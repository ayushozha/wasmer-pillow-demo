#!/bin/bash
# usage: http.sh <replay-name> <port> <out> paths...
S=/tmp/claude-0/-home-user-wasmer-pillow-demo/9b68abed-67cb-5023-b672-44f9751def64/scratchpad
N=$1; PORT=$2; OUT=$3; shift 3
APP=$S/replay/$N/static_app
$S/sws/bin/static-web-server --root="$APP" --log-level=info --port=$PORT --host=127.0.0.1 > $S/replay/$N/sws-http.log 2>&1 & SP=$!
for i in $(seq 1 30); do curl -s -o /dev/null http://127.0.0.1:$PORT/ && break; sleep 0.3; done
B=http://127.0.0.1:$PORT
{
echo "# http receipts $(date -u +%FT%TZ) replay=\$S/replay/$N/static_app server=static-web-server $($S/sws/bin/static-web-server --version | sed -n 's/Version: *//p') (same args as replay.sh)"
echo "# locale env in this shell: '$(env | grep -E '^(LANG|LC_)' | tr '\n' ' ')' (empty = none set)"
echo "# format: path -> http_code content_type size_download"
for p in "$@"; do printf '%s -> %s\n' "$p" "$(curl -s -o /dev/null -w '%{http_code} %{content_type} %{size_download}' "$B$p")"; done
echo "# same-origin assets enumerated from built HTML (href/src, excluding http(s)://, //, mailto:, #)"
A=$(cd $APP && grep -rhoE '(href|src)="[^"#]+"' --include=*.html . | sed -E 's/^(href|src)="//; s/"$//' | grep -vE '^(https?:|//|mailto:|tel:|javascript:|data:)' | sed -E 's#^\./#/#; s#^([^/])#/\1#' | sort -u)
for p in $A; do printf '%s -> %s\n' "$p" "$(curl -s -o /dev/null -w '%{http_code} %{content_type} %{size_download}' "$B$p")"; L=$(curl -s -o /dev/null -w '%{redirect_url}' "$B$p"); [ -n "$L" ] && printf '   (redirect_url=%s -> %s)\n' "${L#$B}" "$(curl -sL -o /dev/null -w '%{http_code} %{content_type} %{size_download}' "$B$p")"; done
echo "# missing-path body check: curl -s $B/no-such-page | head -c 300"
curl -s "$B/no-such-page" | head -c 300; echo
echo "# summary: $(grep -c ' -> 2' /dev/null)"
} > "$OUT" 2>&1
kill $SP; wait $SP 2>/dev/null
G=$(grep -v '^#' "$OUT"); c2=$(echo "$G" | grep -cE ' -> 2[0-9][0-9] '); c4=$(echo "$G" | grep -cE ' -> 404 '); co=$(echo "$G" | grep -E ' -> ' | grep -vcE ' -> (2[0-9][0-9]|404) ')
sed -i "s/^# summary: .*/# summary: 2xx=$c2 404=$c4 other=$co/" "$OUT"
cat "$OUT"
