# Evidence: once-ui-system/magic-portfolio

| Item | Value |
| --- | --- |
| Branch / pinned SHA | `main` @ `76ae5e33e97599eaf209a4d9d844c4a77b3cc904` (remote `preview` is the same SHA) |
| Last commit | 2026-10-19T21:21:40+02:00, "Ship preview to main (#202)" |
| Stars / forks | 1,416 / 935 (GitHub API, 2026-10-22) |
| License | CC BY-NC 4.0 (see quote below) |
| Contribution policy | `PREVIEW.md`: "Branch from `preview` and open PRs against `preview`." and "Label it `no-demo` when nothing visible changes (CI, tests, tooling, ... typo fixes)". CI `.github/workflows/ci.yml`: `npm ci`, `npx tsc --noEmit`, `npx next build` on every PR. |
| AI policy | `.agents` holds Once UI component/style rules for coding agents; no contribution or AI-disclosure policy. No PR template. |
| Duplicate check | GitHub search `wasmer` across all 18 batch targets returned 0 PRs (2026-10-22) |
| Prior third-party deploy-button PRs | None provided for this target |

## License (quoted)

`LICENSE`:

> Creative Commons Attribution-NonCommercial 4.0 International CC BY-NC 4.0 ... You are free to: **Share** — copy and redistribute the material in any medium or format; **Adapt** — remix, transform, and build upon the material. Under the following conditions: **Attribution** — You must give appropriate credit, provide a link to the license, and indicate if changes were made. **NonCommercial** — You may not use the material for **commercial purposes**.

`README.md` "License": "Distributed under the CC BY-NC 4.0 License. - Attribution is required. - Commercial usage is not allowed. - You can extend the license to [Dopler CC](https://dopler.app/license) by purchasing a [Once UI Pro](https://once-ui.com/pricing) license."

The patch keeps the attribution and license text untouched and adds one sentence to the Wasmer section: a personal, non-commercial portfolio with attribution is within CC BY-NC 4.0; commercial use needs the extended license described in the README. Neither the README text nor the PR body suggests commercial/SaaS use.

## Source facts (at pinned SHA)

- `package.json`: `build` = `next build`, `start` = `next start`, `engines.node >=20.9.0`, no `packageManager`; `package-lock.json`. Lockfile resolves Next.js 16.4.2.
- Env read by code: only `PAGE_ACCESS_PASSWORD` (`src/app/api/authenticate/route.ts`), plus `NODE_ENV` for the cookie `secure` flag. `.env.example` has `PAGE_ACCESS_PASSWORD=password` — a placeholder, not a secure value; the README text tells users to set their own.
- Default protected route (`src/resources/once-ui.config.ts`): `/work/automate-design-handovers-with-a-figma-to-code-pipeline: true`.
- Customization: `src/resources/content.tsx`, `src/resources/once-ui.config.ts` (README steps 4-5); MDX in `src/app/blog/posts` and `src/app/work/projects`.
- Existing deploy: `## Deploy with Vercel` (last section). New `## Deploy on Wasmer` appended after it. `vercel.json` only has an `ignoreCommand`.

## Wasmer builder behaviour (wasmerio/shipit @ 587be23132ea = tag `v0.33.0`, "chore(main): release 0.33.0 (#133)", 2026-10-05)

The coordinator reports production pins Anybuild 0.33.0; the clone's HEAD is exactly the `v0.33.0` tag. Production config could still differ.

- Package manager: `package-lock.json` -> npm (`crates/anybuild/src/providers/node.rs:1172-1197`); npm version default `11` (`node.rs:1116-1124`).
- Install: `npm install` (not `npm ci`) with only `package.json` + lockfile present (`resources/starlib/tools/node.bzl:21-26, 95-139`).
- Framework: `next` in dependencies -> Next.js (`node.rs:1318-1320`).
- Build: `npx -y next-bundle@1.0.0 --build-command 'npm run build'` (`node.rs:23, 458-471, 1646-1667`).
- Start: `node .next-bundle/server.mjs` from a copy of `.next-bundle` (`node.rs:473-475, 1764-1768`; `node.bzl:209-211`). The repo's `start` script is not used.
- Node: `24` by default (`node.rs:561, 608`; override `ANYBUILD_NODE_VERSION`); `engines` is not read. `>=20.9.0` is satisfied. Local tests used Node 22.
- No config file needed.

## Build / smoke (see build.log)

- `npm ci` 0, `npm run build` 0. `npm start` on 3202: `/`, `/blog`, `/blog/quick-start`, `/work/simple-portfolio-builder`, protected route all 200; `/api/rss` 200 XML; `/api/check-auth` 401; `POST /api/authenticate` 500 with env unset.
- With a throwaway `PAGE_ACCESS_PASSWORD` on 3203: wrong 401, right 200 + `authToken` cookie, `check-auth` with cookie 200.
- Wasmer path emulated: `npx -y next-bundle@1.0.0 --build-command 'npm run build'` exit 0 (the first attempt failed with `next-bundle: not found` while another npx fetch ran at the same time; the retry succeeded, both are logged). `node .next-bundle/server.mjs` from an empty dir holding only `.next-bundle`, port 3206: pages 200, `check-auth` 401, `authenticate` 500 (env unset), **`/api/rss` 404** (re-checked on a fresh server, port 3208: `/api/rss` and `/api/rss/` both 404 with empty body, while `functions/api/rss.prerender-config.json` and `rss.prerender-fallback.body` containing the feed are in the bundle). `/api/rss` is `export const dynamic = "force-static"` (`src/app/api/rss/route.ts`). This points to the next-bundle 1.0.0 server not serving prerendered route-handler output; it is not a repo bug.

## Observation (not part of the PR; consider reporting separately)

The password gate is client-side only (`src/components/RouteGuard.tsx` is a `"use client"` wrapper). An unauthenticated GET of the protected route returned 200, and the HTML already contains the MDX body ("Key Features", "Technologies Used", "Challenges and Learnings" each found once; see build.log). The cookie value is also the constant `authenticated`. So `PAGE_ACCESS_PASSWORD` hides pages in the UI but is not access control. The README patch does not call it secure.

## Verdict: CONDITIONAL

The README-only patch is ready, and both `next start` and the emulated Wasmer build/serve work for pages and APIs. One item is open: `/api/rss` (an advertised README feature, "RSS feed at `/api/rss`") returned 404 under next-bundle 1.0.0. Remaining check for Codex: open `https://wasmer.io/apps/create?github=once-ui-system%2Fmagic-portfolio`, deploy, and `curl -sS -o /dev/null -w '%{http_code}' https://<app>/api/rss`. If it is 200, open the PR (base `preview`, label `no-demo`). If it is 404, hold the PR or report the issue to wasmerio/next-bundle first.
