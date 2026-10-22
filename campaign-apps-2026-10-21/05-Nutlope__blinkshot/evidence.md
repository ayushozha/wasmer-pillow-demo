# Evidence: Nutlope/blinkshot

## Verdict: READY

The patch is ready. The local frozen install and `pnpm build` both pass with **no env**, and `pnpm start` passes as well. On the running server, the home page returns 200. The API also fails safely without a key: the origin guard returns 403, and a missing server key returns 400 with no outbound call.

Remaining check (the same for every target in this batch): Codex opens `https://wasmer.io/apps/create?github=Nutlope%2Fblinkshot` and confirms that Next.js and pnpm are detected.

## Repo facts
- Pinned SHA: `e730e2a9dfd9aeb4e18856ba96f8b02a740343b9` (branch `main`), last commit 2026-08-31T14:05:17+02:00 ("Replace deprecated Flux Schnell with Juggernaut Lightning").
- Stars / forks: 1,040 / 192 (GitHub API, 2026-10-22).
- License: **none found**. There is no LICENSE file and no `license` field.
- Contribution / AI policy: no `.github`, CONTRIBUTING, PR template or AI policy. The recent commit subjects are plain sentences, so the PR title uses `docs:` to match the other targets.
- Duplicate check: a GitHub search for `wasmer` across all 18 targets returned 0 PRs (2026-10-22).
- Existing deploy buttons: none. A new `## Deploy on Wasmer` section goes after "Cloning & running", with the same wording and table layout as turboseek and llamatutor.

## Task notes vs current source (Upstash / Braintrust / Helicone)
- The package manager is pnpm (`pnpm-lock.yaml` v9). The README says `npm install`; I left that unchanged.
- `.example.env` contains only `TOGETHER_API_KEY`, `BRAINTRUST_API_KEY` and `BRAINTRUST_PROJECT=blinkshot`. It has no Helicone or Upstash entries, even though the code reads both.
- **Upstash: optional.** `app/api/generateImages/route.ts:29-37` creates the rate limiter only `if (process.env.UPSTASH_REDIS_REST_URL)` (5 requests per 1440 min, and it only applies when the user has not supplied their own key).
- **Helicone: optional.** It is used only `if (process.env.HELICONE_API_KEY)` (`route.ts:186-191`), which switches the base URL to `together.helicone.ai`.
- **Braintrust: optional.** `lib/braintrust.ts:11` returns early when `BRAINTRUST_API_KEY` is unset, and `BRAINTRUST_PROJECT` defaults to `blinkshot`.
- `NEXT_PUBLIC_SITE_URL`: optional. It adds an allowed origin for the origin guard (`route.ts:42-53`, `lib/origin-guard.ts`). Same-origin browser requests (`Sec-Fetch-Site: same-origin`) pass regardless, and so does a request whose origin matches the request URL. Not setting `VERCEL_URL` on Wasmer therefore does not break the app.
- **`TOGETHER_API_KEY` is required even for bring-your-own-key users.** `new Together(options)` (`route.ts:194`) runs before `client.apiKey = userAPIKey`. together-ai 0.44.1 throws in its constructor when `TOGETHER_API_KEY` is unset (`node_modules/together-ai/client.js:76`). Verified at runtime: with a user key and no server key, the response was **400** "The TOGETHER_API_KEY environment variable is missing or empty". The README states this neutrally ("also needed when visitors enter their own Together key").
- `proxy.ts` blocks `geo.country === "RU"` (Vercel geo). Elsewhere it has no effect.

## Local results (Node v22.22.0, pnpm 10.28.0)
- `pnpm install --frozen-lockfile`: exit 0. `pnpm build` with no env: exit 0 (Next.js 16.2.6).
- `pnpm start` on PORT 3105:
  - `/` returned **200** and contained "BlinkShot". `/robots.txt` returned **200**.
  - `POST /api/generateImages` without Origin or Sec-Fetch-Site returned **403** `{"error":"Forbidden"}`.
  - The same request with `Sec-Fetch-Site: same-origin`, a benign prompt, a placeholder `userAPIKey` and no server key returned **400** (Together constructor error). No network call was made.

## Wasmer builder (Anybuild) facts
Source: `wasmerio/shipit@587be23132ea` (2026-10-05). Production may differ.
- pnpm is detected from the lockfile (`crates/anybuild/src/providers/node.rs:1185-1196`), and its version defaults to 10 (`node.rs:1116-1124`).
- Install runs `pnpm install` with `CI=true` and `pnpm_config_dangerously_allow_all_builds=true` (`resources/starlib/tools/node.bzl:118-130`).
- Next.js is detected (`node.rs:1318`).
- Build is `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'` (`node.rs:458-471, 1646-1667`). Start is `node .next-bundle/server.mjs` (`node.rs:473-475, 1765-1769`).
- Node defaults to 24 (`node.rs:561, 608`; override with `ANYBUILD_NODE_VERSION`, `providers/base.rs:34-43`). Local tests used Node 22.

## Limitations
No Wasmer deployment was submitted. wasmer.io and img.shields.io are blocked here. No real keys were used and no paid calls were made. The `/api/moderate` route was not exercised.
