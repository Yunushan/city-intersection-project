# Quick Start

```bash
cp inventories/example/hosts.yml inventories/prod/hosts.yml
cp .env.example .env
make validate
make bootstrap ENV=prod ENGINE=rke2
make install-cluster ENV=prod ENGINE=rke2
make install-operators
make deploy ENV=prod
```

For a single-machine compatibility run:

```bash
make docker-up
```
