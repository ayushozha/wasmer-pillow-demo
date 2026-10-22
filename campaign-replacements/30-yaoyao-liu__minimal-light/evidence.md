# 30 yaoyao-liu/minimal-light — CONDITIONAL

- Pinned SHA `dd114c3fef2d97adc1c6b6d46901e0d96ab83a7c`, branch `main`.
- Stars 1,048 / forks 882, template repo, not archived (GitHub API, 2026-10-22). Last push 2026-10-18.
- License: CC0 1.0 Universal (public-domain dedication, no conditions on reuse).
- Policy files: none (no CONTRIBUTING, PR template, AGENTS/CLAUDE files or workflows).
- Merged PRs since 2025-10-01: 0. **Merged PRs ever: 0** (`is:merged repo:yaoyao-liu/minimal-light`, total_count 0). The maintainer commits directly.
- Duplicate check `wasmer`: 0. Prior PRs with `deploy` in the title: 0.
- Existing deploy docs: "Using with the GitHub Pages Service" (fork or remote_theme) and "Using Locally with Jekyll" (build, then upload `_site`).
- Personal-site template. The README patch says the button deploys the example page, and that users import their own repo after editing `_config.yml`/`index.md`.

## Anybuild detection
`providers/jekyll.rs:115-119`: `_config.yml` + `Gemfile` gives Strong evidence (85). `jekyll.bzl:16-31`: `bundle install` with only the Gemfile staged (there is no Gemfile.lock and no `gemspec` line, so staging is fine), then `jekyll build`, then `cp -R _site/*`.

## Replay
`replay.sh <patched clone> minimal-light 3670 /404.html /no-such-page /assets/files/curriculum_vitae.pdf`:
- Ruby 3.4.7. `bundle install` exit 0 (jekyll 3.8.7, webrick). `jekyll build` exit 0, with one Ruby 3.4 warning: "Logger not initialized properly". 16 files.
- Smoke: `/` 200, 11/11 asset refs 200, CV PDF 200. `/404.html` and `/no-such-page` give 404 (the site has no 404 page).
- Jekyll 3.8 on Ruby 3.4 worked, so the removed default gems did not break this site.
- Note: `jekyll build` runs without `bundle exec`. Jekyll calls Bundler.setup itself because a Gemfile is present, and only one Jekyll version is in GEM_HOME, so the pinned 3.8.x is what runs.

## Verdict: CONDITIONAL
The build passes. The condition is maintainer responsiveness: the repo has never merged a pull request. The reviewer should decide whether a PR is worth opening, or whether an issue proposing the change is the better route. Also check that the badge renders and the import URL opens.
