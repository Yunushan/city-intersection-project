#!/usr/bin/env bash
set -euo pipefail
BRANCH="${BRANCH:-main}"

git branch -M "${BRANCH}"
for remote in github gitlab origin; do
  if git remote get-url "$remote" >/dev/null 2>&1; then
    echo "Pushing to $remote..."
    git push -u "$remote" "$BRANCH"
  fi
done
