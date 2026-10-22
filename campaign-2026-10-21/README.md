# Deploy to Wasmer campaign: static-site staging (2026-10-21)

Staging area for README-only "Deploy to Wasmer" patches to popular static-site repositories.
Nothing in this directory has been sent upstream. `ledger.json` is the source of truth for each target's status, evidence and blockers.

## Layout

| Path | Contents |
| --- | --- |
| `ledger.json` | Per-target record: stars plus source and timestamp, pinned base SHA, build/smoke/format results, policy notes, status |
| `patches/<owner>_<repo>.patch` | `git format-patch` output against the ledger's `base_sha`. Apply with `git am` |
| `pr-bodies/<owner>_<repo>.md` | PR title and body, following the repo's PR template when it has one |
| `logs/` | Raw build logs (`*.build.log`), smoke results (`*.smoke.json`), formatter checks (`*.format.log`) |
| `tools/smoke_static.py` | Stdlib-only smoke test: serves a build dir, checks routes return 200 and root-relative refs resolve |

## Batch 1 status

| Target | Status | Build | Smoke |
| --- | --- | --- | --- |
| satnaing/astro-paper | READY | Codex PASS (cloud: env-blocked fonts.google.com) | Codex browser PASS |
| saicaca/fuwari | READY | PASS (Node 22 and 24, pnpm 9.14.4) | PASS |
| RyanFitzgerald/devportfolio | READY | PASS | PASS |
| chrismwilliams/astro-theme-cactus | READY | PASS | PASS |
| 11ty/eleventy-base-blog | READY (verify `_site` detection) | PASS | PASS |
| arthelokyo/astrowind | HELD_POLICY (main frozen, discussion #736) | env-blocked | n/a |
| mearashadowfax/ScrewFast | HELD_POLICY (maintainer closed provider PR #611) | env-blocked | n/a |

READY still requires Codex to open each `import_url` and confirm the import page detects the repo. So far only astro-paper is confirmed.

## Destination and badge

- Link: `https://wasmer.io/apps/create?github=OWNER%2FREPO`. Codex verified this in a live browser for astro-paper: detection only, nothing was deployed. The page imports the public repo and does **not** copy it into the visitor's account, so each README tells readers to import their own copy if they want to customize it.
- Badge: `https://img.shields.io/badge/Deploy%20to-Wasmer-171717?logo=wasmer&logoColor=white`. The `wasmer` icon slug exists in simple-icons 16.35.0. This sandbox cannot fetch img.shields.io, so check that it renders.
- Not used: `wasmer.io/deploy/button.svg` (404) and `wasmer.io/deploy?repository-url=` (shows a user profile).

## Environment limits of this cloud session

- Egress policy denies wasmer.io, docs.wasmer.io, registry.wasmer.io, img.shields.io, fonts.google.com, api.fontsource.org, cdn.pixabay.com and images.unsplash.com. Builds that fetch fonts or remote images at build time fail here for that reason only. These are labeled `FAIL_ENV`, not project bugs.
- Wasmer docs were read from source: `wasmerio/docs.wasmer.io@6f160c96`. The docs have no deploy-button page; the documented paths are `wasmer deploy` and connecting GitHub to an existing app.
- Toolchain: Node 24.22.1 (checksum-verified from nodejs.org) unless noted, npm 11, pnpm resolved per repo.

## Applying a patch

```bash
git clone https://github.com/OWNER/REPO && cd REPO
git checkout -b deploy-to-wasmer <base_sha from ledger>
git am /path/to/campaign-2026-10-21/patches/OWNER_REPO.patch
```
