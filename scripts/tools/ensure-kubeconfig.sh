#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${ENV:-prod}"
ENGINE="${ENGINE:-rke2}"
INVENTORY_PATH="${INVENTORY:-inventories/${ENVIRONMENT}/hosts.yml}"
ANSIBLE_CONFIG_PATH="${ANSIBLE_CONFIG:-ansible/ansible.cfg}"
ANSIBLE_PLAYBOOK_BIN="${ANSIBLE_PLAYBOOK:-ansible-playbook}"
OPERATOR_KUBECONFIG_PATH="${OPERATOR_KUBECONFIG:-${KUBECONFIG:-${HOME}/.kube/config}}"
FALLBACK_INVENTORY_PATH="${TMPDIR:-/tmp}/urban-platform-import-inventory.yml"

if [ "${ENGINE}" != "rke2" ]; then
  echo "Skipping automatic kubeconfig repair for ENGINE=${ENGINE}; using existing kubectl context."
  exit 0
fi

if [ ! -f "${INVENTORY_PATH}" ]; then
  if [ -z "${MIGRATION_RKE2_NODES:-}" ]; then
    echo "Missing inventory ${INVENTORY_PATH}; cannot repair operator kubeconfig." >&2
    echo "Set INVENTORY=/path/to/hosts.yml or MIGRATION_RKE2_NODES=node-1,node-2,node-3." >&2
    exit 1
  fi

  IFS=',' read -r -a rke2_nodes <<< "${MIGRATION_RKE2_NODES}"
  first_rke2_node=""
  for node in "${rke2_nodes[@]}"; do
    node="${node//[[:space:]]/}"
    if [ -n "${node}" ]; then
      first_rke2_node="${node}"
      break
    fi
  done
  if [ -z "${first_rke2_node}" ]; then
    echo "MIGRATION_RKE2_NODES did not contain any usable node address." >&2
    exit 1
  fi

  explicit_cluster_vip="${MIGRATION_CLUSTER_VIP:-${CLUSTER_VIP:-}}"
  cluster_vip="${explicit_cluster_vip:-${first_rke2_node}}"
  if [ -n "${explicit_cluster_vip}" ]; then
    kubernetes_api_port="${MIGRATION_KUBERNETES_API_VIP_PORT:-${KUBERNETES_API_VIP_PORT:-7443}}"
  else
    kubernetes_api_port="${MIGRATION_KUBERNETES_API_VIP_PORT:-${KUBERNETES_API_VIP_PORT:-6443}}"
  fi
  ansible_user_for_nodes="${MIGRATION_SSH_USER:-${ANSIBLE_USER:-root}}"

  {
    printf 'all:\n'
    printf '  vars:\n'
    printf '    ansible_user: %s\n' "${ansible_user_for_nodes}"
    printf '    ansible_python_interpreter: /usr/bin/python3\n'
    printf '    cluster_engine: rke2\n'
    printf '    cluster_vip: %s\n' "${cluster_vip}"
    printf '    kubernetes_api_vip_port: %s\n' "${kubernetes_api_port}"
    printf '  children:\n'
    printf '    cluster_nodes:\n'
    printf '      children:\n'
    printf '        rke2_servers:\n'
    printf '        rke2_agents:\n'
    printf '    rke2_servers:\n'
    printf '      hosts:\n'
    index=1
    for node in "${rke2_nodes[@]}"; do
      node="${node//[[:space:]]/}"
      if [ -z "${node}" ]; then
        continue
      fi
      printf '        import-rke2-%02d:\n' "${index}"
      printf '          ansible_host: %s\n' "${node}"
      printf '          node_ip: %s\n' "${node}"
      index=$((index + 1))
    done
    printf '    rke2_agents:\n'
    printf '      hosts: {}\n'
    printf '    load_balancers:\n'
    printf '      hosts:\n'
    index=1
    for node in "${rke2_nodes[@]}"; do
      node="${node//[[:space:]]/}"
      if [ -z "${node}" ]; then
        continue
      fi
      printf '        import-rke2-%02d: {}\n' "${index}"
      index=$((index + 1))
    done
  } > "${FALLBACK_INVENTORY_PATH}"
  chmod 0600 "${FALLBACK_INVENTORY_PATH}" 2>/dev/null || true
  INVENTORY_PATH="${FALLBACK_INVENTORY_PATH}"
  echo "Generated temporary operator inventory from MIGRATION_RKE2_NODES: ${INVENTORY_PATH}"
  echo "Operator kubeconfig endpoint will be https://${cluster_vip}:${kubernetes_api_port}"
fi

extra_args=()
if [ -n "${ANSIBLE_ARGS:-}" ]; then
  # shellcheck disable=SC2206
  extra_args=(${ANSIBLE_ARGS})
fi

ANSIBLE_CONFIG="${ANSIBLE_CONFIG_PATH}" \
  "${ANSIBLE_PLAYBOOK_BIN}" \
  -i "${INVENTORY_PATH}" \
  ansible/playbooks/operator-kubeconfig.yml \
  -e "cluster_engine=${ENGINE}" \
  -e "deployment_environment=${ENVIRONMENT}" \
  -e "operator_kubeconfig_path=${OPERATOR_KUBECONFIG_PATH}" \
  "${extra_args[@]}"

if command -v kubectl >/dev/null 2>&1; then
  KUBECONFIG="${OPERATOR_KUBECONFIG_PATH}" kubectl version --request-timeout=10s >/dev/null
fi

echo "Operator kubeconfig ready: ${OPERATOR_KUBECONFIG_PATH}"
