# city-intersection-platform Helm chart

This chart renders the default HA application stack for `city-intersection-project`.

## Common changes

```bash
# Render only
helm template city-intersection-project . -n city-intersection -f values.yaml

# Install/upgrade
helm upgrade --install city-intersection-project . -n city-intersection --create-namespace -f values.yaml
```

Switches are handled in `values.yaml`:

- `global.cluster.engine`: `rke2`, `k3s`, `microk8s`, `docker`, `raw`
- `webserver.provider`: `nginx`, `apache-httpd`, `apache-tomcat`, `traefik`
- `databases.provider`: `cloudnative-pg` by default; use catalog profiles for alternatives
- `observability.profile`: `elasticsearch`, `loki`, `opensearch`, `graylog`, `clickhouse`

CloudNativePG and ECK CRs require operators. Install them with `make install-operators`.
