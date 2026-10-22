## Summary

This PR adds a short `## Deploy on Wasmer` section to the README, after "Cloning & running". It contains:
- a Deploy to Wasmer button;
- one sentence on what the button does: it builds this public repo as-is, without forking it, and to redeploy on push you fork the repo and connect the fork;
- a table of the environment variables the current code reads.

Only the README changes.

## Why this repo

Llama Tutor is a small, self-contained app that people fork to run their own tutor with their own keys. The README does not list which keys the current code needs:
- Together and Exa keys.
- A Helicone key. Chat requests always go to Helicone's Together gateway, because `together.helicone.ai` is hardcoded in `utils/TogetherAIStream.ts`. Without the key, the `Helicone-Auth` header is sent as `Bearer undefined`.
- Upstash is optional. It is only used for rate limiting and is skipped when `UPSTASH_REDIS_REST_URL` is unset.

## Testing

All tests ran at SHA `5b88de25bccd33524342f5ee34ca49ca38aca7f3`. No real keys were used and no outbound or paid calls were made. Servers ran in a loopback-only network namespace, and any upstream traffic went to a local mock.

- Wasmer's builder steps were replayed locally on Node 24 with pnpm 10: `pnpm install`, then `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'`. Both exited 0.
- I then ran `node .next-bundle/server.mjs`:
  - `/` returned 200.
  - `POST /api/getSources` without `EXA_API_KEY` returned 500.
- With `next start`, I pointed the app at a local mock and checked the chat request. Without `HELICONE_API_KEY`, the app sent `Helicone-Auth: Bearer undefined` to `together.helicone.ai`.
- Chat and answer generation were not tested against the real providers.

## Limitations

- I did not submit a Wasmer deployment.
- From the test environment I could not verify Wasmer's detection, its runtime, or how the badge renders.
