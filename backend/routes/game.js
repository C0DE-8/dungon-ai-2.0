const router = require("express").Router();
const pool = require("../config/db");
const authenticateToken = require("../middleware/authMiddleware");
const { generateNarration } = require("../services/aiEngine");

// api/game/start
router.post("/start", authenticateToken, async (req, res) => {
  const userId = req.user.userId;
  let conn;

  try {
    conn = await pool.getConnection();
    await conn.beginTransaction();

    const [[player]] = await conn.query(
      `SELECT
        id,
        user_id,
        persona,
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

    if (!player) {
      await conn.rollback();
      return res.status(404).json({ message: "Player not found" });
    }

    const choices = [
      "look around",
      "move forward",
      "stay still",
      "call out"
    ];

    const context = {
      event: "game_start",
      player: {
        name: player.name,
        race: player.current_race,
        title: player.current_title,
        level: player.level,
        hp: player.hp,
        max_hp: player.max_hp,
        stats: {
          strength: player.strength_stat,
          dexterity: player.dexterity_stat,
          stamina: player.stamina_stat,
          intelligence: player.intelligence_stat,
          charisma: player.charisma_stat,
          wisdom: player.wisdom_stat
        }
      },
      world: {
        year: player.year_survived,
        day: player.day_survived,
        hour: player.current_hour,
        floor: player.current_floor,
        area: player.current_area
      },
      scene_goal: "Introduce the player's first awakening in the dungeon and end with tension."
    };

    const narration = await generateNarration({
      context,
      persona: player.persona
    });

    const sceneTitle = "Awakening in Darkness";

    await conn.query(
      `INSERT INTO player_current_scene (
        player_id,
        scene_title,
        scene_text,
        scene_type,
        choices_json,
        can_type
      ) VALUES (?, ?, ?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE
        scene_title = VALUES(scene_title),
        scene_text = VALUES(scene_text),
        scene_type = VALUES(scene_type),
        choices_json = VALUES(choices_json),
        can_type = VALUES(can_type)`,
      [
        player.id,
        sceneTitle,
        narration,
        "intro",
        JSON.stringify(choices),
        1
      ]
    );

    await conn.query(
      `INSERT INTO player_scene_history (
        player_id,
        scene_title,
        scene_text,
        scene_type
      ) VALUES (?, ?, ?, ?)`,
      [player.id, sceneTitle, narration, "intro"]
    );

    await conn.commit();

    return res.json({
      message: "Game started successfully",
      scene: {
        title: sceneTitle,
        text: narration,
        type: "intro",
        choices,
        can_type: true
      },
      world: {
        year: player.year_survived,
        day: player.day_survived,
        hour: player.current_hour,
        floor: player.current_floor,
        area: player.current_area
      }
    });
  } catch (error) {
    if (conn) await conn.rollback();
    console.error("game start error:", error);
    return res.status(500).json({ message: "Failed to start game" });
  } finally {
    if (conn) conn.release();
  }
});

// api/game/current
router.get("/current", authenticateToken, async (req, res) => {
  const userId = req.user.userId;

  try {
    const [[player]] = await pool.query(
      `SELECT id, current_floor, current_area, year_survived, day_survived, current_hour
       FROM players
       WHERE user_id = ?
       LIMIT 1`,
      [userId]
    );

    if (!player) {
      return res.status(404).json({ message: "Player not found" });
    }

    const [[scene]] = await pool.query(
      `SELECT
        scene_title,
        scene_text,
        scene_type,
        choices_json,
        can_type
       FROM player_current_scene
       WHERE player_id = ?
       LIMIT 1`,
      [player.id]
    );

    if (!scene) {
      return res.status(404).json({ message: "No active scene found. Start the game first." });
    }

    let parsedChoices = [];

    try {
      parsedChoices = scene.choices_json ? JSON.parse(scene.choices_json) : [];
    } catch (err) {
      parsedChoices = [];
    }

    let timeOfDay = "night";
    if (player.current_hour >= 5 && player.current_hour <= 11) timeOfDay = "morning";
    else if (player.current_hour >= 12 && player.current_hour <= 16) timeOfDay = "afternoon";
    else if (player.current_hour >= 17 && player.current_hour <= 20) timeOfDay = "evening";

    return res.json({
      scene: {
        title: scene.scene_title,
        text: scene.scene_text,
        type: scene.scene_type,
        choices: parsedChoices,
        can_type: !!scene.can_type
      },
      world: {
        year: player.year_survived,
        day: player.day_survived,
        hour: player.current_hour,
        time_of_day: timeOfDay,
        floor: player.current_floor,
        area: player.current_area
      }
    });
  } catch (error) {
    console.error("get current scene error:", error);
    return res.status(500).json({ message: "Failed to fetch current scene" });
  }
});

module.exports = router;