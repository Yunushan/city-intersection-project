#!/usr/bin/env bash
set -euo pipefail
PROJECT_NAME="${PROJECT_NAME:-urban-platform-infra}"

git init
if ! git branch --show-current >/dev/null 2>&1; then
  git checkout -b main
fi
git add .
git commit -m "Initial enterprise HA scaffold for ${PROJECT_NAME}" || true
printf 'Local git repository is ready.\n'
