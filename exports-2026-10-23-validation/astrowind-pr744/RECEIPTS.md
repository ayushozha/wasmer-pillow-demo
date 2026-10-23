# onwidget/astrowind PR #744: exact-head validation receipts

Local, read-only. Nothing was written upstream and nothing was deployed. Paths are written relative to `$S` (the scratch dir).

## Identity
- Expected head: `refs/pull/744/head` = `deb589391de4e2366a5cc4a6c0ebd52f545f06e8` (`git ls-remote`, ls-remote.txt).
- `git rev-parse HEAD` in the fresh clone = `deb589391de4e2366a5cc4a6c0ebd52f545f06e8`. **Verified** (git-receipts.txt, agents-checks.log).
- **pr.json / pr-files.json could not be obtained.** This session's egress proxy answers api.github.com and github.com/…/pull/744(.patch) with 403 "GitHub access to this repository is not enabled for this session" (raw: api-refusal-pr.json, api-refusal-pr-files.json). I did not attach credentials (push access) to get around it. So the expected SHA comes from the public git ref and not from the API.
- Base branch: `main`, from GitHub's test-merge ref `refs/pull/744/merge` = 5d5422e2, whose parents are `14e1a691` (main) and `deb58939` (head). main = `14e1a691f80548dcc36370847b1a02c0d0b12821`, which is also the merge-base. arthelokyo/astrowind main has the same SHA (link-checks.txt).
- 1 commit: `deb58939 Ayush Ojha "docs: add Deploy to Wasmer option"`.

## Changed files (`git diff --name-status 14e1a691..HEAD`)
| file | status | blob at head | blob at base |
|---|---|---|---|
| README.md | M (+6/-0) | d73b1891d35252c549f453b25954713da2e565ea | d0ef70ca4bf235636be1b2d865d947e28c304e24 |

- Lockfile `package-lock.json` blob is 56aaebeb10995585ae948e398a26b8e5f591293f at both base and head. `package.json` is c8dbf155… at both. `.github/` tree is 75b489e4… at both. AGENTS.md is 4bfd82a9… at both.
- Hooks: there is no `.husky/`, lefthook, simple-git-hooks, `.pre-commit-config.yaml` or `.githooks`, no hooks/prepare/lint-staged entry in package.json, and no `core.hooksPath`. The PR has none to remove or alter. Its diff touches only README.md.

## Repo instructions followed (AGENTS.md at head, lines 116-123; CLAUDE.md just points to AGENTS.md; there is no CONTRIBUTING)
> After changes, always verify:
> 1. `npm run build` succeeds
> 2. `npm run check` passes (astro check + ESLint + Prettier)
> 3. Visual check in browser: homepage, blog, dark mode, mobile menu
> 4. Structured data describes the site it is on: … (n/a: the PR does not touch src/)

Package manager is npm, from package-lock.json. CI (.github/workflows/actions.yaml) runs `npm ci` → `npm run check`, then `npm ci` → `npm run build`. The engine requirement is `node >=22.22.3`. The host has 22.22.0, so I used Node v24.22.1 with npm 10.9.4.

| check | exit | receipt |
|---|---|---|
| `npm ci` | 0 | agents-checks.log |
| `npm run check` (astro check 0 errors/0 warnings/0 hints on 108 files; eslint; prettier "All matched files use Prettier code style!") | 0 | agents-checks.log |
| `npm run build` | **1** | agents-checks.log |
| `git status --porcelain` afterwards | 0 (clean) | agents-checks.log |

Why the build failed: `api.fontsource.org` returned ENOTFOUND, so the Inter font got "No data found". The fatal error is `FailedToFetchRemoteImageDimensions` for `https://cdn.pixabay.com/photo/2017/02/03/01/56/smartphone-2034330_1280.png` while rendering `/homes/mobile-app`. Both hosts are blocked by this sandbox (curl through the proxy gives CONNECT 403). The build needs outbound network at build time. That is an environment limitation here and is not caused by the PR, since only README.md changed. Still, a **successful build was not observed**.

