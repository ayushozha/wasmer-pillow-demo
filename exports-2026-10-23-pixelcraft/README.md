# PixelCraft export 2026-10-23: one prepared "Deploy to Wasmer" README patch

This folder holds publication inputs only. Nothing here has been submitted upstream. The publisher dedupes against the live PR inventory and checks the import page before any use.

| Repo | Base | Change | Builder result (Anybuild 0.33.1) |
|---|---|---|---|
| rgab1508/PixelCraft | `master` @ `45a5d48` | README "Deploy Your Own Copy" section with badge; no config | `staticfile` serving the repository root on base and patched; no install or build |

Files in `rgab1508_PixelCraft/`:
- the patch;
- `pr-body.md`: the 48px black button, then the Wasmer employment and AI-assistance lines, the README-cited benefit, Testing and Limitations;
- `receipt.json`: public facts;
- `logs/`: plans, replays, native static-web-server 2.32.2 and 2.38.0 smokes, and headless Chromium smokes covering drawing, GIF export through the worker, and the service worker.

Notes:
- The README already lists two static hosts for the app (GitHub Pages and Firebase).
- Acceptance risk: the last merge was in 2023. It is recorded as a caveat, not a policy restriction.
- Local sandbox paths are replaced with placeholders. Wasmer's WebAssembly static-web-server was not run here.
- `MANIFEST.json` and `SHA256SUMS` cover every file in this folder.
