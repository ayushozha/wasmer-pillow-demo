# 30 yaoyao-liu/minimal-light: READY

## Source
- Fresh `git clone --filter=blob:none` on 2026-10-23, `main` HEAD `dd114c3fef2d97adc1c6b6d46901e0d96ab83a7c` (2026-10-18). Same as the prior pin, so the README patch was re-applied unchanged (patch-checks.txt).
- `upstream.patch` sha256 `af6663e45fed5d9bb5980cf6e2dfabc8304fa49846a4a8e2e10240ba38bedf8f`; `git apply --check` on a clean HEAD exit 0; `git diff --check` exit 0; 0 trailing-whitespace lines.

## Policy (policy-excerpt.txt)
- No CONTRIBUTING, AGENTS.md, CLAUDE.md, .cursorrules, copilot-instructions, PR template, CLA or workflows. No `.github/` directory.
- The only contribution wording is README_zh_Hant.md line 1, which welcomes pull requests that correct that translation. No rule against AI/agent PRs. No lint/test command is required, so none was run.
- Activity: the maintainer commits directly (last 2026-10-18). There are 0 "Merge pull request" commits in history (only 3 "Merge branch" commits, 2020). Disclosed.

## Duplicate check (duplicate-check.txt)
- 26 PR refs fetched. `--grep=wasmer`: 0. `--author=wasmer --author=ayush`: 0. README scan: 26 refs (8 unique blobs), 0 hits. No existing Wasmer PR.

## Plan and replay (plan.txt, plan.json, replay.log)
- Provider Jekyll (`_config.yml` + `Gemfile`). Install `bundle install` with only Gemfile staged (no Gemfile.lock, no `gemspec` line). Build `jekyll build` (no `bundle exec`). Ruby 3.4.7, output `_site`.
- `ruby -v` exit 0; `bundle install` exit 0 ("2 Gemfile dependencies, 27 gems now installed": jekyll 3.8.7, webrick 1.9.2, sass 3.7.4); `jekyll build` exit 0; copy exit 0; 16 files. No LANG/LC_* set. One warning: "Logger not initialized properly".
- Command: `$S/scripts/replay.sh <patched clone> val2-minlight 3952 /404.html /no-such-page /assets/files/curriculum_vitae.pdf /assets/css/style.css /feed.xml /sitemap.xml`.

## HTTP (http-receipts.txt; smoke.txt)
- `/` 200 text/html. 11/11 same-origin assets from the built HTML return 200: 3 CSS text/css, 2 JS text/javascript, 5 PNG image/png, CV application/pdf.
- 404: `/404.html`, `/feed.xml`, `/sitemap.xml`, `/no-such-page`, with SWS's generic 404 body (106 bytes). The site has no 404.html, and no feed or sitemap is configured. Summary line: 2xx=14 404=4 other=0.
- smoke.txt: pages=7 refs=9 failures=4 (the four expected 404s).

## Compatibility finding (compat.txt)
- Ruby 3.4: the pinned `jekyll ~> 3.8.5` resolves to 3.8.7 (with sass 3.7.4, i18n 0.9.5, kramdown 1.17.0), and it builds on Ruby 3.4.7 with one warning. No github-pages gem. No lockfile, so transitive versions float at deploy time. No locale needed.
- Plain `jekyll` (not `bundle exec`) still loaded 3.8.7, because the only jekyll in GEM_HOME is 3.8.7 (replay.log paths).
- `remote_theme:` is ignored without jekyll-remote-theme; the local `_layouts` are used.
- External: the default config's `google_analytics: UA-111540567-4` (the template's own ID) renders analytics.js in index.html. Font Awesome comes from cdnjs. Both are disclosed in Limitations.

## Verdict: READY
The build and serve pass with no controlling policy. Acceptance uncertainty is disclosed in the PR body: no merged PRs are visible in history.

## Claims table (PR_BODY.md)
| Claim | Receipt |
|---|---|
| Only README.md changes, 6 added lines, placement | upstream.patch |
| Tested on dd114c3, main | patch-checks.txt, replay.log header |
| Anybuild v0.33.0 detects Jekyll; `bundle install`, `jekyll build`, `_site` | plan.txt, plan.json, replay.log |
| Ruby 3.4.7, no locale vars, exits 0, 27 gems, jekyll 3.8.7/webrick 1.9.2, 1 warning, 16 files | replay.log, compat.txt, http-receipts.txt header |
| static-web-server 2.38.0 | replay.log, http-receipts.txt |
| `/` 200; 11 assets 200 with types; missing paths 404 | http-receipts.txt, smoke.txt |
| No Gemfile.lock; ~> 3.8.5 | compat.txt (Gemfile) |
| GA UA-111540567-4 rendered; Font Awesome cdnjs | compat.txt |
| No 404.html; generic 404 | compat.txt, http-receipts.txt |
| remote_theme ignored by plain build | compat.txt, replay.log (build used local layouts) |
| No merged PRs visible; maintainer commits directly | policy-excerpt.txt |
| Button/disclosure/no-deployment sentences | statements of intent, no receipt needed |

## Update 2 (root review: concise README, route limitations)
- The README paragraph now says you review, and correct if needed, the detected settings before clicking Deploy, and that nothing is deployed until you do. It also keeps the no-copy and own-fork semantics. Only the paragraph wording changed; the line count is the same.
- New `upstream.patch` sha256: `08dff7ab375d11949580d81ac379eb16e1cffa5ec7f0e03b2c142dac0ae69ab8`. Apply and whitespace checks on a fresh clean HEAD are in `patch-check-update2.txt`. Earlier sha256 values in this file are superseded.
- `PR_BODY.md` Limitations now state the route behaviour. It is backed by `http-receipts.txt`: every served page, plus the unknown paths and repository files that return 404.
- The PR-body button now has `width="328" height="48"`.
