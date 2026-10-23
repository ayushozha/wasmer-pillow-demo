# Advisory applicability: markhorn-dev/astro-sphere (NN=09)

Repo HEAD `f7e3a40f20e1267d7fbbb7b6dd868df1845e1d82`. Fresh clone at `$S/val2-src/aud-astro-sphere`. Read-only: no dependency, source or lockfile changes were kept, and nothing was written upstream.
Toolchain matches the Anybuild replay: node v24.22.1, npm 11.21.1, `CI=true npm install --no-fund`, then `npm run build` (`astro check && astro build`).

## Install and lockfile (meta.txt, install.log)
- `package-lock.json` exists in the repo, and `npm install` respects it. Exit status was 0.
- `npm install` **did modify** the lockfile: `git diff --stat` shows 1025 insertions and 28 deletions. In detail, **no pre-existing lock entry changed version**. 61 entries were added, all of them optional per-platform binaries (`@esbuild/*`, `@img/sharp-*`, `@emnapi/runtime`, ...). One entry, `node_modules/prettier`, was dropped. The resolved tree is therefore the lock as committed (checked with summary.txt, line 1).
- npm 11 skipped the install scripts of `esbuild@0.21.5` and `sharp@0.33.5` (allowScripts), the same as in the replay. sharp still runs through the prebuilt `@img/sharp-linux-x64` package.
- Counts: `npm audit --json` gives 39 vulnerabilities (3 critical, 25 high), matching Anybuild. The summary printed at install time said 40/26 high, a drift of one in highs; the 3 criticals are the same in both. `--omit=dev` returns an identical result (39/3/25) because the repo lists every package under `dependencies` and has no `devDependencies`. The dev/prod flag therefore does not separate build tooling from runtime here; what does separate them is the dist evidence below.

## Build (build-excerpt.log, build.full.log)
- `npm run build` exit 0: "17 page(s) built", `[@astrojs/sitemap]`, `/rss.xml` prerendered, 1 image optimized (`spongebob…webp`).
- Output is fully static: astro.config has no `output` and no `adapter`, and dist contains no `entry.mjs`, server directory or node_modules. The deployment serves dist/ with static-web-server, so **no Node runs at runtime**.

## What ships (dist-grep.txt)
dist holds 17 html, 13 js, 1 css, 3 xml (rss and sitemaps), and images and fonts. The JS consists of the Solid client runtime chunk `_astro/web.*.js`, the site's own islands (`Counter`, `Search`, `SearchBar`, `SearchCollection`, `client`), two Astro `hoisted.*.js` scripts and five hand-written `public/js/*.js` files.
Searching all dist js/html/xml returned **0 files** for every one of these strings: `seroval`, `fromJSON`, `fast-xml-parser`, `XMLParser`, `XMLBuilder`, `sharp`, `libvips`, `libheif`, `avif`, `astro/dist`, `devalue`, `fast-uri`, `js-yaml`, `postcss`, `rollup`, `vite`, `esbuild`, `picomatch`, `micromatch`, `minimatch`, `braces`, `browserslist`, `source-map-js`, `node:`/`require("fs")`, `process.env`. Source maps were not enabled because that would need a config edit. The generic words `glob`/`yaml` only match blog prose and an icon id.

## Criticals

| # | package@version | GHSA (critical) | title | dependency path (npm explain) | dev/prod | in dist | applicability |
|---|---|---|---|---|---|---|---|
| C1 | astro@4.16.18 | GHSA-26w7-cxv4-gfx2 (<7.2.8) | Astro: Remote code execution through AVIF image optimization | root `astro@^4.4.13` (direct) | prod (no dev split) | **no** | build-time only; not triggered (see below) |
| C2 | fast-xml-parser@4.5.3 | GHSA-m7jm-9gc2-mpf2 (>=4.1.3 <4.5.4) | entity encoding bypass via regex injection in DOCTYPE entity names | root → `@astrojs/rss@4.0.11` → `fast-xml-parser@^4.5.0` | prod (no dev split) | **no** | build-time only; parser never invoked |
| C3 | seroval@1.2.1 | GHSA-mv8w-475r-vwqw (<=1.5.2), GHSA-p6vx-979v-rg4c (>=0.12.0 <=1.6.0) | `fromJSON()` Promise resolver/thenable type confusion invokes attacker-controlled methods | root → `solid-js@1.9.5` → `seroval@^1.1.0` (also via `seroval-plugins@1.2.1`) | prod (no dev split) | **no** | build-time SSR only; `fromJSON` never called |

