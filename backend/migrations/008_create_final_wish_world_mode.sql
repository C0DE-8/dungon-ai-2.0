CREATE TABLE IF NOT EXISTS `player_dungeon_completions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `completed_life_number` int(11) NOT NULL,
  `floor_reached` int(11) NOT NULL DEFAULT 100,
  `status` varchar(40) NOT NULL DEFAULT 'awaiting_wish',
  `completed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `ascended_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_player_completion_life` (`player_id`, `completed_life_number`),
  KEY `idx_player_dungeon_completions_status` (`status`),
  CONSTRAINT `fk_player_dungeon_completions_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `player_dungeon_run_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `life_number` int(11) NOT NULL,
  `highest_floor` int(11) NOT NULL DEFAULT 1,
  `run_result` varchar(50) NOT NULL DEFAULT 'in_progress',
  `summary_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`summary_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_player_dungeon_run_history_player` (`player_id`, `life_number`),
  CONSTRAINT `fk_player_dungeon_run_history_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `player_final_wishes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `completion_id` int(11) NOT NULL,
  `wish_text` text NOT NULL,
  `interpreted_intent` varchar(80) NOT NULL,
  `interpretation_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`interpretation_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_final_wish_completion` (`completion_id`),
  KEY `idx_player_final_wishes_player` (`player_id`),
  CONSTRAINT `fk_player_final_wishes_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_player_final_wishes_completion` FOREIGN KEY (`completion_id`) REFERENCES `player_dungeon_completions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `player_ascension_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `final_wish_id` int(11) NOT NULL,
  `form_key` varchar(120) NOT NULL,
  `new_race` varchar(80) NOT NULL,
  `new_title` varchar(120) NOT NULL,
  `identity_label` varchar(120) NOT NULL,
  `stat_bonus_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`stat_bonus_json`)),
  `passive_traits_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`passive_traits_json`)),
  `active_traits_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`active_traits_json`)),
  `carryover_power` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_ascension_final_wish` (`final_wish_id`),
  KEY `idx_player_ascension_results_player` (`player_id`),
  CONSTRAINT `fk_player_ascension_results_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_player_ascension_results_wish` FOREIGN KEY (`final_wish_id`) REFERENCES `player_final_wishes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `player_carryover_traits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `ascension_id` int(11) NOT NULL,
  `trait_key` varchar(120) NOT NULL,
  `trait_type` varchar(30) NOT NULL DEFAULT 'passive',
  `name` varchar(120) NOT NULL,
  `effect_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`effect_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_player_carryover_trait` (`player_id`, `ascension_id`, `trait_key`),
  KEY `idx_player_carryover_traits_ascension` (`ascension_id`),
  CONSTRAINT `fk_player_carryover_traits_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_player_carryover_traits_ascension` FOREIGN KEY (`ascension_id`) REFERENCES `player_ascension_results` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `player_world_state` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `ascension_id` int(11) NOT NULL,
  `world_region` varchar(120) NOT NULL DEFAULT 'Threshold Kingdom',
  `world_phase` varchar(80) NOT NULL DEFAULT 'awakening',
  `world_year` int(11) NOT NULL DEFAULT 1,
  `world_day` int(11) NOT NULL DEFAULT 1,
  `world_hour` int(11) NOT NULL DEFAULT 8,
  `influence` int(11) NOT NULL DEFAULT 0,
  `stability` int(11) NOT NULL DEFAULT 50,
  `current_objective` varchar(180) NOT NULL DEFAULT 'Understand the world beyond the dungeon',
  `state_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`state_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_player_world_state` (`player_id`),
  KEY `idx_player_world_state_ascension` (`ascension_id`),
  CONSTRAINT `fk_player_world_state_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_player_world_state_ascension` FOREIGN KEY (`ascension_id`) REFERENCES `player_ascension_results` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `world_action_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `world_state_id` int(11) NOT NULL,
  `action_key` varchar(80) NOT NULL,
  `action_text` text DEFAULT NULL,
  `outcome_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`outcome_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_world_action_logs_player` (`player_id`),
  KEY `idx_world_action_logs_state` (`world_state_id`),
  CONSTRAINT `fk_world_action_logs_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_world_action_logs_state` FOREIGN KEY (`world_state_id`) REFERENCES `player_world_state` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
