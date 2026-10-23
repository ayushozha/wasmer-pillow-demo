<a href="https://wasmer.io/apps/create?github=Bowen7%2Fregex-vis"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" height="48"></a>

## Summary

Adds a short "Deploy on Wasmer" section to the README, before "Contribution Guide", with a Deploy to Wasmer badge and one sentence on what the deployment does. No application code, build configuration or dependency changes.

Disclosure: I work at Wasmer. I prepared this change with help from Claude, an AI assistant, and reviewed and tested it before opening this PR.

The button opens Wasmer's import page for this public repository, where you review the detected build settings and click Deploy; it does not create a copy of the repository in your GitHub account. To customize the site and redeploy on changes, fork the repository and import your fork instead.

## Why this repo

Regex Vis is a Vite single-page app that builds to static files in `dist`. Its main view is `/`, and the regex being visualized lives in the query string (`/?r=...`), so shared links and reloads of the main view work on a plain static file server. The repository already ships a `Dockerfile` and a `vercel.json`; this adds a one-click option that uses the existing `pnpm run build`.

## Testing

Local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `a6d920601ca44ab2d4e9cd02306510ab6d5e4b38` (current `main`) with this change applied:

- Detection: static Node.js provider, framework Vite, package manager pnpm, output directory `dist`.
- `pnpm install` (Node 24.22.1, pnpm 10.34.7, with `package.json` and `pnpm-lock.yaml` staged) exited 0.
- `pnpm run build` (`tsc && vite build`) exited 0 and produced 12 files.
- `pnpm test` (as CONTRIBUTING.md asks, run with `CI=true`): 18 test files, 53 tests passed, exit 0.
- The output was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).
- `/`, `/?r=%2F%5Ba-z%5D%2B%2F` and `/index.html` returned 200 with the title "Regex Vis". All 12 built files returned 200 with the expected content types (JS, CSS, `favicon.png`, `logo.svg`, `manifest.json`, `robots.txt` and the five `locales/*/translation.json` files).
- In headless Chromium (Playwright 1.56.1), with every request outside the local server blocked: a direct load of `/?r=/[a-z]+\d{2,}/` filled the input and drew the graph; typing `a|b+` on `/` updated the URL to `/?r=a%7Cb%2B`, and reloading that URL restored it; the header "Samples" link opened the samples page in the app (12 sample links), and clicking a sample opened it on `/?r=...`.

## Limitations

- No deployment was made. The import page and the badge image were not opened from the test environment.
- Deep links: the app uses `BrowserRouter` with routes `/` and `/samples` (`/playground` exists only in development). On a static server without a rewrite, reloading or directly opening `/samples` returns 404 (also `/samples/`); only in-app navigation to it works. The main editor at `/` and `/?r=...` is not affected. `vercel.json` rewrites all paths to `/` for the Vercel deployment; this PR deliberately adds no equivalent fallback for Wasmer.
- Analytics: the production `index.html` includes the Cloudflare Web Analytics beacon with this repository's token (`f684c9449da14b2396a0a944c9acb39f`), and the build keeps it. A copy deployed with this button would report visits to the same Cloudflare Web Analytics account unless the deployer removes or replaces it. This PR does not change it. In the browser test the beacon (static.cloudflareinsights.com) was blocked and the app worked normally.
- Maintainer activity: the last commit on `main` is from 2026-05-06, so review timing is uncertain.
