# Replacement targets (static sites) — staging

README-only (plus a tiny `Staticfile` where detection needs it) "Deploy to Wasmer" patches for popular static templates, replacing batch-B targets that were held. Nothing here is an upstream PR yet.

Per target `NN-owner__repo/`: `evidence.md` (pin, popularity, policy, Anybuild detection with file:line, verdict), `replay.log` + `plan.txt` (proof), `upstream.patch` (`git diff` vs pinned SHA; `git apply`), `PR_TITLE.txt`, `PR_BODY.md`.

## Proof method — `tools/replay.sh`
Faithful local replay of Anybuild v0.33.0 (wasmerio/shipit tag `v0.33.0`, 587be231, the version production pins):
1. Copy the patched tree to a flat root without `.git` (no ancestor `package.json`/workspace).
2. `anybuild plan --temp-anybuild --wasmer` with the v0.33.0 CLI built from that tag.
3. Execute exactly the generated steps: Node 24.22.1; package manager at the plan's version; install with only the lockfile + `node_install_inputs` staged and node.bzl's env (`CI=true`, pnpm `minimum_release_age=0`, `dangerously_allow_all_builds=true`, `strict_dep_builds=false`; npm `NPM_CONFIG_FUND=false`); copy sources; build; copy the static dir. Jekyll: Ruby 3.4.7 (compiled from the ruby/ruby `v3_4_7` tag), `bundle install`, `jekyll build`, `cp -R _site/*`. Hugo: the plan's Hugo version. Staticfile: copy `root` as-is.
4. Serve with static-web-server 2.38.0 (built from crates.io, the version Anybuild pins). Only deviation: `--host=127.0.0.1` (no IPv6 in the container).
5. `tools/smoke.py`: `/`, extra pages, and up to 60 same-origin `href`/`src` refs must return 2xx.

Not verifiable here: wasmer.io import page and img.shields.io rendering (blocked egress) — the reviewer checks each `https://wasmer.io/apps/create?github=OWNER%2FREPO`.

Badge (same as the static session's published PRs):
`[![Deploy to Wasmer](https://img.shields.io/badge/Deploy%20to-Wasmer-171717?logo=wasmer&logoColor=white)](https://wasmer.io/apps/create?github=OWNER%2FREPO)`
