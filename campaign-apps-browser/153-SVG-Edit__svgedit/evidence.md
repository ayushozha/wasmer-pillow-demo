# SVG-Edit/svgedit: evidence

**Verdict: HOLD (policy).** The technical path is proven: a Staticfile with `root: dist/editor`, a clean build, and all assets returning 200. The README's contribution section says: "Please let us know by creating an issue or a discussion if you wish to contribute." Under the campaign gate, a repo that asks for an issue or discussion before contributing is a policy HOLD. Hosting is also branded "Thanks to **Netlify**" with a "Deploys by Netlify" badge, which suggests a sponsored hosting relationship. Remaining check: the account owner decides whether to open a discussion first. Do not route around this.

## Repository
- Pinned SHA: `c44f061d2f9a626d2771cc931298af5a45522d87` on `master` (the default branch; PRs merge there).
- Stars / forks: 7,881 / 1,754. Not archived. Last push 2026-08-05 (GitHub API, 2026-10-22).
- License: MIT (`LICENSE-MIT.txt`).
- PR template: `.github/pull_request_template.md`. It has "## PR description" and a "## Checklist" that requires UI tests and `npm test` for features, while "Added any user documentation" is listed as optional/helpful. `PR_BODY.md` follows it.
- There is no CONTRIBUTING file. The README "Contributions" section is quoted above. The README also has "I want to host SVGEdit in my environment" (`npm i`, `npm run build`, "serve from your own web server"), which is where the patch goes.
- Workflows: CodeQL, npm publish, and on-push/on-PR CI. There is no auto-close bot.
- Merged PRs since 2025-10-01: 18. Duplicate `wasmer` PRs: 0. Prior PRs with "deploy" in the title: 0.

## Anybuild detection (v0.33.0)
- Unpatched: static Node.js provider, Vite, output directory `dist` (Vite default, `node.rs:334`). `vite.config.mjs:78` sets `outDir: 'dist/editor'`. The replay (pre-patch) built fine, but `static_app` held only `editor/`, so `/` returned 404.
- Patched: `Staticfile` with `root: dist/editor` sets `static_dir`; node-static still builds (`node_static.rs:202-205`, `260-276`).
- Install inputs: npm workspaces, so `node_install_requires_all_files=true` and the whole tree is copied before install. Installer: npm 11.21.1 with `CI=true NPM_CONFIG_FUND=false`.

## Replay (patched): Node 24.22.1, npm 11.21.1
- `npm install` exited 0. `npm run build` exited 0, and `static_app` holds 370 files.
- Smoke: `/`, `/index.html`, `/iife-index.html` and `/browser-not-supported.html` returned 200, along with all referenced assets.
- Dynamic assets: 183 of 184 URLs returned 200 (all `import("./…")` chunks of `Editor.js`, every `images/*` file, and extension JS). The one exception is the `images/cursors` directory URL, which returned 308.
- Routes: no router; the static HTML entry points listed above. Unknown paths return 404.
- Env vars: none needed for the core editor.

## Security
- Runtime dependencies (lockfile versions): jspdf 4.2.1, i18next 26.3.6, elix 15.0.1, browser-fs-access 0.38.0, svg2pdf.js 2.7.0 and pathseg 1.2.1. All have 0 advisories.
