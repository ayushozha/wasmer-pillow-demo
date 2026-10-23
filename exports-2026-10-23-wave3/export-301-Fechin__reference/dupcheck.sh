#!/bin/bash
# usage: dupcheck.sh <filter=blob:none clone with refs/remotes/pr/* fetched> <owner/repo>
set -u; C=$1; cd "$C"
echo "# all-state duplicate check for $2, $(date -u +%FT%TZ)"
echo "# HEAD $(git rev-parse HEAD)"
echo "\$ git fetch origin '+refs/pull/*/head:refs/remotes/pr/*'"
echo "PR refs (open+closed+merged): $(git for-each-ref refs/remotes/pr | wc -l)"
echo "highest PR number: $(git for-each-ref --format='%(refname:lstrip=3)' refs/remotes/pr | sort -n | tail -1)"
echo; echo "\$ git log --remotes=pr -i --grep=wasmer --format='%H %an <%ae> %s'"
git log --remotes=pr -i --grep=wasmer --format='%H %an <%ae> %s'; echo "(end; lines=$(git log --remotes=pr -i --grep=wasmer --format=%H | wc -l))"
echo; echo "\$ git log --remotes=pr -i --author=wasmer --author=ayush --format='%H %an <%ae> %s'"
git log --remotes=pr -i --author=wasmer --author=ayush --format='%H %an <%ae> %s'; echo "(end; lines=$(git log --remotes=pr -i --author=wasmer --author=ayush --format=%H | wc -l))"
echo; echo "# per-ref: git show <ref>:README.md | grep -il wasmer  (README blobs only)"
n=0; hits=0; nore=0
for ref in $(git for-each-ref --format='%(refname)' refs/remotes/pr); do
  n=$((n+1))
  if git cat-file -e "$ref:README.md" 2>/dev/null; then
    if git show "$ref:README.md" 2>/dev/null | grep -il wasmer >/dev/null; then echo "HIT $ref"; hits=$((hits+1)); fi
  else nore=$((nore+1)); fi
done
echo "refs scanned=$n readme_hits=$hits refs_without_README.md=$nore"
