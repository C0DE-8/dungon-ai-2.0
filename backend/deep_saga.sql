-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 22, 2026 at 07:49 PM
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
-- Table structure for table `battle_logs`
--

CREATE TABLE `battle_logs` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `enemy_id` int(11) NOT NULL,
  `player_action` varchar(50) NOT NULL,
  `enemy_action` varchar(50) NOT NULL,
  `player_damage_dealt` int(11) NOT NULL DEFAULT 0,
  `enemy_damage_dealt` int(11) NOT NULL DEFAULT 0,
  `player_hp_after` int(11) NOT NULL DEFAULT 0,
  `enemy_hp_after` int(11) NOT NULL DEFAULT 0,
  `result_tag` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `battle_logs`
--

INSERT INTO `battle_logs` (`id`, `player_id`, `enemy_id`, `player_action`, `enemy_action`, `player_damage_dealt`, `enemy_damage_dealt`, `player_hp_after`, `enemy_hp_after`, `result_tag`, `created_at`) VALUES
(1, 1, 1, 'attack', 'attack', 5, 2, 38, 13, 'ongoing', '2026-04-19 23:26:51'),
(2, 1, 1, 'attack', 'attack', 5, 2, 36, 8, 'ongoing', '2026-04-19 23:27:18'),
(3, 1, 1, 'attack', 'attack', 5, 2, 34, 3, 'ongoing', '2026-04-19 23:29:11'),
(4, 1, 1, 'attack', 'attack', 5, 0, 34, 0, 'enemy_defeated', '2026-04-19 23:29:37'),
(5, 1, 1, 'attack', 'attack', 5, 2, 32, 13, 'ongoing', '2026-04-19 23:31:04'),
(6, 1, 1, 'attack', 'attack', 5, 2, 30, 8, 'ongoing', '2026-04-19 23:33:28'),
(7, 1, 1, 'attack', 'attack', 5, 2, 28, 3, 'ongoing', '2026-04-19 23:34:34'),
(8, 1, 1, 'attack', 'attack', 5, 0, 28, 0, 'enemy_defeated', '2026-04-19 23:34:46'),
(9, 1, 1, 'attack', 'attack', 5, 2, 26, 13, 'ongoing', '2026-04-20 00:11:44'),
(10, 1, 1, 'attack', 'attack', 5, 2, 24, 8, 'ongoing', '2026-04-20 00:12:05'),
(11, 1, 1, 'attack', 'attack', 5, 2, 22, 3, 'ongoing', '2026-04-20 00:12:24'),
(12, 1, 1, 'attack', 'attack', 5, 0, 22, 0, 'enemy_defeated', '2026-04-20 00:12:43'),
(13, 1, 2, 'attack', 'attack', 5, 2, 35, 13, 'ongoing', '2026-04-20 00:21:20'),
(14, 1, 2, 'attack', 'attack', 5, 2, 33, 8, 'ongoing', '2026-04-20 00:21:24'),
(15, 1, 2, 'attack', 'attack', 5, 2, 31, 3, 'ongoing', '2026-04-20 00:23:04'),
(16, 1, 2, 'attack', 'attack', 5, 0, 31, 0, 'enemy_defeated', '2026-04-20 00:23:07'),
(17, 1, 3, 'attack', 'attack', 11, 2, 34, 5, 'ongoing', '2026-04-20 00:39:41'),
(18, 1, 3, 'attack', 'attack', 11, 0, 34, 0, 'enemy_defeated', '2026-04-20 00:41:36'),
(19, 1, 3, 'attack', 'attack', 11, 2, 32, 5, 'ongoing', '2026-04-20 00:49:11'),
(20, 1, 3, 'attack', 'attack', 11, 0, 32, 0, 'enemy_defeated', '2026-04-20 00:49:19'),
(21, 1, 4, 'typed:observe', 'attack', 0, 2, 30, 18, 'ongoing', '2026-04-20 01:26:18'),
(22, 1, 4, 'typed:direct_attack', 'attack', 8, 2, 28, 10, 'ongoing', '2026-04-20 01:26:41'),
(23, 1, 4, 'typed:observe', 'attack', 0, 2, 26, 10, 'ongoing', '2026-04-20 01:27:04'),
(24, 1, 4, 'typed:direct_attack', 'attack', 4, 2, 24, 6, 'ongoing', '2026-04-20 01:27:57'),
(25, 1, 4, 'typed:observe', 'attack', 0, 2, 22, 6, 'ongoing', '2026-04-20 01:28:55'),
(26, 1, 4, 'attack', 'attack', 10, 0, 22, 0, 'enemy_defeated', '2026-04-20 01:29:59'),
(27, 1, 5, 'typed:observe', 'attack', 0, 2, 20, 16, 'ongoing', '2026-04-22 16:25:19'),
(28, 1, 5, 'attack', 'attack', 11, 2, 18, 5, 'ongoing', '2026-04-22 16:26:31'),
(29, 1, 5, 'attack', 'attack', 11, 0, 18, 0, 'enemy_defeated', '2026-04-22 16:26:40'),
(30, 1, 6, 'attack', 'attack', 10, 2, 38, 8, 'ongoing', '2026-04-22 17:24:42'),
(31, 1, 6, 'attack', 'attack', 10, 0, 38, 0, 'enemy_defeated', '2026-04-22 17:29:57'),
(32, 1, 7, 'typed:observe', 'attack', 0, 1, 39, 15, 'ongoing', '2026-04-22 17:32:41'),
(33, 1, 7, 'typed:precision_attack', 'attack', 2, 1, 38, 13, 'ongoing', '2026-04-22 17:33:44'),
(34, 1, 7, 'typed:observe', 'attack', 0, 1, 37, 13, 'ongoing', '2026-04-22 17:34:34'),
(35, 1, 7, 'attack', 'attack', 11, 1, 36, 2, 'ongoing', '2026-04-22 17:35:10'),
(36, 1, 7, 'attack', 'attack', 11, 0, 36, 0, 'enemy_defeated', '2026-04-22 17:35:37');

-- --------------------------------------------------------

--
-- Table structure for table `bosses`
--

