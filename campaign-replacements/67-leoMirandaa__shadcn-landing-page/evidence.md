# leoMirandaa/shadcn-landing-page (67): HOLD, duplicate (campaign PR already open)

- Pinned `ae3716dbce5c8a26815222bb743994b5717938f1` (main, last commit 2024-10-08); 1,981 stars / 422 forks (GitHub API 2026-10-22); MIT (Copyright (c) 2024 Leopoldo Miranda).
- **Duplicate:** PR #32 "docs: add Wasmer Edge deploy option" by ayushozha is already open (created 2026-10-22T05:07Z). Do not open another PR. This folder only adds replay evidence that #32's reviewer can use.
- Anybuild v0.33.0: node-static, Vite, npm (`package-lock.json` + `package.json` staged), `npm install` / `npm run build` (`tsc && vite build`), output `dist`. There is no router: it is a single page with `#section` anchors.
- Replay of a README-only patch: install exit 0, build exit 0, 10 files. Smoke `/` and `/#features` 200; JS/CSS/icon 200; all 5 JS-imported PNGs 200 (appended to replay.log). npm audit reports 24 build-time vulnerabilities (Vite 5 toolchain); the output is pure static.
- Maintainer activity: last merged PR #17 (2024-10-09); several later PRs were closed unmerged.
- Note: this replay ran before the harness npm-version fix (npm 10.9.4, not the plan's npm 11). Not re-run because the target is a duplicate HOLD.
