# slimphp/Slim-Skeleton

- Upstream: https://github.com/slimphp/Slim-Skeleton, default branch `main`, pinned `0ef01549870b3234a3a9f602904a39c3ed73f44c` (last commit 2024-03-03)
- Popularity (GitHub API, 2026-10-22): 1,621 stars, 471 forks, not archived. Official Slim 4 skeleton (`slim/slim-skeleton` on Packagist).
- License: MIT (`LICENSE.md`).
- Contribution policy: `CONTRIBUTING.md` — fork, feature branch, PR to `4.x`, PSR-12. `git ls-remote` shows no `4.x` branch (only `main`, `2.x`, dependabot branches) → target `main`. No AI policy file.
- Duplicates: GitHub PR search `wasmer` across all batch-B targets → 0 results (2026-10-22). No prior third-party deploy-button PRs found.
- Wasmer support: docs.wasmer.io@6f160c96 supported-frameworks — PHP detected by any `.php`, Composer installed, `public/index.php` entry point supported.

## Build/runtime (this container)
`composer install --no-dev` exit 0; `php -S … -t public` smoke: `/` 200, `/users` 200, `/users/1` 200, `/users/99` 404, unknown 405. See `build.log`.

Not testable here: non-writable `logs/` (container is root), Wasmer itself (wasmer.io blocked).

## Verdict: CONDITIONAL
Patch ready. Before opening: open https://wasmer.io/apps/create?github=slimphp%2FSlim-Skeleton and confirm PHP detection with `public/` as web root. If a test deploy is allowed, check `/users` (it writes `logs/app.log`); if it 500s on Wasmer, add that caveat to the README text or hold.
