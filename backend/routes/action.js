const router = require("express").Router();
const pool = require("../config/db");
const authenticateToken = require("../middleware/authMiddleware");
const { generateNarration } = require("../services/aiEngine");
const {
  getActionTimeCost,
  applyTime,
  getTimeOfDay
} = require("../services/timeEngine");
const {
  markEnemyDiscovered,
  resolveEnemyEncounter,
  setCurrentEnemy,
  getCurrentEnemy,
  shouldEncounterEnemy
} = require("../services/enemyEngine");
const { resolveBattleTurn } = require("../services/battleEngine");
const {
  createRemains,
  deriveSceneTags,
  getActiveOpponent,
  getActiveRemains,
  interpretTextAction,
  interpretTextActionPlan,
  logTextActionInterpretation,
  resolveTextAction
} = require("../services/textActionEngine");
const { applyExpGain } = require("../services/levelEngine");
const {
  evaluateSkillProgression,
  getPlayerSkillContext,
  trackActionBehavior
} = require("../services/skillEngine");
const {
  getCurrentBoss,
  logBossBattle,
  markBossDefeated,
  startBossEncounter,
  updateBossHp,
  clearCurrentBoss
} = require("../services/bossEngine");
const {
  getAreaPool,
  markFloorBossDefeated,
  resolveDungeonProgression
} = require("../services/dungeonEngine");
const { triggerDeathFlow } = require("../services/deathEngine");
const {
  getPendingAscension,
  startFinalAscension
} = require("../services/finalWishEngine");
const { getWorldState } = require("../services/worldEngine");

const ALLOWED_ACTIONS = ["move", "look", "rest", "hide", "appraise", "attack", "defend"];

function normalizeAction(input = "") {
  return String(input).trim().toLowerCase();
}

function getFallbackAreaName(player, label) {
  return `Floor ${Number(player.current_floor) || 1} ${label}`;
}

function getEscapeDestination(player, currentArea, resolutionType) {
  if (resolutionType === "success") {
    if (String(currentArea || "").toLowerCase().includes("sealed")) {
      return getFallbackAreaName(player, "Quiet Seal Alcove");
    }

    if (String(currentArea || "").toLowerCase().includes("dust")) {
      return getFallbackAreaName(player, "Dust-Choked Refuge");
    }

    return getFallbackAreaName(player, "Shadowed Refuge");
  }

  if (resolutionType === "partial_success") {
    return getFallbackAreaName(player, "Temporary Cover");
  }

  return currentArea;
}

async function clearCurrentEnemy(conn, playerId) {
  await conn.query(
    `UPDATE player_current_enemy
     SET enemy_current_hp = 0, encounter_state = 'defeated'
     WHERE player_id = ?`,
    [playerId]
  );
}

async function markEnemyEscaped(conn, playerId) {
  await conn.query(
    `UPDATE player_current_enemy
     SET encounter_state = 'escaped'
     WHERE player_id = ? AND encounter_state = 'active'`,
    [playerId]
  );
}

async function markBossEscaped(conn, playerId) {
  await conn.query(
    `UPDATE player_current_boss
     SET encounter_state = 'escaped'
     WHERE player_id = ? AND encounter_state = 'active'`,
    [playerId]
  );
}

