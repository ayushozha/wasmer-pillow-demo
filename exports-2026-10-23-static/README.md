# Static export 2026-10-23: three prepared "Deploy to Wasmer" README patches

This folder holds publication inputs only. Nothing here has been submitted upstream. The publisher dedupes each target against the live PR inventory before any use.

| Repo | Base | Changes | Builder result (Anybuild 0.33.1) |
|---|---|---|---|
| Kirilllive/ASCII_Art_Paint | `main` @ `3477035` | README section with badge | `staticfile` on base and patched; no build |
| pmotschmann/Evolve | `DeadSpace` @ `88aecff` (dev branch per README) | README section with badge, one-line `Staticfile` | base `node` (`node src/index.js`), patched `staticfile` serving `.` |
| cssninjaStudio/fresh | `main` @ `420e73e` | README step with badge, root `Anybuild` | base `node` (`astro dev`), patched `node-static` / `dist` with pnpm 8.15.9 |

Per target folder:
- `OWNER_REPO.patch`: `git format-patch` output, authored by Claude.
- `pr-body.md`: the first line is `Title:`. Next comes the 48px black Deploy to Wasmer button, then the affiliation line, the repo-specific benefit, Testing and Limitations.
- `receipt.json`: public facts only: license, policy reading, build, detection, replay, static-server smoke, and hook check.
- `logs/`: plan output from Anybuild 0.33.1 (wasmerio/shipit `v0.33.1`, `2ed7f86`), flat replays of the planned steps, native static-web-server smokes, and normal builds where relevant.

Notes:
- Local sandbox paths are replaced with placeholders such as `<clone>` and `<replay>`, and analytics-tag values with `<analytics-tag>`.
- The static-server smokes used native static-web-server 2.38.0. Wasmer serves with its own static-web-server 2.32.2 wasm build, which was not run here.
- The badge link builds the repository's default branch. Evolve's patch targets `DeadSpace`, so until it reaches `master`, users must select a branch containing the `Staticfile` in the import page's branch setting. The README and PR body say so.
- `MANIFEST.json` lists base SHAs and patch and body hashes. `SHA256SUMS` covers every file in this folder.
