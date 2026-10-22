Title: docs: add Wasmer Edge deploy option

I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository’s static site. References: [Wasmer Edge docs](https://docs.wasmer.io/edge/), [Git deployments](https://docs.wasmer.io/edge/git/).

## Summary

Adds a short "Deploy your own copy / 自分のコピーをデプロイ" section at the end of the README. It has a "Deploy to Wasmer" badge that links to `https://wasmer.io/apps/create?github=Kirilllive%2FASCII_Art_Paint`, plus a few lines in English and Japanese, matching the rest of the README:

- ASCII Art Paint is plain static files with no build step, so it can be served as-is.
- Fork first if you want to customize it. The import serves the repository you pick and does not copy it into your GitHub account.
- The editor itself is at `/ascii_paint.html`, because the root `index.html` is the landing page.

This is a README-only change, with no code or config changes.

## Why this repository

ASCII Art Paint is entirely committed HTML/JS (`index.html`, `ascii_paint.html`, `ascii_paint_minified.html`) with no dependencies, and it is designed to work offline in the browser. The README currently points only to your GitHub Pages copy. This section gives people who want their own instance, for example with their own palettes or fonts, a direct way to host one, and it tells them where the editor lives.

## Testing

- Base commit: `3477035bc09e91c8c638d9039e5727eb1ef64630`. No build step and no `package.json`.
- I ran Anybuild 0.33.0's `anybuild plan` on clean checkouts of the base commit and of this branch. Both gave provider `staticfile`, serving the repository root, with no build. Nothing steers detection to Node.
- I replayed the planned steps in a clean directory and served the result with static-web-server 2.38.0 using Anybuild's flags. `/`, `/index.html`, `/ascii_paint.html`, `/ascii_paint_minified.html`, `/examples/logo.txt`, `/examples/example_map.png`, `/screenshots/palette.png` and `/README.md` all returned 200. An unknown path returned 404.
- A relative-link scan found 13 relative references. The only missing one is `icon.jpg`, the favicon referenced by `ascii_paint.html` and `ascii_paint_minified.html`. That file isn't in the repository, so the favicon is already missing on GitHub Pages too. This PR doesn't change it.

## Limitations

- I did not deploy to Wasmer. Only the local static serving above was tested.
- Redeploy-on-push needs your own fork connected.
- Because the whole repository root is served, `README.md`, `LICENSE`, `.github/` and the `.DS_Store` files are publicly reachable too.
- Palettes, theme and font-range settings saved in the browser (localStorage) belong to each site, so they don't carry over between the GitHub Pages copy and a self-hosted copy.
- The badge image is served by shields.io.
