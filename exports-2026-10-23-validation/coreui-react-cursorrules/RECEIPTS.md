# CoreUI React (08): repository agent rules (`.cursorrules`)

## Status
CONDITIONAL. This supersedes the "READY" label in `export-08-…/RECEIPTS.md` on this branch.

## The rules (`cursorrules-excerpt.txt`, HEAD `2609f5995035973e00c16ec723165a5fff87cceb`)
`.cursorrules` in this repo says:
- Run `npm run lint` before committing.
- "What AI Should NOT Do: … Create files outside the src/ directory structure … Modify build configuration without clear reason".

## Conflict
- The prepared patch (sha256 `676a48e6…c761c`) creates `Staticfile` at the repository root. That is a new file outside `src/`, which the rule above forbids for AI-assisted changes.
- The patch needs the file: without it, Anybuild plans `dist` and the build writes `build` (see `export-08-…/receipts/plan-unpatched.txt`).
- The alternative would change `vite.config` `outDir`, which is a build-configuration change the same rules discourage.
- So no variant of this change complies with the file's rules as written.
- This is not worked around here. Publishing needs a human decision: ask the maintainers first, or don't publish.

## Lint (`lint-receipt.txt`)
- Tree: HEAD plus the patch, Node 24.22.1 / npm 11.21.1.
- `npm ci` exits 0. npm 11 notes that the install scripts of @parcel/watcher and core-js were not run.
- `npm run lint` (`eslint`) exits 0.
- ESLint does not lint `README.md` or `Staticfile`, so this shows only that the patch does not break the existing lint. It says nothing about the two changed files themselves.