// api/action/
router.post("/", authenticateToken, async (req, res) => {
  const userId = req.user.userId;
  const actionInput = req.body?.action || req.body?.text || "";
  const action = normalizeAction(actionInput);

  if (!action) {
    return res.status(400).json({ message: "Action is required" });
  }

  let conn;

  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const [[player]] = await conn.query(
      `SELECT
        id,
        user_id,
        persona,
        name,
        current_race,
        current_title,
        level,
        exp,
        stat_points,
        hp,
        max_hp,
        strength_stat,
        dexterity_stat,
        stamina_stat,
        intelligence_stat,
        charisma_stat,
        wisdom_stat,
        current_floor,
        current_area,
        life_number,
        is_alive,
        year_survived,
        day_survived,
        current_hour
      FROM players
      WHERE user_id = ?
      LIMIT 1`,
      [userId]
    );

    if (!player) {
      await conn.rollback();
      return res.status(404).json({ message: "Player not found" });
    }

    if (!player.is_alive) {
      await conn.rollback();
      return res.status(400).json({
        message: "Player is dead. Use the rebirth restart flow to begin the next life."
      });
    }

    const pendingAscension = await getPendingAscension(conn, player.id);

    if (pendingAscension) {
      await conn.rollback();
      return res.status(400).json({
        message: "Dungeon completed. State your wish to continue.",
        prompt: "State your wish.",
        ascension: pendingAscension
      });
    }

    const worldState = await getWorldState(conn, player.id);

    if (worldState) {
      await conn.rollback();
      return res.status(400).json({
        message: "Player is in World Mode. Use /api/world/action for post-dungeon actions.",
        mode: "world"
      });
    }

    const [[currentScene]] = await conn.query(
      `SELECT
        id,
        scene_title,
        scene_text,
        scene_type,
        choices_json,
        can_type
      FROM player_current_scene
      WHERE player_id = ?
      LIMIT 1`,
      [player.id]
    );

    if (!currentScene) {
      await conn.rollback();
      return res.status(404).json({ message: "No current scene found. Start the game first." });
    }

    let nextArea = player.current_area;
    let nextHp = player.hp;
    let sceneTitle = "Dungeon Response";
    let sceneType = "action";
    let systemOutcome = "";
    let actionKey = action;
    let encounteredEnemy = await getCurrentEnemy(conn, player.id);
    let encounteredBoss = await getCurrentBoss(conn, player.id);
    let enemyWasNew = false;
    let battleResult = null;
    let progression = null;
    let defeatedEnemy = null;
    let defeatedBoss = null;
    let finalAscension = null;
    let dungeonProgression = { event_key: "none", message: null };
    let textInterpretation = null;
    let textResolution = null;
    let sceneTags = [];
    let suppressDungeonProgression = false;
    let eventFeedback = null;
    let textActionDefeatedPlayer = false;
    let skillProgression = {
      dynamic_skill_keys: [],
      unlocked: []
    };

    if (ALLOWED_ACTIONS.includes(action)) {
      if (action === "move") {
        sceneTitle = "A Careful Advance";
        systemOutcome = "The player moves deeper into the area.";

        const areaPool = getAreaPool(player.current_floor);
        nextArea = areaPool[Math.floor(Math.random() * areaPool.length)];
      }

      if (action === "look") {
        sceneTitle = "Eyes on the Dark";
        systemOutcome = "The player studies the surroundings carefully.";
      }

      if (action === "rest") {
        sceneTitle = "Breathing Space";
        nextHp = Math.min(player.max_hp, player.hp + 5);
        systemOutcome = "The player pauses to recover strength.";
      }

      if (action === "hide") {
        sceneTitle = "Holding Still";
        sceneType = "stealth";
        systemOutcome = "The player hides and lowers presence.";
      }

      if (action === "appraise") {
        sceneTitle = "Measured Observation";
        sceneType = "utility";

        if (encounteredBoss && encounteredBoss.encounter_state === "active") {
          systemOutcome = `The player appraises the active floor boss: ${encounteredBoss.name}.`;
        } else if (encounteredEnemy && encounteredEnemy.encounter_state === "active") {
          systemOutcome = `The player appraises the encountered enemy: ${encounteredEnemy.name}.`;
        } else {
          systemOutcome = "The player appraises the area, but no active enemy is present.";
        }
      }

      if (action === "attack" || action === "defend") {
        if (encounteredBoss && encounteredBoss.encounter_state === "active") {
          sceneType = "boss_battle";
          sceneTitle = action === "attack" ? "Boss Clash" : "Guarding Against the Warden";

          battleResult = resolveBattleTurn({
            player,
            enemy: encounteredBoss,
            playerAction: action
          });

          nextHp = battleResult.playerHpAfter;

          await updateBossHp(conn, player.id, battleResult.enemyHpAfter, battleResult.resultTag);
          await logBossBattle(conn, {
            playerId: player.id,
            bossId: encounteredBoss.boss_id,
            battleResult
          });

          if (battleResult.resultTag === "enemy_defeated") {
            const expReward = Number(encounteredBoss.reward_exp || 0);
            defeatedBoss = encounteredBoss;
            defeatedEnemy = {
              name: encounteredBoss.name,
              enemy_type: "boss"
            };

            progression = applyExpGain(player, expReward);

            await conn.query(
              `UPDATE players
               SET exp = ?, level = ?, stat_points = ?, hp = ?
               WHERE id = ?`,
              [
                progression.exp,
                progression.level,
                progression.stat_points,
                nextHp,
                player.id
              ]
            );

            await markBossDefeated(conn, player, encounteredBoss);
            const bossProgression = await markFloorBossDefeated(conn, player.id, encounteredBoss.floor_number);
            await createRemains(conn, {
              playerId: player.id,
              enemyName: encounteredBoss.name,
              enemyType: "boss",
              sourceType: "boss",
              sourceId: encounteredBoss.boss_id
            });
            await clearCurrentBoss(conn, player.id);

            if (bossProgression.dungeon_completed) {
              finalAscension = await startFinalAscension(conn, player, bossProgression.completed_floor);
              sceneType = "ascension";
              sceneTitle = "Final Ascension";
              systemOutcome = `The player defeats the final boss ${encounteredBoss.name} and clears Floor 100. The dungeon run is complete. State your wish.`;
            } else {
              systemOutcome = progression.levels_gained > 0
                ? `The player defeats the floor boss ${encounteredBoss.name}. The floor seal breaks, ${expReward} EXP is gained, and the player levels up.`
                : `The player defeats the floor boss ${encounteredBoss.name}. The floor seal breaks and ${expReward} EXP is gained.`;
            }
          } else if (battleResult.resultTag === "player_defeated") {
            systemOutcome = `${encounteredBoss.name} kills the player.`;
            await triggerDeathFlow(conn, player, `Killed by boss: ${encounteredBoss.name}`);
            nextHp = 0;
            sceneType = "death";
            sceneTitle = "Death";
          } else if (battleResult.resultTag === "double_ko") {
            defeatedBoss = encounteredBoss;
            defeatedEnemy = {
              name: encounteredBoss.name,
              enemy_type: "boss"
            };

            await markBossDefeated(conn, player, encounteredBoss);
            await markFloorBossDefeated(conn, player.id, encounteredBoss.floor_number);
            await createRemains(conn, {
              playerId: player.id,
              enemyName: encounteredBoss.name,
              enemyType: "boss",
              sourceType: "boss",
              sourceId: encounteredBoss.boss_id
            });
            await clearCurrentBoss(conn, player.id);
            await triggerDeathFlow(conn, player, `Killed while defeating boss: ${encounteredBoss.name}`);

            systemOutcome = `The player and ${encounteredBoss.name} destroy each other. The boss seal breaks, but this life ends.`;
            nextHp = 0;
            sceneType = "death";
            sceneTitle = "Death";
          } else {
            systemOutcome = `The player uses ${action}. ${encounteredBoss.name} answers as a persistent floor boss.`;
          }

          encounteredBoss = await getCurrentBoss(conn, player.id);
        } else if (encounteredEnemy && encounteredEnemy.encounter_state === "active") {
          sceneType = "battle";
          sceneTitle = action === "attack" ? "Steel Meets Flesh" : "A Guarded Breath";

          battleResult = resolveBattleTurn({
            player,
            enemy: encounteredEnemy,
            playerAction: action
          });

          nextHp = battleResult.playerHpAfter;

          await conn.query(
            `UPDATE player_current_enemy
             SET enemy_current_hp = ?, encounter_state = ?
             WHERE player_id = ?`,
            [
              battleResult.enemyHpAfter,
              battleResult.resultTag === "enemy_defeated" ? "defeated" : "active",
              player.id
            ]
          );

          await conn.query(
            `INSERT INTO battle_logs (
              player_id,
              enemy_id,
              player_action,
              enemy_action,
              player_damage_dealt,
              enemy_damage_dealt,
              player_hp_after,
              enemy_hp_after,
              result_tag
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [
              player.id,
              encounteredEnemy.enemy_id,
              battleResult.playerAction,
              battleResult.enemyAction,
              battleResult.playerDamageDealt,
              battleResult.enemyDamageDealt,
              battleResult.playerHpAfter,
              battleResult.enemyHpAfter,
              battleResult.resultTag
            ]
          );

          if (battleResult.resultTag === "enemy_defeated") {
            const expReward = Number(encounteredEnemy.reward_exp || 0);
            defeatedEnemy = encounteredEnemy;

            progression = applyExpGain(player, expReward);

            await conn.query(
              `UPDATE players
               SET exp = ?, level = ?, stat_points = ?, hp = ?
               WHERE id = ?`,
              [
                progression.exp,
                progression.level,
                progression.stat_points,
                nextHp,
                player.id
              ]
            );

            systemOutcome = progression.levels_gained > 0
              ? `The player attacks ${encounteredEnemy.name} and defeats it. The player gains ${expReward} EXP and levels up.`
              : `The player attacks ${encounteredEnemy.name} and defeats it. The player gains ${expReward} EXP.`;

            await createRemains(conn, {
              playerId: player.id,
              enemyName: encounteredEnemy.name,
              enemyType: encounteredEnemy.enemy_type,
              sourceType: "enemy",
              sourceId: encounteredEnemy.enemy_id || encounteredEnemy.id
            });
            await clearCurrentEnemy(conn, player.id);
          } else if (battleResult.resultTag === "player_defeated") {
            systemOutcome = `${encounteredEnemy.name} overpowers the player.`;
            await triggerDeathFlow(conn, player, `Killed by enemy: ${encounteredEnemy.name}`);
            nextHp = 0;
            sceneType = "death";
            sceneTitle = "Death";
          } else if (battleResult.resultTag === "double_ko") {
            systemOutcome = `Both the player and ${encounteredEnemy.name} fall in the same clash.`;
            defeatedEnemy = encounteredEnemy;
            await createRemains(conn, {
              playerId: player.id,
              enemyName: encounteredEnemy.name,
              enemyType: encounteredEnemy.enemy_type,
              sourceType: "enemy",
              sourceId: encounteredEnemy.enemy_id || encounteredEnemy.id
            });
            await clearCurrentEnemy(conn, player.id);
            await triggerDeathFlow(conn, player, `Killed while defeating enemy: ${encounteredEnemy.name}`);
            nextHp = 0;
            sceneType = "death";
            sceneTitle = "Death";
          } else {
            systemOutcome = `The player uses ${action}. ${encounteredEnemy.name} retaliates.`;
          }

          const refreshedEnemy = await getCurrentEnemy(conn, player.id);
          encounteredEnemy = refreshedEnemy;
        } else {
          await conn.rollback();
          return res.status(400).json({ message: `No active enemy or boss to ${action}.` });
        }
      }
    } else {
      actionKey = "typed";
      sceneTitle = "An Unscripted Move";
      sceneType = "typed_action";

      const activeRemains = await getActiveRemains(conn, player.id);
      sceneTags = deriveSceneTags({
        player,
        currentScene,
        activeOpponent: getActiveOpponent(encounteredEnemy, encounteredBoss),
        remains: activeRemains
      });

      await conn.query(
        `INSERT INTO player_scene_environment (player_id, area_name, tags_json)
         VALUES (?, ?, ?)
         ON DUPLICATE KEY UPDATE
           area_name = VALUES(area_name),
           tags_json = VALUES(tags_json)`,
        [player.id, player.current_area, JSON.stringify(sceneTags)]
      );

      const textPlan = interpretTextActionPlan(actionInput, {
        player,
        currentScene,
        enemy: encounteredEnemy,
        boss: encounteredBoss,
        sceneTags
      });

      if (textPlan.is_sequence) {
        textInterpretation = textPlan;
        suppressDungeonProgression = true;

        const stepResolutions = [];
        const outcomeParts = [];
        let totalTimeCostHours = 0;
        let sequenceStopped = false;
        let workingPlayer = {
          ...player,
          hp: nextHp,
          current_floor: player.current_floor,
          current_area: nextArea
        };

        for (const step of textPlan.steps) {
          if (sequenceStopped) break;

          const stepResolution = await resolveTextAction(conn, {
            player: workingPlayer,
            input: step.input,
            interpretation: step,
            enemy: encounteredEnemy,
            boss: encounteredBoss,
            sceneTags,
            remains: activeRemains
          });

          stepResolutions.push({
            order: step.order,
            input: step.input,
            resolved_intent: stepResolution.resolved_intent,
            resolution_type: stepResolution.resolution_type,
            effect_applied: stepResolution.effect_applied,
            cost: stepResolution.cost
          });

          totalTimeCostHours += Number(stepResolution.cost?.timeCostHours || 0);
          nextHp = stepResolution.playerHpAfter ?? nextHp;
          workingPlayer = {
            ...workingPlayer,
            hp: nextHp,
            current_floor: player.current_floor,
            current_area: nextArea
          };
          outcomeParts.push(stepResolution.narrationOutcome);

          if (step.intent === "escape") {
            const escapeEffect = stepResolution.effect_applied;

            if (escapeEffect?.moved) {
              nextArea = getEscapeDestination(player, nextArea, stepResolution.resolution_type);
              workingPlayer.current_area = nextArea;
              escapeEffect.destination = nextArea;
              stepResolutions[stepResolutions.length - 1].effect_applied.destination = nextArea;
            }

            if (escapeEffect?.escaped) {
              if (encounteredBoss && encounteredBoss.encounter_state === "active") {
                await markBossEscaped(conn, player.id);
                encounteredBoss = null;
              }

              if (encounteredEnemy && encounteredEnemy.encounter_state === "active") {
                await markEnemyEscaped(conn, player.id);
                encounteredEnemy = null;
              }
            }

            sceneTitle = escapeEffect?.escaped
              ? "Escape Into Safer Ground"
              : escapeEffect?.reached_temporary_safety
                ? "A Desperate Withdrawal"
                : "Escape Denied";
            sceneType = escapeEffect?.escaped
              ? "escape"
              : escapeEffect?.reached_temporary_safety
                ? "evasion"
                : "danger";
            outcomeParts.push(`The escape attempt ends at ${nextArea}. Safety state: ${escapeEffect?.safety_state || "unknown"}.`);

            if (stepResolution.playerHpAfter <= 0) {
              textActionDefeatedPlayer = true;
              await triggerDeathFlow(conn, player, "Killed while trying to escape");
              nextHp = 0;
              sceneType = "death";
              sceneTitle = "Death";
            }

            sequenceStopped = true;
            continue;
          }

          if (stepResolution.resolution_type === "invalid_attempt") {
            sequenceStopped = true;
            sceneTitle = "Interrupted Plan";
            sceneType = "invalid_action";
            outcomeParts.push("The sequence stops because that step cannot be executed.");
            continue;
          }

          if (stepResolution.battleResult) {
            battleResult = stepResolution.battleResult;
            sequenceStopped = true;
            continue;
          }

          if (step.intent === "move_toward_objective") {
            const areaPool = getAreaPool(player.current_floor);
            nextArea = areaPool[Math.floor(Math.random() * areaPool.length)];
            workingPlayer.current_area = nextArea;
            sceneTitle = step.objective === "boss_room" ? "Toward the Boss Seal" : "A Purposeful Advance";
            sceneType = "progression";
            outcomeParts.push(`The player advances into ${nextArea}.`);
          }

          const progressionActionKey = ["map_area", "scout_area"].includes(step.intent)
            ? "look"
            : step.intent === "move_toward_objective"
              ? "move"
              : null;

          if (progressionActionKey && !encounteredEnemy && !encounteredBoss) {
            dungeonProgression = await resolveDungeonProgression(conn, {
              player: workingPlayer,
              actionKey: progressionActionKey,
              hasActiveEnemy: false,
              hasActiveBoss: false
            });

            if (dungeonProgression.next_floor) {
              player.current_floor = dungeonProgression.next_floor;
              workingPlayer.current_floor = dungeonProgression.next_floor;
              nextArea = dungeonProgression.next_area || nextArea;
              workingPlayer.current_area = nextArea;
              sceneType = "progression";
              sceneTitle = "A Hidden Route Opens";
            }

            if (dungeonProgression.message) {
              outcomeParts.push(dungeonProgression.message);
            }

            if (dungeonProgression.trigger_boss) {
              encounteredBoss = await startBossEncounter(conn, player.id, player.current_floor, {
                triggerKey: dungeonProgression.boss_trigger_key
              });
              encounteredEnemy = null;
              sceneType = "boss_encounter";
              sceneTitle = "The Floor Guardian Appears";
              outcomeParts.push("The plan stops as the floor guardian answers the route.");
              sequenceStopped = true;
              continue;
            }
          }

          if (!encounteredEnemy && !encounteredBoss && progressionActionKey && shouldEncounterEnemy(progressionActionKey)) {
            const roll = Math.random();

            if (roll < 0.45) {
              const generated = await resolveEnemyEncounter(conn, {
                playerId: player.id,
                floor: player.current_floor,
                area: nextArea,
                progressionTrigger: dungeonProgression.event_key,
                encounterState: "active"
              });

              encounteredEnemy = generated.enemy;
              enemyWasNew = generated.isNew;

              await markEnemyDiscovered(conn, player.id, encounteredEnemy.enemy_id || encounteredEnemy.id);
              await setCurrentEnemy(conn, player.id, encounteredEnemy);

              sceneType = "encounter";
              sceneTitle = enemyWasNew
                ? "A New Presence Emerges"
                : "A Familiar Threat Returns";

              outcomeParts.push(enemyWasNew
                ? `A new enemy appears for the first time: ${encounteredEnemy.name}.`
                : `An enemy appears: ${encounteredEnemy.name}.`);
              sequenceStopped = true;
            }
          }
        }

        const terminalStep = stepResolutions[stepResolutions.length - 1];

        textResolution = {
          input: actionInput,
          normalized: "typed",
          resolved_intent: "sequence",
          resolution_type: battleResult
            ? battleResult.resultTag
            : stepResolutions.some((step) => step.resolution_type === "invalid_attempt")
              ? "partial_sequence"
              : terminalStep?.resolution_type || "success",
          effect_applied: {
            type: "sequence",
            steps: stepResolutions,
            stopped_early: sequenceStopped,
            final_area: nextArea,
            final_floor: player.current_floor
          },
          battleResult,
          playerHpAfter: nextHp,
          enemyHpAfter: battleResult?.enemyHpAfter ?? null,
          cost: {
            timeCostHours: Math.max(1, totalTimeCostHours),
            hpRiskCost: stepResolutions.reduce((sum, step) => sum + Number(step.cost?.hpRiskCost || 0), 0)
          },
          narrationOutcome: outcomeParts.filter(Boolean).join(" ")
        };
      } else {
        textInterpretation = textPlan.steps[0] || interpretTextAction(actionInput, {
          player,
          currentScene,
          enemy: encounteredEnemy,
          boss: encounteredBoss,
          sceneTags
        });

        textResolution = await resolveTextAction(conn, {
          player,
          input: actionInput,
          interpretation: textInterpretation,
          enemy: encounteredEnemy,
          boss: encounteredBoss,
          sceneTags,
          remains: activeRemains
        });

        if (textInterpretation.action_key) {
          actionKey = textInterpretation.action_key;
        }

        if (textInterpretation.intent === "move_toward_objective") {
          const areaPool = getAreaPool(player.current_floor);
          nextArea = areaPool[Math.floor(Math.random() * areaPool.length)];
          sceneTitle = textInterpretation.objective === "boss_room" ? "Toward the Boss Seal" : "A Purposeful Advance";
          sceneType = "progression";
          textResolution.narrationOutcome = `${textResolution.narrationOutcome} The player advances into ${nextArea}.`;
        } else if (textInterpretation.intent === "escape") {
          const escapeEffect = textResolution.effect_applied;

          if (escapeEffect?.moved) {
            nextArea = getEscapeDestination(player, nextArea, textResolution.resolution_type);
            escapeEffect.destination = nextArea;
            textResolution.narrationOutcome = `${textResolution.narrationOutcome} The escape attempt ends at ${nextArea}.`;
          }

          if (escapeEffect?.escaped) {
            if (encounteredBoss && encounteredBoss.encounter_state === "active") {
              await markBossEscaped(conn, player.id);
              encounteredBoss = null;
            }

            if (encounteredEnemy && encounteredEnemy.encounter_state === "active") {
              await markEnemyEscaped(conn, player.id);
              encounteredEnemy = null;
            }
          }

          sceneTitle = escapeEffect?.escaped
            ? "Escape Into Safer Ground"
            : escapeEffect?.reached_temporary_safety
              ? "A Desperate Withdrawal"
              : "Escape Denied";
          sceneType = escapeEffect?.escaped
            ? "escape"
            : escapeEffect?.reached_temporary_safety
              ? "evasion"
              : "danger";
          suppressDungeonProgression = true;

          if (textResolution.playerHpAfter <= 0) {
            textActionDefeatedPlayer = true;
            await triggerDeathFlow(conn, player, "Killed while trying to escape");
            nextHp = 0;
            sceneType = "death";
            sceneTitle = "Death";
          }
        }
      }

      await logTextActionInterpretation(conn, {
        playerId: player.id,
        actionText: actionInput,
        interpretation: textInterpretation,
        resolution: textResolution
      });

      suppressDungeonProgression = textPlan.is_sequence
        || textResolution.resolution_type === "invalid_attempt"
        || ["rest", "escape", "plan_next_move", "sequence"].includes(textResolution.resolved_intent);
      battleResult = textResolution.battleResult;
      nextHp = textResolution.playerHpAfter ?? nextHp;
      systemOutcome = textResolution.narrationOutcome;

      if (textResolution.resolution_type === "invalid_attempt") {
        sceneTitle = "Impossible Attempt";
        sceneType = "invalid_action";
      }

      if (battleResult && encounteredBoss && encounteredBoss.encounter_state === "active") {
        sceneType = "boss_battle";
        sceneTitle = "Improvised Boss Clash";

        await updateBossHp(conn, player.id, battleResult.enemyHpAfter, battleResult.resultTag);
        await logBossBattle(conn, {
          playerId: player.id,
          bossId: encounteredBoss.boss_id,
          battleResult
        });

        if (battleResult.resultTag === "enemy_defeated") {
          const expReward = Number(encounteredBoss.reward_exp || 0);
          defeatedBoss = encounteredBoss;
          defeatedEnemy = {
            name: encounteredBoss.name,
            enemy_type: "boss"
          };

          progression = applyExpGain(player, expReward);

          await conn.query(
            `UPDATE players
             SET exp = ?, level = ?, stat_points = ?, hp = ?
             WHERE id = ?`,
            [
              progression.exp,
              progression.level,
              progression.stat_points,
              nextHp,
              player.id
            ]
          );

          await markBossDefeated(conn, player, encounteredBoss);
          const bossProgression = await markFloorBossDefeated(conn, player.id, encounteredBoss.floor_number);
          await createRemains(conn, {
            playerId: player.id,
            enemyName: encounteredBoss.name,
            enemyType: "boss",
            sourceType: "boss",
            sourceId: encounteredBoss.boss_id
          });
          await clearCurrentBoss(conn, player.id);

          if (bossProgression.dungeon_completed) {
            finalAscension = await startFinalAscension(conn, player, bossProgression.completed_floor);
            sceneType = "ascension";
            sceneTitle = "Final Ascension";
            systemOutcome = `${systemOutcome} The improvised action defeats the final boss ${encounteredBoss.name}. Floor 100 is clear. State your wish.`;
          } else {
            systemOutcome = progression.levels_gained > 0
              ? `${systemOutcome} ${encounteredBoss.name} falls. The floor seal breaks, ${expReward} EXP is gained, and the player levels up.`
              : `${systemOutcome} ${encounteredBoss.name} falls. The floor seal breaks and ${expReward} EXP is gained.`;
          }
        } else if (battleResult.resultTag === "player_defeated") {
          systemOutcome = `${systemOutcome} ${encounteredBoss.name} kills the player.`;
          await triggerDeathFlow(conn, player, `Killed by boss during typed action: ${encounteredBoss.name}`);
          nextHp = 0;
          sceneType = "death";
          sceneTitle = "Death";
        } else if (battleResult.resultTag === "double_ko") {
          defeatedBoss = encounteredBoss;
          defeatedEnemy = {
            name: encounteredBoss.name,
            enemy_type: "boss"
          };

          await markBossDefeated(conn, player, encounteredBoss);
          await markFloorBossDefeated(conn, player.id, encounteredBoss.floor_number);
          await createRemains(conn, {
            playerId: player.id,
            enemyName: encounteredBoss.name,
            enemyType: "boss",
            sourceType: "boss",
            sourceId: encounteredBoss.boss_id
          });
          await clearCurrentBoss(conn, player.id);
          await triggerDeathFlow(conn, player, `Killed while defeating boss with typed action: ${encounteredBoss.name}`);

          systemOutcome = `${systemOutcome} The player and ${encounteredBoss.name} destroy each other.`;
          nextHp = 0;
          sceneType = "death";
          sceneTitle = "Death";
        }

        encounteredBoss = await getCurrentBoss(conn, player.id);
      } else if (battleResult && encounteredEnemy && encounteredEnemy.encounter_state === "active") {
        sceneType = "battle";
        sceneTitle = "Improvised Clash";

        await conn.query(
          `UPDATE player_current_enemy
           SET enemy_current_hp = ?, encounter_state = ?
           WHERE player_id = ?`,
          [
            battleResult.enemyHpAfter,
            battleResult.resultTag === "enemy_defeated" || battleResult.resultTag === "double_ko" ? "defeated" : "active",
            player.id
          ]
        );

        await conn.query(
          `INSERT INTO battle_logs (
            player_id,
            enemy_id,
            player_action,
            enemy_action,
            player_damage_dealt,
            enemy_damage_dealt,
            player_hp_after,
            enemy_hp_after,
            result_tag
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
          [
            player.id,
            encounteredEnemy.enemy_id,
            battleResult.playerAction,
            battleResult.enemyAction,
            battleResult.playerDamageDealt,
            battleResult.enemyDamageDealt,
            battleResult.playerHpAfter,
            battleResult.enemyHpAfter,
            battleResult.resultTag
          ]
        );

        if (battleResult.resultTag === "enemy_defeated") {
          const expReward = Number(encounteredEnemy.reward_exp || 0);
          defeatedEnemy = encounteredEnemy;

          progression = applyExpGain(player, expReward);

          await conn.query(
            `UPDATE players
             SET exp = ?, level = ?, stat_points = ?, hp = ?
             WHERE id = ?`,
            [
              progression.exp,
              progression.level,
              progression.stat_points,
              nextHp,
              player.id
            ]
          );

          systemOutcome = progression.levels_gained > 0
            ? `${systemOutcome} ${encounteredEnemy.name} is defeated. The player gains ${expReward} EXP and levels up.`
            : `${systemOutcome} ${encounteredEnemy.name} is defeated. The player gains ${expReward} EXP.`;

          await createRemains(conn, {
            playerId: player.id,
            enemyName: encounteredEnemy.name,
            enemyType: encounteredEnemy.enemy_type,
            sourceType: "enemy",
            sourceId: encounteredEnemy.enemy_id || encounteredEnemy.id
          });
          await clearCurrentEnemy(conn, player.id);
        } else if (battleResult.resultTag === "player_defeated") {
          systemOutcome = `${systemOutcome} ${encounteredEnemy.name} overpowers the player.`;
          await triggerDeathFlow(conn, player, `Killed by enemy during typed action: ${encounteredEnemy.name}`);
          nextHp = 0;
          sceneType = "death";
          sceneTitle = "Death";
        } else if (battleResult.resultTag === "double_ko") {
          systemOutcome = `${systemOutcome} Both the player and ${encounteredEnemy.name} fall.`;
          defeatedEnemy = encounteredEnemy;
          await createRemains(conn, {
            playerId: player.id,
            enemyName: encounteredEnemy.name,
            enemyType: encounteredEnemy.enemy_type,
            sourceType: "enemy",
            sourceId: encounteredEnemy.enemy_id || encounteredEnemy.id
          });
          await clearCurrentEnemy(conn, player.id);
          await triggerDeathFlow(conn, player, `Killed while defeating enemy with typed action: ${encounteredEnemy.name}`);
          nextHp = 0;
          sceneType = "death";
          sceneTitle = "Death";
        }

        const refreshedEnemy = await getCurrentEnemy(conn, player.id);
        encounteredEnemy = refreshedEnemy;
      }
    }

    if (!battleResult && !suppressDungeonProgression) {
      dungeonProgression = await resolveDungeonProgression(conn, {
        player,
        actionKey,
        hasActiveEnemy: !!encounteredEnemy,
        hasActiveBoss: !!encounteredBoss
      });

      if (dungeonProgression.next_floor) {
        player.current_floor = dungeonProgression.next_floor;
        nextArea = dungeonProgression.next_area || nextArea;
        sceneType = "progression";
        sceneTitle = "A Hidden Route Opens";
      }

      if (dungeonProgression.message) {
        systemOutcome = `${systemOutcome} ${dungeonProgression.message}`.trim();
      }

      if (dungeonProgression.trigger_boss) {
        encounteredBoss = await startBossEncounter(conn, player.id, player.current_floor, {
          triggerKey: dungeonProgression.boss_trigger_key
        });
        encounteredEnemy = null;
        sceneType = "boss_encounter";
        sceneTitle = "The Floor Guardian Appears";
      }
    }

    if (!encounteredEnemy && !encounteredBoss && !suppressDungeonProgression && shouldEncounterEnemy(actionKey)) {
      const roll = Math.random();

      if (roll < 0.45) {
        const generated = await resolveEnemyEncounter(conn, {
          playerId: player.id,
          floor: player.current_floor,
          area: nextArea,
          progressionTrigger: dungeonProgression.event_key,
          encounterState: "active"
        });

        encounteredEnemy = generated.enemy;
        enemyWasNew = generated.isNew;

        await markEnemyDiscovered(conn, player.id, encounteredEnemy.enemy_id || encounteredEnemy.id);
        await setCurrentEnemy(conn, player.id, encounteredEnemy);

        sceneType = "encounter";
        sceneTitle = enemyWasNew
          ? "A New Presence Emerges"
          : "A Familiar Threat Returns";

        systemOutcome = enemyWasNew
          ? `A new enemy appears for the first time: ${encounteredEnemy.name}. Its stats are now recorded in the world.`
          : `An enemy appears: ${encounteredEnemy.name}. This enemy has been seen before.`;
      }
    }

    const hoursToAdd = textResolution?.cost?.timeCostHours ?? getActionTimeCost(actionKey);

    const nextTime = applyTime({
      year: player.year_survived,
      day: player.day_survived,
      hour: player.current_hour,
      hoursToAdd
    });

    const timeOfDay = getTimeOfDay(nextTime.hour);

    if (!progression && !(battleResult?.resultTag === "player_defeated" || battleResult?.resultTag === "double_ko")) {
      await conn.query(
        `UPDATE players
         SET hp = ?, current_floor = ?, current_area = ?, current_hour = ?, day_survived = ?, year_survived = ?
         WHERE id = ?`,
        [nextHp, player.current_floor, nextArea, nextTime.hour, nextTime.day, nextTime.year, player.id]
      );
    } else {
      await conn.query(
        `UPDATE players
         SET hp = ?, current_floor = ?, current_area = ?, current_hour = ?, day_survived = ?, year_survived = ?
         WHERE id = ?`,
        [nextHp, player.current_floor, nextArea, nextTime.hour, nextTime.day, nextTime.year, player.id]
      );
    }

    await conn.query(
      `INSERT INTO player_action_logs (player_id, action_key, action_text)
       VALUES (?, ?, ?)`,
      [player.id, actionKey, actionInput]
    );

    const changedConditionStats = await trackActionBehavior(conn, {
      playerId: player.id,
      actionKey,
      actionInput,
      defeatedEnemy,
      textResolution,
      textInterpretation
    });

    skillProgression = await evaluateSkillProgression(conn, {
      playerId: player.id,
      playerLevel: progression ? progression.level : player.level,
      changedStats: changedConditionStats
    });

    const skillContext = await getPlayerSkillContext(conn, player.id);
    const escapeEffect = textResolution?.effect_applied?.type === "escape"
      ? textResolution.effect_applied
      : textResolution?.effect_applied?.steps?.find((step) => step.effect_applied?.type === "escape")?.effect_applied || null;

    eventFeedback = {
      location: {
        before: player.current_area,
        after: nextArea,
        floor: player.current_floor,
        time_of_day: timeOfDay,
        scene_tags: sceneTags
      },
      action: {
        input: actionInput,
        normalized: actionKey,
        resolved_intent: textResolution?.resolved_intent || actionKey,
        resolution_type: textResolution?.resolution_type || (battleResult ? battleResult.resultTag : "success")
      },
      consequences: {
        hp_before: player.hp,
        hp_after: nextHp,
        hp_delta: Number(nextHp || 0) - Number(player.hp || 0),
        safety_state: escapeEffect?.safety_state || null,
        moved: player.current_area !== nextArea,
        enemy_state: encounteredEnemy
          ? "active"
          : escapeEffect?.escaped && escapeEffect?.enemy_pressure?.type === "enemy"
            ? "escaped"
            : null,
        boss_state: encounteredBoss
          ? "active"
          : escapeEffect?.escaped && escapeEffect?.enemy_pressure?.type === "boss"
            ? "escaped"
            : null,
        world_change: dungeonProgression.event_key || "none"
      }
    };

    const context = {
      action: actionInput,
      outcome: systemOutcome,
      event_feedback: eventFeedback,
      environment: {
        area: nextArea,
        time_of_day: timeOfDay
      },
      player: {
        hp: nextHp,
        max_hp: player.max_hp,
        level: progression ? progression.level : player.level,
        exp: progression ? progression.exp : player.exp,
        stat_points: progression ? progression.stat_points : player.stat_points,
        is_alive:
          textActionDefeatedPlayer ||
          battleResult?.resultTag === "player_defeated" ||
          battleResult?.resultTag === "double_ko"
            ? 0
            : 1,
        stats: {
          strength: player.strength_stat,
          dexterity: player.dexterity_stat,
          stamina: player.stamina_stat,
          intelligence: player.intelligence_stat,
          charisma: player.charisma_stat,
          wisdom: player.wisdom_stat
        }
      },
      skills: {
        active: skillContext.active,
        passive: skillContext.passive,
        newly_unlocked: skillProgression.unlocked,
        dynamic_created: skillProgression.dynamic_skill_keys
      },
      dungeon_progression: dungeonProgression,
      text_action: textResolution
        ? {
            input: textResolution.input,
            normalized: textResolution.normalized,
            resolved_intent: textResolution.resolved_intent,
            resolution_type: textResolution.resolution_type,
            effect_applied: textResolution.effect_applied,
            interpretation: textInterpretation,
            scene_tags: sceneTags,
            cost: textResolution.cost
          }
        : null,
      final_ascension: finalAscension
        ? {
            prompt: "State your wish.",
            status: finalAscension.status,
            floor_reached: finalAscension.floor_reached
          }
        : null,
      world: {
        year: nextTime.year,
        day: nextTime.day,
        hour: nextTime.hour,
        floor: player.current_floor,
        time_of_day: timeOfDay
      },
      enemy: encounteredEnemy
        ? {
            id: encounteredEnemy.enemy_id || encounteredEnemy.id,
            name: encounteredEnemy.name,
            type: encounteredEnemy.enemy_type,
            level: encounteredEnemy.level,
            hp: encounteredEnemy.enemy_current_hp || encounteredEnemy.hp,
            max_hp: encounteredEnemy.max_hp,
            attack: encounteredEnemy.attack_stat,
            defense: encounteredEnemy.defense_stat,
            speed: encounteredEnemy.speed_stat,
            intelligence: encounteredEnemy.intelligence_stat,
            description: encounteredEnemy.description,
            first_time_seen: enemyWasNew
          }
        : null,
      boss: encounteredBoss
        ? {
            id: encounteredBoss.boss_id,
            name: encounteredBoss.name,
            type: encounteredBoss.boss_type,
            floor: encounteredBoss.floor_number,
            level: encounteredBoss.level,
            hp: encounteredBoss.boss_current_hp,
            max_hp: encounteredBoss.max_hp,
            attack: encounteredBoss.attack_stat,
            defense: encounteredBoss.defense_stat,
            speed: encounteredBoss.speed_stat,
            intelligence: encounteredBoss.intelligence_stat,
            description: encounteredBoss.description,
            skills: encounteredBoss.skills
          }
        : null,
      battle: battleResult
        ? {
            player_action: battleResult.playerAction,
            enemy_action: battleResult.enemyAction,
            player_damage_dealt: battleResult.playerDamageDealt,
            enemy_damage_dealt: battleResult.enemyDamageDealt,
            player_hp_after: battleResult.playerHpAfter,
            enemy_hp_after: battleResult.enemyHpAfter,
            result_tag: battleResult.resultTag
          }
        : null,
      progression: progression
        ? {
            level: progression.level,
            exp: progression.exp,
            stat_points: progression.stat_points,
            levels_gained: progression.levels_gained,
            stat_points_gained: progression.stat_points_gained
          }
        : null,
      boss_defeated: defeatedBoss
        ? {
            id: defeatedBoss.boss_id,
            name: defeatedBoss.name,
            floor: defeatedBoss.floor_number
          }
        : null,
      condition_stats_changed: changedConditionStats.map((stat) => ({
        stat_key: stat.stat_key,
        stat_value: stat.stat_value
      }))
    };

    const aiResult = await generateNarration({
      context,
      persona: player.persona
    });

    const narration = aiResult.narration;
    const choices = aiResult.choices;

    await conn.query(
      `UPDATE player_current_scene
       SET scene_title = ?, scene_text = ?, scene_type = ?, choices_json = ?, can_type = ?
       WHERE player_id = ?`,
      [
        sceneTitle,
        narration,
        sceneType,
        JSON.stringify(choices),
        1,
        player.id
      ]
    );

    await conn.query(
      `INSERT INTO player_scene_history (
        player_id,
        scene_title,
        scene_text,
        scene_type
      ) VALUES (?, ?, ?, ?)`,
      [player.id, sceneTitle, narration, sceneType]
    );

    await conn.commit();

    return res.json({
      message: "Action resolved successfully",
      action: {
        input: actionInput,
        normalized: actionKey,
        time_cost_hours: hoursToAdd,
        resolved_intent: textResolution?.resolved_intent || actionKey,
        resolution_type: textResolution?.resolution_type || (battleResult ? battleResult.resultTag : "success"),
        effect_applied: textResolution?.effect_applied || null
      },
      scene: {
        title: sceneTitle,
        text: narration,
        type: sceneType,
        choices,
        can_type: true
      },
      player: {
        hp: nextHp,
        max_hp: player.max_hp,
        level: progression ? progression.level : player.level,
        exp: progression ? progression.exp : player.exp,
        stat_points: progression ? progression.stat_points : player.stat_points,
        is_alive:
          textActionDefeatedPlayer ||
          battleResult?.resultTag === "player_defeated" ||
          battleResult?.resultTag === "double_ko"
            ? 0
            : 1
      },
      world: {
        year: nextTime.year,
        day: nextTime.day,
        hour: nextTime.hour,
        time_of_day: timeOfDay,
        floor: player.current_floor,
        area: nextArea
      },
      event_feedback: eventFeedback,
      enemy: encounteredEnemy
        ? {
            id: encounteredEnemy.enemy_id || encounteredEnemy.id,
            name: encounteredEnemy.name,
            type: encounteredEnemy.enemy_type,
            level: encounteredEnemy.level,
            hp: encounteredEnemy.enemy_current_hp || encounteredEnemy.hp,
            max_hp: encounteredEnemy.max_hp,
            description: encounteredEnemy.description,
            is_new: enemyWasNew
          }
        : null,
      boss: encounteredBoss
        ? {
            id: encounteredBoss.boss_id,
            name: encounteredBoss.name,
            type: encounteredBoss.boss_type,
            floor: encounteredBoss.floor_number,
            level: encounteredBoss.level,
            hp: encounteredBoss.boss_current_hp,
            max_hp: encounteredBoss.max_hp,
            description: encounteredBoss.description,
            skills: encounteredBoss.skills
          }
        : null,
      battle: battleResult || null,
      progression: progression || null,
      dungeon_progression: dungeonProgression,
      text_action: textResolution
        ? {
            input: textResolution.input,
            normalized: textResolution.normalized,
            resolved_intent: textResolution.resolved_intent,
            resolution_type: textResolution.resolution_type,
            effect_applied: textResolution.effect_applied,
            interpretation: textInterpretation,
            scene_tags: sceneTags,
            cost: textResolution.cost
          }
        : null,
      final_ascension: finalAscension
        ? {
            prompt: "State your wish.",
            status: finalAscension.status,
            floor_reached: finalAscension.floor_reached
          }
        : null,
      skills: {
        unlocked: skillProgression.unlocked,
        active: skillContext.active,
        passive: skillContext.passive,
        dynamic_created: skillProgression.dynamic_skill_keys
      }
    });
  } catch (error) {
    if (conn) await conn.rollback();
    console.error("action route error:", error);
    return res.status(500).json({ message: "Failed to resolve action" });
  } finally {
    if (conn) conn.release();
  }
});

module.exports = router;
