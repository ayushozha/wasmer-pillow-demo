# slimphp/Slim-Skeleton

- Upstream: https://github.com/slimphp/Slim-Skeleton, default branch `main`, pinned `0ef01549870b3234a3a9f602904a39c3ed73f44c` (last commit 2024-03-03)
- Popularity (GitHub API, 2026-10-22): 1,621 stars, 471 forks, not archived. Official Slim 4 skeleton (`slim/slim-skeleton` on Packagist).
- License: MIT (`LICENSE.md`).
- Contribution policy: `CONTRIBUTING.md` — fork, feature branch, PR to `4.x`, PSR-12. `git ls-remote` shows no `4.x` branch (only `main`, `2.x`, dependabot branches) → target `main`. No AI policy file.
- Duplicates: GitHub PR search `wasmer` across all batch-B targets → 0 results (2026-10-22). No prior third-party deploy-button PRs found.
- Wasmer support: docs.wasmer.io@6f160c96 supported-frameworks — PHP detected by any `.php`, Composer installed, `public/index.php` entry point supported.

## Wasmer builder (Anybuild v0.33.0 = wasmerio/shipit tag v0.33.0 @587be231, the version production pins)
- Detection: `crates/anybuild/src/providers/php.rs:323-327` returns `ComposerEntrypoint` when `composer.json` and `public/index.php` exist (both do).
- Composer enabled: `php.rs:232` (`use_composer` when `composer.json`/`composer.lock` exists).
- Docroot: `crates/anybuild/src/providers/php.rs:260-266` sets `public_dir = "public"` when `public/index.php` exists.
- Install: `resources/starlib/tools/php.bzl:71` runs `composer install --optimize-autoloader --ignore-platform-reqs --no-scripts --no-interaction` (dev deps included, scripts skipped). Slim needs no Composer scripts.
- 4.x: `git ls-remote --heads https://github.com/slimphp/Slim-Skeleton.git` (2026-10-22) lists only `main`, `2.x` and dependabot branches; there is no `4.x`, so the PR base is `main`.

## Build/runtime (this container)
`composer install --no-dev` exit 0; `php -S … -t public` smoke: `/` 200, `/users` 200, `/users/1` 200, `/users/99` 404, unknown 405. See `build.log`.

Wasmer's exact install command (with dev deps) could not finish here: the require-dev package squizlabs/php_codesniffer downloads from api.github.com, which this container blocks (403); see end of build.log.

Not testable here: non-writable `logs/` (container is root), Wasmer itself (wasmer.io blocked).

## README text (revised after root review)
States detection/install/docroot (backed by the citations above, to be confirmed on the live import page) and adds two production steps that apply on any host: make `logs/` writable or point `logger.path` elsewhere (e.g. `php://stdout`), and set `displayErrorDetails` to `false`. It makes no claim that filesystem writes work on Wasmer.

Base branch: `main` (root confirmed merged PRs #347/#348 target `main`; no `4.x` remote).

## Verdict: CONDITIONAL
Patch ready. Before opening: open https://wasmer.io/apps/create?github=slimphp%2FSlim-Skeleton and confirm PHP detection with `public/` as web root. If a test deploy is allowed, check `/users` (it writes `logs/app.log`); if it 500s on Wasmer, add that caveat to the README text or hold.
