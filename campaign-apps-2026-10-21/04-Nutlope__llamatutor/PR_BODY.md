## Summary

This PR adds a short `## Deploy on Wasmer` section to the README, after "Cloning & running". It contains:
- a Deploy to Wasmer button;
- one sentence on what the button does: it builds this public repo as-is, without forking it, and to redeploy on push you fork the repo and connect the fork;
- a table of the environment variables the current code reads.

Only the README changes.

## Why this repo

Llama Tutor is a small, self-contained app that people fork to run their own tutor with their own keys. The current code needs Together and Exa keys. Helicone sits in the chat request path. Upstash is optional: it is used only for rate limiting, and it is skipped when `UPSTASH_REDIS_REST_URL` is unset. None of this is spelled out in the README today, so the new table says it explicitly.

## Testing

All tests ran at SHA `5b88de25bccd33524342f5ee34ca49ca38aca7f3` on Node v22.22.0 with pnpm 10.28.0.

- `pnpm install --frozen-lockfile`: exit 0.
- `pnpm build` with no env vars: exit 0.
- `pnpm start`:
  - `/` returned 200.
  - `POST /api/getSources` without `EXA_API_KEY` returned 500.
  - `POST /api/getChat` with a malformed body returned 500. This shows the route loads without Upstash variables.
- No outbound or paid calls were made.

## Limitations

- I did not submit a Wasmer deployment.
- From the test environment I could not verify Wasmer's detection, its runtime, or how the badge renders.
