# iib0011/omni-tools: evidence (triage; no patch prepared)

**Verdict: HOLD (history-router deep links).** It is a React `BrowserRouter` app, and every tool is its own path (for example `string/base64` and `pdf/merge-pdf`; route config in `src/config/routesConfig.tsx`). The static host has no SPA fallback: Anybuild serves with a local native static-web-server 2.38.0, and Wasmer's hosted WASI static-web-server has no page-fallback option. Reloading or sharing any tool URL would 404, and tool pages are the main use.

## Facts
- Pinned SHA: `32db77fd8d58fe13acb25f9002550fb79d137da8` on `main` (2026-10-21). Stars / forks: 10,341 / 729 (GitHub API, 2026-10-22). License: MIT.
- Anybuild: static Node.js, Vite, npm. Output `dist` (plan.txt). The repo also contains a `pnpm-lock.yaml`, but Anybuild picked npm.
- Not replayed. Duplicate `wasmer` PRs: 0.
