# k8sgames export 2026-10-23: one prepared "Deploy to Wasmer" README patch

This folder holds publication inputs only. Nothing here has been submitted upstream. The publisher dedupes against the live PR inventory and checks the import page before any use.

| Repo | Base | Change | Builder result (Anybuild 0.33.1) |
|---|---|---|---|
| rohitg00/k8sgames | `main` @ `af5dbc1` | README "Host your own copy" subsection with badge; no config | `staticfile` serving the repository root on base and patched; no install or build |

Files in `rohitg00_k8sgames/`:
- the patch;
- `pr-body.md`: the 48px black button, then the Wasmer employment and AI-assistance lines, the benefit, Testing and Limitations;
- `receipt.json`: public facts, the searches as shown, acceptance risk, and the `vercel.json` hosting boundary;
- `logs/`: plans, replay, native static-web-server 2.38.0 and 2.32.2 smokes, the `/draw` proof without `vercel.json`, and the headless Chromium smoke.

Notes:
- `vercel.json` (the `/draw` rewrite, cache headers, and the user-agent redirect of crawlers to `robots.txt`) applies only on Vercel. On a generic static host, `/draw` still serves `draw.html` through static-web-server's extensionless `.html` mapping. The headers and the crawler redirect are not applied; the README and PR body say so.
- Acceptance risk is high: the owner has had no activity since 2026-04-28. This is recorded as a caveat, not as a policy restriction.
- Local sandbox paths are replaced with placeholders. Wasmer's WebAssembly static-web-server was not run here.
- `MANIFEST.json` and `SHA256SUMS` cover every file in this folder.
