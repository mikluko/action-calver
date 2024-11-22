#!/usr/bin/env bash

set -euo pipefail

layout=vYY.0M.MICRO-MODIFIER
modifier="${1:-}"

if [[ -n "${GITHUB_ACTIONS:-}" ]]; then git config --global --add safe.directory /github/workspace; fi

version=$(gh release list --json tagName | jq -r '.[].tagName' | calver --trim-suffix --layout=$layout --next --modifier=$modifier 2>/dev/null || true)

[[ -z "${version}" ]] && version=$(calver --layout=$layout | calver --next --layout=$layout --modifier=$modifier --trim-suffix)

cat <<EOF | tee "${GITHUB_OUTPUT:-/dev/null}"
version=${version}
EOF
