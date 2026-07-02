# Gemini proxy worker

A Cloudflare Worker that sits between the portfolio's Flutter app and the Google
Gemini API so the **Gemini API key never ships to the browser**. The browser
calls this worker with no key; the worker adds the secret key and forwards the
request to Google.

- `src/index.js` — the proxy (routes `/generate` and `/stream`, CORS, origin
  allowlist, per-IP rate limit).
- `wrangler.toml` — config: allowed origins + rate limit. **No secrets here.**

## One-time setup

From inside this `worker/` folder:

```bash
npm install                 # installs wrangler locally
npx wrangler login          # opens a browser to authenticate your Cloudflare account
```

## Set the secret key

**Rotate the Gemini key first** in Google AI Studio — the old one was shipped to
the browser and is compromised. Then store the NEW key as a secret:

```bash
npx wrangler secret put GEMINI_API_KEY
# paste the new key when prompted
```

The secret is encrypted by Cloudflare and is never in this repo.

## Deploy

```bash
npx wrangler deploy
```

This prints the public worker URL, e.g.:

```
https://naresh-gemini-proxy.<your-subdomain>.workers.dev
```

Give that URL to the app — it goes into `_proxyBaseUrl` in
`lib/core/services/gemini_service.dart`.

## Local testing

```bash
npx wrangler dev            # runs the worker at http://localhost:8787
```

Smoke test the origin check (should be 403 with no/foreign Origin, 200/SSE with an
allowed Origin):

```bash
# blocked — no allowed Origin
curl -i -X POST http://localhost:8787/stream -d '{}'

# allowed — localhost Origin, streams SSE from Gemini
curl -i -X POST http://localhost:8787/stream \
  -H 'Origin: http://localhost:9999' \
  -H 'Content-Type: application/json' \
  -d '{"contents":[{"role":"user","parts":[{"text":"hi"}]}]}'
```

## Notes

- `period` in `wrangler.toml` must be `10` or `60`. Current cap: 15 req / 60s per IP.
- If `npx wrangler deploy` errors on the `[[ratelimits]]` binding (older wrangler),
  run `npm install wrangler@latest`, or temporarily comment the block out to deploy
  without rate limiting while you sort it.
- Change the model in `src/index.js` (`MODEL`) and redeploy — no app rebuild needed.
