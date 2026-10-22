# 33 alshedivat/al-folio — HOLD (policy: PRs restricted to collaborators)

- Pinned SHA `f2a2765c8a9413f6ec703fc02070fbe6becf1572`, branch `main`. Stars 16,266 / forks 13,057, template repo (GitHub API, 2026-10-22). License MIT.
- **`pull_request_creation_policy: "collaborators_only"`** (GitHub API repo object). Outside contributors cannot open PRs. This is a hard stop.
- Policy files: AGENTS.md, CLAUDE.md, .github/copilot-instructions.md, docs/CONTRIBUTING.md (prettier required; routing via docs/BOUNDARIES.md), and a PR template with "Ownership Routing" checkboxes and a `npm ci` / `bundle exec jekyll build` validation list. Merged PRs since 2025-10-01: 114. Duplicate `wasmer`: 0. `deploy` in title: 48 results, all user "deploy my site" PRs closed by maintainers.

## Quick build proof (feasibility, unpatched)
Jekyll Strong. `Gemfile` + `Gemfile.lock` (no `gemspec`). `bundle install` exit 0 on Ruby 3.4.7. `jekyll build` exit 1: `Failed to open TCP connection to medium.com:443 (getaddrinfo … Name or service not known)`. The build fetches external posts at build time, and this container has no general DNS. Classification: **FAIL_ENV** here, not proven either way for Wasmer. Further heavy requirements (ImageMagick via jekyll-imagemagick, jupyter via jekyll-jupyter-notebook, purgecss via npm in the upstream deploy workflow) were not exercised. Note that Anybuild's Docker build image does install `libmagickwand-dev`.

## Verdict: HOLD
The policy blocks it (collaborators-only PRs). No patch drafted.
