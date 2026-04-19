function parseJson(value, fallback = []) {
  if (!value) return fallback;
  if (typeof value === "object") return value;

  try {
    return JSON.parse(value);
  } catch (err) {
    return fallback;
  }
}

function getGeneratedBossTemplate(floor = 1) {
  const level = Math.max(2, Number(floor) + 1);

  return {
    boss_key: `floor_${floor}_warden`,
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
    trigger_key: `floor_${floor}_hidden_seal`,
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

async function ensureBossForFloor(conn, floor = 1) {
  const [[existing]] = await conn.query(
    `SELECT * FROM bosses WHERE floor_number = ? ORDER BY id ASC LIMIT 1`,
    [floor]
  );

  if (existing) return existing;

  const template = getGeneratedBossTemplate(floor);

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

  return boss;
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
     LIMIT 1`,
    [playerId]
  );

  if (!boss) return null;

  return {
    ...boss,
    skills: await getBossSkills(conn, boss.boss_id)
  };
}

async function startBossEncounter(conn, playerId, floor) {
  const boss = await ensureBossForFloor(conn, floor);

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

  return getCurrentBoss(conn, playerId);
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
    `DELETE FROM player_current_boss WHERE player_id = ?`,
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
  getCurrentBoss,
  logBossBattle,
  markBossDefeated,
  startBossEncounter,
  updateBossHp
};
