# 15 - ixartz/Next-JS-Landing-Page-Starter-Template

| Item | Value |
| --- | --- |
| Pinned SHA | `cd6694e6c69efad1128c1ed732188389182789df` (branch `master`, default) |
| Last commit | 2026-01-18 22:31:32 +0100 - "docs: update copyright year to 2026 in LICENSE and README" |
| Stars / forks | 2,140 / 716 (GitHub API, 2026-10-22) |
| License | MIT (`LICENSE`, "Copyright (c) 2026 Rem W."); README: "Licensed under the MIT License" |
| Package manager | npm, `package-lock.json`; no `engines`, no `packageManager` |
| Env vars | None read by app code (`grep process.env src` empty). `ANALYZE` only toggles the bundle analyzer in `next.config.js` for `npm run build-stats`. |

## Contribution / AI policy
No CONTRIBUTING, AGENTS or PR template (`.github/` holds only `FUNDING.yml`). README "Contributions": "Everyone is welcome to contribute to this project. Feel free to open an issue if you have question or found a bug." No AI policy found. Recent commit subjects use Conventional Commits (`docs: ...`), so the PR title follows that.

## Duplicate check
GitHub search `wasmer` across all 18 batch targets returned 0 PRs (2026-10-22). No prior third-party deploy-button PR outcomes were provided for this repo.

## Deviations of task notes from current source
- `next.config.js` has **no** `output: 'export'`, so this is not a static export: `next start` works (verified) and is the real production path. The README's "All generated files are located at `out` folder" text and `netlify.toml` (`publish = "out"`, `command = "npm run build-prod"`) are stale: `npm run build-prod` exits 0 but creates no `out/` (build.log). Not touched by the patch.
- README has a Netlify deploy button (in "### Deploy to Netlify"); no Vercel button. Wasmer section placed right after it, same `###` heading level.
- Customization docs say `utils/AppConfig.ts`; the actual path is `src/utils/AppConfig.ts` (patch uses the real path).

## Wasmer builder (Anybuild) - source, not guesses
Source: `wasmerio/shipit` tag `v0.33.0` = `587be23132ea` (HEAD of the provided clone is that tag; production is said to pin 0.33.0, but production may still differ). CLI built locally from that tag; `anybuild plan --wasmer` output is in build.log.
- Provider choice: node provider `FrameworkWithStart` = 45 (`providers/node.rs:1025-1031`, scores `providers/mod.rs:428-433`) beats node-static `Weak` = 20 (`next` is in `STATIC_DEPENDENCIES`, `node_static.rs:140-148`; scores `mod.rs:423-424`). node-static would only win with `output: 'export'` (`node_static.rs:189`, `701-720`, `806-808`), which this repo does not have.
- Package manager: `package-lock.json` -> npm (`node.rs:1172-1194`), npm pinned to 11 (`node.rs:1116-1123`).
- Node: 24 unless `ANYBUILD_NODE_VERSION` is set (`node.rs:561`, `608`); `.nvmrc`/`engines` are not read. Env overrides use `ANYBUILD_<FIELD>`, legacy `SHIPIT_<FIELD>` (`providers/base.rs:34-48`).
- Commands generated: install `npm install` (`resources/starlib/tools/node.bzl:21-26`), build `npx -y next-bundle@1.0.0 --build-command 'npm run build'` (`node.rs:1646-1668`, `458-471`), start `node .next-bundle/server.mjs` - the framework start command takes precedence over the `start` script (`node.rs:473-475`, `1764-1769`). So `npm start` is **not** what Wasmer runs; README wording only claims `npm run build` + "serves the production build".

## Local results (build.log)
- Repo-native: `npm ci` 0, `npm run build` 0, `npm start` on 3301: `/` 200 + title + content marker, asset 200, unknown 404.
- Builder-equivalent (clean copy, no `.git`, Node 24.22.1, npm 10.9.4 instead of 11): `CI=true npm install` 0 (husky `prepare` skips: "git command not found, skipping install"), `next-bundle@1.0.0` build 0, `node .next-bundle/server.mjs` on 3302: `/` 200 + title, asset 200.
- Found: under the next-bundle server, an unknown path (`/does-not-exist/`, `/404/`) returns 308 to itself (curl: 50 redirects), where `next start` gives 404. Likely `trailingSlash: true` handling in next-bundle@1.0.0; real pages unaffected. Recorded in PR Limitations.

## Verdict: CONDITIONAL
Patch, local build and production start are proven; detection is proven against Anybuild v0.33.0 source and plan. Remaining check for Codex: open `https://wasmer.io/apps/create?github=ixartz%2FNext-JS-Landing-Page-Starter-Template`, confirm it detects Next.js/npm and the deployed `/` renders; request an unknown path - if it loops 308 like the local next-bundle run, either keep the Limitations note as written (default) or hold until next-bundle handles `trailingSlash`.
