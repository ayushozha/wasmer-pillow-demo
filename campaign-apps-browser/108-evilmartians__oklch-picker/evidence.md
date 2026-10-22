# evilmartians/oklch-picker: evidence (triage; no patch prepared)

**Verdict: HOLD (fit/privacy).** It builds and serves cleanly under the Anybuild replay, but I don't recommend a deploy-button PR:
- **Upstream analytics in every production build.** `view/analytics/index.ts` sets `if (process.env.NODE_ENV === 'production')` and then `new Plausible({ apiHost: 'https://plausible.io', domain: COLOR_FN === 'oklch' ? 'oklch.com' : 'lch.oklch.com' })` and `trackEvent('pageview')`. Every Wasmer-deployed copy would send page views attributed to oklch.com to the maintainers' Plausible account, and the user cannot turn this off.
- **Weak self-hosting case.** This is a small color picker that its maintainer company runs as the canonical site (oklch.com; the deploy history moved to Cloudflare Pages in #173). The README has only "Development" instructions and no self-hosting section. A third-party deploy button would add little for users and would mostly pollute upstream analytics.

## Repository
- Pinned SHA: `8b3b727a3108ee931a91ef9bb328ef5224b02936` on `main` (2026-10-05). Stars / forks: 2,012 / 123. License: MIT.
- No CONTRIBUTING or PR template. Workflows: `ci.yml` (pnpm 12, Node 26, `pnpm install --ignore-scripts`) and PR preview deploys. Merged PRs since 2025-10-01: 17. Duplicate `wasmer` PRs: 0.

## Replay (unpatched triage run; Node 24.22.1, pnpm 10.34.7)
- Static Node.js, Vite, pnpm. Output `dist`. Staged: `package.json` and `pnpm-lock.yaml`. `pnpm-workspace.yaml`, which holds only `allowBuilds: simple-git-hooks: true`, was not staged and was not needed.
- `pnpm install` and `pnpm run build` (`vite build -m production`) both exited 0.
- On a local native static-web-server 2.38.0, `/` and all 9 referenced assets returned 200: fonts, SVG icons, `oklch.webmanifest`, `index-*.js` and `index-*.css`. The color is kept in the URL fragment, which never reaches the server.
