# yulimchen/vue3-h5-template: evidence

**Verdict: READY** (README-only patch; replay passes). Note for coordinator: this is a hash-router app (a lead you assigned, not self-found). If the hash-router lane owns it, hand this folder over rather than duplicating.

## Repository
- Pinned SHA: `95816e6001f6039782166c4299e485884d73fab2` on `master` (default branch). Last push 2026-06-09; not archived.
- Stars / forks: 1,549 / 342 (GitHub API, 2026-10-22). GitHub "template repository": yes.
- License: MIT ("The MIT License (MIT) Copyright © 2021 yulimchen").
- No CONTRIBUTING, PR template, AGENTS/CLAUDE files or AI policy. `.github/` holds only `workflows/main.yml` (GitHub Pages deploy). No bad-PR bot.
- Merged PRs since 2025-10-01: 1 (#78, 2025-11-09). The maintainer mostly commits directly; low PR throughput is the main risk.
- Duplicate `wasmer` PR search: 0. `deploy in:title` PR search: 0.
- Existing deploy docs: README links the GitHub Pages demo; the workflow builds with `pnpm install` + `pnpm build` and rewrites `VITE_PUBLIC_PATH` to `/vue3-h5-template/` for Pages. Root deploy (Wasmer) needs no rewrite: `.env.production` has `VITE_PUBLIC_PATH = "/"`.

## Anybuild detection (v0.33.0)
- Provider: node-static, framework Vite, package manager pnpm (`pnpm-lock.yaml`; plan pins pnpm 10), output `dist` (`plan.txt`).
- `node_install_requires_all_files: true` (the whole tree is copied before install, `node.bzl:111-112`), so the `prepare: husky install` script runs; it prints ".git can't be found" and exits 0.
- No `pnpm-workspace.yaml`, so the staged-install catalog gap does not apply.
- Router: `createWebHashHistory()` (`src/router/index.ts:10`), so no SPA fallback is needed.

## Replay (patched clone, Node 24.22.1, pnpm 10.34.7)
- `pnpm install` exit 0; `pnpm run build` (`vite build` then `vue-tsc --noEmit`) exit 0; 38 files in `static_app`.
- Smoke: `/`, `/#/tools`, `/#/about` 200 (title "vue3-h5-template"); all 3 referenced assets 200. failures=0.
- Observed: pnpm printed "Ignored build scripts: rs-module-lexer@2.6.0, vue-demi@0.14.10" although the replay exported `pnpm_config_dangerously_allow_all_builds=true` (node.bzl:123). Build output was unaffected. Reported to coordinator as a builder observation, not a repo problem.

## Limitations
- The "tools" demo page calls mock APIs (`mock/list.mock.ts`) served only by the dev-server plugin; in any static deployment (including the maintainer's GitHub Pages demo) those requests fail. README sentence says so.
- Working copy shows `CHANGELOG.md` modified only because it is committed with CRLF and `.gitattributes` forces LF; it is excluded from the patch (`git diff -- README.md`).

## Remaining check for the reviewer
- Verify badge and import page in a browser (img.shields.io / wasmer.io blocked here).
