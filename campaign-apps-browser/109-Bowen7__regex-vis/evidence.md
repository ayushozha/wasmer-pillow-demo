# Bowen7/regex-vis: evidence

**Verdict: CONDITIONAL.** The build and smoke pass, and the main use is the single URL `/`. The regex lives in the query string (`/?r=...`; `SEARCH_PARAM_REGEX = 'r'`, `src/constants/index.ts:44`), and that URL loads fine. There are three caveats for the reviewer:
1. **Reloading `/samples` returns 404.** It is a secondary page, linked from the header (`src/components/header/index.tsx:32`). The app uses `react-router-dom` `<Routes>` with paths `/` and `/samples`; `/playground` is dev only.
2. **Upstream analytics.** The production `index.html` includes the Cloudflare Web Analytics beacon with the maintainer's token (`f684c9449da14b2396a0a944c9acb39f`; `index.html` inside `<% if (!isDev) %>`). Deployed copies would report to it.
3. **Old dependencies** are shipped to the browser (see Security).

## Repository
- Pinned SHA: `a6d920601ca44ab2d4e9cd02306510ab6d5e4b38` on `main`. The last commit is 2026-05-06.
- Stars / forks: 4,449 / 332. Not archived (GitHub API, 2026-10-22).
- License: MIT ("Copyright (c) 2021 Bowen").
- `.github/CONTRIBUTING.md`, "Open a PR": "Fork this project to your own account. Checkout to a new branch. Run `pnpm install`... Run `pnpm test`. Make sure to pass all test cases. Submit your code." There is no issue-first rule, no AI policy and no PR template. Workflows: `test.yml` only.
- Merged PRs since 2025-10-01: 3, all outside contributors (translations and a fix). Older external PRs were also merged: Docker (#124, #157), localizations, and a samples page (#156).
- Duplicate `wasmer` PRs: 0. Prior deploy-button PRs: none. A "deploy" search returns only dependabot and feature PRs. Existing deploy docs: `Dockerfile` (runs `pnpm start`, the dev server) and `vercel.json` (rewrite all to `/`).

## Anybuild detection (v0.33.0)
- Provider: static Node.js; framework Vite; pnpm (`pnpm-lock.yaml`, no `packageManager` field). The replay ran pnpm 10.34.7. Output dir: `dist`.
- Staged before install: `package.json` and `pnpm-lock.yaml`. There is no `pnpm-workspace.yaml`. Env: `CI=true pnpm_config_minimum_release_age=0 pnpm_config_dangerously_allow_all_builds=true pnpm_config_strict_dep_builds=false`.
- Commands: `pnpm install`, then `pnpm run build` (`tsc && vite build`), then `static-web-server --root=/opt/static_app --log-level=info --port=8080`. There is no `_redirects` file.

## Replay (patched clone, Node 24.22.1, pnpm 10.34.7)
- `pnpm install` exited 0. `pnpm run build` exited 0.
- The output was served with a local native static-web-server 2.38.0, the version Anybuild's plan pins. Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here.
- Smoke results:
  - `/` and `/?r=%2F%5Ba-z%5D%2B%2F` returned 200 ("Regex Vis").
  - `assets/index-DYMSwI23.js` (740 KB) and `assets/index-BChK14_K.css` returned 200.
  - `favicon.png`, `logo.svg`, `manifest.json` and `robots.txt` returned 200.
  - The i18n files `locales/fr/translation.json` and `locales/jp/translation.json` returned 200.
  - `/samples` returned **404** on a direct load; `/nope` returned 404.
- Not exercised in a browser.

## Env vars
- `vite.config.ts` defines a global `SENTRY_DSN` from `process.env.SENTRY_DSN`, but `src/index.tsx:8` reads `import.meta.env.SENTRY_DSN`. Vite only exposes `VITE_*` there, so Sentry does not initialise in this build. Nothing else is read. The core needs no variables.

## Security (shipped code)
- `pnpm audit --prod`: 0 critical, 25 high, 32 moderate, 7 low. Most are in build tooling that this repo lists under `dependencies` (vite, rollup, postcss, minimatch, braces, glob, etc.) and are not shipped.
- Shipped to the browser:
  - react-router-dom 6.24.1 / @remix-run/router. These have open-redirect advisories; the app has no loaders or redirects from untrusted paths, only two static `<Route>`s.
  - nanoid 3.3.7 (DoS advisories for non-integer or negative sizes; the app calls `nanoid()` with no arguments).
  - i18next-http-backend 1.4.5 (path traversal and URL injection via unsanitised `lng`; it fetches only same-origin `/locales/...`).
  - @sentry/react 8.17.0, inactive (see above).
- No critical advisories. The applicable risk looks low, but the dependencies are dated.

## Remaining check for the reviewer
- Accept or reject the `/samples` reload 404 and the upstream Cloudflare beacon. Both are disclosed in the PR text.
- Verify the badge and import page in a browser (blocked here).
