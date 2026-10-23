# Portfolios export 2026-10-23: two prepared "Deploy to Wasmer" patches

This folder holds publication inputs only. Nothing here has been submitted upstream. The publisher dedupes against the live PR inventory and checks the import page before any use.

| Repo | Base | Changes | Builder result (Anybuild 0.33.1) |
|---|---|---|---|
| rammcodes/Dopefolio | `main` @ `4734cb2` | README "Deploy to Wasmer" subsection; one-line `Staticfile` (`root: .`) | base: provider node (`npm install` fails on Node 24 with node-sass 6; start `node index.js` throws). Patched: `staticfile` serving the committed files, with no install or build. |
| nisarhassan12/portfolio-template | `master` @ `f3ed885` | README "Deploy" section; no config | `staticfile` at the root on base and patched; no build |

Per target folder:
- the patch;
- `pr-body.md`: the black button (328x48), then the Wasmer employment and AI-assistance lines, the README-cited benefit, Testing and Limitations;
- `receipt.json`: public facts;
- `logs/`: plans, replays, native static-web-server 2.32.2 and 2.38.0 smokes with content types, headless Chromium smokes and link scans.

Notes:
- Dopefolio:
  - The committed `css/style.css` has the same 121 rule selectors as a fresh SASS compile (`css-check.log`).
  - The README and body state that the contact form (`action="#"`, no `method`) delivers no messages until a form service is connected, and advise against real messages until then, because the browser's default GET submission puts the fields in the page URL. They also say Google Fonts load externally.
  - Second commit on this branch: the patch was re-authored as `1e5c736` from the same base. Only that README note changed; the `Staticfile` and the served site are unchanged, so the build, static-server and browser evidence still applies.
- portfolio-template:
  - Its README has no hosting guide, and the body says only what the README says.
- Acceptance risk is high for both because outside merges are rare. It is recorded as a caveat, not a policy restriction.
- Local sandbox paths are replaced with placeholders. Wasmer's WebAssembly static-web-server was not run here.
- `MANIFEST.json` and `SHA256SUMS` cover every file in this folder.
