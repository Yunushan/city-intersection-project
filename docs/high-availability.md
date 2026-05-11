# High Availability Guide

## Default RKE2 topology

The default production topology is three RKE2 server nodes. The first three inventory hosts are both Kubernetes servers and load-balancer participants:

- `cip-cp-01` / `192.0.2.11`
- `cip-cp-02` / `192.0.2.12`
- `cip-cp-03` / `192.0.2.13`
- VIP: `192.0.2.10`

HAProxy exposes:

- `6443` Kubernetes API
- `9345` RKE2 registration endpoint

Keepalived owns the virtual IP. Chrony runs on every node to reduce clock drift issues for certificates, logs, distributed databases, and Kafka.

## Stateful services

- PostgreSQL/PostGIS/TimescaleDB use CloudNativePG custom resources by default.
- Elasticsearch/Kibana use ECK custom resources by default.
- Kafka/ZooKeeper render as StatefulSets to preserve the supplied Confluent images.
- Redis renders as a Redis + Sentinel scaffold.

Before production, choose storage classes and backup policies in `values.yaml`.

## Failure checks

```bash
kubectl get nodes -o wide
kubectl -n urban-platform get pod -o wide
kubectl -n urban-platform get pdb,hpa
kubectl -n urban-platform get clusters.postgresql.cnpg.io
```

Test VIP failover by stopping HAProxy or Keepalived on the current master and confirming the VIP moves to another node.