CREATE TABLE `bosses` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bosses`
--

INSERT INTO `bosses` (`id`, `boss_key`, `name`, `boss_type`, `floor_number`, `level`, `hp`, `max_hp`, `attack_stat`, `defense_stat`, `speed_stat`, `intelligence_stat`, `reward_exp`, `description`, `trigger_key`, `is_final`, `created_at`, `updated_at`) VALUES
(1, 'floor_1_warden', 'Warden of the First Seal', 'dungeon', 1, 2, 42, 42, 6, 3, 2, 3, 35, 'The first floor guardian, drawn out only after enough hidden dungeon pressure is disturbed.', 'first_floor_hidden_seal', 0, '2026-04-19 19:42:32', '2026-04-19 19:42:32'),
(2, 'floor_1_warden_floor1hiddenseal', 'Warden of Floor 1', 'dungeon', 1, 2, 46, 46, 6, 3, 2, 2, 36, 'A floor 1 guardian bound to the hidden dungeon route.', 'floor_1_hidden_seal', 0, '2026-04-22 16:40:07', '2026-04-22 16:40:07');

-- --------------------------------------------------------

--
-- Table structure for table `boss_battle_logs`
--

CREATE TABLE `boss_battle_logs` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `boss_id` int(11) NOT NULL,
  `player_action` varchar(50) NOT NULL,
  `boss_action` varchar(50) NOT NULL,
  `player_damage_dealt` int(11) NOT NULL DEFAULT 0,
  `boss_damage_dealt` int(11) NOT NULL DEFAULT 0,
  `player_hp_after` int(11) NOT NULL DEFAULT 0,
  `boss_hp_after` int(11) NOT NULL DEFAULT 0,
  `result_tag` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `boss_battle_logs`
--

INSERT INTO `boss_battle_logs` (`id`, `player_id`, `boss_id`, `player_action`, `boss_action`, `player_damage_dealt`, `boss_damage_dealt`, `player_hp_after`, `boss_hp_after`, `result_tag`, `created_at`) VALUES
(1, 1, 2, 'typed:observe', 'attack', 0, 4, 19, 46, 'ongoing', '2026-04-22 16:41:33'),
(2, 1, 2, 'defend', 'attack', 0, 2, 17, 46, 'ongoing', '2026-04-22 16:42:45'),
(3, 1, 2, 'typed:observe', 'attack', 0, 4, 13, 46, 'ongoing', '2026-04-22 16:43:00'),
(4, 1, 2, 'typed:observe', 'attack', 0, 4, 9, 46, 'ongoing', '2026-04-22 16:43:38'),
(5, 1, 2, 'typed:observe', 'attack', 0, 4, 5, 46, 'ongoing', '2026-04-22 16:44:39');

-- --------------------------------------------------------

--
-- Table structure for table `boss_skills`
--

CREATE TABLE `boss_skills` (
  `id` int(11) NOT NULL,
  `boss_id` int(11) NOT NULL,
  `skill_key` varchar(160) NOT NULL,
  `name` varchar(120) NOT NULL,
  `effect_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`effect_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `boss_skills`
--

INSERT INTO `boss_skills` (`id`, `boss_id`, `skill_key`, `name`, `effect_json`, `created_at`) VALUES
(1, 1, 'seal_pressure', 'Seal Pressure', '{\"pressure_bonus\": 1}', '2026-04-19 19:42:32'),
(2, 2, 'warden_focus', 'Warden Focus', '{\"attack_bonus_when_wounded\":1}', '2026-04-22 16:40:07');

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
(1, 'goblin_scout_f1', 'Goblin Scout', 'normal', 1, 1, 1, 18, 18, 4, 2, 3, 2, 'A small green scavenger lurking in the lower dungeon. Encountered in Dust Chamber.', 0, '2026-04-19 15:01:01', '2026-04-19 15:01:01', 10),
(2, 'goblin_scout_f1_afloor_1_broken_hall_tnothingfound', 'Goblin Scout', 'normal', 1, 1, 1, 18, 18, 4, 2, 3, 2, 'A small green scavenger that maps weak paths through the lower dungeon. Encountered in Floor 1 Broken Hall.', 0, '2026-04-20 00:21:04', '2026-04-20 00:21:04', 10),
(3, 'cracked_bone_rat_f1_afloor_1_broken_hall_tnothingfound', 'Cracked Bone Rat', 'normal', 1, 1, 1, 16, 16, 4, 1, 4, 1, 'A bone-plated rat drawn to fractures in old stone. Encountered in Floor 1 Broken Hall.', 0, '2026-04-20 00:39:26', '2026-04-20 00:39:26', 9),
(4, 'goblin_scout_f1_afloor_1_broken_hall_thiddenexitrevealed', 'Goblin Scout', 'normal', 1, 1, 1, 18, 18, 4, 2, 3, 2, 'A small green scavenger that maps weak paths through the lower dungeon. Encountered in Floor 1 Broken Hall.', 0, '2026-04-20 01:26:01', '2026-04-20 01:26:01', 10),
(5, 'cracked_bone_rat_f1_afloor_1_sealed_passage_tprogressionclue', 'Cracked Bone Rat', 'normal', 1, 1, 1, 16, 16, 4, 1, 4, 1, 'A bone-plated rat drawn to fractures in old stone. Encountered in Floor 1 Sealed Passage.', 0, '2026-04-20 01:31:16', '2026-04-20 01:31:16', 9),
(6, 'goblin_scout_f1_afloor_1_quiet_seal_alcove_tnothingfound', 'Goblin Scout', 'normal', 1, 1, 1, 18, 18, 4, 2, 3, 2, 'A small green scavenger that maps weak paths through the lower dungeon. Encountered in Floor 1 Quiet Seal Alcove.', 0, '2026-04-22 17:24:27', '2026-04-22 17:24:27', 10),
(7, 'dust_skitter_f1_afloor_1_quiet_seal_alcove_tnothingfound', 'Dust Skitter', 'normal', 1, 1, 1, 15, 15, 3, 1, 5, 1, 'A many-legged scavenger that hides under powdery dungeon debris. Encountered in Floor 1 Quiet Seal Alcove.', 0, '2026-04-22 17:32:31', '2026-04-22 17:32:31', 8),
(8, 'dust_skitter_f1_afloor_1_quiet_seal_alcove_tprogressionclue', 'Dust Skitter', 'normal', 1, 1, 1, 15, 15, 3, 1, 5, 1, 'A many-legged scavenger that hides under powdery dungeon debris. Encountered in Floor 1 Quiet Seal Alcove.', 0, '2026-04-22 17:39:01', '2026-04-22 17:39:01', 8);

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
(1, 1, 'ADMIN', 'light', 'Lost Soul', 'Unawakened', 3, 5, 0, 36, 40, 11, 6, 4, 6, 4, 10, 1, 'Floor 1 Quiet Seal Alcove', 1, 1, 1, 6, 9, '2026-04-19 12:15:36', '2026-04-22 17:39:01');

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
(15, 1, 'typed', 'Scan the perimeter for structural weaknesses', '2026-04-19 15:01:02'),
(16, 1, 'typed', 'Scan the perimeter for structural weaknesses', '2026-04-19 19:57:30'),
(17, 1, 'typed', 'Scan the perimeter for ememys', '2026-04-19 19:58:25'),
(18, 1, 'look', 'look', '2026-04-19 23:26:23'),
(19, 1, 'attack', 'attack', '2026-04-19 23:26:51'),
(20, 1, 'attack', 'attack', '2026-04-19 23:27:18'),
(21, 1, 'appraise', 'appraise', '2026-04-19 23:27:37'),
(22, 1, 'attack', 'attack', '2026-04-19 23:29:11'),
(23, 1, 'look', 'look', '2026-04-19 23:29:25'),
(24, 1, 'attack', 'attack', '2026-04-19 23:29:37'),
(25, 1, 'look', 'look', '2026-04-19 23:30:27'),
(26, 1, 'attack', 'attack', '2026-04-19 23:31:04'),
(27, 1, 'typed', 'Analyze enemy weakness for tactical advantage.', '2026-04-19 23:31:15'),
(28, 1, 'typed', 'Attempt to disarm opponent.', '2026-04-19 23:31:35'),
(29, 1, 'typed', 'use full on attact dont give the ememy a free to to breath or rest flood with attact', '2026-04-19 23:33:00'),
(30, 1, 'attack', 'attack', '2026-04-19 23:33:28'),
(31, 1, 'typed', 'Execute standard attack sequence.', '2026-04-19 23:33:57'),
(32, 1, 'typed', 'Allocate stat points to Strength to improve output efficiency.', '2026-04-19 23:34:17'),
(33, 1, 'attack', 'attack', '2026-04-19 23:34:34'),
(34, 1, 'attack', 'attack', '2026-04-19 23:34:46'),
(35, 1, 'typed', 'Allocate stat points to Dexterity.', '2026-04-19 23:35:34'),
(36, 1, 'appraise', 'appraise', '2026-04-20 00:11:32'),
(37, 1, 'attack', 'attack', '2026-04-20 00:11:45'),
(38, 1, 'attack', 'attack', '2026-04-20 00:12:05'),
(39, 1, 'attack', 'attack', '2026-04-20 00:12:24'),
(40, 1, 'attack', 'attack', '2026-04-20 00:12:43'),
(41, 1, 'rest', 'rest', '2026-04-20 00:12:54'),
(42, 1, 'rest', 'rest', '2026-04-20 00:13:26'),
(43, 1, 'rest', 'rest', '2026-04-20 00:13:40'),
(44, 1, 'look', 'look', '2026-04-20 00:19:02'),
(45, 1, 'move', 'move', '2026-04-20 00:20:40'),
(46, 1, 'typed', 'Rest to restore health parameters.', '2026-04-20 00:21:04'),
(47, 1, 'attack', 'attack', '2026-04-20 00:21:20'),
(48, 1, 'attack', 'attack', '2026-04-20 00:21:24'),
(49, 1, 'typed', 'Continue standard attack sequence.', '2026-04-20 00:21:29'),
(50, 1, 'typed', 'Utilize Adaptive Insight to identify structural vulnerabilities.', '2026-04-20 00:21:42'),
(51, 1, 'typed', 'Allocate stat points to Strength to increase impact force.', '2026-04-20 00:21:52'),
(52, 1, 'typed', 'Execute standard physical strike on Goblin Scout.', '2026-04-20 00:21:55'),
(53, 1, 'typed', 'Focus attack on the target\'s lower extremities.', '2026-04-20 00:22:01'),
(54, 1, 'typed', 'Execute lethal strike on compromised target.', '2026-04-20 00:22:25'),
(55, 1, 'typed', 'Allocate stat points to Dexterity.', '2026-04-20 00:22:43'),
(56, 1, 'typed', 'Initiate combat with Goblin Scout.', '2026-04-20 00:22:51'),
(57, 1, 'typed', 'Allocate available stat points to increase combat efficiency.', '2026-04-20 00:22:55'),
(58, 1, 'typed', 'Allocate 5 Strength, 6 Stamina.', '2026-04-20 00:22:59'),
(59, 1, 'attack', 'attack', '2026-04-20 00:23:04'),
(60, 1, 'attack', 'attack', '2026-04-20 00:23:07'),
(61, 1, 'rest', 'rest', '2026-04-20 00:38:48'),
(62, 1, 'look', 'look', '2026-04-20 00:39:26'),
(63, 1, 'attack', 'attack', '2026-04-20 00:39:41'),
(64, 1, 'typed', 'Execute a precise finishing blow.', '2026-04-20 00:40:10'),
(65, 1, 'typed', 'Stomp the wretched thing into the floor tiles.', '2026-04-20 00:40:31'),
(66, 1, 'typed', 'Twist your heel to grind the remaining bones into dust.', '2026-04-20 00:41:29'),
(67, 1, 'attack', 'attack', '2026-04-20 00:41:36'),
(68, 1, 'typed', 'Search the pile of rat bones for anything of value.', '2026-04-20 00:46:15'),
(69, 1, 'attack', 'attack', '2026-04-20 00:49:11'),
(70, 1, 'attack', 'attack', '2026-04-20 00:49:19'),
(71, 1, 'typed', 'Distribute stat points to boost Strength.', '2026-04-20 01:26:01'),
(72, 1, 'typed', 'Engage the Goblin Scout in immediate melee combat.', '2026-04-20 01:26:18'),
(73, 1, 'typed', 'Execute a heavy strike with your weapon.', '2026-04-20 01:26:41'),
(74, 1, 'typed', 'Execute a finishing blow to silence the scout permanently.', '2026-04-20 01:27:04'),
(75, 1, 'typed', 'Attack the scout with everything you have.', '2026-04-20 01:27:57'),
(76, 1, 'typed', 'Use the broken wall for cover and recover your breath.', '2026-04-20 01:28:16'),
(77, 1, 'typed', 'Use Adaptive Insight to analyze the Goblin Scout\'s movement.', '2026-04-20 01:28:55'),
(78, 1, 'typed', 'Kick the nearby torch stand to create a wall of fire.', '2026-04-20 01:29:37'),
(79, 1, 'attack', 'attack', '2026-04-20 01:29:59'),
(80, 1, 'move', 'move', '2026-04-20 01:31:16'),
(81, 1, 'typed', 'Engage Cracked Bone Rat using melee.', '2026-04-22 16:25:19'),
(82, 1, 'attack', 'attack', '2026-04-22 16:26:31'),
(83, 1, 'attack', 'attack', '2026-04-22 16:26:40'),
(84, 1, 'typed', 'find a way to the boss room but before then try to heal up by resting for 2 hours and then map the place and plan the next move', '2026-04-22 16:40:07'),
(85, 1, 'hide', 'hide', '2026-04-22 16:40:57'),
(86, 1, 'typed', 'Observe Warden movement patterns', '2026-04-22 16:41:33'),
(87, 1, 'defend', 'defend', '2026-04-22 16:42:45'),
(88, 1, 'typed', 'Attempt to identify structural weaknesses in the passage.', '2026-04-22 16:43:00'),
(89, 1, 'typed', 'i run away be it kills me', '2026-04-22 16:43:38'),
(90, 1, 'typed', 'run to a save point', '2026-04-22 16:44:39'),
(91, 1, 'move', 'my health is low so I run away to a safe place away from the fight', '2026-04-22 17:04:34'),
(92, 1, 'rest', 'rest', '2026-04-22 17:05:07'),
(93, 1, 'rest', 'rest', '2026-04-22 17:05:19'),
(94, 1, 'rest', 'rest till i get my full health', '2026-04-22 17:05:40'),
(95, 1, 'typed', 'i cut my self to see my own blood', '2026-04-22 17:10:25'),
(96, 1, 'typed', 'Search the corpse for salvageable assets.', '2026-04-22 17:11:07'),
(97, 1, 'rest', 'Rest to optimize stamina before progression.', '2026-04-22 17:11:32'),
(98, 1, 'rest', 'rest till my health is full', '2026-04-22 17:12:10'),
(99, 1, 'rest', 'Continue resting to reach full capacity.', '2026-04-22 17:16:34'),
(100, 1, 'rest', 'Continue resting to reach full capacity.', '2026-04-22 17:24:10'),
(101, 1, 'look', 'Search the area for loot.', '2026-04-22 17:24:27'),
(102, 1, 'attack', 'attack', '2026-04-22 17:24:42'),
(103, 1, 'attack', 'attack', '2026-04-22 17:29:57'),
(104, 1, 'look', 'look', '2026-04-22 17:31:17'),
(105, 1, 'rest', 'Rest to recover remaining 2 HP.', '2026-04-22 17:31:51'),
(106, 1, 'typed', 'Practice combat drills to refine dexterity.', '2026-04-22 17:32:06'),
(107, 1, 'typed', 'Examine the corpse for gear.', '2026-04-22 17:32:31'),
(108, 1, 'typed', 'Use a defensive stance to mitigate initial damage.', '2026-04-22 17:32:41'),
(109, 1, 'typed', 'take out his eye with a full on speed attack', '2026-04-22 17:33:44'),
(110, 1, 'typed', 'Utilize Adaptive Insight to analyze movement patterns.', '2026-04-22 17:34:34'),
(111, 1, 'attack', 'attack', '2026-04-22 17:35:10'),
(112, 1, 'attack', 'attack', '2026-04-22 17:35:37'),
(113, 1, 'typed', 'use appraised and self', '2026-04-22 17:36:54'),
(114, 1, 'typed', 'Proceed deeper into the floor.', '2026-04-22 17:37:28'),
(115, 1, 'typed', 'i saw a group of gobiln up to 10 and i set and trap for them and start the killing', '2026-04-22 17:39:01');

-- --------------------------------------------------------

--
-- Table structure for table `player_ascension_results`
--

CREATE TABLE `player_ascension_results` (
  `id` int(11) NOT NULL,
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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_boss_defeats`
--

CREATE TABLE `player_boss_defeats` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `boss_id` int(11) NOT NULL,
  `floor_number` int(11) NOT NULL,
  `defeated_life_number` int(11) NOT NULL,
  `defeated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_carryover_traits`
--

CREATE TABLE `player_carryover_traits` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `ascension_id` int(11) NOT NULL,
  `trait_key` varchar(120) NOT NULL,
  `trait_type` varchar(30) NOT NULL DEFAULT 'passive',
  `name` varchar(120) NOT NULL,
  `effect_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`effect_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_condition_stats`
--

CREATE TABLE `player_condition_stats` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `stat_key` varchar(160) NOT NULL,
  `stat_value` int(11) NOT NULL DEFAULT 0,
  `metadata_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_condition_stats`
--

INSERT INTO `player_condition_stats` (`id`, `player_id`, `stat_key`, `stat_value`, `metadata_json`, `created_at`, `updated_at`) VALUES
(1, 1, 'enemies_killed', 10, NULL, '2026-04-19 19:37:54', '2026-04-22 17:35:37'),
(2, 1, 'times_hidden', 1, NULL, '2026-04-19 19:37:54', '2026-04-22 16:40:57'),
(3, 1, 'times_rested', 13, '{\"source\":\"typed_intent\"}', '2026-04-19 19:37:54', '2026-04-22 17:31:51'),
(4, 1, 'times_appraised', 3, '{\"source\":\"typed_intent\"}', '2026-04-19 19:37:54', '2026-04-22 16:40:07'),
(5, 1, 'typed_actions_count', 55, '{\"last_action\":\"i saw a group of gobiln up to 10 and i set and trap for them and start the killing\"}', '2026-04-19 19:37:54', '2026-04-22 17:39:01'),
(142, 1, 'enemy_killed:goblin_scout', 6, '{\"enemy_name\":\"Goblin Scout\",\"enemy_type\":\"normal\"}', '2026-04-19 23:29:38', '2026-04-22 17:29:57'),
(143, 1, 'enemy_type_killed:normal', 10, '{\"enemy_type\":\"normal\"}', '2026-04-19 23:29:38', '2026-04-22 17:35:37'),
(854, 1, 'enemy_killed:cracked_bone_rat', 3, '{\"enemy_name\":\"Cracked Bone Rat\",\"enemy_type\":\"normal\"}', '2026-04-20 00:41:36', '2026-04-22 16:26:40'),
(920, 1, 'intent:precision_attack', 1, '{\"last_action\":\"take out his eye with a full on speed attack\",\"approach\":\"normal\",\"risk_level\":\"medium\",\"resolution_type\":\"partial_success\"}', '2026-04-20 01:25:45', '2026-04-22 17:33:44'),
(921, 1, 'intent:environment_attack', 0, NULL, '2026-04-20 01:25:45', '2026-04-20 01:25:45'),
(922, 1, 'intent:hide', 0, NULL, '2026-04-20 01:25:45', '2026-04-20 01:25:45'),
(923, 1, 'intent:devour_remains', 0, NULL, '2026-04-20 01:25:45', '2026-04-20 01:25:45'),
(924, 1, 'intent:social', 0, NULL, '2026-04-20 01:25:45', '2026-04-20 01:25:45'),
(925, 1, 'risk:high', 0, NULL, '2026-04-20 01:25:45', '2026-04-20 01:25:45'),
(949, 1, 'intent:observe', 17, '{\"last_action\":\"i saw a group of gobiln up to 10 and i set and trap for them and start the killing\",\"approach\":\"normal\",\"risk_level\":\"low\",\"resolution_type\":\"success\"}', '2026-04-20 01:26:01', '2026-04-22 17:39:01'),
(1019, 1, 'intent:direct_attack', 2, '{\"last_action\":\"Attack the scout with everything you have.\",\"approach\":\"normal\",\"risk_level\":\"low\",\"resolution_type\":\"partial_success\"}', '2026-04-20 01:26:41', '2026-04-20 01:27:57'),
(1523, 1, 'intent:rest', 7, '{\"last_action\":\"rest to recover remaining 2 hp\",\"approach\":\"normal\",\"risk_level\":\"low\",\"resolution_type\":\"success\"}', '2026-04-22 16:40:07', '2026-04-22 17:31:51'),
(1524, 1, 'intent:map_area', 1, '{\"last_action\":\"map the place\",\"approach\":\"normal\",\"risk_level\":\"low\",\"resolution_type\":\"success\"}', '2026-04-22 16:40:07', '2026-04-22 16:40:07'),
(1525, 1, 'intent:plan_next_move', 1, '{\"last_action\":\"plan the\",\"approach\":\"normal\",\"risk_level\":\"low\",\"resolution_type\":\"success\"}', '2026-04-22 16:40:07', '2026-04-22 16:40:07'),
(1527, 1, 'intent:move_toward_objective', 1, '{\"last_action\":\"find a way to the boss room\",\"approach\":\"normal\",\"risk_level\":\"medium\",\"resolution_type\":\"success\"}', '2026-04-22 16:40:07', '2026-04-22 16:40:07'),
(1765, 1, 'intent:escape', 1, '{\"last_action\":\"my health is low so i run away to a safe place away from the fight\",\"approach\":\"normal\",\"risk_level\":\"medium\",\"resolution_type\":\"success\"}', '2026-04-22 17:04:34', '2026-04-22 17:04:34'),
(1959, 1, 'intent:loot_remains', 2, '{\"last_action\":\"examine the corpse for gear\",\"approach\":\"normal\",\"risk_level\":\"low\",\"resolution_type\":\"success\"}', '2026-04-22 17:11:07', '2026-04-22 17:32:31'),
(2201, 1, 'intent:scout_area', 1, '{\"last_action\":\"search the area for loot\",\"approach\":\"normal\",\"risk_level\":\"low\",\"resolution_type\":\"success\"}', '2026-04-22 17:24:27', '2026-04-22 17:24:27'),
(2663, 1, 'enemy_killed:dust_skitter', 1, '{\"enemy_name\":\"Dust Skitter\",\"enemy_type\":\"normal\"}', '2026-04-22 17:35:37', '2026-04-22 17:35:37');

-- --------------------------------------------------------

--
-- Table structure for table `player_current_boss`
--

CREATE TABLE `player_current_boss` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `boss_id` int(11) NOT NULL,
  `boss_current_hp` int(11) NOT NULL,
  `encounter_state` varchar(50) NOT NULL DEFAULT 'active',
  `trigger_revealed_at` timestamp NULL DEFAULT NULL,
  `started_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_current_boss`
--

INSERT INTO `player_current_boss` (`id`, `player_id`, `boss_id`, `boss_current_hp`, `encounter_state`, `trigger_revealed_at`, `started_at`, `updated_at`) VALUES
(1, 1, 2, 46, 'escaped', '2026-04-22 16:40:07', '2026-04-22 16:40:07', '2026-04-22 17:04:34');

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
(3, 1, 8, 15, 'active', '2026-04-19 23:35:34', '2026-04-22 17:39:01');

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
(8, 1, 'A New Presence Emerges', 'Observation successful. The intended ambush site has revealed a secondary entity: a Dust Skitter. The creature remains tethered to the terrain, utilizing debris for concealment. Analysis complete; target data indexed. The goblin group remains within the immediate perimeter of the Quiet Seal Alcove.', 'encounter', '[\"Initiate tactical engagement on the Dust Skitter.\",\"Execute trap deployment on the goblin group.\",\"Activate Combat Focus and engage the goblin group.\",\"Utilize Adaptive Insight to analyze goblin weaknesses.\",\"Reposition to exploit cover for a surprise attack.\"]', 1, '2026-04-19 13:29:39', '2026-04-22 17:39:25');

-- --------------------------------------------------------

--
-- Table structure for table `player_deaths`
--

CREATE TABLE `player_deaths` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `life_number` int(11) NOT NULL,
  `death_cause` varchar(180) DEFAULT NULL,
  `floor_number` int(11) NOT NULL DEFAULT 1,
  `area` varchar(120) DEFAULT NULL,
  `year_survived` int(11) NOT NULL DEFAULT 1,
  `day_survived` int(11) NOT NULL DEFAULT 1,
  `current_hour` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_dungeon_completions`
