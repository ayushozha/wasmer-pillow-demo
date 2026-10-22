## Summary

Adds a short "Deploy on Wasmer" section to the README, before the Contribution Guide. It has a Deploy to Wasmer badge and two sentences: one on how the app is built and served, and one on what the button does. There are no code or config changes.

## Why this repo

Regex Vis is used by developers who want to see and edit a regular expression as a diagram and test it against sample strings. Teams that paste internal log lines or identifiers into a regex tester sometimes prefer an instance on their own URL. The repo already ships a Dockerfile, which runs the dev server, and a Vercel rewrite. The app is a fully client-side Vite build, so Wasmer can build it from source and serve the static output with one click. The shareable state is the `?r=` query on `/`, which works on a static host.

## Testing

I ran a local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `a6d920601ca44ab2d4e9cd02306510ab6d5e4b38` with this change.

Detection:
- Provider: static Node.js.
- Framework: Vite.
- Package manager: pnpm.
- Output directory: `dist`.

Commands and results:
- `pnpm install` (pnpm 10.34.7, Node 24.22.1) exited 0. Only `package.json` and `pnpm-lock.yaml` were staged, as the builder does.
- `pnpm run build` (`tsc && vite build`) exited 0.
- The output was served with a local native static-web-server 2.38.0, the version Anybuild's plan pins. Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here.

Smoke test:
- `/` and `/?r=...` returned 200.
- The JS bundle, CSS, favicon, logo, manifest and robots returned 200.
- The translation files under `/locales/` returned 200.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- The static host has no SPA fallback. Opening or reloading `/samples` directly returns 404. Navigating to it from the header is client-side and should work, but it was not tested in a browser. `/` with `?r=` links is unaffected.
- The production `index.html` includes the Cloudflare Web Analytics beacon for regex-vis.com, so deployed copies keep it unless the person deploying edits their own copy.
- The button opens Wasmer's import page for this public repository, where the user reviews the configuration and clicks Deploy; it does not create a copy of the repository in their GitHub account.
