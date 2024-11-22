#!/usr/bin/env bash

set -euo pipefail

layout="vYY.0M.MICRO"

PARSED_OPTIONS=$(getopt -o l: --long layout: -- "$@")
eval set -- "$PARSED_OPTIONS"

while true; do
  case "$1" in
  -l | --layout)
    layout="$2"
    shift 2
    ;;
  --)
    shift
    break
    ;;
  *)
    echo "Usage: cmd [-l layout] [--layout layout]"
    exit 1
    ;;
  esac
done

git config --global --add safe.directory /github/workspace

prev_version=$(gh release list --json tagName | jq -r '.[].tagName' | calver --layout "${layout}" || calver --layout "${layout}")
next_version=$(echo "$prev_version" | calver --layout "${layout}" --next)

cat <<EOF | tee "${GITHUB_OUTPUT:-/dev/null}"
prev_version=${prev_version}
next_version=${next_version}
EOF
