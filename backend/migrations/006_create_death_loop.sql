CREATE TABLE IF NOT EXISTS `player_deaths` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `life_number` int(11) NOT NULL,
  `death_cause` varchar(180) DEFAULT NULL,
  `floor_number` int(11) NOT NULL DEFAULT 1,
  `area` varchar(120) DEFAULT NULL,
  `year_survived` int(11) NOT NULL DEFAULT 1,
  `day_survived` int(11) NOT NULL DEFAULT 1,
  `current_hour` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_player_life_death` (`player_id`, `life_number`),
  CONSTRAINT `fk_player_deaths_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `player_rebirth_wishes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `life_number` int(11) NOT NULL,
  `wish_text` varchar(240) NOT NULL,
  `granted_effect_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`granted_effect_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_player_rebirth_wishes_player` (`player_id`),
  CONSTRAINT `fk_player_rebirth_wishes_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
