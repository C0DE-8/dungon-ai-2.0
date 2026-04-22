const TEXT_ACTION_INTENTS = new Set([
  "direct_attack",
  "precision_attack",
  "heavy_attack",
  "defend",
  "hide",
  "observe",
  "environment_attack",
  "environment_control",
  "loot_remains",
  "inspect_remains",
  "devour_remains",
  "rest",
  "escape",
  "map_area",
  "scout_area",
  "plan_next_move",
  "move_toward_objective",
  "force_object",
  "social",
  "invalid"
]);

const TAG_BY_AREA_KEYWORD = [
  { keyword: "broken", tags: ["cover_available", "loose_stones", "broken_wall"] },
  { keyword: "hall", tags: ["wall_present", "torch_stand", "cover_available"] },
  { keyword: "silent", tags: ["dark_area", "cover_available"] },
  { keyword: "junction", tags: ["cover_available", "loose_stones"] },
  { keyword: "dust", tags: ["loose_sand", "loose_stones", "low_visibility"] },
  { keyword: "chamber", tags: ["pillar_present", "wall_present", "torch_stand"] },
  { keyword: "narrow", tags: ["narrow_space", "wall_present", "cover_available"] },
  { keyword: "descent", tags: ["uneven_terrain", "loose_stones"] },
  { keyword: "sealed", tags: ["sealed_door", "wall_present"] },
  { keyword: "unknown", tags: ["dark_area", "wall_present"] }
];

const TARGET_TAGS = {
  pillar: "pillar_present",
  column: "pillar_present",
  wall: "wall_present",
  stones: "loose_stones",
  rock: "loose_stones",
  sand: "loose_sand",
  dust: "loose_sand",
  torch: "torch_stand",
  darkness: "dark_area",
  shadow: "dark_area",
  cover: "cover_available",
  trap: "wall_present",
  ambush: "cover_available",
  chokepoint: "narrow_space",
  passage: "narrow_space",
  terrain: "uneven_terrain",
  door: "sealed_door",
  corpse: "corpse_present",
  body: "corpse_present",
  remains: "corpse_present"
};

function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}

