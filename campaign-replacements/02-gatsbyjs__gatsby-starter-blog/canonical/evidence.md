# Canonical target for gatsby-starter-blog: gatsbyjs/gatsby `starters/blog/README.md`

- Root correction (2026-10-22): `gatsbyjs/gatsby-starter-blog` is a read-only mirror; bots on PRs #204/#190 route contributions to the monorepo `gatsbyjs/gatsby` `starters/blog`. Never publish against the mirror.
- Canonical: `gatsbyjs/gatsby`, default branch `master`, pinned `516700a1dca1e982b6d098ab57230b25e0318a1f` (sparse clone of `starters/blog`).
- README blob identity: `git hash-object starters/blog/README.md` = `f272fcd68c4905bc19deb4ae9493d2077a80f1a0` = mirror `HEAD:README.md`. Whole tree: `diff -r` of `starters/blog` vs the mirror shows only README.md differing (because the mirror clone carries the patch). So the earlier mirror replay (see ../replay.log) is a replay of the canonical starter's exact files.
- Patch: `canonical/upstream.patch` — path `starters/blog/README.md`, same text as the mirror patch; `git apply --check -R` ok.
- PR template: `.github/PULL_REQUEST_TEMPLATE.md` (Description / Documentation / Tests / Related Issues) — PR_BODY follows it. CONTRIBUTING points to gatsbyjs.com/contributing.
- Activity: 25 PRs merged since 2026-04-01 (e.g. #39695 2026-10-15).
- Duplicates: no `wasmer` PRs. Prior vendor badge: #21748 "chore(starters): Add ZEIT Now Deployment badge" (2020) closed. The starter README's only deploy section is Netlify's (Gatsby is a Netlify product).

## Verdict: CONDITIONAL — high acceptance risk
Technically validated; the risk is policy/commercial (Netlify-owned project with a Netlify-only deploy section; a prior third-party deploy badge PR was closed). Root decides whether to spend a PR here. Remaining check: live import page for `gatsbyjs/gatsby-starter-blog` (the button target stays the mirror, which is the deployable starter repo).
