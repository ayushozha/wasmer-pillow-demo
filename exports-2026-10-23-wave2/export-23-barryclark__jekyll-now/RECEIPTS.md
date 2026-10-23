# 23 barryclark/jekyll-now: CONDITIONAL

## Source
- Fresh `git clone --filter=blob:none` on 2026-10-23, `master` HEAD `12cb8a2e97c3b63c4bc92d2a1ab050b35bf946b7` (2018-04-11). Same as the prior pin, so the README patch was re-applied unchanged (patch-checks.txt).
- `upstream.patch` sha256 `072145ac72efb039b47e7db8b11c99c16069ddcf4a12c337b3067d099b24bacb`; `git apply --check` on a clean HEAD exit 0; `git diff --check` exit 0; 0 trailing-whitespace lines.

## Policy (policy-excerpt.txt)
- No CONTRIBUTING, AGENTS.md, CLAUDE.md, .cursorrules, copilot-instructions, PR template, CLA or workflows. No `.github/` directory.
- README "Contributing": "Issues and Pull Requests are greatly appreciated." / "You can start by opening an issue describing the problem that you're looking to resolve and we'll go from there." / "I want to keep Jekyll Now as minimal as possible. Every line of code should be one that's useful to 90% of the people using it. ... If it's not something that most people will use, it probably won't get merged."
- No rule against AI/agent PRs. No lint/test command required, so none was run.
- Activity: last commit 2018-04-11; 0 "Merge pull request" commits since 2019. Disclosed in the PR body.

## Duplicate check (duplicate-check.txt)
- 2125 PR refs fetched. `--grep=wasmer`: 0. `--author=wasmer --author=ayush`: 16 commits, all by "Ayush Bharadwaj" (ayusbhar2), dated 2023-04-26..2023-05-04 in PR refs pr/2145 and pr/2148: an unrelated user's personal-site commits with no Wasmer content (no `wasmer` in messages or README). README scan: 2048 refs (334 unique blobs), 0 hits. No existing Wasmer PR.

## Plan and replay (plan.txt, plan.json, replay.log)
- Provider Jekyll; no Gemfile, so install = `bundle init && bundle add jekyll -v 4.3.0`, build = `jekyll build` (no `bundle exec`), Ruby 3.4.7, output `_site`, start `static-web-server --root=/opt/static_app ...`.
- `ruby -v` exit 0; install exit 0; `jekyll build` exit 0; copy exit 0; 12 files. No LANG/LC_* set. Warnings only: Logger not initialized properly, 4x Sass @import deprecation.
- Command: `$S/scripts/replay.sh <patched clone> val2-jekyllnow 3951 /about/ /Hello-World/ /404.html /feed.xml /sitemap.xml /style.css /no-such-page`.

## HTTP (http-receipts.txt; smoke.txt)
- Pages 200: `/`, `/about/`, `/Hello-World/` (post), `/404.html`, `/style.css`. Assets from built HTML: `/images/404.jpg`, `/images/config.png`, `/style.css`, `/`, `/Hello-World/` 200; `/about` 308 to `/about/` (200).
- 404: `/feed.xml`, `/sitemap.xml`, `/no-such-page`, `/Hello-World/no-such`. Body is the site's own 404 page (2513 bytes, title "404 - Page not found"). Summary line: 2xx=11 (incl. 1 followed redirect) 404=5 other=1 (the 308).
- smoke.txt: pages=8 refs=3 failures=3 (the three expected 404s).

## Compatibility finding (compat.txt)
- `_config.yml` lists `jekyll-sitemap`/`jekyll-feed` under the legacy `gems:` key. Jekyll 4.3.0's site.rb reads only `config["plugins"]`, and neither gem is installed, so both are silently skipped: no feed/sitemap, and the `<link rel="alternate" href="/feed.xml">` in all 4 pages 404s. The README section and PR body state this.
- Ruby 3.4: no pinned gems (no Gemfile/lock; no github-pages gem); jekyll 4.3.0 builds with warnings only. No locale needed.
- External scripts: GA and Disqus are empty in config and render nothing (0 matches in built HTML). The only external script is html5shiv over http inside an IE<9 conditional comment. Avatar image from raw.githubusercontent.com.

## Verdict: CONDITIONAL
Build, serve and 404 handling pass. Open item: the README asks contributors to "start by opening an issue" and keep changes useful to 90% of users. I read this as a suggestion, not an issue-first requirement, but a reviewer should decide whether to open an issue first. The PR body offers to. The repo has been inactive since 2018 (disclosed).

## Claims table (PR_BODY.md)
| Claim | Receipt |
|---|---|
| Only README.md changes, 6 added lines | upstream.patch |
| Tested on 12cb8a2, master | patch-checks.txt, replay.log header |
| Anybuild v0.33.0 detects Jekyll; `bundle init && bundle add jekyll -v 4.3.0`, `jekyll build`, `_site` | plan.txt, plan.json, replay.log |
| Ruby 3.4.7, no locale vars, install exit 0, build exit 0, warnings listed, 12 files | replay.log, http-receipts.txt header |
| static-web-server 2.38.0 | replay.log, http-receipts.txt |
| Pages 200; assets 200; /about 308 to /about/; missing paths 404 with own 404.html | http-receipts.txt, smoke.txt |
| `gems:` ignored by Jekyll 4; feed/sitemap 404; every page links /feed.xml | compat.txt, http-receipts.txt |
| GA/Disqus empty by default; html5shiv IE<=8 only | compat.txt |
| Last commit April 2018; README asks to start with an issue / stay minimal | policy-excerpt.txt |
| Button/disclosure/no-deployment sentences | statements of intent, no receipt needed |
