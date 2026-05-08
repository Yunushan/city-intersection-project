#!/usr/bin/env bash
set -euo pipefail
PROJECT_NAME="${PROJECT_NAME:-city-intersection-project}"
GITLAB_URL="${GITLAB_URL:-https://gitlab.com}"
VISIBILITY="${GITLAB_VISIBILITY:-private}"
: "${GITLAB_TOKEN:?Set GITLAB_TOKEN with api scope}"

DATA=(--data-urlencode "name=${PROJECT_NAME}" --data-urlencode "path=${PROJECT_NAME}" --data-urlencode "visibility=${VISIBILITY}")
if [ -n "${GITLAB_NAMESPACE_ID:-}" ]; then
  DATA+=(--data-urlencode "namespace_id=${GITLAB_NAMESPACE_ID}")
fi
curl -fsS --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "${DATA[@]}" "${GITLAB_URL%/}/api/v4/projects"
echo "GitLab project requested with visibility=${VISIBILITY}."