## Visual checks (views.js, Playwright Chromium; every non-127.0.0.1 request was aborted)
1. **Against the built output (native SWS 2.38.0, replay static_app):** all 6 views returned **404**, because the failed build emitted no `/`, no blog and no posts (views-sws-partial-build.json). Their screenshots were discarded because they only showed the 404 page.
2. **Fallback: `astro dev` (AGENTS.md's documented `npm run dev`, here run as `npx astro dev --host 127.0.0.1 --port 4321`). This is a dev server and not the built output.** Results are in views-dev.json:

| view | viewport | HTTP | result | console errors | blocked origins | shot |
|---|---|---|---|---|---|---|
| homepage `/` | 1280x800 | 200 | renders | 2 (ERR_FAILED = aborted externals) | img.shields.io | shot-dev-home.png (hero caught mid fade-in) |
| blog index `/blog` | 1280x800 | 200 | renders | 6 (aborted externals) | images.unsplash.com, img.shields.io | none |
| blog post `/get-started-website-with-astro-tailwind-css` | 1280x800 | 200 | renders | 2 | images.unsplash.com, img.shields.io | shot-dev-blog-post.png |
| dark mode via toggle `[data-aw-toggle-color-scheme]` | 1280x800 | 200 | `html.dark`=true, body rgb(8,9,10) | 1 | img.shields.io | shot-dev-dark-toggle.png |
| dark via prefers-color-scheme | 1280x800 | 200 | `html.dark`=true | 1 | img.shields.io | none |
| mobile menu | 390x844 | 200 | menu opens (aria-expanded=true), no horizontal overflow | 0 | none | shot-dev-mobile-menu.png |

There were no page (JS) errors. On first load the home view had ERR_ABORTED on local `/node_modules/.vite/deps/*` dev-toolbar requests. That is dev-server dependency optimisation and not site code.

## Anybuild v0.33.0 replay (`replay.sh <clone> val-astrowind 3901 …`)
- Plan (plan.txt, plan.json): "Detected static Node.js provider, Framework: Astro, Package manager: npm, Output directory: dist". `install='npm install'` (not `npm ci`), `build='npm run build'`, `static_dir=dist`, npm_version 11, node_install_inputs `[package.json]` plus the lockfile.
- replay.log: `npm install` exit=0. `npm run build` **exit=1, "BUILD FAILED"**, with the same two causes as above. static_app holds the **partial** output: 109 files (404.html, about/, contact/, decapcms/, robots.txt, `_astro/*`, and 92 `.prerender/*.mjs` server chunks).
- smoke.txt: SUMMARY pages=8 refs_checked=6 failures=6.

## HTTP receipts (http-receipts.txt)
These were served with a local native static-web-server 2.38.0 (the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, which was not tested here). The root was the partial static_app.
- 404: `/`, the blog post, `/blog`, `/rss.xml`, `/sitemap-index.xml`, and the missing path `/definitely-missing-k93xq7`. The missing path → 404 is correct, served with the custom 404.html body (7899 B).
- 200 text/html: `/404`, `/404.html`. `/about` and `/contact` → 308 (trailing-slash redirect). `/robots.txt` → 200 text/plain.
- Assets referenced by the built HTML: 9 refs were enumerated. 6 are real assets and all are **200 with correct MIME**: 2 × text/javascript, 1 × text/css, image/svg+xml, image/png, image/x-icon. The other 3 refs are page links (2 posts and the sitemap), which return 404 because those pages were not built.
- `/.prerender/prerender-entry.*.mjs` returned 200 application/javascript (279 KB). A failed or partial build left server chunks in the publicly served dir.

Untested gaps: the WASI SWS 1.1.0 package (2.32.2, no page fallback); its custom-404 and trailing-slash 308 behaviour; precompressed files; any success-path HTTP (there was no successful build). The static build calls out to these optional externals: img.shields.io, images.unsplash.com, and at build time api.fontsource.org and cdn.pixabay.com. A Wasmer builder would need egress to those hosts at build time.

## Claims
The PR body was **not retrievable** (API blocked), so every body-only claim (versions, "tested" statements, counts) is **unverified**. Below are the claims made by the added README text:

| claim | status |
|---|---|
| "Build AstroWind with `npm run build`" | verified as the documented command (package.json, AGENTS.md, Anybuild plan). The build itself **failed here** (sandbox egress), so it was not shown end to end. |
| "serve the generated `dist` directory" | verified: outDir is `dist` (Astro build log, plan static_dir=dist) |
| button target `wasmer.io/apps/create?github=arthelokyo%2Fastrowind` opens the template's import page | unverified (wasmer.io blocked, 403) |
| repo slug `arthelokyo/astrowind` | verified: it matches the existing Vercel button and has the same main SHA as onwidget/astrowind |
| badge `img.shields.io … logo=wasmer` renders | unverified (blocked) |
| docs link `docs.wasmer.io/edge/` | unverified (blocked) |
| "Wasmer Edge is a cloud platform for hosting websites…" | unverified (marketing text) |
| PR changes only docs | verified: README.md is the only file, +6/-0 |

## Files
RECEIPTS.md, git-receipts.txt, ls-remote.txt, api-refusal-pr.json, api-refusal-pr-files.json, agents-checks.log, dev-server.log, views.js, views-dev.json, views-sws-partial-build.json, shot-dev-{home,blog-post,dark-toggle,mobile-menu}.png, plan.txt, plan.json, replay.log, smoke.txt, replay-static_app-filelist.txt, http-receipts.txt, asset-list.txt, sws-http.log, link-checks.txt.
