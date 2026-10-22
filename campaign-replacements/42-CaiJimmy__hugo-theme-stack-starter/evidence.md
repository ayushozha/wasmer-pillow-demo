# CaiJimmy/hugo-theme-stack-starter — evidence

- Pinned SHA: `457a70dd24e2de8ab5ed88e414f5d3a87a7fa8a2` (branch `master`); clone `$S/rup/CaiJimmy__hugo-theme-stack-starter`.
- Stars / forks: 598 / 179 (GitHub API, 2026-10-22). Not archived.
- License: MIT ("Copyright (c) 2021 Jimmy Cai"). No CONTRIBUTING / AGENTS / PR template; workflows `deploy.yml` (GitHub Pages) and `update-theme.yml` (daily theme bump).
- Recent merged PRs: `is:merged merged:>2025-10-01` → 1 (#84). Prior deploy PRs: #16, #21, #77 (all GitHub Pages workflow, closed). Duplicate `wasmer` → 0.
- README: "Deploy to another static page hostings — Check official Hugo documentation".
- Site layout: config in `config/_default/*.toml` (no root `hugo.toml`/`config.toml`), theme imported as a **Hugo Module** (`config/_default/module.toml` imports `github.com/CaiJimmy/hugo-theme-stack/v4`; `go.mod` requires v4.0.3). `deploy.yml` uses Hugo extended (`HUGO_VERSION: 0.154.2`, setup action `latest`), Go, and Dart Sass 1.97.1.

## Anybuild v0.33.0 — three independent blockers (all reproduced)
1. **Detection fails.** `anybuild plan` on the unpatched tree: `Error: plan failed ... No Go build file was found ... Set ANYBUILD_GO_BUILD_FILE or add a supported Go entrypoint`. Hugo detection (`providers/hugo.rs:179-193`) needs a root `hugo.*`, or `config.*` + `content/` + `static/`|`themes/`; this repo has none at root, so `go.mod` makes the Go provider (score 80, `mod.rs:441-443`) win and then fail. Adding an empty root `hugo.toml` (diagnostic copy only, `$S/w8/stack`) does give "Detected Hugo provider, 0.153.2, public" (`plan_with_hugo_toml.json`).
2. **No Go toolchain in the Hugo build.** `hugo.bzl:11-21` only `use(dep("hugo"))`; docker backend maps it to `ubi:gohugoio/hugo[matching=extended]` (`build/docker.rs:49`). Replay of `hugo --gc --minify` with Hugo 0.153.2+extended and `go` removed from PATH: `ERROR failed to load modules: failed to download modules: binary with name "go" not found in PATH`.
3. **Hugo too old for the theme.** With Go present (deviation, diagnostic only), modules download but rendering fails: `executing "home.html" at <.Site.Language.Locale>: can't evaluate field Locale in type *langs.Language`. The theme's `config/_default/module.toml` declares `[hugoVersion] extended = true, min = "0.157.0"`; Anybuild pins 0.153.2 (`hugo.rs:143-149`; override only via the `hugo_version` env, not repo files).
- Dart Sass: the theme compiles SCSS with `toCSS` (libsass in Hugo extended works by default); the workflow installs Dart Sass, but whether it is required could not be tested because the build stops at blocker 2/3. Hugo used: v0.153.2+extended built from source (`go install -tags extended github.com/gohugoio/hugo@v0.153.2`).

## Verdict: HOLD
Not deployable by Anybuild v0.33.0 without builder changes (Go in the Hugo image, Hugo ≥ 0.157 extended, and either root-config detection or a `hugo.toml`). No patch produced; adding a root `hugo.toml` alone would still fail at blocker 2.
