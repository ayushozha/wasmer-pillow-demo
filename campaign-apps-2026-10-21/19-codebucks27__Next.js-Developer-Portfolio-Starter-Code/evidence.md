# Evidence: codebucks27/Next.js-Developer-Portfolio-Starter-Code

| Item | Value |
| --- | --- |
| Branch / pinned SHA | `main` @ `b6f8ee2d3a75664858d02436f697e4b68118396b` |
| Last commit | 2026-10-06T22:21:58+05:30, "update: ReadMe" (shallow clone shows only this commit) |
| Stars / forks / open issues | 1,351 / 664 / 0 (GitHub API, 2026-10-22) |
| License | **None.** No LICENSE file at the repo root and no license statement in README.md or package.json. By default, all rights are reserved by the author. |
| Contribution / AI policy | None (no CONTRIBUTING, AGENTS, PR template; `.github/FUNDING.yml` only) |
| Duplicate check | GitHub search `wasmer` returned 0 PRs (2026-10-22, from the coordinator) |
| Prior third-party deploy-button PRs | None provided |

## Source facts (at pinned SHA)

- `package.json`: `build` = `next build`, `start` = `next start`, no `engines`, no `packageManager`. Deps: `next` 15.5.24, `react`/`react-dom` 18.2.0, `framer-motion` ^10.6.0, `eslint` / `eslint-config-next` 13.2.4 as runtime deps.
- **No lockfile** (`package-lock.json`, `yarn.lock`, `pnpm-lock.yaml` and `bun.lock` are all absent; build.log). Wasmer's Anybuild picks npm by default (`node.rs:1172-1197`) and runs `npm install` (`node.bzl:21-26`), so it resolves fresh, the same as this test.
- **The app is the stock create-next-app page.** `src/pages/index.js` renders "Create Next App" / "Get started by editing `src/pages/index.js`"; the only other route is `/api/hello`. `/about`, `/projects` and `/articles` do not exist (404). `public/images/{projects,articles,svgs}` hold assets for the tutorial. The finished portfolio shown in the README screenshots is linked externally ("For Demo and Final Code checkout following link").
- README content to preserve (untouched): tutorial/YouTube links, screenshots, the "Resources Used" attributions (Midjourney image, Albert Dera on Unsplash, Google Fonts, Iconify, Lukasz Adam), the library list and "Other project".
- No `process.env` reads, so no env vars.
- Task notes vs source: the "Framer Motion portfolio" exists only as a dependency and assets; no portfolio routes exist at this SHA.

## Wasmer builder (wasmerio/shipit @ 587be23132ea = tag `v0.33.0`)

npm (no lockfile) -> `npm install`; `next` dependency -> Next.js (`node.rs:1318-1320`). Build: `npx -y next-bundle@1.0.0 --build-command 'npm run build'` (`node.rs:458-471, 1646-1667`). Start: `node .next-bundle/server.mjs` (`node.rs:473-475`). Node 24 by default (`node.rs:561, 608`). Node 24 is not installed in this container, so all tests ran on Node 22.22.0.

## Build / smoke (build.log)

- The first `npm install` hit ENOSPC because the shared container disk was full. I freed my own scratch dirs and retried on a fresh copy: `npm install` 0, `npm run build` 0 (Next.js 15.5.24; `/`, `/404`, `/api/hello`).
- `PORT=3251 npm start`: `/` 200 (marker "Get started by editing" present), `/api/hello` 200 `{"name":"John Doe"}`, `/about` `/projects` `/articles` 404, `/next.svg` `/vercel.svg` `/favicon.ico` 200, `/_next/image?url=/images/projects/devdreaming.jpg` 200 image/jpeg.
- Emulated Wasmer path: `npx -y next-bundle@1.0.0 --build-command 'npm run build'` exit 0; `node .next-bundle/server.mjs` from an empty dir (port 3252): `/` 200, `/api/hello` 200, `/about` 404, static files 200, `_next/image` 200 (webp).

## Verdict: HOLD

It builds and serves fine, both with `next start` and with the emulated Wasmer bundle. But:

1. The button would deploy the default create-next-app page, not a portfolio. That is misleading on a repo whose README is all portfolio screenshots. The staged README text says so explicitly, but the value of a one-click deploy here is low.
2. There is no LICENSE, so the default is all rights reserved. A deploy button that encourages third-party hosting of the code is something to ask the author about first.
3. There is no lockfile, so builds are not reproducible.

The patch, PR title and body are staged in case the maintainer agrees. Remaining check for Codex: do not open the PR. If you want to proceed, first open an issue asking codebucks27 whether they want a deploy option and a license; reconsider only on a positive reply.
