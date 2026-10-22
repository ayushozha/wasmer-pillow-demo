# 17 - arthelokyo/tailnext

| Item | Value |
| --- | --- |
| Pinned SHA | `bad459314c915bc1424045523a23360eee2aed6e` (branch `main`, default; canonical repo, onwidget/tailnext redirects here) |
| Last commit | 2026-09-10 17:05:45 -0400 - "fix: generate types before typechecking in CI" |
| Stars / forks | 431 / 161 (GitHub API, 2026-10-22) |
| License | MIT (`LICENSE.md`, "Copyright (c) 2022 Arthelokyo") |
| Stack | Next.js 16.3.4 (Turbopack), React 19.3.0, Tailwind 4, MDX via content-collections, `sharp` 0.35.4 dependency |
| Node | `engines.node >=20.9.0`, `.nvmrc` 24. Local run used Node 22.22.0 = inside engines (CI also tests 22: `.github/workflows/ci.yml` matrix `[22, 24]`). Builder-equivalent run used Node 24.22.1. |
| Env vars | `NEXT_PUBLIC_SITE_ORIGIN` only (`src/config.ts:5`, default `https://tailnext.vercel.app`); `.env.example`: "Todas las variables son opcionales". Optional; inlined at build time. |

## Contribution / AI policy
- `CONTRIBUTING.md`: run `npm run lint`, `npm run typecheck`, `npm run prettier:check`, `npm test`, `npm run build`; "Commits follow Conventional Commits; `commitlint` enforces it through a git hook".
- `AGENTS.md` ("Guidance for automated coding agents"): same CI list under "Before finishing"; "Commits follow Conventional Commits; a git hook enforces it." No ban on AI-assisted PRs. No PR template.
- Done: prettier:check, typegen+typecheck, lint all exit 0 with the patch. Skipped: `npm test` (Storybook browser tests need `npx playwright install --with-deps chromium`, a heavy download; README-only change).
- PR title `docs: add Deploy to Wasmer button` is Conventional Commits.

## Duplicate check
GitHub search `wasmer` across all 18 batch targets returned 0 PRs (2026-10-22). No prior third-party deploy-button PR outcomes provided. README already carries Vercel and Netlify buttons in `## Deploy`, so a third host button there is in keeping.

## Deviations of task notes from current source
None material. Task notes match (Next 16, content-collections, Node >=20.9 / `.nvmrc` 24, npm). `images.qualities` is `[50, 75]` (`next.config.ts`); q=50 is used by the page and was tested.

## Wasmer builder (Anybuild) - source
`wasmerio/shipit` tag `v0.33.0` = `587be23132ea` (= HEAD of the provided clone); CLI built locally, `anybuild plan --wasmer` output in build.log. Production may differ.
- Node provider wins (`FrameworkWithStart` 45 vs node-static `Weak` 20: `providers/node.rs:1024-1033`, `providers/mod.rs:423-433`, `node_static.rs:140-148`); no `output: 'export'`.
- npm from `package-lock.json` (`node.rs:1172-1194`), npm 11 (`node.rs:1116-1123`); Node 24 default (`node.rs:561`, `608`) - matches `.nvmrc`, but `.nvmrc` itself is not read. Override: `ANYBUILD_NODE_VERSION` (`base.rs:34-48`).
- Build `npx -y next-bundle@1.0.0 --build-command 'npm run build'` (`node.rs:458-471`, `1646-1668`); start `node .next-bundle/server.mjs`, not `npm start` (`node.rs:473-475`, `1764-1769`). Install is `npm install`, not `npm ci` (`resources/starlib/tools/node.bzl:21-26`).

## Local results (build.log)
- Repo-native (Node 22): `npm ci` 0; sharp loads; `npm run build` 0; `npm start` on 3321: `/` 200 + title, `/blog/demo-post-1` 200 + post title, `/sitemap.xml` 200, `/_next/image?...camera-back...&w=640&q=50` 200 (`image/webp` with Accept; `image/jpeg` 9,842 bytes, `X-Nextjs-Cache: MISS`, source 156,914 bytes - sharp really resized), `q=80` 400 (not in `images.qualities`, expected).
- Builder-equivalent (clean copy without `.git`, Node 24.22.1, builder's commands): `CI=true npm install` 0, next-bundle build 0, `node .next-bundle/server.mjs` on 3322: `/`, `/blog/demo-post-1`, `/sitemap.xml` 200; unknown 404; image URL 200 `image/webp` but **147,038 bytes** with or without Accept header, and `q=80` returned **200** instead of 400. The bundle ships `sharp`, `@img/sharp-linux-x64`, `@img/sharp-wasm32` and `@cf-wasm/photon` (next-bundle@1.0.0 deps); its image path behaves differently from `next start`.

## Verdict: CONDITIONAL
Patch, prettier/lint/typecheck, build and production start proven; detection proven from Anybuild v0.33.0 source + plan. Condition (sharp on Wasmer): Codex deploys via `https://wasmer.io/apps/create?github=arthelokyo%2Ftailnext`, confirms Next.js/npm detection, then requests `/_next/image?url=%2F_next%2Fstatic%2Fmedia%2F<camera-back hash>.jpg&w=640&q=50` on the deployed app and checks it is 200 with an image body. If 200, open as written (Limitations already note optimizer differences); if it fails, HOLD.
