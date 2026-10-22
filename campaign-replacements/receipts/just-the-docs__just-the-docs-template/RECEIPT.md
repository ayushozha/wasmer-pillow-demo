# just-the-docs/just-the-docs-template — strict Anybuild v0.33.0 Jekyll replay on Ruby 3.4.7

Requested by root for ClaudeA's prepared README patch (this receipt changes no source; it replays the unmodified base).

- Upstream: https://github.com/just-the-docs/just-the-docs-template, base `d9e885a8bf281872759fbe061633e040772e76a1` (checked out exactly; `git status` clean).
- Builder: `anybuild plan --temp-anybuild --wasmer` with the Anybuild v0.33.0 CLI (wasmerio/shipit tag v0.33.0, 587be231) → **Jekyll provider**: install `bundle install`, build `jekyll build`, start static-web-server (`plan.txt`).
- Toolchain: **ruby 3.4.7 (2025-10-08 revision 7a5688e2a2) +PRISM [x86_64-linux]** — Anybuild's default Ruby version (`providers/jekyll.rs:34,65`), compiled earlier in this session from the official ruby/ruby `v3_4_7` git tag (no system tools installed for this run). Bundler 2.6.9 (with Ruby) switched itself to the lockfile's 2.5.9.
- Strict staging (mirrors `resources/starlib/tools/jekyll.bzl:16-31`): only `Gemfile` + `Gemfile.lock` present for `bundle install` (exit 0) → then the full source copied → plain `jekyll build` (not `bundle exec`) exit 0, "done in 0.79 seconds" → `cp -R _site/*` into the static app.
- Resolved gems (from the installed GEM_HOME): jekyll 4.4.1, just-the-docs 0.12.0, jekyll-seo-tag 2.8.0, jekyll-include-cache 0.2.1, jekyll-sass-converter 3.0.0, sass-embedded 1.83.4 (x86_64-linux-gnu), bundler 2.5.9.
- Output: 13 files (`static_app-files.txt`).
- Smoke (local native static-web-server 2.38.0 — the version Anybuild's plan pins; Wasmer's hosted runtime uses its own WASI static-web-server package, not tested here) — `smoke.txt`:
  - `/` 200 "Home | Just the Docs Template"; `/assets/css/just-the-docs-default.css` 200 (text/css); `/assets/js/just-the-docs.js` 200; `/assets/js/search-data.json` 200; referenced `/assets/css/just-the-docs-head-nav.css` 200 and `/assets/js/vendor/lunr.min.js` 200.
  - `/404.html` 404 and `/does-not-exist` 404: the template has no 404 page (no `404.html`/`404.md` in the source), so none is generated — expected, not a failure.
- Build output also prints many Dart Sass deprecation warnings (`@import`, global built-ins, `darken()`/`lighten()`) from the theme's SCSS; they are warnings only (stripped from the saved log for length; counts: 'repetitive deprecation warnings omitted' lines remain).
- Not covered: Wasmer's actual builder image (e.g. locale, binstub PATH), the hosted WASI static server, the import page/badge.
