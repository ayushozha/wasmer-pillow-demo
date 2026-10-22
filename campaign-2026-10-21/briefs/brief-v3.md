# Brief v3: docs-site starters, hash-routed apps and static tools lane

Read /tmp/claude-0/brief.md and /tmp/claude-0/brief2.md first. Where they differ, v2 overrides v1 and THIS FILE overrides both.

Publishing is paused. Prepare validated artifacts only. Never push, fork, open PRs or issues, or comment upstream. Never commit in /home/user/wasmer-pillow-demo.

## Scope (your lane)

Runnable default sites only: a repo whose default branch builds a real site.
- Documentation-site STARTER/APPLICATION repos: VitePress, Docusaurus, Astro Starlight, VuePress.
- MkDocs repos, but only where Anybuild's mkdocs provider really builds them (see below).
- Hash-routed browser apps.
- Maintained pure static tools.

Do NOT add a hosting badge to:
- framework libraries, plugins or theme-only packages without a runnable default site;
- monorepos whose root is not the site;
- docs folders of a larger product.

## Selection

- Prefer >500 stars and activity in 2025-2026. A strongest-in-niche active starter can qualify below 500 only with explicit popularity evidence (stars, dependents, usage) and a stated real benefit.
- Maintainer diversity: at most ONE repo per owner per wave, and none from an owner already in ledger.json or ledger.d/ unless that owner has no PUBLISHED or READY entry. Also skip every repo already in the ledger.
- Never touch these 31 already-created repos, or anything else in the ledger:
  - Astro and Eleventy themes/starters: AstroPaper, Fuwari, devportfolio, Cactus, eleventy-base-blog, Astroship, Dante, AstroMicro, AccessibleAstro, AcademicTemplate, AstroNano, Astroplate, Firefly, Typography, eleventy-excellent, Retypeset, Mizuki.
  - Other templates: Simplefolio, vcard, Landing-Page, MagicUI, play-tailwind, Gentelella, AdminKit, Metis, shadcn-landing-page, masterPortfolio, Bulma, SBAdmin2, Mazer, Sufee.
- Charca/astro-blog-template is also pending. Leave it alone.
- Hold or decline on any of these:
  - policy refusal, a closed provider-button PR, PRs disabled, or no outside merges in years;
  - an unsupported native dependency;
  - auth or secrets leaking into the client;
  - insecure public defaults;
  - payment or paid-API calls;
  - critical runtime advisories (in code that ships to the browser or runs at runtime);
  - a hardcoded AI model or key. Any AI model selection must be env-driven, and you must not add AI features.

## Required record (ledger.d/OWNER_REPO.json)

- `repo`: canonical owner/repo. Follow redirects via MCP and record any rename.
- `stars` and `stars_at`: UTC fetch time.
- `default_branch`, `base_sha`, and the head commit date.
- `license`: SPDX id plus any redistribution or attribution constraints.
- `policy`:
  - CONTRIBUTING, AGENTS.md and any AI policy;
  - PR template;
  - deploy-provider stance (existing provider buttons, closed provider PRs);
  - outside-merge activity.
- `wasmer_pr_search`: the MCP query and its result.
- `why`: the repo-specific benefit.
- `detect_log` and `detection_verified`:
  - `anybuild plan` on the BASE and PATCHED commits from clean worktrees;
  - record provider, framework, static_dir, and the pm and version;
  - delete the `Anybuild` file that `plan` writes into its target dir.
- `anybuild_replay`: tools/anybuild_flat_replay.py output, including the pinned pm version and the env it applied.
- `sws_smoke`: tools/sws_smoke.py on the replay output dir, covering routes, hashed assets, the search index if present, and a missing path.
- `build_claude`: the repo's normal upstream build, with a frozen lockfile.
- `audit`: `npm audit --omit=dev` (or the full audit) counts, plus whether each critical or high advisory applies at runtime or build only. For Python, `uvx pip-audit` if feasible.
- `hook_check`: what actually ran. Never bypass a hook.
- `caveats`: source and runtime caveats, including base path, `site` URL to change, analytics or third-party IDs in the defaults, search keys (Algolia etc.), and forms.

## Compatibility facts (Anybuild 0.33.0, verified from source and examples)

