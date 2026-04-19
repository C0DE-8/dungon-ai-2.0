-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 19, 2026 at 06:28 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `deep_saga`
--

-- --------------------------------------------------------

--
-- Table structure for table `enemies`
--

CREATE TABLE `enemies` (
  `id` int(11) NOT NULL,
  `enemy_key` varchar(120) NOT NULL,
  `name` varchar(120) NOT NULL,
  `enemy_type` varchar(50) NOT NULL DEFAULT 'normal',
  `floor_min` int(11) NOT NULL DEFAULT 1,
  `floor_max` int(11) NOT NULL DEFAULT 1,
  `level` int(11) NOT NULL DEFAULT 1,
  `hp` int(11) NOT NULL DEFAULT 20,
  `max_hp` int(11) NOT NULL DEFAULT 20,
  `attack_stat` int(11) NOT NULL DEFAULT 4,
  `defense_stat` int(11) NOT NULL DEFAULT 2,
  `speed_stat` int(11) NOT NULL DEFAULT 2,
  `intelligence_stat` int(11) NOT NULL DEFAULT 1,
  `description` text DEFAULT NULL,
  `is_boss` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `reward_exp` int(11) NOT NULL DEFAULT 10
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enemies`
--

INSERT INTO `enemies` (`id`, `enemy_key`, `name`, `enemy_type`, `floor_min`, `floor_max`, `level`, `hp`, `max_hp`, `attack_stat`, `defense_stat`, `speed_stat`, `intelligence_stat`, `description`, `is_boss`, `created_at`, `updated_at`, `reward_exp`) VALUES
(1, 'goblin_scout_f1', 'Goblin Scout', 'normal', 1, 1, 1, 18, 18, 4, 2, 3, 2, 'A small green scavenger lurking in the lower dungeon. Encountered in Dust Chamber.', 0, '2026-04-19 15:01:01', '2026-04-19 15:01:01', 10);

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `persona` varchar(20) NOT NULL DEFAULT 'ADMIN',
  `name` varchar(100) DEFAULT NULL,
  `current_race` varchar(50) NOT NULL DEFAULT 'Lost Soul',
  `current_title` varchar(100) DEFAULT 'Unawakened',
  `level` int(11) NOT NULL DEFAULT 0,
  `exp` int(11) NOT NULL DEFAULT 0,
  `stat_points` int(11) NOT NULL DEFAULT 8,
  `hp` int(11) NOT NULL DEFAULT 40,
  `max_hp` int(11) NOT NULL DEFAULT 40,
  `strength_stat` int(11) NOT NULL DEFAULT 4,
  `dexterity_stat` int(11) NOT NULL DEFAULT 4,
  `stamina_stat` int(11) NOT NULL DEFAULT 4,
  `intelligence_stat` int(11) NOT NULL DEFAULT 4,
  `charisma_stat` int(11) NOT NULL DEFAULT 4,
  `wisdom_stat` int(11) NOT NULL DEFAULT 4,
  `current_floor` int(11) NOT NULL DEFAULT 1,
  `current_area` varchar(120) NOT NULL DEFAULT 'Unknown Chamber',
  `life_number` int(11) NOT NULL DEFAULT 1,
  `is_alive` tinyint(1) NOT NULL DEFAULT 1,
  `year_survived` int(11) NOT NULL DEFAULT 1,
  `day_survived` int(11) NOT NULL DEFAULT 1,
  `current_hour` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`id`, `user_id`, `persona`, `name`, `current_race`, `current_title`, `level`, `exp`, `stat_points`, `hp`, `max_hp`, `strength_stat`, `dexterity_stat`, `stamina_stat`, `intelligence_stat`, `charisma_stat`, `wisdom_stat`, `current_floor`, `current_area`, `life_number`, `is_alive`, `year_survived`, `day_survived`, `current_hour`, `created_at`, `updated_at`) VALUES
(1, 1, 'ADMIN', 'light', 'Lost Soul', 'Unawakened', 0, 0, 8, 40, 40, 4, 4, 4, 4, 4, 4, 1, 'Dust Chamber', 1, 1, 1, 1, 15, '2026-04-19 12:15:36', '2026-04-19 15:01:02');

-- --------------------------------------------------------

--
-- Table structure for table `player_action_logs`
--

CREATE TABLE `player_action_logs` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `action_key` varchar(50) NOT NULL,
  `action_text` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_action_logs`
--

INSERT INTO `player_action_logs` (`id`, `player_id`, `action_key`, `action_text`, `created_at`) VALUES
(4, 1, 'typed', 'touch the wall and listen closely', '2026-04-19 13:53:24'),
(5, 1, 'typed', 'move around', '2026-04-19 14:12:17'),
(6, 1, 'typed', 'Perform a tactile scan of the floor surface to identify stability.', '2026-04-19 14:18:03'),
(7, 1, 'typed', 'Perform a tactile scan of the floor surface to identify stability.', '2026-04-19 14:24:39'),
(8, 1, 'typed', 'Activate local light source to improve visibility.', '2026-04-19 14:25:31'),
(9, 1, 'typed', 'look around', '2026-04-19 14:26:29'),
(10, 1, 'look', 'look', '2026-04-19 14:29:57'),
(11, 1, 'appraise', 'appraise', '2026-04-19 14:36:27'),
(12, 1, 'move', 'move', '2026-04-19 14:44:39'),
(13, 1, 'move', 'move', '2026-04-19 14:52:51'),
(14, 1, 'typed', 'Scan the perimeter for structural weaknesses', '2026-04-19 14:53:20'),
(15, 1, 'typed', 'Scan the perimeter for structural weaknesses', '2026-04-19 15:01:02');

-- --------------------------------------------------------

--
-- Table structure for table `player_current_enemy`
--

CREATE TABLE `player_current_enemy` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `enemy_id` int(11) NOT NULL,
  `enemy_current_hp` int(11) NOT NULL,
  `encounter_state` varchar(50) NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_current_enemy`
--

INSERT INTO `player_current_enemy` (`id`, `player_id`, `enemy_id`, `enemy_current_hp`, `encounter_state`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 18, 'active', '2026-04-19 15:01:01', '2026-04-19 15:01:01');

-- --------------------------------------------------------

--
-- Table structure for table `player_current_scene`
--

CREATE TABLE `player_current_scene` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `scene_title` varchar(150) NOT NULL,
  `scene_text` text NOT NULL,
  `scene_type` varchar(50) NOT NULL DEFAULT 'intro',
  `choices_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`choices_json`)),
  `can_type` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_current_scene`
--

INSERT INTO `player_current_scene` (`id`, `player_id`, `scene_title`, `scene_text`, `scene_type`, `choices_json`, `can_type`, `created_at`, `updated_at`) VALUES
(8, 1, 'A New Presence Emerges', 'You feel the dungeon breathing around you, but nothing answers yet.', 'encounter', '[\"look around\",\"move carefully\",\"rest\",\"hide\"]', 1, '2026-04-19 13:29:39', '2026-04-19 15:01:15');

-- --------------------------------------------------------

--
-- Table structure for table `player_enemy_discoveries`
--

CREATE TABLE `player_enemy_discoveries` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `enemy_id` int(11) NOT NULL,
  `first_seen_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_enemy_discoveries`
--

INSERT INTO `player_enemy_discoveries` (`id`, `player_id`, `enemy_id`, `first_seen_at`) VALUES
(1, 1, 1, '2026-04-19 15:01:01');

-- --------------------------------------------------------

--
-- Table structure for table `player_scene_history`
--

CREATE TABLE `player_scene_history` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `scene_title` varchar(150) NOT NULL,
  `scene_text` text NOT NULL,
  `scene_type` varchar(50) NOT NULL DEFAULT 'intro',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_scene_history`
