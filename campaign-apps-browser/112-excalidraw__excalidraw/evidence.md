# excalidraw/excalidraw: evidence (triage; no patch prepared)

**Verdict: HOLD (monorepo is not detected as static).** From the root, Anybuild v0.33.0 detects a **Node.js server provider**: `yarn install`, then `yarn run build`, then start `yarn --cwd ./excalidraw-app start`. The root `build` is `yarn --cwd ./excalidraw-app build`, and `excalidraw-app`'s `start` is `yarn && vite`, so the deployment would run the Vite **dev server**. No static dir is set (plan.txt). A correct static deployment of `excalidraw-app/build` needs a builder or config change outside a README PR. The committed `.env.production` also points sharing, collaboration, libraries and AI at excalidraw.com services (`VITE_APP_BACKEND_V2_*`, `VITE_APP_WS_SERVER_URL=https://oss-collab.excalidraw.com`, `VITE_APP_AI_BACKEND`, and others). Local drawing works client-side.

## Facts
- Pinned SHA: `1d4dc2c0e6e476911d0760e9c3cf3694f2d43384` on `master` (2026-10-21). Stars / forks: 134,347 / 15,787 (GitHub API, 2026-10-22). License: MIT.
- Yarn 1.22.22 workspaces (`excalidraw-app`, `packages/*`, `examples/*`). All workspace `package.json` files are staged (plan `node_install_inputs`).
- Not replayed: the plan alone shows a dev-server start.
