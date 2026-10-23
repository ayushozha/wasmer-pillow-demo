#!/bin/bash
# usage: policy.sh <clone> <out-file>
C=$1; O=$2
{ echo "# policy files at HEAD $(git -C "$C" rev-parse HEAD) ($(date -u +%F))"
echo '$ git ls-files | grep -iE "contrib|agents.md|claude.md|cursorrules|copilot-instructions|pull_request_template|PULL_REQUEST|code_of_conduct|cla|security.md|anybuild|wasmer"'
git -C "$C" ls-files | grep -iE 'contrib|agents\.md|claude\.md|cursorrules|copilot-instructions|pull_request_template|PULL_REQUEST|code_of_conduct|(^|/)cla|security\.md|anybuild|wasmer'; echo "(end of list)"
echo '$ git ls-files .github'; git -C "$C" ls-files .github; echo "(end of list)"
echo '$ git grep -niE "\bAI\b|LLM|chatgpt|copilot|contributor license|\bCLA\b|issue first|open an issue (first|before)|no (pull requests|PRs)" -- README* CONTRIBUTING* .github docs/CONTRIBUTING*'
(cd "$C" && git grep -niE '\bAI\b|LLM|chatgpt|copilot|contributor license|\bCLA\b|issue first|open an issue (first|before)|no (pull requests|PRs)' -- 'README*' 'CONTRIBUTING*' '.github' 'docs/CONTRIBUTING*' 2>/dev/null); echo "(end of matches)"
for f in $(git -C "$C" ls-files .github/workflows); do echo "--- $f (on:/jobs names)"; git -C "$C" show "HEAD:$f" | grep -nE '^name:|^on:|^  [a-z_-]+:$|uses:' ; done
echo "$ git log -5 --format=\"%cI %h %s\""; git -C "$C" log -5 --format="%cI %h %s"
} > "$O" 2>&1; cat "$O"
