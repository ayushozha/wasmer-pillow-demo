## Summary

This adds a short "Self-hosted on Wasmer" section to the README's Usage part, with a Deploy to Wasmer badge and two sentences. It also adds a one-line `Staticfile` (`root: dist-app`) so the hosting builder serves the folder the app build actually writes. There are no source, dependency or build-script changes.

## Why this repo

The README already offers two ways to use PEV2: the Dalibo service and the downloadable all-in-one `pev2.html`. Some teams want a third option in between: their own internal URL. Their execution plans contain table names, queries and sometimes literal values, so they would rather not paste them into a third-party site, and they don't want to pass an HTML file around either. The app runs entirely in the browser. Plans are stored in the browser's IndexedDB, and the only network request is the GitHub "latest release" version check. That makes it a good fit for a one-click static deployment built from this repository's own source.

The `Staticfile` is needed because `vite.config.ts` sets `outDir: "dist-app"` for the app build. Wasmer's builder (Anybuild v0.33.0) detects Vite and otherwise serves `dist/`, which this build does not create.

## Testing

I replayed the steps Wasmer's builder generates for `e41d4e8b3006c479f9364d68a5d538d81cb7d110` (v1.25.0) with this change:

- Detection: static Node.js provider, framework Vite, package manager npm, output directory `dist-app` (from the `Staticfile`). Before the change, the plan said `dist`.
- `npm install` exited 0 with only `package.json` and `package-lock.json` staged (Node 24.22.1, npm 11.21.1). Husky's `prepare` printed ".git can't be found", which is non-fatal.
- `npm run build` (`vue-tsc --noEmit && vite build`) exited 0 and produced a single self-contained `dist-app/index.html` (1,308,080 bytes; JS and CSS inlined by `vite-plugin-singlefile`).
- Served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here):
  - `/` and `/index.html` returned 200 with the title "Postgres EXPLAIN Visualizer 2 (pev2)".
  - The page references no other local files (the favicon is a data URI).
- `npm audit --omit=dev` reported 0 vulnerabilities.
- `prettier --check README.md` passes.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- The checks were HTTP-level only; plan parsing and rendering were not exercised in a browser.
- The app is a single page. Node selection uses URL hash fragments (`#plan/node/<id>`), which never reach the server; any other path returns 404.
- The button opens Wasmer's import page for this public repository, where the user reviews the configuration and clicks Deploy; it does not create a copy of the repository in their GitHub account.
