# thuliteio/doks: evidence

**Verdict: HOLD.** The build fails under Anybuild: the Hugo binary is not available in the node-static build, and the planned static dir is wrong.

## Repository
- Pinned SHA: `262fbe7006114a78dfc3750d9d7ba7cfbb6c3ee4` on branch `main`.
- Stars / forks: 2,363 / 377. The repo is not archived and was last pushed 2026-10-21 (GitHub API, 2026-10-22).
- License: MIT, Copyright (c) 2020-2026 Thulite.
- PR template: `.github/PULL_REQUEST_TEMPLATE.md` (Summary / Basic example / Motivation / Checks). There is no CONTRIBUTING file in the repo and no AI policy.
- Recent merged PRs since 2025-10-01: 6.
- Duplicate `wasmer` PR check: 0. No prior deploy-button PRs were found.

## Anybuild detection (v0.33.0)
- Plan without changes: provider **node-static**, framework **Vite** (because `vite` is a devDependency), `npm install`, then `npm run build`, with static_dir **dist** (`providers/node.rs:334`, `node_static.rs:226-231`).
- Hugo's provider does not win, because the repo has `config/_default/hugo.toml` but no root Hugo config. Node-static scores higher (`mod.rs:390-393`, `mod.rs:421-426`).
- Plan with a `Staticfile` (`root: public`, tested): provider **staticfile**, which only copies files and never builds, so it is useless here (`public/` is not committed).

## Replay (unpatched clone, Node 24.22.1, npm 11)
- `npm install` succeeded (exit 0).
- `npm run build`, which runs `hugo --minify --gc`, failed with exit 127: `sh: 1: hugo: not found`. Thulite 3 no longer ships a Hugo binary through npm; it expects a system Hugo.
- Then `STATIC_DIR 'dist' MISSING`, and smoke returned 404 on `/`, `/docs/` and `/blog/`.
- Proof of the output directory: I ran Hugo 0.153.2 extended (Anybuild's Hugo-provider default) by hand in the installed tree (`hugo-manual.log`).
  - It failed with `can't evaluate field Locale in type *langs.Language`. The theme needs a newer Hugo; `netlify.toml` pins `HUGO_VERSION = "0.166.0"` and Dart Sass 1.104.1.
  - Hugo created `public/`, not `dist/`, and `netlify.toml` also says `publish = "public"`.
- So the plan says `dist`, but Doks outputs to `public/`.
- Classification: **genuine builder mismatch**. Node-static has no Hugo or Dart Sass, the static_dir is wrong, and the Hugo provider's default version is too old.

## Remaining check for the reviewer
- Unblock only if Anybuild gains Hugo plus Node support (a Hugo provider that runs `npm install` and allows `HUGO_VERSION>=0.166`), or if node-static learns about Thulite.
- No upstream patch is proposed.
