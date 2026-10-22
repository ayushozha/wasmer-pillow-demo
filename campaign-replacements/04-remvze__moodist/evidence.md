# remvze/moodist: evidence

**Verdict: READY.**

## Repository
- Pinned SHA: `11c0be2200116a3635880d600fd6953899cc51a3` on branch `main`.
- Stars / forks: 3,901 / 335. The repo is not archived and was last pushed 2026-09-27 (GitHub API, 2026-10-22).
- License: MIT, Copyright (c) 2023 MAZE. The README's "Third-Party Assets" section covers the sounds separately; the patch does not touch them.
- `CONTRIBUTING.md` asks contributors to fork, branch and open a PR, and says: "Commit messages should follow Conventional Commits Specification." There is no PR template and no AI policy.
- Workflows: `build_docker.yml` only. No bad-PR bot.
- Recent merged PRs since 2025-10-01: 6.
- Duplicate `wasmer` PR check: 0. Prior deploy-button PRs: none.
- Existing deploy docs: the README has "## Self-Hosting" with "### 1. Run with Docker" and "### 2. Run with Docker Compose". The patch adds "### 3. Deploy on Wasmer" in the same list. The app is fully static (ambient sounds, no backend), so static hosting is a natural self-host option.

## Anybuild detection (v0.33.0)
- Provider: node-static, framework Astro, Strong detection (60; `mod.rs:421-426`). Static dir: `dist` (`providers/node.rs:330`).
- Package manager: pnpm 10 (`pnpm-lock.yaml`; there is no `packageManager` field). Install runs `pnpm install` with `package.json` and `pnpm-lock.yaml` staged.
- `pnpm-workspace.yaml` (holding `saveExact` and `allowBuilds` for esbuild and sharp) is not staged. It has no catalogs, and the install succeeded without it.

## Replay (patched clone, Node 24.22.1, pnpm 10)
- `pnpm install` succeeded (exit 0). `pnpm run build` (`astro build`) succeeded (exit 0). `static_app` holds 122 files.
- Smoke:
  - `/` returned 200 ("Moodist: Ambient Sounds for Focus and Calm").
  - `/manifest.webmanifest` returned 200.
  - All 4 referenced assets returned 200.
  - `/nope` returned 404 (expected; this is a one-page app).
- I did not test audio playback or the PWA service worker in a browser; the smoke test only fetches over HTTP.

## Remaining check for the reviewer
- Verify the badge and import page in a browser; `img.shields.io` and `wasmer.io` are blocked here.
- Use a Conventional Commits message (`docs: ...`).
