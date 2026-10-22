# jakearchibald/svgomg: evidence (triage; no patch prepared)

**Verdict: HOLD (not detected as static).** There is no framework marker, so Anybuild v0.33.0 picks the **Node.js server provider**: `npm install`, then `npm run build` (`gulp clean-build`), then start `sirv build --port 8080 --dev --no-clear`. That runs sirv's development mode as the production server. The built `build/` folder is not committed, so a `Staticfile` alone cannot point at it. Serving the gulp output statically needs builder support. The repo also had little recent activity: last commit 2025-09-29.

## Facts
- Pinned SHA: `f925656d40a507c512bf95ee14ad16445a4ad3ed` on `main`. Stars / forks: 6,206 / 524 (GitHub API, 2026-10-22). License: MIT.
- Not replayed (Node-server provider; the harness only replays static providers).
