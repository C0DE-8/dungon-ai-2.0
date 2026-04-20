ALTER TABLE `enemies`
  ADD KEY `idx_enemies_floor_boss_key` (`is_boss`, `floor_min`, `floor_max`, `enemy_key`);

ALTER TABLE `player_current_enemy`
  ADD KEY `idx_player_current_enemy_state` (`player_id`, `encounter_state`);

ALTER TABLE `bosses`
  ADD KEY `idx_boss_floor_trigger` (`floor_number`, `trigger_key`);

ALTER TABLE `player_current_boss`
  ADD KEY `idx_player_current_boss_state` (`player_id`, `encounter_state`);
