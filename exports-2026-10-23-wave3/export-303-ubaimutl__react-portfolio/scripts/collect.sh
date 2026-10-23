#!/bin/bash
# usage: collect.sh <clone> <replay-name> <out-dir>  -- copies raw receipts with local paths rewritten to $S-relative, writes upstream.patch + checks
S=${S:?set S to the scratchpad dir}
C=$1; R=$S/replay/$2; O=$3
san(){ sed -e "s#$S#\$S#g" -e 's#/tmp/Anybuild[A-Za-z0-9]*#<tmp>#g' -e 's#/home/user/[^ ]*#<local>#g' -e 's#/root/[^ ]*#<local>#g'; }
for f in plan.txt plan.json replay.log smoke.txt; do san < "$R/$f" > "$O/$f"; done
for f in http-receipts.txt external-refs.txt duplicate-check.txt; do [ -f "$O/$f" ] && { san < "$O/$f" > "$O/.t" && mv "$O/.t" "$O/$f"; }; done
git -C "$C" add -N . ; git -C "$C" diff > "$O/upstream.patch"
{ echo "# patch checks $(date -u +%FT%TZ)"
  echo "\$ git -C <clone> diff --check"; git -C "$C" diff --check; echo "exit=$?"
  T=$(mktemp -d "$S/val2-src/chk.XXXX"); git -C "$C" worktree add -q --detach "$T" HEAD 2>/dev/null
  echo "\$ git apply --check upstream.patch   # on clean HEAD $(git -C "$T" rev-parse HEAD)"; git -C "$T" apply --check "$O/upstream.patch"; echo "exit=$?"
  git -C "$C" worktree remove --force "$T"
  echo "\$ sha256sum upstream.patch"; (cd "$O" && sha256sum upstream.patch)
  echo "\$ grep -c trailing-whitespace lines in added lines"; grep -cE '^\+.*[ 	]$' "$O/upstream.patch"
} > "$O/patch-check.txt" 2>&1
cat "$O/patch-check.txt"
grep -rlE "/home/user|/root/|$S|ghp_|gho_|github_pat" "$O" && echo "PATH/TOKEN LEAK ABOVE" || echo "no local paths/tokens"
