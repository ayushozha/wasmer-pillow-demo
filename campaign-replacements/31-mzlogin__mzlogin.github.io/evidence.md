# 31 mzlogin/mzlogin.github.io — HOLD (genuine build failure under Anybuild's locale)

- Pinned SHA `e34d9a48947607e6c8d156ca0bd8f8343ccdf032`, branch `master`. Stars 1,659 / forks 1,277, template repo (GitHub API, 2026-10-22). Last push 2026-07-21. License MIT ("Copyright (c) 2013 Zhuang Ma").
- No CONTRIBUTING or PR template. Merged PRs since 2025-10-01: 0. Duplicate `wasmer`: 0. `deploy` in title: #146 (2022, accidental, closed).
- The repo is also the author's live personal blog (`url: https://mazhuang.org`, real posts/wiki/images, CNAME). The "Fork 指南" tells forkers to delete his posts. A deploy button would publish his blog content, so a README patch would need to say clearly that users import their own repo after editing `_config.yml`.

## Replay: BUILD FAILED
Jekyll Strong detection. `Gemfile`: `github-pages` (no lock), which resolves jekyll 3.10.0 and jekyll-sass-converter 1.5.2 (Ruby Sass 3.7.4). `bundle install` exit 0. Then `jekyll build` exit 1:
```
Conversion error: Jekyll::Converters::Scss encountered an error while converting 'assets/css/style.scss':
  Invalid US-ASCII character "\xE2" on line 5
  …/jekyll-theme-primer-0.6.0/_sass/primer-support/lib/variables/typography.scss:5
```
Cause: no UTF-8 locale. Ruby's `Encoding.default_external` falls back to US-ASCII, and Ruby Sass 3.7 reads the primer theme's UTF-8 SCSS with it. Anybuild's Docker build stage (`src/build/docker.rs:116-140`, `FROM debian:trixie-slim`, no `ENV LANG`) and its starlib set no LANG/LC_ALL (grep finds none), so the replay's empty locale matches the real builder. Diagnostic only: the same tree with `LANG=C.UTF-8` builds (921 files).
Classification: **genuine build failure caused by builder environment (missing UTF-8 locale) + github-pages' old Ruby Sass**. This is not FAIL_ENV, because the replay environment matches Anybuild here.

## Verdict: HOLD
This needs either Anybuild to set `LANG=C.UTF-8` in the build image (the better fix, and it affects every github-pages/Ruby-Sass site), or a repo-side change (for example `encoding`/Gemfile changes) that would be out of scope for a README PR. Also a personal blog. No patch drafted.
