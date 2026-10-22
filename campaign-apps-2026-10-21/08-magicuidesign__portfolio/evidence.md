# Evidence: magicuidesign/portfolio

| Item | Value |
| --- | --- |
| Upstream | `magicuidesign/portfolio` (GitHub API `full_name`; README still links `dillionverma/portfolio`, which redirects) |
| Branch / pinned SHA | `main` @ `5ef12e4c8bd0de3e22e89c2181ee77a35925ec8b` |
| Last commit | 2026-01-13T11:26:06-05:00, "Nextjs 16 tailwindcss v4 (#32)" |
| Stars / forks | 1,516 / 432 (GitHub API, 2026-10-22) |
| License | MIT (`LICENSE`, "Copyright (c) 2024 Dillion Verma") |
| Contribution / AI policy | None found: no CONTRIBUTING, AGENTS, `.github/` or PR template in the repo |
| Duplicate check | GitHub search `wasmer` across all 18 batch targets returned 0 PRs (2026-10-22) |
| Prior third-party deploy-button PRs | None provided for this target |

## Source facts (at pinned SHA)

- `package.json`: `build` = `next build`, `start` = `next start`, `engines.node >=18.0.0`, no `packageManager` field; lockfile `pnpm-lock.yaml`.
- Next.js 16.1.1, content via `content-collections` (`content-collections.ts`, MDX in `content/`), wrapped in `next.config.mjs` via `withContentCollections`.
- No `process.env` reads in `src/`, `next.config.mjs` or `content-collections.ts`; no `.env.example`. No database.
- Customization file: `src/data/resume.tsx` (README: "single config file"); posts in `content/*.mdx`.
- Existing deploy button: Vercel, inline in the H1 title line. Wasmer badge placed beside it (not repeated in the section); short `# Deploy on Wasmer` section (repo uses H1 for sections) before `# License`.

## Deviations from task notes

- Task notes match current source. Note README claims "Next.js 14"; actual is 16.1.1 (not changed by this patch).

## Build / smoke (see build.log)

- `pnpm install --frozen-lockfile` exit 0 (pnpm 10.28 ignored build scripts for esbuild@0.25.12, sharp@0.34.5; build still succeeded).
- `pnpm build` exit 0. `PORT=3201 pnpm start`: `/` 200 (name marker x13), `/blog` 200, `/blog/api-design-principles` 200 (title present), `/does-not-exist` 404.
- `/opengraph-image`: empty reply; server log `Can't load image https://dillion.io/me.png: fetch failed` (outbound host blocked in sandbox; the OG route fetches the avatar via `new URL(DATA.avatarUrl, DATA.url)`). Environment-specific, not caused by the patch. On Wasmer it will depend on outbound fetch to the configured `DATA.url`.

## Wasmer builder behaviour (wasmerio/shipit @ 587be23132ea = tag `v0.33.0`, 2026-10-05; production reportedly pins Anybuild 0.33.0, but its config may still differ)

- Package manager: no `packageManager`, no `pnpm-workspace.yaml`, `pnpm-lock.yaml` -> pnpm (`crates/anybuild/src/providers/node.rs:1172-1197`); pnpm version default `10` (`node.rs:1116-1124`).
- Install: `pnpm install` with `CI=true`, `pnpm_config_dangerously_allow_all_builds=true` (`resources/starlib/tools/node.bzl:21-26, 95-139`).
- Framework: `next` dependency -> Next.js (`node.rs:1318-1320`).
- Build: `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'` (`node.rs:23, 458-471, 1646-1667`).
- Start: `node .next-bundle/server.mjs` (`node.rs:473-475, 1764-1768`; `node.bzl:209-211`); the `start` script is not used.
- Node `24` default (`node.rs:561, 608`); `engines >=18` satisfied. No config file needed.

Emulated locally (build.log): `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'` exit 0 ("Build output written to .next-bundle"); `node .next-bundle/server.mjs` from an empty dir holding only `.next-bundle` (port 3207): `/` 200 (name marker present), `/blog` 200, `/blog/api-design-principles` 200, `/does-not-exist` 404.

## Verdict: READY

README-only patch. Build and production start verified locally with the repo's lockfile, both with `next start` and with the emulated Wasmer next-bundle build/serve. Remaining check for Codex (standard for the batch): open `https://wasmer.io/apps/create?github=magicuidesign%2Fportfolio` and confirm Next.js detection and the build/start commands before opening the PR.
