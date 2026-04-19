const GAME_CONFIG = require("../config/gameConfig");
const { clearCurrentBoss } = require("./bossEngine");
const { resetDungeonRun } = require("./dungeonEngine");
const { ensurePlayerConditionStats } = require("./skillEngine");

async function recordDeath(conn, player, deathCause = "Unknown cause") {
  await conn.query(
    `INSERT INTO player_deaths (
      player_id,
      life_number,
      death_cause,
      floor_number,
      area,
      year_survived,
      day_survived,
      current_hour
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ON DUPLICATE KEY UPDATE death_cause = VALUES(death_cause)`,
    [
      player.id,
      player.life_number,
      deathCause,
      player.current_floor,
      player.current_area,
      player.year_survived,
      player.day_survived,
      player.current_hour
    ]
  );
}

async function triggerDeathFlow(conn, player, deathCause) {
  await recordDeath(conn, player, deathCause);
  await conn.query(
    `UPDATE players SET is_alive = 0, hp = 0 WHERE id = ?`,
    [player.id]
  );
}

function getWishEffect(wishText = "") {
  const text = String(wishText || "").toLowerCase();

  if (text.includes("health") || text.includes("hp") || text.includes("survive")) {
    return {
      type: "max_hp",
      amount: 5,
      message: "The next life begins with a small increase to maximum HP."
    };
  }

  const stats = ["strength", "dexterity", "stamina", "intelligence", "charisma", "wisdom"];
  const matchedStat = stats.find((stat) => text.includes(stat));

  if (matchedStat) {
    return {
      type: "stat",
      stat: matchedStat,
      amount: 1,
      message: `The next life begins with a small ${matchedStat} increase.`
    };
  }

  return {
    type: "none",
    amount: 0,
    message: "The wish is recorded, but no stable limited effect forms."
  };
}

async function applyWishEffect(conn, playerId, effect) {
  if (effect.type === "max_hp") {
    await conn.query(
      `UPDATE players SET max_hp = max_hp + ?, hp = max_hp + ? WHERE id = ?`,
      [effect.amount, effect.amount, playerId]
    );
  }

  if (effect.type === "stat") {
    const statColumn = `${effect.stat}_stat`;
    const allowed = new Set([
      "strength_stat",
      "dexterity_stat",
      "stamina_stat",
      "intelligence_stat",
      "charisma_stat",
      "wisdom_stat"
    ]);

    if (allowed.has(statColumn)) {
      await conn.query(
        `UPDATE players SET ${statColumn} = ${statColumn} + ? WHERE id = ?`,
        [effect.amount, playerId]
      );
    }
  }
}

async function restartSameForm(conn, player, wishText = null) {
  const nextLifeNumber = Number(player.life_number || 1) + 1;
  const effect = wishText ? getWishEffect(wishText) : null;

  await resetDungeonRun(conn, player.id);
  await clearCurrentBoss(conn, player.id);

  await conn.query(
    `DELETE FROM player_current_enemy WHERE player_id = ?`,
    [player.id]
  );

  await conn.query(
    `DELETE FROM player_current_scene WHERE player_id = ?`,
    [player.id]
  );

  await conn.query(
    `UPDATE players
     SET
       hp = max_hp,
       current_floor = ?,
       current_area = ?,
       life_number = ?,
       is_alive = 1,
       year_survived = ?,
       day_survived = ?,
       current_hour = ?
     WHERE id = ?`,
    [
      GAME_CONFIG.START_FLOOR,
      GAME_CONFIG.START_AREA,
      nextLifeNumber,
      GAME_CONFIG.START_YEAR,
      GAME_CONFIG.START_DAY,
      GAME_CONFIG.START_HOUR,
      player.id
    ]
  );

  if (effect) {
    await conn.query(
      `INSERT INTO player_rebirth_wishes (
        player_id,
        life_number,
        wish_text,
        granted_effect_json
      ) VALUES (?, ?, ?, ?)`,
      [player.id, nextLifeNumber, String(wishText).slice(0, 240), JSON.stringify(effect)]
    );

    await applyWishEffect(conn, player.id, effect);
  }

  await ensurePlayerConditionStats(conn, player.id);

  return {
    life_number: nextLifeNumber,
    wish_effect: effect
  };
}

async function getDeathStatus(connOrPool, playerId) {
  const [[player]] = await connOrPool.query(
    `SELECT id, is_alive, life_number, hp, max_hp
     FROM players
     WHERE id = ?
     LIMIT 1`,
    [playerId]
  );

  const [[death]] = await connOrPool.query(
    `SELECT *
     FROM player_deaths
     WHERE player_id = ?
     ORDER BY created_at DESC
     LIMIT 1`,
    [playerId]
  );

  return {
    player,
    latest_death: death || null
  };
}

module.exports = {
  getDeathStatus,
  restartSameForm,
  triggerDeathFlow
};
