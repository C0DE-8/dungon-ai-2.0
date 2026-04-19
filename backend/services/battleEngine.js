function clampMin(value, min = 0) {
  return value < min ? min : value;
}

function calculatePlayerDamage(player, enemy, actionKey) {
  const baseAttack = Number(player.strength_stat || 0);
  const enemyDefense = Number(enemy.defense_stat || 0);

  let raw = baseAttack - Math.floor(enemyDefense / 2);

  if (actionKey === "attack") {
    raw += 2;
  }

  return clampMin(raw, 1);
}

function calculateEnemyDamage(enemy, player, playerAction) {
  const enemyAttack = Number(enemy.attack_stat || 0);
  const playerDefense = Number(player.stamina_stat || 0);

  let raw = enemyAttack - Math.floor(playerDefense / 2);

  if (playerAction === "defend") {
    raw = Math.floor(raw / 2);
  }

  return clampMin(raw, 0);
}

function getEnemyAction(enemy, player) {
  if ((enemy.enemy_current_hp || enemy.hp) <= Math.floor((enemy.max_hp || enemy.hp) * 0.3)) {
    return "attack";
  }

  if ((player.hp || 0) <= Math.floor((player.max_hp || 0) * 0.35)) {
    return "attack";
  }

  return "attack";
}

function resolveBattleTurn({ player, enemy, playerAction }) {
  const enemyAction = getEnemyAction(enemy, player);

  let playerDamageDealt = 0;
  let enemyDamageDealt = 0;

  let enemyHpAfter = Number(enemy.enemy_current_hp || enemy.hp || 0);
  let playerHpAfter = Number(player.hp || 0);

  if (playerAction === "attack") {
    playerDamageDealt = calculatePlayerDamage(player, enemy, playerAction);
    enemyHpAfter = Math.max(0, enemyHpAfter - playerDamageDealt);
  }

  if (enemyHpAfter > 0) {
    enemyDamageDealt = calculateEnemyDamage(enemy, player, playerAction);
    playerHpAfter = Math.max(0, playerHpAfter - enemyDamageDealt);
  }

  let resultTag = "ongoing";

  if (enemyHpAfter <= 0) resultTag = "enemy_defeated";
  if (playerHpAfter <= 0) resultTag = "player_defeated";
  if (enemyHpAfter <= 0 && playerHpAfter <= 0) resultTag = "double_ko";

  return {
    playerAction,
    enemyAction,
    playerDamageDealt,
    enemyDamageDealt,
    playerHpAfter,
    enemyHpAfter,
    resultTag
  };
}

module.exports = {
  resolveBattleTurn
};