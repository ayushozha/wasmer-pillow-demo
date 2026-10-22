# Evidence: Nutlope/roomGPT

## Verdict: CONDITIONAL

The patch is ready, and the old dependency tree installs, builds and serves locally on Node 22 (`npm ci` and `npm run build` exit 0, `npm start` serves `/` and `/dream` with 200). Codex must confirm one thing: the Wasmer build succeeds on `https://wasmer.io/apps/create?github=Nutlope%2FroomGPT`. The builder defaults to **Node 24** with `npm install` and npm 11. The repo has no `engines` field or `.nvmrc`, and `next@13.4.4` (2023) was not tested on Node 24 here because no Node 24 is available in this container. If the build fails on Node 24, set `ANYBUILD_NODE_VERSION=22`. That would need a README line or an `app.yaml`, so ask the coordinator first.

There is also a soft acceptance risk. The repo's last commit was 2023-09, and the README calls it "the previous and open source version" of a paid SaaS.

## Repo facts
- Pinned SHA: `611398c78da64f1794df2d99018c3d02d3ab0048` (branch `main`), last commit 2023-09-20T15:25:21-04:00.
- Stars / forks: 10,690 / 1,494 (GitHub API, 2026-10-22).
- License: MIT (`LICENSE`, "Copyright (c) 2023 Hassan El Mghari").
- Contribution / AI policy: no `.github` folder, CONTRIBUTING, PR template or AI policy.
- Duplicate check: a GitHub search for `wasmer` across all 18 targets returned 0 PRs (2026-10-22).
- Existing deploy buttons: Vercel appears twice, at the top and under `## One-Click Deploy`. The Wasmer button and note go under `## One-Click Deploy`, after the Vercel button.

## Task notes vs current source
- `.example.env` has `REPLICATE_API_KEY`, `NEXT_PUBLIC_UPLOAD_API_KEY`, and optionally `UPSTASH_REDIS_REST_URL` / `UPSTASH_REDIS_REST_TOKEN`. This matches the code.
- `REPLICATE_API_KEY`: `app/generate/route.ts:44, 76` sends `Authorization: "Token " + process.env.REPLICATE_API_KEY` to `api.replicate.com`. It is required for generation.
- `NEXT_PUBLIC_UPLOAD_API_KEY`: `app/dream/page.tsx:20-23` falls back to the Bytescale demo key `"free"`. Because the variable is `NEXT_PUBLIC_`, it is inlined into the client bundle at build time, so it must be set before building. The README says so.
- Upstash is optional. `utils/redis.ts:3-9` creates a client only when both the URL and the token are set, and `app/generate/route.ts:7-13` applies 5 requests per 1440 min per `x-real-ip`.
- Old dependencies: `npm ci` reports "20 vulnerabilities (1 low, 10 moderate, 7 high, 2 critical)" (build.log). I made no further claim, and no dependencies were changed.

## Local results (Node v22.22.0, npm 10.9.4)
- `npm ci`: exit 0, 190 packages. `npm run build` (Next.js 13.4.4): exit 0. The routes are `/` and `/dream` (static) and `/generate` (λ).
- `PORT=3106 npm start`:
  - `/` returned **200** and contained "roomGPT".
  - `/dream` returned **200** and contained "Choose your room theme" and "Generate your dream".
  - `POST /generate` with a malformed body returned **500** (JSON parse error, before any outbound call).
- No request with a valid body was sent, because that would call `api.replicate.com`.

## Wasmer builder (Anybuild) facts
Source: `wasmerio/shipit@587be23132ea` (2026-10-05). Production may differ.
- npm is detected from `package-lock.json` (`crates/anybuild/src/providers/node.rs:1185-1196`), and npm defaults to version 11 (`node.rs:1116-1124`).
- Install is **`npm install`**, not `npm ci`, with `CI=true` (`resources/starlib/tools/node.bzl:21-26, 134`).
- Next.js is detected (`node.rs:1318`).
- Build is `npx -y next-bundle@1.0.0 --build-command 'npm run build'` (`node.rs:458-471, 1646-1667`; this matches the `tests/plan_snapshots/node-next.json` snapshot). Start is `node .next-bundle/server.mjs` (`node.rs:473-475, 1765-1769`), not `next start`.
- Node defaults to 24 (`node.rs:561, 608`); `ANYBUILD_NODE_VERSION` overrides it (`providers/base.rs:34-43`). This default is the condition above.

## Limitations
No Wasmer deployment was submitted. wasmer.io and img.shields.io are blocked here. No real keys were used, and no Replicate or Bytescale calls were made. Node 24 was not tested.
