#!/usr/bin/env bash

set -euo pipefail

declare layoutPrev=vYY.MM.MICRO
declare layoutNext=$layoutPrev
declare modifier=

case "$GITHUB_EVENT_NAME" in
push | workflow_dispatch)
  case "$GITHUB_REF" in
  refs/heads/main | refs/heads/master)
    series=stable
    ;;
  refs/heads/develop)
    series=beta
    modifier=${series}.${GITHUB_RUN_NUMBER}
    layoutNext+=-MODIFIER
    ;;
  *)
    series=alpha
    modifier=${series}.${GITHUB_RUN_NUMBER}
    layoutNext+=-MODIFIER
    ;;
  esac
  ;;
pull_request)
  series="pr$(jq '.pull_request.number' "$GITHUB_EVENT_PATH")"
  modifier=${series}.${GITHUB_RUN_NUMBER}
  layoutNext+=-MODIFIER
  ;;
*)
  cat <<EOF >&2
::error::Unsupported event name: '$GITHUB_EVENT_NAME'
EOF
  exit 1
  ;;
esac

git config --global --add safe.directory /github/workspace

historical=$(gh release list --json tagName | jq -r '.[].tagName')

declare prev
prev=$(calver --layout=$layoutNext)
[[ -n "${historical}" ]] && prev=$(echo "$historical" | calver --layout=$layoutPrev 2>/dev/null || calver --layout=$layoutPrev)

next=$(echo "$prev" | calver --next --layout=$layoutNext --modifier="$modifier" --trim-suffix)

cat <<EOF | tee "${GITHUB_OUTPUT:-/dev/null}"
series=${series}
version=${next}
EOF
