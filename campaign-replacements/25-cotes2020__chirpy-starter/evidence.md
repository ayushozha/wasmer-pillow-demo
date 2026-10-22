# 25 cotes2020/chirpy-starter — HOLD (policy: contributions routed to the theme repo)

- Pinned SHA `beffc88713242da8bf49325674be38d171071213`, branch `main`. Stars 1,111 / forks 600, template repo, issues disabled (`has_issues: false`). Topic `auto-generated`. Last push 2026-06-20 (GitHub API, 2026-10-22). License MIT ("Copyright (c) 2021 Cotes Chung").
- README "Contributing": "This repository is automatically updated with new releases from the theme repository. If you encounter any issues or want to contribute to its improvement, please visit the [theme repository](https://github.com/cotes2020/jekyll-theme-chirpy/) to provide feedback."
- Merged PRs since 2025-10-01: 0. Duplicate `wasmer`: 0. `deploy` in title: #12 and #7 (pages-deploy.yml fixes, both closed unmerged).

## Build: PASS (proved)
Detection: Jekyll Strong (`_config.yml` + `Gemfile`, `providers/jekyll.rs:115-119`). Gem theme `jekyll-theme-chirpy ~> 7.6` with no `gemspec` line, so staging only the Gemfile works. The question "does it need `bundle exec` or JS assets?" is answered: no. The gem ships prebuilt `assets/js/dist/*.min.js` and CSS, and plain `jekyll build` works.
Replay (unpatched clone, `pre-cotes2020__chirpy-starter`, Ruby 3.4.7): `bundle install` exit 0, `jekyll build` exit 0 (0.54 s), 30 files. Smoke: `/`, `/404.html`, `/feed.xml` and `/sitemap.xml` return 200. Theme CSS/JS, `/categories/`, `/tags/`, `/archives/` and `/about/` return 200. The single "failure" `/{url}` is a JS template literal picked up by the smoke parser, not a real link. Caveats: `assets/lib` is a git submodule (chirpy-static-assets) that is not populated in a shallow clone. It is only used when `assets.self_host.enabled: true` (default false, so the CDN is used). `_posts/` is empty, so the demo is an empty blog.

## Verdict: HOLD
The starter is generated from the theme repo, which also owns contributions; a README change here is the wrong venue and may be overwritten. If the reviewer wants to pursue Chirpy, re-target `cotes2020/jekyll-theme-chirpy`. That needs separate research, because the theme repo root is a gem plus demo with its own build tooling. No patch drafted.
