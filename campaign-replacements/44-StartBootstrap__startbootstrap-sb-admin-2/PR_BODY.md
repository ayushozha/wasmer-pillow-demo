## Summary

Adds a "Deploy to Wasmer" button to the README (new "Deploy on Wasmer" subsection under Usage) and a one-line `Staticfile` (`root: .`) so Wasmer serves the prebuilt HTML, CSS, JS and `vendor` files at the repository root as a static site.

Why the `Staticfile` is needed: without it, Wasmer's builder (Anybuild) sees `package.json` and picks its Node.js provider, which would run `node_modules/.bin/gulp watch` — the BrowserSync development server with file watching — as the production start command. With the `Staticfile` it copies `.` as-is and serves it with static-web-server; no install or build step runs.

The button opens Wasmer's import and configuration page for this public repository; the user reviews the configuration and clicks Deploy. It does not create a copy of the repository in their GitHub account. To customize the theme, users fork it (or use their own copy) and import their own repository.

## Why this repo

SB Admin 2 is one of the most-used free Bootstrap admin dashboards; people often want a hosted copy of the demo to evaluate or share before wiring it to a backend. The repository ships the built files at its root, so a one-click static deploy needs no build tooling; the only existing hosting path in the README is the GitHub Pages live preview.

## Testing

Replayed locally exactly what Wasmer's builder (Anybuild v0.33.0) generates for this branch, at upstream `f0309881ef82`:
- `anybuild plan` → static provider, output directory `.`, no install/build commands.
- Copied `.` into the app directory and served it with static-web-server 2.38.0 (`--root=<app> --port=<port>`).
- Smoke test: Pages `/`, `/index.html`, `/charts.html`, `/tables.html`, `/login.html`, `/404.html` = 200; all 24 same-origin refs 200. `/does-not-exist` = 404 with an empty body in this local replay, while `/404.html` itself = 200. The cause was not established (it may depend on the local harness's working directory or static-web-server settings), so the 404 page shown on Wasmer is unverified. Offline link check of every `.html` in static_app: 331 local refs, 0 unresolved.

## Limitations

- No deployment was made; the badge image and the wasmer.io import page could not be loaded from the test environment.
- Serving `root: .` also publishes the repo's source files (`scss/`, `gulpfile.js`, `package.json`, `Staticfile`); none are secrets, and this is the same tree GitHub Pages serves today. In the local replay unknown URLs returned an empty 404 body rather than the theme's `404.html`; behaviour on Wasmer is unverified. The theme is Bootstrap 4 / last commit 2021-04-28.
