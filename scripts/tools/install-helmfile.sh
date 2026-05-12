#!/usr/bin/env bash
set -euo pipefail

if command -v helmfile >/dev/null 2>&1; then
  helmfile --version
  exit 0
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required to install Helmfile." >&2
  exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
  echo "tar is required to install Helmfile." >&2
  exit 1
fi

version="${HELMFILE_VERSION:-v1.2.1}"
os_name="$(uname -s | tr '[:upper:]' '[:lower:]')"
machine_arch="$(uname -m)"

case "${machine_arch}" in
  x86_64 | amd64)
    arch="amd64"
    ;;
  aarch64 | arm64)
    arch="arm64"
    ;;
  *)
    echo "Unsupported Helmfile architecture: ${machine_arch}" >&2
    exit 1
    ;;
esac

case "${os_name}" in
  linux | darwin)
    ;;
  *)
    echo "Unsupported Helmfile OS: ${os_name}" >&2
    exit 1
    ;;
esac

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

archive="helmfile_${version#v}_${os_name}_${arch}.tar.gz"
url="https://github.com/helmfile/helmfile/releases/download/${version}/${archive}"

curl -fsSL "${url}" -o "${tmp_dir}/${archive}"
tar -xzf "${tmp_dir}/${archive}" -C "${tmp_dir}" helmfile

install_dir="${HELMFILE_INSTALL_DIR:-/usr/local/bin}"
if [ -w "${install_dir}" ]; then
  install -m 0755 "${tmp_dir}/helmfile" "${install_dir}/helmfile"
elif command -v sudo >/dev/null 2>&1; then
  sudo install -m 0755 "${tmp_dir}/helmfile" "${install_dir}/helmfile"
else
  install_dir="${HOME}/.local/bin"
  mkdir -p "${install_dir}"
  install -m 0755 "${tmp_dir}/helmfile" "${install_dir}/helmfile"
  case ":${PATH}:" in
    *":${install_dir}:"*) ;;
    *)
      echo "Installed Helmfile to ${install_dir}; add it to PATH before rerunning make." >&2
      exit 1
      ;;
  esac
fi

helmfile --version
