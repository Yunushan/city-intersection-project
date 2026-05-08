# Security Hardening

- Keep real secrets out of Git.
- Keep private data, customer data, internal inventories, and confidential disclosure material out of Git.
- Use `example.com`, `.example` names, and RFC 5737 documentation IP ranges in samples.
- Use SOPS/age, Sealed Secrets, External Secrets, Vault, or cloud secret managers.
- Rotate bootstrap tokens after cluster creation.
- Use private registries and imagePullSecrets.
- Enable TLS for ingress and internal services where required.
- Set NetworkPolicies to least privilege.
- Run `make policy` and CI scans before merge.
- Avoid `latest` tags for third-party production images unless deliberately accepted.
- Restrict Kubernetes API and VIP access to management networks.