--

CREATE TABLE `player_dungeon_completions` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `completed_life_number` int(11) NOT NULL,
  `floor_reached` int(11) NOT NULL DEFAULT 100,
  `status` varchar(40) NOT NULL DEFAULT 'awaiting_wish',
  `completed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `ascended_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_dungeon_run_history`
--

CREATE TABLE `player_dungeon_run_history` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `life_number` int(11) NOT NULL,
  `highest_floor` int(11) NOT NULL DEFAULT 1,
  `run_result` varchar(50) NOT NULL DEFAULT 'in_progress',
  `summary_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`summary_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_dungeon_state`
--

CREATE TABLE `player_dungeon_state` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_dungeon_state`
--

INSERT INTO `player_dungeon_state` (`id`, `player_id`, `floor_number`, `max_floor_unlocked`, `exploration_score`, `progression_clues`, `hidden_exit_found`, `boss_triggered`, `floor_boss_defeated`, `last_event_key`, `metadata_json`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 19, 5, 1, 1, 0, 'progression_clue', NULL, '2026-04-19 19:43:04', '2026-04-22 17:39:01');

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
(1, 1, 1, '2026-04-19 15:01:01'),
(4, 1, 2, '2026-04-20 00:21:04'),
(5, 1, 3, '2026-04-20 00:39:26'),
(7, 1, 4, '2026-04-20 01:26:01'),
(8, 1, 5, '2026-04-20 01:31:16'),
(9, 1, 6, '2026-04-22 17:24:27'),
(10, 1, 7, '2026-04-22 17:32:31'),
(11, 1, 8, '2026-04-22 17:39:01');

-- --------------------------------------------------------

--
-- Table structure for table `player_final_wishes`
--

CREATE TABLE `player_final_wishes` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `completion_id` int(11) NOT NULL,
  `wish_text` text NOT NULL,
  `interpreted_intent` varchar(80) NOT NULL,
  `interpretation_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`interpretation_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_rebirth_wishes`
--

