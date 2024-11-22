#!/usr/bin/env bash

set -euo pipefail

PREV="${PREV:-${NEXT:-}}"
NEXT="${NEXT:-}"
MOD="${MOD:-}"

if [[ -n "${GITHUB_ACTIONS:-}" ]]; then git config --global --add safe.directory /github/workspace; fi

prev_version=$(gh release list --json tagName | jq -r '.[].tagName' | calver --layout "${PREV}" || calver --layout "${PREV}")

if [[ -z $MOD ]]; then
  next_version=$(echo "$prev_version" | calver --layout "${NEXT}" --next)
else
  next_version=$(echo "$prev_version" | calver --layout "${NEXT}" --next --modifier "$MOD")
fi

cat <<EOF | tee "${GITHUB_OUTPUT:-/dev/null}"
prev_version=${prev_version}
next_version=${next_version}
EOF
