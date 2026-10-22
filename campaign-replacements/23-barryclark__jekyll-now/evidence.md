# 23 barryclark/jekyll-now — CONDITIONAL

- Pinned SHA `12cb8a2e97c3b63c4bc92d2a1ab050b35bf946b7`, branch `master`.
- Stars 8,409 / forks 34,704, not archived (GitHub API, 2026-10-22). **Last push 2024-08-19.** 390 open issues.
- License: MIT ("Copyright (c) 2015 Barry Clark … without restriction").
- Policy files: none (no CONTRIBUTING, PR template or workflows). README "Contributing" section invites issues/PRs.
- Merged PRs since 2025-10-01: 0. Most recent merged PR: #993, 2018-04-12. The repo is effectively unmaintained.
- Duplicate check `wasmer`: 0. PRs with `deploy` in the title: #2465 (2026, closed, a user's own workflow), #1600, #1529. All are accidental user PRs, not third-party deploy buttons.

## Anybuild detection
`providers/jekyll.rs:115-120`: `_config.yml` without a Gemfile gives Structural evidence (40). No other provider matches. `jekyll.bzl:22-25`: no Gemfile, so it runs `bundle init` and `bundle add jekyll -v 4.3.0` (the `jekyll_version` default is at `jekyll.rs:35,66`).

## Plugin compatibility
`_config.yml` uses the legacy `gems:` key (`jekyll-sitemap`, `jekyll-feed`). Neither gem is installed by the generated Gemfile, and Jekyll 4 printed no error, so they are silently skipped. `/feed.xml` and `/sitemap.xml` return 404. On GitHub Pages they exist. The README patch states this.

## Replay
`replay.sh <patched clone> jekyll-now 3663 /about /Hello-World/ /404.html /no-such-page /feed.xml`:
- Ruby 3.4.7. Install exit 0. `jekyll build` exit 0, with warnings: "Logger not initialized properly" (Ruby 3.4) and Sass `@import` deprecations. 12 files.
- Smoke: `/`, `/about`, `/Hello-World/` and `/404.html` return 200. `/style.css` and the images return 200. `/feed.xml` 404 (expected, see above). `/no-such-page` 404.

## Verdict: CONDITIONAL
The build passes. The conditions are (1) the maintainer has merged nothing since 2018, so the PR is very unlikely to be reviewed, and (2) feed/sitemap are missing compared with GitHub Pages (documented in the patch). Reviewer: decide whether to spend a PR on an inactive repo, and check that the badge renders and the import URL opens.
