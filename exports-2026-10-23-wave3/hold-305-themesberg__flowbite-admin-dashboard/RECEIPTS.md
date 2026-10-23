# 305 themesberg/flowbite-admin-dashboard: HOLD (2026-10-23)

## Source
- Fresh `git clone --filter=blob:none`, `main` HEAD `229df7ff25808ab2bbda65f03f2397a05f7b4288` (2025-03-20). It matches the pin.
- No export was made. `candidate.diff` records the tested candidate (Anybuild + 2 template lines + README). It is not proposed while the upstream build is broken.

## Policy (policy-files.txt, config-excerpt.txt)
- No CONTRIBUTING, AGENTS.md, CLAUDE.md, `.cursorrules`, `.github/`, PR template, CLA or AI rule.
- README: GitHub Issues is the bug tracker, and questions go to flowbite.com/contact.
- The only "Merge pull request" in history is #20, an internal branch. The last commit is 2025-03-20, so acceptance is uncertain.

## Duplicates (duplicate-check.txt)
- 9 PR refs in all states. `--grep=wasmer`: none. `--author=wasmer/ayush`: none. README.md wasmer hits: 0 of 9.

## Detection and auto-plan replay (auto-*.txt, auto-hugo-output.txt)
- Anybuild 0.33.0 detects the **Hugo provider** (hugo 0.153.2) with build `hugo --gc --minify` and static_dir `public`. There is no npm or webpack step.
- **static_dir mismatch.** `config.yml` sets `publishDir: "_gh_pages"`. hugo.rs reads publishDir only from `hugo.{toml,json,yaml,yml}`, not `config.yml`. Hugo writes `_gh_pages/` (exit 0), then `cp -R public/.` fails with "cannot stat" (exit 1). Nothing is deployed.
- Even if that copy worked, the output would have no `app.css` or `app.bundle.js`: they are webpack outputs and gitignored (`static/*.js`, `static/*.css`). Also, `baseURL` is vercel.app and `canonifyURLs: true`, so index.html carries 47 `https://flowbite-admin-dashboard.vercel.app/...` refs. Links and images would point at the upstream demo.

## Node path (candidate-*.txt, candidate-Dockerfile.generated)
- A committed `Anybuild` (nodestatic, npm 11, build `npm run build:webpack && hugo --destination=./public --baseURL=/`, `build_pre = [use(dep("hugo", "0.153.2"))]`) plans OK.
- The generated Dockerfile installs `ubi:gohugoio/hugo[matching=extended]@0.153.2` via mise before the node build. Hugo is not in npm deps (0 `hugo` lines in package-lock.json), so the Node provider alone has no Hugo.
- `--baseURL=/` also needs a template fix: `{{ .Site.BaseURL }}/app.css` and `/app.bundle.js` would become `//app.css` (protocol-relative). Changing them to `relURL` (2 lines) keeps the Vercel output the same.
- Replay (Node 24.22.1, npm 11.21.1): `npm install` exit=0 (810 packages, 97 advisories). The **build exits 1**.

## Controlling fact: the upstream production build is broken at HEAD (webpack-build-failure.txt)
- `npm run build:webpack` (`webpack --mode=production`) exits 1 on Node 24.22.1, 22.22.0 and 20.20.0. With the minimizer in-process the error is: `JisonLexerError … infinity * 1px` from postcss-calc 8.0.0 (cssnano 5.0.12, via css-minimizer-webpack-plugin 3.4.1) parsing Tailwind 4.0.0 output. yarn.lock pins the same versions. This is a pre-existing upstream bug, independent of Wasmer, so the repo's own `npm run build` cannot succeed.
- Fixing it needs a dependency/build-config change, not a deploy-button change. Shipping a `--mode=development` bundle as a workaround is not proposed.

## Diagnostic only (diag-build.txt, diag-http-receipts.txt)
- With `webpack --mode=development` (exit 0) plus the planned Hugo step (exit 0, 19 pages), served by native SWS 2.38.0:
  - All 17 content URLs (the README's 15 example pages plus home and layouts/sidebar) return 200 `text/html`.
  - All same-origin assets referenced from built HTML and CSS return 200 with correct types. 81 x 200 in total, plus 16 x 308 slash redirects for the no-slash forms.
  - 9 x 404: `/does-not-exist`, `/crud/nope/`, `/package.json`, `/config.yml`, `/_gh_pages/` and their variants.
- External scripts: buttons.github.io and cdn.jsdelivr.net (simple-datatables).

## Verdict: HOLD
- Exact reason: no build path yields the site at HEAD. Auto-detect (Hugo) copies a non-existent `public/` and skips webpack. The Node/webpack path that the README documents (`npm run build`) fails in production mode on the committed lockfile (Tailwind 4 `calc(infinity*1px)` vs postcss-calc 8.0.0).
- Unblock: upstream fixes the production build (e.g. a newer css-minimizer/cssnano). Then `candidate.diff` (Anybuild + 2-line relURL fix + README) is the expected minimal change; re-run the replay to confirm.
