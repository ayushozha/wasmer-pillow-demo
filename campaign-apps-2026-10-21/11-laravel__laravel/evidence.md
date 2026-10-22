# laravel/laravel — HOLD (no upstream PR)

- Upstream: https://github.com/laravel/laravel, default branch `13.x`, pinned `9ffef3bc4241e3cc333ef267258a404d0d95f194` (2026-10-14). `composer.json` requires `php ^8.3`, `laravel/framework ^13.17`.
- Popularity (GitHub API, 2026-10-22): 85,232 stars, 27,626 forks.
- Duplicates: GitHub PR search `wasmer` across batch-B targets → 0 (2026-10-22).

## Why HOLD

1. **Maintainer policy / precedent.** Contributions follow https://laravel.com/docs/contributions (README "Contributing"). Vendor deployment PRs to the skeleton are closed unmerged: #6179 "adding for deployment into Vercel" (closed 33 min after opening, 2023-05-19), #6131 and #5981 (Azure App Service workflows), #6724 (EC2 script), #6801 (VPS hardening, 2026-04). The skeleton README is copied into every `composer create-project laravel/laravel` app, which makes a third-party host button a change to every new Laravel app. Laravel promotes its own Laravel Cloud. Acceptance probability is very low.
2. **Default config is not stateless.** `.env.example` ships `DB_CONNECTION=sqlite`, `SESSION_DRIVER=database`, `CACHE_STORE=database`, `QUEUE_CONNECTION=database`. Measured here (`build.log`): with defaults and no database file, `GET /` → **500** ("Database file at path … database.sqlite does not exist"); `/up` → 200. With `SESSION_DRIVER=cookie CACHE_STORE=array` the welcome page → 200.
3. **Wasmer behaviour for this case is not provable here.** Anybuild v0.33.0 `resources/starlib/tools/laravel.bzl` runs `php artisan config:cache/route:cache/view:cache` at build and `php artisan migrate` as `after_deploy`; with SQLite this would create a database file inside the app filesystem whose durability across redeploys/instances is not documented. docs.wasmer.io says MySQL/PostgreSQL may be auto-attached (`DB_HOST`…), but the skeleton defaults to `sqlite`, so it would not use them without `DB_CONNECTION=mysql`. Without a real deploy we cannot claim the welcome page, sessions or migrations work, and we must not imply durable SQLite.

## If revisited
Only as Wasmer-side documentation (e.g. wasmerio/examples `php-laravel` already exists) or with a verified test deploy using `DB_CONNECTION=mysql` + `SESSION_DRIVER=database` after migrations. Not as a downstream PR to laravel/laravel. Laravel starter kits (React/Vue/Livewire) route contributions to laravel/maestro — also out of scope.

Replacement candidates (user-supplied, source-checked by Codex): mldangelo/personal-site, m4tt72/terminal, codebucks27/Next.js-Developer-Portfolio-Starter-Code, TailAdmin/free-react-tailwind-admin-dashboard.
