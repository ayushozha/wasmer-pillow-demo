# steffest/BassoonTracker: evidence

**Verdict: HOLD (build output has no index page).** BassoonTracker is an Amiga-style music tracker that runs in the browser (MIT, 1,169 stars, last push 2026-10-21).

## What the builder does
- Plan (`plan.txt`): static Node.js provider, Vite, npm 11. Install `npm install`, build `npm run build` (`vite build`), output directory `dist`.
- `vite.config.js` sets `outDir = process.env.VITE_OUTDIR || 'build'`, so the default build writes `build/`, not `dist/`. The build input is `dev.html`, so the output entry point is `build/dev.html`; no `index.html` is produced.
  - The `copyIndexHtmlPlugin` that rewrites the root `index.html` runs only when `VITE_OUTDIR=live` (the `deploy` script). It writes the root `index.html` to point at `./live/`.
- A Staticfile with `root: build` would fix the directory, but `/` would still return 404 because there is no `index.html`. Serving the repo root instead would copy `node_modules` into the artifact (as in 161). The README itself says "BassoonTracker doesn't need building, the build step is optional".
- That makes this effectively a no-build static app, which another session owns. It is held and handed off rather than patched.

## Repository
- Pinned SHA: `f2d3a1039ce31ed1542da760f5c7c845cdfce2ed` on `master`.
- License: `license.txt`, MIT, Copyright (c) 2017 Steffest.
- The repo also ships optional `api/` (Node server for modarchive and storage proxies) and `auth/` folders. Core tracker editing is client-side.
- No replay was run; the decisive facts come from the config files and the plan.
