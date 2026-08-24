# AGENTS.md

Instructions for Codex and other filesystem-native agents working in this
repository.

## Project Identity

Illithid is the FLEY workflow and service-integration authority for the public
NetHack service running dgamelaunch and the Floating Eye NetHack variant.

This repository owns service-level plans, tasks, release coordination,
migration acceptance, and verification evidence. It does not vendor the
upstream-derived source repositories merely to exercise workflow authority.

## Start Here

Before making code or content changes, read:

- `_work/README.md`
- `_work/repo-workflow.md`
- `_work/local-workflow.md`
- `_work/plans/plans.csv`
- `_work/tasks.csv`
- the relevant `_work/plans/*.md` file

Check `git status` before editing and preserve unrelated user changes.

## Authority And Routing

- Illithid owns public-service integration work spanning dgamelaunch and the
  Floating Eye NetHack runtime.
- Illithid owns the public landing-page content and source under
  `site/illithid.floatingeye.net/`.
- Implementation commits remain in the applicable `dgamelaunch` or `nethack`
  source repository and are referenced from Illithid plans and tasks.
- Do not add FLEY `_work/` or `AGENTS.md` files to those upstream-derived
  source repositories.
- Route host provisioning, operating-system controls, DNS, TLS, SSH endpoint
  operations, backups, monitoring, public-web deployment, and live-site
  verification to `site-ops`.
- Route future Nexus engine/product work to `nexus` and learning-environment
  adapter work to `nle5`.
- Route organization topology and portfolio coordination to `fley-org`.
- Route controlled SOP, WI, CAPA, Change Control, and other controlled QMS
  work to `fley-qms`.

## Production Safety

- Treat production inspection as read-only unless the user explicitly
  authorizes a mutation.
- Do not restart services, deploy releases, change accounts, alter DNS/TLS,
  modify saves, or change production configuration without explicit authority.
- Never commit credentials, account databases, saves, locks, private rc files,
  raw administrative exports, private backups, or secrets.
- Use public-safe manifests, redacted observations, checksums, procedures, and
  verification receipts when durable evidence is needed.
- Preserve exact legacy binaries, data, configuration, and player state until
  migration and rollback evidence has been reviewed.

## Workflow

- Keep executable work in `_work/plans/plans.csv` and `_work/tasks.csv`.
- Keep expanded task context in `_work/tasks.md` when needed.
- Record durable session findings in `_work/codex-log.md`.
- Put Illithid-specific additions in `_work/local-workflow.md`; do not edit the
  canonical `_work/repo-workflow.md` copy independently.
- Run `make check-work` after changing workflow surfaces.
- Use `make repo-tour` when organization-level adoption or workflow drift must
  be inspected.
- Do not close a plan without explicit maintainer approval.
- Do not commit unless the user explicitly asks for a commit.

When the user says `wrap up`, `finish the session`, or equivalent, perform the
workflow maintenance described in `_work/repo-workflow.md` and summarize
changes, verification, blockers, and uncommitted work.
