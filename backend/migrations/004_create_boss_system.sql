CREATE TABLE IF NOT EXISTS `bosses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `boss_key` varchar(160) NOT NULL,
  `name` varchar(120) NOT NULL,
  `boss_type` varchar(50) NOT NULL DEFAULT 'dungeon',
  `floor_number` int(11) NOT NULL DEFAULT 1,
  `level` int(11) NOT NULL DEFAULT 1,
  `hp` int(11) NOT NULL DEFAULT 45,
  `max_hp` int(11) NOT NULL DEFAULT 45,
  `attack_stat` int(11) NOT NULL DEFAULT 6,
  `defense_stat` int(11) NOT NULL DEFAULT 3,
  `speed_stat` int(11) NOT NULL DEFAULT 2,
  `intelligence_stat` int(11) NOT NULL DEFAULT 2,
  `reward_exp` int(11) NOT NULL DEFAULT 30,
  `description` text DEFAULT NULL,
  `trigger_key` varchar(160) DEFAULT NULL,
  `is_final` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_boss_key` (`boss_key`),
  KEY `idx_boss_floor` (`floor_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `boss_skills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `boss_id` int(11) NOT NULL,
  `skill_key` varchar(160) NOT NULL,
  `name` varchar(120) NOT NULL,
  `effect_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`effect_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_boss_skill` (`boss_id`, `skill_key`),
  CONSTRAINT `fk_boss_skills_boss` FOREIGN KEY (`boss_id`) REFERENCES `bosses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `player_current_boss` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `boss_id` int(11) NOT NULL,
  `boss_current_hp` int(11) NOT NULL,
  `encounter_state` varchar(50) NOT NULL DEFAULT 'active',
  `trigger_revealed_at` timestamp NULL DEFAULT NULL,
  `started_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_player_current_boss` (`player_id`),
  KEY `fk_player_current_boss_boss` (`boss_id`),
  CONSTRAINT `fk_player_current_boss_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_player_current_boss_boss` FOREIGN KEY (`boss_id`) REFERENCES `bosses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `player_boss_defeats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `boss_id` int(11) NOT NULL,
  `floor_number` int(11) NOT NULL,
  `defeated_life_number` int(11) NOT NULL,
  `defeated_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_player_boss_life` (`player_id`, `boss_id`, `defeated_life_number`),
  KEY `fk_player_boss_defeats_boss` (`boss_id`),
  CONSTRAINT `fk_player_boss_defeats_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_player_boss_defeats_boss` FOREIGN KEY (`boss_id`) REFERENCES `bosses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `boss_battle_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `boss_id` int(11) NOT NULL,
  `player_action` varchar(50) NOT NULL,
  `boss_action` varchar(50) NOT NULL,
  `player_damage_dealt` int(11) NOT NULL DEFAULT 0,
  `boss_damage_dealt` int(11) NOT NULL DEFAULT 0,
  `player_hp_after` int(11) NOT NULL DEFAULT 0,
  `boss_hp_after` int(11) NOT NULL DEFAULT 0,
  `result_tag` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_boss_battle_logs_player` (`player_id`),
  KEY `idx_boss_battle_logs_boss` (`boss_id`),
  CONSTRAINT `fk_boss_battle_logs_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_boss_battle_logs_boss` FOREIGN KEY (`boss_id`) REFERENCES `bosses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT IGNORE INTO `bosses` (
  `boss_key`,
  `name`,
  `boss_type`,
  `floor_number`,
  `level`,
  `hp`,
  `max_hp`,
  `attack_stat`,
  `defense_stat`,
  `speed_stat`,
  `intelligence_stat`,
  `reward_exp`,
  `description`,
  `trigger_key`,
  `is_final`
) VALUES (
  'floor_1_warden',
  'Warden of the First Seal',
  'dungeon',
  1,
  2,
  42,
  42,
  6,
  3,
  2,
  3,
  35,
  'The first floor guardian, drawn out only after enough hidden dungeon pressure is disturbed.',
  'first_floor_hidden_seal',
  0
);

INSERT IGNORE INTO `boss_skills` (`boss_id`, `skill_key`, `name`, `effect_json`)
SELECT b.`id`, 'seal_pressure', 'Seal Pressure', JSON_OBJECT('pressure_bonus', 1)
FROM `bosses` b
WHERE b.`boss_key` = 'floor_1_warden';
