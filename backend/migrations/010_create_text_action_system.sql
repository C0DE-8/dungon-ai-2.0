CREATE TABLE IF NOT EXISTS `player_scene_environment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `area_name` varchar(120) NOT NULL,
  `tags_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`tags_json`)),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_player_scene_environment` (`player_id`),
  CONSTRAINT `fk_player_scene_environment_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `player_remains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `source_type` varchar(30) NOT NULL,
  `source_id` int(11) DEFAULT NULL,
  `enemy_name` varchar(120) NOT NULL,
  `enemy_type` varchar(50) DEFAULT NULL,
  `loot_state` varchar(30) NOT NULL DEFAULT 'available',
  `inspect_state` varchar(30) NOT NULL DEFAULT 'available',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NOT NULL,
  `consumed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_player_remains_active` (`player_id`, `consumed_at`, `expires_at`),
  CONSTRAINT `fk_player_remains_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `player_text_action_interpretations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `action_text` text NOT NULL,
  `interpretation_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`interpretation_json`)),
  `resolution_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`resolution_json`)),
  `resolved_intent` varchar(80) NOT NULL,
  `resolution_type` varchar(80) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_text_action_player_created` (`player_id`, `created_at`),
  KEY `idx_text_action_intent` (`resolved_intent`, `resolution_type`),
  CONSTRAINT `fk_text_action_interpretations_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `skills` (
  `skill_key`,
  `name`,
  `description`,
  `skill_type`,
  `unlock_type`,
  `required_level`,
  `condition_stat_key`,
  `condition_threshold`,
  `effect_json`,
  `is_dynamic`,
  `source_pattern`
) VALUES
  (
    'intent_precision_instinct',
    'Precision Instinct',
    'A passive combat sense formed by repeated weak-point and eye attacks.',
    'passive',
    'condition',
    NULL,
    'intent:precision_attack',
    4,
    JSON_OBJECT('precision_bonus', 1),
    0,
    'repeated_precision_intent'
  ),
  (
    'intent_environmental_tactician',
    'Environmental Tactician',
    'A passive tactical sense formed by repeatedly weaponizing the room itself.',
    'passive',
    'condition',
    NULL,
    'intent:environment_attack',
    4,
    JSON_OBJECT('environment_attack_bonus', 1),
    0,
    'repeated_environment_intent'
  ),
  (
    'intent_predator_hunger',
    'Predator Hunger',
    'A passive instinct awakened by repeatedly consuming remains.',
    'passive',
    'condition',
    NULL,
    'intent:devour_remains',
    3,
    JSON_OBJECT('devour_hp_bonus', 1),
    0,
    'repeated_devour_intent'
  ),
  (
    'intent_beast_parley',
    'Beast Parley',
    'A social survival technique formed through repeated attempts to communicate with creatures.',
    'active',
    'condition',
    NULL,
    'intent:social',
    4,
    JSON_OBJECT('social_opening_bonus', 1, 'duration_turns', 1),
    0,
    'repeated_social_intent'
  )
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `description` = VALUES(`description`),
  `skill_type` = VALUES(`skill_type`),
  `unlock_type` = VALUES(`unlock_type`),
  `required_level` = VALUES(`required_level`),
  `condition_stat_key` = VALUES(`condition_stat_key`),
  `condition_threshold` = VALUES(`condition_threshold`),
  `effect_json` = VALUES(`effect_json`),
  `is_dynamic` = VALUES(`is_dynamic`),
  `source_pattern` = VALUES(`source_pattern`);
