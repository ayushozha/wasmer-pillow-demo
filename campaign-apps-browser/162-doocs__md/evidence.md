# doocs/md: evidence

**Verdict: HOLD (monorepo, no static detection).** The editor lives in the `apps/web` pnpm workspace package (Vite and Vue). Anybuild v0.33.0 sees the root `package.json`, which has no `build` script and no static framework dependency at the root. It therefore picks the **Node.js provider** (not node-static), with:
- install `pnpm install`, with all files staged because of the workspace;
- build `None`;
- start `pnpm web dev`, the Vite **dev server** (see `plan.txt`).

A one-click deploy would run a development server instead of a static build. Fixing this needs a root `build` script or app-subdir configuration, which is a repo or builder change rather than a README change.

## Repository
- Pinned SHA: `0bbfe56b67d7683ad4503e7a7690af277c99c5fe` on `main`, dated 2026-10-21.
- Stars / forks: 13,451 / 2,249. Last push 2026-10-21 (GitHub API, 2026-10-22).
- License: WTFPL.
- The repo has `CONTRIBUTING.md`, a PR template, `AGENTS.md`/`CLAUDE.md` and Cloudflare/Surge preview workflows. The policy files were not evaluated further, because the target is held on detection.
- Root scripts include `"start": "pnpm web dev"` and `"web": "pnpm --filter @md/web"`. There is no root `build`.
- No replay was run; the plan alone is decisive.
