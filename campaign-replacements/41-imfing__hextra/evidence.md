# imfing/hextra — evidence

- Pinned SHA: `e58687ee6c2e7ccd054c7ef31307d2147a7b8bd7` (branch `main`); clone `$S/rup/imfing__hextra`.
- Stars / forks: 2,398 / 438 (GitHub API, 2026-10-22). Not archived.
- License: MIT ("Copyright (c) 2023 Xin ... Permission is hereby granted, free of charge ...").
- `AGENTS.md` / `CLAUDE.md` (identical, AI-agent guidance): describes the repo as "a modern, responsive Hugo theme"; "The `docs/` directory serves as both documentation and testing ground ... Run from docs with: `hugo server --themesDir=../..`". No AI ban. `.github/CONTRIBUTING.md`: Fork-and-PR, Conventional Commits; no PR template; no bad-PR bots.
- Existing deploy: `netlify.toml` builds `cd docs && hugo --gc --minify --themesDir ../.. -b ${DEPLOY_PRIME_URL}`, publish `docs/public`, `HUGO_VERSION = "0.156.0"`; GitHub Pages workflow. README "Quick Start" sends users to the separate **imfing/hextra-starter-template** ("the simplest method to bootstrap a new website with Hextra theme").
- Recent merged PRs: `is:merged merged:>2025-10-01` (excluding dependabot/renovate) → 81. Prior deploy PRs: only owner docs PRs (#158, #699, #901) and an unmerged IPFS PR (#249); no third-party deploy-button PR. Duplicate `wasmer` → 0.

## Anybuild v0.33.0 detection
- Root `hugo.toml` exists → Hugo provider "Strong" score 80 (`providers/hugo.rs:179-180`, `mod.rs:389-391`). Plan: Hugo 0.153.2, build `hugo --gc --minify` at repo root, output `public`.
- `hugo.bzl:21` hard-codes `run("hugo --gc --minify")` in the copied repo root; there is no way to pass `--source=docs --themesDir=../..`.
- **The repo root is the theme, not a site**: root `hugo.toml` only holds theme module config (`[module.hugoVersion] min = '0.146.0'`, output formats); there is no root `content/`. The real docs/demo site is `docs/` (its own `hugo.yaml`, `content/`, `go.mod`, `hugo.work`).

## Replay (unpatched, `replay.sh <clone> w8-hextra-root 3697 /docs/ /index.xml /sitemap.xml`)
- Hugo: **v0.153.2+extended**, built from source here with `GOFLAGS=-mod=mod CGO_ENABLED=1 go install -tags extended github.com/gohugoio/hugo@v0.153.2` (GitHub release downloads blocked). `go` was removed from PATH for the replay (Anybuild's Hugo image has only the Hugo binary: `build/docker.rs:49` maps `hugo` to `ubi:gohugoio/hugo[matching=extended]`).
- `hugo --gc --minify` → exit=1: `Could not retrieve FlexSearch js file from https://cdn.jsdelivr.net/npm/flexsearch@0.8.143/dist/flexsearch.bundle.min.js ... Forbidden` — **FAIL_ENV** (cdn.jsdelivr.net is denied by this container's proxy; Wasmer's builder presumably has internet). BUILD FAILED.
- Independently of that, the partial output shows what the root build produces: 24 files — `index.html` with an empty `<title>`, `categories/`, `tags/`, `404.html`, favicons, CSS/JS; `/docs/` → 404. Even with network, the button would deploy an empty theme shell, not the Hextra docs.

## Verdict: HOLD
The root is a theme, and Anybuild's Hugo rule always builds the root with no `--source`/`--themesDir` option, so the deployed app would be an empty site. No minimal README/Staticfile change fixes this (a Staticfile cannot build; changing the root theme `hugo.toml` to point at `docs/` would alter the theme's module config, which is not acceptable in a theme repo). No patch produced.

Suggested replacement: **imfing/hextra-starter-template** (the README's recommended starting point) — but it uses Hugo Modules (`go.mod`), which needs the `go` binary at build time; Anybuild's Hugo build has none (see 42-CaiJimmy__hugo-theme-stack-starter: `failed to download modules: binary with name "go" not found in PATH`). Check before proposing.
