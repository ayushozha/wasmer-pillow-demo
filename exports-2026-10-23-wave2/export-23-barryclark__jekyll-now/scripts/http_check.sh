#!/bin/bash
# usage: http_check.sh <static_app> <port> <outdir>  — native SWS 2.38.0, plan start args + --host=127.0.0.1
S=/tmp/claude-0/-home-user-wasmer-pillow-demo/9b68abed-67cb-5023-b672-44f9751def64/scratchpad
APP=$1; PORT=$2; D=$3; B=http://127.0.0.1:$PORT
find "$APP" -type f | sed "s#$APP##" | sort > "$D/static_app-files.txt"
"$S/sws/bin/static-web-server" --root="$APP" --log-level=info --port=$PORT --host=127.0.0.1 > "$D/sws-http.log" 2>&1 & SP=$!; sleep 1
{ echo "# native static-web-server 2.38.0 (plan start args + --host=127.0.0.1); format: code content_type size path"
  for p in / /index.html /about/ /about /Hello-World/ /feed.xml /sitemap.xml /robots.txt /style.css /images/jekyll-logo.png /404.html /definitely-missing-x9 /missing.css /2014/missing/ /feed /sitemap; do echo "$(curl -s -o /dev/null -w '%{http_code} %{content_type} %{size_download}' $B$p) $p"; done
  echo "# every built file:"; while read f; do echo "$(curl -s -o /dev/null -w '%{http_code} %{content_type} %{size_download}' "$B$f") $f"; done < "$D/static_app-files.txt"
  echo "# feed link in served pages"; for p in / /about/ /Hello-World/ /404.html; do echo "$p $(curl -s $B$p | grep -o 'href="[^"]*feed.xml"' | head -1)"; done
} > "$D/http-receipts.txt"
curl -s $B/feed.xml > "$D/feed.xml.served"; curl -s $B/sitemap.xml > "$D/sitemap.xml.served"
kill $SP; wait $SP 2>/dev/null