function normalizeText(text = "") {
  return String(text)
    .toLowerCase()
    .replace(/[^\w\s'-]/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function includesAny(text, terms) {
  return terms.some((term) => text.includes(term));
}

function firstMatch(text, terms) {
  return terms.find((term) => text.includes(term)) || null;
}

function extractDurationHours(normalized) {
  const numericMatch = normalized.match(/\b(\d+)\s*(?:hours?|hrs?|h)\b/);
  if (numericMatch) return clamp(Number(numericMatch[1]) || 1, 1, 24);

  const wordHours = {
    one: 1,
    two: 2,
    three: 3,
    four: 4,
    five: 5,
    six: 6,
    seven: 7,
    eight: 8
  };

  for (const [word, hours] of Object.entries(wordHours)) {
    if (normalized.includes(`${word} hour`) || normalized.includes(`${word} hr`)) {
      return hours;
    }
  }

  return null;
}

function requestsFullRecovery(normalized) {
  return /\b(?:til|till|until)\b.*\b(?:health|hp)\b.*\bfull\b/.test(normalized)
    || /\b(?:health|hp)\b.*\b(?:is|gets?|becomes?)\b.*\bfull\b/.test(normalized)
    || /\b(?:reach|get|return to|recover to|restore to)\b.*\bfull\b.*\b(?:capacity|strength|health|hp)\b/.test(normalized)
    || /\b(?:full|maximum|max)\b.*\b(?:capacity|stability|condition)\b/.test(normalized)
    || /\b(?:capacity|stability|condition)\b.*\b(?:is|gets?|becomes?|reaches?)\b.*\bfull\b/.test(normalized)
    || includesAny(normalized, [
    "full health",
    "full hp",
    "full capacity",
    "full condition",
    "full stability",
    "max health",
    "max hp",
    "max capacity",
    "maximum capacity",
    "fully heal",
    "fully healed",
    "fully recover",
    "fully recovered",
    "heal fully",
    "recover fully",
    "full strength",
    "reach full capacity",
    "reach full health",
    "reach full hp",
    "restore full capacity",
    "restore full health",
    "recover to full",
    "back to full",
    "top off",
    "until healed",
    "till healed",
    "til healed",
    "until i heal",
    "till i heal",
    "til i heal",
    "until i get my health",
    "till i get my health",
    "til i get my health",
    "until i get my full health",
    "till i get my full health",
    "til i get my full health",
    "until full capacity",
    "till full capacity",
    "til full capacity",
    "health is full",
    "hp is full",
    "health gets full",
    "hp gets full",
    "capacity is full",
    "capacity gets full"
  ]);
}

function requestsShortRest(normalized) {
  return includesAny(normalized, [
    "short nap",
    "quick nap",
    "brief nap",
    "small nap",
    "short rest",
    "quick rest",
    "brief rest",
    "take a nap",
    "power nap",
    "catnap"
  ]);
}

function getFullRecoveryDurationHours(player) {
  const currentHp = Number(player?.hp || 0);
  const maxHp = Number(player?.max_hp || currentHp || 1);
  const missingHp = Math.max(0, maxHp - currentHp);

  if (missingHp <= 0) return 1;

  return clamp(Math.ceil(missingHp / 5) * 2, 2, 72);
}

function splitTextActionSteps(text = "") {
  const normalized = normalizeText(text);
  if (!normalized) return [];

  const beforeMatch = normalized.match(/^(.*?)\b(?:but\s+)?before\s+(?:that|then)\b\s+(.*)$/);

  if (beforeMatch) {
    const primary = beforeMatch[1].trim();
    const prerequisiteText = beforeMatch[2].trim();
    const prerequisiteSteps = splitTextActionSteps(prerequisiteText);
    return [...prerequisiteSteps, primary].filter(Boolean);
  }

  return normalized
    .split(/\b(?:and\s+then|then|after\s+that|next|finally|and\s+(?=(?:plan|prepare|find|move|go|run|flee|escape|retreat|withdraw|rest|sleep|heal|map|scout|observe|look|attack|defend|hide|appraise|search|loot|inspect|devour)\b))/g)
    .map((step) => step.trim())
    .filter(Boolean);
}

function titleCase(value = "") {
  return String(value)
    .replace(/[_-]+/g, " ")
    .trim()
    .split(/\s+/)
    .filter(Boolean)
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(" ");
}

function getActiveOpponent(enemy, boss) {
  if (boss && boss.encounter_state === "active") {
    return { ...boss, isBoss: true, currentHp: Number(boss.boss_current_hp || boss.enemy_current_hp || boss.hp || 0) };
  }

  if (enemy && enemy.encounter_state === "active") {
    return { ...enemy, isBoss: false, currentHp: Number(enemy.enemy_current_hp || enemy.hp || 0) };
  }

  return null;
}

function deriveSceneTags({ player, currentScene, activeOpponent, remains = [] }) {
  const tags = new Set();
  const area = normalizeText(player?.current_area || "");
  const sceneText = normalizeText(`${currentScene?.scene_title || ""} ${currentScene?.scene_text || ""}`);

  for (const entry of TAG_BY_AREA_KEYWORD) {
    if (area.includes(entry.keyword) || sceneText.includes(entry.keyword)) {
      entry.tags.forEach((tag) => tags.add(tag));
    }
  }

  if (includesAny(sceneText, ["pillar", "column", "load bearing"])) tags.add("pillar_present");
  if (includesAny(sceneText, ["wall", "broken wall", "fracture"])) tags.add("wall_present");
  if (includesAny(sceneText, ["loose stone", "loose stones", "rubble", "debris"])) tags.add("loose_stones");
  if (includesAny(sceneText, ["sand", "dust", "ash"])) tags.add("loose_sand");
  if (includesAny(sceneText, ["torch", "fire", "brazier"])) tags.add("torch_stand");
  if (includesAny(sceneText, ["cover", "barricade", "behind"])) tags.add("cover_available");
  if (includesAny(sceneText, ["corpse", "body", "remains"])) tags.add("corpse_present");

  if (activeOpponent) tags.add("enemy_present");
  if (remains.length > 0) tags.add("corpse_present");
  if (Number(player?.current_hour || 0) >= 20 || Number(player?.current_hour || 0) <= 4) {
    tags.add("dark_area");
  }

  return [...tags].sort();
}

function getTargetFromText(normalized) {
  return firstMatch(normalized, Object.keys(TARGET_TAGS));
}

function getApproach(normalized) {
  if (includesAny(normalized, ["full power", "full strength", "all my strength", "hard", "smash", "crush", "break", "force"])) {
    return "heavy_force";
  }

  if (includesAny(normalized, ["carefully", "careful", "circle", "opening", "wait", "measure", "look for"])) {
    return "careful";
  }

  if (includesAny(normalized, ["quick", "rush", "lunge", "dash", "jump"])) {
    return "quick";
  }

  if (includesAny(normalized, ["reckless", "wild", "desperate"])) {
    return "reckless";
  }

  return "normal";
}

function getRiskLevel(normalized, intent, approach) {
  if (approach === "reckless" || includesAny(normalized, ["collapse", "building", "ceiling", "full power", "suicide"])) {
    return "high";
  }

  if (approach === "heavy_force" || intent === "environment_attack" || includesAny(normalized, ["rush", "jump", "eye", "throat", "weak point"])) {
    return "medium";
  }

  return "low";
}

function inferRequestedEffect(normalized) {
  if (includesAny(normalized, ["run away", "flee", "escape", "retreat", "withdraw", "disengage", "safe place", "away from the fight", "get away"])) return "reach_safety";
  if (includesAny(normalized, ["collapse", "fall on", "bring down", "building"])) return "collapse_structure";
  if (includesAny(normalized, ["blind", "eyes", "sand", "dust"])) return "blind_target";
  if (includesAny(normalized, ["burn", "fire", "torch"])) return "burn_target";
  if (includesAny(normalized, ["hide", "cover", "wall"])) return "gain_cover";
  if (includesAny(normalized, ["open", "force", "door"])) return "force_open";
  if (includesAny(normalized, ["loot", "search"])) return "recover_loot";
  if (includesAny(normalized, ["inspect", "study", "examine"])) return "gain_information";
  if (includesAny(normalized, ["eat", "devour", "consume"])) return "consume_remains";
  return null;
}

function interpretTextAction(text, { player, currentScene, enemy, boss, sceneTags = [] } = {}) {
  const normalized = normalizeText(text);
  const target = getTargetFromText(normalized);
  const approach = getApproach(normalized);
  let intent = "observe";
  let secondaryTarget = null;

  if (!normalized) intent = "invalid";
  else if (includesAny(normalized, ["run away", "flee", "escape", "retreat", "withdraw", "disengage", "safe place", "away from the fight", "get away", "back away"])) intent = "escape";
  else if (includesAny(normalized, ["eat", "devour", "consume corpse", "consume remains"])) intent = "devour_remains";
  else if (includesAny(normalized, ["inspect the body", "inspect body", "inspect corpse", "inspect remains", "examine remains", "study remains"])) intent = "inspect_remains";
  else if (includesAny(normalized, ["loot", "search the body", "search body", "search corpse", "search remains", "corpse", "remains"])) intent = "loot_remains";
  else if (includesAny(normalized, ["talk", "negotiate", "speak", "reason with", "communicate"])) intent = "social";
  else if (includesAny(normalized, ["defend", "brace", "block", "guard"])) intent = "defend";
  else if (includesAny(normalized, ["hide", "sneak", "ambush", "behind cover"])) intent = "hide";
  else if (includesAny(normalized, ["pillar", "column", "wall", "sand", "dust", "torch", "terrain", "stones", "rock", "cover"])) {
    intent = includesAny(normalized, ["attack", "strike", "kick", "throw", "break", "collapse", "fall on", "enemy", "creature", "goblin"])
      ? "environment_attack"
      : "environment_control";
  } else if (includesAny(normalized, ["force the door", "break the door", "open the door"])) intent = "force_object";
  else if (includesAny(normalized, ["look for an opening", "find an opening", "watch for an opening", "circle around"])) intent = "observe";
  else if (includesAny(normalized, ["eye", "throat", "weak point", "joint"]) || (normalized.includes("opening") && includesAny(normalized, ["stab", "slash", "strike", "attack", "hit"]))) intent = "precision_attack";
  else if (includesAny(normalized, ["slash", "stab", "strike", "attack", "hit", "rush", "lunge"])) {
    intent = approach === "heavy_force" ? "heavy_attack" : "direct_attack";
  }

  if (["environment_attack", "direct_attack", "precision_attack", "heavy_attack", "social", "escape"].includes(intent)) {
    secondaryTarget = boss ? "boss" : enemy ? "enemy" : null;
  }

  return {
    intent: TEXT_ACTION_INTENTS.has(intent) ? intent : "invalid",
    approach,
    target,
    secondary_target: secondaryTarget,
    risk_level: getRiskLevel(normalized, intent, approach),
    requested_effect: inferRequestedEffect(normalized),
    tags_considered: sceneTags,
    confidence: normalized ? 0.78 : 0,
    source: "backend_rules"
  };
}

function interpretUtilityStep(stepText, index, context) {
  const normalized = normalizeText(stepText);
  const durationHours = extractDurationHours(normalized);
  const wantsFullRecovery = requestsFullRecovery(normalized);
  let intent = null;
  let actionKey = "typed";
  let requestedEffect = null;
  let objective = null;

  if (includesAny(normalized, ["run away", "flee", "escape", "retreat", "withdraw", "disengage", "safe place", "away from the fight", "get away", "back away"])) {
    intent = "escape";
    actionKey = "move";
    requestedEffect = "reach_safety";
    objective = includesAny(normalized, ["safe place", "safety", "safe zone", "away from the fight"]) ? "safety" : "distance";
  } else if (includesAny(normalized, ["rest", "sleep", "nap", "heal up", "recover", "catch my breath", "regain strength"])) {
    intent = "rest";
    actionKey = "rest";
    requestedEffect = wantsFullRecovery ? "full_recovery" : requestsShortRest(normalized) ? "short_recovery" : "recover_hp";
  } else if (includesAny(normalized, ["trap", "ambush", "snare", "set up", "prepare killzone", "kill zone"])) {
    intent = "environment_control";
    actionKey = "typed";
    requestedEffect = "prepare_trap";
  } else if (includesAny(normalized, ["map", "chart", "draw a map", "map out", "survey the area", "survey"])) {
    intent = "map_area";
    actionKey = "look";
    requestedEffect = "increase_exploration";
  } else if (includesAny(normalized, ["scout", "search the area", "explore", "recon", "look around", "observe the area"])) {
    intent = "scout_area";
    actionKey = "look";
    requestedEffect = "increase_exploration";
  } else if (includesAny(normalized, ["plan", "prepare", "next move", "strategy", "decide what to do"])) {
    intent = "plan_next_move";
    actionKey = "appraise";
    requestedEffect = "tactical_plan";
  } else if (
    includesAny(normalized, ["boss room", "boss", "floor guardian", "guardian", "way to", "route to", "find a way", "go to", "move toward", "advance"])
  ) {
    intent = "move_toward_objective";
    actionKey = "move";
    requestedEffect = "move";

    if (includesAny(normalized, ["boss room", "boss", "floor guardian", "guardian"])) objective = "boss_room";
    else if (includesAny(normalized, ["exit", "stairs", "deeper", "next floor"])) objective = "deeper_route";
    else objective = "route";
  }

  if (!intent) return null;

  return {
    order: index + 1,
    input: stepText,
    intent,
    approach: getApproach(normalized),
    target: getTargetFromText(normalized),
    secondary_target: intent === "escape"
      ? context.boss
        ? "boss"
        : context.enemy
          ? "enemy"
          : null
      : null,
    risk_level: intent === "escape" || intent === "move_toward_objective" ? "medium" : "low",
    requested_effect: requestedEffect,
    objective,
    duration_hours: intent === "rest"
      ? durationHours || (wantsFullRecovery ? getFullRecoveryDurationHours(context.player) : requestsShortRest(normalized) ? 1 : 2)
      : durationHours,
    desired_full_recovery: intent === "rest" && wantsFullRecovery,
    rest_intensity: intent === "rest"
      ? wantsFullRecovery
        ? "full"
        : requestsShortRest(normalized)
          ? "short"
          : "normal"
      : null,
    action_key: actionKey,
    tags_considered: context.sceneTags || [],
    confidence: 0.82,
    source: "backend_rules"
  };
}

function interpretTextActionPlan(text, context = {}) {
  const steps = splitTextActionSteps(text);
  const usableSteps = steps.length ? steps : [normalizeText(text)].filter(Boolean);
  const interpretedSteps = usableSteps.map((stepText, index) => {
    const utilityStep = interpretUtilityStep(stepText, index, context);

    if (utilityStep) return utilityStep;

    return {
      order: index + 1,
      input: stepText,
      action_key: "typed",
      ...interpretTextAction(stepText, context)
    };
  });

  return {
    intent: interpretedSteps.length > 1 ? "sequence" : interpretedSteps[0]?.intent || "invalid",
    is_sequence: interpretedSteps.length > 1,
    step_count: interpretedSteps.length,
    steps: interpretedSteps,
    source: "backend_rules"
  };
}

function getCostProfile(interpretation) {
  if (interpretation.intent === "escape") {
    return { timeCostHours: 1, hpRiskCost: 1 };
  }

  if (interpretation.intent === "rest") {
    return { timeCostHours: interpretation.duration_hours || 2, hpRiskCost: 0 };
  }

  if (["map_area", "scout_area", "plan_next_move", "move_toward_objective"].includes(interpretation.intent)) {
    return { timeCostHours: 1, hpRiskCost: 0 };
  }

  const riskCost = { low: 1, medium: 2, high: 3 }[interpretation.risk_level] || 1;
  const hpRisk = interpretation.risk_level === "high" ? 2 : interpretation.risk_level === "medium" ? 1 : 0;

  if (["observe", "inspect_remains", "social"].includes(interpretation.intent)) {
    return { timeCostHours: 1, hpRiskCost: 0 };
  }

  if (["heavy_attack", "environment_attack", "force_object"].includes(interpretation.intent)) {
    return { timeCostHours: riskCost, hpRiskCost: hpRisk };
  }

  return { timeCostHours: 1, hpRiskCost: hpRisk };
}

function calculateEnemyDamage(enemy, player, mitigation = 0) {
  const raw = Number(enemy.attack_stat || 0) - Math.floor(Number(player.stamina_stat || 0) / 2) - mitigation;
  return clamp(raw, 0, 999);
}

function getStatScore(player, interpretation) {
  const strength = Number(player.strength_stat || 0);
  const dexterity = Number(player.dexterity_stat || 0);
  const stamina = Number(player.stamina_stat || 0);
  const intelligence = Number(player.intelligence_stat || 0);
  const wisdom = Number(player.wisdom_stat || 0);
  const charisma = Number(player.charisma_stat || 0);

  if (interpretation.intent === "precision_attack") return dexterity + Math.floor(intelligence / 2);
  if (interpretation.intent === "environment_attack") return Math.max(strength, intelligence) + Math.floor(wisdom / 2);
  if (interpretation.intent === "defend") return stamina + Math.floor(wisdom / 2);
  if (interpretation.intent === "hide") return dexterity + Math.floor(wisdom / 2);
  if (interpretation.intent === "social") return charisma + Math.floor(wisdom / 2);
  if (interpretation.intent === "force_object" || interpretation.intent === "heavy_attack") return strength + Math.floor(stamina / 2);
  return strength + Math.floor(dexterity / 2);
}

function getDifficulty(interpretation, opponent) {
  const opponentLevel = Number(opponent?.level || 1);
  const opponentDefense = Number(opponent?.defense_stat || 0);
  const opponentSpeed = Number(opponent?.speed_stat || 0);
  const riskMod = { low: 2, medium: 5, high: 8 }[interpretation.risk_level] || 2;

  if (interpretation.intent === "escape") return 6 + opponentSpeed + opponentLevel + riskMod + (opponent?.isBoss ? 4 : 0);
  if (interpretation.intent === "environment_attack") return 7 + opponentLevel + riskMod;
  if (interpretation.intent === "precision_attack") return 5 + opponentSpeed + riskMod;
  if (interpretation.intent === "social") return 6 + Number(opponent?.intelligence_stat || 0);
  return 4 + opponentDefense + riskMod;
}

function resolveEscapeOutcome({ player, opponent, interpretation, sceneTags }) {
  if (!opponent) {
    const roll = Math.floor(Math.random() * 20) + 1;
    return { type: "success", roll, total: roll + Number(player.dexterity_stat || 0), difficulty: 6 };
  }

  const dexterity = Number(player.dexterity_stat || 0);
  const stamina = Number(player.stamina_stat || 0);
  const wisdom = Number(player.wisdom_stat || 0);
  const hp = Number(player.hp || 0);
  const maxHp = Number(player.max_hp || 1);
  const hpRatio = maxHp > 0 ? hp / maxHp : 0;
  const opponentSpeed = Number(opponent?.speed_stat || 0);
  const opponentLevel = Number(opponent?.level || 1);
  const pressure = opponent
    ? opponentSpeed + Math.floor(opponentLevel / 2) + (opponent.isBoss ? 4 : 0)
    : 0;
  const terrainMod = sceneTags.includes("narrow_space") ? -2 : 0;
  const coverMod = sceneTags.includes("cover_available") ? 2 : 0;
  const darkMod = sceneTags.includes("dark_area") ? 1 : 0;
  const lowHpMod = hpRatio <= 0.25 ? -2 : hpRatio <= 0.5 ? -1 : 0;
  const approachMod = interpretation.approach === "quick" ? 2 : interpretation.approach === "careful" ? 1 : 0;
  const roll = Math.floor(Math.random() * 20) + 1;
  const total = roll + dexterity + Math.floor(stamina / 2) + Math.floor(wisdom / 3) + coverMod + darkMod + terrainMod + lowHpMod + approachMod;
  const difficulty = opponent ? 9 + pressure : 8;

  if (total >= difficulty + 6) return { type: "success", roll, total, difficulty };
  if (total >= difficulty) return { type: "partial_success", roll, total, difficulty };
  if (opponent && roll <= 4) return { type: "backfire", roll, total, difficulty };
  return { type: "fail", roll, total, difficulty };
}

function getEscapeDangerLevel({ player, opponent, sceneTags }) {
  const hp = Number(player.hp || 0);
  const maxHp = Number(player.max_hp || 1);
  const hpRatio = maxHp > 0 ? hp / maxHp : 0;
  let score = 0;

  if (opponent) score += opponent.isBoss ? 4 : 2;
  if (Number(opponent?.speed_stat || 0) >= Number(player.dexterity_stat || 0)) score += 2;
  if (hpRatio <= 0.25) score += 2;
  else if (hpRatio <= 0.5) score += 1;
  if (sceneTags.includes("narrow_space")) score += 2;
  if (sceneTags.includes("sealed_door")) score += 1;
  if (sceneTags.includes("cover_available")) score -= 1;
  if (sceneTags.includes("dark_area")) score -= 1;

  if (score >= 6) return "severe";
  if (score >= 4) return "high";
  if (score >= 2) return "medium";
  return "low";
}

function getEnemyAwareness(opponent, sceneTags) {
  if (!opponent) return "none";
  let score = opponent.isBoss ? 3 : 1;

  if (Number(opponent.intelligence_stat || 0) >= 5) score += 1;
  if (Number(opponent.speed_stat || 0) >= 5) score += 1;
  if (sceneTags.includes("dark_area")) score -= 1;
  if (sceneTags.includes("low_visibility")) score -= 1;

  if (score >= 4) return "locked_on";
  if (score >= 2) return "alert";
  return "searching";
}

function getPositionPressure(sceneTags) {
  if (sceneTags.includes("narrow_space")) return "tight";
  if (sceneTags.includes("sealed_door")) return "sealed";
  if (sceneTags.includes("cover_available")) return "covered";
  if (sceneTags.includes("dark_area")) return "obscured";
  if (sceneTags.includes("uneven_terrain")) return "unstable";
  return "open";
}

function chooseEscapeWorldReaction({ player, opponent, interpretation, sceneTags, outcome }) {
  const dangerLevel = getEscapeDangerLevel({ player, opponent, sceneTags });
  const awareness = getEnemyAwareness(opponent, sceneTags);
  const position = getPositionPressure(sceneTags);
  const actor = opponent?.name || "the dungeon";
  const isSafetyGoal = interpretation.objective === "safety" || interpretation.requested_effect === "reach_safety";
  let type = "lost_pursuit";
  let label = "Pursuit Broken";
  let description = `${actor} loses the player's line of movement.`;
  let movementResult = "escaped";
  let nextSituation = isSafetyGoal ? "safer_ground" : "new_route";
  let damageModifier = 0;
  let pressureDelta = -2;

  if (outcome.type === "success") {
    if (position === "obscured" || sceneTags.includes("low_visibility")) {
      type = "vanished_into_cover";
      label = "Vanished Into Cover";
      description = `The area hides the player's retreat before ${actor} can keep a clean line.`;
    } else if (position === "sealed") {
      type = "route_slipped";
      label = "Seal Route Slipped";
      description = `The player finds a narrow route through the seal pressure and breaks contact.`;
    }
  } else if (outcome.type === "partial_success") {
    movementResult = "moved_under_pressure";
    nextSituation = "temporary_cover";
    pressureDelta = 1;

    if (awareness === "locked_on" || opponent?.isBoss) {
      type = "chased";
      label = "Chased Through the Dungeon";
      description = `${actor} keeps pressure on the retreat and forces the player to move under pursuit.`;
      damageModifier = 1;
    } else if (position === "tight" || position === "sealed") {
      type = "rerouted";
      label = "Rerouted Under Pressure";
      description = `The direct route closes, forcing the player into a worse but survivable side path.`;
    } else {
      type = "temporary_cover";
      label = "Temporary Cover";
      description = `The player reaches cover, but the danger has not fully lost them.`;
    }
  } else if (outcome.type === "backfire") {
    type = "cornered";
    label = "Cornered";
    description = `${actor} reads the escape attempt and drives the player into a bad position.`;
    movementResult = "cornered";
    nextSituation = "cornered";
    damageModifier = 2;
    pressureDelta = 3;
  } else {
    movementResult = "blocked";
    nextSituation = "still_in_danger";
    pressureDelta = 2;

    if (position === "tight" || position === "sealed" || opponent?.isBoss) {
      type = "blocked_path";
      label = "Path Blocked";
      description = `${actor} cuts off the route before the player can turn it into distance.`;
      damageModifier = 1;
    } else {
      type = "intercepted";
      label = "Intercepted";
      description = `${actor} closes the gap and interrupts the retreat.`;
    }
  }

  return {
    type,
    label,
    description,
    danger_level: dangerLevel,
    enemy_awareness: awareness,
    position_pressure: position,
    movement_result: movementResult,
    next_situation: nextSituation,
    pressure_delta: pressureDelta,
    damage_modifier: damageModifier
  };
}

function rollOutcome({ player, opponent, interpretation, sceneTags }) {
  const score = getStatScore(player, interpretation);
  const difficulty = getDifficulty(interpretation, opponent);
  const tagBonus = interpretation.intent.startsWith("environment") && sceneTags.includes(TARGET_TAGS[interpretation.target])
    ? 2
    : 0;
  const roll = Math.floor(Math.random() * 20) + 1;
  const total = roll + score + tagBonus;

  if (total >= difficulty + 8) return { type: "success", roll, total, difficulty };
  if (total >= difficulty) return { type: "partial_success", roll, total, difficulty };
  if (interpretation.risk_level === "high" && roll <= 5) return { type: "backfire", roll, total, difficulty };
  return { type: "fail", roll, total, difficulty };
}

function calculatePlayerDamage(player, opponent, interpretation, outcomeType) {
  if (!["direct_attack", "precision_attack", "heavy_attack", "environment_attack"].includes(interpretation.intent)) {
    return 0;
  }

  const strength = Number(player.strength_stat || 0);
  const dexterity = Number(player.dexterity_stat || 0);
  const intelligence = Number(player.intelligence_stat || 0);
  const enemyDefense = Number(opponent?.defense_stat || 0);
  let base = strength - Math.floor(enemyDefense / 2);

  if (interpretation.intent === "precision_attack") {
    base = Math.floor((dexterity + intelligence) / 2) - Math.floor(enemyDefense / 3);
  }

  if (interpretation.intent === "heavy_attack") base += 4;
  if (interpretation.intent === "environment_attack") base = Math.max(strength, intelligence) + 3 - Math.floor(enemyDefense / 3);
  if (interpretation.risk_level === "high") base += 2;
  if (outcomeType === "partial_success") base = Math.floor(base / 2);
  if (["fail", "backfire"].includes(outcomeType)) base = 0;

  return clamp(base, 0, 999);
}

function invalidResolution(input, interpretation, reason) {
  return {
    input,
    normalized: "typed",
    resolved_intent: interpretation.intent,
    resolution_type: "invalid_attempt",
    effect_applied: {
      type: "none",
      reason
    },
    battleResult: null,
    playerHpAfter: null,
    enemyHpAfter: null,
    cost: getCostProfile(interpretation),
    narrationOutcome: reason
  };
}

async function getActiveRemains(conn, playerId) {
  const [rows] = await conn.query(
    `SELECT *
     FROM player_remains
     WHERE player_id = ?
       AND consumed_at IS NULL
       AND expires_at > CURRENT_TIMESTAMP
     ORDER BY created_at DESC
     LIMIT 3`,
    [playerId]
  );

  return rows;
}

async function createRemains(conn, { playerId, enemyName, enemyType, sourceType, sourceId }) {
  await conn.query(
    `INSERT INTO player_remains (
      player_id,
      source_type,
      source_id,
      enemy_name,
      enemy_type,
      loot_state,
      inspect_state,
      expires_at
    ) VALUES (?, ?, ?, ?, ?, 'available', 'available', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 6 HOUR))`,
    [playerId, sourceType, sourceId || null, enemyName, enemyType || null]
  );
}

async function consumeRemain(conn, remainId, field) {
  if (field === "devour") {
    await conn.query(
      `UPDATE player_remains
       SET loot_state = 'claimed',
           inspect_state = 'claimed',
           consumed_at = CURRENT_TIMESTAMP
       WHERE id = ?`,
      [remainId]
    );
    return;
  }

  const stateField = field === "inspect" ? "inspect_state" : "loot_state";
  const otherStateField = field === "inspect" ? "loot_state" : "inspect_state";
  await conn.query(
    `UPDATE player_remains
     SET ${stateField} = 'claimed',
         consumed_at = CASE
           WHEN ${otherStateField} = 'claimed' THEN CURRENT_TIMESTAMP
           ELSE consumed_at
         END
     WHERE id = ?`,
    [remainId]
  );
}

async function resolveRemainAction(conn, { player, input, interpretation, remains }) {
  const remain = remains[0];
  const cost = getCostProfile(interpretation);

  if (!remain) {
    return invalidResolution(input, interpretation, "No usable remains are present in the current scene.");
  }

  if (interpretation.intent === "loot_remains" && remain.loot_state !== "available") {
    return invalidResolution(input, interpretation, "These remains have already been searched.");
  }

  if (interpretation.intent === "inspect_remains" && remain.inspect_state !== "available") {
    return invalidResolution(input, interpretation, "These remains have already been inspected.");
  }

  if (interpretation.intent === "devour_remains" && remain.loot_state !== "available") {
    return invalidResolution(input, interpretation, "These remains no longer have anything useful to consume.");
  }

  const effect = {
    type: interpretation.intent,
    target: remain.enemy_name,
    source_type: remain.source_type
  };

  if (interpretation.intent === "loot_remains") {
    await consumeRemain(conn, remain.id, "loot");
    effect.reward = { kind: "scrap", amount: 1 };
  }

  if (interpretation.intent === "inspect_remains") {
    await consumeRemain(conn, remain.id, "inspect");
    effect.reward = { kind: "information", enemy_type: remain.enemy_type };
  }

  if (interpretation.intent === "devour_remains") {
    await consumeRemain(conn, remain.id, "devour");
    effect.reward = { kind: "hp", amount: 2 };
    effect.hp_after = Math.min(Number(player.max_hp || 0), Number(player.hp || 0) + 2);
  }

  return {
    input,
    normalized: "typed",
    resolved_intent: interpretation.intent,
    resolution_type: "success",
    effect_applied: effect,
    battleResult: null,
    playerHpAfter: effect.hp_after || Number(player.hp || 0),
    enemyHpAfter: null,
    cost,
    narrationOutcome: `${titleCase(interpretation.intent)} succeeds on ${remain.enemy_name}.`
  };
}

async function resolveTextAction(conn, { player, input, interpretation, enemy, boss, sceneTags = [], remains = [] }) {
  const opponent = getActiveOpponent(enemy, boss);

  if (interpretation.intent === "rest") {
    const cost = getCostProfile(interpretation);
    if (opponent) {
      const enemyDamage = calculateEnemyDamage(opponent, player, 0);
      const playerHpAfter = Math.max(0, Number(player.hp || 0) - enemyDamage);

      return {
        input,
        normalized: "typed",
        resolved_intent: interpretation.intent,
        resolution_type: "interrupted",
        effect_applied: {
          type: "rest",
          area: player.current_area,
          heal_amount: 0,
          hp_after: playerHpAfter,
          duration_hours: 1,
          interrupted: true,
          world_reaction: {
            type: "rest_interrupted",
            label: "Rest Interrupted",
            description: `${opponent.name} does not allow recovery while the player remains within reach.`,
            danger_level: getEscapeDangerLevel({ player, opponent, sceneTags }),
            enemy_awareness: getEnemyAwareness(opponent, sceneTags),
            movement_result: "held_in_danger",
            next_situation: "under_pressure",
            pressure_delta: 2
          },
          enemy_pressure: {
            name: opponent.name,
            type: opponent.isBoss ? "boss" : "enemy",
            speed: opponent.speed_stat,
            level: opponent.level
          },
          damage_taken: enemyDamage
        },
        battleResult: null,
        playerHpAfter,
        enemyHpAfter: opponent.currentHp,
        cost: { timeCostHours: 1, hpRiskCost: 1 },
        narrationOutcome: `The player tries to rest in ${player.current_area}, but ${opponent.name} interrupts the recovery.`
      };
    }

    const healAmount = interpretation.desired_full_recovery
      ? Math.max(0, Number(player.max_hp || 0) - Number(player.hp || 0))
      : interpretation.rest_intensity === "short"
        ? 3
        : Math.max(3, Math.ceil(cost.timeCostHours / 2) * 5);
    const hpAfter = Math.min(Number(player.max_hp || 0), Number(player.hp || 0) + healAmount);

    return {
      input,
      normalized: "typed",
      resolved_intent: interpretation.intent,
      resolution_type: "success",
      effect_applied: {
        type: "rest",
        area: player.current_area,
        heal_amount: hpAfter - Number(player.hp || 0),
        hp_after: hpAfter,
        duration_hours: cost.timeCostHours,
        desired_full_recovery: !!interpretation.desired_full_recovery,
        rest_intensity: interpretation.rest_intensity || "normal",
        recovery_complete: hpAfter >= Number(player.max_hp || 0)
      },
      battleResult: null,
      playerHpAfter: hpAfter,
      enemyHpAfter: null,
      cost,
      narrationOutcome: interpretation.desired_full_recovery
        ? `The player rests until recovery reaches ${hpAfter}/${player.max_hp} HP.`
        : interpretation.rest_intensity === "short"
          ? `The player takes a short nap for ${cost.timeCostHours} hour${cost.timeCostHours === 1 ? "" : "s"} and recovers lightly.`
        : `The player rests for ${cost.timeCostHours} hour${cost.timeCostHours === 1 ? "" : "s"} and recovers.`
    };
  }

  if (interpretation.intent === "escape") {
    const cost = getCostProfile(interpretation);
    const outcome = resolveEscapeOutcome({ player, opponent, interpretation, sceneTags });
    const worldReaction = chooseEscapeWorldReaction({ player, opponent, interpretation, sceneTags, outcome });
    const escaped = outcome.type === "success";
    const reachedTemporarySafety = outcome.type === "partial_success";
    const enemyDamage = opponent && ["partial_success", "fail", "backfire"].includes(outcome.type)
      ? calculateEnemyDamage(opponent, player, outcome.type === "partial_success" ? 2 : 0)
        + (outcome.type === "backfire" ? 1 : 0)
        + worldReaction.damage_modifier
      : 0;
    const playerHpAfter = Math.max(0, Number(player.hp || 0) - enemyDamage);
    const safetyState = escaped
      ? "escaped"
      : reachedTemporarySafety
        ? "temporary_safety"
        : "still_in_danger";

    return {
      input,
      normalized: "typed",
      resolved_intent: interpretation.intent,
      resolution_type: outcome.type,
      effect_applied: {
        type: "escape",
        area_before: player.current_area,
        target: interpretation.secondary_target,
        requested_effect: interpretation.requested_effect,
        safety_state: safetyState,
        escaped,
        reached_temporary_safety: reachedTemporarySafety,
        world_reaction: worldReaction,
        enemy_pressure: opponent
          ? {
              name: opponent.name,
              type: opponent.isBoss ? "boss" : "enemy",
              speed: opponent.speed_stat,
              level: opponent.level
            }
          : null,
        chase_damage: enemyDamage,
        hp_after: playerHpAfter,
        moved: ["escaped", "moved_under_pressure"].includes(worldReaction.movement_result),
        tags_used: sceneTags,
        roll: outcome.roll,
        total: outcome.total,
        difficulty: outcome.difficulty
      },
      battleResult: null,
      playerHpAfter,
      enemyHpAfter: opponent?.currentHp ?? null,
      cost,
      narrationOutcome: escaped
        ? `The player tries to escape. ${worldReaction.description}`
        : reachedTemporarySafety
          ? `The player tries to escape. ${worldReaction.description}`
          : enemyDamage > 0
            ? `The player tries to escape. ${worldReaction.description} The retreat costs blood.`
            : `The player tries to escape. ${worldReaction.description}`
    };
  }

  if (["map_area", "scout_area", "plan_next_move", "move_toward_objective"].includes(interpretation.intent)) {
    const cost = getCostProfile(interpretation);
    if (opponent && interpretation.intent === "move_toward_objective") {
      const enemyDamage = calculateEnemyDamage(opponent, player, 1);
      const playerHpAfter = Math.max(0, Number(player.hp || 0) - enemyDamage);

      return {
        input,
        normalized: "typed",
        resolved_intent: interpretation.intent,
        resolution_type: "blocked",
        effect_applied: {
          type: interpretation.intent,
          area: player.current_area,
          requested_effect: interpretation.requested_effect,
          objective: interpretation.objective || null,
          moved: false,
          hp_after: playerHpAfter,
          damage_taken: enemyDamage,
          world_reaction: {
            type: "advance_blocked",
            label: "Advance Blocked",
            description: `${opponent.name} controls the route and prevents clean movement toward the objective.`,
            danger_level: getEscapeDangerLevel({ player, opponent, sceneTags }),
            enemy_awareness: getEnemyAwareness(opponent, sceneTags),
            movement_result: "blocked",
            next_situation: "must_deal_with_threat",
            pressure_delta: 2
          },
          enemy_pressure: {
            name: opponent.name,
            type: opponent.isBoss ? "boss" : "enemy",
            speed: opponent.speed_stat,
            level: opponent.level
          },
          tags_used: sceneTags
        },
        battleResult: null,
        playerHpAfter,
        enemyHpAfter: opponent.currentHp,
        cost,
        narrationOutcome: `The player tries to push toward the objective, but ${opponent.name} blocks the route.`
      };
    }

    return {
      input,
      normalized: "typed",
      resolved_intent: interpretation.intent,
      resolution_type: "success",
      effect_applied: {
        type: interpretation.intent,
        area: player.current_area,
        requested_effect: interpretation.requested_effect,
        objective: interpretation.objective || null,
        tags_used: sceneTags
      },
      battleResult: null,
      playerHpAfter: Number(player.hp || 0),
      enemyHpAfter: null,
      cost,
      narrationOutcome: `The player completes ${titleCase(interpretation.intent)}.`
    };
  }

  if (["loot_remains", "inspect_remains", "devour_remains"].includes(interpretation.intent)) {
    return resolveRemainAction(conn, { player, input, interpretation, remains });
  }

  const cost = getCostProfile(interpretation);

  if (interpretation.intent === "invalid") {
    return invalidResolution(input, interpretation, "The action could not be understood as a playable attempt.");
  }

  if (interpretation.intent === "environment_attack") {
    const requiredTag = TARGET_TAGS[interpretation.target];

    if (!requiredTag || !sceneTags.includes(requiredTag)) {
      return invalidResolution(input, interpretation, `The scene does not currently support ${interpretation.target || "that environmental object"}.`);
    }
  }

  if (interpretation.intent === "force_object" && !sceneTags.includes("sealed_door")) {
    return invalidResolution(input, interpretation, "There is no forceable sealed door in the current scene.");
  }

  if (["direct_attack", "precision_attack", "heavy_attack", "environment_attack", "social"].includes(interpretation.intent) && !opponent) {
    return invalidResolution(input, interpretation, "No active enemy or boss is present for that attempt.");
  }

  if (interpretation.intent === "environment_control" && interpretation.requested_effect === "gain_cover" && !sceneTags.includes("cover_available")) {
    return invalidResolution(input, interpretation, "There is no usable cover in the current scene.");
  }

  if (["observe", "hide", "defend", "environment_control", "force_object"].includes(interpretation.intent) && !opponent) {
    const effectType = interpretation.intent === "hide" ? "stealth_position" : interpretation.intent;
    return {
      input,
      normalized: "typed",
      resolved_intent: interpretation.intent,
      resolution_type: "success",
      effect_applied: {
        type: effectType,
        area: player.current_area,
        tags_used: sceneTags,
        requested_effect: interpretation.requested_effect
      },
      battleResult: null,
      playerHpAfter: Number(player.hp || 0),
      enemyHpAfter: null,
      cost,
      narrationOutcome: `The player completes a ${interpretation.intent} action.`
    };
  }

  const outcome = rollOutcome({ player, opponent, interpretation, sceneTags });
  const damage = calculatePlayerDamage(player, opponent, interpretation, outcome.type);
  let enemyHpAfter = opponent ? Math.max(0, opponent.currentHp - damage) : null;
  let enemyDamage = 0;
  let playerHpAfter = Number(player.hp || 0);

  if (opponent && enemyHpAfter > 0) {
    const mitigation = interpretation.intent === "defend" ? 3 : interpretation.intent === "hide" ? 1 : 0;
    enemyDamage = calculateEnemyDamage(opponent, player, mitigation);
    if (outcome.type === "success" && ["defend", "hide", "social", "environment_control"].includes(interpretation.intent)) {
      enemyDamage = Math.floor(enemyDamage / 2);
    }
    if (outcome.type === "backfire") enemyDamage += cost.hpRiskCost + 1;
    playerHpAfter = Math.max(0, playerHpAfter - enemyDamage);
  }

  if (!opponent && outcome.type === "backfire") {
    playerHpAfter = Math.max(0, playerHpAfter - cost.hpRiskCost);
  }

  let resultTag = "ongoing";
  if (enemyHpAfter !== null && enemyHpAfter <= 0) resultTag = "enemy_defeated";
  if (playerHpAfter <= 0) resultTag = "player_defeated";
  if (enemyHpAfter !== null && enemyHpAfter <= 0 && playerHpAfter <= 0) resultTag = "double_ko";

  const battleResult = opponent
    ? {
        playerAction: `typed:${interpretation.intent}`,
        enemyAction: "attack",
        playerDamageDealt: damage,
        enemyDamageDealt: enemyDamage,
        playerHpAfter,
        enemyHpAfter,
        resultTag,
        resolutionType: outcome.type
      }
    : null;

  return {
    input,
    normalized: "typed",
    resolved_intent: interpretation.intent,
    resolution_type: outcome.type,
    effect_applied: {
      type: interpretation.intent,
      area: player.current_area,
      target: interpretation.target,
      secondary_target: interpretation.secondary_target,
      requested_effect: interpretation.requested_effect,
      damage,
      enemy_damage: enemyDamage,
      tags_used: sceneTags,
      roll: outcome.roll,
      total: outcome.total,
      difficulty: outcome.difficulty
    },
    battleResult,
    playerHpAfter,
    enemyHpAfter,
    cost,
    narrationOutcome: `${titleCase(interpretation.intent)} resolved as ${outcome.type}.`
  };
}

async function logTextActionInterpretation(conn, { playerId, actionText, interpretation, resolution }) {
  await conn.query(
    `INSERT INTO player_text_action_interpretations (
      player_id,
      action_text,
      interpretation_json,
      resolution_json,
      resolved_intent,
      resolution_type
    ) VALUES (?, ?, ?, ?, ?, ?)`,
    [
      playerId,
      actionText,
      JSON.stringify(interpretation),
      JSON.stringify({
        effect_applied: resolution.effect_applied,
        cost: resolution.cost
      }),
      resolution.resolved_intent,
      resolution.resolution_type
    ]
  );
}

module.exports = {
  createRemains,
  deriveSceneTags,
  getActiveOpponent,
  getActiveRemains,
  interpretTextAction,
  interpretTextActionPlan,
  logTextActionInterpretation,
  resolveTextAction
};
