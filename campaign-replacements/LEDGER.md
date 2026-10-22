# Replacement ledger (static sites) — 2026-10-22

Note: npm targets 02/07/08/09/10/11 were re-run on the exact planned npm 11.21.1 after a harness bug (earlier runs used host npm 10.9.4); superseded logs kept as `replay-npm10-host-superseded.log`.

Qualified = exact Anybuild v0.33.0 flat replay passed (install/build/serve with static-web-server 2.38.0 + smoke) and no policy/security blocker found. Every one still needs root's live import-page and badge check (wasmer.io / img.shields.io blocked here). Button wording everywhere: "opens Wasmer's import page … you review the configuration and click Deploy; it does not create a copy of the repository in your GitHub account."

## Qualified (12)
| Folder | Stars | Verdict | Builder path | Condition / note |
|---|---|---|---|---|
| 04 remvze/moodist | 3.9k | READY (root fork created) | node-static pnpm → dist | all 91 sounds + 121 precache URLs 200; Radio Browser/YouTube optional third parties; sound licences only partly stated (root decision) |
| 07 coreui/coreui-free-vue-admin-template | 3.4k | READY | node-static npm 11.21.1 → dist | hash routing; 96/96 files 200; vite/source-map-js advisories dev/build-only; root import check OK |
| 32 murraco/jekyll-theme-minimal-resume | 554 | **PUBLISHED by root (PR #102)** | jekyll (Ruby 3.4.7, committed Gemfile.lock) | Gulp not run; committed assets used |
| 44 StartBootstrap/startbootstrap-sb-admin-2 | 9.9k | READY (root-approved single probe) | Staticfile `root: .` | wording fixed per root; 404-page behaviour stated without cause |
| 51 estevanmaito/windmill-dashboard | 3.0k | CONDITIONAL | Staticfile `root: public` | ships Chart.js 2.9.3 (GHSA-h68q-55jf-x68w; demo feeds only hard-coded data) + floating Alpine v2 CDN, no SRI; low activity |
| 02 gatsbyjs/gatsby-starter-blog | 3.5k | CONDITIONAL | node-static npm → public | 0 merges in 12 months; earlier vendor deploy PRs closed |
| 08 coreui/coreui-free-react-admin-template | 5.0k | CONDITIONAL | node-static npm, Staticfile `root: build` (outDir) | maintainers must accept the extra file |
| 09 markhorn-dev/astro-sphere | 691 | CONDITIONAL | node-static npm → dist | inactive since 2025-06 |
| 10 Charca/astro-blog-template | 533 | **PUBLISHED by root (PR #26)** | node-static npm → dist | inactive since 2025-03 |
| 11 mhyfritz/astro-landing-page | 679 | CONDITIONAL | node-static npm → dist | inactive since 2024-11 |
| 23 barryclark/jekyll-now | 8.4k | CONDITIONAL | jekyll, no Gemfile → `bundle add jekyll 4.3.0` | no PR merged since 2018; feed/sitemap plugins don't run (README says so) |
| 30 yaoyao-liu/minimal-light | 1.0k | CONDITIONAL | jekyll | repo has never merged a PR |

## Held (technically passing, held by decision)
61 Adrinlol/landy-react-template — POLICY HOLD (owner closed provider-button PR #101). Also excluded by root: github-education-resources/codespaces-project-template-js, gabrielecirulli/2048, flatlogic/react-dashboard.
45 freelancer, 46 resume, 47 creative, 48 agency (StartBootstrap) — root allows one org probe (44) only.
43 ColorlibHQ/AdminLTE — replay passes with `root: dist`, but SECURITY.md says not to deploy demo pages; ask maintainers first.

## Held (real blockers)
01 vitesse, 12 vitesse-lite (pnpm-workspace.yaml not staged; SPA history routes) · 03 doks (Hugo absent in node-static; output dir mismatch) · 05 astro-theme-pure (lockfile pinned to blocked mirror; FAIL_ENV) · 06 porfolio.dev (CC BY-NC) · 21 academicpages (declined by root) · 22 beautiful-jekyll, 24 TeXt, 26 minima, 27 no-style-please, 28 console, 29 yat (Gemfile `gemspec` not staged) · 25 chirpy-starter (auto-generated; contributions go upstream) · 31 mzlogin (no UTF-8 locale in builder) · 33 al-folio (collaborator-only PRs) · 41 hextra (theme root, no `--source`) · 42 hugo-theme-stack-starter (Hugo Modules need Go; Hugo ≥0.157) · 52 minimal-ui-kit/material-kit-react (no SPA fallback) · 53 gatsby-starter-default (SSR/DSG demo pages 404 statically) · 54 devias material-kit-react (Next 15.3.3 security).

## Builder issues found (for wasmerio)
pnpm-workspace.yaml / .npmrc / .yarnrc.yml not staged before install · Gemfile `gemspec` not staged · Jekyll build image lacks UTF-8 locale · `jekyll build` without `bundle exec` (digest conflict) · no SPA fallback (only 301/302 `_redirects`) · Hugo always at repo root, no Go for modules, Hugo 0.153.2 behind themes · Vite `build.outDir` ignored · next-bundle@1.0.0 drops pnpm symlinks (`@swc/helpers`) and Turbopack hashed externals (`shiki-…`), edge routes run as Node (`self is not defined`) · `yarn dlx next-bundle` resolves INIT_CWD to the dlx temp dir.
