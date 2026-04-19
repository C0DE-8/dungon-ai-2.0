CREATE TABLE IF NOT EXISTS `battle_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `enemy_id` int(11) NOT NULL,
  `player_action` varchar(50) NOT NULL,
  `enemy_action` varchar(50) NOT NULL,
  `player_damage_dealt` int(11) NOT NULL DEFAULT 0,
  `enemy_damage_dealt` int(11) NOT NULL DEFAULT 0,
  `player_hp_after` int(11) NOT NULL DEFAULT 0,
  `enemy_hp_after` int(11) NOT NULL DEFAULT 0,
  `result_tag` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_battle_logs_player` (`player_id`),
  KEY `idx_battle_logs_enemy` (`enemy_id`),
  CONSTRAINT `fk_battle_logs_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_battle_logs_enemy` FOREIGN KEY (`enemy_id`) REFERENCES `enemies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
