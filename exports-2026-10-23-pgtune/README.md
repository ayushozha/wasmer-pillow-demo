# pgtune export 2026-10-23: one prepared "Deploy to Wasmer" patch

This folder holds publication inputs only. Nothing here has been submitted upstream. The publisher dedupes against the live PR inventory and checks the import page before any use.

| Repo | Base | Changes | Builder result (Anybuild 0.33.1) |
|---|---|---|---|
| le0pard/pgtune | `master` @ `0208aa2` | README "Deploy" section with badge; root `Anybuild` | base: node-static/vite/yarn/`dist`, but install sees only `package.json`, so Yarn 4 uses Plug'n'Play and the build fails. Patched (`e2df476`): "declared in Anybuild", the same, with `yarn_version = "4.18.1"` and `node_install_requires_all_files = True`, so the build passes. |

`Anybuild` is the output of `anybuild generate . --provider node-static` (0.33.1) with three edits: `yarn_version = "4.18.1"`, `node_install_requires_all_files = True`, and the app name, each with comments where shown. See `Anybuild.generated-0.33.1` and `Anybuild.diff`. Both fields are supported Anybuild 0.33.1 fields (`crates/anybuild/src/providers/node.rs`, `resources/starlib/tools/node.bzl`).

**Correction (second commit on this branch):**
- The first version (`3289c49`) left Yarn unpinned. Anybuild 0.33.x deliberately leaves Yarn's version floating, so its Docker build rendered `mise use --global "yarn"`, and the earlier replay masked this with a repo-relative wrapper.
- `e2df476` pins `yarn_version = "4.18.1"`. The rendered Docker build now runs `mise use --global "yarn@4.18.1"`; see `Dockerfile.rendered.diff`, rendered with a stub docker client.
- The replay now installs the plan's Yarn release. It uses `@yarnpkg/cli-dist@4.18.1` from npm with its own launcher; its `yarn.js` is byte-identical to the committed `.yarn/releases/yarn-4.18.1.cjs`. repo.yarnpkg.com and mise were not reachable from the sandbox.
- The browser smoke ran on the `3289c49` build. That commit differs from `e2df476` only in the README and `Anybuild` lines, with the same Yarn release, and the app source is unchanged.

Files in `le0pard_pgtune/`:
- the patch;
- `pr-body.md`: the 48px black button, then the Wasmer employment and AI-assistance lines, the benefit, Testing and Limitations;
- `receipt.json`: public facts;
- `logs/`: base and patched plans, base (failing) and patched (passing) replays, static-web-server smokes including `/about` on native 2.32.2 and 2.38.0, a headless Chromium smoke, and the normal build.

Notes:
- Local sandbox paths are replaced with placeholders.
- Wasmer's WebAssembly static-web-server was not run here.
- The live import page may keep a different preset. The README and PR body say to select node-static in that case.
- `MANIFEST.json` and `SHA256SUMS` cover every file in this folder.
