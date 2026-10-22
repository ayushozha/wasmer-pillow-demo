# rawgraphs/rawgraphs-app: evidence

**Verdict: HOLD (builder: `.npmrc` not staged).** Also a CLA gate (see Policy).

- Pinned SHA `48c3b2ee9ff412721a2c99c7bed38e734b3fa534` on `master` (default; last commit 2026-10-08). Stars/forks 9,044 / 1,840, not archived (GitHub API, 2026-10-22). License Apache-2.0. `wasmer repo:rawgraphs/rawgraphs-app` → 0 PRs.
- Anybuild v0.33.0 plan (plan.txt): static Node.js, Vite, npm, output `dist`; install inputs `package-lock.json` + `package.json` only.
- Replay (unpatched clone; no patch was written because the build fails), replay.log: `npm install` **exit 1, `ERESOLVE could not resolve`** (`react-data-grid@7.0.0-canary.16` peer `react@^16.8` vs root `react@^18.3.1`). The repo's `.npmrc` contains `legacy-peer-deps=true`, but Anybuild's staged install copies only the lockfile and `node_install_inputs` (`crates/anybuild/resources/starlib/tools/node.bzl:95-140`: `copy(lockfile)` then `run(install, inputs = config.node_install_inputs)`), and `discover_js_install_context` (`src/providers/install_context.rs:124`) never adds `.npmrc`. So npm resolves without the repo's setting and fails. `npm run build` then fails (`vite: not found`, exit 127), `dist` missing, `/` 404 (smoke-receipt.txt).
- Classification: workspace/config input gap (`.npmrc` not staged) — a real Anybuild limitation. A README-only PR cannot fix it; changing dependencies to satisfy peers is out of scope.
- Policy: `CONTRIBUTING.md`: "You will need to sign a Contributor License Agreement (CLA) ... before making a submission" with the exemption "very small contributions (such as fixing spelling errors), where the content change is small enough to not be considered intellectual property, can be submitted ... without a CLA". Whether a README button counts is unresolved: "CLA signature required by the account owner — unresolved" unless the maintainer agrees it is exempt.
- App fit (for later): single-page client-side chart builder, no router, only `VITE_APP_VERSION` read.
- Re-check when Anybuild stages `.npmrc`.
