# Leads export 2026-10-23: one prepared "Deploy to Wasmer" README patch

This folder holds publication inputs only. Nothing here has been submitted upstream. The publisher dedupes against the live PR inventory and checks the import page before any use.

| Repo | Base | Change | Builder result (Anybuild 0.33.1) |
|---|---|---|---|
| pshenok/server-survival | `main` @ `52fc46f` | README "Host your own copy" subsection with badge | `staticfile` serving the repository root on base and patched; no install or build |

Files in `pshenok_server-survival/`:
- `pshenok_server-survival.patch`: `git format-patch` output, authored by Claude.
- `pr-body.md`: the first line is `Title:`. Next come the 48px black Deploy to Wasmer button, the Wasmer employment line, the AI-assistance line, the repo-specific benefit, Testing and Limitations.
- `receipt.json`: public facts only: license, policy reading with the URLs read, dedupe search, build, detection, replay, static-server smoke, and hook check.
- `logs/`: the Anybuild 0.33.1 plan, a flat replay of the planned steps, a native static-web-server 2.38.0 smoke, and the upstream CI-equivalent checks (`npm ci`, lint, tests).

Notes:
- Local sandbox paths are replaced with placeholders.
- Wasmer serves with its own static-web-server 2.32.2 wasm build, which was not run here.
- Other leads reviewed in this wave were held, so they are not included.
- `MANIFEST.json` lists the base SHA and the patch and body hashes. `SHA256SUMS` covers every file in this folder.
