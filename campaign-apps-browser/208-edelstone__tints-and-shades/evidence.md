# edelstone/tints-and-shades: evidence

**Verdict: POLICY HOLD (issue first).** Technically the build passes.

- Pinned SHA `02d8480ac4fabb622ad79e8717364ab716dc50a9` on `main` (last commit 2026-10-15). Stars/forks 588 / 64 (GitHub API, 2026-10-22). License present (`LICENSE`). `wasmer repo:edelstone/tints-and-shades` → 0 PRs.
- Policy: README "Feedback and contributing": "If you’d like to contribute, comment on an [open issue] or open a new one describing your approach. Once aligned, submit a PR." Under the campaign gate this is issue-first → POLICY HOLD; not to be routed around. `AGENTS.md` also notes the README is partially generated from `src/shared/about.html` via `build-readme.js` ("Do not hand-edit generated README sections without also updating the source"), so any future patch must edit the source and run `npm run build:readme`.
- Anybuild v0.33.0 (plan.txt): static Node.js, Astro, npm workspaces (`packages/tints-and-shades/package.json` is detected, so the plan installs with all files), output `dist`.
- Replay (unpatched; no patch written because of the policy hold), replay.log / smoke-receipt.txt: `npm install` and `npm run build` exit 0; `/` 200, `/about/` 200, the Astro JS chunks 200; `/nope` 404.
- Remaining step: the account owner decides whether to open an issue first. Do not open a PR before the maintainer agrees.
