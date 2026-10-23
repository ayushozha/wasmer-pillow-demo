#!/bin/bash
# usage: http.sh <replay-name> <port> <out-dir> [page paths...]
# Serves the replay's static_app with SWS 2.38.0 (same args as replay.sh), curls pages + every
# same-origin asset referenced from ALL built HTML files, plus trailing-slash variants; lists external hosts.
S=${S:?set S to the scratchpad dir}
NAME=$1; PORT=$2; OUT=$3; shift 3
R=$S/replay/$NAME; APP=$R/static_app; SWS=$S/sws/bin/static-web-server
ARGS=(--root="$APP" --log-level=info --port="$PORT" --host=127.0.0.1)
[ -f "$R/sws.toml" ] && ARGS+=(--config-file="$R/sws.toml")
"$SWS" "${ARGS[@]}" > "$R/sws-http.log" 2>&1 & SP=$!
for i in $(seq 1 30); do curl -s -o /dev/null "http://127.0.0.1:$PORT/" && break; sleep 0.3; done
B=http://127.0.0.1:$PORT
python3 -I "$S/val2/tools/refs.py" "$APP" > "$OUT/.assets" 2> "$OUT/external-refs.txt"
{
echo "# $("$SWS" --version 2>&1 | head -1); root=<replay>/static_app; static_app files: $(find "$APP" -type f | wc -l)"
echo "# format: <path> -> curl -w '%{http_code} %{content_type} %{size_download}'"
echo "## pages"
for p in "$@"; do printf '%s -> ' "$p"; curl -s -o /dev/null -w '%{http_code} %{content_type} %{size_download}\n' "$B$p"; done
echo "## trailing-slash / .html variants of pages"
for p in "$@"; do case "$p" in */) q=${p%/}; [ -n "$q" ] || continue
  for v in "$q" "${p}index.html"; do printf '%s -> ' "$v"; curl -s -o /dev/null -w '%{http_code} %{content_type} %{size_download} redirect=%{redirect_url}\n' "$B$v"; done;; esac; done
echo "## assets referenced from all $(find "$APP" -name "*.html" | wc -l) built HTML files and url() in $(find "$APP" -name "*.css" | wc -l) built CSS files ($(wc -l < "$OUT/.assets") unique same-origin refs)"
while read -r a; do printf '%s -> ' "$a"; c=$(curl -s -o /dev/null -w '%{http_code} %{content_type} %{size_download}' "$B$a"); case "$c" in 3*) echo "$c | followed(-L): $(curl -sL -o /dev/null -w '%{http_code} %{content_type} %{size_download} hops=%{num_redirects}' "$B$a")";; *) echo "$c";; esac; done < "$OUT/.assets"
} > "$OUT/http-receipts.txt"
kill $SP; wait $SP 2>/dev/null; rm -f "$OUT/.assets"
echo "## summary" >> "$OUT/http-receipts.txt"
grep -E '^/[^ ]* -> ' "$OUT/http-receipts.txt" | awk '{print $3}' | sort | uniq -c | sed 's/^/# status count: /' >> "$OUT/http-receipts.txt"
tail -6 "$OUT/http-receipts.txt"
