const pool = require("../config/db");

function slugify(value = "") {
  return String(value)
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9\s-]/g, "")
    .replace(/\s+/g, "_");
}

function getFloorEnemyTemplate(floor = 1) {
  if (floor <= 5) {
    return {
      name: "Goblin Scout",
      enemy_type: "normal",
      level: 1,
      hp: 18,
      max_hp: 18,
      attack_stat: 4,
      defense_stat: 2,
      speed_stat: 3,
      intelligence_stat: 2,
      reward_exp: 10,
      description: "A small green scavenger lurking in the lower dungeon."
    };
  }

  return {
    name: "Dungeon Vermin",
    enemy_type: "normal",
    level: 1,
    hp: 16,
    max_hp: 16,
    attack_stat: 3,
    defense_stat: 2,
    speed_stat: 2,
    intelligence_stat: 1,
    reward_exp: 8,
    description: "A low-level creature shaped by the dungeon."
  };
}

async function createEnemyIfNew(conn, { floor = 1, area = "Unknown Chamber" }) {
  const template = getFloorEnemyTemplate(floor);
  const enemyKey = `${slugify(template.name)}_f${floor}`;

  const [[existing]] = await conn.query(
    `SELECT * FROM enemies WHERE enemy_key = ? LIMIT 1`,
    [enemyKey]
  );

  if (existing) {
    return { enemy: existing, isNew: false };
  }

  const [result] = await conn.query(
    `INSERT INTO enemies (
      enemy_key,
      name,
      enemy_type,
      floor_min,
      floor_max,
      level,
      hp,
      max_hp,
      attack_stat,
      defense_stat,
      speed_stat,
      intelligence_stat,
      reward_exp,
      description,
      is_boss
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      enemyKey,
      template.name,
      template.enemy_type,
      floor,
      floor,
      template.level,
      template.hp,
      template.max_hp,
      template.attack_stat,
      template.defense_stat,
      template.speed_stat,
      template.intelligence_stat,
      template.reward_exp,
      `${template.description} Encountered in ${area}.`,
      0
    ]
  );

  const [[enemy]] = await conn.query(
    `SELECT * FROM enemies WHERE id = ? LIMIT 1`,
    [result.insertId]
  );

  return { enemy, isNew: true };
}

async function markEnemyDiscovered(conn, playerId, enemyId) {
  await conn.query(
    `INSERT INTO player_enemy_discoveries (player_id, enemy_id)
     VALUES (?, ?)
     ON DUPLICATE KEY UPDATE enemy_id = enemy_id`,
    [playerId, enemyId]
  );
}

async function setCurrentEnemy(conn, playerId, enemy) {
  await conn.query(
    `INSERT INTO player_current_enemy (
      player_id,
      enemy_id,
      enemy_current_hp,
      encounter_state
    ) VALUES (?, ?, ?, ?)
    ON DUPLICATE KEY UPDATE
      enemy_id = VALUES(enemy_id),
      enemy_current_hp = VALUES(enemy_current_hp),
      encounter_state = VALUES(encounter_state)`,
    [playerId, enemy.id, enemy.hp, "active"]
  );
}

async function getCurrentEnemy(conn, playerId) {
  const [[row]] = await conn.query(
    `SELECT
      pce.id,
      pce.enemy_id,
      pce.enemy_current_hp,
      pce.encounter_state,
      e.name,
      e.enemy_type,
      e.level,
      e.hp,
      e.max_hp,
      e.attack_stat,
      e.defense_stat,
      e.speed_stat,
      e.intelligence_stat,
      e.reward_exp,
      e.description,
      e.is_boss
     FROM player_current_enemy pce
     INNER JOIN enemies e ON pce.enemy_id = e.id
     WHERE pce.player_id = ?
     LIMIT 1`,
    [playerId]
  );

  return row || null;
}

function shouldEncounterEnemy(actionKey) {
  return ["move", "look", "typed"].includes(actionKey);
}

module.exports = {
  createEnemyIfNew,
  markEnemyDiscovered,
  setCurrentEnemy,
  getCurrentEnemy,
  shouldEncounterEnemy
};