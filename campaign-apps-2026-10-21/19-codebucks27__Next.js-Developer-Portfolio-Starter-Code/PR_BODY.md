## Summary

Adds a short "Deploy on Wasmer" section with a Deploy to Wasmer button before "Resources Used in This Project". README-only; no code, dependency or config changes. The tutorial links, screenshots and image/font/icon attributions are unchanged.

The section says that Wasmer runs the project's `build` script (`npm run build`) and serves the production build with Node. It is explicit that the button deploys this starter code as-is (the default Next.js starter page, not the finished portfolio) and does not fork it, and that to publish your own portfolio while following the tutorial you fork and connect the fork from the Wasmer dashboard. No environment variables are required.

## Why this repo

This is the starting point for the Next.js + Framer Motion portfolio tutorial, and people following it end up wanting to put their portfolio online. It has no environment variables, database or API keys, so connecting a fork gives a working deployment that rebuilds on every push as the tutorial progresses.

## Testing

From a copy of `main` at `b6f8ee2d3a75664858d02436f697e4b68118396b`, Node v22.22.0, npm 10.9.4. The repo has no lockfile, so this used `npm install`:

- `npm install` - exit 0 (next 15.5.24, react 18.2.0, framer-motion 10.18.0)
- `npm run build` - exit 0
- `PORT=3251 npm start`: `/` 200 (default starter page), `/api/hello` 200 `{"name":"John Doe"}`, `/next.svg` and `/favicon.ico` 200, `/_next/image?url=/images/projects/devdreaming.jpg&w=640&q=75` 200
- Wasmer's Next.js build, reproduced locally: `npx -y next-bundle@1.0.0 --build-command 'npm run build'` - exit 0, then `node .next-bundle/server.mjs` from a directory holding only `.next-bundle`: same results

## Limitations

- No Wasmer deployment was submitted, and detection and runtime on wasmer.io were not verified from my environment. Wasmer builds on Node 24 by default; I tested on Node 22.
- Without a lockfile, each deploy resolves dependency versions fresh within the ranges in `package.json`.
