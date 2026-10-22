# Evidence: Nutlope/blinkshot

## Verdict: HOLD

Do not open this PR yet. In the replay of the Wasmer build path, the bundle Anybuild would export serves the page, but its image API crashes.

The flat replay of Anybuild v0.33.0 builds the bundle. `pnpm install`, `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'` and `pnpm prune --prod` all exit 0. When the exported bundle is served with `node .next-bundle/server.mjs` on Node 24.22.1:
- `/` and `/robots.txt` return 200.
- **Every `POST /api/generateImages` returns 500 `Internal Server Error`.** This includes the requests that should get the origin guard's 403. The error is `Failed to load external module next/dist/compiled/next-server/app-route-turbo.runtime.prod.js: Error: Cannot find module '@swc/helpers/_/_interop_require_default'`.

The root cause is next-bundle@1.0.0 with pnpm's isolated layout:
- The Next server trace lists the symlink `node_modules/.pnpm/next@16.2.6_…/node_modules/@swc/helpers`.
- `bin/build.mjs:234-250` (`copyExistingFile`) copies only regular files, so it skips that symlink.
- `:275-328` re-links symlinks only inside directories that already hold a copied file. The scoped dir `next@…/node_modules/@swc` never qualifies.
- As a result, 16 traced symlinks are missing from the bundle, including `@swc/helpers`, `@next/env`, `styled-jsx`, `client-only` and `sharp`. The target package `@swc+helpers@0.5.15` itself is present in the bundle.

This is a builder or tooling problem, not a README problem. It needs a fix in next-bundle, or in how Wasmer bundles pnpm projects, before the button works for this repo.

The Wasmer runtime itself (Edge.js, `edgejs_enable`/`edgejs_precompile: true`) was not replayed. Whether production hits the same missing symlink there is untested, but the files are absent from the bundle either way.

**Diagnostic (not the Wasmer output; build.log §1c).** I copied the bundle and re-added the 15 missing relative symlinks whose targets were already in the bundle. With that change, every API check behaved as documented. This confirms that the missing symlinks are the only blocker found, and that the README table is accurate.

## Flat replay facts (build.log §1)
- Source: the patched clone exported without `.git` to `$SCRATCH/replay/05-Nutlope__blinkshot/src`. No ancestor directory has a `package.json`.
- Plan from `anybuild-v0.33.0 plan --temp-anybuild --wasmer`:
  - Detected: Node.js, Next.js, server `node`, `pnpm_version: "10"`, Node 24.
  - Install: `pnpm install`. Build: `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'`. Start: `node .next-bundle/server.mjs`.
- The steps follow `crates/anybuild/resources/starlib/tools/node.bzl` at v0.33.0 (`:95-150`):
  1. Stage only `pnpm-lock.yaml` and `package.json`.
  2. `pnpm install` with `CI=true pnpm_config_minimum_release_age=0 pnpm_config_dangerously_allow_all_builds=true pnpm_config_strict_dep_builds=false`.
  3. Copy the sources, then build.
  4. `pnpm prune --prod`.
  5. `cp -R .next-bundle <app>`.
- Toolchain: Node 24.22.1, pnpm 10.28.0. Next.js 16.2.6 (Turbopack). The build detected the `/api/generateImages`, `/api/moderate` and Proxy routes.
- Not replayed: `optimize-node-modules.sh` and the Edge.js runtime.
- **INIT_CWD:** pnpm is not affected. `INIT_CWD` was unset, and next-bundle printed `Building …/replay/05-Nutlope__blinkshot/build`, which is the correct root.

## Runtime smoke on the real bundle (`node .next-bundle/server.mjs`, loopback-only `unshare -n`, build.log §1b)
- The external connectivity probe failed (no route).
- `/` returned **200** and contained "BlinkShot". `/robots.txt` returned **200**.
- `POST /api/generateImages` returned **500** in all seven checks:
  - no Origin header;
  - a foreign Origin;
  - same-origin without a server key;
  - a short prompt;
  - a fake key with `TOGETHER_BASE_URL` pointed at the local mock;
  - a fake key with a fake Helicone key routed through the mock proxy.
- The mock recorded **no** upstream request, so the route crashes at module load before any outbound call.

## Diagnostic smoke (hand-patched bundle copy, build.log §1c), for doc accuracy only
- **Origin guard:** with no Origin, Referer or Sec-Fetch-Site the response is **403** `{"error":"Forbidden"}`. `Origin: https://evil.example` also gets **403**, even with keys set.
- **Server key required:** a same-origin request with a user key and no server key returns **400** "The TOGETHER_API_KEY environment variable is missing or empty". The cause is that `new Together(options)` (`app/api/generateImages/route.ts:194`) runs before `client.apiKey = userAPIKey` (`:196-198`).
- **Prompt validation:** the prompt "hi" returns **400** "Please enter a longer prompt".
- **Fake key with local mock:** I set a fake `TOGETHER_API_KEY` with `TOGETHER_BASE_URL=http://127.0.0.1:3740/v1` (Stainless SDK env), with no Helicone key. The app sent `POST /v1/images/generations` (model `Rundiffusion/Juggernaut-Lightning-Flux`, `Authorization: Bearer <21 chars>`) to the mock. It returned the mock's base64 placeholder with **200**.
- **Fake Helicone key:** with a fake `HELICONE_API_KEY` and HTTPS forced through the logging mock, the app went to `together.helicone.ai` with `Helicone-Auth` and `Helicone-Property-BYOK: false` (`route.ts:184-192` overrides the base URL). This confirms that Helicone is **optional** and only changes where requests are sent.
- **Origin matching the request's own origin:** `Origin: http://127.0.0.1:3742` returned **403** under `server.mjs`. Browsers' own fetches send `Sec-Fetch-Site: same-origin`, which passes (`lib/origin-guard.ts:35`). `NEXT_PUBLIC_SITE_URL` is read at runtime (not inlined) and can add an allowed origin.
- **No generation proof:** image generation was **never** run against Together or Helicone. The "image" in these tests is a mock placeholder.

## Notes vs current source
- **Optional integrations:** Upstash (`route.ts:29-37`), Helicone (`:186-192`), Braintrust (`lib/braintrust.ts`, returns early without a key) and `NEXT_PUBLIC_SITE_URL` (`route.ts:42-54`) are all optional.
- **`TOGETHER_API_KEY`:** required, even for bring-your-own-key users.
- **Vercel-only rule:** `proxy.ts` is a Vercel geo rule. Under next-bundle's server, Node-runtime middleware is not run (`server.mjs:762`).
- **Untested route:** `/api/moderate` was not exercised.

## Repo facts
- Pinned SHA: `e730e2a9dfd9aeb4e18856ba96f8b02a740343b9` (main), last commit 2026-08-31.
- Stars / forks: 1,040 / 192.
- License: none found. There is no `.github`, CONTRIBUTING or AI policy.
- Duplicate check: 0 `wasmer` PRs.
- Deploy buttons: none existing.

## Patch
`upstream.patch` is a `git diff` that touches README.md only (+14 lines). `git apply --check -R` passes. The README table was re-checked against the diagnostic runs and is unchanged.

## Limitations
- No Wasmer deployment was made.
- wasmer.io and img.shields.io are blocked from this environment.
- No real keys or paid calls were used.
- The server ran on stock Node 24.22.1, not on Edge.js.
