## Summary

Adds a short "Deploy on Wasmer" section to the README, before "What's Included", and a one-line root `Staticfile` (`root: .`) so Wasmer serves the committed demo as static files.

## Why this repo

Sneat Free is used by developers who want a Bootstrap 5 admin UI they can show to a team or client before building on it. The README notes that Node, Webpack and Gulp are optional and that the committed files are usable as-is. A one-click deploy of those files gives people a private, shareable copy of the demo (all `html/` pages, assets and fonts) without setting up the Gulp toolchain.

Why the `Staticfile` is needed: without it, Wasmer's builder sees `package.json` and picks the Node.js server provider, which runs `yarn install` and `yarn run build` and then has no start command. The one-line `Staticfile` tells it to serve the repository root as static files. It changes nothing for local development.

## Testing

Local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `de094c2bf89e602054b7c14f46c9a3a5b9f6cac9` with this change:
- Detection: StaticFile provider, output directory `.`, served by a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).
- `/`, `/html/index.html`, `/html/auth-login-basic.html`, `/html/cards-basic.html`, `/html/form-layouts-vertical.html` and `/html/tables-basic.html` returned 200.
- Every local `href`/`src` referenced from every HTML page (115 unique URLs: CSS, JS, fonts, images) returned 200.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- The login and register pages are static demo screens; there is no real authentication.
- The button opens Wasmer's import page for this public repository, where you review the configuration and click Deploy; it does not create a copy of the repository in your GitHub account. To customize, fork the repository and import your fork.
