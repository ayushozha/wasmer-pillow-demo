# 22 daattali/beautiful-jekyll — HOLD (install input gap: gemspec not staged)

- Pinned SHA `7286eb8478fbd4265a6d2497c2e0f84d9a9326ba`, branch `master`. Stars 5,830 / forks 17,303 (GitHub API, 2026-10-22). License MIT.
- Duplicate check `wasmer`: 0.
- PR template: 'if you are trying to update **your** website, this is the wrong place'. Merged PRs since 2025-10-01: 0 (the maintainer pushes directly; last push 2026-10-15). README: 'you will not get any support if you use this theme via Ruby gems'.
- Side note (diagnostic only, not the Anybuild path): with the full tree staged, install and build exit 0.

## Why HOLD
The root `Gemfile` contains `gemspec`. Anybuild v0.33.0 `resources/starlib/tools/jekyll.bzl:16-20` stages only `Gemfile` (plus `Gemfile.lock` via `copy`) before `run("bundle install", inputs=["Gemfile"])`. The executors bind or copy only the listed inputs (`src/build/docker.rs:377-399`, `src/build/local.rs:299-320`), so the `*.gemspec` is missing when Bundler parses the Gemfile.

Replay (`replay.sh <clone> pre-daattali__beautiful-jekyll …`, Ruby 3.4.7), see replay.log:
```
$ bundle install
[!] There was an error parsing `Gemfile`: There are no gemspecs at …/work. Bundler cannot continue.
exit=15  INSTALL FAILED
$ jekyll build   exit=127  BUILD FAILED   (smoke: / 404)
```
Classification: **install input gap (gemspec not staged)**. This is a real Anybuild limitation, not a repo bug. No minimal repo-side fix is appropriate, because rewriting a theme gem's Gemfile for one host is not a reasonable upstream change. No README patch or PR has been drafted.

Remaining check for the reviewer: none until Anybuild stages `*.gemspec` (and anything the gemspec reads) as `bundle install` inputs.
