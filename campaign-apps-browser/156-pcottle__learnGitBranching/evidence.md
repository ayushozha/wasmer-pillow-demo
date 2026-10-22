# pcottle/learnGitBranching: evidence

**Verdict: HOLD (builder).** Three separate Anybuild v0.33.0 behaviours break this repo as-is, and none can be fixed with a README-only change or a Staticfile:

1. **Preinstall input gap.** The `preinstall` script runs `node scripts/check-package-manager.js`, but the staged install sees only `package.json` and `yarn.lock` (`node.bzl:95-140`, `node_install_inputs=['package.json']`). The result is `MODULE_NOT_FOUND`, and `yarn install` exits 1 ("INSTALL FAILED" in `replay.log`).
2. **Build-script choice.** The builder picks `yarn run generate` over `yarn run build`. `get_build_command` checks `generate` before `build` (`node_static.rs:902-907`). In this repo `generate` only regenerates level and locale manifests; the real build is `yarn build`, which runs `yarn test`, then `vite build`, then `postbuild`.
3. **Output directory.** The builder expects Vite's default `dist` (`node.rs:334`), but `vite.config.mjs` writes to `build/`. A Staticfile `root: build` would fix only this point.

A fix would need repo changes: renaming the `generate` script, or making `preinstall` tolerate a missing file. That is outside this campaign's README-only scope, so it stays HOLD.

## Repository
- Pinned SHA: `30855ac924472ee622c8fec3a75a016efbc1c8e4` on `main`.
- Stars / forks: 34,146 / 6,031. Last push 2026-10-19 (GitHub API, 2026-10-22).
- License: MIT. The repo is very active, with 137 merged PRs since 2025-10-01.
- CONTRIBUTING says: "We have a pretty relaxed environment in this project so there's no formal template to submit Pull Requests for."
- `CLAUDE.md` is present and describes the project as "100% client-side".
- Duplicate `wasmer` PRs: 0. "Deploy" PRs: #1354, #1352 and #666, all by the owner (CI and gh-pages work).
- Existing hosting: `netlify.toml` (`yarn build`, publishing `build`) and Docker.

## Replay (unpatched): Node 24.22.1, yarn 1.22.22
- `yarn install`: preinstall failed with `MODULE_NOT_FOUND` (exit 1).
- `yarn run generate`: exit 0.
- "STATIC_DIR 'dist' MISSING", and `/` returned 404.

## Note for the lead
- The `generate`-over-`build` precedence and the non-staging of files referenced by lifecycle scripts are real builder gaps. They are worth reporting upstream to Anybuild.
