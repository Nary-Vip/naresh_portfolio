const MODEL = "gemini-2.5-flash-lite";
const GEMINI_BASE = "https://generativelanguage.googleapis.com/v1beta/models";

export default {
  async fetch(request, env) {
    const origin = request.headers.get("Origin") || "";
    const allowed = isAllowedOrigin(origin, env);

    if (request.method === "OPTIONS") {
      return new Response(null, {
        status: allowed ? 204 : 403,
        headers: corsHeaders(origin, allowed),
      });
    }

    if (request.method !== "POST") {
      return json({ error: "Method not allowed" }, 405, origin, allowed);
    }

    if (!allowed) {
      return json({ error: "Forbidden origin" }, 403, origin, allowed);
    }

    // Route.
    const pathname = new URL(request.url).pathname;
    let stream;
    if (pathname === "/stream") stream = true;
    else if (pathname === "/generate") stream = false;
    else return json({ error: "Not found" }, 404, origin, allowed);

    // Per-IP rate limit.
    if (env.RATE_LIMITER) {
      const ip = request.headers.get("CF-Connecting-IP") || "unknown";
      const { success } = await env.RATE_LIMITER.limit({ key: ip });
      if (!success) {
        return json(
          { error: "Rate limit exceeded. Please slow down and try again shortly." },
          429,
          origin,
          allowed,
        );
      }
    }

    const upstreamUrl = stream
      ? `${GEMINI_BASE}/${MODEL}:streamGenerateContent?alt=sse`
      : `${GEMINI_BASE}/${MODEL}:generateContent`;

    let geminiResp;
    try {
      geminiResp = await fetch(upstreamUrl, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "x-goog-api-key": env.GEMINI_API_KEY,
        },
        body: request.body,
      });
    } catch (e) {
      return json({ error: "Upstream request failed" }, 502, origin, allowed);
    }

    const headers = corsHeaders(origin, allowed);
    const contentType = geminiResp.headers.get("Content-Type");
    if (contentType) headers.set("Content-Type", contentType);

    return new Response(geminiResp.body, {
      status: geminiResp.status,
      headers,
    });
  },
};

function isAllowedOrigin(origin, env) {
  if (!origin) return false;

  const list = (env.ALLOWED_ORIGINS || "")
    .split(",")
    .map((s) => s.trim())
    .filter(Boolean);
  if (list.includes(origin)) return true;

  if (/^http:\/\/localhost(:\d+)?$/.test(origin)) return true;
  if (/^http:\/\/127\.0\.0\.1(:\d+)?$/.test(origin)) return true;

  return false;
}

function corsHeaders(origin, allowed) {
  const h = new Headers();
  if (allowed && origin) {
    h.set("Access-Control-Allow-Origin", origin);
    h.set("Vary", "Origin");
  }
  h.set("Access-Control-Allow-Methods", "POST, OPTIONS");
  h.set("Access-Control-Allow-Headers", "Content-Type");
  h.set("Access-Control-Max-Age", "86400");
  return h;
}

function json(obj, status, origin, allowed) {
  const h = corsHeaders(origin, allowed);
  h.set("Content-Type", "application/json");
  return new Response(JSON.stringify(obj), { status, headers: h });
}
