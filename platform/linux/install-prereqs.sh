#!/usr/bin/env bash
set -euo pipefail
if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y curl git jq make python3 python3-pip ansible helm
elif command -v dnf >/dev/null 2>&1; then
  sudo dnf install -y curl git jq make python3 python3-pip ansible-core
elif command -v yum >/dev/null 2>&1; then
  sudo yum install -y curl git make python3 python3-pip ansible
else
  echo "Install curl, git, jq, make, python3, ansible, kubectl, and helm with your OS package manager."
fi
