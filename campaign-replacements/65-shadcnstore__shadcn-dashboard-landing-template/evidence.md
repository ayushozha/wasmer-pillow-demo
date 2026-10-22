# shadcnstore/shadcn-dashboard-landing-template (65): HOLD, not built

- Pinned `953300fa5176608a9d682943edfc359ce809f2c7` (main); 1,210 stars / 257 forks (GitHub API 2026-10-22); MIT.
- Layout: the repo root has no `package.json`; the apps live in `vite-version/` and `nextjs-version/`. A button import of the repo root gives Anybuild nothing to build at the root. The `?github=OWNER%2FREPO` route takes no subdirectory, and Anybuild v0.33.0's `app_subdir` (`node.bzl:104-111`) is not reachable from the badge URL as far as verified here.
- Even inside `vite-version/`, routing is `createBrowserRouter` (`vite-version/src/App.tsx:1,13`) with dashboard deep links, and Wasmer's static path has no SPA fallback. `nextjs-version/` would be a Next server (next-bundle caveats plus an advisory check).
- Not a README-only target.
