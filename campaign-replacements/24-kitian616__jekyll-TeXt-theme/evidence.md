# 24 kitian616/jekyll-TeXt-theme — HOLD (install input gap: gemspec not staged)

- Pinned SHA `e8b5d368bc638b1997d0829c349580c6c1b6a141`, branch `master`. Stars 3,344 / forks 2,645 (GitHub API, 2026-10-22). License MIT.
- Duplicate check `wasmer`: 0.
- CLAUDE.md present (commands and architecture only, no contribution rules). No PR template. Merged PRs since 2025-10-01: 0; last push 2026-06-08.
- Also has `package.json`, but Jekyll (85) outranks NodeStatic (60).
- Side note (diagnostic only): with the full tree staged, the build exits 0.

## Why HOLD
The root `Gemfile` contains `gemspec`. Anybuild v0.33.0 `resources/starlib/tools/jekyll.bzl:16-20` stages only `Gemfile` (plus `Gemfile.lock` via `copy`) before `run("bundle install", inputs=["Gemfile"])`. The executors bind or copy only the listed inputs (`src/build/docker.rs:377-399`, `src/build/local.rs:299-320`), so the `*.gemspec` is missing when Bundler parses the Gemfile.

Replay (`replay.sh <clone> pre-kitian616__jekyll-TeXt-theme …`, Ruby 3.4.7), see replay.log:
```
$ bundle install
[!] There was an error parsing `Gemfile`: There are no gemspecs at …/work. Bundler cannot continue.
exit=15  INSTALL FAILED
$ jekyll build   exit=127  BUILD FAILED   (smoke: / 404)
```
Classification: **install input gap (gemspec not staged)**. This is a real Anybuild limitation, not a repo bug. No minimal repo-side fix is appropriate, because rewriting a theme gem's Gemfile for one host is not a reasonable upstream change. No README patch or PR has been drafted.

Remaining check for the reviewer: none until Anybuild stages `*.gemspec` (and anything the gemspec reads) as `bundle install` inputs.