Notes: the full advisory text could not be fetched. Both api.github.com/advisories and osv.dev are blocked from this session, so the reasoning below rests on the advisory titles, the affected ranges and the installed code.

- **C1 astro (AVIF RCE).** Static builds run astro's image pipeline (sharp) only on images the repo itself imports. The repo tracks no `.avif`, `.heic` or `.heif` files. Nothing in src or astro.config mentions `avif`, and astro.config sets no `image.domains` or `remotePatterns`. The build log shows exactly one image processed, a webp. The `/_image` endpoint exists only with an SSR adapter; there is none here. The input to the build is the deployer's own repo content, and astro runs nowhere at runtime. The other high advisories on astro (server islands XSS, Host-header SSRF, slot-name XSS) all need an SSR server, which this deployment does not have.
- **C2 fast-xml-parser.** Its only importer is `@astrojs/rss/dist/index.js`. That file calls `XMLParser.parse` only for `customData`, `source` or `enclosure` (lines 129–172), and the repo's `src/pages/rss.xml.ts` passes none of them. The parser therefore never runs. The output side uses `XMLBuilder` on the repo's own frontmatter, and the result is the static `dist/rss.xml`.
- **C3 seroval.** It is imported only by `solid-js/web/dist/server.{js,cjs}` (`Feature, Serializer, getCrossReferenceHeader`), which serializes during SSR. Nothing outside seroval calls seroval's `fromJSON`/`fromCrossJSON`: the matches buildtime-usage.txt lists are postcss, babel and jsonrpc functions of the same name. The client runtime chunk contains no seroval code: 0 matches for `seroval` and `fromJSON`. Islands hydrate from Astro's own props serialization.

## Highs (25), all prod-flagged and all absent from dist (highs-table.md)
@astrojs/check@0.5.10 · @astrojs/language-server@2.15.4 · brace-expansion@2.0.1 · braces@3.0.3 · browserslist@4.24.4 · chokidar@3.6.0 · devalue@5.1.1 · fast-glob@3.3.3 · fast-uri@3.0.6 · find-yarn-workspace-root2@1.2.16 · glob@10.4.5 · http-cache-semantics@4.1.1 · js-yaml@3.14.1/4.1.0 · lodash@4.17.21 · micromatch@4.0.8 · minimatch@9.0.5 · nanoid@3.3.11 · picomatch@2.3.1/4.0.2 · postcss@8.5.3 · preferred-pm@4.1.1 · rollup@4.40.0 · sharp@0.33.5 · source-map-js@1.2.1 · tailwindcss@3.4.17 · vite@5.4.18.
All of them are build, CLI, dev-server or type-check tooling: ReDoS/DoS on globs and YAML, the vite dev-server `fs.deny` bypass, the rollup output path traversal, postcss sourceMappingURL reading, the glob CLI `-c`, the libvips/libheif/librsvg bugs in sharp, and the lodash `_.template` in yaml-language-server. Each one acts on repo content at build time or is never invoked. None appears in dist. The GHSA IDs and introducers are in highs-table.md and the full trees are in explain.txt.

## Files
audit.json, audit-omit-dev.json, summary.txt, explain.txt (`npm explain` for all 3 critical and 25 high packages), meta.txt, install.log, build-excerpt.log, build.full.log, dist-grep.txt, buildtime-usage.txt, highs-table.md.

## Verdict
**Not HOLD.** All three criticals are build-time tooling and are not emitted, and the static runtime runs no Node. None of the three ships to the browser (0 dist matches for each). None is reachable by untrusted input at runtime, because the deployment is static files served by static-web-server. At build time, the AVIF path has no AVIF inputs, the vulnerable XML parse is never called, and seroval only serializes, so `fromJSON` is never called.
