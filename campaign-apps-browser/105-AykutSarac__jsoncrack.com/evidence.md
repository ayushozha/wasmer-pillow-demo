# AykutSarac/jsoncrack.com: evidence (triage only; no patch prepared)

**Verdict: POLICY HOLD (issue-first).** `CONTRIBUTING.md`, "Before You Start: The Issue-First Workflow": "**Always open or find an issue BEFORE you start coding.** ... 3. **Wait for approval** — I'll review and give feedback ... 4. **Once approved**, you can start coding". This stays held until a maintainer has approved the idea in an issue. It is not to be routed around.

## Repository
- Pinned SHA: `a46d0d0adb098e12e577a083e87ead7f61f90098` on `main`. Stars / forks: 44,514 / 3,577 (GitHub API, 2026-10-22).
- Merged PRs since 2025-10-01: 5. Duplicate `wasmer` PRs: 0. Prior "deploy" PR: #359 "Deploying image to ghcr for ease of use" (closed 2024-09-29).
- Turborepo monorepo (`apps/www`, `apps/vscode`, `apps/chrome-extension`, `packages/jsoncrack-react`). `packageManager: pnpm@10.20.0`. `pnpm-workspace.yaml` exists.

## Anybuild detection (v0.33.0)
- **Node.js server provider**, not static: `pnpm install`, then `pnpm run build` (`turbo run build`), then start `turbo run start`. `apps/www` uses `output: "export"` (`apps/www/next.config.*`, line 9), so its export would be static, but Anybuild doesn't detect it from the root. `pnpm-workspace.yaml` is not among the staged install inputs (the package.json files only). This is the known workspace-input gap. See plan.txt.
- Not replayed.

## Security: Next.js version shipped (`apps/www` depends on `next` 16.3.5, lockfile)
`python3 -I adv.py next@16.3.5` returns 7 advisories:
- critical GHSA-vcvr-r3jv-pc5j "Remote Code Execution in next/og ImageResponse" (>=16.2.0 <16.3.6).
- high GHSA-cjq9-62q9-8jv4 "SSRF in Image Optimization" (<16.3.8).
- 4 moderate (metadata image info disclosure, two SSG/ISR cache-poisoning issues, Draft Mode leak).
- 1 low (dev-server MCP endpoint).

Most of these are server-side features: next/og, image optimization and ISR don't run on a pure static export. That still needs a reviewed analysis of what the export ships, or an upgrade to >=16.3.8, before any qualification.
