# Illithid Work Area

This directory is the authoritative FLEY coordination surface for the public
Illithid NetHack service.

## Authority

Illithid owns service-level planning, tasks, cross-component release decisions,
migration acceptance criteria, and verification evidence for work performed
against the upstream-derived `dgamelaunch` and Floating Eye `nethack` source
repositories.

Source changes remain in those source repositories. Host, backup, monitoring,
DNS/TLS, SSH endpoint, and public-web operations remain in `site-ops`.

## Files

- `repo-workflow.md` is the point-of-work copy of the canonical FLEY workflow.
- `local-workflow.md` adds Illithid-specific safety and routing rules.
- `plans/plans.csv` tracks larger service work fronts.
- `plans/*.md` records scope, constraints, acceptance criteria, and status.
- `tasks.csv` tracks concrete executable work.
- `tasks.md` stores expanded task context when needed.
- `codex-log.md` records concise durable session findings.

## Data Boundary

Do not store credentials, account databases, saves, locks, private rc files,
raw ttyrecs containing private information, production backups, host exports,
or secrets here. Retain only public-safe manifests, redacted observations,
checksums, procedures, and verification receipts.

Run `make check-work` after changing workflow surfaces.
