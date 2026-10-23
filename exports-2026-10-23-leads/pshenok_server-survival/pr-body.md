Title: docs: add Wasmer Edge deploy option

<a href="https://wasmer.io/apps/create?github=pshenok%2Fserver-survival"><img src="https://img.shields.io/badge/Deploy%20to-Wasmer-171717?style=for-the-badge&amp;logo=wasmer&amp;logoColor=white&amp;labelColor=171717" alt="Deploy to Wasmer" height="48"></a>

I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository’s static site. References: [Wasmer Edge docs](https://docs.wasmer.io/edge/), [Git deployments](https://docs.wasmer.io/edge/git/).

This change was prepared with AI assistance (Anthropic's Claude); the testing described below was run locally, and I did not deploy it to Wasmer.

## Summary

Adds a short "Host your own copy" subsection under Getting Started, right after the local `python3 -m http.server` instructions. It contains a "Deploy to Wasmer" badge linking to `https://wasmer.io/apps/create?github=pshenok%2Fserver-survival`, plus a few lines saying:

- fork first, then import your fork (swap the `owner%2Frepo` in the link);
- importing does not copy this repository into anyone's account, and only a repository you own and connect redeploys on push;
- there is still no build step, and the folder is served as static files, the same way GitHub Pages serves it.

This is a README-only change, with no code or config changes.

## Why this repository

The README already covers running "your own copy — a fork, or a change you just made" and explains why it has to be served over HTTP rather than opened from `file://`. Server Survival is free, no-build static ES modules, so a fork with its own campaign levels, balance tweaks or translations (for a class or a workshop, say) can go online as it is. Its `?arch=` share links are built from `location.origin`, so they then point at that fork's own URL. The new subsection gives people a hosted option next to the local one.

## Testing

- Base commit: `52fc46f0602acf11b8e2a9cf2627e706ccff8f6f`.
- I ran the same checks as CI (`.github/workflows/ci.yml`) on Node 22.22.0: `npm ci`, `npm run lint` and `npm test`. All passed, with 71 test files and 1182 tests.
- I ran Anybuild 0.33.1's `anybuild plan` on clean checkouts of the base commit and of this branch. Both gave provider `staticfile`, serving the repository root, with no install or build step.
- I replayed the planned steps in a clean directory and served the result with a native static-web-server 2.38.0 using Anybuild's flags. Wasmer itself runs the SWS 2.32.2 WebAssembly build, which I did not test. `/`, `/index.html`, `/game.js`, `/style.css`, `/src/main.js`, `/src/state.js`, `/assets/sounds/click-10.mp3`, `/assets/gameplay.gif` and `/?arch=x` all returned 200. An unknown path returned 404.
- A scan of the module graph found all 277 relative `import` specifiers and every `assets/sounds/*` path referenced from JS present in the served tree.
- `npm audit --omit=dev` reports 0 vulnerabilities, because there are no runtime npm dependencies.

## Limitations

- I did not deploy to Wasmer. Only the local static serving above was tested.
- Redeploy-on-push needs your own fork connected.
- The whole repository root is served, so `README.md`, `docs/`, `tests/` and `package.json` are publicly reachable too, as they are on GitHub Pages.
- Saves, campaign progress and settings live in localStorage, which is per site, so they don't carry over from the GitHub Pages copy.
- The share-image watermark and the `og:url` meta tag still name the upstream GitHub Pages URL. Fork owners may want to change them.
- The game still loads Tailwind and Three.js from their CDNs at runtime. The badge image is served by shields.io.
