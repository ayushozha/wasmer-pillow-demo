# 32 murraco/jekyll-theme-minimal-resume — READY

- Pinned SHA `21f924a4671a24c8ea03b34ae0bcc35066d96a86`, branch `master`.
- Stars 554 / forks 595, not archived, not a template repo (GitHub API, 2026-10-22). Last push 2026-08-24.
- License: MIT ("Copyright (c) 2017 Mauricio Urraco … Permission is hereby granted, free of charge … to deal in the Software without restriction").
- Policy files: none (no CONTRIBUTING, no PR template, no AGENTS/CLAUDE files, no bad-PR workflow; `.github/` has only FUNDING.yml and dependabot.yml). README "Contribution": "Report issues / Open pull request with improvements / Spread the word".
- Merged PRs since 2025-10-01: 17. Most are Dependabot bumps (#96–#100), and the maintainer merges them.
- Duplicate check `wasmer repo:…`: 0. Prior PRs with `deploy` in the title: 0.
- Existing deploy docs: a Netlify status badge, plus "Deploys to GitHub Pages, Netlify, or any static host". There is no deploy-button section.

## Anybuild detection
- `crates/anybuild/src/providers/jekyll.rs:115-119`: `_config.yml` + `Gemfile` gives Strong evidence, scored 85 (`providers/mod.rs` Jekyll arm). NodeStatic Strong is 60, so Jekyll wins over `package.json`/gulp. Plan: "Detected Jekyll provider, Jekyll 4.3.0 (unused, Gemfile present), Ruby 3.4.7, Output _site".
- `resources/starlib/tools/jekyll.bzl:16-31`: copy Gemfile.lock, `bundle install` (inputs Gemfile only), copy tree, `jekyll build` (no `bundle exec`), `cp -R _site/*`.
- The repo pins Ruby 3.3.6 in `.ruby-version`. Anybuild ignores that file and uses 3.4.7.

## Replay
`replay.sh <patched clone> minimal-resume 3672 /404.html /no-such-page /assets/css/main.css /README.md` on Ruby 3.4.7 (built from the ruby v3_4_7 tag):
- `bundle install` exit 0 (98 gems, github-pages lock, jekyll 3.10.0). `jekyll build` exit 0. Copy exit 0. 23 files.
- Smoke: `/` 200, `/assets/css/main.css` 200, 4 asset refs 200. `/404.html` and `/no-such-page` give 404 (the repo has no 404 page). `/README.md` 200: the repo's exclude list lets it through, which is existing behaviour.
- The Ruby 3.4 + github-pages (jekyll 3.10) lock worked here: no csv/base64/bigdecimal/logger load errors, and the lock already resolves them.

## Verdict: READY
Reviewer remaining check: confirm the badge renders and that `wasmer.io/apps/create?github=murraco%2Fjekyll-theme-minimal-resume` opens the import page. Optionally do a real Wasmer deploy to confirm the builder's `jekyll` binstub resolves under its mise Ruby. Locally, GEM_HOME/bin was on PATH.
