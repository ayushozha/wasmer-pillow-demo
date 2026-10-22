## Summary

Adds a short "Deploy on Wasmer" subsection to the README's Getting Started section, after the Docker and custom inference server instructions. It has a Deploy to Wasmer badge, one sentence on how the app is built and served, one sentence on what the button does, and a note that `VITE_*` values are public. There are no code or config changes.

## Why this repo

ChartDB is used by developers and DBAs to visualize an existing database from a single metadata query and to edit schemas. Many of them cannot paste production schema metadata into a hosted service, which is why the README offers Docker self-hosting. The editor runs fully in the browser with IndexedDB storage, so a static deployment from source gives a team its own instance without running a container.

The note covers how the README's existing AI options behave on a public static deployment. `VITE_OPENAI_API_KEY` is compiled into the JavaScript and visible to every visitor. AI export runs in the browser, so the safe option is the documented custom inference endpoint with its own access control.

## Testing

I ran a local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `c24936a402bb3e24b4858f05282d69a04fcfe25b` with this change, with no environment variables set.

Detection:
- Provider: static Node.js.
- Framework: Vite.
- Package manager: npm.
- Output directory: `dist`.

Commands and results:
- `npm install` on Node 24.22.1 with npm 11.21.1 exited 0.
- `npm run build` ran out of memory at Node's default heap (about 2.2 GB on the test machine).
- With `NODE_OPTIONS=--max-old-space-size=4096` the build completed. `/` and all referenced assets returned 200 from static-web-server 2.38.0.

## Limitations

- No deployment was made. The badge and the Wasmer import page could not be checked from the test environment.
- The build needs more than about 2.2 GB of Node heap. Whether Wasmer's builder provides that was not verified.
- Wasmer serves the build without an SPA fallback, unlike the bundled nginx `try_files`. Reloading `/diagrams/<id>`, `/examples` or `/templates/...` returns 404, and the editor moves to `/diagrams/<id>` as soon as a diagram exists.
- AI export is not available unless configured. Any `VITE_*` value, including an API key, is public in the built JavaScript.
- ChartDB is AGPL-3.0. Anyone hosting a modified version must offer its source to users. The repository requires signing its CLA.
