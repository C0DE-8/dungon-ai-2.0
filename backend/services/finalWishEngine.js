const MAX_DUNGEON_FLOOR = 100;

function slugify(value = "") {
  return String(value)
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9\s-]/g, "")
    .replace(/\s+/g, "_")
    .replace(/_+/g, "_")
    .replace(/^_|_$/g, "");
}

function parseJson(value, fallback = null) {
  if (!value) return fallback;
  if (typeof value === "object") return value;

  try {
    return JSON.parse(value);
  } catch (err) {
    return fallback;
  }
}

function scoreWish(wishText) {
  const text = String(wishText || "").toLowerCase();
  const categories = [
    {
      key: "dragon",
      race: "Draconic Ascendant",
      title: "Bearer of the First Flame",
      identity: "Dragon-Souled Conqueror",
      keywords: ["dragon", "flame", "fire", "burn", "wings", "scale"],
      stats: { strength: 3, stamina: 2, charisma: 1 },
      passive: [{ key: "draconic_body", name: "Draconic Body", effect: { max_hp_bonus: 15 } }],
      active: [{ key: "ember_command", name: "Ember Command", effect: { damage_bonus: 2, cooldown: 3 } }]
    },
    {
      key: "shadow",
      race: "Umbral Ascendant",
      title: "Sovereign of Quiet Doors",
      identity: "Shadow-Walked Victor",
      keywords: ["shadow", "night", "stealth", "hidden", "invisible", "dark"],
      stats: { dexterity: 3, wisdom: 2, intelligence: 1 },
      passive: [{ key: "world_between_steps", name: "World Between Steps", effect: { stealth_bonus: 2 } }],
      active: [{ key: "vanish_once", name: "Vanish Once", effect: { evade_next_threat: 1, cooldown: 4 } }]
    },
    {
      key: "knowledge",
      race: "Aether Sage",
      title: "Keeper of the Unsealed Truth",
      identity: "Wish-Bound Scholar",
      keywords: ["knowledge", "truth", "magic", "spell", "wisdom", "intelligence", "understand"],
      stats: { intelligence: 3, wisdom: 3 },
      passive: [{ key: "aether_memory", name: "Aether Memory", effect: { clue_quality_bonus: 2 } }],
      active: [{ key: "read_fate", name: "Read Fate", effect: { reveal_hidden_state: 1, cooldown: 5 } }]
    },
    {
      key: "life",
      race: "Eternal Vessel",
      title: "Heir to the Living Cycle",
      identity: "Life-Forged Survivor",
      keywords: ["life", "heal", "immortal", "survive", "restore", "protect", "health"],
      stats: { stamina: 3, wisdom: 2, charisma: 1 },
      passive: [{ key: "death_residue", name: "Death Residue", effect: { max_hp_bonus: 20 } }],
      active: [{ key: "last_breath", name: "Last Breath", effect: { emergency_heal: 10, cooldown: 6 } }]
    },
    {
      key: "power",
      race: "Titan-Blooded Ascendant",
      title: "Breaker of Sealed Thrones",
      identity: "Crowned Destroyer",
      keywords: ["power", "strength", "strong", "war", "destroy", "conquer", "rule"],
      stats: { strength: 3, stamina: 2, dexterity: 1 },
      passive: [{ key: "titan_frame", name: "Titan Frame", effect: { physical_resistance: 2 } }],
      active: [{ key: "sovereign_strike", name: "Sovereign Strike", effect: { damage_bonus: 3, cooldown: 5 } }]
    },
    {
      key: "freedom",
      race: "World-Wanderer",
      title: "One Who Crossed the Last Door",
      identity: "Unbound Pilgrim",
      keywords: ["freedom", "world", "explore", "travel", "open", "beyond", "peace"],
      stats: { dexterity: 2, charisma: 2, wisdom: 2 },
      passive: [{ key: "open_road", name: "Open Road", effect: { travel_event_bonus: 2 } }],
      active: [{ key: "path_claim", name: "Path Claim", effect: { stabilize_region: 2, cooldown: 4 } }]
    }
  ];

  let selected = categories[categories.length - 1];
  let bestScore = -1;

  for (const category of categories) {
    const score = category.keywords.reduce((sum, keyword) => (
      text.includes(keyword) ? sum + 1 : sum
    ), 0);

    if (score > bestScore) {
      bestScore = score;
      selected = category;
    }
  }

  return selected;
}

function interpretFinalWish(wishText = "") {
  const selected = scoreWish(wishText);
  const wishSlug = slugify(wishText).slice(0, 40) || "unspoken_wish";

  return {
    intent: selected.key,
    form_key: `${selected.key}_${wishSlug}`,
    new_race: selected.race,
    new_title: selected.title,
    identity_label: selected.identity,
    stat_bonuses: selected.stats,
    passive_traits: selected.passive,
    active_traits: selected.active,
    carryover_power: 10,
    limitations: {
      max_single_stat_bonus: 3,
      world_mode_scaling: "ascended but not invincible"
    }
  };
}