--

INSERT INTO `player_scene_history` (`id`, `player_id`, `scene_title`, `scene_text`, `scene_type`, `created_at`) VALUES
(11, 1, 'Awakening in Darkness', '**SYSTEM BULLETIN: INITIALIZATION COMPLETE**\n\n**Subject:** Unit \'light\'\n**Status:** Awakening\n**Classification:** Lost Soul [Unawakened]\n**Current Sector:** Floor 1, Unknown Chamber\n**Time:** Year 1, Day 1, Hour 03:00\n\n**Diagnostic Report:**\nBiological baseline established. HP: 40/40. All primary attributes remain at base-line variable [4]. Statistical probability of survival without immediate environmental adaptation: < 0.04%. \n\n**Analysis:**\nYour consciousness has been forcibly anchored to this plane. The Chamber is stagnant; oxygen levels are suboptimal. You are currently devoid of gear, skills, or tactical awareness. You are an anomaly with no recorded history.\n\n**Alert:**\nThe atmospheric pressure in the Chamber is fluctuating. Something is mobilizing in the periphery of your sensory range. You have exactly 60 seconds of silence before the local inhabitants register your signature. \n\n**Decision required:** Attempt to synthesize your surroundings, or await inevitable assimilation. Proceed.', 'intro', '2026-04-19 13:29:39'),
(12, 1, 'An Unscripted Move', '**SYSTEM BULLETIN: ENVIRONMENTAL INTERACTION LOG**\n\n**Subject:** Unit \'light\'\n**Action:** Tactile/Auditory Probe\n**Result:** Analysis initiated.\n\n**Data Capture:**\n- **Surface:** The wall is composed of porous, calcified material. Temperature: 4°C. Sub-surface vibration detected.\n- **Auditory Log:** Low-frequency thrumming emanates from beyond the structure. Pulse interval: 12 seconds. Pattern indicates mechanical or structural stress, not biological origin.\n- **Observation:** The wall is not solid. Micro-fractures present at 0.4 meters from your current position.\n\n**Diagnostic:**\nAttempting to gather intelligence before internalizing environmental hazards is a statistically sound decision. However, time remains the primary limiting factor. Your proximity to the wall creates a sensory blind spot.\n\n**Status:**\n- HP: 40/40.\n- Efficiency: +2% gain in environmental awareness.\n- Threat Level: Nominal, but increasing.\n\n**Required Action:** The structure is unstable. You may attempt to exploit the micro-fractures, or extract yourself to a more defensible position. Proceed.', 'typed_action', '2026-04-19 13:53:33'),
(13, 1, 'An Unscripted Move', '[object Object]', 'typed_action', '2026-04-19 14:13:05'),
(14, 1, 'An Unscripted Move', '[object Object]', 'typed_action', '2026-04-19 14:18:10'),
(15, 1, 'An Unscripted Move', 'Tactile scan completed. Surface composition: High-density obsidian. Structural integrity: 98.4%. Sub-surface seismic activity: Negligible. Floor surface is confirmed stable for traversal.', 'typed_action', '2026-04-19 14:24:51'),
(16, 1, 'An Unscripted Move', 'You feel the dungeon breathing around you, but nothing answers yet.', 'typed_action', '2026-04-19 14:25:48'),
(17, 1, 'An Unscripted Move', 'Environment scan complete. Sector: Unknown Chamber. Visibility: Restricted. Structural integrity: Nominal. Presence of light: Negligible. Atmospheric composition: Stable. No immediate hostile signatures detected. Objective: Establish orientation.', 'typed_action', '2026-04-19 14:27:06'),
(18, 1, 'Eyes on the Dark', 'Environment scan complete. Area: Unknown Chamber. Structural integrity: Stable. Atmospheric composition: Standard. No immediate hostile entities detected. Presence of thermal radiation at 0.04% variance from baseline.', 'action', '2026-04-19 14:30:02'),
(19, 1, 'Measured Observation', 'Environment scan complete. Area: Unknown Chamber. Current status: Stable. Integrity: 100%. No immediate hostiles detected. Probability of undetected hazards: 14%.', 'utility', '2026-04-19 14:37:01'),
(20, 1, 'A Careful Advance', 'Entry into the Dust Chamber confirmed. Atmospheric particulate density is high, suggesting potential respiratory impedance. Structural integrity of the floor is sub-optimal. No immediate hostiles detected. Efficiency rating remains stable.', 'action', '2026-04-19 14:45:49'),
(21, 1, 'A Careful Advance', 'Entry into the Dust Chamber confirmed. Atmospheric particulate density is high. Visibility: 40%. Ambient temperature: 28°C. No hostile biological signatures detected in immediate proximity. Structural integrity of the chamber is failing.', 'action', '2026-04-19 14:52:59'),
(22, 1, 'An Unscripted Move', 'Scan complete. Dust Chamber integrity compromised. North-west load-bearing column shows 42% micro-fracture saturation. Immediate structural failure probability: 18%. Atmospheric oxygen levels stable. No external threats detected.', 'typed_action', '2026-04-19 14:53:29'),
(23, 1, 'A New Presence Emerges', 'You feel the dungeon breathing around you, but nothing answers yet.', 'encounter', '2026-04-19 15:01:15');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `created_at`, `updated_at`) VALUES
(1, 'light', '8amlight@gmail.com', '$2b$10$5NRvFJ0ciPSEcCAkZE2d4uocwDqCfoWssfXxHEEomImZN5Vf3HiGu', '2026-04-19 12:15:36', '2026-04-19 12:15:36');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `enemies`
--
ALTER TABLE `enemies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `enemy_key` (`enemy_key`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `player_action_logs`
--
ALTER TABLE `player_action_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_player_action_logs_player` (`player_id`);

--
-- Indexes for table `player_current_enemy`
--
ALTER TABLE `player_current_enemy`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `player_id` (`player_id`),
  ADD KEY `fk_player_current_enemy_enemy` (`enemy_id`);

--
-- Indexes for table `player_current_scene`
--
ALTER TABLE `player_current_scene`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `player_id` (`player_id`);

--
-- Indexes for table `player_enemy_discoveries`
--
ALTER TABLE `player_enemy_discoveries`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_player_enemy_discovery` (`player_id`,`enemy_id`),
  ADD KEY `fk_player_enemy_discoveries_enemy` (`enemy_id`);

