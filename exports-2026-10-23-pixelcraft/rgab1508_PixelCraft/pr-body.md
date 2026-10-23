Title: Add Wasmer Edge deploy option to README

<a href="https://wasmer.io/apps/create?github=rgab1508%2FPixelCraft"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" height="48"></a>

I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository’s static site. References: [Wasmer Edge docs](https://docs.wasmer.io/edge/), [Git deployments](https://docs.wasmer.io/edge/git/).

This change was prepared with AI assistance (Anthropic's Claude); the testing described below was run locally, and I did not deploy it to Wasmer.

## Summary

This adds a short "Deploy Your Own Copy" section to the README, after "PWA Support". It holds a Deploy to Wasmer badge that links to Wasmer's import page for this repository. The section also has fork-first guidance: the import does not copy the repository into your GitHub account, so to customize a copy (for example the `og:url` and `og:image` links in `index.html`) or to redeploy on push, fork first and import the fork.

Only `README.MD` changes (8 added lines). No app code, config files, dependencies or CI files change.

## Why this repository

The README already says "This App is Available at both these locations" and lists https://rgab1508.github.io/PixelCraft and https://pixelcraft.web.app, so PixelCraft is already served from two static hosts. It describes itself as "A pixel Art & Animation Creation Tool Built using HTML5 Canvas" and "a Progressive Web App (PWA) with offline compatibility". The app is committed as plain files at the repository root (`index.html`, `Canvas.js`, `lib/`, `gif.worker.js`, `sw.js`, `manifest.json`) with no build step. Another static host can therefore serve it exactly as it is. I checked locally that drawing, GIF export through the gif.js worker, and the service worker all work from a plain static server.

## Testing

All at commit 45a5d48 (base) and with this patch applied:

- **Wasmer's builder (Anybuild 0.33.1, local):** `anybuild plan` on clean checkouts of the base and the patched commit. Both detect the static site provider (staticfile) with the repository root as the site and no install or build step. With the patch, `anybuild build` copies the repository (ignoring `.git`) and runs no toolchain.
- **Build-step replay:** replaying the planned steps put the same files in the output directory. 13 paths returned 200 and no root-relative references were missing.
- **Static serving:** native static-web-server 2.32.2 and 2.38.0, the server Wasmer uses, built natively here rather than the WebAssembly build Wasmer runs. `/`, `/index.html`, `/global.css`, `/Canvas.js`, `/lib/gif.js`, `/lib/Matrix.js`, `/lib/Shapes.js`, `/lib/Transformation.js`, `/gif.worker.js`, `/sw.js`, `/manifest.json`, `/icons/logo.png`, `/images/overview.png` and `/images/toolbar.png` all returned 200 on both versions. A missing path returned 404. `sw.js` and `gif.worker.js` are served as `text/javascript`.
- **Headless Chromium** (served by each static-web-server version):
  - the page loaded and the default 16 x 16 dimension popup was accepted;
  - 12 toolbar items and 20 palette colors rendered;
  - a mouse draw turned cell (3,3) black;
  - after adding two frames, "Save GIF" ran the `gif.worker.js` worker and produced a 5.2 kB `image/gif`;
  - `sw.js` registered at scope `/`;
  - no local requests failed.

  The only console error was the external Font Awesome kit request, which my sandbox network blocks, so toolbar icon glyphs were blank in that test.

## Limitations

- I did not deploy this to Wasmer. The serving tests used native static-web-server, not Wasmer's WebAssembly build.
- The import page reads this public repository. It does not fork or copy it into the visitor's account. Redeploy-on-push needs the visitor's own fork connected.
- The deployed copy serves the whole repository root, including the unbuilt `new/pixelcraft` React sources, as the existing hosts presumably do. The app does not load them.
- Toolbar icons come from an external Font Awesome kit. I could not check whether that kit serves pages on other domains.
- The `og:url` and `og:image` meta tags point to rgab1508.github.io, so a copy on another domain may want to change them.
