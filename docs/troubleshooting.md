# Troubleshooting

## VIP does not move

Check Keepalived status and interface name:

```bash
systemctl status keepalived
ip addr show
journalctl -u keepalived -n 100
```

## Kubernetes API unreachable

```bash
systemctl status haproxy
ss -lntp | grep -E '6443|9345'
curl -k https://<vip>:6443/readyz
```

## Images cannot be pulled

Set `global.imageRegistry`, configure `imagePullSecrets`, or preload images:

```bash
scripts/images/export-from-host.sh
scripts/images/preload-rke2.sh dist/images
```

## CloudNativePG or ECK resources not recognized

Install operators:

```bash
make install-operators
kubectl get crd | grep -E 'postgresql.cnpg|elastic'
```
