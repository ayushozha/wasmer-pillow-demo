# josh-collinsworth/sveltekit-blog-starter: evidence

**Verdict: READY** (README-only patch; replay passes). Popularity is just above the floor (511 stars). It is a strong fit: a fully prerendered static blog starter whose README says the `build` folder can be uploaded "anywhere a static site can be hosted".

## Repository
- Pinned SHA: `6a1873dca5c2912d49ce38ff76242bed9b513b4c` on `main` (default). Last commit 2026-03-27; not archived.
- Stars / forks: 511 / 98 (GitHub API, 2026-10-22).
- License: MIT ("Copyright (c) 2021 Josh Collinsworth").
- No CONTRIBUTING, PR template, AI policy or `.github/`. README "## Contributing": "Feel free to visit the repo and submit a pull request".
- Maintainer activity: owner merged #49 "Update packages and Svelte 5 code" (2026-03-27). Merged since 2025-10-01: 1. #48 was closed 2026-08-02.
- Deploy-button / provider PRs: none in the repo's 18 PRs. Duplicate `wasmer` PR: none. Not in the campaign's existing PR list (`author:ayushozha wasmer`).
- Existing deploy docs: README "## Building, deploying and hosting" mentions Netlify/Vercel auto-deploy and manual upload of `build`. The patch adds a "### Deploy on Wasmer" subsection at the end of that section.

## Anybuild detection (v0.33.0)
- Provider: node-static, **framework SvelteKit**, npm (plan pins npm 11; `package-lock.json` + `package.json` staged), `npm install` / `npm run build` (`vite build`), output `build` (`plan.txt`). `@sveltejs/adapter-static` writes to `build`, matching the plan. No Staticfile needed.
- All routes are prerendered (`kit.prerender.entries` in `svelte.config.js`), so there is no SPA fallback dependency.

## Replay (patched clone, Node 24.22.1, npm 11.21.1)
- `npm install` exit 0; `npm run build` exit 0 ("Using @sveltejs/adapter-static, Wrote site to build").
- Smoke: `/`, `/about`, `/blog`, `/blog/heading-links-example`, `/contact`, `/api/rss.xml`, `/blog/category/svelte` all 200 with correct titles. 26 referenced `_app/immutable` assets 200.
- `/blog/page/2` 404 (observed). The demo has 3 posts with `postsPerPage = 10` (`src/lib/config.js`), so no page 2 is generated.
- Observed: the wildcard prerender entries also emit literal files such as `blog/page/*.html`. On Linux (this replay, and Wasmer's Linux builder) this is harmless. Root found that on Windows the upstream build fails because `*` is an invalid filename character — an environmental limitation of the upstream project on Windows, not of this patch or the Linux build path.
- Dependency audit: the lockfile audit reports **11 findings (8 high, 2 moderate, 1 low)**. The deployed site is static prerendered output (no SvelteKit/Node server runs on Wasmer), and root's specific input-path review found no concrete reachable vulnerable path in what ships. This is not a clean audit; the findings remain in the upstream lockfile.

## Remaining check for the reviewer
- Verify badge and import page in a browser (img.shields.io / wasmer.io blocked here).

## README wording correction (root, 2026-10-22)
- Changed "Wasmer detects the SvelteKit static adapter" → "Wasmer detects this SvelteKit project": Anybuild detects the `@sveltejs/kit` dependency, not the adapter identity.
- README blob: base `98e8c8afa702de478d372ee5029377b94eba531f` → patched `e57c966ae29fb016509b1689c94d1c554ce5ec2f`; `upstream.patch` regenerated, `git apply --check -R` ok.
