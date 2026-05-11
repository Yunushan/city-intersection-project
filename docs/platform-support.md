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
| Ubuntu | Yes | Major LTS versions 22.04, 24.04, and 26.04 |
| Debian | Yes | Major versions 11, 12, and 13 |
| RHEL | Yes | Major versions 7, 8, 9, and 10 |
| Rocky Linux | Yes | Major versions 7, 8, 9, and 10 |
| AlmaLinux | Yes | Major versions 7, 8, 9, and 10 |
| CentOS Stream | Yes | Major versions 9 and 10 |
| CentOS Linux | Compatibility | Legacy CentOS Linux 7/8 only; prefer RHEL, Rocky, AlmaLinux, or CentOS Stream |
| FreeBSD / NetBSD / OpenBSD | Raw/LB/workstation | Raw scripts, HAProxy/relayd examples, not default Kubernetes worker profile |
| macOS | Workstation/dev | Helm/kubectl/Ansible tooling, Docker Desktop profile |
| Windows / Windows Server | Workstation/dev/Windows nodes | PowerShell helper, Docker Desktop/WSL2, Windows-container node notes |

## Debian-Family Support Contract

The RKE2, K3s, MicroK8s, Docker, and raw Linux profiles declare full Debian-family support for these production node OS identifiers:

- `ubuntu-22.04`, `ubuntu-24.04`, `ubuntu-26.04`
- `debian-11`, `debian-12`, `debian-13`

Ansible preflight validates Debian-family cluster nodes before bootstrap. Ubuntu targets must report version 22.04, 24.04, or 26.04. Debian targets must report major version 11, 12, or 13.

## RHEL-Family Support Contract

The RKE2, K3s, Docker, and raw Linux profiles declare full RedHat-family support for these production node OS identifiers:

- `rhel-7`, `rhel-8`, `rhel-9`, `rhel-10`
- `rocky-linux-7`, `rocky-linux-8`, `rocky-linux-9`, `rocky-linux-10`
- `alma-linux-7`, `alma-linux-8`, `alma-linux-9`, `alma-linux-10`
- `centos-stream-9`, `centos-stream-10`

Ansible preflight validates RedHat-family cluster nodes before bootstrap. RHEL, Rocky Linux, and AlmaLinux must report major version 7, 8, 9, or 10. CentOS targets must be CentOS Stream major version 9 or 10.

Kubernetes Linux workloads should be scheduled on Linux nodes. Windows nodes require Windows-compatible container images. BSD/macOS profiles are included for operator, raw, and compatibility workflows.
