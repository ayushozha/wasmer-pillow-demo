## Summary

Adds a "Deploy on Wasmer" subsection next to the existing GitHub Pages and Docker deployment instructions, in both `README.md` (Chinese) and `README_en.md` (English): a Deploy to Wasmer badge and two sentences on what the button does. No source or build changes.

## Why this repo

The periodic table is a fully static, client-side teaching tool: element data, heatmaps and the CSS 3D atom models all ship in the bundle, with no account, key or backend. Chemistry teachers and schools often want their own copy on a URL they control (for a class, an intranet or a lab display), and the README already offers GitHub Pages and Docker for that. A one-click deploy from source adds an option for people who do not want to run Docker or set up Actions.

## Testing

Replayed what Wasmer's builder (Anybuild v0.33.0) generates for commit `fa32eff8aa40b6a1a31f166017ad590222401482` with this change:

- Detection: static Node.js provider, framework Vite, package manager npm, output directory `dist` (matches `vite.config.ts`).
- `npm install` (only `package.json` and `package-lock.json` staged, as the builder does) exited 0 on Node 24.22.1 / npm 11.21.1.
- `npm run build` (vite 6.4.3) exited 0.
- `dist` served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here): `/` returned 200, and the JS and CSS bundles referenced by the built `index.html` returned 200.
- `npm audit --omit=dev`: 0 (the app has no runtime dependencies). The full `npm audit` reports 5 findings in dev tooling (2 critical: vitest, tinypool; 2 high: vite, source-map-js; 1 moderate: @vitest/mocker); none ships in `dist`.

## Limitations

- This repo's `quality` workflow runs `npm audit --audit-level=high` on pull requests to `main`. That gate already fails on `main` at this commit because of the dev-tooling findings above, so it will also fail on this README-only PR; this PR doesn't change dependencies or the workflow.
- Code is MIT; the primary element data is CC BY-SA 3.0 (as the README states), and a deployment redistributes it with that attribution.
- The core table works offline, but the optional element-photo and Bohr-model buttons load images from third-party hosts (Wikimedia, images-of-elements.com, Google Cloud Storage).

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- Checks were HTTP-level only; the 3D atom view and heatmaps were not exercised in a browser.
- The app is a single page; unknown paths return 404, as on any static host.
