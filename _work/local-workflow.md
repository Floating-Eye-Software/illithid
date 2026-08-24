# Illithid Local Workflow

This file supplements `_work/repo-workflow.md` with service-specific routing
and production-safety rules.

## Service Authority

- Keep public-service integration plans, tasks, release manifests, migration
  criteria, multi-version dispatch decisions, and service acceptance here.
- Reference exact implementation commits from `dgamelaunch` and `nethack`;
  do not duplicate their source history or add FLEY workflow files to them.
- Keep Nexus future-engine work and NLE5 adapter work in their own workflows.

## Site Operations

Coordinate infrastructure changes with `site-ops`. Illithid may define the
service outcome and acceptance criteria, while `site-ops` owns host changes,
backups and restore operations, monitoring, DNS/TLS, SSH endpoints, and public
web deployment.

## Production Changes

Repository work does not authorize production mutation. Before any production
change, identify the exact host, service, data surface, rollback path, backup
state, and approval. Preserve legacy saves and runtimes until explicit
retirement approval is recorded.

## Verification

Run this after changing repository workflow surfaces:

```sh
make check-work
```

Use `make repo-tour` to inspect organization-level adoption and workflow drift.
Implementation and production verification commands belong in the applicable
task or plan and must be proportionate to the risk.
