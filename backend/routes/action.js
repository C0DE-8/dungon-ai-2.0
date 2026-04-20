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

async function clearCurrentEnemy(conn, playerId) {
  await conn.query(
    `UPDATE player_current_enemy
     SET enemy_current_hp = 0, encounter_state = 'defeated'
     WHERE player_id = ?`,
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
      systemOutcome = `Player attempts: "${actionInput}"`;
    }

    if (!battleResult) {
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

    if (!encounteredEnemy && !encounteredBoss && shouldEncounterEnemy(actionKey)) {
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

    const hoursToAdd = getActionTimeCost(actionKey);

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
      defeatedEnemy
    });

    skillProgression = await evaluateSkillProgression(conn, {
      playerId: player.id,
      playerLevel: progression ? progression.level : player.level,
      changedStats: changedConditionStats
    });

    const skillContext = await getPlayerSkillContext(conn, player.id);

    const context = {
      action: actionInput,
      outcome: systemOutcome,
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
        time_cost_hours: hoursToAdd
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
