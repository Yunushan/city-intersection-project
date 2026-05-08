#!/usr/bin/env bash
set -euo pipefail
OUT_DIR="${1:-dist/images}"
mkdir -p "$OUT_DIR"
while read -r image; do
  safe=$(echo "$image" | tr '/:' '__')
  echo "Saving $image"
  docker save "$image" -o "${OUT_DIR}/${safe}.tar"
done < <(python3 scripts/images/list-images.py)
