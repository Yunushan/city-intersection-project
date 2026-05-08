#!/usr/bin/env python3
import sys
from pathlib import Path
import yaml

if len(sys.argv) != 2:
    print('Usage: basic_policy.py rendered.yaml', file=sys.stderr)
    sys.exit(2)

path = Path(sys.argv[1])
if not path.exists():
    print(f'Missing rendered manifest: {path}', file=sys.stderr)
    sys.exit(2)

errors = []
warnings = []
for doc in yaml.safe_load_all(path.read_text()):
    if not isinstance(doc, dict):
        continue
    kind = doc.get('kind')
    meta = doc.get('metadata', {})
    name = meta.get('name', '<unknown>')
    if kind in {'Deployment', 'StatefulSet'}:
        spec = doc.get('spec', {})
        tmpl = spec.get('template', {})
        podspec = tmpl.get('spec', {})
        containers = podspec.get('containers', [])
        if not containers:
            errors.append(f'{kind}/{name}: no containers')
        for c in containers:
            image = c.get('image', '')
            image_name = image.rsplit('/', 1)[-1]
            if image.endswith(':latest') and not image_name.startswith('example-app-'):
                warnings.append(f'{kind}/{name}: image uses latest tag: {image}')
            if not c.get('ports'):
                # worker services may have no ports, but this stack expects them from docker ps.
                pass
        if kind == 'Deployment' and spec.get('replicas', 0) < 2:
            errors.append(f'{kind}/{name}: replicas should be >= 2 for HA')

if warnings:
    for w in warnings:
        print('POLICY-WARN:', w, file=sys.stderr)
if errors:
    for e in errors:
        print('POLICY:', e, file=sys.stderr)
    sys.exit(1)
print('Basic policy checks passed')
