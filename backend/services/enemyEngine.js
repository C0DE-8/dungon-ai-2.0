function slugify(value = "") {
  const slug = String(value)
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9\s-]/g, "")
    .replace(/\s+/g, "_")
    .replace(/_+/g, "_")
    .replace(/^_|_$/g, "");

  return slug || "unknown";
}

const RARITY_WEIGHTS = {
  common: 70,
  uncommon: 22,
  rare: 7,
  elite: 1
};

const AREA_TAGS = [
  "broken",
  "hall",
  "silent",
  "junction",
  "dust",
  "chamber",
  "narrow",
  "descent",
  "sealed",
  "passage",
  "unknown"
];

const MONSTER_POOLS = [
  {
    floorMin: 1,
    floorMax: 5,
    monsters: [
      {
        name: "Goblin Scout",
        rarity: "common",
        areaTags: ["hall", "junction", "passage"],
        levelOffset: 0,
        hp: 18,
        attack_stat: 4,
        defense_stat: 2,
        speed_stat: 3,
        intelligence_stat: 2,
        reward_exp: 10,
        description: "A small green scavenger that maps weak paths through the lower dungeon."
      },
      {
        name: "Dust Skitter",
        rarity: "common",
        areaTags: ["dust", "chamber", "unknown"],
        levelOffset: 0,
        hp: 15,
        attack_stat: 3,
        defense_stat: 1,
        speed_stat: 5,
        intelligence_stat: 1,
        reward_exp: 8,
        description: "A many-legged scavenger that hides under powdery dungeon debris."
      },
      {
        name: "Cracked Bone Rat",
        rarity: "common",
        areaTags: ["broken", "hall", "descent"],
        levelOffset: 0,
        hp: 16,
        attack_stat: 4,
        defense_stat: 1,
        speed_stat: 4,
        intelligence_stat: 1,
        reward_exp: 9,
        description: "A bone-plated rat drawn to fractures in old stone."
      },
      {
        name: "Silent Leech",
        rarity: "uncommon",
        areaTags: ["silent", "junction", "chamber"],
        levelOffset: 1,
        hp: 22,
        attack_stat: 4,
        defense_stat: 2,
        speed_stat: 2,
        intelligence_stat: 2,
        reward_exp: 14,
        description: "A pale parasite that waits where sound is swallowed."
      },
      {
        name: "Seal Gnawer",
        rarity: "rare",
        areaTags: ["sealed", "passage"],
        levelOffset: 1,
        hp: 26,
        attack_stat: 5,
        defense_stat: 3,
        speed_stat: 2,
        intelligence_stat: 3,
        reward_exp: 20,
        description: "A rune-bitten creature that feeds on weak seals and hidden doors."
      },
      {
        name: "Lower Floor Stalker",
        rarity: "elite",
        areaTags: ["narrow", "descent", "sealed"],
        levelOffset: 2,
        hp: 34,
        attack_stat: 7,
        defense_stat: 4,
        speed_stat: 4,
        intelligence_stat: 3,
        reward_exp: 34,
        description: "An unusually disciplined predator that claims the lower floor routes."
      }
    ]
  },
  {
    floorMin: 6,
    floorMax: 15,
    monsters: [
      {
        name: "Ironcap Gnoll",
        rarity: "common",
        areaTags: ["hall", "junction", "broken"],
        levelOffset: 0,
        hp: 30,
        attack_stat: 7,
        defense_stat: 4,
        speed_stat: 3,
        intelligence_stat: 2,
        reward_exp: 24,
        description: "A low-ranking pack fighter wearing scrap metal like a crown."
      },
      {
        name: "Ash Mite Swarm",
        rarity: "common",
        areaTags: ["dust", "chamber", "passage"],
        levelOffset: 0,
        hp: 26,
        attack_stat: 6,
        defense_stat: 2,
        speed_stat: 6,
        intelligence_stat: 1,
        reward_exp: 22,
        description: "A churning swarm that rises from ash-filled floor seams."
      },
      {
        name: "Blind Hookclaw",
        rarity: "uncommon",
        areaTags: ["silent", "narrow", "descent"],
        levelOffset: 1,
        hp: 36,
        attack_stat: 8,
        defense_stat: 3,
        speed_stat: 5,
        intelligence_stat: 2,
        reward_exp: 30,
        description: "A blind hunter that listens for breath through curved claws."
      },
      {
        name: "Runebark Husk",
        rarity: "rare",
        areaTags: ["sealed", "passage", "chamber"],
        levelOffset: 2,
        hp: 44,
        attack_stat: 7,
        defense_stat: 7,
        speed_stat: 2,
        intelligence_stat: 4,
        reward_exp: 42,
        description: "A dry husk animated by failed sealing script."
      },
      {
        name: "Red-Eyed Pack Elder",
        rarity: "elite",
        areaTags: ["hall", "junction", "descent"],
        levelOffset: 3,
        hp: 58,
        attack_stat: 11,
        defense_stat: 6,
        speed_stat: 5,
        intelligence_stat: 5,
        reward_exp: 70,
        description: "A veteran pack leader that remembers every wounded intruder."
      }
    ]
  },
  {
    floorMin: 16,
    floorMax: 30,
    monsters: [
      {
        name: "Glassback Lurker",
        rarity: "common",
        areaTags: ["chamber", "silent", "unknown"],
        levelOffset: 0,
        hp: 52,
        attack_stat: 11,
        defense_stat: 6,
        speed_stat: 5,
        intelligence_stat: 3,
        reward_exp: 58,
        description: "A translucent ambusher that bends dim light across its spine."
      },
      {
        name: "Mawroot Crawler",
        rarity: "common",
        areaTags: ["broken", "dust", "passage"],
        levelOffset: 0,
        hp: 60,
        attack_stat: 10,
        defense_stat: 8,
        speed_stat: 3,
        intelligence_stat: 2,
        reward_exp: 60,
        description: "A root-like crawler with a split jaw and stone-splinter teeth."
      },
      {
        name: "Echo Knight Remnant",
        rarity: "uncommon",
        areaTags: ["hall", "sealed", "junction"],
        levelOffset: 2,
        hp: 72,
        attack_stat: 13,
        defense_stat: 9,
        speed_stat: 4,
        intelligence_stat: 5,
        reward_exp: 82,
        description: "The repeating combat memory of someone who never left the dungeon."
      },
      {
        name: "Black Seal Marionette",
        rarity: "rare",
        areaTags: ["sealed", "passage", "descent"],
        levelOffset: 3,
        hp: 88,
        attack_stat: 15,
        defense_stat: 10,
        speed_stat: 5,
        intelligence_stat: 7,
        reward_exp: 120,
        description: "A puppet body dragged by threads of old floor authority."
      },
      {
        name: "Abyss-Touched Executioner",
        rarity: "elite",
        areaTags: ["narrow", "descent", "sealed"],
        levelOffset: 5,
        hp: 118,
        attack_stat: 20,
        defense_stat: 12,
        speed_stat: 6,
        intelligence_stat: 7,
        reward_exp: 190,
        description: "A towering elite that appears only where the dungeon pressure thickens."
      }
    ]
  },
  {
    floorMin: 31,
    floorMax: 100,
    monsters: [
      {
        name: "Depthborn Ravager",
        rarity: "common",
        areaTags: ["hall", "broken", "junction", "unknown"],
        levelOffset: 0,
        hp: 90,
        attack_stat: 18,
        defense_stat: 10,
        speed_stat: 6,
        intelligence_stat: 4,
        reward_exp: 125,
        description: "A hardened dungeon predator adapted to deep-floor pressure."
      },
      {
        name: "Pale Choir Wisp",
        rarity: "uncommon",
        areaTags: ["silent", "chamber", "sealed"],
        levelOffset: 2,
        hp: 76,
        attack_stat: 17,
        defense_stat: 8,
        speed_stat: 9,
        intelligence_stat: 8,
        reward_exp: 145,
        description: "A singing spirit cluster that distorts instinct and direction."
      },
      {
        name: "Vault Carapace",
        rarity: "rare",
        areaTags: ["sealed", "passage", "descent"],
        levelOffset: 4,
        hp: 135,
        attack_stat: 20,
        defense_stat: 18,
        speed_stat: 3,
        intelligence_stat: 5,
        reward_exp: 230,
        description: "A living vault shell that guards routes the floor has tried to forget."
      },
      {
        name: "Ancient Hunger",
        rarity: "elite",
        areaTags: ["narrow", "descent", "silent", "sealed"],
        levelOffset: 7,
        hp: 180,
        attack_stat: 28,
        defense_stat: 18,
        speed_stat: 8,
        intelligence_stat: 10,
        reward_exp: 380,
        description: "A named elite presence old enough to hunt by memory alone."
      }
    ]
  }
];

