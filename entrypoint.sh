#!/usr/bin/env bash

set -euo pipefail

layout=vYY.0M.MICRO-MODIFIER
modifier=

case "$GITHUB_EVENT_NAME" in
push)
  case "$GITHUB_REF" in
  refs/heads/main | refs/heads/master)
    series=stable
    ;;
  refs/heads/develop)
    series=beta
    modifier=beta.${GITHUB_RUN_NUMBER}.${GITHUB_SHA:0:7}
    ;;
  *)
    series=alpha
    modifier=alpha.${GITHUB_RUN_NUMBER}.${GITHUB_SHA:0:7}
    ;;
  esac
  ;;
pull_request | pull_request_target)
  series="pr$(jq '.pull_request.number' "$GITHUB_EVENT_PATH")"
  modifier=${series}.${GITHUB_RUN_NUMBER}.${GITHUB_SHA:0:7}
  ;;
esac

version=$(gh release list --json tagName | jq -r '.[].tagName' | calver --trim-suffix --layout=$layout --next --modifier="$modifier" 2>/dev/null || true)

[[ -z "${version}" ]] && version=$(calver --layout=$layout | calver --next --layout=$layout --modifier="$modifier" --trim-suffix)

cat <<EOF | tee "${GITHUB_OUTPUT:-/dev/null}"
series=${series}
version=${version}
EOF
