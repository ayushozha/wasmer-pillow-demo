## Summary

Adds a short "Deploy on Wasmer" section after "Build instructions" in the README, with a Deploy to Wasmer badge and two sentences, plus a one-line `Staticfile` (`root: .`) at the repository root. No source, build or `dist/` changes.

## Why this repo

miniPaint is a fully client-side image editor: layers, filters and exports all run in the browser, and images never leave the user's machine. Schools, small teams and privacy-conscious users often want their own copy on their own URL, for example to embed it with the iframe snippet from the README without depending on `viliusle.github.io`. The repository already ships the built `dist/bundle.js` next to `index.html`, so the repository root is a complete static site.

The `Staticfile` is needed for correct detection. Without it, Wasmer's builder (Anybuild v0.33.0) sees `package.json` and picks its Node.js provider, which has a build command (`npm run build`) but no start command and does not serve the root `index.html`. With `root: .` it serves the repository root as static files, which is how GitHub Pages serves the hosted editor today.

## Testing

I replayed what Wasmer's builder generates for `a79733eb803fc97084ef0ee4faa96b031e69e1c0` with this change:

- Provider: static site (`Staticfile`), output directory `.`. No install or build step.
- The root was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).
- `/` returned 200 ("miniPaint - image editor"), and `/dist/bundle.js` returned 200 (1.36 MB).
- Runtime assets the bundle loads all returned 200: `images/test-collection.json`, `images/logo-colors.png`, `images/logo.svg`, `src/js/libs/gifjs/gif.worker.js` and sample icons. All 30 `images/icons/*` files referenced in the bundle are present in the served root.
- The commented-out `dist/manifest.json` link in `index.html` 404s, as it does today; browsers ignore it because it is inside an HTML comment.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- The deployment serves the committed `dist/bundle.js`. Changes to `src/` appear only after `dist/` is rebuilt and committed, which matches the current release process.
- Editing was not tested in a real browser; the checks were HTTP-level only. Google Fonts and other optional online features still call their external services.
- The button opens Wasmer's import page for this public repository, where the user reviews the configuration and clicks Deploy; it does not create a copy of the repository in their GitHub account.
