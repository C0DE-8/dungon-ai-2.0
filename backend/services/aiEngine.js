const { model, genAI } = require("../config/gemini");
const { buildPrompt } = require("../config/prompts");

const FALLBACK_MODEL_NAME = "gemini-2.5-flash";
const DEFAULT_NARRATION =
  "You feel the dungeon breathing around you, but nothing answers yet.";
const DEFAULT_CHOICES = ["look around", "move carefully", "rest", "hide"];

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
  if (!trimmed) return null;

  try {
    return JSON.parse(trimmed);
  } catch (err) {
    const objectMatch = trimmed.match(/\{[\s\S]*\}/);
    if (objectMatch) {
      try {
        return JSON.parse(objectMatch[0]);
      } catch (innerErr) {}
    }

    const fencedMatch = trimmed.match(/```json\s*([\s\S]*?)```/i) || trimmed.match(/```\s*([\s\S]*?)```/i);
    if (fencedMatch) {
      try {
        return JSON.parse(fencedMatch[1].trim());
      } catch (innerErr) {}
    }

    return null;
  }
}

function buildFallbackResponse(narration = DEFAULT_NARRATION) {
  return {
    narration,
    choices: DEFAULT_CHOICES,
    source: "fallback"
  };
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function isRetryableGeminiError(error) {
  const status = error?.status || error?.statusCode;
  return status === 429 || status === 500 || status === 503;
}

async function callModel(activeModel, prompt) {
  const result = await activeModel.generateContent(prompt);
  const response = await result.response;
  const text = response.text();
  return String(text || "").trim();
}

async function generateWithRetry(activeModel, prompt, maxRetries = 3) {
  let lastError;

  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      return await callModel(activeModel, prompt);
    } catch (error) {
      lastError = error;

      if (!isRetryableGeminiError(error) || attempt === maxRetries) {
        throw error;
      }

      const delay = Math.min(1000 * 2 ** attempt, 8000) + Math.floor(Math.random() * 300);
      await sleep(delay);
    }
  }

  throw lastError;
}

async function generateNarration({ context, persona = "ADMIN" }) {
  const prompt = buildPrompt({ persona, context });

  try {
    let text = "";

    try {
      text = await generateWithRetry(model, prompt, 3);
    } catch (primaryError) {
      console.error("Primary Gemini model failed:", primaryError);

      if (!genAI) {
        throw primaryError;
      }

      const fallbackModel = genAI.getGenerativeModel({
        model: FALLBACK_MODEL_NAME
      });

      text = await generateWithRetry(fallbackModel, prompt, 2);
    }

    if (!text) {
      return buildFallbackResponse();
    }

    const parsed = extractJson(text);

    if (!parsed) {
      return {
        narration: text,
        choices: DEFAULT_CHOICES,
        source: "plain_text"
      };
    }

    const narration =
      String(parsed.narration || "").trim() || DEFAULT_NARRATION;

    const choices = sanitizeChoices(parsed.choices);

    return {
      narration,
      choices: choices.length ? choices : DEFAULT_CHOICES,
      source: "json"
    };
  } catch (error) {
    console.error("generateNarration error:", error);
    return buildFallbackResponse();
  }
}

module.exports = { generateNarration };