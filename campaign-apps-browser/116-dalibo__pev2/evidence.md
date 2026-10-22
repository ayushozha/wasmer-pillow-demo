# dalibo/pev2: evidence (triage; no patch prepared)

**Verdict: HOLD (output-dir mismatch).** Anybuild v0.33.0 detects static Node.js/Vite and serves `dist` (plan.txt). This repo's app build writes elsewhere: `vite.config.ts` sets `outDir: "dist-app"` for the non-library build. `npm run build` (`vue-tsc --noEmit && vite build`) would therefore produce `dist-app/`, `dist` would be missing, and the deployment would serve nothing. I did not replay it, because the config is unambiguous; this is the same Anybuild limitation seen with mermaid-live-editor (111) and erd-editor (115): it does not read the framework's configured output directory. Fixing it needs a builder or config change, not a README PR.

## Facts
- Pinned SHA: `e41d4e8b3006c479f9364d68a5d538d81cb7d110` on `master` (2026-10-20). Stars / forks: 3,606 / 200 (GitHub API, 2026-10-22). License: PostgreSQL License.
- The app build is a single-file bundle (`vite-plugin-singlefile`, `inlineDynamicImports: true`) and is otherwise ideal for static hosting.
