# 28 b2a3e8/jekyll-theme-console — HOLD (install input gap: gemspec not staged)

- Pinned SHA `36631985b1b2e30646320c509c5b6d93577588f6`, branch `master`. Stars 821 / forks 440 (GitHub API, 2026-10-22). License MIT.
- Duplicate check `wasmer`: 0.
- No policy files. Merged PRs since 2025-10-01: 0; last push 2025-09-09. The demo is hosted in separate repos (jekyll-theme-console-demo-*).
- Side note (diagnostic only): with the full tree staged, the build exits 0.

## Why HOLD
The root `Gemfile` contains `gemspec`. Anybuild v0.33.0 `resources/starlib/tools/jekyll.bzl:16-20` stages only `Gemfile` (plus `Gemfile.lock` via `copy`) before `run("bundle install", inputs=["Gemfile"])`. The executors bind or copy only the listed inputs (`src/build/docker.rs:377-399`, `src/build/local.rs:299-320`), so the `*.gemspec` is missing when Bundler parses the Gemfile.

Replay (`replay.sh <clone> pre-b2a3e8__jekyll-theme-console …`, Ruby 3.4.7), see replay.log:
```
$ bundle install
[!] There was an error parsing `Gemfile`: There are no gemspecs at …/work. Bundler cannot continue.
exit=15  INSTALL FAILED
$ jekyll build   exit=127  BUILD FAILED   (smoke: / 404)
```
Classification: **install input gap (gemspec not staged)**. This is a real Anybuild limitation, not a repo bug. No minimal repo-side fix is appropriate, because rewriting a theme gem's Gemfile for one host is not a reasonable upstream change. No README patch or PR has been drafted.

Remaining check for the reviewer: none until Anybuild stages `*.gemspec` (and anything the gemspec reads) as `bundle install` inputs.
