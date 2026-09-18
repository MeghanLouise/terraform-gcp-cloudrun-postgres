# Terraform: GCP Cloud Run + Postgres + CI/CD

A reusable, documented Terraform module that spins up a Cloud Run service, a Cloud SQL (Postgres) instance, and a GitHub Actions pipeline in a single `terraform apply`.

## Why

Most starter Terraform examples stop at one resource. This module wires together what a small production service actually needs: compute, a database, and the CI/CD to deploy it safely, so it can be dropped into a new project and be useful on day one.

## Status

Early build, following the roadmap below.

## Planned

- [ ] Cloud Run service resource + variables
- [ ] Cloud SQL (Postgres) instance + private networking
- [ ] GitHub Actions: `terraform plan` on pull requests, `terraform apply` on merge to main
- [ ] Worked example in `examples/`
- [ ] Architecture diagram in the README

## Stack

Terraform, GCP Cloud Run, Cloud SQL, GitHub Actions

## License

MIT, see [LICENSE](./LICENSE).