CREATE TABLE `player_rebirth_wishes` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `life_number` int(11) NOT NULL,
  `wish_text` varchar(240) NOT NULL,
  `granted_effect_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`granted_effect_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_remains`
--

CREATE TABLE `player_remains` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `source_type` varchar(30) NOT NULL,
  `source_id` int(11) DEFAULT NULL,
  `enemy_name` varchar(120) NOT NULL,
  `enemy_type` varchar(50) DEFAULT NULL,
  `loot_state` varchar(30) NOT NULL DEFAULT 'available',
  `inspect_state` varchar(30) NOT NULL DEFAULT 'available',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `consumed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_remains`
--

INSERT INTO `player_remains` (`id`, `player_id`, `source_type`, `source_id`, `enemy_name`, `enemy_type`, `loot_state`, `inspect_state`, `created_at`, `expires_at`, `consumed_at`) VALUES
(1, 1, 'enemy', 4, 'Goblin Scout', 'normal', 'available', 'available', '2026-04-20 01:29:59', '2026-04-20 07:29:59', NULL),
(2, 1, 'enemy', 5, 'Cracked Bone Rat', 'normal', 'claimed', 'available', '2026-04-22 16:26:40', '2026-04-22 22:26:40', NULL),
(3, 1, 'enemy', 6, 'Goblin Scout', 'normal', 'claimed', 'available', '2026-04-22 17:29:57', '2026-04-22 23:29:57', NULL),
(4, 1, 'enemy', 7, 'Dust Skitter', 'normal', 'available', 'available', '2026-04-22 17:35:37', '2026-04-22 23:35:37', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `player_scene_environment`
--

CREATE TABLE `player_scene_environment` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `area_name` varchar(120) NOT NULL,
  `tags_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`tags_json`)),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_scene_environment`
--

INSERT INTO `player_scene_environment` (`id`, `player_id`, `area_name`, `tags_json`, `updated_at`) VALUES
(1, 1, 'Floor 1 Quiet Seal Alcove', '[\"corpse_present\",\"cover_available\"]', '2026-04-22 17:39:01');

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
(23, 1, 'A New Presence Emerges', 'You feel the dungeon breathing around you, but nothing answers yet.', 'encounter', '2026-04-19 15:01:15'),
(24, 1, 'An Unscripted Move', 'Structural integrity scan complete. The Dust Chamber exhibits significant stress fractures along the northern load-bearing pillar. Tactical inefficiency detected: Goblin Scout engaged. Entity is currently aware of your presence. Immediate conflict is mathematically inevitable.', 'typed_action', '2026-04-19 19:57:33'),
(25, 1, 'An Unscripted Move', 'Scan complete. One target identified: Goblin Scout, Level 1. Proximity: 12 meters. Combat status: Neutral. Current HP: 40/40. Survival probability at current stats: 84%.', 'typed_action', '2026-04-19 19:58:37'),
(26, 1, 'Eyes on the Dark', 'Environment scan complete. Dust Chamber floor 1. Structural integrity stable. Light levels low. Goblin Scout identified at 4 meters. Threat assessment: Minimal, yet hazardous if neglected. Allocation of 8 unused stat points is pending. Decision required.', 'action', '2026-04-19 23:26:26'),
(27, 1, 'Steel Meets Flesh', 'Hostile engagement ongoing. Player attack successful: 5 damage. Counter-attack received: 2 damage. Goblin Scout HP reduced to 13. Player HP at 38/40. Efficiency rating: Suboptimal. Survival probability remains high, provided tactical adjustment occurs.', 'battle', '2026-04-19 23:26:53'),
(28, 1, 'Steel Meets Flesh', 'Engagement analyzed. Hostile unit health reduced to 8/18. Player integrity remains at 36/40. Goblin Scout retaliatory strike registered; defense failure detected. Combat state: ongoing.', 'battle', '2026-04-19 23:27:20'),
(29, 1, 'Measured Observation', 'Target identified: Goblin Scout. Status: Injured. Current HP 8/18. Threat level: Low. Environmental light conditions favor evasion. Immediate action required to minimize resource depletion.', 'utility', '2026-04-19 23:27:45'),
(30, 1, 'Steel Meets Flesh', 'Engagement outcome: Player dealt 5 damage. Goblin Scout retaliated for 2 damage. Current Player HP: 34/40. Current Enemy HP: 3/18. Target is critical. Probability of termination in next strike: 94%.', 'battle', '2026-04-19 23:29:13'),
(31, 1, 'Eyes on the Dark', 'Environment: Dust Chamber. Status: Compromised. Target identified: Goblin Scout, 16.6% structural integrity remaining. Immediate threat detected. Proximity: Close. Failure to neutralize will result in tactical disadvantage.', 'action', '2026-04-19 23:29:28'),
(32, 1, 'Steel Meets Flesh', 'Hostile entity neutralized. Dust Chamber scan indicates no immediate secondary threats. Condition \'First Blood\' initialized. System recommends immediate allocation of 8 available stat points to rectify efficiency deficits.', 'battle', '2026-04-19 23:29:47'),
(33, 1, 'A Familiar Threat Returns', 'Hostile entity identified: Goblin Scout, Level 1. Target health: 18/18. Subject health: 34/40. Tactical advantage neutral. Current location: Dust Chamber. Engagement is inevitable for floor progression.', 'encounter', '2026-04-19 23:30:43'),
(34, 1, 'Steel Meets Flesh', 'Engagement report: Entity \'Goblin Scout\' HP reduced to 13. Player HP reduced to 32. Hostile retaliatory protocols active. Combat efficiency at 72%.', 'battle', '2026-04-19 23:31:06'),
(35, 1, 'An Unscripted Move', 'Analysis complete. Target: Goblin Scout. Weakness detected: Exposed cervical vertebrae due to posture. Defensive rating low. Intelligence: Inferior. Probability of successful strike: 84%. Current HP status indicates vulnerability to sustained aggression.', 'typed_action', '2026-04-19 23:31:17'),
(36, 1, 'An Unscripted Move', 'Disarmament sequence initiated. Probability of success: 38%. Target remains armed. Strength discrepancy identified. Counter-maneuver imminent.', 'typed_action', '2026-04-19 23:31:48'),
(37, 1, 'An Unscripted Move', 'Aggressive engagement initiated. Player output exceeds current stamina efficiency. Target: Goblin Scout. Enemy HP reduced to 5. Tactical over-extension observed. Current heart rate elevation suboptimal.', 'typed_action', '2026-04-19 23:33:05'),
(38, 1, 'Steel Meets Flesh', 'Engagement analysis: Primary target Goblin Scout sustained 5 damage. Counter-maneuver executed. Player HP remains static at 30/40. Enemy health at 8/18. Combat state: Ongoing. Efficiency requires immediate termination to minimize resource drain.', 'battle', '2026-04-19 23:33:53'),
(39, 1, 'An Unscripted Move', 'Combat initiation confirmed. Target: Goblin Scout. Enemy HP: 18/18. Player Strength: 4. Deficit in raw output detected. Probability of neutral outcome: 64%. Probability of injury: 36%.', 'typed_action', '2026-04-19 23:33:59'),
(40, 1, 'An Unscripted Move', 'Stat allocation command received. Strength increased from 4 to 12. Physical output efficiency optimized by 200%. Goblin Scout remains hostile, unaware of current power delta. Engagement is imminent.', 'typed_action', '2026-04-19 23:34:19'),
(41, 1, 'Steel Meets Flesh', 'Engagement ongoing. Player attack successful. Enemy retaliated with low-impact strike. Target HP: 3. Probability of target lethality remains high. Status: Efficient.', 'battle', '2026-04-19 23:34:37'),
(42, 1, 'Steel Meets Flesh', 'Target neutralized. Level incremented. System analysis confirms 11 stat points pending allocation. Passive skills \'Survivor Instinct\' and \'First Blood\' registered. Environmental integrity in Dust Chamber remains stable. Current probability of immediate threat detected as low.', 'battle', '2026-04-19 23:34:55'),
(43, 1, 'A Familiar Threat Returns', 'Stat allocation processed. Dexterity incremented to 5. Environmental scan indicates Goblin Scout presence in Dust Chamber. Enemy previously cataloged. HP deficit detected: 28/40. Threat assessment: Moderate. Intelligence dynamic skill unlocked: Adaptive Insight active.', 'encounter', '2026-04-19 23:35:47'),
(44, 1, 'Measured Observation', 'You feel the dungeon breathing around you, but nothing answers yet.', 'utility', '2026-04-20 00:11:35'),
(45, 1, 'Steel Meets Flesh', 'You feel the dungeon breathing around you, but nothing answers yet.', 'battle', '2026-04-20 00:11:53'),
(46, 1, 'Steel Meets Flesh', 'You feel the dungeon breathing around you, but nothing answers yet.', 'battle', '2026-04-20 00:12:08'),
(47, 1, 'Steel Meets Flesh', 'You feel the dungeon breathing around you, but nothing answers yet.', 'battle', '2026-04-20 00:12:29'),
(48, 1, 'Steel Meets Flesh', 'You feel the dungeon breathing around you, but nothing answers yet.', 'battle', '2026-04-20 00:12:47'),
(49, 1, 'Breathing Space', 'You feel the dungeon breathing around you, but nothing answers yet.', 'action', '2026-04-20 00:13:21'),
(50, 1, 'Breathing Space', 'You feel the dungeon breathing around you, but nothing answers yet.', 'action', '2026-04-20 00:13:33'),
(51, 1, 'Breathing Space', 'You feel the dungeon breathing around you, but nothing answers yet.', 'action', '2026-04-20 00:13:42'),
(52, 1, 'Eyes on the Dark', 'Environment scan: Dust Chamber. Status: Sterile. Probability of immediate resource acquisition in this sector remains zero. Stat points pending allocation. Inefficiency detected in current idle state.', 'action', '2026-04-20 00:19:05'),
(53, 1, 'A Careful Advance', 'Movement concluded. Floor 1 status: static. Environment scan reveals negligible utility in current quadrant. Resource expenditure is inefficient. Statistical potential via point allocation remains unoptimized.', 'action', '2026-04-20 00:20:52'),
(54, 1, 'A New Presence Emerges', 'Rest cycle interrupted. Hostile entity \'Goblin Scout\' identified within perimeter. Subject HP recovery incomplete. Optimal combat engagement required to prevent resource depletion.', 'encounter', '2026-04-20 00:21:06'),
(55, 1, 'Steel Meets Flesh', 'Hostile engagement ongoing. Player attack yielded 5 damage. Counter-attack received: 2 damage. Current Player HP: 35/40. Target HP: 13/18. Efficiency ratio sub-optimal.', 'battle', '2026-04-20 00:21:23'),
(56, 1, 'Steel Meets Flesh', 'Exchange confirmed. Player dealt 5 damage. Goblin Scout retaliated, dealing 2 damage. Current HP: 33/40. Enemy HP: 8/18. Combat state: Ongoing.', 'battle', '2026-04-20 00:21:27'),
(57, 1, 'An Unscripted Move', 'Target status: 8/18 HP remaining. Critical threshold not yet reached. Combat efficiency suboptimal. Eleven stat points are currently unallocated; failure to optimize physical parameters increases risk of attrition.', 'typed_action', '2026-04-20 00:21:31'),
(58, 1, 'An Unscripted Move', 'Adaptive Insight activated. Structural analysis of Floor 1 Broken Hall reveals stress fractures in the supporting pillars directly above the Goblin Scout. Collapse probability: 84%. Tactical window limited.', 'typed_action', '2026-04-20 00:21:48'),
(59, 1, 'An Unscripted Move', 'Stat allocation finalized. Strength increased by 11 points. Current Strength: 15. Impact force potential adjusted to maximum efficiency. Target \'Goblin Scout\' remains hostile, current HP 8/18.', 'typed_action', '2026-04-20 00:21:53'),
(60, 1, 'An Unscripted Move', 'Strike initiated. Vector: Direct. Goblin Scout HP reduced from 18 to 8. Target remains combat-capable. Threat level persists. Survival efficiency at 82.5%.', 'typed_action', '2026-04-20 00:21:57'),
(61, 1, 'An Unscripted Move', 'Target mobility compromised. Goblin Scout HP reduced to 8/18. Structural integrity of the target\'s lower limbs failing under precise kinetic application. Combat efficiency remains suboptimal; immediate elimination is required to minimize potential damage accrual.', 'typed_action', '2026-04-20 00:22:03'),
(62, 1, 'An Unscripted Move', 'Target neutralized. Lethal strike confirmed. Objective status: Success. The Goblin Scout has ceased biological function. Efficiency rating: Optimal. Experience gain detected. You possess 11 unused stat points. System recommends immediate allocation to maximize survival probability.', 'typed_action', '2026-04-20 00:22:27'),
(63, 1, 'An Unscripted Move', 'Stat allocation command executed. Dexterity increased to 15. Remaining stat points: 0. System efficiency optimization: Complete. Enemy Goblin Scout identified at 3 meters. Biological metrics: Stable. Engagement probability: High.', 'typed_action', '2026-04-20 00:22:46'),
(64, 1, 'An Unscripted Move', 'Hostile engagement initiated. Goblin Scout detected. Target vitality: 18/18. Player structural integrity: 33/40. Adaptive Insight active. Combat probability matrix initialized.', 'typed_action', '2026-04-20 00:22:53'),
(65, 1, 'An Unscripted Move', 'Stat allocation interface initialized. 11 points available. Current combat efficiency is suboptimal; probability of lethal outcome against encountered hostiles remains high without enhancement. Suggest prioritizing Strength for damage throughput or Stamina for survivability.', 'typed_action', '2026-04-20 00:22:57'),
(66, 1, 'An Unscripted Move', 'Stat allocation confirmed. Strength increased to 9. Stamina increased to 10. Stat points depleted. Neural-muscular efficiency optimized for sustained engagement. Target: Goblin Scout. HP: 8/18. Distance: Close-quarters.', 'typed_action', '2026-04-20 00:23:00'),
(67, 1, 'Steel Meets Flesh', 'Engagement update: Entity Goblin Scout hp reduced to 3. Player hp stability maintained at 31. Enemy counter-attack executed with 2 damage. Efficiency remains suboptimal. Target is critical.', 'battle', '2026-04-20 00:23:05'),
(68, 1, 'Steel Meets Flesh', 'Target neutralized. EXP threshold updated to 20/??. Passive skill \'Goblin Scout Slayer\' has been integrated into core protocols. System analysis indicates 11 unallocated stat points; lethality remains suboptimal. Current environment: Floor 1, Broken Hall. Status: Clear.', 'battle', '2026-04-20 00:23:09'),
(69, 1, 'Breathing Space', 'Oh, how precious. You curl up in the dust of the Broken Hall, nursing your 36 hit points like they\'re a life-altering treasure. The shadows here are lengthening, and they seem to be whispering about your next mistake. Do you really think a few moments of quiet will save you from what\'s crawling in the dark? The dungeon is bored of your stillness.', 'action', '2026-04-20 00:39:05'),
(70, 1, 'A New Presence Emerges', 'Oh, look what the dungeon dragged in—a skittering little nightmare held together by calcified spite. The Cracked Bone Rat watches you with hungry, hollow eyes, sniffing the air for the scent of your very marrow. It’s pathetic, really, but even a rat can nibble a hero down to the bone if they\'re slow enough. Don\'t look so shocked; did you think the shadows were empty?', 'encounter', '2026-04-20 00:39:29'),
(71, 1, 'Steel Meets Flesh', 'Oh, how clumsy. You swung your weapon with all the grace of a drunken bricklayer, leaving yourself wide open. The Cracked Bone Rat didn\'t hesitate to remind you of your mortality—a small scratch, but a delicious reminder that even the smallest vermin can draw blood when you\'re busy fumbling. It sits there, shivering on five measly health points. Finish it, or shall we let it nibble your ankles until you fall?', 'battle', '2026-04-20 00:39:48'),
(72, 1, 'An Unscripted Move', 'Oh, how quaint. You try to play the hero with such surgical precision, yet here is your target—a mangy, bone-crusted vermin—still twitching despite your best efforts. It’s barely holding on, clinging to its wretched life like you cling to your vanity. You didn\'t finish it, darling; you just made it angry. Shall we try not to be so clumsy next time, or are you hoping to provide the rat with a trophy?', 'typed_action', '2026-04-20 00:40:20'),
(73, 1, 'An Unscripted Move', 'Oh, how quaint! You fancy yourself a titan, crashing your heel down onto the Cracked Bone Rat like a bored god squashing a gnat. The tiles groan, the creature squeaks—a pathetic, rhythmic crunch that echoes through the Broken Hall. It’s still twitching, though. Did you miss the mark, or are you just savoring the way its marrow paints the floor?', 'typed_action', '2026-04-20 00:40:34'),
(74, 1, 'An Unscripted Move', 'Such cruelty! You grind the brittle remains of that pathetic rodent into a fine, calcium-rich powder beneath your boot. The echo of snapping bone dances through the Broken Hall, drawing whispers from the shadows that you aren\'t quite ready to hear yet. You have quite the appetite for destruction, don\'t you? It’s almost charming, in a doomed sort of way.', 'typed_action', '2026-04-20 00:41:32'),
(75, 1, 'Steel Meets Flesh', 'A pathetic splatter of fur and brittle calcium is all that remains of your pest. How violent, how... efficient. Your bloodlust has finally sharpened your senses—a little trick of the mind called \'Normal Hunter.\' You’re becoming quite the expert at clearing out the rubbish of this hall. Tell me, does the smell of decay stir something, or are you just getting hungry?', 'battle', '2026-04-20 00:41:46'),
(76, 1, 'A Familiar Threat Returns', 'Oh, how charmingly predictable. You went digging through the trash, and look who decided to crawl out for an encore—a Cracked Bone Rat. Did you miss its sharp, calcium-caked teeth? Or did you just forget that some things don\'t stay dead when you disturb their resting place? The Broken Hall isn\'t a graveyard; it\'s a dinner theater, and you\'re the main course.', 'encounter', '2026-04-20 00:46:18'),
(77, 1, 'Steel Meets Flesh', 'Oh, how precious. You swung your little limb and left the rodent a shivering mess of splintered bone, but it didn\'t appreciate the gesture. It lunged back, leaving a stinging reminder on your skin. You\'re bleeding, darling—just a trickle, but enough to make the shadows in this hall watch with hungry anticipation. The rat is rattling its last, and you\'re standing there wondering if you\'re the hunter or just the next course.', 'battle', '2026-04-20 00:49:14'),
(78, 1, 'Steel Meets Flesh', 'Oh, how precious. You crushed that vermin into dust, and look—you\'ve grown. You\'re level two now, a whole step closer to being a threat worth noticing. The bones in this hall are whispering about your \'Normal Hunter\' potential, though I suppose you\'re still just a clumsy scavenger in the dark. Three shiny stat points sitting there, waiting to be spent on a future that\'s likely just as bleak as your past. Don\'t take too long to decide; the shadows aren\'t as empty as they look.', 'battle', '2026-04-20 00:49:47'),
(79, 1, 'A New Presence Emerges', 'Oh, how precious. You puff out your chest, feeling the new weight of your muscles, but the shadows of the Broken Hall have eyes. A Goblin Scout skitters into the light, its nose twitching as it sniffs out your newfound potential. It’s small, yes, but it knows these walls better than you know your own reflection. Don\'t look so surprised; you invited the hunt by showing up at all.', 'encounter', '2026-04-20 01:26:04'),
(80, 1, 'Improvised Clash', 'Oh, how precious. You tried to \'observe\' your way through a knife fight, and the little green nuisance rewarded your academic curiosity with a stinging scratch to your ribs. 30 HP left, and you\'re still playing the scholar while your blood stains the Broken Hall floor. That Goblin Scout is currently giggling at your hesitation. Will you actually fight, or should I start drafting your epitaph?', 'battle', '2026-04-20 01:26:21'),
(81, 1, 'Improvised Clash', 'A crude, satisfying crunch—your blade bites deep into the scout, though the little wretch manages a pathetic, frantic swipe that barely grazes your armor. You stand over it in the morning gloom of the Broken Hall, blood staining the loose sand. It’s twitching, terrified, and very much still alive. Such a messy affair, isn\'t it? The air smells of ozone and iron, and I suspect there\'s a whisper in the stone just behind you, hoping you\'re too distracted by this pathetic vermin to notice.', 'battle', '2026-04-20 01:26:56'),
(82, 1, 'Improvised Clash', 'Oh, how precious. You try to play the executioner, but your hesitation turns a \'finishing blow\' into a fumbling observation. The goblin scout isn\'t dead—it\'s laughing, and it just carved a nasty little souvenir into your armor. Your health dips to 26, and your dignity? Well, that\'s gone entirely. Are you going to keep staring, or finally commit to the bloodshed?', 'battle', '2026-04-20 01:27:09'),
(83, 1, 'Improvised Clash', 'Oh, how clumsy. You swung with the ferocity of a starving beast, yet managed to catch only the air and a sliver of the scout\'s ear. A \'partial success\'—the dungeon’s way of saying you’re barely competent. You look tired, bleeding slightly, while that wretched creature mocks you from the loose stones. It has 6 health left, and you? You’re fading, but your \'Adaptive Insight\' is humming in your brain like a headache you can\'t quite shake. Still want to play the hero?', 'battle', '2026-04-20 01:27:59'),
(84, 1, 'Impossible Attempt', 'Oh, how precious. You try to scavenge for sustenance in a hall that hasn\'t even had the decency to offer up a corpse yet. You\'re catching your breath behind a pile of rubble while a rather unimpressed Goblin Scout watches you pant. It’s pathetic, really—the way you cling to that wall as if it might feed you. Do you plan to wait until you rot, or are you actually going to do something about that green pest?', 'invalid_action', '2026-04-20 01:28:18'),
(85, 1, 'Improvised Clash', 'Oh, how precious. You spent an hour playing the scholar, unraveling the creature’s gait with such intellectual posturing, only to be rewarded with a jagged blade to your side for your trouble. The Goblin Scout isn\'t interested in your analytical monologues, and honestly? Neither am I. You\'re bleeding, you\'re slow, and you\'re still staring at it like it’s a science project while it clearly finds you quite edible.', 'battle', '2026-04-20 01:28:57'),
(86, 1, 'Impossible Attempt', 'Oh, how precious. You kicked the torch stand like a petulant child throwing a tantrum, expecting a pyre to dance for your amusement. The flames sputtered, the stones remained stubbornly un-burned, and your target—that shivering Goblin Scout—is still very much alive and probably laughing at your theatrics. You are burning daylight, not enemies. Shall we try actually hitting something that bleeds?', 'invalid_action', '2026-04-20 01:29:41'),
(87, 1, 'Steel Meets Flesh', 'Oh, how cute. You\'ve splattered another one of those wretched scouts against the masonry of this Broken Hall. It’s almost pathetic how predictable your violence is becoming—you\'re practically carving your own destiny into the floorboards. You’re level two, feeling strong, and sporting three shiny stat points you haven’t bothered to use yet. Don\'t worry, the dungeon loves a procrastinator; it gives the shadows more time to watch you.', 'battle', '2026-04-20 01:30:01'),
(88, 1, 'A New Presence Emerges', 'Movement detected in Floor 1 Sealed Passage. Analysis: New entity, Cracked Bone Rat (Level 1). Biological fragility detected in skeletal structure. Host health at 55%. Combat engagement imminent.', 'encounter', '2026-04-20 01:31:18'),
(89, 1, 'Improvised Clash', 'Engagement failed. Attempted melee strike resulted in observation. Cracked Bone Rat successfully counter-attacked. 2 HP lost. Current state: HP 20/40. Enemy integrity at 100%.', 'battle', '2026-04-22 16:25:31'),
(90, 1, 'Steel Meets Flesh', 'Engagement outcome: Player landed a critical strike. Enemy retaliation confirmed. Subject HP: 18/40. Target HP: 5/16. Threat assessment remains nominal. Critical vulnerability detected in Cracked Bone Rat skeletal integrity.', 'battle', '2026-04-22 16:26:38'),
(91, 1, 'Steel Meets Flesh', 'Target neutralized. Efficiency verified. Passive trait \'Cracked Bone Rat Slayer\' acquired via repetitive pattern recognition. Current health: 18/40. Physiological state suboptimal. Resource depletion risk: Moderate.', 'battle', '2026-04-22 16:26:45'),
(92, 1, 'The Floor Guardian Appears', 'Rest period complete. Mapping successful. Exploration initiated the hidden seal, triggering a containment protocol. Warden of Floor 1 has materialized. Hostile entity detected. Engagement is inevitable.', 'boss_encounter', '2026-04-22 16:40:25'),
(93, 1, 'Holding Still', 'Stealth successful. Presence signature suppressed. The Warden of Floor 1 continues its patrol cycle, 46/46 HP stable. Proximity remains dangerous. HP: 23/40. Status: Compromised.', 'stealth', '2026-04-22 16:41:17'),
(94, 1, 'Improvised Boss Clash', 'Observation incomplete. Warden movement cycle identified: systematic, linear, predictable. You failed to maintain distance; Warden counter-attack successful. Current health at 47.5%. Sustained physical trauma confirms tactical inferiority.', 'boss_battle', '2026-04-22 16:41:46'),
(95, 1, 'Guarding Against the Warden', 'Defense successful. Damage mitigation effective. Current HP: 17/40. The Warden of Floor 1 remains at full capacity (46/46 HP). Combat efficiency is sub-optimal. The gap in sustain and damage output necessitates immediate strategic recalibration.', 'boss_battle', '2026-04-22 16:42:57'),
(96, 1, 'Improvised Boss Clash', 'Structural analysis complete. The passage exhibits a load-bearing fracture point near the ceiling. Warden of Floor 1 engaged during observation; 4 HP loss sustained. Current HP: 13/40. The structural weakness is vulnerable to kinetic force.', 'boss_battle', '2026-04-22 16:43:13'),
(97, 1, 'Improvised Boss Clash', 'You feel the dungeon breathing around you, but nothing answers yet.', 'boss_battle', '2026-04-22 16:44:11'),
(98, 1, 'Improvised Boss Clash', 'Subject reached the designated save point. HP critical at 5/40. Enemy engagement occurred during transit; enemy attack successful. Warden of Floor 1 remains at 100% capacity. Survival probability significantly degraded.', 'boss_battle', '2026-04-22 16:45:17'),
(99, 1, 'Seal Route Slipped', 'Escape successful. Current location: Floor 1 Quiet Seal Alcove. HP remains at 5/40. Critical threshold reached. Structural integrity of current position is temporary. Contact with hostiles is broken but pursuit status is alert.', 'escape', '2026-04-22 17:04:44'),
(100, 1, 'Breathing Space', 'Rest cycle complete. HP restored to 10/40. Physiological deficit remains high. Current location: Floor 1 Quiet Seal Alcove. Environment stable.', 'action', '2026-04-22 17:05:16'),
(101, 1, 'Breathing Space', 'Rest period concluded. Biological efficiency suboptimal at 37.5% HP. Floor 1 Quiet Seal Alcove remains stable. No immediate threats detected in current perimeter.', 'action', '2026-04-22 17:05:26'),
(102, 1, 'An Unscripted Move', 'Rest cycle completed. Duration: 2 hours. Current HP: 20/40. Physiological recovery stalled by environmental constraints. Floor 1 remains volatile; presence of organic decay noted in alcove. Efficiency is suboptimal.', 'typed_action', '2026-04-22 17:05:51'),
(103, 1, 'Measured Observation', 'Observation complete. Self-inflicted trauma yielded zero tactical data. Biological integrity maintained at 20/40 HP. You remain in the Quiet Seal Alcove; the corpse provides no further utility, and the environment remains stagnant.', 'utility', '2026-04-22 17:10:37'),
(104, 1, 'Searching the Remains', 'Corpse dissected. Salvage success: +1 unit of scrap. Analysis of internal markings reveals a secondary maintenance tunnel, bypassing the primary gate of the Floor 1 Quiet Seal Alcove.', 'loot', '2026-04-22 17:11:14'),
(105, 1, 'Recovery Rest', 'Rest cycle complete. Floor 1 Quiet Seal Alcove. HP restored to 25/40. Stagnation is a statistical inefficiency; current HP reserves remain suboptimal for extended exploration.', 'recovery', '2026-04-22 17:11:47'),
(106, 1, 'Recovery Rest', 'Rest period concluded at Floor 1 Quiet Seal Alcove. HP recovered by 5 units. Current stability: 30/40. Recovery remains incomplete. Environment status: Static. Corpse remains present. Cover remains viable.', 'recovery', '2026-04-22 17:12:18'),
(107, 1, 'Recovery Rest', 'Rest cycle complete. Integrity at 35/40 HP. You remain within the Floor 1 Quiet Seal Alcove. The corpse remains static. Atmospheric conditions indicate mid-afternoon. Further recovery requires additional temporal expenditure.', 'recovery', '2026-04-22 17:16:46'),
(108, 1, 'Full Recovery Rest', 'Rest completed. HP at 40/40. Physiological baseline restored. Quiet Seal Alcove remains stable. No immediate threats detected in the vicinity. Corpse present in immediate area offers no further utility.', 'recovery', '2026-04-22 17:24:24'),
(109, 1, 'A New Presence Emerges', 'Search protocol yielded zero resources. Probability of asset recovery in Floor 1 Quiet Seal Alcove: null. Entity Goblin Scout detected. Target is active; hostility is imminent. Combat engagement is now the primary efficiency metric.', 'encounter', '2026-04-22 17:24:39'),
(110, 1, 'Steel Meets Flesh', 'Engagement persists. Direct strike landed on Goblin Scout, reducing entity HP to 8. Retaliatory damage sustained: 2 HP loss. Current HP: 38/40. Enemy remains active and hostile within the Floor 1 Quiet Seal Alcove.', 'battle', '2026-04-22 17:25:04'),
(111, 1, 'Steel Meets Flesh', 'Target neutralized. Floor 1 Quiet Seal Alcove threat removed. Goblin Scout failed to initiate counter-measures. EXP gain confirmed. Entity status remains optimal.', 'battle', '2026-04-22 17:30:08'),
(112, 1, 'Eyes on the Dark', 'Location: Floor 1 Quiet Seal Alcove. Optical scan complete. Environment static; zero anomalies detected. Remaining HP: 38/40. No immediate threat signature established.', 'action', '2026-04-22 17:31:36'),
(113, 1, 'Recovery Rest', 'Rest completed. Biological integrity at maximum capacity (40/40 HP). The Quiet Seal Alcove remains stagnant; external threat presence unchanged. Corpse remains for potential scavenging or inspection.', 'recovery', '2026-04-22 17:32:03'),
(114, 1, 'Measured Observation', 'Location: Floor 1 Quiet Seal Alcove. Combat drills yielded incidental data. Observation confirms a structural irregularity. A hidden route is present within the alcove, obscured by debris. Analysis suggests immediate tactical advantage if exploited.', 'utility', '2026-04-22 17:32:22'),
(115, 1, 'A New Presence Emerges', 'Examination of the remains yielded no equipment, only debris. The disturbance of the alcove floor triggered the emergence of a Dust Skitter. Threat identified. Enemy is active and hostile. The creature is currently positioned within striking distance.', 'encounter', '2026-04-22 17:32:39'),
(116, 1, 'Improvised Clash', 'Observation successful. The Dust Skitter exploited your transition from defense to neutral, landing a kinetic strike. HP: 39/40. The entity remains active, occupying the Floor 1 Quiet Seal Alcove.', 'battle', '2026-04-22 17:32:54'),
(117, 1, 'Improvised Clash', 'Floor 1 Quiet Seal Alcove. Precision strike landed; 2 damage dealt. Dust Skitter countered during recovery phase, inflicting 1 damage. Current state: Hostile engagement ongoing. Player HP: 38/40. Enemy HP: 13/15.', 'battle', '2026-04-22 17:34:01'),
(118, 1, 'Improvised Clash', 'Observation failed. The Dust Skitter exploited the pause in your defensive stance, connecting with a strike that reduced your integrity to 37/40 HP. You remain within the Floor 1 Quiet Seal Alcove; enemy is active.', 'battle', '2026-04-22 17:35:02'),
(119, 1, 'Steel Meets Flesh', 'Engagement: Floor 1 Quiet Seal Alcove. Strike delivered 11 damage. Dust Skitter remains active with 2 HP. Target countered during recovery; player sustained 1 damage. Current efficiency: Suboptimal.', 'battle', '2026-04-22 17:35:19'),
(120, 1, 'Steel Meets Flesh', 'Target neutralized. Dust Skitter incapacitated; threat variance zero. Biological feedback: Level 3 reached. System integration of Combat Focus complete. Efficiency metrics confirmed: 3 stat points available for reallocation. Location: Floor 1 Quiet Seal Alcove remains stable.', 'battle', '2026-04-22 17:35:44'),
(121, 1, 'Measured Observation', 'Observation sequence concluded. Floor 1 Quiet Seal Alcove remains static. Environmental scan indicates the presence of a corpse, loose substrate, and compromised visibility. No immediate tactical assets identified. Efficiency remains nominal.', 'utility', '2026-04-22 17:37:08'),
(122, 1, 'Measured Observation', 'Observation successful. Floor 1 Quiet Seal Alcove. Analysis of the environment confirms a concealed passage hidden behind the corpse. Route viability established. Path ahead remains precarious.', 'utility', '2026-04-22 17:38:06'),
(123, 1, 'A New Presence Emerges', 'Observation successful. The intended ambush site has revealed a secondary entity: a Dust Skitter. The creature remains tethered to the terrain, utilizing debris for concealment. Analysis complete; target data indexed. The goblin group remains within the immediate perimeter of the Quiet Seal Alcove.', 'encounter', '2026-04-22 17:39:25');

-- --------------------------------------------------------

--
-- Table structure for table `player_skills`
--

CREATE TABLE `player_skills` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `skill_id` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `unlocked_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_skills`
--

INSERT INTO `player_skills` (`id`, `player_id`, `skill_id`, `is_active`, `unlocked_at`) VALUES
(1, 1, 3, 0, '2026-04-19 23:29:38'),
(2, 1, 1, 0, '2026-04-19 23:34:46'),
(3, 1, 4, 1, '2026-04-19 23:35:34'),
(4, 1, 5, 0, '2026-04-20 00:12:43'),
(5, 1, 21, 0, '2026-04-20 00:41:36'),
(6, 1, 39, 0, '2026-04-22 16:26:40'),
(7, 1, 2, 1, '2026-04-22 17:35:37');

-- --------------------------------------------------------

--
-- Table structure for table `player_text_action_interpretations`
--

CREATE TABLE `player_text_action_interpretations` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `action_text` text NOT NULL,
  `interpretation_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`interpretation_json`)),
  `resolution_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`resolution_json`)),
  `resolved_intent` varchar(80) NOT NULL,
  `resolution_type` varchar(80) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_text_action_interpretations`
