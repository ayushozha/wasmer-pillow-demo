# VERT-sh/VERT: evidence

**Verdict: HOLD (build needs env).** The default import fails. SvelteKit's `$env/static/public` validation aborts `vite build` when the `PUB_*` variables from `.env.example` are unset. The failing variables include `PUB_HOSTNAME`, `PUB_ENV`, `PUB_VERTD_URL`, `PUB_DISABLE_ALL_EXTERNAL_REQUESTS`, `PUB_DISABLE_FAILURE_BLOCKS`, `PUB_DONATION_URL` and `PUB_STRIPE_KEY`; the error is "Value is missing" (`https://svelte.dev/e/kit/env_invalid`). A one-click button would therefore fail unless the user fills in about 8 build variables on the import page. That is not a one-click experience, and a README PR cannot fix it without a code change (defaults or optional validators).

## Repository
- Pinned SHA: `257bcb3b2bb6a501bae0faf9ffb05060ee00c3f7` on `main`.
- Stars / forks: 16,058 / 856. Last push 2026-10-20 (GitHub API, 2026-10-22).
- License: AGPL-3.0.
- Merged PRs since 2025-10-01: 41.
- Duplicate `wasmer` PRs: 0.
- Prior third-party deploy PRs: #249 "Add: Vercel deployment tutorial" (open), #234 (same title, closed) and #196 "Add deployment section to README" (closed). Those docs-deploy additions have not been merged.

## Anybuild / replay
- Plan: static Node.js provider, SvelteKit with `adapter-static`, bun 1, `bun install --no-save` with `bun.lock` and `package.json` staged.
  - Staged before install: `bun.lock` and `package.json`.
- Build: `bun run build`. Output directory: `build`.
- `bun install` exited 0. `bun run build` exited 1 with the env validation error above. Result: "STATIC_DIR 'build' MISSING".

## Other notes
- `.env.example` contains `PUB_STRIPE_KEY=pk_live_…`. That is a publishable Stripe key and public by design, but it means a deploy would embed the upstream's donation key unless it is changed.
- Video conversion needs the external `vertd` server (`PUB_VERTD_URL`).
