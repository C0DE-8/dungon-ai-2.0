const { model } = require("../config/gemini");
const { buildPrompt } = require("../config/prompts");

function sanitizeChoices(choices) {
  if (!Array.isArray(choices)) return [];

  const cleaned = choices
    .map((choice) => String(choice || "").trim())
    .filter(Boolean)
    .filter((choice) => choice.length <= 80);

  return [...new Set(cleaned)].slice(0, 5);
}

function extractJson(text = "") {
  const trimmed = String(text || "").trim();

  try {
    return JSON.parse(trimmed);
  } catch (err) {
    const match = trimmed.match(/\{[\s\S]*\}/);
    if (match) {
      try {
        return JSON.parse(match[0]);
      } catch (innerErr) {
        return null;
      }
    }
    return null;
  }
}

async function generateNarration({ context, persona = "ADMIN" }) {
  try {
    const prompt = buildPrompt({ persona, context });

    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();

    if (!text || !text.trim()) {
      return {
        narration: "You feel the dungeon breathing around you, but nothing answers yet.",
        choices: ["look around", "move carefully", "rest", "hide"]
      };
    }

    const parsed = extractJson(text);

    if (!parsed) {
      return {
        narration: text.trim(),
        choices: ["look around", "move carefully", "rest", "hide"]
      };
    }

    const narration = String(parsed.narration || "").trim() ||
      "You feel the dungeon breathing around you, but nothing answers yet.";

    const choices = sanitizeChoices(parsed.choices);

    return {
      narration,
      choices: choices.length
        ? choices
        : ["look around", "move carefully", "rest", "hide"]
    };
  } catch (error) {
    console.error("generateNarration error:", error);
    return {
      narration: "You feel the dungeon breathing around you, but nothing answers yet.",
      choices: ["look around", "move carefully", "rest", "hide"]
    };
  }
}

module.exports = { generateNarration };