CREATE TABLE IF NOT EXISTS `player_condition_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `stat_key` varchar(160) NOT NULL,
  `stat_value` int(11) NOT NULL DEFAULT 0,
  `metadata_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_player_condition_stat` (`player_id`, `stat_key`),
  KEY `idx_player_condition_stat_key` (`stat_key`),
  CONSTRAINT `fk_player_condition_stats_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT IGNORE INTO `player_condition_stats` (`player_id`, `stat_key`, `stat_value`, `metadata_json`)
SELECT p.`id`, base_stats.`stat_key`, 0, NULL
FROM `players` p
CROSS JOIN (
  SELECT 'enemies_killed' AS `stat_key`
  UNION ALL SELECT 'times_hidden'
  UNION ALL SELECT 'times_rested'
  UNION ALL SELECT 'times_appraised'
  UNION ALL SELECT 'typed_actions_count'
) base_stats;
