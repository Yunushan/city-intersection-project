#!/usr/bin/env bash
set -euo pipefail
PROJECT_NAME="${PROJECT_NAME:-urban-platform-infra}"
OWNER="${GITHUB_OWNER:-}"
VISIBILITY="${GITHUB_VISIBILITY:-private}"

if command -v gh >/dev/null 2>&1; then
  if [ -n "${OWNER}" ]; then
    gh repo create "${OWNER}/${PROJECT_NAME}" --"${VISIBILITY}" --source=. --remote=github --push
  else
    gh repo create "${PROJECT_NAME}" --"${VISIBILITY}" --source=. --remote=github --push
  fi
else
  : "${GH_TOKEN:?Set GH_TOKEN or install/login with GitHub CLI gh}"
  API="https://api.github.com/user/repos"
  DATA=$(printf '{"name":"%s","private":%s}' "$PROJECT_NAME" "$([ "$VISIBILITY" = private ] && echo true || echo false)")
  curl -fsS -H "Authorization: Bearer ${GH_TOKEN}" -H "Accept: application/vnd.github+json" -d "$DATA" "$API"
  echo "Add the returned clone URL as remote 'github', then push."
fi
