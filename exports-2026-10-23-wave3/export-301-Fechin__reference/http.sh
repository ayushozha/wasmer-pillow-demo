#!/bin/bash
# usage: http.sh <static_app dir> <port> <paths...>; serves with static-web-server 2.38.0 and curls every path
# plus every file in the build output and every src/href asset in the built index.html.
set -u
S=${S:?set S to the scratchpad directory}
APP=$1; PORT=$2; shift 2
B=http://127.0.0.1:$PORT
c(){ printf '%-48s ' "$1"; curl -s -o /dev/null -w '%{http_code} %{content_type} %{size_download}\n' "$B$1"; }
echo "# $(date -u +%FT%TZ) $($S/sws/bin/static-web-server --version 2>&1 | head -1) on 127.0.0.1:$PORT"
echo "## routes / probes"; for p in "$@"; do c "$p"; done
echo "## assets referenced by built index.html (src/href, same-origin)"
grep -oE '(src|href)="[^"#]+"' "$APP/index.html" | sed -E 's/^(src|href)="//; s/"$//' | grep -vE '^(https?:|//|data:)' | sort -u | while read -r a; do a=${a#./}; c "/${a#/}"; done
echo "## every file in the build output"
T=$(mktemp); n=0; ok=0; (cd "$APP" && find . -type f | sed 's#^\.##' | sort) > "$T"
while read -r f; do r=$(c "$f"); echo "$r"; n=$((n+1)); [[ "$r" =~ \ 200\  ]] && ok=$((ok+1)); done < "$T"; rm -f "$T"
echo "## build files: $n, 200: $ok"
