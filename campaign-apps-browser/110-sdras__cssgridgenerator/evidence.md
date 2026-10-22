# sdras/cssgridgenerator: evidence (triage; no patch prepared)

**Verdict: HOLD (genuine repo/build error under Anybuild's Node 24).** `npm run build` (`vue-cli-service build`, webpack 4) fails with `Error: error:0308010C:digital envelope routines::unsupported` / `code: 'ERR_OSSL_EVP_UNSUPPORTED'` (exit 1). This is the known webpack 4 MD4-hash incompatibility with OpenSSL 3. Anybuild v0.33.0 uses Node 24 and ignores `engines` and `.nvmrc`, and the repo has neither. A fix would need a code or tooling change (a Vue CLI 5 / Vite migration, or `NODE_OPTIONS=--openssl-legacy-provider` in the build script), which is out of scope for a README PR.

## Repository
- Pinned SHA: `be1e0a53497a7381ed5e60ba6c759bed0f271baf` on `main` (last commit 2026-04-06). Stars / forks: 5,359 / 569. License: MIT (Copyright (c) 2019 Sarah Drasner).
- No CONTRIBUTING or PR template; `.github` has only FUNDING. Duplicate `wasmer` PRs: 0.

## Replay (unpatched triage run; Node 24.22.1, npm 11.21.1)
- Static Node.js, Vue, npm. Output `dist`. `npm install` exited 0. `npm run build` exited 1 (OpenSSL error above). `dist` was missing, so the smoke test failed.
