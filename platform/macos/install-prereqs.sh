#!/usr/bin/env bash
set -euo pipefail
if ! command -v brew >/dev/null 2>&1; then
  echo "Install Homebrew first: https://brew.sh" >&2
  exit 1
fi
brew install git jq make python ansible kubectl helm helmfile
