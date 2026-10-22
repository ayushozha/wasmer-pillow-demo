## Summary

Adds a short "Deploy on Wasmer" subsection to the README, after the Docker build instructions. It has a Deploy to Wasmer badge and two sentences: one on how the app is built and served, and one on what the button does. There are no code or config changes.

## Why this repo

drawDB is used by developers, students and teams to sketch database schemas and generate SQL in the browser without an account. Some teams want their own instance on an internal URL so schema drafts never leave infrastructure they control. The README already documents a static build and a Docker image. The editor runs entirely in the browser, with diagrams stored in IndexedDB, so a static deployment is enough unless you need sharing, which uses the separate drawdb-server and `VITE_BACKEND_URL`. The button gives that self-hosted instance in one step from source.

## Testing

I ran a local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `7683bdf90a8db5d284dc6b2bc545831aa4b6dd76` with this change.

Detection:
- Provider: static Node.js.
- Framework: Vite.
- Package manager: npm.
- Output directory: `dist`.

Commands and results:
- `npm install` on Node 24.22.1 with npm 11.21.1 exited 0. Only `package.json` and `package-lock.json` were staged, as the builder does.
- `npm run build` (`vite build`) exited 0.
- `dist/` was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).

Smoke test:
- `/` returned 200.
- The main JS bundle, CSS, `config.js` and favicon all returned 200.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- Wasmer serves the build without an SPA fallback, unlike the repo's `vercel.json` rewrite and nginx `try_files`. Reloading or opening `/editor`, `/editor/diagrams/<id>`, `/editor/templates/<id>`, `/templates` or `/bug-report` directly returns 404. Only `/` loads on a fresh request.
- Sharing needs a separately hosted drawdb-server. `VITE_BACKEND_URL` is baked into the public JS at build time.
- drawDB is AGPL-3.0. Anyone hosting a modified version must offer its source to users.
