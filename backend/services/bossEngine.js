function parseJson(value, fallback = []) {
  if (!value) return fallback;
  if (typeof value === "object") return value;

  try {
    return JSON.parse(value);
  } catch (err) {
    return fallback;
  }
}

function normalizeKeySegment(value = "") {
  const segment = String(value)
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9\s-]/g, "")
    .replace(/\s+/g, "_")
    .replace(/_+/g, "_")
    .replace(/^_|_$/g, "");

  return segment || "unknown";
}

function getGeneratedBossTemplate(floor = 1, triggerKey = null) {
  const level = Math.max(2, Number(floor) + 1);
  const normalizedTriggerKey = triggerKey || `floor_${floor}_hidden_seal`;
  const bossKeyTrigger = normalizeKeySegment(normalizedTriggerKey).slice(0, 80);

  return {
    boss_key: `floor_${floor}_warden_${bossKeyTrigger}`,
    name: `Warden of Floor ${floor}`,
    boss_type: "dungeon",
    floor_number: floor,
    level,
    hp: 38 + (floor * 8),
    max_hp: 38 + (floor * 8),
    attack_stat: 5 + floor,
    defense_stat: 3 + Math.floor(floor / 2),
    speed_stat: 2 + Math.floor(floor / 3),
    intelligence_stat: 2 + Math.floor(floor / 2),
    reward_exp: 28 + (floor * 8),
    description: `A floor ${floor} guardian bound to the hidden dungeon route.`,
    trigger_key: normalizedTriggerKey,
    is_final: 0
  };
}

async function getBossSkills(conn, bossId) {
  const [skills] = await conn.query(
    `SELECT skill_key, name, effect_json
     FROM boss_skills
     WHERE boss_id = ?
     ORDER BY id ASC`,
    [bossId]
  );

  return skills.map((skill) => ({
    skill_key: skill.skill_key,
    name: skill.name,
    effect: parseJson(skill.effect_json, {})
  }));
}

async function findActiveBossForContext(conn, { playerId, floor, triggerKey = null, encounterState = "active" }) {
  const params = [playerId, encounterState, floor];
  const triggerFilter = triggerKey ? "AND b.trigger_key = ?" : "";

  if (triggerKey) params.push(triggerKey);

  const [[boss]] = await conn.query(
    `SELECT
      pcb.id,
      pcb.boss_id,
      pcb.boss_current_hp,
      pcb.boss_current_hp AS enemy_current_hp,
      pcb.encounter_state,
      pcb.trigger_revealed_at,
      b.name,
      b.boss_type,
      b.boss_type AS enemy_type,
      b.floor_number,
      b.level,
      b.hp,
      b.max_hp,
      b.attack_stat,
      b.defense_stat,
      b.speed_stat,
      b.intelligence_stat,
      b.reward_exp,
      b.description,
      b.trigger_key,
      b.is_final
     FROM player_current_boss pcb
     INNER JOIN bosses b ON pcb.boss_id = b.id
     WHERE pcb.player_id = ?
       AND pcb.encounter_state = ?
       AND b.floor_number = ?
       ${triggerFilter}
     LIMIT 1`,
    params
  );

  if (!boss) return null;

  return {
    ...boss,
    skills: await getBossSkills(conn, boss.boss_id)
  };
}

async function findBossForTrigger(conn, { floor = 1, triggerKey = null }) {
  const params = [floor];
  const triggerFilter = triggerKey ? "AND trigger_key = ?" : "";

  if (triggerKey) params.push(triggerKey);

  const [[existing]] = await conn.query(
    `SELECT *
     FROM bosses
     WHERE floor_number = ?
       ${triggerFilter}
     ORDER BY id ASC
     LIMIT 1`,
    params
  );

  return existing || null;
}

