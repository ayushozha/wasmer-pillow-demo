Title: docs: add Wasmer Edge deploy option

I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository’s static site. References: [Wasmer Edge docs](https://docs.wasmer.io/edge/), [Git deployments](https://docs.wasmer.io/edge/git/).

## Summary

Based on the current dev branch, `DeadSpace` (`88aecff`), as the README asks. The PR has no generated JS/CSS. It changes two files:

- `README.md`: a short "Wasmer Edge" section after the Docker section. It has a "Deploy to Wasmer" badge that links to `https://wasmer.io/apps/create?github=pmotschmann%2FEvolve`, plus a few lines of guidance:
  - Fork first; the import serves the repository you choose and does not copy it into your GitHub account.
  - The committed game files are served as they are, with no `npm run build`. Rebuild and commit `evolve/` and `wiki/` in your fork after changing the source.
  - Saves are kept in each player's browser for that site; use Export/Import to move a save.
  - The pages include this project's Google Analytics tag (`G-CPC46V71CB`); change or remove it in a fork.
- `Staticfile` (new, one line: `root: .`): tells Wasmer's build detection to serve the repository root as static files.

## Why this repository

Evolve keeps the built game in the repository (`evolve/main.js`, `evolve/evolve.css`, `evolve/save-codec.js`, `wiki/`), and the README already documents self-hosting through a gh-pages fork deploy or Docker. That means a copy can be served as plain static files without any build.

Without the `Staticfile`, Wasmer's detector picks a Node server: it plans `npm run build`, which fails on Node 24, and then a `node src/index.js` start command, and `src/index.js` is browser code. The one-line `Staticfile` avoids that. The README text covers the two things that differ from the official site for anyone hosting their own copy: the analytics ID, and per-site browser saves.

## Testing

- Base: `DeadSpace` @ `88aecff2c5ff7b1136e3c3e1db5c786ca79b250c`. The patch also applies cleanly to `master` @ `3436358`.
- I ran Anybuild 0.33.0's `anybuild plan` on clean checkouts:
  - `DeadSpace` without this PR: provider `node`, build `npm run build`, start `node src/index.js`.
  - `DeadSpace` with this PR: provider `staticfile`, static dir `.`, no install or build.
  - `master` gives the same two results.
- I replayed the planned steps in a clean directory. The unpatched plan's `npm run build` fails on Node 24, because the `node@^16` dependency puts Node 16.6.1 on the scripts' PATH and npm 11 refuses to run under it. The patched plan has no build step.
- I served the patched result with static-web-server 2.38.0 using Anybuild's flags. All of these returned 200: `/`, `/index.html`, `/wiki.html`, `/save.html`, `/evolve/main.js`, `/evolve/evolve.css`, `/evolve/save-codec.js`, `/wiki/wiki.js`, `/wiki/wiki.css`, `/strings/strings.json`, `/strings/strings.ja-JP.json`, `/strings/strings.zh-CN.json`, `/lib/lz-string.min.js`, `/lib/fflate.min.js`, `/lib/buefy.min.0.9.22.css`, `/font/weathericons-regular-webfont.eot` and `/evolved.ico`. An unknown path returned 404. The local reference checks found 0 missing references.
- For comparison, I ran the normal build with the Dockerfile's toolchain (Node 16.20.2, npm 8.19.4, `npm install && npm run build`; `npm ci` rejects the current lockfile). On `DeadSpace` it reproduced every committed file in `evolve/` and `wiki/` byte for byte.

## Limitations

- I did not deploy to Wasmer. Only the local static serving above was tested.
- The import link builds the default branch (`master`). This change reaches `master` when `DeadSpace` is merged for the 1.5 release. Until then, importing `master` hits the Node detection described above.
- Redeploy-on-push needs your own fork connected. A fork has to commit rebuilt `evolve/` and `wiki/` files for source changes to show up, just like the gh-pages deploy.
- The whole repository root is served, so `src/`, `package.json`, `Dockerfile`, `debug.html` and similar files are publicly reachable.
- Runtime requests to third parties are the same as on the official site:
  - unpkg.com (Vue, Buefy, Popper, Sortable, Chart.js) and Google Fonts;
  - Google Analytics;
  - the periodic version check against `https://pmotschmann.github.io/Evolve/package.json`.
- The badge image is served by shields.io.
