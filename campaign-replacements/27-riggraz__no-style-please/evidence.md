# 27 riggraz/no-style-please — HOLD (install input gap: gemspec not staged)

- Pinned SHA `2f8dba2c23633b21e45dce0fe2e34ec2d79bb1ca`, branch `master`. Stars 1,399 / forks 631 (GitHub API, 2026-10-22). License MIT.
- Duplicate check `wasmer`: 0.
- No policy files. Merged PRs since 2025-10-01: 0; last push 2025-03-15.
- Side note (diagnostic only): with the full tree staged, `jekyll build` (no `bundle exec`) fails with 'You have already activated digest 3.2.0, but your Gemfile requires digest 3.1.1 … digest is a default gem' (Gem::LoadError). This is the plain-`jekyll build` vs `bundle exec` difference on Ruby 3.4, and it would still block the build after an Anybuild staging fix.

## Why HOLD
The root `Gemfile` contains `gemspec`. Anybuild v0.33.0 `resources/starlib/tools/jekyll.bzl:16-20` stages only `Gemfile` (plus `Gemfile.lock` via `copy`) before `run("bundle install", inputs=["Gemfile"])`. The executors bind or copy only the listed inputs (`src/build/docker.rs:377-399`, `src/build/local.rs:299-320`), so the `*.gemspec` is missing when Bundler parses the Gemfile.

Replay (`replay.sh <clone> pre-riggraz__no-style-please …`, Ruby 3.4.7), see replay.log:
```
$ bundle install
[!] There was an error parsing `Gemfile`: There are no gemspecs at …/work. Bundler cannot continue.
exit=15  INSTALL FAILED
$ jekyll build   exit=127  BUILD FAILED   (smoke: / 404)
```
Classification: **install input gap (gemspec not staged)**. This is a real Anybuild limitation, not a repo bug. No minimal repo-side fix is appropriate, because rewriting a theme gem's Gemfile for one host is not a reasonable upstream change. No README patch or PR has been drafted.

Remaining check for the reviewer: none until Anybuild stages `*.gemspec` (and anything the gemspec reads) as `bundle install` inputs.
