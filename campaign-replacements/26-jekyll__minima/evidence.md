# 26 jekyll/minima — HOLD (install input gap: gemspec not staged)

- Pinned SHA `4de322363fca5927e6f4012cb94f6dad69ab5e6c`, branch `master`. Stars 3,837 / forks 3,790 (GitHub API, 2026-10-22). License MIT.
- Duplicate check `wasmer`: 0.
- CODE_OF_CONDUCT only. 1 merged PR since 2025-10-01. Last push 2026-04-07.
- Theme-vs-site: the root is the theme gem (minima.gemspec) with a demo `_config.yml`, `_posts`, `about.md` and `index.md`. It is a theme development tree, not a site template; users consume minima as a gem via `jekyll new`. Even apart from the builder gap, a deploy button here would deploy the theme's demo, which is weak value.
- Side note (diagnostic only): with the full tree staged, `jekyll build` still fails: 'Liquid syntax error … Unknown tag `seo`'. jekyll-seo-tag is a gemspec runtime dependency, but the root `_config.yml` declares no `plugins:` or `theme:`, so nothing loads it. Upstream builds its demo with a different config (`_config_theme-dev.yml` / the demo_site workflow). So it would still fail after an Anybuild fix.

## Why HOLD
The root `Gemfile` contains `gemspec`. Anybuild v0.33.0 `resources/starlib/tools/jekyll.bzl:16-20` stages only `Gemfile` (plus `Gemfile.lock` via `copy`) before `run("bundle install", inputs=["Gemfile"])`. The executors bind or copy only the listed inputs (`src/build/docker.rs:377-399`, `src/build/local.rs:299-320`), so the `*.gemspec` is missing when Bundler parses the Gemfile.

Replay (`replay.sh <clone> pre-jekyll__minima …`, Ruby 3.4.7), see replay.log:
```
$ bundle install
[!] There was an error parsing `Gemfile`: There are no gemspecs at …/work. Bundler cannot continue.
exit=15  INSTALL FAILED
$ jekyll build   exit=127  BUILD FAILED   (smoke: / 404)
```
Classification: **install input gap (gemspec not staged)**. This is a real Anybuild limitation, not a repo bug. No minimal repo-side fix is appropriate, because rewriting a theme gem's Gemfile for one host is not a reasonable upstream change. No README patch or PR has been drafted.

Remaining check for the reviewer: none until Anybuild stages `*.gemspec` (and anything the gemspec reads) as `bundle install` inputs.
