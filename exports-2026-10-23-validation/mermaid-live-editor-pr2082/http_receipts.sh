#!/bin/bash
# usage: http_receipts.sh BASE STATIC_APP  -> verbatim curl lines to stdout
B=$1; APP=$2; T=$(mktemp -d)
W='%{http_code} %{content_type} %{size_download} %{url_effective}\n'
c(){ curl -sS -o /dev/null -w "$W" "$B$1"; }
echo "## server: $($3 --version 2>/dev/null | head -1)"
echo "## pages"
for p in / /edit /view /embed /edit/ /view/ /embed/ /edit.html /view.html /embed.html /index.html /404.html; do c $p; done
echo "## missing paths (must be 404)"
M=/definitely-missing-$RANDOM$RANDOM; c $M; c /_app/immutable/chunks/definitely-missing.js; c /definitely-missing.css
echo "## body identity of served pages (sha256 of body vs files on disk)"
for f in index 404 edit view embed; do echo "disk $f.html $(sha256sum < $APP/$f.html | cut -c1-16)"; done
for p in / /edit /view /embed /edit/ $M; do echo "served $p $(curl -sS "$B$p" | sha256sum | cut -c1-16)"; done
echo "## assets referenced by served HTML of / /edit /view /embed (href/src/import())"
for p in / /edit /view /embed; do curl -sS "$B$p" > $T/page.html
  python3 -I -c '
import re,sys,urllib.parse as u
t=open(sys.argv[1]).read()
for m in re.finditer(r"(?:href|src)\s*=\s*[\"\x27]([^\"\x27#]+)|import\(\"([^\"]+)\"\)",t):
  r=m.group(1) or m.group(2)
  if r.startswith(("http:","https:","//","data:","mailto:")): continue
  print(u.urlparse(u.urljoin("http://h"+sys.argv[2],r)).path)' $T/page.html $p
done | sort -u > $T/refs
echo "# $(wc -l < $T/refs) unique refs"; while read r; do c "$r"; done < $T/refs
echo "## fonts referenced by served CSS (url())"
grep '\.css$' $T/refs | while read r; do curl -sS "$B$r" | grep -o 'url([^)]*)' | sed 's/url(//;s/)//;s/["'"'"']//g' | grep -v '^data:' | while read u; do python3 -I -c 'import sys,urllib.parse as u;print(u.urlparse(u.urljoin("http://h"+sys.argv[1],sys.argv[2])).path)' "$r" "$u"; done; done | sort -u > $T/fonts
echo "# $(wc -l < $T/fonts) unique font/css-url refs"; while read r; do c "$r"; done < $T/fonts
echo "## all JS-referenced CSS/font/worker assets present on disk under _app/immutable/{assets,workers} + root files"
for f in $(cd $APP && ls _app/immutable/assets/* _app/immutable/workers/* | sort) manifest.json service-worker.js embed.js favicon.ico favicon.svg favicon.png robots.txt sitemap.xml llms.txt _app/version.json; do c /$f; done
