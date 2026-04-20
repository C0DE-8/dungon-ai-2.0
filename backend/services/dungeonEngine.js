const EXPLORATION_ACTIONS = ["move", "look", "typed", "appraise", "hide"];
const MAX_DUNGEON_FLOOR = 100;

function getAreaPool(floor = 1) {
  return [
    `Floor ${floor} Broken Hall`,
    `Floor ${floor} Silent Junction`,
    `Floor ${floor} Dust Chamber`,
    `Floor ${floor} Narrow Descent`,
    `Floor ${floor} Sealed Passage`
  ];
}

async function ensureDungeonState(conn, playerId, floor = 1) {
  await conn.query(
    `INSERT IGNORE INTO player_dungeon_state (player_id, floor_number, max_floor_unlocked)
     VALUES (?, ?, ?)`,
    [playerId, floor, Math.max(1, floor)]
  );

  const [[state]] = await conn.query(
    `SELECT *
     FROM player_dungeon_state
     WHERE player_id = ? AND floor_number = ?
     LIMIT 1`,
    [playerId, floor]
  );

  return state;
}

async function markFloorBossDefeated(conn, playerId, floor) {
  const state = await ensureDungeonState(conn, playerId, floor);
  const isDungeonComplete = Number(floor) >= MAX_DUNGEON_FLOOR;

  await conn.query(
    `UPDATE player_dungeon_state
     SET
       floor_boss_defeated = 1,
       hidden_exit_found = 1,
       max_floor_unlocked = GREATEST(max_floor_unlocked, ?),
       last_event_key = 'boss_defeated'
     WHERE id = ?`,
    [isDungeonComplete ? MAX_DUNGEON_FLOOR : floor + 1, state.id]
  );

  return {
    dungeon_completed: isDungeonComplete,
    completed_floor: isDungeonComplete ? MAX_DUNGEON_FLOOR : null
  };
}

async function resetDungeonRun(conn, playerId) {
  await conn.query(
    `DELETE FROM player_dungeon_state WHERE player_id = ?`,
    [playerId]
  );
}

async function resolveDungeonProgression(conn, { player, actionKey, hasActiveEnemy, hasActiveBoss }) {
  if (!EXPLORATION_ACTIONS.includes(actionKey) || hasActiveEnemy || hasActiveBoss) {
    return { event_key: "none", message: null };
  }

  const floor = Number(player.current_floor) || 1;
  const state = await ensureDungeonState(conn, player.id, floor);
  const explorationScore = Number(state.exploration_score) + 1;
  const roll = Math.random();

  if (state.floor_boss_defeated && state.hidden_exit_found && actionKey === "move" && roll < 0.4) {
    if (floor >= MAX_DUNGEON_FLOOR) {
      return {
        event_key: "dungeon_completed",
        message: "The final floor has already been conquered. The dungeon waits for the final wish."
      };
    }

    const nextFloor = floor + 1;
    await ensureDungeonState(conn, player.id, nextFloor);
    await conn.query(
      `UPDATE player_dungeon_state
       SET max_floor_unlocked = GREATEST(max_floor_unlocked, ?), last_event_key = 'floor_advanced'
       WHERE id = ?`,
      [nextFloor, state.id]
    );

    return {
      event_key: "floor_advanced",
      message: "A hidden route folds open and the player slips into a deeper floor.",
      next_floor: nextFloor,
      next_area: `Floor ${nextFloor} Unknown Chamber`
    };
  }

  if (!state.hidden_exit_found && explorationScore >= 2 && roll < 0.25) {
    await conn.query(
      `UPDATE player_dungeon_state
       SET exploration_score = ?, hidden_exit_found = 1, last_event_key = 'hidden_exit_revealed'
       WHERE id = ?`,
      [explorationScore, state.id]
    );

    return {
      event_key: "hidden_exit_revealed",
      message: "Exploration reveals a hidden exit, but its seal still resists passage."
    };
  }

  if (state.hidden_exit_found && !state.boss_triggered && explorationScore >= 3 && roll < 0.35) {
    await conn.query(
      `UPDATE player_dungeon_state
       SET exploration_score = ?, boss_triggered = 1, last_event_key = 'boss_trigger_revealed'
       WHERE id = ?`,
      [explorationScore, state.id]
    );

    return {
      event_key: "boss_trigger_revealed",
      message: "A hidden seal answers the player's exploration. A floor guardian is drawn into the area.",
      trigger_boss: true,
      boss_trigger_key: `floor_${floor}_hidden_seal`
    };
  }

  if (roll < 0.45) {
    await conn.query(
      `UPDATE player_dungeon_state
       SET exploration_score = ?, progression_clues = progression_clues + 1, last_event_key = 'progression_clue'
       WHERE id = ?`,
      [explorationScore, state.id]
    );

    return {
      event_key: "progression_clue",
      message: "The player finds a subtle clue about the floor's hidden route."
    };
  }

  await conn.query(
    `UPDATE player_dungeon_state
     SET exploration_score = ?, last_event_key = 'nothing_found'
     WHERE id = ?`,
    [explorationScore, state.id]
  );

  return {
    event_key: "nothing_found",
    message: "Exploration changes nothing obvious."
  };
}

module.exports = {
  ensureDungeonState,
  getAreaPool,
  markFloorBossDefeated,
  MAX_DUNGEON_FLOOR,
  resetDungeonRun,
  resolveDungeonProgression
};
