#!/usr/bin/env python3
from pathlib import Path
import yaml
ROOT = Path(__file__).resolve().parents[2]
catalog = yaml.safe_load((ROOT / 'config/services.catalog.yaml').read_text())
seen = []
for item in catalog['images']:
    img = item['image']
    if img not in seen:
        seen.append(img)
for img in seen:
    print(img)
