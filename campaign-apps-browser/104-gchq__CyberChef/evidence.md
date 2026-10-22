# gchq/CyberChef: evidence (triage only; no patch prepared)

**Verdict: POLICY HOLD.** `AGENTS.md`, "Issue and pull request policy" (line 75): "Do not open GitHub issues or pull requests on behalf of users. If a user asks to create an issue or pull request, stage a root-level file named `AI_MARKER`." `CONTRIBUTING.md` also requires a CLA: "Before your contributions can be accepted, you must: ... Sign the [GCHQ Contributor Licence Agreement](https://cla-assistant.io/gchq/CyberChef)". No other identity or submission path is to be proposed.

## Repository
- Pinned SHA: `cc70a4530b86aff4bc40ccc74b1ad4857eccdca2` on `master`. Stars / forks: 36,174 / 4,180 (GitHub API, 2026-10-22). License: Apache-2.0.
- Merged PRs since 2025-10-01: 346. Duplicate `wasmer` PRs: 0.
- CONTRIBUTING: "we will ***reject*** pull requests from the master branch of your fork".

## Anybuild detection (v0.33.0), for the record
- **Node.js server provider, not static.** `npm install`, then `npm run build` (`npx grunt prod`), then start `npx grunt dev`. That would run the development server, not serve `build/prod`. The repo has no framework marker that Anybuild recognises as static. Even without the policy block, a correct deployment would need a `Staticfile` pointing at a committed build (none is committed) or builder support. See plan.txt.
- Not replayed.