- **VitePress:** node-static with framework vitepress. static_dir comes from the build script root, e.g. `docs/.vitepress/dist`. Check that it matches the real output. If `base` is set to a sub-path, assets break at the root, so HOLD unless it's env/config-driven with a root default.
- **Docusaurus:** node-static, `build/`. Check `baseUrl` (it must be `/`) and `url`. Algolia keys in `docusaurus.config` are public search-only keys; note them, but don't count them as a leak.
- **Starlight/Astro:** as before, `dist`. VuePress: `.vuepress/dist` under the docs root.
- **MkDocs:** the provider runs `uv init && uv add 'mkdocs'`. If `requirements.txt` exists it runs `uv add -r requirements.txt`; if `pyproject.toml` exists it runs `uv sync`, with `--locked` when `uv.lock` exists. Then it runs `uv run mkdocs build`. A repo that uses mkdocs-material or plugins without declaring them in requirements.txt or pyproject FAILS on Wasmer: HOLD, don't add config. The replay tool supports provider mkdocs. Run it with uv (at /root/.local/bin/uv).
- **No SPA fallback.** Hash routing is fine. History routing needs every route prerendered, or a 404.html redirect trick verified in a browser.
- **Node 24 default; .nvmrc and engines are ignored.** pnpm defaults to 10 unless packageManager is declared.

## Commands

- `export PATH=/tmp/claude-0/tools/node/bin:/root/.bun/bin:/root/.local/bin:$PATH`
- `A=/tmp/claude-0/camp/wasmerio_shipit/target/release/anybuild`
- `python3 -I /home/user/wasmer-pillow-demo/campaign-2026-10-21/tools/anybuild_flat_replay.py $A <clone> <routes...>`
- `python3 -I /home/user/wasmer-pillow-demo/campaign-2026-10-21/tools/sws_smoke.py /tmp/claude-0/tools/sws/bin/static-web-server OWNER_REPO /tmp/claude-0/flat-replay/OWNER_REPO/opt/temp/<static_dir> <routes...>`
  - For MkDocs the output dir is `.../opt/temp/__site`.
  - Probe at least: `/`, 3-6 real routes, one hashed asset, `/404.html` if it exists, the search index, and a missing path (automatic).
- Relative links: `python3 -I /tmp/claude-0/relscan.py <dir>`.

## Patch

- Minimal README change: a visible badge plus accurate import guidance (fork first; the import does not copy the repo; name any settings to change, such as `site`/`url`, `baseUrl`, analytics IDs and search keys). Match the README's style and language.
- Add a Staticfile or other config only when it's strictly necessary and proven by plan output before and after.
- The PR body (pr-bodies/OWNER_REPO.md) mirrors the repo's PR template if it has one. It must cover:
  - Summary, mentioning the badge;
  - Why this repository;
  - Testing: normal build, plan, replay with versions, and SWS routes;
  - Limitations.
- No deployment claims.

## Disk hygiene

Free space is about 11 GB. After finishing each repo, delete its `node_modules`, `.venv` and `/tmp/claude-0/flat-replay/<key>/opt`. Keep the clone and the git branch. Clone with `--depth 1` unless you need history. Skip repos over 300 MB.

## Final reply

A table per repo (status, stars, license, provider/static_dir, normal build, replay, SWS, audit applicability, one-line reason), plus rejected candidates with reasons.

## Addendum 2026-10-22 (overrides earlier text where they differ)

- Count only real upstream creations toward 200. Never pad with duplicates, repeat declined proposals, or evade a restriction.
- PR bodies: after the `Title:` line, run `python3 -I /home/user/wasmer-pillow-demo/campaign-2026-10-21/tools/add_affiliation.py pr-bodies/OWNER_REPO.md`. It inserts the fixed affiliation paragraph ("I work at Wasmer. Wasmer Edge is a cloud hosting platform powered by WebAssembly; it can host this repository's [generated] static site." plus links to https://docs.wasmer.io/edge/ and https://docs.wasmer.io/edge/git/). Then explain the repo-specific benefit. No price or performance claims and no sales pitch.
- Author every staging commit and patch as `Claude <noreply@anthropic.com>`. Never use the user's or anyone else's identity.
- Hold any repo that ships an OAuth clientSecret or other secret in client code (e.g. Gitalk configs).
- Confirmed policy exclusions (never prepare these):
  - gabrielecirulli/2048
  - Adrinlol/landy-react-template
  - github-education-resources/codespaces-project-template-js
  - CommunityPro/portfolio-html
  - binyamin/eleventy-garden
  - tbaltrushaitis/cv
  - Bitburner (Commons Clause)
- Treat "issue/discussion required before PR" policies as HOLD. Don't open issues just to place a PR.
