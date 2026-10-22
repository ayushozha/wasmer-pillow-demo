# devias-io/material-kit-react (replacement 54) — HOLD (security)

- Pinned `6423e1a2f092c50d7e1e22f3e43344df02af41de` (main); 5,580 stars / 2,550 forks (GitHub API 2026-10-22); MIT.
- Pins Next 15.3.3, which is affected by the React Server Components RCE ("React2Shell") class and later Next advisories (root review 2026-10-22). Anybuild v0.33.0 would deploy it via next-bundle as a Node server.
- Per root: do not publish README-only for a version with a known RCE. Not built here.

## Verdict: HOLD
Unhold only with a separate, reviewed Next/React security remediation (same method as magicuidesign/portfolio's `security-remediation/`) plus a next-bundle runtime replay; note the next-bundle pnpm-symlink and Turbopack-external bugs found there.
