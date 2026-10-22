## Summary

This PR adds a short `## Deploy on Wasmer` section to the README, after "Cloning & running". The section has:
- a Deploy to Wasmer button;
- one sentence on what the button does (it builds this public repo as-is, without forking it; to redeploy on push, fork the repo and connect the fork);
- a table of the environment variables the current code reads.

Only the README changes.

## Why this repo

TurboSeek is a popular example of a self-hosted AI search engine. People deploy it to try it with their own Together and Exa keys. The env setup is the part people get wrong. The README still mentions Bing/SERP, but the current code uses Exa. Also, `pnpm run build` itself fails when `TOGETHER_API_KEY` or `EXA_API_KEY` is missing, because the clients are created at module scope. The new section lists exactly what the code reads today, and it says both keys must be set before the first build.

## Testing

Tested at SHA `9e16b401d5595cbe0fadaad12ef7d32b3635deec` on Node v22.22.0 with pnpm 10.28.0:

- `pnpm install --frozen-lockfile`: exit 0.
- `pnpm build` with no env: exit 1 (missing `TOGETHER_API_KEY`). With only the Together placeholder: exit 1 (missing `EXA_API_KEY`). With both set to placeholder strings: exit 0.
- `pnpm start` with no keys at runtime: `/` returned 200. `POST /api/getSources` and `POST /api/getAnswer` returned 500. No outbound or paid calls were made.

## Limitations

- I did not submit a Wasmer deployment.
- Wasmer's detection and runtime, and whether its build step sees app env vars, could not be verified from the test environment. Badge rendering was not verified either.
