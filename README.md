<h1 align="center">City Intersection Project</h1>

<p align="center">
  <strong>Enterprise-first HA smart-city intersection platform workspace with 3-node RKE2, live service deployment, web gateway, databases, observability, and multi-platform installation scaffolding.</strong>
</p>

<p align="center">
  <img alt="build" src="https://img.shields.io/badge/build-ready-brightgreen">
  <img alt="release" src="https://img.shields.io/badge/release-v0.1.0-blue">
  <img alt="license" src="https://img.shields.io/badge/license-MIT-0ea5e9">
  <img alt="nodes" src="https://img.shields.io/badge/default%20nodes-3-success">
  <img alt="cluster" src="https://img.shields.io/badge/default%20cluster-RKE2-0f766e">
  <img alt="os" src="https://img.shields.io/badge/default%20OS-Ubuntu%2024.04-e95420">
</p>

<p align="center">
  <img alt="runtime" src="https://img.shields.io/badge/runtime-RKE2%20%7C%20K3s%20%7C%20MicroK8s%20%7C%20Docker%20%7C%20Raw-111827">
  <img alt="ha" src="https://img.shields.io/badge/HA-HAProxy%20%7C%20Keepalived%20%7C%20Chrony-f59e0b">
  <img alt="web" src="https://img.shields.io/badge/web-nginx%20default%20%7C%20Apache%20HTTPD%20%7C%20Tomcat%20%7C%20Traefik-0891b2">
  <img alt="observability" src="https://img.shields.io/badge/observability-Grafana%20%7C%20Loki%20%7C%20Elastic%20%7C%20OpenSearch%20%7C%20Graylog%20%7C%20ClickHouse-7c3aed">
</p>

<p align="center">
  <a href="#quick-start">Quick Start</a> •
  <a href="#what-this-repository-deploys">Workloads</a> •
  <a href="#changeable-defaults">Change Defaults</a> •
  <a href="docs/high-availability.md">HA Guide</a> •
  <a href="docs/platform-support.md">Platform Support</a> •
  <a href="docs/repository-setup.md">GitHub/GitLab</a> •
  <a href="docs/release-guide.md">Release Guide</a> •
  <a href="LICENSE">License</a>
</p>

---

A desktop/operator-first and production-ready deployment workspace for the **city-intersection-project** stack. It is centered on a default **3-node RKE2 Kubernetes cluster** running on **Ubuntu 24.04**, with HAProxy/Keepalived for the control-plane virtual IP, Chrony for time sync, Helm-based application deployment, Docker Swarm/Compose fallback, raw-install scaffolding, and GitHub/GitLab private-repository readiness.

The project is designed so defaults can be changed from configuration instead of editing templates: cluster engine, web server, database family, observability backend, registry, replica counts, hostnames, storage class, TLS, image tags, and platform profile all live under `config/` and `helm/city-intersection-platform/values.yaml`.

## Quick Start

```bash
git init city-intersection-project
cd city-intersection-project
# copy this repository content into the directory, or unzip the delivered artifact here

cp inventories/example/hosts.yml inventories/prod/hosts.yml
cp .env.example .env
$EDITOR inventories/prod/hosts.yml .env

make validate
make bootstrap ENV=prod ENGINE=rke2
make install-cluster ENV=prod ENGINE=rke2
make install-operators
make deploy ENV=prod
make status
```

Local Docker profile:

```bash
make docker-up
make docker-status
```

Private GitHub/GitLab setup:

```bash
scripts/repo/init-local-git.sh
scripts/repo/create-github-repo.sh        # requires GH_TOKEN or gh auth login
scripts/repo/create-gitlab-repo.sh        # requires GITLAB_TOKEN; defaults to visibility=private
scripts/repo/push-all-remotes.sh
```

## What this repository deploys

By default the Kubernetes profile deploys:

| Layer | Default | HA behavior |
|---|---|---|
| Cluster | RKE2 | 3 server nodes, fixed VIP, etcd quorum |
| Control-plane access | HAProxy + Keepalived | Virtual IP failover and TCP load balancing for `6443` and `9345` |
| Time sync | Chrony | Installed on every node |
| Web gateway | nginx `1.18` | 3 replicas, swappable with Apache HTTPD, Tomcat, or Traefik |
| Application services | Sanitized `example-app-*` images | 3 replicas, PDB, HPA, anti-affinity/topology spread |
| Kafka | `confluentinc/cp-kafka:7.5.0` + `confluentinc/cp-zookeeper:latest` | 3 brokers, 3 ZooKeeper pods, Kafka UI |
| Redis | `redis:6.2` | 3 Redis pods + Sentinel scaffolding |
| PostgreSQL/PostGIS/TimescaleDB | `postgres:16.2`, `postgis/postgis:16-3.4`, `timescale/timescaledb:latest-pg16` | CloudNativePG custom resources with 3 instances per database |
| Observability | Elasticsearch/Kibana/Logstash `8.12.0`, Grafana option | ECK custom resources for Elasticsearch/Kibana, Logstash replicas |
| Optional observability | Grafana Loki, OpenSearch, Graylog, ClickHouse | Switchable by Helmfile values/profile |
| Agent monitoring | `zabbix/zabbix-agent2:latest` | 3 replicas |

The image and port inventory is stored in [`config/services.catalog.yaml`](config/services.catalog.yaml). Helm values are stored in [`helm/city-intersection-platform/values.yaml`](helm/city-intersection-platform/values.yaml).

## Changeable defaults

```bash
# Change deployment flavor without template edits
python3 scripts/configure.py --engine k3s --webserver traefik --observability loki
python3 scripts/configure.py --engine microk8s --webserver apache-httpd
python3 scripts/configure.py --database cockroachdb
python3 scripts/configure.py --database postgresql --webserver nginx --observability elasticsearch

# Or use Makefile wrappers
make configure ENGINE=k3s WEB=traefik DB=postgresql OBS=loki
make deploy ENV=prod
```

Supported cluster profiles are defined in [`config/cluster-profiles.yaml`](config/cluster-profiles.yaml):

- `rke2` default production Kubernetes
- `k3s` lightweight/edge Kubernetes
- `microk8s` Canonical MicroK8s profile
- `docker` Docker Compose/Swarm fallback
- `raw` non-container service-install scaffolding

Supported web server profiles are defined in [`config/webservers.yaml`](config/webservers.yaml): `nginx`, `apache-httpd`, `apache-tomcat`, and `traefik`.

Supported database profiles are defined in [`config/databases.catalog.yaml`](config/databases.catalog.yaml), aligned with the database family list from endoflife.date. PostgreSQL is the default because your current stack already includes PostgreSQL, PostGIS, and TimescaleDB images.

## Repository layout

```text
.
├── ansible/                         # Node bootstrap, HAProxy/Keepalived/Chrony, RKE2/K3s/MicroK8s/Docker/raw roles
├── config/                          # Cluster, services, database, webserver, observability, OS profiles
├── deploy/                          # Helmfile, Argo CD application, kustomize entrypoints
├── docs/                            # Architecture, HA, platform, operations, release, security, troubleshooting
├── helm/city-intersection-platform/ # Main Helm chart for the HA application platform
├── inventories/                     # Example 3-node inventory, production copy target
├── platform/                        # Linux/BSD/macOS/Windows helper scripts and raw templates
├── scripts/                         # Repo setup, image preload/push, configuration, health checks
├── tests/                           # Static checks and policy tests
├── .github/workflows/               # GitHub Actions CI/CD
└── .gitlab-ci.yml                   # GitLab private repo CI/CD
```

## Production checklist

1. Replace example IP addresses in `inventories/prod/hosts.yml`.
2. Set a real VIP and DNS record in `.env` and `helm/.../values.yaml`.
3. Push local/private images to a registry or preload them onto all RKE2 nodes with `scripts/images/preload-rke2.sh`.
4. Enable TLS and cert-manager in `deploy/helmfile.yaml`.
5. Put secrets in SOPS/External Secrets/Sealed Secrets. Do not commit database passwords.
6. Choose storage classes for CloudNativePG, Kafka, Redis, Elasticsearch, and ClickHouse/OpenSearch if enabled.
7. Run `make validate`, `make policy`, and `make deploy-dry-run` before production deploy.

## License

This project is released under the MIT License. See [`LICENSE`](LICENSE).
