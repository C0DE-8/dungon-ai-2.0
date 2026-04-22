const { model, genAI } = require("../config/gemini");
const { buildPrompt } = require("../config/prompts");

const FALLBACK_MODEL_NAME = "gemini-2.5-flash";
const DEFAULT_NARRATION =
  "You feel the dungeon breathing around you, but nothing answers yet.";
const DEFAULT_CHOICES = ["look around", "move carefully", "rest", "hide"];
const ACTION_PLAN_INTENTS = new Set([
  "direct_attack",
  "precision_attack",
  "heavy_attack",
  "defend",
  "hide",
  "observe",
  "environment_attack",
  "environment_control",
  "loot_remains",
  "inspect_remains",
  "devour_remains",
  "rest",
  "escape",
  "map_area",
  "scout_area",
  "plan_next_move",
  "move_toward_objective",
  "force_object",
  "social"
]);

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

function buildFallbackNarration(context = null) {
  const feedback = context?.event_feedback;
  if (!feedback) return DEFAULT_NARRATION;

  const location = feedback.location?.after || context?.environment?.area || "the dungeon";
  const intent = feedback.action?.resolved_intent || context?.action || "action";
  const outcome = feedback.action?.resolution_type || "resolved";
  const hpDelta = Number(feedback.consequences?.hp_delta || 0);
  const safety = feedback.consequences?.safety_state;
  const reaction = feedback.consequences?.world_reaction;
  const danger = feedback.consequences?.danger_level;
  const combat = feedback.combat;

  if (combat) {
    const enemyText = combat.enemy_name ? ` Enemy: ${combat.enemy_name}.` : "";
    const reactionText = combat.enemy_reaction ? ` ${combat.enemy_reaction}` : "";
    const enemyHpText = combat.enemy_hp_after !== null && combat.enemy_hp_after !== undefined
      ? ` Enemy HP after: ${combat.enemy_hp_after}.`
      : "";
    const playerHpText = combat.player_hp_after !== null && combat.player_hp_after !== undefined
      ? ` Player HP after: ${combat.player_hp_after}.`
      : "";

    return `${combat.player_attempt || titleCase(intent)} ${combat.hit_result || `Result: ${outcome}.`}${reactionText}${enemyText}${enemyHpText}${playerHpText}`;
  }

  const movement = feedback.consequences?.moved
    ? ` The player moves to ${location}.`
    : ` The player remains in ${location}.`;
  const hpText = hpDelta === 0
    ? " Condition is unchanged."
    : hpDelta > 0
      ? ` HP rises by ${hpDelta}.`
      : ` HP falls by ${Math.abs(hpDelta)}.`;
  const safetyText = safety ? ` Safety state: ${safety}.` : "";
  const reactionText = reaction ? ` World reaction: ${reaction}.` : "";
  const dangerText = danger ? ` Danger level: ${danger}.` : "";

  return `${titleCase(intent)} resolves as ${outcome} in ${location}.${movement}${hpText}${safetyText}${reactionText}${dangerText}`;
}

function titleCase(value = "") {
  return String(value)
    .replace(/[_-]+/g, " ")
    .trim()
    .split(/\s+/)
    .filter(Boolean)
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(" ");
}

function buildFallbackResponse(context = null, narration = null) {
  return {
    narration: narration || buildFallbackNarration(context),
    choices: DEFAULT_CHOICES,
    source: "fallback"
  };
}

function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}

function sanitizeActionPlanStep(step, index) {
  if (!step || typeof step !== "object") return null;

  const intent = String(step.intent || "").trim();
  if (!ACTION_PLAN_INTENTS.has(intent)) return null;

  const durationHours = Number(step.duration_hours || 0);

  return {
    order: index + 1,
    input: String(step.input || step.summary || intent).slice(0, 240),
    intent,
    approach: ["careful", "quick", "heavy_force", "reckless", "normal"].includes(step.approach) ? step.approach : "normal",
    target: step.target ? String(step.target).slice(0, 80) : null,
    secondary_target: step.secondary_target ? String(step.secondary_target).slice(0, 80) : null,
    risk_level: ["low", "medium", "high"].includes(step.risk_level) ? step.risk_level : "low",
    requested_effect: step.requested_effect ? String(step.requested_effect).slice(0, 120) : null,
    objective: step.objective ? String(step.objective).slice(0, 120) : null,
    duration_hours: durationHours > 0 ? clamp(Math.round(durationHours), 1, 72) : null,
    desired_full_recovery: !!step.desired_full_recovery,
    rest_intensity: ["short", "normal", "full"].includes(step.rest_intensity) ? step.rest_intensity : null,
    action_key: step.action_key ? String(step.action_key).slice(0, 40) : "typed",
    confidence: clamp(Number(step.confidence || 0.75), 0, 1),
    source: "ai_planner"
  };
}

