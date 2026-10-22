## PR description

This PR adds a "Deploy on Wasmer" subsection under "I want to host SVGEdit in my environment", with a Deploy to Wasmer badge and two sentences. It also adds a one-line `Staticfile` (`root: dist/editor`) so the builder serves the folder `npm run build` produces (the same folder `netlify.toml` publishes). No source changes.

Why: the README already explains how to self-host SVGEdit by running `npm i` and `npm run build` and serving the bundle. A one-click deploy from source gives teams, classrooms and documentation sites their own SVGEdit instance (no account, drawings stay in the browser) without a local Node setup. Without the `Staticfile`, Wasmer's builder (Anybuild v0.33.0) detects Vite and serves `dist/`, which only contains the `editor/` subfolder, so `/` would return 404.

Testing: I replayed the builder's generated steps for `c44f061d2f9a626d2771cc931298af5a45522d87` with this change.
- Detection: static Node.js provider, framework Vite, output directory `dist/editor`. Install ran with the whole tree staged because of the npm workspaces.
- `npm install` exited 0 on Node 24.22.1 with npm 11.21.1.
- `npm run build` exited 0. It builds svgcanvas, then react-test, then the editor, then the `postbuild` copy-static and extension steps.
- Served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here):
  - `/`, `/index.html`, `/iife-index.html` and `/browser-not-supported.html` returned 200.
  - Every `import("./...")` chunk in `Editor.js`, all 144 `images/*` entries and the extension scripts returned 200, 183 URLs in total. The only non-200 was the `images/cursors` directory URL, which returned a 308 redirect.

Limitations: no deployment was made; the badge and the Wasmer import page could not be checked from the test environment. The checks were HTTP-level only. The button opens Wasmer's import page for this public repository, where you review the configuration and click Deploy; it does not create a copy of the repository in your GitHub account.

## Checklist

- [ ] - Added Cypress UI tests (not applicable: README and hosting config only)
- [ ] - Ran `npm test` (not run: no source change; the build was verified as described above)
- [x] - Added any user documentation.
