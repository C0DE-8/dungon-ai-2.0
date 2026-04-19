const router = require("express").Router();
const pool = require("../config/db");
const authenticateToken = require("../middleware/authMiddleware");
const {
  getDeathStatus,
  restartSameForm
} = require("../services/deathEngine");

async function getPlayerForUser(connOrPool, userId) {
  const [[player]] = await connOrPool.query(
    `SELECT
      id,
      user_id,
      name,
      current_race,
      current_title,
      level,
      exp,
      stat_points,
      hp,
      max_hp,
      strength_stat,
      dexterity_stat,
      stamina_stat,
      intelligence_stat,
      charisma_stat,
      wisdom_stat,
      current_floor,
      current_area,
      life_number,
      is_alive,
      year_survived,
      day_survived,
      current_hour
     FROM players
     WHERE user_id = ?
     LIMIT 1`,
    [userId]
  );

  return player || null;
}

// api/rebirth/status
router.get("/status", authenticateToken, async (req, res) => {
  const userId = req.user.userId;

  try {
    const player = await getPlayerForUser(pool, userId);

    if (!player) {
      return res.status(404).json({ message: "Player not found" });
    }

    const status = await getDeathStatus(pool, player.id);

    return res.json({
      is_alive: !!player.is_alive,
      life_number: player.life_number,
      hp: player.hp,
      max_hp: player.max_hp,
      latest_death: status.latest_death
    });
  } catch (error) {
    console.error("rebirth status error:", error);
    return res.status(500).json({ message: "Failed to fetch rebirth status" });
  }
});

// api/rebirth/restart
router.post("/restart", authenticateToken, async (req, res) => {
  const userId = req.user.userId;
  let conn;

  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const player = await getPlayerForUser(conn, userId);

    if (!player) {
      await conn.rollback();
      return res.status(404).json({ message: "Player not found" });
    }

    if (player.is_alive) {
      await conn.rollback();
      return res.status(400).json({ message: "Player is still alive" });
    }

    const restart = await restartSameForm(conn, player);
    const restartedPlayer = await getPlayerForUser(conn, userId);

    await conn.commit();

    return res.json({
      message: "Restarted in the same form",
      rebirth: {
        mode: "same_form",
        life_number: restart.life_number,
        wish_effect: null
      },
      player: {
        name: restartedPlayer.name,
        race: restartedPlayer.current_race,
        title: restartedPlayer.current_title,
        level: restartedPlayer.level,
        exp: restartedPlayer.exp,
        hp: restartedPlayer.hp,
        max_hp: restartedPlayer.max_hp,
        current_floor: restartedPlayer.current_floor,
        current_area: restartedPlayer.current_area,
        is_alive: restartedPlayer.is_alive
      }
    });
  } catch (error) {
    if (conn) await conn.rollback();
    console.error("rebirth restart error:", error);
    return res.status(500).json({ message: "Failed to restart life" });
  } finally {
    if (conn) conn.release();
  }
});

// api/rebirth/wish
router.post("/wish", authenticateToken, async (req, res) => {
  const userId = req.user.userId;
  const wish = String(req.body?.wish || "").trim();

  if (!wish) {
    return res.status(400).json({ message: "wish is required" });
  }

  if (wish.length > 240) {
    return res.status(400).json({ message: "wish must be 240 characters or less" });
  }

  let conn;

  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const player = await getPlayerForUser(conn, userId);

    if (!player) {
      await conn.rollback();
      return res.status(404).json({ message: "Player not found" });
    }

    if (player.is_alive) {
      await conn.rollback();
      return res.status(400).json({ message: "Rebirth wishes are only available after death" });
    }

    const restart = await restartSameForm(conn, player, wish);
    const restartedPlayer = await getPlayerForUser(conn, userId);

    await conn.commit();

    return res.json({
      message: "Limited rebirth wish processed",
      rebirth: {
        mode: "same_form_with_limited_wish",
        life_number: restart.life_number,
        wish,
        wish_effect: restart.wish_effect
      },
      player: {
        name: restartedPlayer.name,
        race: restartedPlayer.current_race,
        title: restartedPlayer.current_title,
        level: restartedPlayer.level,
        exp: restartedPlayer.exp,
        hp: restartedPlayer.hp,
        max_hp: restartedPlayer.max_hp,
        current_floor: restartedPlayer.current_floor,
        current_area: restartedPlayer.current_area,
        is_alive: restartedPlayer.is_alive
      }
    });
  } catch (error) {
    if (conn) await conn.rollback();
    console.error("rebirth wish error:", error);
    return res.status(500).json({ message: "Failed to process rebirth wish" });
  } finally {
    if (conn) conn.release();
  }
});

module.exports = router;
