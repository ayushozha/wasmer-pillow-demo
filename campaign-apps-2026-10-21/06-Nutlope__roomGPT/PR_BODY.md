## Summary

This PR adds a "Deploy to Wasmer" button under the existing `## One-Click Deploy` section, right after the Vercel button. It also adds a short note covering:
- what the button does (it builds this public repo as-is and does not fork it);
- how to fork the repo and connect the fork to redeploy on push;
- which environment variables the code reads.

Only the README changes.

## Why this repo

roomGPT is a widely forked example of a full Next.js AI app that is small enough to self-host. The Wasmer note lists the three things a self-hoster has to get right:
- `REPLICATE_API_KEY` is required.
- `NEXT_PUBLIC_UPLOAD_API_KEY` is inlined at build time, so it must be set before building. Without it, the code falls back to Bytescale's `free` demo key.
- Upstash rate limiting is optional and is skipped when unset.

## Testing

Tested at SHA `611398c78da64f1794df2d99018c3d02d3ab0048` on Node v22.22.0 with npm 10.9.4:

- `npm ci`: exit 0.
- `npm run build` (Next.js 13.4.4): exit 0.
- `PORT=3106 npm start`:
  - `/` returned 200.
  - `/dream` returned 200.
  - `POST /generate` with a malformed body returned 500. No Replicate or Bytescale calls were made.

## Limitations

- I have not submitted a Wasmer deployment.
- From the test environment I could not verify Wasmer's detection, its runtime (including Node version compatibility of the 2023 dependency set), or how the badge renders.
