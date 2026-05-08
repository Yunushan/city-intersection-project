# Database Switching

Default data profile is PostgreSQL-compatible because the supplied running stack uses PostgreSQL, PostGIS, and TimescaleDB images.

Switch in config:

```bash
python3 scripts/configure.py --database postgresql
python3 scripts/configure.py --database cockroachdb
python3 scripts/configure.py --database mysql
python3 scripts/configure.py --database opensearch
python3 scripts/configure.py --database clickhouse
```

Database families are cataloged in `config/databases.catalog.yaml` and are intentionally provider-neutral. For non-PostgreSQL engines, choose one of:

1. Operator-backed HA inside Kubernetes.
2. Managed cloud/on-prem database service.
3. External database endpoint stored in Kubernetes Secret.
4. Raw profile for legacy systems.

Do not assume a container replica count alone creates database HA. Use a proper operator, replication topology, or managed service.
