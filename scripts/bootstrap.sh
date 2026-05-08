#!/usr/bin/env bash
set -euo pipefail
ENV="${ENV:-prod}"
ENGINE="${ENGINE:-rke2}"
INVENTORY="inventories/${ENV}/hosts.yml"

if [ ! -f "$INVENTORY" ]; then
  echo "Missing inventory $INVENTORY. Copy inventories/example/hosts.yml first." >&2
  exit 1
fi
ansible-galaxy collection install -r ansible/requirements.yml
ansible-playbook -i "$INVENTORY" ansible/playbooks/bootstrap.yml -e cluster_engine="$ENGINE"
ansible-playbook -i "$INVENTORY" ansible/playbooks/install-cluster.yml -e cluster_engine="$ENGINE"
