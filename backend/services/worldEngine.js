function parseJson(value, fallback = null) {
  if (!value) return fallback;
  if (typeof value === "object") return value;

  try {
    return JSON.parse(value);
  } catch (err) {
    return fallback;
  }
}

async function getWorldState(connOrPool, playerId) {
  const [[state]] = await connOrPool.query(
    `SELECT
      ws.*,
      ar.new_race,
      ar.new_title,
      ar.identity_label,
      ar.carryover_power,
      ar.passive_traits_json,
      ar.active_traits_json
     FROM player_world_state ws
     INNER JOIN player_ascension_results ar ON ws.ascension_id = ar.id
     WHERE ws.player_id = ?
     LIMIT 1`,
    [playerId]
  );

  if (!state) return null;

  return {
    ...state,
    state: parseJson(state.state_json, {}),
    passive_traits: parseJson(state.passive_traits_json, []),
    active_traits: parseJson(state.active_traits_json, [])
  };
}

async function initializeWorldMode(conn, playerId, ascensionId, interpretation) {
  await conn.query(
    `INSERT INTO player_world_state (
      player_id,
      ascension_id,
      world_region,
      world_phase,
      influence,
      stability,
      current_objective,
      state_json
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ON DUPLICATE KEY UPDATE
      ascension_id = VALUES(ascension_id),
      world_region = VALUES(world_region),
      world_phase = VALUES(world_phase),
      influence = VALUES(influence),
      stability = VALUES(stability),
      current_objective = VALUES(current_objective),
      state_json = VALUES(state_json)`,
    [
      playerId,
      ascensionId,
      "Threshold Kingdom",
      "awakening",
      Math.min(25, interpretation.carryover_power),
      55,
      "Understand the world beyond the dungeon",
      JSON.stringify({
        origin: "dungeon_ascension",
        form_key: interpretation.form_key,
        identity_label: interpretation.identity_label
      })
    ]
  );

  await conn.query(
    `UPDATE players
     SET current_area = 'Threshold Kingdom', current_floor = 100
     WHERE id = ?`,
    [playerId]
  );

  return getWorldState(conn, playerId);
}

function normalizeWorldAction(input = "") {
  const text = String(input || "").trim().toLowerCase();

  if (["look", "observe", "survey"].includes(text)) return "observe";
  if (["travel", "move", "explore"].includes(text)) return "travel";
  if (["help", "protect", "aid"].includes(text)) return "aid";
  if (["command", "rule", "influence"].includes(text)) return "influence";
  if (["rest", "recover"].includes(text)) return "rest";

  return text ? "world_typed" : "";
}

async function resolveWorldAction(conn, { playerId, actionInput }) {
  const actionKey = normalizeWorldAction(actionInput);

  if (!actionKey) {
    return null;
  }

  const state = await getWorldState(conn, playerId);

  if (!state) {
    return null;
  }

  let influenceDelta = 0;
  let stabilityDelta = 0;
  let worldPhase = state.world_phase;
  let objective = state.current_objective;
  let outcome = "The ascended player acts in the wider world.";

  if (actionKey === "observe") {
    stabilityDelta = 1;
    outcome = "The player studies the world beyond the dungeon and reads its tensions.";
  } else if (actionKey === "travel") {
    influenceDelta = 1;
    outcome = "The player travels beyond the threshold and discovers new pressure in the living world.";
  } else if (actionKey === "aid") {
    influenceDelta = 2;
    stabilityDelta = 2;
    outcome = "The player uses ascended power to stabilize a local crisis.";
  } else if (actionKey === "influence") {
    influenceDelta = 3;
    stabilityDelta = -1;
    outcome = "The player bends attention and authority toward their ascended presence.";
  } else if (actionKey === "rest") {
    stabilityDelta = 1;
    outcome = "The player anchors the new form and recovers balance.";
  } else {
    influenceDelta = 1;
    outcome = `The player attempts a freeform world action: "${actionInput}".`;
  }

  const nextInfluence = Math.max(0, Number(state.influence) + influenceDelta);
  const nextStability = Math.max(0, Math.min(100, Number(state.stability) + stabilityDelta));

  if (nextInfluence >= 20 && state.world_phase === "awakening") {
    worldPhase = "recognized";
    objective = "Choose how this world will remember the ascended one";
  }

  await conn.query(
    `UPDATE player_world_state
     SET
      influence = ?,
      stability = ?,
      world_phase = ?,
      current_objective = ?,
      world_hour = (world_hour + 2) % 24
     WHERE id = ?`,
    [nextInfluence, nextStability, worldPhase, objective, state.id]
  );

  const updatedState = await getWorldState(conn, playerId);

  await conn.query(
    `INSERT INTO world_action_logs (
      player_id,
      world_state_id,
      action_key,
      action_text,
      outcome_json
    ) VALUES (?, ?, ?, ?, ?)`,
    [
      playerId,
      state.id,
      actionKey,
      actionInput,
      JSON.stringify({
        outcome,
        influence_delta: influenceDelta,
        stability_delta: stabilityDelta
      })
    ]
  );

  return {
    action_key: actionKey,
    outcome,
    world_state: updatedState
  };
}

module.exports = {
  getWorldState,
  initializeWorldMode,
  resolveWorldAction
};
