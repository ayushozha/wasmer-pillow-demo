# 16 - cruip/open-react-template

| Item | Value |
| --- | --- |
| Pinned SHA | `9da36763df216be7840f3c063edcdcaf7862401e` (branch `master`, default) |
| Last commit | 2025-12-12 09:53:36 +0100 - "Upgrade React and Next.js dependencies to latest versions" |
| Stars / forks | 4,712 / 2,088 (GitHub API, 2026-10-22) |
| Stack | Next.js 15.1.11 App Router, React 19.2.3, Tailwind 4; pnpm (`packageManager: pnpm@10.15.1`, `pnpm-lock.yaml`) |
| License | No LICENSE file in the repo. README "Terms and License" (quoted below). |
| Env vars | None (`app/api/hello` returns a static string). |

## License / redistribution terms (README.md, "## Terms and License", verbatim)

> - Released under the [GPL](https://www.gnu.org/licenses/gpl-3.0.html).
> - Copyright 2024 [Cruip](https://cruip.com/).
> - Use it for personal and commercial projects, but please don't republish, redistribute, or resell the template.
> - Attribution is not required, although it is really appreciated.

Also README "Support notes": "any request dealing with React (e.g. extra features, customisations, et cetera) is to be considered out of the support scope."

## Why HOLD
A one-click "Deploy" button's purpose is to publish an unmodified copy of the template on a public URL. The author explicitly asks that the template not be republished or redistributed. Whether a deployment counts as "republishing" is debatable (the GPL link points the other way, and the license text has no LICENSE file to settle it), but proposing a button whose main effect is mass re-hosting of the template as-is runs against the maintainers' stated wish. The README's only deploy mention is the stock create-next-app "Deploy on Vercel" paragraph (a text link, not a button aimed at this repo), so there is no precedent of the maintainers inviting hosting buttons either. No patch is staged (no `upstream.patch`, `PR_TITLE.txt`, `PR_BODY.md`); the clone is left unmodified.

What would change this: a maintainer answering an issue that a deploy button is welcome. If that happens, the section would sit under "### Deploy on Vercel", say `pnpm run build`, "No environment variables are required", and point to `app/(default)/page.tsx` / `components/` for customization.

## Technical result (for the record; build.log)
- Task note confirmed: current master is Next.js (not the old Vite version), pnpm.
- `corepack pnpm install --frozen-lockfile` (pnpm 10.15.1 from `packageManager`) 0; `pnpm run build` 0; `pnpm start` on 3331: `/` 200 `<title>Home - Open PRO</title>`, `/signin` 200, `/api/hello` 200 "Hello, Next.js!". Node 22.22.0.
- Anybuild v0.33.0 (`wasmerio/shipit@587be23132ea`, tag = HEAD of the provided clone) `plan`: node provider, Next.js, pnpm 10.15.1 (from `packageManager`, `providers/node.rs:1126-1157`), Node 24 (`node.rs:561`, `608`); install `pnpm install`, build `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'` (`node.rs:458-471`, `1646-1668`), start `node .next-bundle/server.mjs` (`node.rs:473-475`, `1764-1769`). Production may run a different builder version.
- Builder-equivalent run (clean copy, no `.git`, Node 24.22.1, builder's pnpm env vars from `resources/starlib/tools/node.bzl:118-132`): install 0, next-bundle build 0, `node .next-bundle/server.mjs` on 3332: `/` 200 + title, `/signin` 200, `/api/hello` 200, unknown path 404.

So it would deploy fine technically; the hold is about the redistribution terms only.

## Contribution / AI policy
No CONTRIBUTING, AGENTS, `.github/` or PR template. No AI policy found.

## Duplicate check
GitHub search `wasmer` across all 18 batch targets returned 0 PRs (2026-10-22). No prior third-party deploy-button PR outcomes were provided.

## Verdict: HOLD
Reason: README terms say "please don't republish, redistribute, or resell the template"; a deploy-as-is button invites exactly that. Remaining check for Codex: none, unless someone opens an issue asking Cruip whether a Wasmer deploy button is acceptable and gets a yes.