async function ensureBossForFloor(conn, floor = 1, triggerKey = null) {
  const existing = await findBossForTrigger(conn, { floor, triggerKey });

  if (existing) return { boss: existing, isNew: false, source: "catalog" };

  const template = getGeneratedBossTemplate(floor, triggerKey);

  const [result] = await conn.query(
    `INSERT INTO bosses (
      boss_key,
      name,
      boss_type,
      floor_number,
      level,
      hp,
      max_hp,
      attack_stat,
      defense_stat,
      speed_stat,
      intelligence_stat,
      reward_exp,
      description,
      trigger_key,
      is_final
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      template.boss_key,
      template.name,
      template.boss_type,
      template.floor_number,
      template.level,
      template.hp,
      template.max_hp,
      template.attack_stat,
      template.defense_stat,
      template.speed_stat,
      template.intelligence_stat,
      template.reward_exp,
      template.description,
      template.trigger_key,
      template.is_final
    ]
  );

  await conn.query(
    `INSERT INTO boss_skills (boss_id, skill_key, name, effect_json)
     VALUES (?, ?, ?, ?)`,
    [
      result.insertId,
      "warden_focus",
      "Warden Focus",
      JSON.stringify({ attack_bonus_when_wounded: 1 })
    ]
  );

  const [[boss]] = await conn.query(
    `SELECT * FROM bosses WHERE id = ? LIMIT 1`,
    [result.insertId]
  );

  return { boss, isNew: true, source: "generated" };
}

async function getCurrentBoss(conn, playerId) {
  const [[boss]] = await conn.query(
    `SELECT
      pcb.id,
      pcb.boss_id,
      pcb.boss_current_hp,
      pcb.boss_current_hp AS enemy_current_hp,
      pcb.encounter_state,
      pcb.trigger_revealed_at,
      b.name,
      b.boss_type,
      b.boss_type AS enemy_type,
      b.floor_number,
      b.level,
      b.hp,
      b.max_hp,
      b.attack_stat,
      b.defense_stat,
      b.speed_stat,
      b.intelligence_stat,
      b.reward_exp,
      b.description,
      b.trigger_key,
      b.is_final
     FROM player_current_boss pcb
     INNER JOIN bosses b ON pcb.boss_id = b.id
     WHERE pcb.player_id = ?
       AND pcb.encounter_state = 'active'
     LIMIT 1`,
    [playerId]
  );

  if (!boss) return null;

  return {
    ...boss,
    skills: await getBossSkills(conn, boss.boss_id)
  };
}

async function startBossEncounter(conn, playerId, floor, options = {}) {
  const triggerKey = options.triggerKey || `floor_${floor}_hidden_seal`;
  const activeBoss = await findActiveBossForContext(conn, {
    playerId,
    floor,
    triggerKey,
    encounterState: "active"
  });

  if (activeBoss) {
    return {
      ...activeBoss,
      is_new: false,
      source: "active_encounter"
    };
  }

  const ensured = await ensureBossForFloor(conn, floor, triggerKey);
  const boss = ensured.boss;

  await conn.query(
    `INSERT INTO player_current_boss (
      player_id,
      boss_id,
      boss_current_hp,
      encounter_state,
      trigger_revealed_at
    ) VALUES (?, ?, ?, 'active', CURRENT_TIMESTAMP)
    ON DUPLICATE KEY UPDATE
      boss_id = VALUES(boss_id),
      boss_current_hp = IF(encounter_state = 'active', boss_current_hp, VALUES(boss_current_hp)),
      encounter_state = 'active',
      trigger_revealed_at = COALESCE(trigger_revealed_at, CURRENT_TIMESTAMP)`,
    [playerId, boss.id, boss.hp]
  );

  const currentBoss = await getCurrentBoss(conn, playerId);

  return {
    ...currentBoss,
    is_new: ensured.isNew,
    source: ensured.source
  };
}

async function updateBossHp(conn, playerId, hpAfter, resultTag) {
  await conn.query(
    `UPDATE player_current_boss
     SET boss_current_hp = ?, encounter_state = ?
     WHERE player_id = ?`,
    [
      hpAfter,
      resultTag === "enemy_defeated" || resultTag === "double_ko" ? "defeated" : "active",
      playerId
    ]
  );
}

async function clearCurrentBoss(conn, playerId) {
  await conn.query(
    `UPDATE player_current_boss
     SET boss_current_hp = 0, encounter_state = 'defeated'
     WHERE player_id = ?`,
    [playerId]
  );
}

async function markBossDefeated(conn, player, boss) {
  await conn.query(
    `INSERT INTO player_boss_defeats (
      player_id,
      boss_id,
      floor_number,
      defeated_life_number
    ) VALUES (?, ?, ?, ?)
    ON DUPLICATE KEY UPDATE defeated_at = defeated_at`,
    [player.id, boss.boss_id, boss.floor_number, player.life_number]
  );
}

async function logBossBattle(conn, { playerId, bossId, battleResult }) {
  await conn.query(
    `INSERT INTO boss_battle_logs (
      player_id,
      boss_id,
      player_action,
      boss_action,
      player_damage_dealt,
      boss_damage_dealt,
      player_hp_after,
      boss_hp_after,
      result_tag
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      playerId,
      bossId,
      battleResult.playerAction,
      battleResult.enemyAction,
      battleResult.playerDamageDealt,
      battleResult.enemyDamageDealt,
      battleResult.playerHpAfter,
      battleResult.enemyHpAfter,
      battleResult.resultTag
    ]
  );
}

module.exports = {
  clearCurrentBoss,
  ensureBossForFloor,
  findActiveBossForContext,
  findBossForTrigger,
  getCurrentBoss,
  logBossBattle,
  markBossDefeated,
  startBossEncounter,
  updateBossHp
};
