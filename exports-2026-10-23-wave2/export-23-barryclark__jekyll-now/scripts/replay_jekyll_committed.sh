#!/bin/bash
# Replay of Anybuild v0.33.0's jekyll_build steps for a repo with a committed Anybuild:
#   workdir temp; [install group] bundle init; bundle add jekyll -v <ver>; copy . ; [build group] <config.commands.build>; cp -R _site/* static_app
# (jekyll.bzl + serve.bzl _override_group_commands), Ruby 3.4.7, no LANG/locale set, then native SWS 2.38.0 on 127.0.0.1.
# usage: replay_jekyll_committed.sh <patched clone> <name> <port>
set -u
S=/tmp/claude-0/-home-user-wasmer-pillow-demo/9b68abed-67cb-5023-b672-44f9751def64/scratchpad
SRC=$1; NAME=$2; PORT=$3
R=$S/replay/$NAME; rm -rf "${R:?}"; mkdir -p "$R"
FLAT=$R/flat; WORK=$R/work; APP=$R/static_app; LOG=$R/replay.log; : > "$LOG"
run(){ echo "\$ $*" >> "$LOG"; ( eval "$@" ) >> "$LOG" 2>&1; local r=$?; echo "exit=$r" >> "$LOG"; echo >> "$LOG"; return $r; }
mkdir -p "$FLAT" "$WORK" "$APP"; (cd "$SRC" && tar --exclude=.git -cf - .) | (cd "$FLAT" && tar -xf -)
echo "# replay of $NAME upstream HEAD=$(git -C "$SRC" rev-parse HEAD) local diff: $(git -C "$SRC" status --porcelain | tr '\n' ';')" >> "$LOG"
"$S/w/anybuild-v0.33.0" plan --anybuild-path "$FLAT/Anybuild" --wasmer "$FLAT" -o "$R/plan.json" > "$R/plan.txt" 2>&1
sed "s#$S#\$S#g" "$R/plan.txt" >> "$LOG"
eval "$(python3 -I - "$R/plan.json" <<'PY'
import json,sys,shlex
c=json.load(open(sys.argv[1]))['config']; cmd=c['commands']
for k,v in dict(INSTALL=cmd['install'],BUILD=cmd['build'],START=cmd['start'],SDIR=c.get('static_dir') or '_site').items(): print(f"{k}={shlex.quote(v)}")
PY
)"
echo "# plan: install='$INSTALL' build='$BUILD' start='$START' static_dir='$SDIR'" >> "$LOG"
export PATH="$S/ruby/3.4.7/bin:$PATH" GEM_HOME=$R/gems; export PATH="$GEM_HOME/bin:$PATH"; unset LANG LC_ALL
echo "# locale env: LANG='${LANG:-}' LC_ALL='${LC_ALL:-}'" >> "$LOG"
cd "$WORK"; run ruby -v; run bundle -v
run "$INSTALL" || echo "INSTALL FAILED" >> "$LOG"
cp -a "$FLAT/." .
run "$BUILD" || echo "BUILD FAILED" >> "$LOG"
run "cp -R ${SDIR}/* '$APP/'" || echo "COPY FAILED" >> "$LOG"
echo "# Gemfile after build:" >> "$LOG"; cat Gemfile >> "$LOG"
echo "# static_app files: $(find "$APP" -type f | wc -l)" >> "$LOG"
