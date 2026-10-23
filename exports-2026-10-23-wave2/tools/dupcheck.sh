#!/bin/bash
# usage: dupcheck.sh <clone> <out>
C=$1; OUT=$2
cd "$C"
{
echo "# duplicate check $(date -u +%FT%TZ) repo=$(git remote get-url origin) HEAD=$(git rev-parse HEAD)"
echo "# PR refs fetched: $(git for-each-ref refs/remotes/pr | wc -l)"
echo "\$ git log --remotes=pr -i --grep=wasmer --format='%H %an <%ae> %s'"
git log --remotes=pr -i --grep=wasmer --format='%H %an <%ae> %s'; echo "exit=$? lines_above=$(git log --remotes=pr -i --grep=wasmer --format=%H | wc -l)"
echo "\$ git log --remotes=pr -i --author=wasmer --author=ayush --format='%H %an <%ae> %s'"
git log --remotes=pr -i --author=wasmer --author=ayush --format='%H %an <%ae> %s'; echo "exit=$? lines_above=$(git log --remotes=pr -i --author=wasmer --author=ayush --format=%H | wc -l)"
# README blobs of every PR head
git for-each-ref --format='%(refname:short)' refs/remotes/pr > /tmp/.refs.$$
while read r; do o=$(git rev-parse -q --verify "$r:README.md" 2>/dev/null) && echo "$r $o"; done < /tmp/.refs.$$ > /tmp/.rb.$$
U=$(awk '{print $2}' /tmp/.rb.$$ | sort -u)
echo "# PR refs with README.md: $(wc -l < /tmp/.rb.$$); unique README blobs: $(echo "$U" | grep -c .)"
echo "$U" | xargs -n 200 git -c fetch.negotiationAlgorithm=noop fetch -q --no-tags --no-write-fetch-head origin 2>&1 | tail -3
echo "\$ for each PR ref: git show <ref>:README.md | grep -il wasmer"
n=0; hits=0
while read r o; do n=$((n+1)); if git show "$r:README.md" 2>/dev/null | grep -qi wasmer; then echo "HIT $r"; hits=$((hits+1)); fi; done < /tmp/.rb.$$
echo "# README scanned: $n refs; hits: $hits"
rm -f /tmp/.refs.$$ /tmp/.rb.$$
} > "$OUT" 2>&1
