## Summary

Adds a short "Deploy on Wasmer" subsection after the README's Build instructions, plus a one-line root `Staticfile` (`root: build`).

## Why this repo

People evaluating an admin template usually want a live instance to click through, or to share with their team, before adopting it. The template is a client-side Vite build with `HashRouter`, so it runs on any static host without rewrites. Wasmer detects Vite, runs `npm install` and `npm run build`, and serves the output folder. The README currently documents only the local build.

Why the `Staticfile` is needed:
- This template sets `build.outDir: 'build'` in `vite.config.mjs`.
- Wasmer's builder assumes Vite's default `dist`, so without a hint it would look for the wrong folder.
- The `Staticfile` only sets the output folder. Wasmer still detects the Vite app and runs the npm build.

## Testing

I ran a local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `2609f5995035973e00c16ec723165a5fff87cceb` with this change.

Detection:
- Provider: static Node.js.
- Framework: Vite.
- Package manager: npm.
- Output directory: `build`. Without the `Staticfile` it is `dist`, which does not exist after the build.

Commands and results:
- `npm install` on Node 24.22.1 with npm 11.21.1 exited 0.
- `npm run build` exited 0.
- `build/` was served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here).

Smoke test:
- `/` returned 200 ("CoreUI Free React.js Admin Template").
- `/#/dashboard` returned 200.
- All referenced assets returned 200.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- The extra root file exists only for Wasmer's output-dir detection.
- The button opens Wasmer's import page for this public repository, where the user reviews the configuration and clicks Deploy; it does not create a copy of the repository in their GitHub account. To customize and redeploy on push, they import their own copy of the repo.
