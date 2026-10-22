# 305 antimatter15/splat — SKIP (no build step; root pure-HTML lane)

- Pinned: main @ ba182b51b7c2ad5738cdd6741cd63336d27470fb, last commit 2025-11-16.
- GitHub API, 2026-10-22: 3077 stars, 335 forks, MIT, not archived.
- Duplicate check: `wasmer` PR search returned 0 (2026-10-22).
- Build step: none. The tracked files are LICENSE, README.md, convert.py, index.html and main.js only (triage-receipt.txt). Anybuild v0.33.0 plan: static site provider, no install/build (plan.txt).
- Remote data by default: main.js:746-751 builds the scene URL as `new URL(params.get("url") || "train.splat", "https://huggingface.co/cakewalk/splat-data/resolve/main/")`. The viewer therefore fetches its default sample from Hugging Face (repo `cakewalk/splat-data`) on every load, and the repo ships no local sample.
- Sample licence: NOT VERIFIED. huggingface.co is blocked from this container (CONNECT 403, saved in triage-receipt.txt). The sample's licence and provenance are separate from the repo's MIT licence and remain open.
- Verdict: SKIP for lane E (pure no-build root HTML belongs to the other session). If that session takes it, it must record the Hugging Face sample licence and disclose that the viewer loads remote data by default.
