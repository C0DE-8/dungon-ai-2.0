CREATE TABLE IF NOT EXISTS `skills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `skill_key` varchar(160) NOT NULL,
  `name` varchar(120) NOT NULL,
  `description` text DEFAULT NULL,
  `skill_type` varchar(20) NOT NULL DEFAULT 'passive',
  `unlock_type` varchar(30) NOT NULL DEFAULT 'condition',
  `required_level` int(11) DEFAULT NULL,
  `condition_stat_key` varchar(160) DEFAULT NULL,
  `condition_threshold` int(11) DEFAULT NULL,
  `effect_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`effect_json`)),
  `is_dynamic` tinyint(1) NOT NULL DEFAULT 0,
  `source_pattern` varchar(160) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_skills_skill_key` (`skill_key`),
  KEY `idx_skills_level_unlock` (`unlock_type`, `required_level`),
  KEY `idx_skills_condition_unlock` (`condition_stat_key`, `condition_threshold`)
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
    'level_1_survivor_instinct',
    'Survivor Instinct',
    'A passive survival sense awakened by reaching level 1.',
    'passive',
    'level',
    1,
    NULL,
    NULL,
    JSON_OBJECT('awareness_bonus', 1),
    0,
    'level'
  ),
  (
    'level_3_combat_focus',
    'Combat Focus',
    'An active burst of focus unlocked through early dungeon growth.',
    'active',
    'level',
    3,
    NULL,
    NULL,
    JSON_OBJECT('attack_bonus', 1, 'duration_turns', 1),
    0,
    'level'
  ),
  (
    'condition_first_blood',
    'First Blood',
    'A passive edge gained after proving you can kill what hunts you.',
    'passive',
    'condition',
    NULL,
    'enemies_killed',
    1,
    JSON_OBJECT('combat_confidence', 1),
    0,
    'kill_count'
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
