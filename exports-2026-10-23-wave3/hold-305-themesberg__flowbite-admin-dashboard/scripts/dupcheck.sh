#!/bin/bash
# usage: dupcheck.sh <clone> <out-file>
C=$1; OUT=$2
{
echo "# all-state duplicate check (no API), $(date -u +%FT%TZ)"
echo "# repo HEAD: $(git -C "$C" rev-parse HEAD)"
echo '$ git fetch origin "+refs/pull/*/head:refs/remotes/pr/*"'
git -C "$C" fetch -q origin '+refs/pull/*/head:refs/remotes/pr/*' 2>&1; echo "exit=$?"
N=$(git -C "$C" for-each-ref refs/remotes/pr --format='%(refname)' | wc -l)
echo "# PR refs fetched: $N"
echo '$ git log --remotes=pr -i --grep=wasmer --format="%H %an <%ae> %s"'
git -C "$C" log --remotes=pr -i --grep=wasmer --format='%H %an <%ae> %s'; echo "exit=$? (no lines above = no match)"
echo '$ git log --remotes=pr -i --author=wasmer --author=ayush --format="%H %an <%ae> %s"'
git -C "$C" log --remotes=pr -i --author=wasmer --author=ayush --format='%H %an <%ae> %s'; echo "exit=$? (no lines above = no match)"
echo '# per-ref: git show <ref>:README.md | grep -il wasmer'
hits=0; checked=0
for r in $(git -C "$C" for-each-ref refs/remotes/pr --format='%(refname:short)' | sort -t/ -k2 -n); do
  if git -C "$C" cat-file -e "$r:README.md" 2>/dev/null; then checked=$((checked+1))
    if git -C "$C" show "$r:README.md" 2>/dev/null | grep -qi wasmer; then echo "HIT $r"; hits=$((hits+1)); fi
  else echo "no README.md at $r"; fi
done
echo "# README.md checked at $checked of $N refs; wasmer hits: $hits"
} > "$OUT" 2>&1
tail -3 "$OUT"
