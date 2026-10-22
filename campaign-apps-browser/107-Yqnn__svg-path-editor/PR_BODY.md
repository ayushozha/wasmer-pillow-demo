## Summary

Adds a short "Deploy on Wasmer" section to the README, after "Running Locally". It has a Deploy to Wasmer badge and two sentences: one on how the app is built and served, and one on what the button does. There are no code or config changes.

## Why this repo

SvgPathEditor is used by front-end developers, icon designers and people hand-tuning SVG for the web to inspect, edit and optimize path data. The README documents building it with `npm run build` into `dist/`, and the public instance is on GitHub Pages. Some people want their own copy on a URL they control, for a team or a classroom, or alongside other internal tools. Because the app is a single-page Angular build with no backend, Wasmer can build and serve it directly from source with one click.

## Testing

I ran a local replay of what Wasmer's builder (Anybuild v0.33.0) generates for `937d75a83b6be2bdda11d02b9b3594841315223a` with this change.

Detection:
- Provider: static Node.js.
- Framework: Angular.
- Package manager: npm.
- Output directory: `dist/svg-path-editor` (matches `angular.json`).

Commands and results:
- `npm install` on Node 24.22.1 with npm 11.21.1 exited 0. Only `package.json` and `package-lock.json` were staged, as the builder does.
- `npm run build` (`ng build`) exited 0.
- The output was served with a local native static-web-server 2.38.0, the version Anybuild's plan pins. Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here.

Smoke test:
- `/` returned 200.
- The main, polyfills and runtime JS returned 200.
- The CSS, favicon, web manifest and icons returned 200.
- The Angular service worker files (`ngsw-worker.js`, `ngsw.json`) returned 200.
- The app has no client-side router, so there are no deep links to break.

## Limitations

- No deployment was made. The badge image and the Wasmer import page could not be checked from the test environment.
- Editing and the service worker were not exercised in a browser; the check was HTTP-level.
- `src/index.html` includes the Google Analytics tag `G-1BBJSPSKQ9` and Google Fonts. The build inlines the font CSS (it fetches fonts.googleapis.com at build time), and the font files still load from fonts.gstatic.com. Deployed copies keep both unless the person deploying edits `index.html` in their own copy.
- The button opens Wasmer's import page for this public repository, where the user reviews the configuration and clicks Deploy; it does not create a copy of the repository in their GitHub account.
