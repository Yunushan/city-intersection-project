SHELL := /usr/bin/env bash
PROJECT ?= city-intersection-project
ENV ?= prod
ENGINE ?= rke2
WEB ?= nginx
DB ?= postgresql
OBS ?= elasticsearch
NAMESPACE ?= city-intersection
VALUES ?= helm/city-intersection-platform/values.yaml
INVENTORY ?= inventories/$(ENV)/hosts.yml

.PHONY: help validate configure bootstrap install-cluster install-operators deploy deploy-dry-run status docker-up docker-down docker-status policy clean

help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage: make <target> [ENV=prod ENGINE=rke2 WEB=nginx DB=postgresql OBS=elasticsearch]\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  %-22s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

validate: ## Validate YAML, Helm chart structure, scripts, and config catalogs.
	python3 scripts/validate.py

configure: ## Update selected runtime defaults in Helm values.
	python3 scripts/configure.py --engine $(ENGINE) --webserver $(WEB) --database $(DB) --observability $(OBS) --values $(VALUES)

bootstrap: ## Bootstrap nodes with common packages, Chrony, HAProxy, Keepalived.
	ansible-playbook -i $(INVENTORY) ansible/playbooks/bootstrap.yml -e cluster_engine=$(ENGINE)

install-cluster: ## Install selected cluster engine: rke2, k3s, microk8s, docker, or raw.
	ansible-playbook -i $(INVENTORY) ansible/playbooks/install-cluster.yml -e cluster_engine=$(ENGINE)

install-operators: ## Install optional operators/charts needed for HA data and observability profiles.
	helmfile -f deploy/helmfile.yaml apply

deploy-dry-run: ## Render the Helm chart without applying it.
	helm template $(PROJECT) helm/city-intersection-platform --namespace $(NAMESPACE) -f $(VALUES) --dry-run > rendered.yaml

policy: ## Run policy checks against rendered manifests.
	mkdir -p reports
	helm template $(PROJECT) helm/city-intersection-platform --namespace $(NAMESPACE) -f $(VALUES) > reports/rendered.yaml
	python3 tests/policy/basic_policy.py reports/rendered.yaml

deploy: ## Deploy/upgrade the HA application platform.
	helm upgrade --install $(PROJECT) helm/city-intersection-platform --namespace $(NAMESPACE) --create-namespace -f $(VALUES)

status: ## Show cluster and workload status.
	scripts/health/status.sh $(NAMESPACE)

docker-up: ## Start Docker fallback profile. Use Docker Swarm for replicas.
	docker compose -f compose/docker-compose.ha.yml up -d

docker-down: ## Stop Docker fallback profile.
	docker compose -f compose/docker-compose.ha.yml down

docker-status: ## Show Docker fallback profile status.
	docker compose -f compose/docker-compose.ha.yml ps

clean: ## Remove generated local files.
	rm -rf rendered.yaml reports dist
