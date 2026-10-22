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

Tested at SHA `e730e2a9dfd9aeb4e18856ba96f8b02a740343b9` on Node v22.22.0 with pnpm 10.28.0:

- `pnpm install --frozen-lockfile`: exit 0.
- `pnpm build` with no env vars: exit 0.
- `pnpm start`:
  - `/` returned 200.
  - `/robots.txt` returned 200.
  - `POST /api/generateImages` without Origin/Sec-Fetch-Site returned 403.
  - The same request as same-origin, with a placeholder user key and no server key, returned 400 ("TOGETHER_API_KEY environment variable is missing"). No outbound or paid calls were made.

## Limitations

- No Wasmer deployment has been submitted.
- Wasmer's detection and runtime were not verified from the test environment, and neither was badge rendering.
