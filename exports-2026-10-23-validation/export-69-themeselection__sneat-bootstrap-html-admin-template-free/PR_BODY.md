<a href="https://wasmer.io/apps/create?github=themeselection%2Fsneat-bootstrap-html-admin-template-free"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" width="328" height="48"></a>

Disclosure: I work at Wasmer. I prepared this change with help from Claude, an AI assistant, and reviewed and tested it before opening this PR.

## Summary

Adds a short "Deploy on Wasmer" section to the README, before "What's Included", and a one-line root `Staticfile` (`root: .`) so Wasmer serves the committed demo as static files. No template files change.

## Why this repo

Sneat Free is used by developers who want a Bootstrap 5 admin UI they can show to a team or client before building on it. The README notes that Node, Webpack and Gulp are optional and that the committed files are usable as-is. A one-click deploy of those files gives people their own shareable copy of the demo (all `html/` pages, assets and fonts) without setting up the Gulp toolchain.

Why the `Staticfile` is needed: without it, Wasmer's builder sees `package.json` and picks the Node.js server provider, which runs `yarn install` and `yarn run build` and then has no start command, so nothing would be served. The one-line `Staticfile` tells it to serve the repository root as static files. It changes nothing for local development.

The button opens Wasmer's import page for this public repository, where you review the detected build settings and click Deploy; it does not create a copy of the repository in your GitHub account. To customize the site and redeploy on changes, fork the repository and import your fork instead.

## Testing

Local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `de094c2bf89e602054b7c14f46c9a3a5b9f6cac9` (current `main`) with this change applied:

- Detection: static site provider, output directory `.`, no install or build step.
- The files were served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).
- `/`, `/html/`, `/html/index.html`, `/html/auth-login-basic.html`, `/html/auth-register-basic.html`, `/html/cards-basic.html`, `/html/form-layouts-vertical.html`, `/html/tables-basic.html`, `/html/pages-misc-error.html` and `/documentation.html` returned 200 with the expected page titles.
- Every local `href`/`src` referenced from every HTML page, plus every `url()` in the referenced local CSS (115 unique URLs: HTML, CSS, JS, images), returned 200 with the expected content types.
- Unknown paths such as `/this-path-does-not-exist` return the server's 404.
- The browser libraries bundled in `assets/vendor` are built from the `yarn.lock` versions (Bootstrap 5.3.3, Popper 2.11.8, jQuery 3.7.1, ApexCharts 4.2.0, highlight.js 11.10.0, Masonry 4.2.2, perfect-scrollbar 1.5.6); the npm advisory database lists no advisories for those versions.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- The login and register pages are static demo screens; there is no real authentication.
- With `root: .` the repository's source files (for example `package.json`, `scss/`) are also served; they are already public on GitHub.
