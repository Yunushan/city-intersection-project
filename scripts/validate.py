#!/usr/bin/env python3
from pathlib import Path
import sys
import yaml

ROOT = Path(__file__).resolve().parents[1]
YAML_DIRS = ['config', 'inventories', 'ansible/playbooks', 'compose']
REQUIRED = [
    'README.md', 'LICENSE', '.github/workflows/ci.yml', '.gitlab-ci.yml',
    'helm/city-intersection-platform/Chart.yaml', 'helm/city-intersection-platform/values.yaml',
    'config/services.catalog.yaml', 'config/cluster-profiles.yaml'
]

def check_yaml(path):
    with open(path, 'r', encoding='utf-8') as f:
        yaml.safe_load(f)

errors = []
for rel in REQUIRED:
    if not (ROOT / rel).exists():
        errors.append(f'Missing required file: {rel}')

for d in YAML_DIRS:
    for path in (ROOT / d).rglob('*'):
        if path.suffix in {'.yaml', '.yml'}:
            try:
                check_yaml(path)
            except Exception as exc:
                errors.append(f'YAML error in {path.relative_to(ROOT)}: {exc}')

values = yaml.safe_load((ROOT / 'helm/city-intersection-platform/values.yaml').read_text())
if values['global']['cluster']['engine'] != 'rke2':
    errors.append('Default engine must be rke2')
if values['global']['cluster']['nodes'] != 3:
    errors.append('Default cluster node count must be 3')
if values['webserver']['provider'] != 'nginx':
    errors.append('Default webserver must be nginx')
if len(values.get('workloads', {})) < 30:
    errors.append('Expected application workload catalog to contain at least 30 services')

if errors:
    for err in errors:
        print(f'ERROR: {err}', file=sys.stderr)
    sys.exit(1)
print('Validation passed')
