#!/usr/bin/env bash
set -euo pipefail
IMAGE_DIR="${1:-dist/images}"
TARGET_DIR="${TARGET_DIR:-/var/lib/rancher/rke2/agent/images}"

if [ ! -d "$IMAGE_DIR" ]; then
  echo "Image directory not found: $IMAGE_DIR" >&2
  exit 1
fi
sudo mkdir -p "$TARGET_DIR"
sudo cp "$IMAGE_DIR"/*.tar "$TARGET_DIR"/
echo "Images copied to $TARGET_DIR. Restart rke2-agent/server if needed."
