# pgtune export 2026-10-23: one prepared "Deploy to Wasmer" patch

This folder holds publication inputs only. Nothing here has been submitted upstream. The publisher dedupes against the live PR inventory and checks the import page before any use.

| Repo | Base | Changes | Builder result (Anybuild 0.33.1) |
|---|---|---|---|
| le0pard/pgtune | `master` @ `0208aa2` | README "Deploy" section with badge; root `Anybuild` | base: node-static/vite/yarn/`dist`, but install sees only `package.json`, so Yarn 4 uses Plug'n'Play and the build fails. Patched: "declared in Anybuild", the same, with `node_install_requires_all_files = True`, so the build passes. |

`Anybuild` is the output of `anybuild generate . --provider node-static` (0.33.1) with two edits: `node_install_requires_all_files = True` with a comment, and the app name. See `Anybuild.generated-0.33.1` and `Anybuild.diff`. The field is a supported Anybuild 0.33.1 field (`crates/anybuild/src/providers/node.rs`, `resources/starlib/tools/node.bzl`).

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
