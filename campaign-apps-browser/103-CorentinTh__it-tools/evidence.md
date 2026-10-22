# CorentinTh/it-tools: evidence (triage only; no patch prepared)

**Verdict: HOLD.** The app uses a history router (`src/router.ts`: `createWebHistory(config.app.baseUrl)`), and every tool lives on its own path (for example `/base64-string-converter`, from `src/tools/base64-string-converter/index.ts`). Under static-web-server 2.38.0 as Anybuild v0.33.0 starts it, there is no SPA fallback, so a reload or shared link to any tool returns 404. Tool pages are the main use, so this is not a single-URL app. The repo's own hosting adds fallbacks (`netlify.toml`, `vercel.json`, `nginx.conf`). Maintainer activity is also low.

## Repository
- Pinned SHA: `d505845f918e946ec300af7b36efc107e2f66e9e` on `main`. The last commit is 2026-02-12 ("chore(readme): remove sponsors section (#1733)").
- Stars / forks: 40,926 / 5,506. Not archived (GitHub API, 2026-10-22). License: GPL-3.0 (`LICENSE`).
- **Base branch.** `.github/PULL_REQUEST_TEMPLATE/pull_request_template.md` says "Submit the PR against the `dev` branch", but the default branch is `main`. The most recent merged PRs (#1733 on 2026-02-12, #1664 on 2025-10-10 and #1553 on 2025-04-06) were all merged into `main` (search `is:merged base:main`). The newest PR merged into `dev` is from 2023 (#268, 2023-03-08). The accepted base today is **`main`**; the template is stale.
- Merged PRs since 2025-10-01: 2, both maintainer README/sponsor chores.
- Prior deploy PRs: #1844 "Add repocloud deploy button" (open, not merged), #1394 "Add Helm Chart Deploy" (open), #443 "Netlify deployment support" (closed 2023). Duplicate `wasmer` PRs: 0.
- `.github/stale.yml` marks issues stale after 60 days and closes them 7 days later (issues only).

## Anybuild detection (v0.33.0)
- Static Node.js, Vite, pnpm (`packageManager: pnpm@9.11.0`). Output `dist`. Install inputs: `package.json` plus `pnpm-lock.yaml`. No `pnpm-workspace.yaml`. See plan.txt.
- Build script: `vue-tsc --noEmit && NODE_OPTIONS=--max_old_space_size=4096 vite build`. The script raises its own heap limit.
- Not replayed: the router blocker and inactivity decided it.