--
-- Indexes for table `player_scene_history`
--
ALTER TABLE `player_scene_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_player_scene_history_player` (`player_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `enemies`
--
ALTER TABLE `enemies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `player_action_logs`
--
ALTER TABLE `player_action_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `player_current_enemy`
--
ALTER TABLE `player_current_enemy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `player_current_scene`
--
ALTER TABLE `player_current_scene`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `player_enemy_discoveries`
--
ALTER TABLE `player_enemy_discoveries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `player_scene_history`
--
ALTER TABLE `player_scene_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `fk_players_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_action_logs`
--
ALTER TABLE `player_action_logs`
  ADD CONSTRAINT `fk_player_action_logs_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_current_enemy`
--
ALTER TABLE `player_current_enemy`
  ADD CONSTRAINT `fk_player_current_enemy_enemy` FOREIGN KEY (`enemy_id`) REFERENCES `enemies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_player_current_enemy_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_current_scene`
--
ALTER TABLE `player_current_scene`
  ADD CONSTRAINT `fk_player_current_scene_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_enemy_discoveries`
--
ALTER TABLE `player_enemy_discoveries`
  ADD CONSTRAINT `fk_player_enemy_discoveries_enemy` FOREIGN KEY (`enemy_id`) REFERENCES `enemies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_player_enemy_discoveries_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_scene_history`
--
ALTER TABLE `player_scene_history`
  ADD CONSTRAINT `fk_player_scene_history_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
