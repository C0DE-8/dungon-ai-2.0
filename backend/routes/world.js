const router = require("express").Router();
const pool = require("../config/db");
const authenticateToken = require("../middleware/authMiddleware");
const { generateNarration } = require("../services/aiEngine");
const { getLatestAscension } = require("../services/finalWishEngine");
const {
  getWorldState,
  initializeWorldMode,
  resolveWorldAction
} = require("../services/worldEngine");

async function getPlayerForUser(connOrPool, userId) {
  const [[player]] = await connOrPool.query(
    `SELECT *
     FROM players
     WHERE user_id = ?
     LIMIT 1`,
    [userId]
  );

  return player || null;
}

// api/world/current
router.get("/current", authenticateToken, async (req, res) => {
  const userId = req.user.userId;

  try {
    const player = await getPlayerForUser(pool, userId);

    if (!player) {
      return res.status(404).json({ message: "Player not found" });
    }

    const worldState = await getWorldState(pool, player.id);

    if (!worldState) {
      return res.status(404).json({ message: "World Mode has not started" });
    }

    return res.json({
      mode: "world",
      player: {
        name: player.name,
        race: player.current_race,
        title: player.current_title,
        level: player.level
      },
      world_state: worldState
    });
  } catch (error) {
    console.error("world current error:", error);
    return res.status(500).json({ message: "Failed to fetch world state" });
  }
});

// api/world/start
router.post("/start", authenticateToken, async (req, res) => {
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

    const existing = await getWorldState(conn, player.id);

    if (existing) {
      await conn.commit();
      return res.json({
        message: "World Mode already started",
        world_state: existing
      });
    }

    const ascension = await getLatestAscension(conn, player.id);

    if (!ascension) {
      await conn.rollback();
      return res.status(400).json({ message: "Final ascension is required before World Mode" });
    }

    const worldState = await initializeWorldMode(conn, player.id, ascension.id, {
      form_key: ascension.form_key,
      identity_label: ascension.identity_label,
      carryover_power: ascension.carryover_power
    });

    await conn.commit();

    return res.json({
      message: "World Mode started",
      world_state: worldState
    });
  } catch (error) {
    if (conn) await conn.rollback();
    console.error("world start error:", error);
    return res.status(500).json({ message: "Failed to start World Mode" });
  } finally {
    if (conn) conn.release();
  }
});

// api/world/action
router.post("/action", authenticateToken, async (req, res) => {
  const userId = req.user.userId;
  const actionInput = req.body?.action || req.body?.text || "";
  let conn;

  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const player = await getPlayerForUser(conn, userId);

    if (!player) {
      await conn.rollback();
      return res.status(404).json({ message: "Player not found" });
    }

    const resolved = await resolveWorldAction(conn, {
      playerId: player.id,
      actionInput
    });

    if (!resolved) {
      await conn.rollback();
      return res.status(400).json({ message: "World Mode action could not be resolved" });
    }

    const aiResult = await generateNarration({
      persona: player.persona,
      context: {
        event: "world_action",
        action: actionInput,
        outcome: resolved.outcome,
        world_state: resolved.world_state,
        player: {
          race: player.current_race,
          title: player.current_title
        },
        rule: "Narrate only. Do not alter mechanics."
      }
    });

    await conn.commit();

    return res.json({
      message: "World action resolved",
      action: {
        input: actionInput,
        normalized: resolved.action_key
      },
      outcome: resolved.outcome,
      world_state: resolved.world_state,
      narration: aiResult.narration,
      choices: aiResult.choices
    });
  } catch (error) {
    if (conn) await conn.rollback();
    console.error("world action error:", error);
    return res.status(500).json({ message: "Failed to resolve world action" });
  } finally {
    if (conn) conn.release();
  }
});

module.exports = router;
