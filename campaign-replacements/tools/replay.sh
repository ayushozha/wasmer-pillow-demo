#!/bin/bash
# Faithful local replay of what Anybuild v0.33.0 (wasmerio/shipit tag v0.33.0, 587be231) generates
# for a static-family app, then a smoke test against static-web-server 2.38.0 (the version it pins).
#
# usage: replay.sh <source-dir (patched clone)> <name> <port> [extra smoke paths...]
# output: $S/replay/<name>/{plan.json,plan.txt,replay.log,smoke.txt}, static_app/ served from there.
set -u
S=/tmp/claude-0/-home-user-wasmer-pillow-demo/9b68abed-67cb-5023-b672-44f9751def64/scratchpad
SRC=$1; NAME=$2; PORT=$3; shift 3; EXTRA=("$@")
ANYBUILD=$S/w/anybuild-v0.33.0
SWS=$S/sws/bin/static-web-server
NODE24=$S/w/node24/node_modules/.bin
RUBY347=$S/ruby/3.4.7/bin
R=$S/replay/$NAME; rm -rf "$R"; mkdir -p "$R"
FLAT=$R/flat            # flat root: no ancestor package.json / workspace above it
WORK=$R/work            # Anybuild's temp mount
APP=$R/static_app       # Anybuild's static_app mount
LOG=$R/replay.log; : > "$LOG"
say(){ echo "$*" | tee -a "$LOG"; }
run(){ echo "\$ $*" >> "$LOG"; ( eval "$@" ) >> "$LOG" 2>&1; local r=$?; echo "exit=$r" >> "$LOG"; echo >> "$LOG"; return $r; }

for p in "$R" "$S" "$(dirname "$S")" /tmp; do
  for f in package.json pnpm-workspace.yaml Gemfile; do [ -e "$p/$f" ] && say "WARNING ancestor file $p/$f"; done
done

# 1. flat clean copy (Anybuild ignores .git)
mkdir -p "$FLAT"; (cd "$SRC" && tar --exclude=.git -cf - .) | (cd "$FLAT" && tar -xf -)
say "# replay of $NAME  source=$SRC  upstream HEAD=$(git -C "$SRC" rev-parse HEAD 2>/dev/null)"
say "# local diff vs HEAD: $(git -C "$SRC" status --porcelain 2>/dev/null | tr '\n' ';')"

# 2. plan
"$ANYBUILD" plan --temp-anybuild --wasmer "$FLAT" -o "$R/plan.json" > "$R/plan.txt" 2>&1
cat "$R/plan.txt" | sed "s#$FLAT#<flat>#g; s#/tmp/Anybuild[A-Za-z0-9]*#<tmp>#g" >> "$LOG"
eval "$(python3 -I - "$R/plan.json" <<'PY'
import json,sys,shlex
c=json.load(open(sys.argv[1]))['config']
cmd=c.get('commands') or {}
prov='unknown'
if 'node_package_manager' in c and c.get('node_build_command') is not None and (cmd.get('start','').startswith('static-web-server')): prov='node-static'
elif 'hugo_version' in c: prov='hugo'
elif cmd.get('install','').startswith('bundle') : prov='jekyll'
elif cmd.get('start','').startswith('static-web-server'): prov='staticfile'
elif 'node_package_manager' in c: prov='node-server'
out=dict(PROV=prov, INSTALL=cmd.get('install',''), BUILD=cmd.get('build',''), START=cmd.get('start',''),
  STATIC_DIR=c.get('static_dir') or '', PM=c.get('node_package_manager') or '', PMV=c.get((c.get('node_package_manager') or 'x')+'_version') or '',
  INPUTS=' '.join(c.get('node_install_inputs') or []), ALLFILES=str(bool(c.get('node_install_requires_all_files'))),
  REDIR=c.get('static_redirects_config') or '', HUGOV=c.get('hugo_version') or '', JEKYLLV=c.get('jekyll_version') or '4.3.0')
for k,v in out.items(): print(f"{k}={shlex.quote(str(v))}")
PY
)"
say "# provider=$PROV install='$INSTALL' build='$BUILD' start='$START' static_dir='$STATIC_DIR' pm=$PM@$PMV inputs='$INPUTS' all_files=$ALLFILES"

