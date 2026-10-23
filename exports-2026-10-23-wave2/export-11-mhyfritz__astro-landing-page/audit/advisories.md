# Advisory applicability: mhyfritz/astro-landing-page (NN=11)

Repo HEAD `987617a50863d31bb865ee531391a191d74a878a`. Fresh clone at `$S/val2-src/aud-astro-landing-page`. Read-only: no dependency or source changes, and nothing written upstream.
Toolchain matches the Anybuild replay: node v24.22.1, npm 11.21.1, `CI=true npm install --no-fund`, then `npm run build` (`astro build`).

## Install and lockfile (meta.txt, install.log)
- `package-lock.json` exists in the repo and was respected. **`npm install` did not modify it**: `git diff --stat` is empty, and no lock entry was added, removed or changed version (summary.txt, line 1). Install exited 0 with 509 packages.
- Counts: `npm audit --json` gives 39 (3 critical, 27 high), the same as Anybuild. `npm audit --omit=dev --json` gives 15 (**0 critical**, 13 high). All three criticals are in the devDependencies tree. Note that Anybuild's `npm install` still installs dev deps and uses them for the build.

## Build (build-excerpt.log, build.full.log)
- `npm run build` exited 0: "1 page(s) built". 25 images were optimized to webp; the source files are png and jpg under src/.
- Output is fully static: astro.config has no `output` and no `adapter`, and dist has no `entry.mjs`, server or node_modules. The site is served by static-web-server, so **no Node runs at runtime**.

## What ships (dist-grep.txt)
dist holds 1 html, 1 css, **1 js** (`_astro/hoisted.*.js`, 9.2 KB: the site's hoisted script bundling `micromodal`, a prod dep that is not flagged), 25 webp, 1 jpg, 1 svg and 7 woff2.
Every distinctive string returns 0 files except `micromodal`. That includes `astro/dist`, `form-data`, `FormData`, `axios`, `node-tar`/`Unpack`, `extract-zip`, `svgo`, `sharp`, `avif`, `devalue`, `vite`, `rollup`, `postcss`, `undici` and `process.env`.

## Criticals

| # | package@version | GHSA (critical) | title | dependency path (npm explain) | dev/prod | in dist | applicability |
|---|---|---|---|---|---|---|---|
| C1 | astro@4.16.14 | GHSA-26w7-cxv4-gfx2 (<7.2.8) | Astro: Remote code execution through AVIF image optimization | root devDep `astro@^4.16.14` | **dev** | **no** | build-time only; not triggered |
| C2 | form-data@4.0.1 | GHSA-fjxv-7rqg-78g4 (>=4.0.0 <4.0.4) | form-data uses unsafe random function for choosing boundary | root dev `astro-icon@1.1.4` → `@iconify/tools@4.0.7` → `axios@1.7.7` → `form-data@^4.0.0` | **dev** | **no** | build-time; never exercised |
| C3 | tar@6.2.1 | GHSA-23hp-3jrh-7fpw (<=7.5.18) | node-tar: Decompression/parse DoS via unlimited input | root dev `astro-icon@1.1.4` → `@iconify/tools@4.0.7` → `tar@^6.2.1` | **dev** | **no** | build-time; never exercised |

- **C1 astro.** This is the same advisory as Sphere C1, but the version here is 4.16.14 where Sphere has 4.16.18, and the path is a devDependency where Sphere's is a dependency. The reasoning is the same and was re-verified for this repo. The repo tracks no `.avif`, `.heic` or `.heif` files, and nothing in src or astro.config mentions avif. The build only optimized 8 repo-owned png/jpg files into webp (build log, buildtime-usage.txt). There is no adapter, so there is no `/_image` endpoint. Astro is absent from the runtime.
- **C2 form-data and C3 tar.** astro-icon imports only `cleanupSVG, importDirectory, isEmptyColor, parseColors, runSVGO` from `@iconify/tools` (loadLocalCollection.js). These run on the repo's own `src/icons/**/*.svg`, plus the installed `@iconify-json/{mdi,fa-brands}` packages, which are read locally. `tar` and `axios`/`form-data` appear only inside `@iconify/tools` download helpers: `downloadNPMPackage`, `downloadGitRepo`, `downloadGitHubRepo`, untar and the figma import. These are loaded because the ESM index re-exports them, but they are never called. The build makes no HTTP multipart request, so the form-data boundary randomness is moot, and it parses no tarball, so the tar DoS is moot. Neither package ships to the browser.

## Highs (27; 13 in the prod tree), all absent from dist (highs-table.md, explain.txt)
@iconify/tools@4.0.7 · astro-icon@1.1.4 · axios@1.7.7 · brace-expansion@2.0.1 · braces@3.0.3 · browserslist@4.24.2 · chokidar@3.6.0 · devalue@5.1.1 · extract-zip@2.0.1 · fast-glob@3.3.2 · find-yarn-workspace-root2@1.2.16 · glob@10.4.5/11.0.0 · http-cache-semantics@4.1.1 · js-yaml@3.14.1/4.1.0 · micromatch@4.0.8 · minimatch@10.0.1/9.0.5 · nanoid@3.3.7 · picomatch@2.3.1/4.0.2 · postcss@8.4.49 · preferred-pm@4.0.0 · rollup@4.27.4 · sharp@0.33.5 · source-map-js@1.2.1 · svgo@3.3.2 · tailwindcss@3.4.15 · undici@6.21.0 · vite@5.4.11.
The 13 prod-tree highs are tailwindcss and its glob chain, postcss, nanoid, source-map-js and sharp. All of these are build-time CSS and image tooling that act on repo content. The one invoked high worth naming is `svgo` (the DOCTYPE entity-expansion DoS): `runSVGO` runs on the repo's own icon SVGs at build time, which is trusted input and only a DoS class of bug. The rest are dev-server, CLI or download paths that the build never calls (vite, axios, extract-zip, undici, glob CLI, rollup path traversal on its own output).

## Files
audit.json, audit-omit-dev.json, summary.txt, explain.txt (all 3 critical and 27 high), meta.txt, install.log, build-excerpt.log, build.full.log, dist-grep.txt, buildtime-usage.txt, highs-table.md.

## Verdict
**Not HOLD.** All three criticals are build-time tooling and are not emitted, and the static runtime runs no Node. They are dev-only (`--omit=dev` reports 0 critical), absent from dist (the only JS shipped is the site's micromodal script), and not reachable by untrusted input. At build time there are no AVIF inputs, and the tar and form-data code paths (the iconify download helpers) are never invoked.
