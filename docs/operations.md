# Operations

## Deploy

```bash
make validate
make install-operators
make deploy
```

## Upgrade image tags

Edit `helm/city-intersection-platform/values.yaml` or use Renovate/CI to propose changes.

## Backup

Recommended before production:

- CloudNativePG scheduled backups to S3-compatible storage.
- Elasticsearch snapshots to S3-compatible storage.
- Kafka topic backup or MirrorMaker/replication strategy.
- Redis RDB/AOF persistence and backup.
- GitOps repository backup.

## Logs

Default pipeline: Logstash -> Elasticsearch -> Kibana. Optional pipelines are configured in `config/observability.yaml`.

## Rollback

```bash
helm history city-intersection-project -n city-intersection
helm rollback city-intersection-project <REVISION> -n city-intersection
```
