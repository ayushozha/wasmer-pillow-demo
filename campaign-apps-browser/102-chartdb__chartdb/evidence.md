# chartdb/chartdb: evidence

**Verdict: HOLD.** There are two independent blockers:
1. **The build hits the Node heap limit in the faithful replay.** `npm run build` (`npm run lint && tsc -b && vite build`) aborted with exit 134 ("JavaScript heap out of memory"). That was Node 24.22.1's default heap here, about 2.2 GB. With `NODE_OPTIONS=--max-old-space-size=4096` (a diagnostic deviation, not what Anybuild runs) it built in about 3 minutes. Whether Wasmer's builder has enough default heap is unknown. Anybuild v0.33.0 sets no `NODE_OPTIONS` (no `max-old-space` anywhere in its resources).
2. **History-router reloads 404.** `createBrowserRouter` (`src/router.tsx:144`). When a saved diagram exists, the editor auto-navigates from `/` to `/diagrams/<id>` (`src/pages/editor-page/use-diagram-loader.tsx`, `navigate(\`/diagrams/${config.defaultDiagramId}\`)`). Create, open and import also navigate there. Reloading that URL on static-web-server 2.38.0, which has no SPA fallback, returns a bare 404. The repo's own nginx config uses `try_files $uri $uri/ /index.html`.

## Repository
- Pinned SHA: `c24936a402bb3e24b4858f05282d69a04fcfe25b` on `main`.
- Stars / forks: 23,011 / 1,504. Not archived (GitHub API, 2026-10-22).
- License: AGPL-3.0. A README PR is fine. Anyone hosting a modified version must offer its source to network users.
- **CLA required: signature required by the account owner, unresolved.** `.github/workflows/cla.yaml` runs contributor-assistant/github-action@v2.6.1 on every `pull_request_target` (opened/closed/synchronize). There is no path filter, and `allowlist:` is empty. Signatures are stored in `chartdb/cla-signatures`. Documentation-only changes are **not** exempt: `CLA.md` says "By submitting code, documentation, or any other materials (collectively, \"Contributions\")..." and grants ChartDB, Inc. "a perpetual, worldwide, non-exclusive, royalty-free, sublicensable license". I did not sign or accept anything. Whether the submitting account is already in the signatures file is unknown, because I have no API access to that repo. Even without the technical blockers, the verdict would be at most CONDITIONAL until the account owner decides on the CLA.
- `CONTRIBUTING.md`: "Fork the repository, create a branch from `main`, and focus on a single change... Open a pull request and clearly state what issue it addresses." There is no PR template and no AI policy.
- Merged PRs since 2025-10-01: 116. Duplicate `wasmer` PRs: 0. PRs with "deploy" in the title: 0.

## Anybuild detection (v0.33.0)
- Provider: static Node.js; framework Vite; npm (`package-lock.json`). Output dir: `dist`. Install inputs staged: `package.json` and `package-lock.json`. Env: `CI=true NPM_CONFIG_FUND=false`.
- Commands: `npm install`, then `npm run build`, then `static-web-server --root=/opt/static_app --log-level=info --port=8080`. There is no `_redirects` file.
- `.nvmrc` is ignored by Anybuild (Node 24 default; CI also uses 24.x).

## Replay (patched clone, Node 24.22.1, npm 11.21.1)
- `npm install` exited 0 (775 packages).
- `npm run build`: lint passed, then the build hit the heap limit (exit 134). BUILD FAILED, `dist` missing, smoke 8/8 fail.
- Diagnostic (appended to replay.log; npm 10.9.4 install from the first run, otherwise identical): with a 4 GB heap the build exited 0. Smoke on that output:
  - `/` returned 200 ("ChartDB - Create & Visualize Database Schema Diagrams").
  - The main JS and CSS, logos, `config.js`, `robots.txt` and `sitemap.xml` returned 200.
  - `/diagrams/abc123`, `/examples`, `/templates` and `/templates/featured` returned **404**.
  - The largest chunk is `code-editor-*.js` at 15.2 MB.

## Env vars and how AI is configured (from source)
- `src/lib/env.ts` reads `VITE_OPENAI_API_KEY`, `VITE_OPENAI_API_ENDPOINT`, `VITE_LLM_MODEL_NAME`, `VITE_IS_CHARTDB_IO`, `VITE_APP_URL`, `VITE_HOST_URL`, `VITE_HIDE_CHARTDB_CLOUD` and `VITE_DISABLE_ANALYTICS`. The last two can be overridden at runtime by `window.env`.
- AI ("AI-Powered Export" of DDL into another dialect) runs **in the browser**. `src/lib/data/sql-export/export-sql-script.ts` (~lines 723-800) reads `window.env.OPENAI_API_KEY ?? VITE_OPENAI_API_KEY`, and the same pattern for the endpoint and model. It then calls `createOpenAI({apiKey, baseUrl})` from `@ai-sdk/openai`, client-side. If both an endpoint and a model are set, it uses the custom endpoint; otherwise it needs a key. The default model in code is `gpt-4o-mini-2024-07-18`.
- **There is no backend or proxy in this repo.** The Docker path builds `VITE_*` into the bundle (Dockerfile writes `.env`). `default.conf.template` plus `entrypoint.sh` serve `/config.js` as `window.env = { OPENAI_API_KEY: "...", ... }`, so a runtime key is also delivered to every browser. The README documents `VITE_OPENAI_API_KEY=<YOUR_OPEN_AI_KEY> npm run build` and `docker run -e OPENAI_API_KEY=...`. Both expose the key publicly on any reachable deployment.
- Our README text tells users not to set `VITE_OPENAI_API_KEY` on a public deployment, and to use the existing "custom inference server" option with an endpoint that enforces its own access. That endpoint is also called from the browser, so it must handle CORS and auth itself. With all vars unset, diagram editing, import and export to the same dialect, and IndexedDB storage work. Cross-dialect AI export throws "Configuration Error" (`validateConfiguration`).
- `public/config.js` is empty in the repo, so `window.env` is undefined on a static host and only the build-time values apply.

## Security (shipped code)
- `npm audit --omit=dev`: 23 total (16 high, 3 moderate, 4 low, 0 critical).
  - Shipped to the browser: react-router 7.10.1. Its highs are mostly framework, SSR or RSC mode, which a client-only SPA doesn't use. "XSS via Open Redirects" (GHSA-2w69) and open-redirect moderates (<7.18.0) may apply to `<Link>`/`navigate`, and I did not analyse them in depth.
  - Also shipped: dompurify 3.2.7 via monaco-editor (moderate XSS advisories), lodash/lodash-es (`_.template`, prototype pollution), nanoid, and js-cookie via react-use.
  - Build-time only: tailwindcss, chokidar, braces, micromatch, postcss and source-map-js.
- No critical advisories in shipped code. A reviewer should still note that react-router <7.18 is shipped.

## Remaining check for the reviewer
- Both blockers need upstream or builder changes: a build memory setting, and an SPA fallback (or a `404.html` copy of `index.html`, which static-web-server serves with status 404 and which boots the app). Neither belongs in a README PR.
- If ever reconsidered: confirm Wasmer's builder heap, the account owner decides on the CLA (unresolved; never signed by us), and verify the badge and import page in a browser (blocked here).
