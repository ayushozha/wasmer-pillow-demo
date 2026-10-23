# beepbox export 2026-10-23: one prepared "Deploy to Wasmer" patch

This folder holds publication inputs only. Nothing here has been submitted upstream. The publisher dedupes against the live PR inventory and checks the import page before any use.

| Repo | Base | Changes | Builder result (Anybuild 0.33.1) |
|---|---|---|---|
| johnnesky/beepbox | `main` @ `355e510` | README "Hosting your own copy" section with badge; root `Anybuild` | base: provider node, `npm run build`, with no output directory and no start command, so nothing is served. Patched: "declared in Anybuild", node-static, `static_dir = "website"`, npm 11. |

`Anybuild` is the output of `anybuild generate . --provider node-static` (0.33.1) with two edits: `static_dir` set to `"website"` and the app name. See `Anybuild.generated-0.33.1` and `Anybuild.diff`. The rendered Docker build runs `mise use --global "npm@11"`, a major-version pin equal to the generator default. The replay confirms npm 11 installs the exact `package-lock.json` tree.

Files in `johnnesky_beepbox/`:
- the patch;
- `pr-body.md`: the 48px black button, then the Wasmer employment and AI-assistance lines, the README-cited benefit, Testing and Limitations;
- `receipt.json`: public facts;
- `logs/`: plans, the Docker render, the normal build, replay and lockfile check, native static-web-server 2.32.2 and 2.38.0 smokes, and headless Chromium smokes.

**Status: PREPARED_GATED.** Root is independently inspecting the scope of two maintainer statements before any publication. They are recorded verbatim in `receipt.json` (`maintainer_statements`), not as approval:
- https://github.com/johnnesky/beepbox/pull/143 (a mod PR, closed unmerged): "You'll need to make your own repo. This repo isn't for mods."
- https://github.com/johnnesky/beepbox/pull/154 (a README-only PR, closed unmerged): "Denied. It looks like this was intended for a fork, not the actual BeepBox repository."

Notes:
- Acceptance risk is high: there have been few outside merges ever.
- Local sandbox paths are replaced with placeholders. Wasmer's WebAssembly static-web-server was not run here.
- `MANIFEST.json` and `SHA256SUMS` cover every file in this folder.
