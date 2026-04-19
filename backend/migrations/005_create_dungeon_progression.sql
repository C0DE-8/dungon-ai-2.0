CREATE TABLE IF NOT EXISTS `player_dungeon_state` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `floor_number` int(11) NOT NULL DEFAULT 1,
  `max_floor_unlocked` int(11) NOT NULL DEFAULT 1,
  `exploration_score` int(11) NOT NULL DEFAULT 0,
  `progression_clues` int(11) NOT NULL DEFAULT 0,
  `hidden_exit_found` tinyint(1) NOT NULL DEFAULT 0,
  `boss_triggered` tinyint(1) NOT NULL DEFAULT 0,
  `floor_boss_defeated` tinyint(1) NOT NULL DEFAULT 0,
  `last_event_key` varchar(80) DEFAULT NULL,
  `metadata_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_player_dungeon_floor` (`player_id`, `floor_number`),
  KEY `idx_player_dungeon_floor` (`floor_number`),
  CONSTRAINT `fk_player_dungeon_state_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT IGNORE INTO `player_dungeon_state` (`player_id`, `floor_number`, `max_floor_unlocked`)
SELECT `id`, `current_floor`, GREATEST(`current_floor`, 1)
FROM `players`;
