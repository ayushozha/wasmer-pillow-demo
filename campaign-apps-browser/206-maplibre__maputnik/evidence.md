# maplibre/maputnik: evidence

**Verdict: HOLD (builder: `.npmrc` not staged).**

- Pinned SHA `d281e87069411deb4ff58f1cc27a1ff005413a21` on `main` (last commit 2026-10-21). Stars/forks 2,659 / 478, not archived (GitHub API, 2026-10-22). License MIT. `wasmer repo:maplibre/maputnik` → 0 PRs.
- Policy (no blocker found): `AGENTS.md` "Pull Requests: Pull requests should update `CHANGELOG.md` with a short description of the change." `.github/PULL_REQUEST_TEMPLATE.md` "Launch Checklist" (describe changes, link issues, visuals, tests, add an entry to `CHANGELOG.md` under `## main`). No CLA. Existing deploy docs: README Docker (`ghcr.io/maplibre/maputnik:main`) and the hosted editor.
- Anybuild v0.33.0 plan (plan.txt): static Node.js, Vite, npm, output `dist`; staged inputs `package-lock.json` + `package.json`.
- Replay (unpatched; no patch written because the build fails), replay.log: `npm install` **exit 1, `ERESOLVE could not resolve`** (`eslint-plugin-react@7.37.5` peer range vs root `eslint@^10.13.0`). The repo's `.npmrc` has `legacy-peer-deps = true`, which Anybuild does not stage (`node.bzl:95-140`; `install_context.rs:124` never adds `.npmrc`). `npm run build` then exit 1; `dist` missing; `/` 404 (smoke-receipt.txt).
- Classification: config input gap (`.npmrc` not staged) — Anybuild limitation; not fixable in a README PR.
- App fit (for later): single-page MapLibre style editor; style state in localStorage / `?style=` query; reads only `BASE_URL`/`MODE`. A future PR must also add a CHANGELOG entry per AGENTS.md.
