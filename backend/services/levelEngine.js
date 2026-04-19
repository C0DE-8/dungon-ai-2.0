function getRequiredExpForNextLevel(level) {
  const currentLevel = Number(level) || 0;
  return 20 + (currentLevel * 10);
}

function applyExpGain(player, expGained) {
  let currentExp = Number(player.exp) || 0;
  let currentLevel = Number(player.level) || 0;
  let currentStatPoints = Number(player.stat_points) || 0;

  currentExp += Number(expGained) || 0;

  let levelsGained = 0;
  let totalStatPointsGained = 0;

  while (currentExp >= getRequiredExpForNextLevel(currentLevel)) {
    currentExp -= getRequiredExpForNextLevel(currentLevel);
    currentLevel += 1;
    levelsGained += 1;
    currentStatPoints += 3;
    totalStatPointsGained += 3;
  }

  return {
    level: currentLevel,
    exp: currentExp,
    stat_points: currentStatPoints,
    levels_gained: levelsGained,
    stat_points_gained: totalStatPointsGained
  };
}

module.exports = {
  getRequiredExpForNextLevel,
  applyExpGain
};