async function startFinalAscension(conn, player, floorReached = MAX_DUNGEON_FLOOR) {
  if (floorReached < MAX_DUNGEON_FLOOR) {
    return null;
  }

  await conn.query(
    `INSERT INTO player_dungeon_completions (
      player_id,
      completed_life_number,
      floor_reached,
      status
    ) VALUES (?, ?, ?, 'awaiting_wish')
    ON DUPLICATE KEY UPDATE status = IF(status = 'ascended', status, 'awaiting_wish')`,
    [player.id, player.life_number, floorReached]
  );

  await conn.query(
    `INSERT INTO player_dungeon_run_history (
      player_id,
      life_number,
      highest_floor,
      run_result,
      summary_json
    ) VALUES (?, ?, ?, 'completed', ?)`,
    [
      player.id,
      player.life_number,
      floorReached,
      JSON.stringify({ completed_floor: floorReached, prompt: "State your wish." })
    ]
  );

  const [[completion]] = await conn.query(
    `SELECT *
     FROM player_dungeon_completions
     WHERE player_id = ? AND completed_life_number = ?
     LIMIT 1`,
    [player.id, player.life_number]
  );

  return completion || null;
}

async function getPendingAscension(connOrPool, playerId) {
  const [[completion]] = await connOrPool.query(
    `SELECT *
     FROM player_dungeon_completions
     WHERE player_id = ? AND status = 'awaiting_wish'
     ORDER BY completed_at DESC
     LIMIT 1`,
    [playerId]
  );

  return completion || null;
}

async function getLatestAscension(connOrPool, playerId) {
  const [[ascension]] = await connOrPool.query(
    `SELECT
      ar.*,
      fw.wish_text,
      fw.interpreted_intent
     FROM player_ascension_results ar
     INNER JOIN player_final_wishes fw ON ar.final_wish_id = fw.id
     WHERE ar.player_id = ?
     ORDER BY ar.created_at DESC
     LIMIT 1`,
    [playerId]
  );

  if (!ascension) return null;

  return {
    ...ascension,
    stat_bonuses: parseJson(ascension.stat_bonus_json, {}),
    passive_traits: parseJson(ascension.passive_traits_json, []),
    active_traits: parseJson(ascension.active_traits_json, [])
  };
}

async function applyStatBonuses(conn, playerId, statBonuses) {
  const allowed = {
    strength: "strength_stat",
    dexterity: "dexterity_stat",
    stamina: "stamina_stat",
    intelligence: "intelligence_stat",
    charisma: "charisma_stat",
    wisdom: "wisdom_stat"
  };

  for (const [stat, amount] of Object.entries(statBonuses || {})) {
    const column = allowed[stat];
    const safeAmount = Math.max(0, Math.min(3, Number(amount) || 0));

    if (column && safeAmount > 0) {
      await conn.query(
        `UPDATE players SET ${column} = ${column} + ? WHERE id = ?`,
        [safeAmount, playerId]
      );
    }
  }
}

async function insertCarryoverTraits(conn, playerId, ascensionId, traits, traitType) {
  for (const trait of traits) {
    await conn.query(
      `INSERT INTO player_carryover_traits (
        player_id,
        ascension_id,
        trait_key,
        trait_type,
        name,
        effect_json
      ) VALUES (?, ?, ?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE trait_key = trait_key`,
      [
        playerId,
        ascensionId,
        trait.key,
        traitType,
        trait.name,
        JSON.stringify(trait.effect || {})
      ]
    );
  }
}

async function resolveFinalWish(conn, player, wishText) {
  const completion = await getPendingAscension(conn, player.id);

  if (!completion) {
    return null;
  }

  const interpretation = interpretFinalWish(wishText);

  const [wishResult] = await conn.query(
    `INSERT INTO player_final_wishes (
      player_id,
      completion_id,
      wish_text,
      interpreted_intent,
      interpretation_json
    ) VALUES (?, ?, ?, ?, ?)`,
    [
      player.id,
      completion.id,
      wishText,
      interpretation.intent,
      JSON.stringify(interpretation)
    ]
  );

  const [ascensionResult] = await conn.query(
    `INSERT INTO player_ascension_results (
      player_id,
      final_wish_id,
      form_key,
      new_race,
      new_title,
      identity_label,
      stat_bonus_json,
      passive_traits_json,
      active_traits_json,
      carryover_power
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      player.id,
      wishResult.insertId,
      interpretation.form_key,
      interpretation.new_race,
      interpretation.new_title,
      interpretation.identity_label,
      JSON.stringify(interpretation.stat_bonuses),
      JSON.stringify(interpretation.passive_traits),
      JSON.stringify(interpretation.active_traits),
      interpretation.carryover_power
    ]
  );

  await insertCarryoverTraits(conn, player.id, ascensionResult.insertId, interpretation.passive_traits, "passive");
  await insertCarryoverTraits(conn, player.id, ascensionResult.insertId, interpretation.active_traits, "active");
  await applyStatBonuses(conn, player.id, interpretation.stat_bonuses);

  await conn.query(
    `UPDATE players
     SET
      current_race = ?,
      current_title = ?,
      is_alive = 1,
      hp = max_hp
     WHERE id = ?`,
    [interpretation.new_race, interpretation.new_title, player.id]
  );

  await conn.query(
    `UPDATE player_dungeon_completions
     SET status = 'ascended', ascended_at = CURRENT_TIMESTAMP
     WHERE id = ?`,
    [completion.id]
  );

  return {
    completion,
    ascension_id: ascensionResult.insertId,
    final_wish_id: wishResult.insertId,
    interpretation
  };
}

module.exports = {
  MAX_DUNGEON_FLOOR,
  getLatestAscension,
  getPendingAscension,
  interpretFinalWish,
  resolveFinalWish,
  startFinalAscension
};
