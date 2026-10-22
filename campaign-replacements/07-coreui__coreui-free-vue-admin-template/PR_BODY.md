## Summary

Adds a short "Deploy on Wasmer" subsection after the README's Build instructions. It has a Deploy to Wasmer badge, one sentence on how the template is built, and one on what the button does. There are no code or config changes.

## Why this repo

People evaluating an admin template usually want a live instance to click through, or to share with their team, before adopting it. The template is a pure client-side Vite build with hash routing, so it runs on any static host without rewrites. Wasmer detects Vite, runs `npm install` and `npm run build`, and serves `dist/`, so the template goes from source to a live URL in one click. The README currently documents only the local build.

## Testing

I ran a local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `81cc2aef4f2c6a195558fcc414820f2f4fef359f` with this change.

Detection:
- Provider: static Node.js.
- Framework: Vite.
- Package manager: npm.
- Output directory: `dist`.

Commands and results:
- `npm install` on Node 24.22.1 with npm 11.21.1 exited 0. Only `package.json` and `package-lock.json` were staged, as the builder does.
- `npm run build` exited 0.
- `dist/` was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).

Smoke test:
- `/` returned 200 ("CoreUI Vue.js Admin Template"), and all 16 assets it references returned 200.
- Every one of the 96 files in `dist/` (including all lazy-loaded route chunks) returned 200 over HTTP.
- Routing is hash-based (`createWebHashHistory` in `src/router/index.js`), so routes such as `#/dashboard` never reach the server; the server only needs `/` and the static assets, and reloads/deep links work without rewrites. The views themselves were not exercised in a browser.

## Limitations

- `npm audit` on the installed tree reports `vite` 8.3.0–8.3.2 (dev-server/`launch-editor` advisories) and `source-map-js` <1.2.2 (build-time). Neither runs or ships in the deployed site: Wasmer serves only the built `dist/` with a static file server, and no Vite server runs.

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- The button opens Wasmer's import page for this public repository, where the user reviews the configuration and clicks Deploy; it does not create a copy of the repository in their GitHub account. To customize and redeploy on push, they import their own copy of the repo.
