# Docker fallback profile

`docker-compose.ha.yml` is a compatibility profile for development, demos, and migration testing. It is not the preferred production HA path; use the RKE2/Kubernetes profile for enterprise production.

```bash
make docker-up
make docker-status
make docker-down
```

For real Docker HA, initialize Docker Swarm and use `docker stack deploy`:

```bash
docker swarm init
REGISTRY_PREFIX=registry.example.com/city-intersection docker stack deploy -c docker-compose.ha.yml city-intersection
```
