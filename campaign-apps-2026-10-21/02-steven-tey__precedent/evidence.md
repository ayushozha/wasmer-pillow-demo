# Evidence: steven-tey/precedent

## Verdict: CONDITIONAL

The patch is ready, and the local build and start are proven. Before opening the PR, Codex must confirm one item: on `https://wasmer.io/apps/create?github=steven-tey%2Fprecedent`, Next.js is detected with pnpm 9.3.0, the build succeeds, and with a free Clerk development app's `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY` / `CLERK_SECRET_KEY` the home page renders and the Sign In modal opens. Without Clerk keys the home page returns 500, so a key-less smoke on Wasmer would look broken.

There is also a soft acceptance risk. The repo has had no commits since 2024-10, and it pins `next@14.3.0-canary.57`.

## Repo facts
- Pinned SHA: `3be40205d7cdf56082cd284f07f12251b9208f79` (branch `main`), last commit 2024-10-02T13:28:58-07:00.
- Stars / forks: 5,114 / 493 (GitHub API, 2026-10-22).
- License: MIT (`LICENSE.md`).
- Contribution / AI policy: there is no `.github` folder, CONTRIBUTING, PR template or AI policy. Commit history is mostly merge commits, so the PR title uses a plain `docs:` prefix.
- Duplicate check: a GitHub search for `wasmer` across all 18 targets returned 0 PRs (2026-10-22).
- Existing deploy button: Vercel only, under `## One-click Deploy`. The Wasmer button is added in that section, below the Vercel button.

## Task notes vs current source
- Auth is **Clerk** (`@clerk/nextjs@^5.6.2`), not NextAuth. `.env.example` lists `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY`, `CLERK_SECRET_KEY`, `NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL=/` and `NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL=/`. The two redirect vars are left at their defaults and not documented in the patch.
- Next canary is confirmed: `next@14.3.0-canary.57`, and `packageManager` pins `pnpm@9.3.0`.
- The Clerk middleware lives at `app/middleware.ts`. Next only loads middleware from the project root or `src/`, so it is **inactive**, and the build output lists no Middleware. I did not change this; it is noted only.
- The redirect `/github` returns 307 to `https://github.com/steven-tey/precedent` (works).
- `app/opengraph-image.tsx` (edge) fetches `https://precedent.dev/logo.png` at request time. Here that fetch fails (sandbox egress), so the OG route returns an empty reply. On Wasmer it depends on precedent.dev staying up. This is not Wasmer-specific.
- The home page fetches `api.github.com/repos/steven-tey/precedent` (optional `GITHUB_OAUTH_TOKEN`) with a 24h revalidate. Failures are caught.

## Required vs optional env (verified)
- Build: **no env needed**. `corepack pnpm build` passed with no Clerk keys (exit 0).
- Runtime without keys: `/` returns **500**, with `@clerk/nextjs: Missing publishableKey` (build.log).
- Runtime with a format-valid placeholder publishable key (`pk_test_` + base64 `example.clerk.accounts.dev$`, not a real Clerk app) and `CLERK_SECRET_KEY=sk_test_placeholder`, set **at runtime only, without rebuilding**: `/` returns **200** with "Building blocks for your Next project". So the keys do not have to exist at build time.
- `CLERK_SECRET_KEY`: I did not isolate whether the page renders without it. The patch marks it required, as `.env.example` and the upstream Vercel button do.
- `GITHUB_OAUTH_TOKEN`: optional.

## Local commands (Node v22.22.0, pnpm 9.3.0 via corepack)
`corepack pnpm install --frozen-lockfile` (exit 0), then `corepack pnpm build` (exit 0), then `corepack pnpm start` on PORT 3102, then curl. Full output is in build.log. `/sitemap.xml` returned 404 (the build lists the route as `/sitemap`), which is unrelated to this patch.

## Wasmer builder (Anybuild) facts
Source: `wasmerio/shipit@587be23132ea` (2026-10-05). Production may run a different builder version.
- The package manager comes from `packageManager` (`crates/anybuild/src/providers/node.rs:1172-1183`), and its version is taken from that field, giving 9.3.0 (`node.rs:1128-1158`).
- Install is `pnpm install` with `CI=true` (`resources/starlib/tools/node.bzl:21-26, 119-130`), which makes it frozen.
- Next.js is detected from the dependency (`node.rs:1318`).
- Build is `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'` (`node.rs:23, 458-471, 1646-1667`). Start is `node .next-bundle/server.mjs` (`node.rs:473-475, 1765-1769`), not `next start`. This is why the README says "serves the production build with Node" and does not claim `next start`.
- Node 24 by default (`node.rs:561, 608`; `ANYBUILD_NODE_VERSION` overrides it, per `providers/base.rs:34-43`). Local tests ran on Node 22.

## Limitations
No Wasmer deployment was submitted. wasmer.io and img.shields.io are blocked here, so detection and badge rendering are unverified. No real Clerk keys were used.
