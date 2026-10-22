# aradzie/keybr.com: evidence

**Verdict: HOLD (not a static app).** keybr.com is a full-stack Node application (npm workspaces with ~70 packages including `server`, `keybr-database`, `keybr-oauth`, `keybr-multiplayer-server`, `page-account`, `page-highscores`). Anybuild v0.33.0 (`plan.txt`) detects the **Node.js provider** (not static), `node_install_requires_all_files: true`, build `npm run build` (webpack), start `env NODE_ENV=development node --enable-source-maps ./root/index.js` (from the repo's `start` script, a development-mode server). The project ships a Dockerfile and docker-compose for self-hosting.

A static one-click deploy does not fit, and the generated start command runs the server in development mode. Out of scope for this browser-app lane (needs a server runtime and database configuration).

## Repository
- Pinned SHA: `05a37bc5265f65ff538c59c613db29442f345d51` on `master`, 2026-09-28.
- Stars / forks: 4,804 / 479; AGPL-3.0 (GitHub API, 2026-10-22).
- README "Can I contribute?": "Yes!", with links to bug reports, translations and getting-started docs; root `AGENTS.md` gives build/test guidance for coding agents (no prohibition on agent PRs found in the first lines read).
- No build was replayed.
