# Changelog

## v0.4.0 — 2026-11-12

- BREAKING: require OCI provider >= 9.12.1, < 10.0.0 and OpenTofu >= 1.11.0.
- Preserve previous local module/example work in separate commits.
- Update embedded examples and dependency pins; add plan-only mocked test coverage.
- Preserve the module input/output contract and resource addresses.


The virtual-node example mocks the IAM module boundary to avoid an OpenTofu 1.11.6 unknown nested-block crash. The KMS example also supplies Vault module outputs. Policy and Vault are planned independently in their own suites; these two composition tests do not validate IAM permissions or end-to-end Vault behavior.
