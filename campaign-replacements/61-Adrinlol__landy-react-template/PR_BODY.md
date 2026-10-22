## Summary

Adds a short "Deploy on Wasmer" subsection under Installation in the README, with a Deploy to Wasmer button and two sentences on what it does.

## Why this repo

Landy is used as a quick landing page for a product or project, and its users are often not front-end specialists. The README links a live demo but has no deploy instructions. The app is a Create React App build with a single page, so it runs on any static host. Wasmer detects CRA, runs the npm build, and serves `build/`.

## Testing

Local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `8c3aa8bfc8fdeddf4c90046594835455b50d6494` with this change:
- Detection: static Node.js provider, framework Create React App, npm, output `build`.
- `npm install` (Node 24.22.1, npm 11): exit 0.
- `npm run build`: exit 0, "Compiled successfully".
- `build/` served with static-web-server 2.38.0: `/` returned 200, and the JS/CSS bundles, the lazy route chunk, `manifest.json` and the `img/svg` icons returned 200.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- The app uses `BrowserRouter`; the static host has no SPA fallback, so a direct load of `/home` returns 404. `/` is the only linked route.
- The button opens Wasmer's import page for this public repository, where you review the configuration and click Deploy; it does not create a copy of the repository in your GitHub account. To customize, fork the repository and import your fork.
