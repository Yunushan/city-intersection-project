# Release Guide

1. Update `CHANGELOG.md`.
2. Run `make validate` and `make policy`.
3. Render manifests with `make deploy-dry-run`.
4. Tag the release:

```bash
git tag -a v0.1.0 -m "city-intersection-project v0.1.0"
git push origin v0.1.0
```

GitHub Actions packages the Helm chart on tags matching `v*.*.*`.
