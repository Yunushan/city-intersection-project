#!/usr/bin/env sh
set -eu
pkg install -y bash curl jq git haproxy py311-ansible
sysrc haproxy_enable=YES
