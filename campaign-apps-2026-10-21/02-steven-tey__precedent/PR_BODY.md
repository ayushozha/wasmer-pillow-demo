## Summary

This PR adds a "Deploy to Wasmer" button to the existing One-click Deploy section, below the Vercel button. Next to it is a short note covering:
- what the button does (it builds this public repo as-is and does not fork it);
- how to fork the repo and connect the fork to get redeploys on push;
- which environment variables the current code reads.

It changes the README only.

## Why this repo

Precedent is a starter people clone in order to change it. A one-click build from source is a quick way to see the template running before forking. The one thing that trips people up is Clerk. Without `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY` the home page returns a 500 error. So the note lists the Clerk keys as required, and `GITHUB_OAUTH_TOKEN` as an optional token for the star-count request.

## Testing

Tested at SHA `3be40205d7cdf56082cd284f07f12251b9208f79` on Node v22.22.0 with pnpm 9.3.0 (corepack, from `packageManager`):

- `pnpm install --frozen-lockfile` (exit 0) and `pnpm build` (exit 0), with no env vars set.
- `pnpm start` with no Clerk keys: `/` returned 500 (`Missing publishableKey`).
- `pnpm start` with a placeholder publishable key and secret key, set at runtime only: `/` returned 200 and showed "Building blocks for your Next project". `/github` returned 307 to the repo.

## Limitations

- I have not submitted a Wasmer deployment.
- Wasmer's detection and runtime were not verified from the test environment, and neither was badge rendering.
- Sign-in was not exercised, because no real Clerk application was used.
