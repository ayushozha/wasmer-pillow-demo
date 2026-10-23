#!/bin/bash
# usage: http-check.sh <static_app> <port>
A=$1; P=$2; B=http://127.0.0.1:$P
c(){ curl -sS -o /dev/null -w '%{http_code} %{content_type} %{size_download} %{url_effective}\n' "$B$1"; }
echo "## server: local native static-web-server 2.38.0, root=static_app (Anybuild static_dir excalidraw-app/build), --host=127.0.0.1 --port=$P"
echo "## [pages]"; c /; c /index.html; c /definitely-missing-q7x3k9; c /web-share-target
echo "## [local refs in index.html, enumerated from the HTML]"
for u in $(grep -oE '(src|href)="/[^"]*"' $A/index.html | sed -E 's/.*="(.*)"/\1/'); do c "$u"; done
echo "## [service worker + workbox + legacy service-worker.js]"
c /sw.js; for f in $(cd $A && ls workbox-*.js); do c /$f; done; c /service-worker.js
echo "## [manifest icons/screenshots]"
for u in android-chrome-192x192.png apple-touch-icon.png favicon-32x32.png favicon-16x16.png /screenshots/virtual-whiteboard.png /screenshots/wireframe.png /screenshots/illustration.png /screenshots/shapes.png /screenshots/collaboration.png /screenshots/export.png; do c "/${u#/}"; done
echo "## [all JS chunks under /assets (lazy chunks of the same build)]"
for f in $(cd $A && find assets -name '*.js' | sort); do c /$f; done
echo "## [all CSS]"; for f in $(cd $A && find . -name '*.css' | sed 's#^\./##' | sort); do c /$f; done
echo "## [all self-hosted fonts (*.woff2), incl. local copies of the 4 fonts index.html preloads from the upstream CDN]"
for f in $(cd $A && find . -name '*.woff2' | sed 's#^\./##' | sort); do c /$f; done
