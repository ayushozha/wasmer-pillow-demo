## Summary

Adds a "Deploy to Wasmer" button to the README (new "Deploy on Wasmer" subsection under Usage) and a one-line `Staticfile` (`root: dist`) so Wasmer serves the committed `dist/` directory as a static site.

Why the `Staticfile` is needed: without it, Wasmer's builder (Anybuild) sees `package.json` and picks its Node.js provider, which would run `npm run build && node scripts/start.js` — the BrowserSync development server with file watching — as the production start command. With the `Staticfile` it copies `dist` as-is and serves it with static-web-server; no install or build step runs.

The button opens Wasmer's import page for this public repository and deploys it as-is; it does not fork it. To customize the theme, users fork it (or use their own copy) and import their own repository.

## Why this repo

This theme is a popular starting point for single-page creative/agency landing sites, and its README already tells users the files in `dist` are the only ones they need to edit. The repository ships the built files in `dist`, so a one-click static deploy needs no build tooling; the only existing hosting path in the README is the GitHub Pages live preview.

## Testing

Replayed locally exactly what Wasmer's builder (Anybuild v0.33.0) generates for this branch, at upstream `b2d5d5c6b139`:
- `anybuild plan` → static provider, output directory `dist`, no install/build commands.
- Copied `dist` into the app directory and served it with static-web-server 2.38.0 (`--root=<app> --port=<port>`).
- Smoke test: `/` and `/index.html` 200; 22 same-origin refs checked, all 200. External CDN refs (Bootstrap, Font Awesome, Google Fonts, SB Forms) are not fetched by the smoke test.

## Limitations

- No deployment was made; the badge image and the wasmer.io import page could not be loaded from the test environment.
- Bootstrap/fonts/icons load from public CDNs as in upstream. The contact form ships with SB Forms markup and the `API_TOKEN` placeholder, so submissions do not work until the user configures SB Forms (unchanged from upstream behaviour). Unknown URLs return static-web-server's bare 404.
