# 306 0xGG/crossnote-app — HOLD (workspace input gap: staged pnpm install fails)

## Repo and policy
- Pinned: main @ b843a10de961c507b829af433c90b0ddd182790e, last commit 2026-09-28.
- GitHub API, 2026-10-22: 1091 stars, 80 forks, AGPL-3.0, not archived, default branch `main`.
- Duplicate check: `wasmer` PR search returned 0 (2026-10-22).
- Policy files: none (no CONTRIBUTING, PR template, AGENTS or CLA; only .github/workflows/ci.yml).
- README:7-12: the original author has moved on and "the app's backend has been shut down". A new maintainer is rebuilding it. The current README describes a local-first app (browser storage / local folders, optional git sync).

## What Anybuild v0.33.0 runs (plan.txt)
- Provider: static Node.js, Vite, pnpm 11.17.0 (`packageManager`). install `pnpm install`, build `pnpm run build`, static_dir `dist`.
- Staged before install: `package.json` and `pnpm-lock.yaml` only (replay.log line 20; node.bzl:95-115 copies only the lockfile + `node_install_inputs`). `pnpm-workspace.yaml` is NOT staged, but it holds this repo's `overrides`, `patchedDependencies` (patches/@0xgg__echomd@1.0.4.patch) and `allowBuilds`.

## Replay result (replay.log, local harness, unpatched clone at the pinned SHA)
- `pnpm install` exited 1 with `[ERR_PNPM_LOCKFILE_CONFIG_MISMATCH] Cannot proceed with the frozen installation. The current "overrides" configuration doesn't match the value found in the lockfile`, so INSTALL FAILED.
- Classification: **workspace/catalog input gap**, which is a real Anybuild limitation, so HOLD.
- `pnpm run build` then made pnpm 11 re-run `pnpm install` with the full tree copied in. That masks the failure, so it does not count as a pass. My disk watchdog killed it (SIGTERM, shown in log) when free space fell below about 2.95 GB. No build output, no smoke.
- A minimal fix would mean moving overrides and patches into package.json `pnpm` fields, which is a dependency-config change and not README-only. So no patch was prepared.

## Runtime services (from source, not browser-verified)
- `VITE_DEFAULT_CORS_PROXY` (src/config.ts:7-8) defaults to `https://cors.isomorphic-git.org`, a third-party proxy used for git sync to cross-origin remotes. Git sync is optional. The value is baked into public JS.
- The `prebuild` script runs scripts/download-emoji-sheet.mjs, a network fetch at build time.
- Core local-notes mode with no backend was NOT proven here, because the Anybuild path fails before a build exists.

## Remaining check for reviewer
- Revisit if Anybuild stages `pnpm-workspace.yaml` for pnpm installs. Then replay with ≥3 GB headroom, smoke `/`, the hashed assets and deep links (check the router type), and prove create/edit/reload of a local note with network to cors.isomorphic-git.org blocked.
- Note: AGPL-3.0 means hosting a modified version carries source-offer obligations.
