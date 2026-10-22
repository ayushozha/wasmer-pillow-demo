# leaningtech/webvm: evidence

**Verdict: HOLD (licence/fit).** The build path looks fine (Anybuild plan: static Node.js provider, framework SvelteKit, `npm install` / `npm run build`, output `build`), but a one-click deploy button conflicts with the CheerpX licence terms and the app's core depends on vendor infrastructure:

- README "License" section (pinned SHA): "The public CheerpX deployment is provided **as-is** and is **free to use** for technological exploration, testing and use by individuals. Any other use by organizations, including non-profit, academia and the public sector, requires a license. Downloading a CheerpX build for the purpose of hosting it elsewhere is not permitted without a commercial license." A button that invites anyone (including organizations) to host their own WebVM steers users towards uses that need a commercial licence.
- `package.json` depends on `"@leaningtech/cheerpx": "latest"` (unpinned, proprietary engine) and `config_public_terminal.js` streams the disk image from `wss://disks.webvm.io/...` (Leaning Technologies' server), so the core does not work fully from the static build.
- WebVM's code is Apache-2.0, but the button's value depends on CheerpX.

No build was replayed (policy hold first, per brief).

## Repository
- Pinned SHA: `7cd36b8d5b32a7532b1af11585d0de26ad92a251` on `main`, 2026-10-07.
- Stars / forks: 17,441 / 3,344; Apache-2.0 (code) (GitHub API, 2026-10-22).
- README already documents "Deploy to GitHub Pages" via a fork + workflow.
