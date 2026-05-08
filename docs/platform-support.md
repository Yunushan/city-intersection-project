# Platform Support

## Default

- Cluster engine: RKE2
- Node count: 3
- Node OS: Ubuntu 24.04
- Webserver: nginx
- Database profile: PostgreSQL/PostGIS/TimescaleDB via CloudNativePG
- Observability profile: Elasticsearch/Kibana/Logstash with Grafana option

## Supported profiles

| Profile | Production target | Notes |
|---|---:|---|
| Ubuntu 24.04 | Yes | Default Linux production node OS |
| Debian | Yes | Linux node profile |
| RHEL / Rocky Linux / AlmaLinux | Yes | Linux node profile |
| CentOS / CentOS Stream | Compatibility | Validate lifecycle and vendor support before production |
| FreeBSD / NetBSD / OpenBSD | Raw/LB/workstation | Raw scripts, HAProxy/relayd examples, not default Kubernetes worker profile |
| macOS | Workstation/dev | Helm/kubectl/Ansible tooling, Docker Desktop profile |
| Windows / Windows Server | Workstation/dev/Windows nodes | PowerShell helper, Docker Desktop/WSL2, Windows-container node notes |

Kubernetes Linux workloads should be scheduled on Linux nodes. Windows nodes require Windows-compatible container images. BSD/macOS profiles are included for operator, raw, and compatibility workflows.
