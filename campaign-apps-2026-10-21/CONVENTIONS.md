# Batch B (apps/starters) — conventions

Staging only. Nothing here is an upstream PR yet; Codex inspects each folder and opens PRs with local `gh`.

## Per-target folder `NN-owner__repo/`

| File | Content |
| --- | --- |
| `evidence.md` | pinned upstream SHA + branch, stars/forks (GitHub API, 2026-10-22), license, contribution/AI policy, duplicate-PR check, prior third-party deploy-button PRs, verdict |
| `build.log` | real commands + output from this container (install, build, production start, curl smoke) with exit codes |
| `upstream.patch` | `git diff` against the pinned SHA; apply with `git apply upstream.patch` at repo root |
| `PR_TITLE.txt`, `PR_BODY.md` | Summary / Why this repo / Testing / Limitations |

Verdicts: **READY** (patch + local build/start proof), **CONDITIONAL** (patch ready, one named item must be confirmed by Codex in a browser or with a real key before opening), **HOLD** (no PR; evidence says why).

## Button

```markdown
[![Deploy to Wasmer](https://img.shields.io/badge/Deploy%20to-Wasmer-6B4EFF)](https://wasmer.io/apps/create?github=OWNER%2FREPO)
```

- Route `https://wasmer.io/apps/create?github=OWNER%2FREPO` was browser-verified by Codex (AstroPaper). Not `/deploy`, not `/deploy/button.svg` (404).
- `img.shields.io` and `wasmer.io` are unreachable from this cloud container, so badge rendering and Wasmer framework detection are **not** verified here. Codex: open each create URL and confirm detection/build command before opening the PR.

## What the button does (wording used in every README section)

The button builds the public upstream repository as-is. It does not fork or copy it into the user's GitHub account, so there is no continuous Git connection. To customize and redeploy on push: fork, then connect the fork from the Wasmer dashboard (Wasmer for GitHub needs access to the repo). Secrets go in app Settings → Environment Vars.

Source for Wasmer behaviour: `wasmerio/docs.wasmer.io@6f160c96` (`content/edge/learn/supported-frameworks-and-languages.mdx`, `content/edge/git/wasmer-for-github.mdx`, `content/edge/learn/secrets.mdx`) and `wasmerio/examples@dd8532fc` (`js-next-ssr`, `php-laravel`, `python-langchain-starter`): zero-config detection for Next.js, PHP/Composer, Python requirements.txt incl. Streamlit; `app.yaml` optional. No `app.yaml`/`wasmer.toml` is added unless a target needs one.

## Rules

- README-only patches unless a target cannot be detected without config. No dependency, lockfile or framework changes.
- No paid API calls, no deployments, no real secrets. Smoke tests use no keys or a local mock server.
- No AI trailers in upstream commits.
