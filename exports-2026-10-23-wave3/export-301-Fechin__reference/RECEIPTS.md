# Receipts: Fechin/reference (NN 301)

Verdict: READY. Open items to accept in review (all disclosed in PR_BODY Limitations): nginx's generic `@html` redirect for missing `.html` files and the custom 404 page (`oops.htm`) are not reproduced; copies keep `url: https://cheatsheets.zip` (canonical/OG/prefetch) unless the deployer changes it. Checked 2026-10-23.

## Source (`source-check.txt`, `patch-checks.txt`)
- Fresh `git clone --filter=blob:none` 2026-10-23T02:37Z: `main` HEAD `6fe843f01a81a2f87279eb629a806f318e6a4d72` (2026-10-14) equals the root-supplied pin.
- Root note corrected: `public/` is NOT committed (`git ls-files public` = 0; `.gitignore:74 public/`). A no-build Staticfile deploy is impossible; the build (`pnpm install && pnpm run build`, as in the `Dockerfile`) is required.
- Patch: `README.md` +10 (subsection under "Live Demonstration"), new `_redirects` (1 comment + 4 rules). `git apply --check` exit 0 on clean HEAD; `git diff --check` exit 0; 0 trailing-whitespace lines. sha256 `91b4de57e8796211de5dc48a14515e2ba7ddfae1af9ae087421ab107ffa8703e`.

## Policy (`policy-files.txt`, `hook-checks.txt`)
- No CONTRIBUTING, AGENTS.md, CLAUDE.md, `.cursorrules`, copilot-instructions, PR template, CLA or AI-PR rule. `.github` has only FUNDING.yml and an issue template.
- README: "feel free to submit a [pull request]"; "Submit a pull request and wait for it to be reviewed and merged."
- Hooks (untouched): pre-commit `npx lint-staged` (prettier --write on *.md), commit-msg `npx commitlint`. Run here: `prettier --check README.md` exit 0 (3.5.3, also exit 0 on HEAD copy); commitlint on PR_TITLE exit 0; `pnpm run lint:check` exit 0; `pnpm run format:check` exit 1 on patched AND on unmodified HEAD (27 pre-existing files each; README.md/_redirects not listed).
- Activity: 8 merged PRs since 2026-07-01 (latest #800, 2026-10-14). License GPL-3.0.

## Duplicate check (`duplicate-check.txt`, `dupcheck.sh`)
- 314 PR head refs fetched (= 314 advertised by `ls-remote`; highest #801). `--grep=wasmer` 0; `--author=wasmer/ayush` 0; README.md mentioning wasmer: 0/314. No existing Wasmer PR.

## Plan and build (`plan.txt`, `plan.json`, `replay.log`, `sws.toml.generated`)
- Anybuild v0.33.0 (`--temp-anybuild`; no committed Anybuild): static Node.js, Hexo, pnpm 10, `static_dir=public`; `_redirects` rendered to 4 `[[advanced.redirects]]` kind 301; start adds `--config-file=/opt/static_config/sws.toml`.
- Node 24.22.1, pnpm 10.34.7: `pnpm install` exit=0 (replay.log:110; 1259 pkgs; husky prints ".git can't be found"; ignored build scripts hexo-util, javascript-obfuscator). `pnpm run build` exit=0 (replay.log:805; "650 files generated").

## URL semantics (`compare-nginx-vs-sws-*.txt`, `compare.sh`, `nginx-oracle.conf.in`, `urls.txt`)
- Oracle: nginx 1.24.0 (Ubuntu deb, extracted, not installed) with upstream `nginx.conf`, changing only user/paths/port/temp dirs; same build; 71 requests, `curl --path-as-is`, no redirect following.
- Without config (unmodified build): same=47 diff=24; `/golang` 404, `/golang.html` 404, `/css` 308 -> `/css/` -> 404, `/css.html` 404.
- With `_redirects`: same=51 diff=20. All 4 rename redirects match nginx (status 301 + Location path). Remaining diffs: 13 trailing-slash sheet forms 200 vs nginx 404; `/about`,`/notes` 308 vs 301; `/about.html`,`/nope.html` 404 vs 301 (generic `@html` rule; would need a catch-all, not added); `/css/` 404 vs 403; 2 traversal 404 vs 400. 404 body: SWS default (106 B) vs `oops.htm` (4039 B).
- Native SWS 2.38 without config already serves `/x` from `x.html` and `/index` (no rewrite needed for extensionless URLs).

## HTTP (`http-receipts.txt`, `serve_and_check.sh`, `http.sh`, `smoke.txt`; SWS 2.38.0 + generated sws.toml)
- 650/650 build files 200 (227 text/html, 18 text/css, 3 text/javascript, 3 application/json, 187 PNG, 208 SVG, text/xml, text/plain, text/markdown, `style.tailwindcss` octet-stream). `/nope`, `/assets/nope.js` 404.
- Internal links from all built HTML: 237 unique, 236 200, `/atom.xml` 404 (also 404 on nginx oracle).
- No analytics tags in the built HTML (0 files; `external-refs.txt`). 226 pages carry canonical + prerender to https://cheatsheets.zip.

## Browser (`playwright.txt`, `pw.js`, `shot-*.png`; non-127.0.0.1 blocked, SW blocked)
- `/` 200, 229 `.html` links; search: 216 entries on open, "python" -> 12 results, first `/python.html` opens 200; `/golang` chain `[/golang -> 301]` final `/go` 200 (18 h2, 87 code blocks); `/css` and `/css.html` end at `/css3`. Local 4xx/5xx: none. Blocked: cheatsheets.zip 5, api.github.com 5, cdn.jsdelivr.net 4. Console: blocked loads, GitHub-stars warning, malformed SVG `d` attributes (upstream markup).

## Claims table (PR_BODY.md)
| Claim | Receipt |
|---|---|
| HEAD `6fe843f`, current `main`; `public/` gitignored | source-check.txt |
| Dockerfile/nginx.conf build+serve | policy-files.txt |
| Hexo / pnpm 10 / `public` / 4 rules kind 301 / `--config-file` | plan.txt, plan.json, sws.toml.generated |
| Node 24.22.1, pnpm 10.34.7, 1259 pkgs, install/build exit 0, 650 files | replay.log |
| SWS 2.38.0 native | replay.log, http-receipts.txt |
| 650/650 200 + MIME; `/nope`, `/assets/nope.js` 404 | http-receipts.txt |
| 237 internal links, 236 200, `/atom.xml` 404 also on nginx | http-receipts.txt, compare-nginx-vs-sws-with-redirects.txt |
| nginx 1.24.0 oracle, 71 requests, 12 sheets, redirects match, negatives, 20 diffs | compare-nginx-vs-sws-with-redirects.txt, urls.txt, nginx-oracle.conf.in |
| Without `_redirects`: `/golang` 404, `/css` -> `/css/` 404 | compare-nginx-vs-sws-unmodified.txt |
| Playwright 1.56.1: 229 links, search 216/12, `/golang` -> `/go` 18/87, `/css` | playwright.txt |
| prettier/lint/commitlint/format:check 27 pre-existing | hook-checks.txt |
| `url: https://cheatsheets.zip`; 23 pages LiveCodes/KaTeX; api.github.com | external-refs.txt; playwright.txt |
| pnpm ignored build scripts | replay.log:104 |
| GPL-3.0 | policy-files.txt (LICENSE) |
