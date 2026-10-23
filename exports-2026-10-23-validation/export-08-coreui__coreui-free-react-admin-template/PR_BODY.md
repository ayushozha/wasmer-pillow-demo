<a href="https://wasmer.io/apps/create?github=coreui%2Fcoreui-free-react-admin-template"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" width="328" height="48"></a>

Disclosure: I work at Wasmer. I prepared this change with help from Claude, an AI assistant, and reviewed and tested it before opening this PR.

## Summary

Adds a short "Deploy on Wasmer" subsection after the README's Build instructions, plus a one-line root `Staticfile` (`root: build`). No application code changes.


## Why this repo

This template is a common starting point for React/Vite admin dashboards. People evaluating it often want a running instance they can click through or share with a team before they adopt it, and the README currently documents only the local `npm run build`.

What is specific to the React template (and why the Vue PR does not cover it):

- Build output directory: this repo's `vite.config.mjs` sets `build.outDir: 'build'`. Wasmer's builder (Anybuild) does not read Vite's `outDir` and assumes Vite's default `dist`, so without a hint the deployment would look for a folder that does not exist. The one-line `Staticfile` (`root: build`) only names the output folder; Wasmer still detects the Vite app and runs `npm install` and `npm run build`.
- Routing: the app uses React Router's `HashRouter` (`src/App.jsx`) and `base: './'`, so every in-app URL (`/#/dashboard`, `/#/login`, `/#/register`) loads `index.html` from `/`. That means it works on a plain static file server with no rewrite or SPA-fallback configuration, and reloading or sharing a deep link keeps working.

The button opens Wasmer's import page for this public repository, where you review the detected build settings and click Deploy; it does not create a copy of the repository in your GitHub account. To customize the site and redeploy on changes, fork the repository and import your fork instead.

## Testing

Local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `2609f5995035973e00c16ec723165a5fff87cceb` (current `main`) with this change applied:

- Detection: static Node.js provider, framework Vite, package manager npm, output directory `build` (without the `Staticfile` the plan says `dist`).
- `npm install` (Node 24.22.1, npm 11.21.1, with `package.json` and `package-lock.json` staged) exited 0.
- `npm run build` exited 0 and produced 107 files.
- The output was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).
- `/`, `/#/dashboard`, `/#/login` and `/#/register` returned 200 with the title "CoreUI Free React.js Admin Template".
- All 107 built files (90 JS chunks, 2 CSS, images, `manifest.json`, `favicon.ico`) returned 200 with the expected content types, including all 25 lazy-loaded chunks referenced from the entry bundle.
- Path URLs such as `/dashboard` return 404, as expected for a hash-routed app; the app's own links all use `/#/...`.
- `npm audit --omit=dev`: 0 vulnerabilities in the dependencies shipped to the browser.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- The extra root file exists only for Wasmer's output-directory detection and does not affect local development.
