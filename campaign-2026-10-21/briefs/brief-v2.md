# Brief v2 (read /tmp/claude-0/brief.md first; THIS FILE OVERRIDES IT where they differ)

Hard rules:
1. NEVER bypass git hooks. That rules out --no-verify, HUSKY=0, core.hooksPath changes, no-op or disabled hooks, and any equivalent.
   - If a hook needs a tool (pnpm, etc.), install the right version and let the hook run.
   - If the repo's own formatter hook reformats nearby lines, that is acceptable; record it.
   - If the hook fails for a repo reason, mark the repo HOOK_BLOCKED with the output.
   - Record what actually ran in `hook_check`. Never claim a hook passed if it did not run.
2. Every patch MUST contain the visible badge, inside the deploy line or section (not in a curated status-badge row):
   `[![Deploy to Wasmer](https://img.shields.io/badge/Deploy%20to-Wasmer-171717?logo=wasmer&logoColor=white)](https://wasmer.io/apps/create?github=OWNER%2FREPO)`
3. A missing deploy section is NOT a blocker; add a tiny "Deploy" section.
   Hold only on concrete evidence:
   - policy or maintainer refusal, PRs disabled;
   - build failure, Anybuild mismatch, misleading behavior;
   - server/DB/secrets needs, archived repo, or inactivity with closed external PRs.
4. Honest frontend-only notes:
   - Contact, newsletter, login, cart and checkout UIs in static templates must be described in Limitations as UI only, with no backend, payments or auth.
   - Never imply a working checkout or a working form.
5. Wasmer compatibility gate (MANDATORY, run on the PATCHED commit):
   - Detector: `/tmp/claude-0/camp/wasmerio_shipit/target/release/anybuild plan <clean worktree> --out x.json`.
     - The provider must be `node-static` (correct framework and static_dir) or `staticfile` (correct root).
     - Provider `node` with a dev-server start (astro dev, webpack serve, vite, etc.) is a FAIL.
   - Wrong output dir fix: a one-line root `Staticfile` with `root: <dir>`.
     - It works only where node_static still wins and builds (Strong framework evidence). Otherwise the plain staticfile provider runs NO build.
     - For prebuilt/plain-HTML repos, a Staticfile `root: <dir or .>` is correct only if the files are committed.
     - Prove it with plan output before and after. Explain it in the README line and the PR body.
   - Build-flow replay: `PATH=/tmp/claude-0/tools/node/bin:/root/.bun/bin:$PATH python3 -I /home/user/wasmer-pillow-demo/campaign-2026-10-21/tools/anybuild_flat_replay.py /tmp/claude-0/camp/wasmerio_shipit/target/release/anybuild <clone dir> <routes...>`
     - It writes logs/<key>.flat-replay.log and .flat-replay-smoke.json, pinning Anybuild's package-manager versions and env.
     - The repo must PASS, or FAIL_ENV only on a sandbox-denied host (name the host).
     - Anybuild defaults to Node 24 and ignores .nvmrc and engines. A repo that needs Node <=20 is HELD_BUILD.
   - Anybuild 0.33's static server has no SPA index.html fallback, and `_redirects` only supports 301/302. Browser-history SPAs with deep routes are HELD unless they use hash routing or every route is prerendered.
   - Also run the repo's normal upstream build (frozen lockfile) and smoke it. Keep both results separate in the ledger: `build_claude` for the normal build, `anybuild_replay` for the replay.
6. Relative links: smoke_static.py checks only root-relative refs. For `./` links, use `python3 -I /tmp/claude-0/relscan.py <dir>` (from an earlier worker) or your own scanner, and report the counts.
7. Dedupe: skip any repo that appears in /home/user/wasmer-pillow-demo/campaign-2026-10-21/ledger.json or ledger.d/ (grep the owner/repo, case-insensitive). Another session works on Node/PHP/Streamlit apps plus 20 static replacements; root dedupes across sessions, so flag possible overlaps rather than guess.
8. Popularity: prefer >=1000 stars (500 minimum). Pushed or merged activity in 2025-2026 preferred. Note older repos honestly.
   - Pure static templates only: Astro, Eleventy, Vite/Parcel, plain HTML, etc.
   - No libraries, monorepo frameworks, or vendor-only deploy flows.
9. Outputs go in campaign-2026-10-21/{patches,pr-bodies,ledger.d,logs}/OWNER_REPO.*
   - The PR body needs: Summary (mention the badge), Why this repository (repo-specific), Testing (normal build + Anybuild plan + replay with versions and routes), and Limitations.
   - The ledger fragment needs the keys from brief.md plus hook_check, anybuild_replay, detect_log.
10. Don't commit in /home/user/wasmer-pillow-demo. Don't push or open anything upstream.
11. Final reply: a per-repo table (status, stars, normal build, replay, detector provider/static_dir, reason) and rejected candidates with reasons.
