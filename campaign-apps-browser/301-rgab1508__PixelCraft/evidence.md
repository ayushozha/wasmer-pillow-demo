# 301 rgab1508/PixelCraft — SKIP (no build step; root pure-HTML lane)

- Pinned: master @ 45a5d4821caeebaea4ee507bdabf8e2645631418, last commit 2025-03-17 (shallow clone).
- GitHub API, 2026-10-22: 1528 stars, 83 forks, MIT, not archived, pushed 2025-03-16.
- Duplicate check: `wasmer` PR search over this repo returned 0 (2026-10-22).
- Build step: none at the root. The root is index.html + Canvas.js + gif.worker.js + sw.js (see triage-receipt.txt `ls-files`). The only package.json is `new/pixelcraft/package.json`, an unfinished CRA (react-scripts 4.0.3) rewrite in a subfolder; it is not the app served at the root and is not built from the root.
- Anybuild v0.33.0 plan: "Detected static site provider", start `static-web-server --root=/opt/static_app ...`, no install/build (plan.txt, plan.json).
- Verdict: SKIP for lane E. A pure no-build root HTML app belongs to the other session's pure-HTML lane, as BRIEF3 says. No replay, patch or PR text was prepared. Also note that the last source change was about 19 months ago.
