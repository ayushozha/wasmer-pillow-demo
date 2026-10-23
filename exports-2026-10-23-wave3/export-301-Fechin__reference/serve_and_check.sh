#!/bin/bash
# usage: serve_and_check.sh <static_app> <port> <sws.toml> -- runs static-web-server 2.38.0 with the plan's generated
# config, then http.sh (routes + assets from built index.html + every build file) and an internal-link check over every
# built HTML page (same-origin href/src, unique, query/fragment stripped; status after following redirects).
set -u; S=${S:?}; APP=$1; PORT=$2; CFG=$3; D=$(cd "$(dirname "$0")" && pwd)
"$S/sws/bin/static-web-server" --root="$APP" --log-level=info --port="$PORT" --host=127.0.0.1 --config-file="$CFG" > /dev/null 2>&1 & SP=$!
sleep 1.5
echo "# static-web-server --root=<static_app> --log-level=info --port=$PORT --host=127.0.0.1 --config-file=<plan static_redirects_config>"
S=$S "$D/http.sh" "$APP" "$PORT" / /index.html /go /golang /css /css3 /about/ /search.json /sitemap.xml /nope /assets/nope.js
echo "## internal links from every built HTML page (followed redirects; final status)"
T=$(mktemp)
find "$APP" -name '*.html' -print0 | xargs -0 grep -ohE '(href|src)="/[^"/][^"]*"' | sed -E 's/^(href|src)="//; s/"$//; s/[?#].*$//' | sort -u > "$T"
n=0; bad=0
while read -r u; do n=$((n+1)); r=$(curl -s -L -o /dev/null -w '%{http_code} %{content_type}' "http://127.0.0.1:$PORT$u"); case "$r" in 200*) ;; *) bad=$((bad+1)); echo "NON200 $u $r";; esac; done < "$T"
echo "## unique internal link targets: $n, non-200: $bad"; rm -f "$T"
kill $SP; wait $SP 2>/dev/null
