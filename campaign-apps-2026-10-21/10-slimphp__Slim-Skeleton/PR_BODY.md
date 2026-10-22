## Summary

Adds a "Deploy to Wasmer" button and a short paragraph to the README, right after the local/Docker run instructions. README-only; no code, config or dependency changes.

## Why this repo

Slim-Skeleton is the official starting point for Slim 4 apps (`composer create-project slim/slim-skeleton`). People evaluating Slim usually want to see the skeleton answer real HTTP requests before they commit to it. The skeleton needs no database, no secrets and no build step beyond Composer, so it is a good fit for a one-click build from source: Wasmer installs the Composer dependencies and serves `public/index.php`, and the visitor gets `/` and the sample `/users` JSON endpoints running on a public URL.

The section also lists two steps that apply to any production host: make `logs/` writable or point `logger.path` in `app/settings.php` at another destination such as `php://stdout` (the `/users` routes write to `logs/app.log`), and set `displayErrorDetails` to `false`.

## Testing

Pinned at `0ef01549870b3234a3a9f602904a39c3ed73f44c` (main), PHP 8.3.6, Composer 2.8.12:

- `composer install --no-dev --optimize-autoloader --no-interaction` (no lock file is committed, so dependencies resolve to current Slim 4 / PHP-DI 6 / Monolog 2) — exit 0
- `php -S 127.0.0.1:3401 -t public` (same as `composer start`):
  - `GET /` → 200 `Hello world!`
  - `GET /users` → 200 JSON list, `GET /users/1` → 200, `GET /users/99` → 404 JSON error, unknown route → 405 JSON error
  - `logs/app.log` is created by the `/users` requests

No Wasmer deployment was made as part of this PR.

## Limitations

- Not deployed to Wasmer from this change. Detection, Composer install and the `public/` document root follow Wasmer's builder source (Anybuild v0.33.0, `providers/php.rs` and `tools/php.bzl`) and docs, but were not checked against a live deploy. Whether `logs/` is writable on Wasmer was not verified, which is why the README gives the `php://stdout` alternative.
- The button deploys `slimphp/Slim-Skeleton` itself. Because `composer create-project` copies this README into new apps, the button in a generated project still points at the skeleton; the paragraph tells users to connect their own repository instead.
- PR targets `main` (CONTRIBUTING.md mentions a `4.x` branch, which does not exist any more).
