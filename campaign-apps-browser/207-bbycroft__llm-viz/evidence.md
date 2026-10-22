# bbycroft/llm-viz: evidence

**Verdict: HOLD (builder: Yarn Berry project; Anybuild floats Yarn and does not stage `.yarnrc.yml`).**

- Pinned SHA `9da93742382f1bf36c020c38a1ace454e82c4490` on `main` (last commit 2026-08-11). Stars/forks 5,570 / 670 (GitHub API, 2026-10-22). License MIT. No CONTRIBUTING/AGENTS/PR template found.
- Anybuild v0.33.0 plan (plan.txt): static Node.js, framework Next (`output: 'export'` in `next.config.js`), yarn, output `out`; staged inputs `yarn.lock` + `package.json`; **no yarn version in the plan** — `crates/anybuild/src/providers/node.rs` `resolve_manager_version`: "Yarn keeps floating", so `packageManager: "yarn@4.1.0"` is ignored.
- Repo needs Yarn 4: `.yarnrc.yml` = `nodeLinker: node-modules`, `yarnPath: .yarn/releases/yarn-4.1.0.cjs`. Neither `.yarnrc.yml` nor `.yarn/` is staged before install.
- Replay (unpatched), replay.log: with the floating `yarn` resolved to 1.22.22 (npm `yarn@latest`), `yarn install` exits 1: "This project's package.json defines "packageManager": "yarn@4.1.0". However the current global version of Yarn is 1.22.22." Build then fails, `out` missing, `/` 404. What Wasmer's `dep("yarn", None)` resolves to was not verifiable here; even with a Yarn 4 binary, the unstaged `.yarnrc.yml` would leave Yarn on its PnP default instead of `node-modules`, which Next's build expects.
- Classification: package-manager/config input gap — Anybuild limitation.
- Also to check later: Next export without `trailingSlash` writes `llm.html` etc.; static-web-server does not map `/llm` to `llm.html`, so the main `/llm` route would likely 404 on reload.