mkdir -p "$WORK" "$APP"
case "$PROV" in
node-static)
  export PATH="$NODE24:$PATH"
  # Use the package-manager version the plan pins (npm included: e.g. npm_version=11), not the host's.
  if [ "$PM" != npm ] || [ -n "$PMV" ]; then
    PMDIR=$S/pm/$PM-${PMV:-latest}; [ -x "$PMDIR/bin/$PM" ] || npm i -g --prefix "$PMDIR" "$PM@${PMV:-latest}" > /dev/null 2>&1
    export PATH="$PMDIR/bin:$PATH"
  fi
  run node -v; run $PM --version
  cd "$WORK"
  if [ "$ALLFILES" = True ]; then cp -a "$FLAT/." .; else
    # node.bzl node_install_steps: copy(lockfile) then run(install, inputs=node_install_inputs)
    case "$PM" in npm) LOCK=package-lock.json;; pnpm) LOCK=pnpm-lock.yaml;; yarn) LOCK=yarn.lock;; bun) LOCK=bun.lock;; *) LOCK=;; esac
    [ "$PM" = bun ] && [ ! -e "$FLAT/bun.lock" ] && [ -e "$FLAT/bun.lockb" ] && LOCK=bun.lockb
    for f in $LOCK $INPUTS; do [ -e "$FLAT/$f" ] && cp -a "$FLAT/$f" .; done
    echo "# staged before install: $(ls -A | tr '\n' ' ')" >> "$LOG"
  fi
  case "$PM" in pnpm) export pnpm_config_minimum_release_age=0 CI=true pnpm_config_dangerously_allow_all_builds=true pnpm_config_strict_dep_builds=false;; npm) export CI=true NPM_CONFIG_FUND=false;; esac
  run "$INSTALL" || say "INSTALL FAILED"
  [ "$ALLFILES" = True ] || (cd "$FLAT" && tar --exclude=node_modules -cf - .) | tar -xf -
  run "$BUILD" || say "BUILD FAILED"
  [ -d "$STATIC_DIR" ] && cp -R "$STATIC_DIR/." "$APP/" || say "STATIC_DIR '$STATIC_DIR' MISSING"
  ;;
staticfile)
  run "cp -R '$FLAT/${STATIC_DIR:-.}/.' '$APP/'" || say "STATIC_DIR '$STATIC_DIR' MISSING"
  ;;
jekyll)
  export PATH="$RUBY347:$PATH" GEM_HOME=$R/gems; export PATH="$GEM_HOME/bin:$PATH"
  run ruby -v
  cd "$WORK"
  if [ -e "$FLAT/Gemfile" ]; then [ -e "$FLAT/Gemfile.lock" ] && cp "$FLAT/Gemfile.lock" .; cp "$FLAT/Gemfile" .; run bundle install || say "INSTALL FAILED"
  else run "bundle init && bundle add jekyll -v $JEKYLLV" || say "INSTALL FAILED"; fi
  cp -a "$FLAT/." .
  run jekyll build || say "BUILD FAILED"
  run "cp -R ${STATIC_DIR:-_site}/* '$APP/'" || say "COPY FAILED"
  ;;
hugo)
  HB=$S/hugo/$HUGOV/hugo; [ -x "$HB" ] && export PATH="$(dirname "$HB"):$PATH"
  run hugo version
  cd "$WORK"; cp -a "$FLAT/." .
  run "$BUILD" || say "BUILD FAILED"
  run "cp -R ${STATIC_DIR:-public}/. '$APP/'" || say "COPY FAILED"
  ;;
*) say "NOT A STATIC PROVIDER ($PROV): start='$START' — no static replay";;
esac

# 3. serve with static-web-server exactly as generated (plus its redirects config if any)
cd "$R"
# Only deviation from the generated start command: --host=127.0.0.1 (this container has no IPv6 for the default [::] bind).
SWSARGS=(--root="$APP" --log-level=info --port="$PORT" --host=127.0.0.1)
echo "\$ static-web-server ${SWSARGS[*]}" >> "$LOG"
if [ -n "$REDIR" ]; then printf '%s' "$REDIR" > "$R/sws.toml"; SWSARGS+=(--config-file="$R/sws.toml"); fi
"$SWS" --version >> "$LOG" 2>&1
"$SWS" "${SWSARGS[@]}" > "$R/sws.log" 2>&1 & SP=$!
for i in $(seq 1 30); do curl -s -o /dev/null "http://127.0.0.1:$PORT/" && break; sleep 0.5; done
python3 -I "$S/scripts/smoke.py" "http://127.0.0.1:$PORT" "$APP" "${EXTRA[@]}" > "$R/smoke.txt" 2>&1
kill $SP 2>/dev/null; wait $SP 2>/dev/null
cat "$R/smoke.txt" >> "$LOG"
say "# static_app files: $(find "$APP" -type f | wc -l)"
tail -3 "$R/smoke.txt"
