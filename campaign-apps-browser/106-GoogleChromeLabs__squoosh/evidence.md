# GoogleChromeLabs/squoosh: evidence (triage only; no patch prepared)

**Verdict: HOLD.** There are three reasons:
1. Anybuild v0.33.0 cannot serve it. It detects a **Node.js server provider with no start command**. The plan warns: "no start or main script found in package.json" and "no entry file found for Node project". The build is `rollup -c && node lib/move-output.js` into `build/`, but nothing serves it.
2. The repo is inactive: 0 merged PRs since 2025-10-01.
3. **CLA signature required by the account owner, unresolved.** `CONTRIBUTING.md`: "Contributions to this project must be accompanied by a Contributor License Agreement... Head over to <https://cla.developers.google.com/>". It states no exemption for documentation-only changes; it covers all "Contributions". I did not sign or accept anything. Whether the submitting account already has a Google CLA on file is unknown.

## Repository
- Pinned SHA: `e8d35e0fb66eb16eff6fe8fc773eabcbb7128de3` on `dev` (default branch). Stars / forks: 26,053 / 2,186 (GitHub API, 2026-10-22). License: Apache-2.0.
- Duplicate `wasmer` PRs: 0. Prior "deploy" PRs: #710 "Deploy" (2019) and #196, both internal.
- Not replayed.