function sanitizeActionPlan(parsed) {
  if (!parsed || typeof parsed !== "object" || !Array.isArray(parsed.steps)) return null;

  const steps = parsed.steps
    .map((step, index) => sanitizeActionPlanStep(step, index))
    .filter(Boolean)
    .slice(0, 6);

  if (!steps.length) return null;

  return {
    intent: steps.length > 1 ? "sequence" : steps[0].intent,
    is_sequence: steps.length > 1,
    step_count: steps.length,
    steps,
    ai_summary: String(parsed.summary || "").slice(0, 500),
    world_assumptions: Array.isArray(parsed.world_assumptions)
      ? parsed.world_assumptions.map((item) => String(item).slice(0, 160)).slice(0, 5)
      : [],
    guardrail_notes: Array.isArray(parsed.guardrail_notes)
      ? parsed.guardrail_notes.map((item) => String(item).slice(0, 160)).slice(0, 5)
      : [],
    source: "ai_planner"
  };
}

function buildActionPlanPrompt({ actionText, context }) {
  return `
You are the Deep Saga action interpreter.

Your job is to convert the player's free-text action into a valid gameplay action plan.
You do NOT decide final HP, EXP, level, actual enemy death, floor changes, or impossible new world facts.
The backend will enforce stats, damage, enemy existence, time, movement, and progression.

Interpret the full sentence naturally. Preserve sequencing, tactics, ambushes, traps, deception, movement, scouting, preparation, escape, and chained combat.
Use only these intents:
${[...ACTION_PLAN_INTENTS].join(", ")}

Rules:
- Return ONLY valid JSON.
- Do not wrap in markdown.
- Break complex text into ordered steps.
- If the player invents enemies not present in context, treat that as suspicion/scouting/plan unless context supports an active enemy.
- If the player wants a trap or ambush, use environment_control before attack.
- If the player wants to attack with the room/trap, use environment_attack when an active enemy/boss exists, otherwise scout_area or environment_control.
- If the player wants full recovery/capacity, use rest with desired_full_recovery true and rest_intensity "full".
- If the player wants a short nap, use rest with rest_intensity "short".
- Keep targets grounded in scene tags and active enemies.

JSON shape:
{
  "summary": "one sentence summary of interpreted player intent",
  "world_assumptions": ["short grounded assumptions"],
  "guardrail_notes": ["short notes about limits backend must enforce"],
  "steps": [
    {
      "input": "the specific sub-action in player's words",
      "intent": "one allowed intent",
      "approach": "normal|careful|quick|heavy_force|reckless",
      "target": "short target or null",
      "secondary_target": "enemy|boss|null",
      "risk_level": "low|medium|high",
      "requested_effect": "short effect",
      "objective": "short objective or null",
      "duration_hours": null,
      "desired_full_recovery": false,
      "rest_intensity": "short|normal|full|null",
      "action_key": "typed",
      "confidence": 0.0
    }
  ]
}

GAME CONTEXT:
${JSON.stringify(context, null, 2)}

PLAYER ACTION:
${JSON.stringify(actionText)}
`;
}

async function generateActionPlan({ actionText, context }) {
  const prompt = buildActionPlanPrompt({ actionText, context });

  try {
    const text = await generateWithRetry(model, prompt, 1);
    const parsed = extractJson(text);
    return sanitizeActionPlan(parsed);
  } catch (error) {
    console.error("generateActionPlan error:", error);
    return null;
  }
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
      return buildFallbackResponse(context);
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
    return buildFallbackResponse(context);
  }
}

module.exports = { generateActionPlan, generateNarration };
