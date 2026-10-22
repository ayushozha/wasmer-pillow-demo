# magicuidesign/portfolio — Next.js security remediation (for root's PR46, now draft)

Base: upstream `main` @ `5ef12e4c8bd0de3e22e89c2181ee77a35925ec8b` (still the upstream HEAD on 2026-10-22). Pins `next` 16.1.1, `eslint-config-next` 16.1.1, `react`/`react-dom` ^19.2.3 (lock: 19.2.3).

## Advisory data (official npm registry bulk advisory endpoint, 2026-10-22) — `npm-advisories.txt`
| version | advisories | notes |
| --- | --- | --- |
| next 16.1.1 (current pin) | 38 | incl. GHSA-h25m-26qc-wcjf (RSC deserialization DoS, <16.1.5) and two criticals (<16.3.3) |
| next 16.1.7 (latest 16.1.x) | 30 | not sufficient |
| next 16.2.12 (latest 16.2.x) | 8 | incl. critical GHSA-vcvr-r3jv-pc5j next/og RCE (>=16.2.0 <16.3.6) — this repo uses next/og |
| **next 16.3.8** | **0** | lowest release with no advisories → security floor |
| next 16.4.2 (latest) | 0 | also clean |
| react / react-dom 19.2.3 | 0 | unchanged |

## Patches (package.json + pnpm-lock.yaml only; README button commit untouched; both `git apply --check` on 5ef12e4)
- `security-fix.patch` — `next` 16.1.1 → 16.3.8 and `eslint-config-next` 16.1.1 → 16.3.8 (exact pins kept), lockfile via `pnpm add … --save-exact --lockfile-only` (pnpm 10.34.7; lockfileVersion 9.0 unchanged). Lock changes are next's own dependency tree (e.g. `@img/sharp-*` 0.34.5→0.35.5, `@emnapi/runtime`), see `lockfile-update.log`.
- `security-fix-with-swc-helpers.patch` — same plus an explicit `"@swc/helpers": "0.5.23"` dependency (the exact version next 16.3.8 depends on). Only needed as a workaround for the Wasmer bundler bug below.

`pnpm audit --prod` after the fix: no `next`/`react` findings; remaining findings (low 1, moderate 8, high 16, critical 0; base had critical 2) are all transitive build-time toolchain paths that predate this change (`remaining-transitive-audit-paths.txt`: content-collections/mdx-bundler/gray-matter, @tailwindcss/postcss, next>styled-jsx>@babel/core). Out of the Next/React scope; not touched.

## Runtime evidence — exact Anybuild v0.33.0 Wasmer path (`tools`-equivalent `replay_next.sh`: flat copy, staged `pnpm install` with node.bzl env, `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'`, `node .next-bundle/server.mjs`, Node 24.22.1)
| route | base 16.1.1 | 16.3.8 (`security-fix.patch`) | 16.4.2 | 16.3.8 + `@swc/helpers` |
| --- | --- | --- | --- | --- |
| `/` + assets | 200 | 200 | 200 | 200 |
| `/blog` | 200 | **500** | **500** | 200 |
| `/blog/api-design-principles`, `/git-workflow-guide`, `/testing-react-apps` | 200 | **500** | **500** | 200 |
| `/blog/typescript-best-practices` | 500 (shiki) | 500 | – | 500 (shiki) |
| `/blog/nextjs-performance-tips` | not reached in base run | – | – | 500 (shiki) |
| `/opengraph-image`, `/blog/opengraph-image`, post OG | 500 | 500 | 500 | not requested |
| `/does-not-exist` | 404 | 404 | – | 404 |

Causes (server logs in `replay-*.log`):
- 16.3.8/16.4.2 `/blog` 500: `Cannot find module '@swc/helpers/_/_interop_require_default'` — next-bundle@1.0.0 copies `.pnpm/@swc+helpers@0.5.23` into the bundle but drops the pnpm symlink next resolves it through (same bug class as blinkshot). Anybuild doesn't stage `.npmrc`, so `node-linker=hoisted` can't be used as a fix.
- shiki posts 500 (also on base): `Cannot find package 'shiki-2815f43ca43e8bcc'` — next-bundle doesn't resolve Turbopack's hashed external alias. Pre-existing.
- OG 500/timeout: the OG routes `fetch()` remote images; outbound hosts are blocked here. Not a Next regression.
- Control: `next start` on the 16.3.8 build serves `/`, `/blog`, `/blog/api-design-principles` with 200 (`next-start-16.3.8.log`).

## Recommendation
- The upstream security fix itself is correct and minimal: `security-fix.patch` (16.3.8 floor). It does not need the `@swc/helpers` line for `next start`/Vercel/Node hosting.
- On Wasmer's current builder, 16.3.8 breaks `/blog` unless `@swc/helpers` is added explicitly, and even then code-highlighted posts 500 (pre-existing next-bundle limitation, now 2 posts observed). So PR46 should stay DRAFT/HOLD for Wasmer readiness until next-bundle handles pnpm symlinks and Turbopack hashed externals; report both to wasmerio. If root still wants a Wasmer-working variant, `security-fix-with-swc-helpers.patch` is the tested option, with the shiki limitation disclosed.
- No exploit was attempted and nothing was deployed.