function getAreaTags(area = "Unknown Chamber") {
  const areaSlug = slugify(area);
  const tags = AREA_TAGS.filter((tag) => areaSlug.includes(tag));

  return tags.length ? tags : ["unknown"];
}

function getMonsterPoolForFloor(floor = 1) {
  const normalizedFloor = Number(floor) || 1;

  return MONSTER_POOLS.find((pool) => (
    normalizedFloor >= pool.floorMin && normalizedFloor <= pool.floorMax
  )) || MONSTER_POOLS[MONSTER_POOLS.length - 1];
}

function getValidEnemyTemplates({ floor = 1, area = "Unknown Chamber", includeElite = true }) {
  const pool = getMonsterPoolForFloor(floor);
  const areaTags = getAreaTags(area);
  const valid = pool.monsters.filter((monster) => includeElite || monster.rarity !== "elite");
  const weighted = valid.map((monster) => ({
    ...monster,
    area_match: monster.areaTags.some((tag) => areaTags.includes(tag))
  }));
  const hasAreaMatch = weighted.some((monster) => monster.area_match);

  if (hasAreaMatch) return weighted;

  return valid.map((monster) => ({
    ...monster,
    area_match: false
  }));
}

function getEnemyTemplateWeight(template) {
  const rarityWeight = RARITY_WEIGHTS[template.rarity] || RARITY_WEIGHTS.common;

  return template.area_match ? rarityWeight * 3 : rarityWeight;
}

