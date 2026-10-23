# Advisory applicability: treefarmstudio/odyssey-theme (NN=70)

Repo HEAD `d191e5715a2519e25be4629b933189c421b30a1a`. Fresh clone at `$S/val2-src/aud-odyssey-theme`. Read-only: no dependency or source changes, and nothing written upstream.
Toolchain matches the Anybuild replay: node v24.22.1, npm 11.21.1, `CI=true npm install --no-fund`, then `npm run build` (`astro build`).

## Install and lockfile (meta.txt, install.log)
- `package-lock.json` exists in the repo and was respected. Install exited 0 with 545 packages. npm warns that the `.npmrc` setting `shamefully-hoist` (a pnpm option) is unknown, and that warning has no effect.
- `npm install` **modified** the lockfile with 21 deletions: it pruned two extraneous optional-peer entries, `node_modules/astro/node_modules/@types/node@22.6.1` and `node_modules/undici-types@6.19.8`. **No entry was added and no version changed** (summary.txt, line 1), so the resolved tree is the committed lock.
- Counts: `npm audit --json` gives 31 (2 critical, 21 high), matching Anybuild. `npm audit --omit=dev --json` gives **0 vulnerabilities in total**, because every package is a devDependency and the repo has no `dependencies`.

## Build (build-excerpt.log, build.full.log)
- `npm run build` exited 0: "18 page(s) built". **No "generating optimized images" step ran**, so the astro/sharp image pipeline processed nothing. Images are copied as-is from public/.
- Output is fully static: astro.config has no `output` and no `adapter`, and dist has no `entry.mjs`, server or node_modules. The site is served by static-web-server, so **no Node runs at runtime**.

## What ships (dist-grep.txt)
dist holds 18 html, 2 css, 1 xml (sitemap) and images and fonts, plus **4 js**: `lit-html.*.js` (the Lit runtime, not flagged), `astro_scripts/before-hydration.*.js` (Lit hydration support), `client.*.js` (the @astrojs/lit client shim) and `theme-switcher.*.js` (the site's own Lit component). Every distinctive string returns **0 files**, including `astro/dist`, `node-tar`/`Unpack`, `tar` importers, `extract-zip`, `svgo`, `sharp`, `avif`, `devalue`, `vite`, `rollup`, `postcss`, `cross-spawn`, `process.env` and `node:`.

## Criticals

| # | package@version | GHSA (critical) | title | dependency path (npm explain) | dev/prod | in dist | applicability |
|---|---|---|---|---|---|---|---|
| C1 | astro@4.15.9 | GHSA-26w7-cxv4-gfx2 (<7.2.8) | Astro: Remote code execution through AVIF image optimization | root devDep `astro@^4.15.9` | **dev** | **no** | build-time only; image pipeline not run |
| C2 | tar@6.2.0 | GHSA-23hp-3jrh-7fpw (<=7.5.18) | node-tar: Decompression/parse DoS via unlimited input | root dev `astro-icon@1.1.0` → `@iconify/tools@3.0.7` → `tar@^6.2.0` | **dev** | **no** | build-time; never exercised |

Some evidence is shared with the other two repos, and it was re-verified here. **C1** is the same advisory as Sphere (astro@4.16.18) and Landing (astro@4.16.14), but this repo has a different version, 4.15.9, inside the same <7.2.8 range. **C2** is the same advisory as Landing C3, with different versions: Landing has tar@6.2.1 via @iconify/tools@4.0.7 and astro-icon@1.1.4, while this repo has tar@6.2.0 via @iconify/tools@3.0.7 and astro-icon@1.1.0. The astro-icon import line and the iconify download-helper layout are identical, as checked in this repo's node_modules (buildtime-usage.txt).
- **C1 astro.** The repo tracks no `.avif`, `.heic` or `.heif` files. Nothing in src or astro.config mentions avif, and there is no remote image config. The build log shows **no image optimization step**, and with no adapter there is no `/_image` endpoint. Astro is absent from the runtime.
- **C2 tar.** astro-icon imports only `cleanupSVG, importDirectory, isEmptyColor, parseColors, runSVGO` from `@iconify/tools`. Icons come from the installed `@iconify-json/{ic,mdi}` packages and `src/icons/icons.js`. `tar` is imported only by `@iconify/tools` download and untar helpers, which the ESM index loads but never calls, so no tarball is parsed. tar does not ship to the browser.

## Highs (21), all dev and all absent from dist (highs-table.md, explain.txt)
@iconify/tools@3.0.7 · astro-icon@1.1.0 · braces@3.0.3 · browserslist@4.23.3 · cross-spawn@7.0.3 · devalue@5.0.0 · extract-zip@2.0.1 · fast-glob@3.3.2 · find-yarn-workspace-root2@1.2.16 · http-cache-semantics@4.1.1 · js-yaml@3.14.1/4.1.0 · micromatch@4.0.8 · nanoid@3.3.7 · picomatch@2.3.1 · postcss@8.4.47 · preferred-pm@4.0.0 · rollup@4.22.4 · sharp@0.33.5 · source-map-js@1.2.1 · svgo@3.0.3 · vite@5.4.7.
All of these are build, dev-server or CLI tooling, and the ReDoS/DoS findings act on repo content. The vite dev server is not used by `astro build`. extract-zip and the download helpers are never called. sharp is not invoked because no images are optimized. svgo can run through `runSVGO`, but only when astro-icon loads a local SVG collection. `npm audit --omit=dev` reports 0.

## Files
audit.json, audit-omit-dev.json, summary.txt, explain.txt (both criticals and all 21 highs), meta.txt, install.log, build-excerpt.log, build.full.log, dist-grep.txt, buildtime-usage.txt, highs-table.md.

## Verdict
**Not HOLD.** Both criticals are build-time tooling and are not emitted, and the static runtime runs no Node. They are dev-only (`--omit=dev` reports 0 in total) and absent from dist, whose only JS is Lit and the site's theme switcher. Neither is reachable by untrusted input: no image optimization runs and the tar paths are never invoked.
