## Summary

This PR is a small documentation addition. It adds a "Deploy on Wasmer" subsection after "Offline builds" in the README, with a Deploy to Wasmer badge and two sentences. It also adds a one-line `Staticfile` (`root: dest/prod`) so the hosting builder serves the folder Piskel's build actually produces. No source or build changes.

## Why this repo

Piskel is a fully client-side sprite editor. Teachers running pixel-art or game-design classes, game-jam teams and hobbyists often want an editor on their own URL: one they control, that keeps working when the public site is busy, and that has no account features. It saves to the browser and exports local files; no account is needed. A one-click deploy from source gives these users their own instance without setting up Node locally. The README currently covers offline (desktop) builds only.

The `Staticfile` is needed because `npm run build` writes to `dest/prod` (set in `vite.config.js`). Wasmer's builder (Anybuild v0.33.0) detects Vite and otherwise expects `dist/`, so without this line the build succeeds but nothing is served.

## Testing

I replayed what Wasmer's builder generates for `d828941fa9fe76464d69d91d5fd862067c98c02c` with this change:

- Detection: static Node.js provider, framework Vite, output directory `dest/prod` (from the `Staticfile`).
- `npm install` exited 0 on Node 24.22.1 with npm 11.21.1, with only `package.json` and `package-lock.json` staged. Husky's `prepare` step printed ".git can't be found" and did not fail the install. npm 11 did not run Puppeteer's or nw-builder's postinstall scripts (not on its allowlist), so no browser was downloaded, and the web build does not need one.
- `npm run build` (sprites, then `vite build`, then partials) exited 0.
- `dest/prod` was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here):
  - `/` returned 200 ("Piskel").
  - All 40 assets the editor loads returned 200: the packaged JS and CSS, the icomoon fonts, every cursor and tool icon in the CSS, the sprite sheets and the partials.
  - The GIF worker is created from a blob URL, so there is no separate worker file.
- Without the `Staticfile`, the same build runs, but the builder looks for `dist/`, which does not exist, so nothing is served.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- The checks were HTTP-level only; drawing and export were not exercised in a browser.
- Piskel is a single page. Unknown paths return 404, as on any static host.
- The button opens Wasmer's import page for this public repository, where the user reviews the configuration and clicks Deploy; it does not create a copy of the repository in their GitHub account.
