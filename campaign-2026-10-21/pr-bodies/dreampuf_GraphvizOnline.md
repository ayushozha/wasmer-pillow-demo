Title: docs: add Wasmer Edge deploy option

I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository’s static site. References: [Wasmer Edge docs](https://docs.wasmer.io/edge/), [Git deployments](https://docs.wasmer.io/edge/git/).

## Summary

Adds a short "Deploy to Wasmer Edge" section to the README, just before "How to implement this". It has a "Deploy to Wasmer" badge that links to `https://wasmer.io/apps/create?github=dreampuf%2FGraphvizOnline`, plus a few lines of guidance:

- GraphvizOnline is plain static files with no build step, so it can be served as-is.
- Fork first if you want to customize it. The import serves the repo you pick and does not copy it into your GitHub account.
- The page loads `lz-string` from cdnjs, and the Share button calls `api.allorigins.win` and `is.gd` to shorten links.

This is a README-only change, with no code or config changes.

## Why this repository

GraphvizOnline is entirely committed static files: `index.html`, `main.js`, the compiled `viz-global.js` and ACE. Graphs are shared through the URL hash or the `?compressed=` / `?url=` parameters, so a copy works on any static host without a server. The README only points to the author's GitHub Pages instance, and the gh-pages workflow was removed in #46. This section gives people who want their own instance a direct way to run it, and it tells them which third-party services the page talks to.

## Testing

- Base commit: `ecaf161aade6111e60f49abf03a5442a6f6beec5`. No build step.
- I ran Anybuild 0.33.0's `anybuild plan` on clean checkouts of the base commit and of this branch. Both gave provider `staticfile`, serving the repository root, with no build.
- I served a clean checkout with static-web-server 2.38.0 using Anybuild's flags. `/`, `/index.html`, `/main.js`, `/viz-global.js`, `/ace/ace.js`, `/style.css`, `/hammer.min.js` and `/svg-pan-zoom.min.js` all returned 200. An unknown path returned 404.
- The local reference checker found no missing local references.

## Limitations

- I did not deploy to Wasmer. Only the local static serving above was tested.
- Redeploy-on-push needs your own fork connected.
- Because the whole repository root is served, `README.md`, `LICENSE` and `.github/` are publicly reachable too.
- The runtime third-party requests (cdnjs, and allorigins/is.gd when Share is used) are the same on every host.
- The badge image is served by shields.io.
