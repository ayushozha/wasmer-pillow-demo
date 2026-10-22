# minimal-ui-kit/material-kit-react (replacement 52) — HOLD

- Pinned `69e780a40c455d664b2e13c525faf1d492a072a7` (main); 2,783 stars / 1,815 forks (GitHub API 2026-10-22); MIT.
- Anybuild v0.33.0 plan: static Node.js provider, Vite, `yarn install` / `yarn run build`, output `dist` (both `package-lock.json` and `yarn.lock` present; yarn chosen).
- Replay (unpatched): install/build exit 0, `/` 200 with JS/CSS assets 200. History-routed deep links `/user`, `/products`, `/blog`, `/sign-in`, `/404` → **404** under static-web-server 2.38.0.
- The repo relies on `vercel.json` `rewrites: /(.*) → /` for SPA fallback. Anybuild only converts `_redirects` files with 301/302 rules into static-web-server redirects (`providers/staticfile.rs:293-330`, `REDIRECT_STATUS_CODES = [301, 302]`); there is no 200 rewrite / SPA fallback, so reloads and shared links to any page other than `/` break.

## Verdict: HOLD
Reason: deep links/reloads 404 on Wasmer's static serving; no in-repo fix without changing the app's router (out of scope). Unhold if Anybuild/static-web-server gains an SPA fallback option the repo can declare.
