# antfu-collective/vitesse: evidence

**Verdict: HOLD.** The staged `pnpm install` fails with a workspace/catalog input gap in Anybuild (`pnpm-workspace.yaml` is not staged).

## Repository
- Pinned SHA: `a8785264f83c2ebe1b3cf689296775a4949957c8` on branch `main` (shallow clone).
- Stars / forks: 9,440 / 954. The repo is not archived and was last pushed 2026-10-06 (GitHub API, 2026-10-22).
- License: MIT ("Permission is hereby granted, free of charge ..."), Copyright (c) 2020-PRESENT Anthony Fu.
- Contribution or AI policy files: none in the repo. There is no CONTRIBUTING, no PR template, no AGENTS.md and no CLAUDE.md. The only workflow is `.github/workflows/ci.yml`, and no bad-PR bot was found.
- Recent merged PRs (`is:merged merged:>2025-10-01`): 3.
- Duplicate check (`wasmer repo:antfu-collective/vitesse`): 0 results.
- Prior third-party deploy-button PRs (`deploy in:title`):
  - #561 "docs: add Deploy on Hostinger button" was closed 2026-02-20 without merging, about 2.5 hours after it was opened.
  - #562 is the same title by the same author and is still **open** and unanswered.
  - #378 (Dockerfile) was merged in 2022.
  - Together, #561 and #562 suggest the maintainers do not welcome vendor deploy buttons.
- Existing deploy docs: the README has "### Deploy on Netlify" and "### Docker Production Build". `netlify.toml` and a `Dockerfile` are present.

## Anybuild detection (v0.33.0, 587be231)
- Provider: node-static. Vite is detected from `vite-ssg build`, so detection is Strong, score 60 (`crates/anybuild/src/providers/mod.rs:421-426`).
- Static dir: Vite gives `dist` (`providers/node.rs:334`, `node_static.rs:226-231`).
- Package manager: pnpm 10.30.2, taken from `packageManager`.
- Install: `pnpm install` runs with inputs `package.json` plus the lockfile only (`resources/starlib/tools/node.bzl:111-139`, `node_install_inputs=['package.json']`). `pnpm-workspace.yaml` is **not** staged.

## Replay (patched clone, Node 24.22.1, pnpm 10.30.2)
- The staged files before install were `package.json` and `pnpm-lock.yaml`.
- `pnpm install` failed with exit 1:
  `ERR_PNPM_CATALOG_IN_OVERRIDES Could not resolve a catalog in the overrides: No catalog entry '@typescript-eslint/typescript-estree' was found for catalog 'dev'.`
- `pnpm run build` then failed with exit 127 (`vite-ssg: command not found`), and the replay reported `dist` as MISSING. Smoke: every path returned 404.
- Classification: **workspace/catalog input gap**.
  - `package.json` uses `catalog:build`, `catalog:dev`, `catalog:frontend` and `catalog:types` for its dependencies and also inside `pnpm.overrides`.
  - All of these catalogs are defined only in `pnpm-workspace.yaml`, which node.bzl does not stage before install.
- This is the same failure family the caller saw on vitesse-lite.

## Why there is no minimal fix
- A fix would need either the builder to stage `pnpm-workspace.yaml`, or upstream to inline every catalog version and drop the catalogs. The second is a large, unwanted change to the project's dependency management.
- A `Staticfile` cannot help, because the StaticFile provider does not build and `dist/` is not committed.

## Remaining check for the reviewer
- Re-evaluate once Anybuild stages `pnpm-workspace.yaml` (add it to `node_install_inputs` when present), then re-replay.
- Even then, weigh the precedent of the closed and ignored Hostinger button PRs (#561 and #562).
- `upstream.patch` (README "### Deploy on Wasmer" next to "Deploy on Netlify") is prepared but must not be submitted while on HOLD. No PR_TITLE or PR_BODY was written.
