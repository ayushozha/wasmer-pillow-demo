#!/bin/bash
# usage: compare.sh <static_app dir> <sws_port> <sws config file or -> <urls.txt>
# Serves the SAME build with (a) upstream nginx.conf (oracle, nginx-oracle.conf.in with paths/port substituted)
# on 127.0.0.1:3993 and (b) static-web-server 2.38.0 on <sws_port> (+ --config-file if given), then requests every
# URL in urls.txt on both with curl --path-as-is (no redirect following) and prints status, content type, size, Location.
set -u
S=${S:?set S}; APP=$1; PORT=$2; CFG=$3; URLS=$4
D=$(cd "$(dirname "$0")" && pwd); N=$S/val3-src/nginx-deb; mkdir -p "$N/run"
sed "s#NGX_RUN#$N/run#g; s#NGX_ROOT#$N/root#g; s#ORACLE_ROOT#$APP#; s#^http {#http {\n    client_body_temp_path $N/run/body; proxy_temp_path $N/run/proxy; fastcgi_temp_path $N/run/fcgi; uwsgi_temp_path $N/run/uwsgi; scgi_temp_path $N/run/scgi;  \# oracle-only: writable temp dirs#" "$D/nginx-oracle.conf.in" > "$N/run/nginx.conf"
"$N/root/usr/sbin/nginx" -p "$N/run" -c "$N/run/nginx.conf" -e "$N/run/error.log" 2>&1
A=(--root="$APP" --log-level=info --port="$PORT" --host=127.0.0.1); [ "$CFG" != - ] && A+=(--config-file="$CFG")
"$S/sws/bin/static-web-server" "${A[@]}" > "$N/run/sws.log" 2>&1 & SP=$!
sleep 1.5
c(){ curl --path-as-is -s -o /dev/null -w '%{http_code} %{content_type} %{size_download} loc=%header{location}' "$1"; }
echo "# $(date -u +%FT%TZ) oracle: $("$N/root/usr/sbin/nginx" -v 2>&1) with upstream nginx.conf; candidate: $("$S/sws/bin/static-web-server" --version 2>&1|head -1) config=$( [ "$CFG" = - ] && echo none || basename "$CFG")"
printf '%-28s | %-52s | %-52s | %s\n' URL "nginx (upstream nginx.conf)" "static-web-server" same-status+loc
same=0; diff=0
while read -r u; do
  case "$u" in ''|'#'*) echo "$u"; continue;; esac
  a=$(c "http://127.0.0.1:3993$u"); b=$(c "http://127.0.0.1:$PORT$u")
  sa="${a%% *} ${a##*loc=}"; sb="${b%% *} ${b##*loc=}"
  sa=${sa//http:\/\/127.0.0.1:3993/}; sb=${sb//http:\/\/127.0.0.1:$PORT/}  # compare status + Location path (nginx sends absolute, SWS relative)
  [ "$sa" = "$sb" ] && { m=same; same=$((same+1)); } || { m=DIFF; diff=$((diff+1)); }
  printf '%-28s | %-52s | %-52s | %s\n' "$u" "${a//127.0.0.1:3993/HOST}" "${b//127.0.0.1:$PORT/HOST}" "$m"
done < "$URLS"
echo "# same=$same diff=$diff"
kill $SP; "$N/root/usr/sbin/nginx" -p "$N/run" -c "$N/run/nginx.conf" -s stop 2>&1; wait $SP 2>/dev/null
