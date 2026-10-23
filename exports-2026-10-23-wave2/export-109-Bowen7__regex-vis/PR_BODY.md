<a href="https://wasmer.io/apps/create?github=Bowen7%2Fregex-vis"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" width="328" height="48"></a>

## Summary

This PR adds a short "Deploy on Wasmer" section to the README, before "Contribution Guide". It also adds an `Anybuild` file, which is Wasmer's build and serve configuration. No application code, build script or dependency changes.

The `Anybuild` file keeps the settings Wasmer would detect anyway: pnpm, Vite, `pnpm run build`, serving `dist`. It adds two literal rewrites, `/samples` and `/samples/`, to `/index.html`. `/samples` is a `BrowserRouter` route linked from the header. Without the rewrites, opening or reloading it on a static server returns 404. There is deliberately no catch-all, so unknown paths and missing assets still return 404.

Disclosure: I work at Wasmer. I prepared this change with help from Claude, an AI assistant, and reviewed and tested it before opening this PR.

The button opens Wasmer's import page for this public repository, where you review the detected build settings and click Deploy; it does not create a copy of the repository in your GitHub account. To customize the site and redeploy on changes, fork the repository and import your fork instead.

## Why this repo

Regex Vis is a Vite single-page app that builds to static files in `dist`. People use it to read, edit and test regular expressions. Hosting your own copy gives a team a private URL for regex work, without depending on the public instance. The repository already ships a `Dockerfile` and a `vercel.json`; this adds a one-click option that uses the existing `pnpm run build`.

## Testing

I replayed locally what Wasmer's builder, Anybuild v0.33.0, does with the committed `Anybuild` file. Base: `a6d920601ca44ab2d4e9cd02306510ab6d5e4b38` (current `main`) with this change applied.

Build:
- The plan used the static Node.js provider with pnpm and served `dist`. Its start command includes `--config-file` for the generated rewrites.
- `pnpm install` (Node 24.22.1, pnpm 10.34.7) exited 0.
- `pnpm run build` exited 0 and produced 12 files.
- `pnpm test`, which CONTRIBUTING.md asks for: 18 test files, 53 tests passed, exit 0.

Serving:
- The output was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here). It used the generated `sws.toml`.
- These paths returned 200 with the app page: `/`, `/samples`, `/samples/`, `/?r=...`, `/samples?x=1` and `/samples/?x=1`, plus HEAD requests on `/samples` and `/samples/`.
- All 12 built files returned 200 with the expected content types.
- These paths returned 404: `/definitely-missing-x9`, `/definitely/missing/deep`, `/samples/extra`, `/samplesx`, `/playground`, `/assets/missing.js`, `/missing.css`, `/missing.wasm` and `/samples/assets/x.js`.

In headless Chromium (Playwright 1.56.1), with every request outside the local server blocked:
- Opening `/samples` and `/samples/` directly, and reloading while on `/samples`, showed the samples page with 12 sample links. Clicking a sample opened it on `/?r=...`.
- A direct load of `/?r=/[a-z]+\d{2,}/` drew the graph.
- Typing `a|b+` updated the URL, and reloading that URL restored it.
- `/playground` and an unknown path returned 404.

## Limitations

- No deployment was made. The import page and the badge image were not opened from the test environment.
- The rewrites cover only `/samples` and `/samples/`. A route added to `src/routes.tsx` later would need its own entry. `/playground` exists only in development, so it stays 404.
- The app requests `/locales/en/translation.json`, which the repository does not ship (`public/locales` has cn, fr, jp, ru and tr). That request returns 404 here as it would on any static host. The English UI still rendered.
- Analytics: the production `index.html` includes the Cloudflare Web Analytics beacon with this repository's token (`f684c9449da14b2396a0a944c9acb39f`), and the build keeps it. A copy deployed with this button would report visits to the same Cloudflare Web Analytics account unless the deployer removes or replaces it. This PR does not change it. In the browser test the beacon was blocked and the app worked normally.
- Maintainer activity: the last commit on `main` is from 2026-05-06, so review timing is uncertain.