function weightedChoice(items) {
  const totalWeight = items.reduce((sum, item) => (
    sum + getEnemyTemplateWeight(item)
  ), 0);
  let roll = Math.random() * totalWeight;

  for (const item of items) {
    roll -= getEnemyTemplateWeight(item);
    if (roll <= 0) return item;
  }

  return items[items.length - 1];
}

function scaleEnemyTemplate(template, floor = 1) {
  const normalizedFloor = Number(floor) || 1;
  const floorBonus = Math.max(0, normalizedFloor - 1);
  const level = Math.max(1, normalizedFloor + Number(template.levelOffset || 0));
  const hp = template.hp + (floorBonus * 4);

  return {
    name: template.name,
    enemy_type: template.rarity === "common" ? "normal" : template.rarity,
    level,
    hp,
    max_hp: hp,
    attack_stat: template.attack_stat + Math.floor(floorBonus * 0.8),
    defense_stat: template.defense_stat + Math.floor(floorBonus * 0.5),
    speed_stat: template.speed_stat + Math.floor(floorBonus * 0.25),
    intelligence_stat: template.intelligence_stat + Math.floor(floorBonus * 0.25),
    reward_exp: template.reward_exp + (floorBonus * 5),
    description: template.description
  };
}

function pickEnemyTemplate({ floor = 1, area = "Unknown Chamber", progressionTrigger = "ambient" }) {
  const includeElite = ["boss_trigger_revealed", "progression_clue", "hidden_exit_revealed"].includes(progressionTrigger)
    || Math.random() < 0.15;
  const templates = getValidEnemyTemplates({ floor, area, includeElite });

  return scaleEnemyTemplate(weightedChoice(templates), floor);
}

function buildEnemyKey({ name, floor = 1, area = "Unknown Chamber", triggerKey = "ambient" }) {
  const areaKey = slugify(area).slice(0, 48);
  const triggerSegment = slugify(triggerKey).slice(0, 24);

  return [
    slugify(name).slice(0, 36),
    `f${Number(floor) || 1}`,
    `a${areaKey}`,
    `t${triggerSegment}`
  ].join("_");
}

