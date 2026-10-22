# Evidence: transitive-bullshit/nextjs-notion-starter-kit

| Item | Value |
| --- | --- |
| Branch / pinned SHA | `main` @ `e787e7b594f1ca6fe7445e1866d4d4668c533737` |
| Last commit | 2026-10-18T21:50:20+07:00, "docs: add code of conduct" |
| Stars / forks | 7,033 / 5,641 (GitHub API, 2026-10-22) |
| License | MIT (`license`; README "MIT © Travis Fischer") |
| Contribution policy | `contributing.md` (suggestions and PRs "highly encouraged"); `AGENTS.md`: "use `pnpm`", "oxfmt for formatting (`pnpm fix:format`)", "oxlint for linting"; `.github/pull_request_template.md` headings `#### Description` and `#### Notion Test Page ID` - PR_BODY.md keeps both. No AI-disclosure policy. Commit style: Conventional (`docs: add code of conduct`). |
| Duplicate check | GitHub search `wasmer` across all 18 batch targets returned 0 PRs (2026-10-22) |
| Prior third-party deploy-button PRs | None provided for this target |

## Source facts (at pinned SHA)

- `package.json`: `build` = `next build`, `start` = `next start`, `engines.node >=22`, `packageManager: pnpm@11.25.0`; `pnpm-lock.yaml`; `pnpm-workspace.yaml` `allowBuilds` includes `sharp`. Next.js ^16.3.4 (16.3.4 installed).
- Env read by code: optional `NEXT_PUBLIC_FATHOM_ID`, `NEXT_PUBLIC_POSTHOG_ID` (`lib/config.ts`), `REDIS_HOST`/`REDIS_PASSWORD`/`REDIS_USER`/`REDIS_URL`/`REDIS_NAMESPACE`/`REDIS_ENABLED` (only when Redis is enabled), `NOTION_API_BASE_URL` (`lib/notion-api.ts`), `NEXT_PUBLIC_SITE_CONFIG`, `PORT`, `VERCEL_URL`/`VERCEL_ENV`. None required. `.env.example` lists `TWITTER_ACCESS_TOKEN` but no current code reads it, so the README section omits it.
- Root page: `rootNotionPageId: '7875426197cf461698809def95960ebf'` in `site.config.ts`.
- Native deps: `sharp` 0.35.4 (loads here, linux-x64 prebuilt) and `lqip-modern` (`lib/preview-images.ts`), used when `isPreviewImageSupportEnabled` (default `true`).
- README `readme.md` has a manual TOC; patch adds `Deploy on Wasmer` under `Setup` after `Vercel Configuration` and a TOC entry. `oxfmt --check readme.md` passes before and after.

## Deviations from task notes

- Notion API host the build calls is `https://app.notion.com/api/v3/...` (not notion.so); both are blocked by the sandbox proxy (CONNECT 403, see build.log).
- Repo `packageManager` pins pnpm 11.25.0; used via corepack instead of the preinstalled pnpm 10.28.

## Build / smoke (see build.log)

- `corepack pnpm install --frozen-lockfile` exit 0.
- `corepack pnpm build` exit 1: compiled successfully and TypeScript passed, then `Error loading page "78754261-97cf-4616-9880-9def95960ebf"` / `Failed to collect page data for /[pageId]` because `loadPageChunk` fetch failed (network blocked). Real error, not a code fault.
- Production start not run (no build output).

## Wasmer builder behaviour (wasmerio/shipit @ 587be23132ea = tag `v0.33.0`, 2026-10-05; production reportedly pins Anybuild 0.33.0, but its config may still differ)

- Package manager: `packageManager: pnpm@11.25.0` -> pnpm (`crates/anybuild/src/providers/node.rs:1172-1197`), version taken from that field (`node.rs:1128-1158`), so pnpm 11.25.0, the same version used here via corepack.
- Install: `pnpm install` with `CI=true`, `pnpm_config_minimum_release_age=0`, `pnpm_config_dangerously_allow_all_builds=true`, `pnpm_config_strict_dep_builds=false` (`resources/starlib/tools/node.bzl:21-26, 95-139`). Only `package.json` + `pnpm-lock.yaml` exist during install (`node.bzl:115-116, 139`), so `pnpm-workspace.yaml` (`allowBuilds`, `minimumReleaseAge`) is not visible then. The env above covers both (sharp's install script is allowed), but the step itself was not exercised.
- Framework: `next` dependency -> Next.js (`node.rs:1318-1320`). Build: `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'` (`node.rs:23, 458-471, 1646-1667`). Start: `node .next-bundle/server.mjs` (`node.rs:473-475, 1764-1768`); the `start` script is not used.
- Node `24` default (`node.rs:561, 608`); `engines >=22` is satisfied. The repo CI uses Node 24 (`.github/workflows/build.yml`); local tests here used 22.22.0.
- The build reaches Notion during `next build`, so the Wasmer build environment needs outbound HTTPS to `app.notion.com`. The next-bundle emulation was not run for this target because `next build` cannot finish here.

## Verdict: CONDITIONAL

Patch is ready and format-checked, but no production build/start was possible here. Remaining check for Codex: on a network-enabled machine run `pnpm install --frozen-lockfile && pnpm build && PORT=3000 pnpm start`, curl `/` (expect 200 with "Next.js Notion Starter Kit") and one sub-page; then open `https://wasmer.io/apps/create?github=transitive-bullshit%2Fnextjs-notion-starter-kit` and confirm Next.js detection, that the build reaches Notion, and that `sharp`/`lqip-modern` work in Wasmer's build (if not, note `isPreviewImageSupportEnabled: false` as the workaround before opening the PR).
