const router = require("express").Router();
const pool = require("../config/db");
const authenticateToken = require("../middleware/authMiddleware");
const { generateNarration } = require("../services/aiEngine");
const {
  getLatestAscension,
  getPendingAscension,
  resolveFinalWish
} = require("../services/finalWishEngine");
const { initializeWorldMode } = require("../services/worldEngine");

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

// api/ascension/status
router.get("/status", authenticateToken, async (req, res) => {
  const userId = req.user.userId;

  try {
    const player = await getPlayerForUser(pool, userId);

    if (!player) {
      return res.status(404).json({ message: "Player not found" });
    }

    const pending = await getPendingAscension(pool, player.id);
    const latest = await getLatestAscension(pool, player.id);

    return res.json({
      awaiting_final_wish: !!pending,
      prompt: pending ? "State your wish." : null,
      pending_completion: pending,
      latest_ascension: latest
    });
  } catch (error) {
    console.error("ascension status error:", error);
    return res.status(500).json({ message: "Failed to fetch ascension status" });
  }
});

// api/ascension/wish
router.post("/wish", authenticateToken, async (req, res) => {
  const userId = req.user.userId;
  const wish = String(req.body?.wish || "").trim();

  if (!wish) {
    return res.status(400).json({ message: "wish is required" });
  }

  if (wish.length > 1000) {
    return res.status(400).json({ message: "wish must be 1000 characters or less" });
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

    const resolved = await resolveFinalWish(conn, player, wish);

    if (!resolved) {
      await conn.rollback();
      return res.status(400).json({ message: "No completed dungeon run is awaiting a final wish" });
    }

    const worldState = await initializeWorldMode(
      conn,
      player.id,
      resolved.ascension_id,
      resolved.interpretation
    );

    const aiResult = await generateNarration({
      persona: player.persona,
      context: {
        event: "final_wish_resolved",
        backend_result: resolved.interpretation,
        world_state: worldState,
        rule: "Narrate only. Do not alter mechanics."
      }
    });

    await conn.commit();

    return res.json({
      message: "Final wish resolved. World Mode initialized.",
      prompt_answered: "State your wish.",
      wish,
      ascension: {
        id: resolved.ascension_id,
        interpretation: resolved.interpretation
      },
      world_state: worldState,
      narration: aiResult.narration,
      choices: aiResult.choices
    });
  } catch (error) {
    if (conn) await conn.rollback();
    console.error("ascension wish error:", error);
    return res.status(500).json({ message: "Failed to resolve final wish" });
  } finally {
    if (conn) conn.release();
  }
});

module.exports = router;