async function findActiveEnemyForContext(conn, { playerId, floor, encounterState = "active" }) {
  const [[enemy]] = await conn.query(
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
       AND pce.encounter_state = ?
       AND e.is_boss = 0
       AND ? BETWEEN e.floor_min AND e.floor_max
     LIMIT 1`,
    [playerId, encounterState, floor]
  );

  return enemy || null;
}

async function findDiscoveredEnemyForContext(conn, { playerId, enemyKey, floor, area, triggerKey }) {
  const areaKey = slugify(area).slice(0, 48);
  const triggerSegment = slugify(triggerKey).slice(0, 24);
  const exactKeyPattern = `%_f${Number(floor) || 1}_a${areaKey}_t${triggerSegment}%`;
  const areaKeyPattern = `%_f${Number(floor) || 1}_a${areaKey}_%`;
  const params = [playerId, floor];
  const exactKeyFilter = enemyKey ? "AND e.enemy_key = ?" : "";

  if (enemyKey) {
    params.push(enemyKey);
  }

  const [[enemy]] = await conn.query(
    `SELECT e.*
     FROM player_enemy_discoveries ped
     INNER JOIN enemies e ON ped.enemy_id = e.id
     WHERE ped.player_id = ?
       AND e.is_boss = 0
       AND ? BETWEEN e.floor_min AND e.floor_max
       ${exactKeyFilter}
     ORDER BY
       CASE
         WHEN e.enemy_key = ? THEN 0
         WHEN e.enemy_key LIKE ? THEN 0
         WHEN e.enemy_key LIKE ? THEN 1
         ELSE 2
       END,
       ped.first_seen_at ASC,
       e.id ASC
     LIMIT 1`,
    [...params, enemyKey || "", exactKeyPattern, areaKeyPattern]
  );

  return enemy || null;
}

async function findCatalogEnemyForContext(conn, { enemyKey, floor, area, triggerKey }) {
  const [[enemy]] = await conn.query(
    `SELECT *
     FROM enemies
     WHERE is_boss = 0
       AND ? BETWEEN floor_min AND floor_max
       AND enemy_key = ?
     LIMIT 1`,
    [floor, enemyKey]
  );

  return enemy || null;
}

async function insertEnemy(conn, { floor, area, triggerKey, template }) {
  const enemyKey = buildEnemyKey({
    name: template.name,
    floor,
    area,
    triggerKey
  });

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

  return enemy;
}

async function createEnemyIfNew(conn, {
  floor = 1,
  area = "Unknown Chamber",
  triggerKey = "ambient",
  template = null
}) {
  const selectedTemplate = template || pickEnemyTemplate({
    floor,
    area,
    progressionTrigger: triggerKey
  });
  const enemyKey = buildEnemyKey({
    name: selectedTemplate.name,
    floor,
    area,
    triggerKey
  });

  const existing = await findCatalogEnemyForContext(conn, {
    enemyKey,
    floor,
    area,
    triggerKey
  });

  if (existing) {
    return { enemy: existing, isNew: false, source: "catalog" };
  }

  const enemy = await insertEnemy(conn, {
    floor,
    area,
    triggerKey,
    template: selectedTemplate
  });
  return { enemy, isNew: true, source: "generated" };
}

async function resolveEnemyEncounter(conn, {
  playerId,
  floor = 1,
  area = "Unknown Chamber",
  progressionTrigger = "ambient",
  encounterState = "active"
}) {
  const normalizedFloor = Number(floor) || 1;
  const triggerKey = progressionTrigger || "ambient";
  const selectedTemplate = pickEnemyTemplate({
    floor: normalizedFloor,
    area,
    progressionTrigger: triggerKey
  });
  const enemyKey = buildEnemyKey({
    name: selectedTemplate.name,
    floor: normalizedFloor,
    area,
    triggerKey
  });
  const activeEnemy = await findActiveEnemyForContext(conn, {
    playerId,
    floor: normalizedFloor,
    encounterState
  });

  if (activeEnemy) {
    return {
      enemy: activeEnemy,
      isNew: false,
      reused: true,
      source: "active_encounter"
    };
  }

  const discovered = await findDiscoveredEnemyForContext(conn, {
    playerId,
    enemyKey,
    floor: normalizedFloor,
    area,
    triggerKey
  });

  if (discovered) {
    return {
      enemy: discovered,
      isNew: false,
      reused: true,
      source: "discovered"
    };
  }

  return createEnemyIfNew(conn, {
    floor: normalizedFloor,
    area,
    triggerKey,
    template: selectedTemplate
  });
}

async function markEnemyDiscovered(conn, playerId, enemyId) {
  await conn.query(
    `INSERT INTO player_enemy_discoveries (player_id, enemy_id)
     VALUES (?, ?)
     ON DUPLICATE KEY UPDATE enemy_id = enemy_id`,
    [playerId, enemyId]
  );
}

async function setCurrentEnemy(conn, playerId, enemy, encounterState = "active") {
  await conn.query(
    `INSERT INTO player_current_enemy (
      player_id,
      enemy_id,
      enemy_current_hp,
      encounter_state
    ) VALUES (?, ?, ?, ?)
    ON DUPLICATE KEY UPDATE
      enemy_id = VALUES(enemy_id),
      enemy_current_hp = IF(encounter_state = 'active' AND enemy_id = VALUES(enemy_id), enemy_current_hp, VALUES(enemy_current_hp)),
      encounter_state = VALUES(encounter_state)`,
    [playerId, enemy.id || enemy.enemy_id, enemy.enemy_current_hp || enemy.hp, encounterState]
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
       AND pce.encounter_state = 'active'
     LIMIT 1`,
    [playerId]
  );

  return row || null;
}

function shouldEncounterEnemy(actionKey) {
  return ["move", "look", "typed"].includes(actionKey);
}

module.exports = {
  buildEnemyKey,
  createEnemyIfNew,
  findActiveEnemyForContext,
  findDiscoveredEnemyForContext,
  getMonsterPoolForFloor,
  getValidEnemyTemplates,
  pickEnemyTemplate,
  markEnemyDiscovered,
  resolveEnemyEncounter,
  setCurrentEnemy,
  getCurrentEnemy,
  shouldEncounterEnemy
};
