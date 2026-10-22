# Evidence: Nutlope/turboseek

## Verdict: CONDITIONAL

The patch is ready, and the local build and start are proven. One item must be confirmed before opening the PR. **`pnpm run build` fails unless `TOGETHER_API_KEY` and `EXA_API_KEY` are present at build time.** Both clients are constructed at module scope in `utils/clients.ts:6-21`, and Next evaluates those modules during "Collecting page data". On `https://wasmer.io/apps/create?github=Nutlope%2Fturboseek`, Codex must confirm two things:
- environment variables can be entered before the first build;
- they are visible to the build step.

If they cannot be, the first build from the button will fail, and the README sentence "add both before the first build" would need a different workaround, which would mean HOLD.

## Repo facts
- Pinned SHA: `9e16b401d5595cbe0fadaad12ef7d32b3635deec` (branch `main`), last commit 2026-07-12T12:12:17-07:00.
- Stars / forks: 1,658 / 261 (GitHub API, 2026-10-22).
- License: **none found**. There is no LICENSE file, no `license` field in `package.json`, and no license text in the README. This does not block a docs PR, but note it.
- Contribution / AI policy: there is no `.github` folder, CONTRIBUTING, PR template or AI policy.
- Duplicate check: a GitHub search for `wasmer` across all 18 targets returned 0 PRs (2026-10-22).
- Existing deploy buttons: none. A new `## Deploy on Wasmer` section goes after "Cloning & running". It uses the same wording and table layout as the llamatutor and blinkshot patches.

## Task notes vs current source
- The package manager is pnpm: `pnpm-lock.yaml` v9, with no `packageManager` field. The README still says `npm install`; that is left unchanged.
- `.example.env` is `TOGETHER_API_KEY`, `HELICONE_API_KEY`, `EXA_API_KEY`. That is confirmed.
- The README's "How it works" section still describes the Bing search API, and "Cloning & running" mentions SERP API/Bing. Current code uses **Exa** (`app/api/getSources/route.ts`, `exaClient.search`). The Wasmer section documents only the current code and leaves the outdated text alone.
- The answer stream uses `@ai-sdk/togetherai` directly against Together (`togetherClientAISDK`). Related questions use the `together-ai` SDK with `baseURL: "https://together.helicone.ai/v1"` and a `Helicone-Auth: Bearer ${HELICONE_API_KEY}` header (`utils/clients.ts:6-13`). So Helicone is in the request path for related questions, and the README marks it "Recommended". I did not verify what happens without a Helicone key, because no outbound calls were made.

## Local results (Node v22.22.0, pnpm 10.28.0)
- `pnpm install --frozen-lockfile`: exit 0.
- `pnpm build` with no env: **exit 1**, `The TOGETHER_API_KEY environment variable is missing or empty` / `Failed to collect page data for /api/getSimilarQuestions`.
- `TOGETHER_API_KEY=placeholder pnpm build`: **exit 1**, `ExaError: API key must be provided`.
- `TOGETHER_API_KEY=placeholder EXA_API_KEY=placeholder pnpm build`: **exit 0**.
- `pnpm start` (PORT 3103) with no env at runtime: `/` returned **200** with "Search smarter" and "Ask anything". `POST /api/getSources` returned **500**, and `POST /api/getAnswer` returned **500**. Both fail at module load because the Together key is missing. These are uncaught 500s, not friendly errors, but the home page is unaffected and no outbound or paid call happens.

## Wasmer builder (Anybuild) facts
Source: `wasmerio/shipit@587be23132ea` (2026-10-05). Production may differ.
- pnpm is detected from the lockfile (`crates/anybuild/src/providers/node.rs:1185-1196`), and its version defaults to 10 (`node.rs:1116-1124`).
- Install is `pnpm install` with `CI=true` (`resources/starlib/tools/node.bzl:21-26, 120-121`).
- Next.js is detected (`node.rs:1318`).
- Build is `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'` (`node.rs:23, 458-471, 1646-1667`), which runs the same failing-without-keys `next build`. Start is `node .next-bundle/server.mjs` (`node.rs:473-475, 1765-1769`).
- Node 24 by default (`node.rs:561, 608`; override with `ANYBUILD_NODE_VERSION`, see `providers/base.rs:34-43`). Local tests ran on Node 22.
- Whether app secrets are injected into the build environment is decided by the platform, not by this builder source. It is unverified, which is exactly the condition above.

## Limitations
No Wasmer deployment was submitted. wasmer.io and img.shields.io are blocked here. No real keys were used and no paid calls were made; the build used the literal string `placeholder-not-a-real-key`.
