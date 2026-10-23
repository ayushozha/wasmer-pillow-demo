#!/bin/bash
# usage: dupcheck.sh <clone>  -- all-state PR duplicate check without the GitHub API
cd "$1"
git fetch -q origin '+refs/pull/*/head:refs/remotes/pr/*' 2>&1
echo "# date: $(date -u +%FT%TZ)  HEAD=$(git rev-parse HEAD)"
echo "# PR refs fetched: $(git for-each-ref refs/remotes/pr | wc -l)"
echo "# PR numbers: $(git for-each-ref --format='%(refname:lstrip=3)' refs/remotes/pr | sort -n | tr '\n' ' ')"
echo "## git log --remotes=pr -i --grep=wasmer"
git log --remotes=pr -i --grep=wasmer --format='%H %an <%ae> %s'
echo "## git log --remotes=pr -i --author=wasmer --author=ayush"
git log --remotes=pr -i --author=wasmer --author=ayush --format='%H %an <%ae> %s'
echo "## README.md / Staticfile / Anybuild mentioning wasmer per PR ref"
n=0
for r in $(git for-each-ref --format='%(refname)' refs/remotes/pr); do
  n=$((n+1))
  for f in README.md Staticfile; do
    git show "$r:$f" 2>/dev/null | grep -qi wasmer && echo "HIT $r:$f"
  done
  git cat-file -e "$r:Staticfile" 2>/dev/null && echo "HAS-Staticfile $r"
done
echo "# refs scanned: $n"
echo "# end"
