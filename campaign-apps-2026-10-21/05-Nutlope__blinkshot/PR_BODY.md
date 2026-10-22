## Summary

This PR adds a short `## Deploy on Wasmer` section to the README, placed after "Cloning & running". The section has three parts:
- A Deploy to Wasmer button.
- One sentence on what the button does. It builds this public repo as-is and does not fork it. To get redeploys on push, fork the repo and connect your fork.
- A table of the environment variables the current code reads.

Only the README changes.

## Why this repo

BlinkShot is a compact real-time image generator. People self-host it with their own Together key. Today the README only mentions `TOGETHER_API_KEY`. The code also reads several optional settings, each of which only turns on when set:
- Helicone, Braintrust and Upstash.
- `NEXT_PUBLIC_SITE_URL` for the origin check.

The server-side `TOGETHER_API_KEY` is still needed even when visitors paste their own key, because the Together client is constructed before the user key is applied. The table makes all of this explicit for anyone deploying from source.

## Testing

Tested at SHA `e730e2a9dfd9aeb4e18856ba96f8b02a740343b9` on Node 24 with pnpm 10. No real keys were used and no outbound or paid calls were made: servers ran in a loopback-only network namespace, and upstream calls went to a local mock.

- I replayed Wasmer's builder steps (`pnpm install`, then `pnpm dlx next-bundle@1.0.0 --build-command 'pnpm run build'`) and both exited 0.
- I then ran `node .next-bundle/server.mjs`. `/` and `/robots.txt` returned 200.
- On the unmodified bundle, `/api/generateImages` returned 500 because next-bundle@1.0.0 left out pnpm's scoped symlinks (`@swc/helpers`). I restored those symlinks in a copy of the bundle and checked the documented API behaviour there:
  - A request without Origin/Sec-Fetch-Site returned 403.
  - A same-origin request with a user key but no server key returned 400 ("TOGETHER_API_KEY environment variable is missing").
  - With `HELICONE_API_KEY` set, requests switch to Helicone's gateway. Without it, they go straight to Together.
- I did not test image generation against the real providers.

## Limitations

- No Wasmer deployment has been submitted.
- Wasmer's detection and runtime were not verified from the test environment, and neither was badge rendering.
