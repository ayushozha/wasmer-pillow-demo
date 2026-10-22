# midudev/porfolio.dev: evidence

**Verdict: HOLD (policy, not built).**

## Repository
- Pinned SHA: `9ac1724b5a6506e14eec8b1babf9836c19321a2c` on branch `main`.
- Stars / forks: 1,470 / 580. The repo is not archived and was last pushed 2026-06-09 (GitHub API, 2026-10-22).
- Recent merged PRs since 2025-10-01: 11. Duplicate `wasmer` check: 0. Prior deploy-button PRs: none.
- **License: `LICENSE.md` is "Attribution-NonCommercial 4.0 International" (CC BY-NC 4.0).** The GitHub API reports `NOASSERTION`.

## Why HOLD
- The content is licensed for non-commercial use only. A README button that drives users to one-click deploy it on a commercial hosting platform invites licensing ambiguity, both for users and for the campaign.
- The repo is also the author's own portfolio example (README in Spanish, 27 lines, no deploy section), not a general-purpose template.
- Following the brief ("check policy FIRST"), I did not spend build time here.

## Anybuild plan only (no replay)
- Provider: node-static (Astro). Package manager: pnpm 10 (`pnpm-lock.yaml`). Install runs `pnpm install`; build runs `pnpm run build`. Static dir: `dist`. This comes from `anybuild plan` on the clone.

## Remaining check for the reviewer
- Only reconsider if the campaign owner decides CC BY-NC repos are in scope. Then run `replay.sh` on the clone with a Spanish-language README patch.
