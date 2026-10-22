# themeselection/sneat-bootstrap-html-admin-template-free: evidence

**Verdict: CONDITIONAL.** The replay passes with a README patch plus a one-line root `Staticfile` (`root: .`). There are two conditions. First, maintainers must accept the extra file. Second, this repo has never merged an external PR: only 3 member-authored branch-merge PRs, and the one outside PR (#4, a README edit from 2022) is still open.

## Repository
- Pinned SHA: `de094c2bf89e602054b7c14f46c9a3a5b9f6cac9` on `main` (default). Last commit 2026-03-20 ("fix(readme): update demo screenshot"); not archived.
- Stars / forks: 1,243 / 283 (GitHub API, 2026-10-22).
- License: `LICENSE` MIT ("Copyright (c) 2022 ThemeSelection"); `LICENSE.md` MIT (2021). README "License": "All our free items are Open Source and licensed under MIT ... We just need an attribution from your end." The template's footer attribution stays intact because the demo is served unmodified.
- README "Contributing": "Contributions are always welcome and recommended! ... Create a pull request". Contribution requirements: a non-exclusive license grant to ThemeSelection, and "Contributions are only accepted through Github pull requests." No AI policy and no PR template.
- Workflows: `handle-new-issue.yml` (potential-duplicates bot on issues), `handle-new-issue-comment.yml` (awaiting-reply label), `issue-staler.yml`. None act on PRs.
- PR history (4 total): #26, #36, #39 are MEMBER branch merges (latest 2025-02-25); #4 "Update README.md" (outside contributor, 2022) is open and unmerged. Merged since 2025-10-01: 0. No deploy-button or provider PRs; duplicate `wasmer` search: 0.
- Existing deploy docs: none. The README covers Gulp/browser-sync dev tasks and a "View Demo" link.

## Anybuild detection (v0.33.0)
- **Unpatched** (`plan_unpatched.json`): Node.js *server* provider, yarn, `yarn install` + `yarn run build` (`npx gulp build`), and "Warning: no start or main script found in package.json". There is no start command, so that deployment would not serve the site.
- **Patched with root `Staticfile` (`root: .`)**: StaticFile provider, "Output directory: .", no install/build. static-web-server serves the committed files (`plan.txt`). The README says Node/Gulp are "totally optional", and the committed `assets/`, `html/`, `fonts/` and `libs/` are what the hosted demo uses.
- Layout: root `index.html` is a small landing page linking to `html/index.html` (the dashboard). `html/*.html` use `../assets/`. `documentation.html` is a meta-refresh to the vendor's hosted docs.

## Replay (patched clone)
- Copy `.` → `static_app` exit 0.
- Smoke: `/`, `/html/`, `/html/index.html`, `/html/auth-login-basic.html`, `/html/cards-basic.html`, `/html/form-layouts-vertical.html`, `/html/tables-basic.html`, `/documentation.html` all 200 with the expected titles. 49 refs from `/` returned 200.
- Supplementary full check: every local `href`/`src` in every HTML file under `static_app` (115 unique URLs) returned 200, with 0 failures (appended to `replay.log`).
- Auth pages are demo screens only: the login form is `<form ... action="index.html">` (`html/auth-login-basic.html:125`), so there is no real sign-in. README and PR body say so.
- With `root: .`, repository source files (`package.json`, `gulpfile.js`, `scss/`, `tasks/`) are also publicly reachable. They are already public on GitHub, so this is not sensitive.

## Remaining check for the reviewer
- Verify badge and import page in a browser (img.shields.io / wasmer.io blocked here).
- Accept the low likelihood of an external merge, or skip.
