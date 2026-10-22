# Evidence: Nutlope/llamatutor

## Verdict: READY

The patch is ready. The local frozen install, `pnpm build` with **no env at all**, and `pnpm start` all pass. The home page returns 200, and the API routes fail without keys as expected. As a supplement, the exact build command the Wasmer builder generates (`pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'`) also completed locally (exit 0).

One check remains, the same for every target in this batch. Codex should open `https://wasmer.io/apps/create?github=Nutlope%2Fllamatutor` and confirm that Next.js is detected and that pnpm is the package manager before opening the PR. Serving `node .next-bundle/server.mjs` was not run here.

## Repo facts
- Pinned SHA: `5b88de25bccd33524342f5ee34ca49ca38aca7f3` (branch `main`), last commit 2026-07-12T12:12:14-07:00.
- Stars / forks: 2,053 / 342 (GitHub API, 2026-10-22).
- License: **none found**. There is no LICENSE file and no `license` field in package.json.
- Contribution / AI policy: there is no `.github` folder, CONTRIBUTING, PR template or AI policy.
- Duplicate check: a GitHub search for `wasmer` across all 18 targets returned 0 PRs (2026-10-22).
- Existing deploy buttons: none. A new `## Deploy on Wasmer` section goes after "Cloning & running". Its wording and table match the turboseek and blinkshot patches.

## Task notes vs current source
- The package manager is pnpm (`pnpm-lock.yaml` v9). The README still says `npm install`, and that is left unchanged.
- **Upstash is optional and does not crash the app.** `app/api/getChat/route.ts:12-20` creates the rate limiter only `if (process.env.UPSTASH_REDIS_REST_URL)` (10 requests per 1440 min, prefix `llamatutor`). When the variable is unset, the module loads and the handler runs; smoke tests confirmed this (the handler was reached and failed only on the deliberately malformed body). Caveat: if the URL is set without the token, `Redis.fromEnv()` would be misconfigured. The README therefore lists both together.
- `EXA_API_KEY`: `app/api/getSources/route.ts` throws `EXA_API_KEY is required` when it is missing, which returns 500. It is required.
- `TOGETHER_API_KEY` and `HELICONE_API_KEY`: chat is sent with a hand-rolled `fetch` to `https://together.helicone.ai/v1/chat/completions`, with `Helicone-Auth: Bearer ${HELICONE_API_KEY}` and `Authorization: Bearer ${TOGETHER_API_KEY}` (`utils/TogetherAIStream.ts:31-40`). So Helicone is always in the request path. The README marks it "Recommended". I did not test behaviour without a Helicone key, because no outbound calls were made.
- `proxy.ts` blocks requests where `X-Vercel-IP-Country: IN`. That header is Vercel-specific, so on other hosts the rule does nothing. No change was made.
- `/api/getChat` uses `runtime = "edge"`. It worked under `next start`, but I did not verify it under Wasmer's server.

## Local results (Node v22.22.0, pnpm 10.28.0)
- `pnpm install --frozen-lockfile`: exit 0. `pnpm build` with no env: exit 0.
- `pnpm start` on PORT 3104: `/` returned **200** and contained "Llama Tutor" and "Your Personal".
- `POST /api/getSources` returned **500** (`EXA_API_KEY is required`).
- `POST /api/getChat` with a malformed body returned 500 (JSON parse). This shows the route module loads with no Upstash vars set, and no outbound call was made.
- Supplementary run in a fresh copy: `CI=true pnpm install`, then `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'`, exit 0. It printed "Build output written to .next-bundle" and "Run it with: node .next-bundle/server.mjs". next-bundle is published by wasmerio (`repository: github.com/wasmerio/next-bundle`). After that, the session's permission policy declined further inspection or execution of this external package, so serving the bundle was not tested.

## Wasmer builder (Anybuild) facts
Source: `wasmerio/shipit@587be23132ea` (2026-10-05). Production may differ.
- pnpm is detected from the lockfile (`crates/anybuild/src/providers/node.rs:1185-1196`), and its version defaults to 10 (`node.rs:1116-1124`).
- Install is `pnpm install` with `CI=true` (`resources/starlib/tools/node.bzl:21-26, 120-121`).
- Next.js is detected (`node.rs:1318`).
- Build: `node.rs:458-471, 1646-1667`. Start is `node .next-bundle/server.mjs` (`node.rs:473-475, 1765-1769`).
- Node 24 by default (`node.rs:561, 608`; override with `ANYBUILD_NODE_VERSION`, see `providers/base.rs:34-43`). Local tests ran on Node 22.

## Limitations
No Wasmer deployment was submitted. wasmer.io and img.shields.io are blocked here. No real keys were used and no paid calls were made.
