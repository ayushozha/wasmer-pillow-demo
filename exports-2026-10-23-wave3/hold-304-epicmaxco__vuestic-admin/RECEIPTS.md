# 304 epicmaxco/vuestic-admin: HOLD (2026-10-23)

## Source
- Fresh `git clone --filter=blob:none -b develop`. `develop` HEAD `ba93fc3f1c8531102bce7492314eb77653b32691` (2025-09-01), matches the pin. `master` is `9c5b44f3` (policy-files.txt).
- No export made, so there is no upstream.patch.

## Policy (policy-files.txt)
- CONTRIBUTING: "Do not submit PRs against the `master` branch." and "create PR against upstream `develop`". A PR would target `develop`. It also says to use yarn and to add before/after screenshots for visual changes.
- COMMIT_CONVENTION: titles must match `(feat|fix|docs|style|refactor|test|ci|chore)(\(.+\))?: .{1,70}`.
- The PR template has Description / Markup / Types of changes sections.
- No AGENTS.md, CLAUDE.md, `.cursorrules`, copilot instructions, CLA workflow or AI/agent-PR rule. The only grep hit is a binary png.
- No lint/test command was run as a policy requirement. The diagnostic build below ran the repo's `build` script, which includes `format` + `lint` + `vue-tsc`.

## Duplicates (duplicate-check.txt)
- 481 PR refs (all states). `--grep=wasmer`: none. `--author=wasmer/ayush`: none. README.md wasmer hits: 0 of 481.

## Controlling facts (why HOLD)
1. **Anybuild 0.33.0 cannot plan HEAD** (plan-head.txt). The repo's root `_redirects` holds `/*  /index.html  200`, a maintainer SPA catch-all, and `anybuild plan --wasmer` fails with "redirect status 200 is not supported by static-web-server" (exit 1). `--env ANYBUILD_STATIC_CONVERT_REDIRECTS=false` fails the same way. A committed `Anybuild` with `static_convert_redirects = False` also fails ("loading node-static config"). It plans only once `_redirects` is removed, because node_static.rs `load_static_parts` runs `compute_redirects_config` before the file's kwargs apply. So any fix must delete a maintainer-owned file. That file is probably unused by Netlify, since `netlify.toml` already has the same `/*` rule and `publish = "dist"`, but this was not verified.
2. **History router with no acceptable static fallback.** `createWebHistory`, with 13 sidebar destinations: dashboard, users, projects, 3 payments pages, faq, settings, preferences, auth login/signup/recover-password, 404. In the diagnostic build, `/` is 200 and every one of those paths is 404 on direct load or reload (diag-http-receipts.txt). The maintainers' own config is a catch-all, which is not allowed here. A small literal set (e.g. `/dashboard`, `/auth/login`) does not cover the primary flows: every admin page would still 404 on reload. Covering them means mirroring the whole route table (14 rewrites) in our file, which goes beyond "small" and drifts with every new route.
3. Runtime gap: Users and Projects fetch `${VITE_API_BASE_URL}/users…`. That variable is unset in the repo, so it compiles to `void 0` and the requests go to `/undefined/users…`, which is 404 (diag-http-receipts.txt). These pages need an external API the repo does not configure.

## Diagnostic replay (HEAD minus `_redirects`, not a proposal; diag-*.txt)
- Plan: static Node.js provider (Vite), yarn, `yarn install` / `yarn run build`, output `dist`. `node_install_requires_all_files: true` because of `workspaces: ["e2e"]`, so the whole tree, including `.yarnrc.yml` (`nodeLinker: node-modules`), is staged before install. The "`.yarnrc.yml` not staged" concern therefore does not apply to this repo. `yarn_version` is left floating (node.rs test: "yarn 1 pin cannot run the Berry-only commands").
- Yarn 4.9.2 (the `packageManager` pin), Node 24.22.1: `yarn install` exit=0 (1097 packages, peer warnings). `yarn run build` exit=0. That script is `npm run lint && vue-tsc --noEmit && vite build`, with prelint `prettier --write .` and eslint `--fix`. This differs from Netlify's `build:ci` (`vite build` only). It produced 81 files, built with Vite 5.4.19.
- Yarn 1.22.22 (if the floating dep resolved to classic): `yarn install` exit=1, "packageManager yarn@4.9.2 … Corepack must currently be enabled" (yarn-classic-check.txt).
- HTTP (diag-http-receipts.txt): 8 x 200 (`/`, `/index.html`, JS, CSS, 3 icon fonts, favicon) and 19 x 404. The 404s are 13 routes, `/does-not-exist`, `/_redirects`, `/package.json`, 2 API probes, and the unhashed legacy `/assets/vuestic-icons.eot` CSS ref.

## Verdict: HOLD
- Exact reason: Anybuild 0.33.0 hard-fails on the repo's `_redirects` (status 200 unsupported, with no config/env override), and the history-mode admin needs a catch-all for its primary flows (13 sidebar routes 404 on reload). A literal-route set would have to mirror the whole router, and a catch-all is disallowed.
- What would unblock it: Anybuild accepting `200` rewrites from `_redirects` (or honouring `static_convert_redirects=False` before parsing), plus an accepted SPA-fallback policy. Alternatively, the maintainers switch to `createWebHashHistory`, which is their call, not ours.