--

INSERT INTO `player_text_action_interpretations` (`id`, `player_id`, `action_text`, `interpretation_json`, `resolution_json`, `resolved_intent`, `resolution_type`, `created_at`) VALUES
(1, 1, 'Distribute stat points to boost Strength.', '{\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"broken_wall\",\"cover_available\",\"dark_area\",\"loose_sand\",\"loose_stones\",\"low_visibility\",\"torch_stand\",\"wall_present\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"observe\",\"tags_used\":[\"broken_wall\",\"cover_available\",\"dark_area\",\"loose_sand\",\"loose_stones\",\"low_visibility\",\"torch_stand\",\"wall_present\"],\"requested_effect\":null},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'observe', 'success', '2026-04-20 01:26:01'),
(2, 1, 'Engage the Goblin Scout in immediate melee combat.', '{\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"broken_wall\",\"cover_available\",\"dark_area\",\"enemy_present\",\"loose_stones\",\"torch_stand\",\"wall_present\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"observe\",\"target\":null,\"secondary_target\":null,\"requested_effect\":null,\"damage\":0,\"enemy_damage\":2,\"tags_used\":[\"broken_wall\",\"cover_available\",\"dark_area\",\"enemy_present\",\"loose_stones\",\"torch_stand\",\"wall_present\"],\"roll\":13,\"total\":24,\"difficulty\":8},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'observe', 'success', '2026-04-20 01:26:18'),
(3, 1, 'Execute a heavy strike with your weapon.', '{\"intent\":\"direct_attack\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":\"enemy\",\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"broken_wall\",\"cover_available\",\"dark_area\",\"enemy_present\",\"loose_sand\",\"loose_stones\",\"torch_stand\",\"wall_present\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"direct_attack\",\"target\":null,\"secondary_target\":\"enemy\",\"requested_effect\":null,\"damage\":8,\"enemy_damage\":2,\"tags_used\":[\"broken_wall\",\"cover_available\",\"dark_area\",\"enemy_present\",\"loose_sand\",\"loose_stones\",\"torch_stand\",\"wall_present\"],\"roll\":8,\"total\":19,\"difficulty\":8},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'direct_attack', 'success', '2026-04-20 01:26:41'),
(4, 1, 'Execute a finishing blow to silence the scout permanently.', '{\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"broken_wall\",\"cover_available\",\"enemy_present\",\"loose_sand\",\"loose_stones\",\"torch_stand\",\"wall_present\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"observe\",\"target\":null,\"secondary_target\":null,\"requested_effect\":null,\"damage\":0,\"enemy_damage\":2,\"tags_used\":[\"broken_wall\",\"cover_available\",\"enemy_present\",\"loose_sand\",\"loose_stones\",\"torch_stand\",\"wall_present\"],\"roll\":20,\"total\":31,\"difficulty\":8},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'observe', 'success', '2026-04-20 01:27:04'),
(5, 1, 'Attack the scout with everything you have.', '{\"intent\":\"direct_attack\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":\"enemy\",\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"broken_wall\",\"cover_available\",\"enemy_present\",\"loose_sand\",\"loose_stones\",\"torch_stand\",\"wall_present\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"direct_attack\",\"target\":null,\"secondary_target\":\"enemy\",\"requested_effect\":null,\"damage\":4,\"enemy_damage\":2,\"tags_used\":[\"broken_wall\",\"cover_available\",\"enemy_present\",\"loose_sand\",\"loose_stones\",\"torch_stand\",\"wall_present\"],\"roll\":3,\"total\":14,\"difficulty\":8},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'direct_attack', 'partial_success', '2026-04-20 01:27:57'),
(6, 1, 'Use the broken wall for cover and recover your breath.', '{\"intent\":\"devour_remains\",\"approach\":\"normal\",\"target\":\"wall\",\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":\"gain_cover\",\"tags_considered\":[\"broken_wall\",\"cover_available\",\"enemy_present\",\"loose_sand\",\"loose_stones\",\"torch_stand\",\"wall_present\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"none\",\"reason\":\"No usable remains are present in the current scene.\"},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'devour_remains', 'invalid_attempt', '2026-04-20 01:28:16'),
(7, 1, 'Use Adaptive Insight to analyze the Goblin Scout\'s movement.', '{\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"broken_wall\",\"corpse_present\",\"cover_available\",\"enemy_present\",\"loose_stones\",\"torch_stand\",\"wall_present\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"observe\",\"target\":null,\"secondary_target\":null,\"requested_effect\":null,\"damage\":0,\"enemy_damage\":2,\"tags_used\":[\"broken_wall\",\"corpse_present\",\"cover_available\",\"enemy_present\",\"loose_stones\",\"torch_stand\",\"wall_present\"],\"roll\":6,\"total\":17,\"difficulty\":8},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'observe', 'success', '2026-04-20 01:28:55'),
(8, 1, 'Kick the nearby torch stand to create a wall of fire.', '{\"intent\":\"devour_remains\",\"approach\":\"normal\",\"target\":\"wall\",\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":\"burn_target\",\"tags_considered\":[\"broken_wall\",\"cover_available\",\"enemy_present\",\"loose_sand\",\"loose_stones\",\"torch_stand\",\"wall_present\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"none\",\"reason\":\"No usable remains are present in the current scene.\"},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'devour_remains', 'invalid_attempt', '2026-04-20 01:29:37'),
(9, 1, 'Engage Cracked Bone Rat using melee.', '{\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"enemy_present\",\"sealed_door\",\"wall_present\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"observe\",\"target\":null,\"secondary_target\":null,\"requested_effect\":null,\"damage\":0,\"enemy_damage\":2,\"tags_used\":[\"enemy_present\",\"sealed_door\",\"wall_present\"],\"roll\":14,\"total\":25,\"difficulty\":7},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'observe', 'success', '2026-04-22 16:25:19'),
(10, 1, 'find a way to the boss room but before then try to heal up by resting for 2 hours and then map the place and plan the next move', '{\"intent\":\"sequence\",\"is_sequence\":true,\"step_count\":5,\"steps\":[{\"order\":1,\"input\":\"try to heal up by resting for 2 hours\",\"intent\":\"rest\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":\"recover_hp\",\"objective\":null,\"duration_hours\":2,\"action_key\":\"rest\",\"tags_considered\":[\"corpse_present\",\"sealed_door\",\"wall_present\"],\"confidence\":0.82,\"source\":\"backend_rules\"},{\"order\":2,\"input\":\"map the place\",\"intent\":\"map_area\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":\"increase_exploration\",\"objective\":null,\"duration_hours\":null,\"action_key\":\"look\",\"tags_considered\":[\"corpse_present\",\"sealed_door\",\"wall_present\"],\"confidence\":0.82,\"source\":\"backend_rules\"},{\"order\":3,\"input\":\"plan the\",\"intent\":\"plan_next_move\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":\"tactical_plan\",\"objective\":null,\"duration_hours\":null,\"action_key\":\"appraise\",\"tags_considered\":[\"corpse_present\",\"sealed_door\",\"wall_present\"],\"confidence\":0.82,\"source\":\"backend_rules\"},{\"order\":4,\"input\":\"move\",\"action_key\":\"typed\",\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"corpse_present\",\"sealed_door\",\"wall_present\"],\"confidence\":0.78,\"source\":\"backend_rules\"},{\"order\":5,\"input\":\"find a way to the boss room\",\"intent\":\"move_toward_objective\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"medium\",\"requested_effect\":\"move\",\"objective\":\"boss_room\",\"duration_hours\":null,\"action_key\":\"move\",\"tags_considered\":[\"corpse_present\",\"sealed_door\",\"wall_present\"],\"confidence\":0.82,\"source\":\"backend_rules\"}],\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"sequence\",\"steps\":[{\"order\":1,\"input\":\"try to heal up by resting for 2 hours\",\"resolved_intent\":\"rest\",\"resolution_type\":\"success\",\"effect_applied\":{\"type\":\"rest\",\"heal_amount\":5,\"hp_after\":23,\"duration_hours\":2},\"cost\":{\"timeCostHours\":2,\"hpRiskCost\":0}},{\"order\":2,\"input\":\"map the place\",\"resolved_intent\":\"map_area\",\"resolution_type\":\"success\",\"effect_applied\":{\"type\":\"map_area\",\"requested_effect\":\"increase_exploration\",\"objective\":null,\"tags_used\":[\"corpse_present\",\"sealed_door\",\"wall_present\"]},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}],\"stopped_early\":true,\"final_area\":\"Floor 1 Sealed Passage\",\"final_floor\":1},\"cost\":{\"timeCostHours\":3,\"hpRiskCost\":0}}', 'sequence', 'success', '2026-04-22 16:40:07'),
(11, 1, 'Observe Warden movement patterns', '{\"order\":1,\"input\":\"observe warden movement patterns\",\"action_key\":\"typed\",\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"corpse_present\",\"enemy_present\",\"sealed_door\",\"wall_present\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"observe\",\"target\":null,\"secondary_target\":null,\"requested_effect\":null,\"damage\":0,\"enemy_damage\":4,\"tags_used\":[\"corpse_present\",\"enemy_present\",\"sealed_door\",\"wall_present\"],\"roll\":3,\"total\":14,\"difficulty\":9},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'observe', 'partial_success', '2026-04-22 16:41:33'),
(12, 1, 'Attempt to identify structural weaknesses in the passage.', '{\"order\":1,\"input\":\"attempt to identify structural weaknesses in the passage\",\"action_key\":\"typed\",\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"corpse_present\",\"dark_area\",\"enemy_present\",\"sealed_door\",\"wall_present\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"observe\",\"target\":null,\"secondary_target\":null,\"requested_effect\":null,\"damage\":0,\"enemy_damage\":4,\"tags_used\":[\"corpse_present\",\"dark_area\",\"enemy_present\",\"sealed_door\",\"wall_present\"],\"roll\":15,\"total\":26,\"difficulty\":9},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'observe', 'success', '2026-04-22 16:43:00'),
(13, 1, 'i run away be it kills me', '{\"order\":1,\"input\":\"i run away be it kills me\",\"action_key\":\"typed\",\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"corpse_present\",\"dark_area\",\"enemy_present\",\"loose_sand\",\"sealed_door\",\"wall_present\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"observe\",\"target\":null,\"secondary_target\":null,\"requested_effect\":null,\"damage\":0,\"enemy_damage\":4,\"tags_used\":[\"corpse_present\",\"dark_area\",\"enemy_present\",\"loose_sand\",\"sealed_door\",\"wall_present\"],\"roll\":4,\"total\":15,\"difficulty\":9},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'observe', 'partial_success', '2026-04-22 16:43:38'),
(14, 1, 'run to a save point', '{\"order\":1,\"input\":\"run to a save point\",\"action_key\":\"typed\",\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"corpse_present\",\"dark_area\",\"enemy_present\",\"loose_sand\",\"sealed_door\",\"wall_present\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"observe\",\"target\":null,\"secondary_target\":null,\"requested_effect\":null,\"damage\":0,\"enemy_damage\":4,\"tags_used\":[\"corpse_present\",\"dark_area\",\"enemy_present\",\"loose_sand\",\"sealed_door\",\"wall_present\"],\"roll\":15,\"total\":26,\"difficulty\":9},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'observe', 'success', '2026-04-22 16:44:39'),
(15, 1, 'my health is low so I run away to a safe place away from the fight', '{\"order\":1,\"input\":\"my health is low so i run away to a safe place away from the fight\",\"intent\":\"escape\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":\"boss\",\"risk_level\":\"medium\",\"requested_effect\":\"reach_safety\",\"objective\":\"safety\",\"duration_hours\":null,\"action_key\":\"move\",\"tags_considered\":[\"corpse_present\",\"dark_area\",\"enemy_present\",\"loose_sand\",\"sealed_door\",\"wall_present\"],\"confidence\":0.82,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"escape\",\"area_before\":\"Floor 1 Sealed Passage\",\"target\":\"boss\",\"requested_effect\":\"reach_safety\",\"safety_state\":\"escaped\",\"escaped\":true,\"reached_temporary_safety\":false,\"world_reaction\":{\"type\":\"route_slipped\",\"label\":\"Seal Route Slipped\",\"description\":\"The player finds a narrow route through the seal pressure and breaks contact.\",\"danger_level\":\"severe\",\"enemy_awareness\":\"alert\",\"position_pressure\":\"sealed\",\"movement_result\":\"escaped\",\"next_situation\":\"safer_ground\",\"pressure_delta\":-2,\"damage_modifier\":0},\"enemy_pressure\":{\"name\":\"Warden of Floor 1\",\"type\":\"boss\",\"speed\":2,\"level\":2},\"chase_damage\":0,\"hp_after\":5,\"moved\":true,\"tags_used\":[\"corpse_present\",\"dark_area\",\"enemy_present\",\"loose_sand\",\"sealed_door\",\"wall_present\"],\"roll\":16,\"total\":25,\"difficulty\":16,\"destination\":\"Floor 1 Quiet Seal Alcove\"},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":1}}', 'escape', 'success', '2026-04-22 17:04:34'),
(16, 1, 'rest till i get my full health', '{\"order\":1,\"input\":\"rest till i get my full health\",\"intent\":\"rest\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":\"recover_hp\",\"objective\":null,\"duration_hours\":2,\"action_key\":\"rest\",\"tags_considered\":[\"corpse_present\"],\"confidence\":0.82,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"rest\",\"area\":\"Floor 1 Quiet Seal Alcove\",\"heal_amount\":5,\"hp_after\":20,\"duration_hours\":2},\"cost\":{\"timeCostHours\":2,\"hpRiskCost\":0}}', 'rest', 'success', '2026-04-22 17:05:40'),
(17, 1, 'i cut my self to see my own blood', '{\"order\":1,\"input\":\"i cut my self to see my own blood\",\"action_key\":\"typed\",\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"corpse_present\",\"cover_available\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"observe\",\"area\":\"Floor 1 Quiet Seal Alcove\",\"tags_used\":[\"corpse_present\",\"cover_available\"],\"requested_effect\":null},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'observe', 'success', '2026-04-22 17:10:25'),
(18, 1, 'Search the corpse for salvageable assets.', '{\"order\":1,\"input\":\"search the corpse for salvageable assets\",\"action_key\":\"typed\",\"intent\":\"loot_remains\",\"approach\":\"normal\",\"target\":\"corpse\",\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":\"recover_loot\",\"tags_considered\":[\"corpse_present\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"loot_remains\",\"target\":\"Cracked Bone Rat\",\"source_type\":\"enemy\",\"reward\":{\"kind\":\"scrap\",\"amount\":1}},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'loot_remains', 'success', '2026-04-22 17:11:07'),
(19, 1, 'Rest to optimize stamina before progression.', '{\"order\":1,\"input\":\"rest to optimize stamina before progression\",\"intent\":\"rest\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":\"recover_hp\",\"objective\":null,\"duration_hours\":2,\"desired_full_recovery\":false,\"action_key\":\"rest\",\"tags_considered\":[\"corpse_present\"],\"confidence\":0.82,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"rest\",\"area\":\"Floor 1 Quiet Seal Alcove\",\"heal_amount\":5,\"hp_after\":25,\"duration_hours\":2,\"desired_full_recovery\":false,\"recovery_complete\":false},\"cost\":{\"timeCostHours\":2,\"hpRiskCost\":0}}', 'rest', 'success', '2026-04-22 17:11:32'),
(20, 1, 'rest till my health is full', '{\"order\":1,\"input\":\"rest till my health is full\",\"intent\":\"rest\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":\"recover_hp\",\"objective\":null,\"duration_hours\":2,\"desired_full_recovery\":false,\"action_key\":\"rest\",\"tags_considered\":[\"corpse_present\",\"cover_available\"],\"confidence\":0.82,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"rest\",\"area\":\"Floor 1 Quiet Seal Alcove\",\"heal_amount\":5,\"hp_after\":30,\"duration_hours\":2,\"desired_full_recovery\":false,\"recovery_complete\":false},\"cost\":{\"timeCostHours\":2,\"hpRiskCost\":0}}', 'rest', 'success', '2026-04-22 17:12:10'),
(21, 1, 'Continue resting to reach full capacity.', '{\"order\":1,\"input\":\"continue resting to reach full capacity\",\"intent\":\"rest\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":\"recover_hp\",\"objective\":null,\"duration_hours\":2,\"desired_full_recovery\":false,\"rest_intensity\":\"normal\",\"action_key\":\"rest\",\"tags_considered\":[\"corpse_present\",\"cover_available\"],\"confidence\":0.82,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"rest\",\"area\":\"Floor 1 Quiet Seal Alcove\",\"heal_amount\":5,\"hp_after\":35,\"duration_hours\":2,\"desired_full_recovery\":false,\"rest_intensity\":\"normal\",\"recovery_complete\":false},\"cost\":{\"timeCostHours\":2,\"hpRiskCost\":0}}', 'rest', 'success', '2026-04-22 17:16:34'),
(22, 1, 'Continue resting to reach full capacity.', '{\"order\":1,\"input\":\"continue resting to reach full capacity\",\"intent\":\"rest\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":\"full_recovery\",\"objective\":null,\"duration_hours\":2,\"desired_full_recovery\":true,\"rest_intensity\":\"full\",\"action_key\":\"rest\",\"tags_considered\":[\"corpse_present\",\"cover_available\"],\"confidence\":0.82,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"rest\",\"area\":\"Floor 1 Quiet Seal Alcove\",\"heal_amount\":5,\"hp_after\":40,\"duration_hours\":2,\"desired_full_recovery\":true,\"rest_intensity\":\"full\",\"recovery_complete\":true},\"cost\":{\"timeCostHours\":2,\"hpRiskCost\":0}}', 'rest', 'success', '2026-04-22 17:24:10'),
(23, 1, 'Search the area for loot.', '{\"order\":1,\"input\":\"search the area for loot\",\"intent\":\"scout_area\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":\"increase_exploration\",\"objective\":null,\"duration_hours\":null,\"desired_full_recovery\":false,\"rest_intensity\":null,\"action_key\":\"look\",\"tags_considered\":[\"corpse_present\",\"cover_available\"],\"confidence\":0.82,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"scout_area\",\"area\":\"Floor 1 Quiet Seal Alcove\",\"requested_effect\":\"increase_exploration\",\"objective\":null,\"tags_used\":[\"corpse_present\",\"cover_available\"]},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'scout_area', 'success', '2026-04-22 17:24:27'),
(24, 1, 'Rest to recover remaining 2 HP.', '{\"order\":1,\"input\":\"rest to recover remaining 2 hp\",\"intent\":\"rest\",\"approach\":\"normal\",\"target\":\"cover\",\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":\"recover_hp\",\"objective\":null,\"duration_hours\":2,\"desired_full_recovery\":false,\"rest_intensity\":\"normal\",\"action_key\":\"rest\",\"tags_considered\":[\"corpse_present\",\"dark_area\"],\"confidence\":0.82,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"rest\",\"area\":\"Floor 1 Quiet Seal Alcove\",\"heal_amount\":2,\"hp_after\":40,\"duration_hours\":2,\"desired_full_recovery\":false,\"rest_intensity\":\"normal\",\"recovery_complete\":true},\"cost\":{\"timeCostHours\":2,\"hpRiskCost\":0}}', 'rest', 'success', '2026-04-22 17:31:51'),
(25, 1, 'Practice combat drills to refine dexterity.', '{\"order\":1,\"input\":\"practice combat drills to refine dexterity\",\"action_key\":\"typed\",\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"corpse_present\",\"cover_available\",\"dark_area\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"observe\",\"area\":\"Floor 1 Quiet Seal Alcove\",\"tags_used\":[\"corpse_present\",\"cover_available\",\"dark_area\"],\"requested_effect\":null},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'observe', 'success', '2026-04-22 17:32:06'),
(26, 1, 'Examine the corpse for gear.', '{\"order\":1,\"input\":\"examine the corpse for gear\",\"action_key\":\"typed\",\"intent\":\"loot_remains\",\"approach\":\"normal\",\"target\":\"corpse\",\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":\"gain_information\",\"tags_considered\":[\"corpse_present\",\"dark_area\",\"loose_stones\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"loot_remains\",\"target\":\"Goblin Scout\",\"source_type\":\"enemy\",\"reward\":{\"kind\":\"scrap\",\"amount\":1}},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'loot_remains', 'success', '2026-04-22 17:32:31'),
(27, 1, 'Use a defensive stance to mitigate initial damage.', '{\"order\":1,\"input\":\"use a defensive stance to mitigate initial damage\",\"action_key\":\"typed\",\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"corpse_present\",\"dark_area\",\"enemy_present\",\"loose_sand\",\"loose_stones\",\"low_visibility\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"observe\",\"area\":\"Floor 1 Quiet Seal Alcove\",\"target\":null,\"secondary_target\":null,\"requested_effect\":null,\"damage\":0,\"enemy_damage\":1,\"tags_used\":[\"corpse_present\",\"dark_area\",\"enemy_present\",\"loose_sand\",\"loose_stones\",\"low_visibility\"],\"roll\":8,\"total\":19,\"difficulty\":7},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'observe', 'success', '2026-04-22 17:32:41'),
(28, 1, 'take out his eye with a full on speed attack', '{\"order\":1,\"input\":\"take out his eye with a full on speed attack\",\"action_key\":\"typed\",\"intent\":\"precision_attack\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":\"enemy\",\"risk_level\":\"medium\",\"requested_effect\":null,\"tags_considered\":[\"corpse_present\",\"dark_area\",\"enemy_present\",\"loose_sand\",\"loose_stones\",\"low_visibility\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"precision_attack\",\"area\":\"Floor 1 Quiet Seal Alcove\",\"target\":null,\"secondary_target\":\"enemy\",\"requested_effect\":null,\"damage\":2,\"enemy_damage\":1,\"tags_used\":[\"corpse_present\",\"dark_area\",\"enemy_present\",\"loose_sand\",\"loose_stones\",\"low_visibility\"],\"roll\":7,\"total\":15,\"difficulty\":15},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":1}}', 'precision_attack', 'partial_success', '2026-04-22 17:33:44'),
(29, 1, 'Utilize Adaptive Insight to analyze movement patterns.', '{\"order\":1,\"input\":\"utilize adaptive insight to analyze movement patterns\",\"action_key\":\"typed\",\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"corpse_present\",\"cover_available\",\"dark_area\",\"enemy_present\",\"loose_sand\",\"loose_stones\",\"low_visibility\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"observe\",\"area\":\"Floor 1 Quiet Seal Alcove\",\"target\":null,\"secondary_target\":null,\"requested_effect\":null,\"damage\":0,\"enemy_damage\":1,\"tags_used\":[\"corpse_present\",\"cover_available\",\"dark_area\",\"enemy_present\",\"loose_sand\",\"loose_stones\",\"low_visibility\"],\"roll\":2,\"total\":13,\"difficulty\":7},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'observe', 'partial_success', '2026-04-22 17:34:34'),
(30, 1, 'use appraised and self', '{\"order\":1,\"input\":\"use appraised and self\",\"action_key\":\"typed\",\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"corpse_present\",\"loose_sand\",\"loose_stones\",\"low_visibility\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"observe\",\"area\":\"Floor 1 Quiet Seal Alcove\",\"tags_used\":[\"corpse_present\",\"loose_sand\",\"loose_stones\",\"low_visibility\"],\"requested_effect\":null},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'observe', 'success', '2026-04-22 17:36:54'),
(31, 1, 'Proceed deeper into the floor.', '{\"order\":1,\"input\":\"proceed deeper into the floor\",\"action_key\":\"typed\",\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"corpse_present\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"observe\",\"area\":\"Floor 1 Quiet Seal Alcove\",\"tags_used\":[\"corpse_present\"],\"requested_effect\":null},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'observe', 'success', '2026-04-22 17:37:28'),
(32, 1, 'i saw a group of gobiln up to 10 and i set and trap for them and start the killing', '{\"order\":1,\"input\":\"i saw a group of gobiln up to 10 and i set and trap for them and start the killing\",\"action_key\":\"typed\",\"intent\":\"observe\",\"approach\":\"normal\",\"target\":null,\"secondary_target\":null,\"risk_level\":\"low\",\"requested_effect\":null,\"tags_considered\":[\"corpse_present\",\"cover_available\"],\"confidence\":0.78,\"source\":\"backend_rules\"}', '{\"effect_applied\":{\"type\":\"observe\",\"area\":\"Floor 1 Quiet Seal Alcove\",\"tags_used\":[\"corpse_present\",\"cover_available\"],\"requested_effect\":null},\"cost\":{\"timeCostHours\":1,\"hpRiskCost\":0}}', 'observe', 'success', '2026-04-22 17:39:01');

-- --------------------------------------------------------

--
-- Table structure for table `player_world_state`
--

CREATE TABLE `player_world_state` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `skills`
--

CREATE TABLE `skills` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `skills`
--

INSERT INTO `skills` (`id`, `skill_key`, `name`, `description`, `skill_type`, `unlock_type`, `required_level`, `condition_stat_key`, `condition_threshold`, `effect_json`, `is_dynamic`, `source_pattern`, `created_at`, `updated_at`) VALUES
(1, 'level_1_survivor_instinct', 'Survivor Instinct', 'A passive survival sense awakened by reaching level 1.', 'passive', 'level', 1, NULL, NULL, '{\"awareness_bonus\": 1}', 0, 'level', '2026-04-19 16:35:03', '2026-04-19 16:35:03'),
(2, 'level_3_combat_focus', 'Combat Focus', 'An active burst of focus unlocked through early dungeon growth.', 'active', 'level', 3, NULL, NULL, '{\"attack_bonus\": 1, \"duration_turns\": 1}', 0, 'level', '2026-04-19 16:35:03', '2026-04-19 16:35:03'),
(3, 'condition_first_blood', 'First Blood', 'A passive edge gained after proving you can kill what hunts you.', 'passive', 'condition', NULL, 'enemies_killed', 1, '{\"combat_confidence\": 1}', 0, 'kill_count', '2026-04-19 16:35:03', '2026-04-19 16:35:03'),
(4, 'dynamic_adaptive_insight', 'Adaptive Insight', 'An active intelligence skill formed by repeated creative typed actions.', 'active', 'condition', NULL, 'typed_actions_count', 8, '{\"intelligence_bonus\":1,\"analysis_window_turns\":1}', 1, 'creative_typed_actions', '2026-04-19 23:35:34', '2026-04-19 23:35:34'),
(5, 'dynamic_slayer_goblin_scout', 'Goblin Scout Slayer', 'A passive combat instinct formed from repeatedly defeating Goblin Scout.', 'passive', 'condition', NULL, 'enemy_killed:goblin_scout', 3, '{\"damage_focus_against\":\"Goblin Scout\",\"focus_bonus\":1}', 1, 'repeated_enemy_kills', '2026-04-20 00:12:43', '2026-04-20 00:12:43'),
(21, 'dynamic_type_hunter_normal', 'Normal Hunter', 'A passive combat pattern formed from repeatedly defeating normal enemies.', 'passive', 'condition', NULL, 'enemy_type_killed:normal', 5, '{\"damage_focus_against_type\":\"normal\",\"focus_bonus\":1}', 1, 'repeated_enemy_type_kills', '2026-04-20 00:41:36', '2026-04-20 00:41:36'),
(24, 'intent_precision_instinct', 'Precision Instinct', 'A passive combat sense formed by repeated weak-point and eye attacks.', 'passive', 'condition', NULL, 'intent:precision_attack', 4, '{\"precision_bonus\": 1}', 0, 'repeated_precision_intent', '2026-04-20 01:24:47', '2026-04-20 01:24:47'),
(25, 'intent_environmental_tactician', 'Environmental Tactician', 'A passive tactical sense formed by repeatedly weaponizing the room itself.', 'passive', 'condition', NULL, 'intent:environment_attack', 4, '{\"environment_attack_bonus\": 1}', 0, 'repeated_environment_intent', '2026-04-20 01:24:47', '2026-04-20 01:24:47'),
(26, 'intent_predator_hunger', 'Predator Hunger', 'A passive instinct awakened by repeatedly consuming remains.', 'passive', 'condition', NULL, 'intent:devour_remains', 3, '{\"devour_hp_bonus\": 1}', 0, 'repeated_devour_intent', '2026-04-20 01:24:47', '2026-04-20 01:24:47'),
(27, 'intent_beast_parley', 'Beast Parley', 'A social survival technique formed through repeated attempts to communicate with creatures.', 'active', 'condition', NULL, 'intent:social', 4, '{\"social_opening_bonus\": 1, \"duration_turns\": 1}', 0, 'repeated_social_intent', '2026-04-20 01:24:47', '2026-04-20 01:24:47'),
(39, 'dynamic_slayer_cracked_bone_rat', 'Cracked Bone Rat Slayer', 'A passive combat instinct formed from repeatedly defeating Cracked Bone Rat.', 'passive', 'condition', NULL, 'enemy_killed:cracked_bone_rat', 3, '{\"damage_focus_against\":\"Cracked Bone Rat\",\"focus_bonus\":1}', 1, 'repeated_enemy_kills', '2026-04-22 16:26:40', '2026-04-22 16:26:40');

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

-- --------------------------------------------------------

--
-- Table structure for table `world_action_logs`
--

CREATE TABLE `world_action_logs` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `world_state_id` int(11) NOT NULL,
  `action_key` varchar(80) NOT NULL,
  `action_text` text DEFAULT NULL,
  `outcome_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`outcome_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `battle_logs`
--
ALTER TABLE `battle_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_battle_logs_player` (`player_id`),
  ADD KEY `idx_battle_logs_enemy` (`enemy_id`);

--
-- Indexes for table `bosses`
--
ALTER TABLE `bosses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_boss_key` (`boss_key`),
  ADD KEY `idx_boss_floor` (`floor_number`),
  ADD KEY `idx_boss_floor_trigger` (`floor_number`,`trigger_key`);

--
-- Indexes for table `boss_battle_logs`
--
ALTER TABLE `boss_battle_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_boss_battle_logs_player` (`player_id`),
  ADD KEY `idx_boss_battle_logs_boss` (`boss_id`);

--
-- Indexes for table `boss_skills`
--
ALTER TABLE `boss_skills`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_boss_skill` (`boss_id`,`skill_key`);

--
-- Indexes for table `enemies`
--
ALTER TABLE `enemies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `enemy_key` (`enemy_key`),
  ADD KEY `idx_enemies_floor_boss_key` (`is_boss`,`floor_min`,`floor_max`,`enemy_key`);

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
-- Indexes for table `player_ascension_results`
--
ALTER TABLE `player_ascension_results`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_ascension_final_wish` (`final_wish_id`),
  ADD KEY `idx_player_ascension_results_player` (`player_id`);

--
-- Indexes for table `player_boss_defeats`
--
ALTER TABLE `player_boss_defeats`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_player_boss_life` (`player_id`,`boss_id`,`defeated_life_number`),
  ADD KEY `fk_player_boss_defeats_boss` (`boss_id`);

--
-- Indexes for table `player_carryover_traits`
--
ALTER TABLE `player_carryover_traits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_player_carryover_trait` (`player_id`,`ascension_id`,`trait_key`),
  ADD KEY `idx_player_carryover_traits_ascension` (`ascension_id`);

--
-- Indexes for table `player_condition_stats`
--
ALTER TABLE `player_condition_stats`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_player_condition_stat` (`player_id`,`stat_key`),
  ADD KEY `idx_player_condition_stat_key` (`stat_key`);

--
-- Indexes for table `player_current_boss`
--
ALTER TABLE `player_current_boss`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_player_current_boss` (`player_id`),
  ADD KEY `fk_player_current_boss_boss` (`boss_id`),
  ADD KEY `idx_player_current_boss_state` (`player_id`,`encounter_state`);

--
-- Indexes for table `player_current_enemy`
--
ALTER TABLE `player_current_enemy`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `player_id` (`player_id`),
  ADD KEY `fk_player_current_enemy_enemy` (`enemy_id`),
  ADD KEY `idx_player_current_enemy_state` (`player_id`,`encounter_state`);

--
-- Indexes for table `player_current_scene`
--
ALTER TABLE `player_current_scene`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `player_id` (`player_id`);

--
-- Indexes for table `player_deaths`
--
ALTER TABLE `player_deaths`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_player_life_death` (`player_id`,`life_number`);

--
-- Indexes for table `player_dungeon_completions`
--
ALTER TABLE `player_dungeon_completions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_player_completion_life` (`player_id`,`completed_life_number`),
  ADD KEY `idx_player_dungeon_completions_status` (`status`);

--
-- Indexes for table `player_dungeon_run_history`
--
ALTER TABLE `player_dungeon_run_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_player_dungeon_run_history_player` (`player_id`,`life_number`);

--
-- Indexes for table `player_dungeon_state`
--
ALTER TABLE `player_dungeon_state`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_player_dungeon_floor` (`player_id`,`floor_number`),
  ADD KEY `idx_player_dungeon_floor` (`floor_number`);

--
-- Indexes for table `player_enemy_discoveries`
--
ALTER TABLE `player_enemy_discoveries`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_player_enemy_discovery` (`player_id`,`enemy_id`),
  ADD KEY `fk_player_enemy_discoveries_enemy` (`enemy_id`);

--
-- Indexes for table `player_final_wishes`
--
ALTER TABLE `player_final_wishes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_final_wish_completion` (`completion_id`),
  ADD KEY `idx_player_final_wishes_player` (`player_id`);

--
-- Indexes for table `player_rebirth_wishes`
--
ALTER TABLE `player_rebirth_wishes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_player_rebirth_wishes_player` (`player_id`);

--
-- Indexes for table `player_remains`
--
ALTER TABLE `player_remains`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_player_remains_active` (`player_id`,`consumed_at`,`expires_at`);

--
-- Indexes for table `player_scene_environment`
--
ALTER TABLE `player_scene_environment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_player_scene_environment` (`player_id`);

--
-- Indexes for table `player_scene_history`
--
ALTER TABLE `player_scene_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_player_scene_history_player` (`player_id`);

--
-- Indexes for table `player_skills`
--
ALTER TABLE `player_skills`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_player_skill` (`player_id`,`skill_id`),
  ADD KEY `fk_player_skills_skill` (`skill_id`);

--
-- Indexes for table `player_text_action_interpretations`
--
ALTER TABLE `player_text_action_interpretations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_text_action_player_created` (`player_id`,`created_at`),
  ADD KEY `idx_text_action_intent` (`resolved_intent`,`resolution_type`);

--
-- Indexes for table `player_world_state`
--
ALTER TABLE `player_world_state`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_player_world_state` (`player_id`),
  ADD KEY `idx_player_world_state_ascension` (`ascension_id`);

--
-- Indexes for table `skills`
--
ALTER TABLE `skills`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_skills_skill_key` (`skill_key`),
  ADD KEY `idx_skills_level_unlock` (`unlock_type`,`required_level`),
  ADD KEY `idx_skills_condition_unlock` (`condition_stat_key`,`condition_threshold`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `world_action_logs`
--
ALTER TABLE `world_action_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_world_action_logs_player` (`player_id`),
  ADD KEY `idx_world_action_logs_state` (`world_state_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `battle_logs`
--
ALTER TABLE `battle_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `bosses`
--
ALTER TABLE `bosses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `boss_battle_logs`
--
ALTER TABLE `boss_battle_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `boss_skills`
--
ALTER TABLE `boss_skills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `enemies`
--
ALTER TABLE `enemies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `player_action_logs`
--
ALTER TABLE `player_action_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=116;

--
-- AUTO_INCREMENT for table `player_ascension_results`
--
ALTER TABLE `player_ascension_results`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_boss_defeats`
--
ALTER TABLE `player_boss_defeats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_carryover_traits`
--
ALTER TABLE `player_carryover_traits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_condition_stats`
--
ALTER TABLE `player_condition_stats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2863;

--
-- AUTO_INCREMENT for table `player_current_boss`
--
ALTER TABLE `player_current_boss`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `player_current_enemy`
--
ALTER TABLE `player_current_enemy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `player_current_scene`
--
ALTER TABLE `player_current_scene`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `player_deaths`
--
ALTER TABLE `player_deaths`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_dungeon_completions`
--
ALTER TABLE `player_dungeon_completions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_dungeon_run_history`
--
ALTER TABLE `player_dungeon_run_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_dungeon_state`
--
ALTER TABLE `player_dungeon_state`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `player_enemy_discoveries`
--
ALTER TABLE `player_enemy_discoveries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `player_final_wishes`
--
ALTER TABLE `player_final_wishes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_rebirth_wishes`
--
ALTER TABLE `player_rebirth_wishes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_remains`
--
ALTER TABLE `player_remains`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `player_scene_environment`
--
ALTER TABLE `player_scene_environment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `player_scene_history`
--
ALTER TABLE `player_scene_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=124;

--
-- AUTO_INCREMENT for table `player_skills`
--
ALTER TABLE `player_skills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `player_text_action_interpretations`
--
ALTER TABLE `player_text_action_interpretations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `player_world_state`
--
ALTER TABLE `player_world_state`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `skills`
--
ALTER TABLE `skills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `world_action_logs`
--
ALTER TABLE `world_action_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `battle_logs`
--
ALTER TABLE `battle_logs`
  ADD CONSTRAINT `fk_battle_logs_enemy` FOREIGN KEY (`enemy_id`) REFERENCES `enemies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_battle_logs_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `boss_battle_logs`
--
ALTER TABLE `boss_battle_logs`
  ADD CONSTRAINT `fk_boss_battle_logs_boss` FOREIGN KEY (`boss_id`) REFERENCES `bosses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_boss_battle_logs_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `boss_skills`
--
ALTER TABLE `boss_skills`
  ADD CONSTRAINT `fk_boss_skills_boss` FOREIGN KEY (`boss_id`) REFERENCES `bosses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
-- Constraints for table `player_ascension_results`
--
ALTER TABLE `player_ascension_results`
  ADD CONSTRAINT `fk_player_ascension_results_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_player_ascension_results_wish` FOREIGN KEY (`final_wish_id`) REFERENCES `player_final_wishes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_boss_defeats`
--
ALTER TABLE `player_boss_defeats`
  ADD CONSTRAINT `fk_player_boss_defeats_boss` FOREIGN KEY (`boss_id`) REFERENCES `bosses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_player_boss_defeats_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_carryover_traits`
--
ALTER TABLE `player_carryover_traits`
  ADD CONSTRAINT `fk_player_carryover_traits_ascension` FOREIGN KEY (`ascension_id`) REFERENCES `player_ascension_results` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_player_carryover_traits_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_condition_stats`
--
ALTER TABLE `player_condition_stats`
  ADD CONSTRAINT `fk_player_condition_stats_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_current_boss`
--
ALTER TABLE `player_current_boss`
  ADD CONSTRAINT `fk_player_current_boss_boss` FOREIGN KEY (`boss_id`) REFERENCES `bosses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_player_current_boss_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
-- Constraints for table `player_deaths`
--
ALTER TABLE `player_deaths`
  ADD CONSTRAINT `fk_player_deaths_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_dungeon_completions`
--
ALTER TABLE `player_dungeon_completions`
  ADD CONSTRAINT `fk_player_dungeon_completions_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_dungeon_run_history`
--
ALTER TABLE `player_dungeon_run_history`
  ADD CONSTRAINT `fk_player_dungeon_run_history_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_dungeon_state`
--
ALTER TABLE `player_dungeon_state`
  ADD CONSTRAINT `fk_player_dungeon_state_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_enemy_discoveries`
--
ALTER TABLE `player_enemy_discoveries`
  ADD CONSTRAINT `fk_player_enemy_discoveries_enemy` FOREIGN KEY (`enemy_id`) REFERENCES `enemies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_player_enemy_discoveries_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_final_wishes`
--
ALTER TABLE `player_final_wishes`
  ADD CONSTRAINT `fk_player_final_wishes_completion` FOREIGN KEY (`completion_id`) REFERENCES `player_dungeon_completions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_player_final_wishes_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_rebirth_wishes`
--
ALTER TABLE `player_rebirth_wishes`
  ADD CONSTRAINT `fk_player_rebirth_wishes_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_remains`
--
ALTER TABLE `player_remains`
  ADD CONSTRAINT `fk_player_remains_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_scene_environment`
--
ALTER TABLE `player_scene_environment`
  ADD CONSTRAINT `fk_player_scene_environment_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_scene_history`
--
ALTER TABLE `player_scene_history`
  ADD CONSTRAINT `fk_player_scene_history_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_skills`
--
ALTER TABLE `player_skills`
  ADD CONSTRAINT `fk_player_skills_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_player_skills_skill` FOREIGN KEY (`skill_id`) REFERENCES `skills` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_text_action_interpretations`
--
ALTER TABLE `player_text_action_interpretations`
  ADD CONSTRAINT `fk_text_action_interpretations_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_world_state`
--
ALTER TABLE `player_world_state`
  ADD CONSTRAINT `fk_player_world_state_ascension` FOREIGN KEY (`ascension_id`) REFERENCES `player_ascension_results` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_player_world_state_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `world_action_logs`
--
ALTER TABLE `world_action_logs`
  ADD CONSTRAINT `fk_world_action_logs_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_world_action_logs_state` FOREIGN KEY (`world_state_id`) REFERENCES `player_world_state` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
