# viliusle/miniPaint: evidence

**Verdict: CONDITIONAL (policy).** The technical path is proven (Staticfile, root served, all runtime assets 200). Before opening, the reviewer must read the owner's comments on the closed Docker/deploy-infrastructure PRs #365 and #434. I could not read comment bodies from this environment: the GitHub issue and comment APIs and github.com return 403 for repositories outside this session, and only search works. If the owner declined deployment additions as out of scope, this becomes a policy HOLD.

## Repository
- Pinned SHA: `a79733eb803fc97084ef0ee4faa96b031e69e1c0` on `master`. The commit is "version 4.14.3", 2026-04-19.
- Stars / forks: 3,480 / 803. Not archived. Last push 2026-04-20 (GitHub API, 2026-10-22).
- License: `MIT-LICENSE.txt` is MIT ("Permission is hereby granted, free of charge, to any person obtaining a copy..."), Copyright (c) ViliusL. GitHub reports NOASSERTION only because of the file name.
- Policy files: there is no CONTRIBUTING, no PR template, no AI policy and no `.github/` folder, so there are no bots or workflows. `SECURITY.md` is the GitHub boilerplate.
- Activity is low. Only one PR has been merged since 2025-10-01 (#431 "version 4.14.3", the owner's release). There are 105 merged PRs in total.
- Duplicate `wasmer` PR check: 0.
- Prior deploy-related PRs, all closed without merging:
  - #200 "Basic Dockerfile" (2020).
  - #365 "Optimized Dockerfile" (2023, 6 comments; the owner commented).
  - #434 "Feature/native docker ci pipeline" (closed 2026-05-25).
  - #413 "Update webpack.config.js to enable working via reverse proxy" was also closed unmerged after an owner comment.
  - This is the policy risk behind the verdict.
- The README has an "Embed" (iframe) section and "Build instructions" (which links to the wiki). It has no deploy section.

## Build freshness
- `dist/bundle.js` is committed and rebuilt at each release. From blobless history, the last change to `dist/bundle.js` is a79733e (2026-04-19, "version 4.14.3"), and the last change to `src/` is 472dfa1 (2026-04-19, "updated google fonts API key"). The committed bundle therefore matches HEAD's sources at the time of release.

## Anybuild detection (v0.33.0)
- Unpatched: Node.js provider, "Package" evidence (score 10, `providers/mod.rs:427-434`). The plan has install `npm install`, build `npm run build` (webpack), start `None`, and no static dir. webpack is not one of `node_static.rs` STATIC_DEPENDENCIES (lines 110-149), so there is no static detection. A Node app with no start command does not serve the root `index.html`.
- Patched: a `Staticfile` with `root: .` gives StaticFile evidence (score 50, `mod.rs:445-447`; `staticfile.rs:190`). The plan is "Detected static site provider", output directory `.`, no install or build, start `static-web-server --root=/opt/static_app --log-level=info --port=8080` (sws 2.38.0).
- Why the root and not `dist/`: `index.html` sits at the root and loads `dist/bundle.js`, `images/*`, `src/js/libs/gifjs/gif.worker.js` and the `tools/*` ids by relative path. So the site root must be the repository root with the prebuilt `dist/` inside it, which is exactly what `root: .` serves.

## Replay (patched clone)
- No install or build step (staticfile provider). The tree was copied as-is and served with sws 2.38.0 (`--host=127.0.0.1` is the only deviation). There are 293 files.
- Smoke (see `replay.log`):
  - `/` returned 200 (title "miniPaint - image editor").
  - `/dist/bundle.js` returned 200 (1,358,169 bytes).
  - These returned 200: `/images/test-collection.json`, `/images/logo-colors.png`, `/images/logo.svg`, `/images/icons/{brush.svg,grid.png,undo.svg,gradient.png}`, `/src/js/libs/gifjs/gif.worker.js` and `/images/favicon.png`.
  - `/dist/manifest.json` returned 404. It is referenced only inside an HTML comment (`<!-- <link rel="manifest" ...> -->`), so this is a smoke-tool false positive and is the same upstream.
- Asset completeness: I extracted every `images/icons/*.svg|png` literal from `dist/bundle.js`; all 30 exist in the served root. Dynamic icon names (`'images/icons/'+p`) resolve inside the same folder, all 31 files of which are served.
- Routes: single page; the logo link is `#`. No history-router paths.

## Runtime config, keys, external calls
- There are no env vars. `src/js/config.js:18` contains the upstream's own Google Webfonts API key (obfuscated by string-splitting). It is already public and already in the bundle, and the patch does not touch it.
- Optional online features call external services (Google Fonts, plus links to remove.bg, tinypng and squoosh). Core editing is local.

## Security (runtime deps, lockfile versions, npm advisory bulk API)
- 0 advisories: jquery 3.7.1, pica 7.1.1, alertifyjs 1.14.0, file-saver 2.0.5, exif-js 2.3.0, gif.js.optimized 1.0.1, webfontloader 1.6.28, fuzzysort 1.9.0, blueimp-canvas-to-blob 3.29.0, @babel/runtime 7.29.2, hermite-resize 2.2.10 and semver-compare 1.0.0.
- uuid 8.3.2 has 1 moderate advisory (GHSA-w5hq-g745-h8pq, buffer bounds check when `buf` is passed). This is not critical and does not block.

## Remaining checks for the reviewer
1. Read the owner's comments on #365 and #434 (and #413). If they reject deploy or provider additions, mark this a policy HOLD.
2. Verify the badge and import page in a browser; `img.shields.io` and `wasmer.io` are blocked here.
3. Optionally, open the deployed editor and try one edit and export.
