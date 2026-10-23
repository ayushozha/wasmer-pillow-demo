#!/bin/bash
# usage: S=<scratchpad> http.sh <static_app dir> <port> <sws.toml or -> <pages...>
# Serves with static-web-server 2.38.0 (no redirect following in curl), curls each page, every same-origin
# src/href asset referenced by each page's HTML (resolved against the page URL), and every file in the build.
set -u; S=${S:?}; APP=$1; PORT=$2; CFG=$3; shift 3; B=http://127.0.0.1:$PORT
A=(--root="$APP" --log-level=error --port="$PORT" --host=127.0.0.1); [ "$CFG" != - ] && A+=(--config-file="$CFG")
"$S/sws/bin/static-web-server" "${A[@]}" >/dev/null 2>&1 & SP=$!; for i in $(seq 1 30); do curl -s -o /dev/null $B/ && break; sleep 0.3; done
c(){ printf '%-90s ' "$1"; curl -s -o /dev/null -w '%{http_code} %{content_type} %{size_download} %{redirect_url}\n' "$B$1"; }
echo "# $(date -u +%FT%TZ) $("$S/sws/bin/static-web-server" --version 2>&1 | head -1 | tr -s ' ') on 127.0.0.1:$PORT config=$( [ "$CFG" != - ] && basename "$CFG" || echo none)"
echo "## pages / probes"; for p in "$@"; do c "$p"; done
echo "## assets referenced by each page (src/href, same-origin)"
T=$(mktemp)
for p in "$@"; do curl -s -L "$B$p" -o "$T.h" -w '%{http_code}' | grep -q 200 || continue
  python3 -I -c '
import re,sys,urllib.parse
base,page=sys.argv[1],sys.argv[2]; h=open(sys.argv[3],encoding="utf-8",errors="replace").read()
for m in sorted(set(re.findall(r"(?:src|href)=\"([^\"#]+)\"",h))):
  if re.match(r"^(https?:|//|data:|mailto:)",m): continue
  print(urllib.parse.urlparse(urllib.parse.urljoin(base+page,m)).path)' "$B" "$p" "$T.h"; done | sort -u > "$T.a"
while read -r a; do c "$a"; done < "$T.a"; echo "## referenced assets: $(wc -l < "$T.a")"
echo "## every file in the build output"; n=0; ok=0
(cd "$APP" && find . -type f | sed 's#^\.##' | sort) > "$T"
while read -r f; do r=$(c "$f"); echo "$r"; n=$((n+1)); [[ "$r" =~ \ 200\  ]] && ok=$((ok+1)); done < "$T"
echo "## build files: $n, 200: $ok"; rm -f "$T" "$T.h" "$T.a"; kill $SP; wait $SP 2>/dev/null
