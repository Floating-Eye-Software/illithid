# Illithid Codex Log

## 2026-08-24 - Dgamelaunch Game Catalog Planning

Created plan `0005-dgamelaunch-game-catalog` to add What Fools These Mortals,
Rogue Clone IV, and a small licensed Z-machine interactive-fiction catalog to
the public dgamelaunch service. The plan uses the maintainer's public
`mlehotay/WhatFools` and `mlehotay/rogue` forks as the initial source lines,
requires a Python 3 port for WhatFools and a supported Linux/ncurses port for
Rogue Clone IV, and compares Frotz with Bocfel before choosing a terminal
Z-machine interpreter.

The plan requires an explicit per-story redistribution license, isolated
per-player and per-game state, ttyrec and watching verification, resource
limits, reproducible packages, staging security/failure tests, and a
backup-gated site-ops deployment. Registered tasks `todo-022` through
`todo-029`. Plan 0005 remains blocked by plan 0001 and its dgamelaunch
integration depends on the common versioned menu work in plan 0004.

Cross-repository review confirmed that Illithid owns game-catalog integration,
`fley-org` owns project/repository identity, and `site-ops` owns the host,
chroot deployment, SSH behavior, backups, monitoring, and production
verification. No sibling repository or production service was changed.

Session wrap-up:

- added `FLOATINGEYE-DOSSIER-PROPOSAL.md` as maintainer-authored exploratory
  input; it remains a proposal and does not create executable workflow tasks;
- updated `AGENTS.md` so future cross-project questions begin with read-only
  inspection of the owning `fley-org` or `site-ops` records;
- the Windows `Zone.Identifier` metadata sidecar was removed before commit;
- plans 0001, 0002, 0004, and 0005 remain open, with plans 0004 and 0005
  blocked by the plan 0001 workflow-boundary work;
- no plan is ready for closure; and
- no sibling repository or production service was changed.

## 2026-08-24 - Floating Eye 3.7 and 5.0 Planning

Created plan `0004-floatingeye-nethack-5` as the source and multi-version
integration work package for the public-service modernization. The plan will
refresh the stale vanilla 3.7 baseline, reconstruct and update the Floating Eye
3.7 line, port every accepted variant change to a pinned official NetHack 5.0
line, and provide explicit dgamelaunch choices for both game versions.

The plan preserves the exact deployed legacy 3.7 runtime for existing saves,
requires disjoint versioned state and artifacts, and treats every patch through
a recorded port/upstream/externalize/retire disposition. It coordinates
production execution with the recovery and security gates in plans 0002 and
0003. Registered tasks `todo-014` through `todo-021` cover baselines, both
source lines, runtime packaging, dgamelaunch integration, staging verification,
controlled deployment, and publication.

The existing local refs showed `floatingeye` 38 commits behind the locally
available vanilla 3.7 ref, not 50, but both refs were stale. Plan 0004 therefore
requires a fetch and refreshed divergence record before implementation.

Session wrap-up:

- `make check-work` passed with four active plans and sixteen active tasks;
- `git diff --check` passed;
- plan 0001 remains in progress with `todo-004`, `todo-006`, `todo-007`, and
  `todo-009` incomplete;
- plan 0004 remains blocked by plan 0001, and its first executable work is
  `todo-014` after the workflow-boundary verification dependency is complete;
- no plan is ready for closure; and
- no production mutation was authorized or performed.

No NetHack source, sibling repository, or production service was changed.

## 2026-08-24 - Floating Eye Variant Inventory

Added `FLOATINGEYE.md` as a descriptive inventory of the NetHack 3.7 variant
used by the Illithid service. It separates gameplay patches, public-service
integration, build and configuration differences, maintainer preferences, and
experimental work that is not merged into the service branch. The inventory
uses `QueerHack` as the canonical name for the historical Queer Characters
patch family, records `consent` and `gender` as former branch names, and
documents the misleading current `gender` and `pethack` refs. It also records
observed commit identifiers for the aggregate, PetHack, gluten-free conduct,
and unmerged stdio window-port work. The NetHackWiki public-server page is
recorded as the service's community-maintained listing.

No source branch, production service, or sibling repository was changed.

## 2026-08-24 - Repository Workflow Adoption

Installed the minimum FLEY repository workflow surface for the public Illithid
NetHack service-integration repository:

- added repository-local agent instructions and routing boundaries;
- copied the canonical FLEY repository workflow;
- added an Illithid local workflow supplement;
- registered plans 0001 and 0002;
- seeded the repository task dashboard from plan 0001;
- added local workflow verification targets and a shared-checker adapter.

Illithid is the workflow authority for the upstream-derived `dgamelaunch` and
Floating Eye `nethack` repositories. Those source repositories remain free of
FLEY `_work/` and `AGENTS.md` surfaces. `site-ops` retains host and public-web
operations authority.

This workflow installation does not authorize production access or mutation.

## 2026-08-24 - Security Modernization Planning

Created plan `0003-illithid-security-modernization` to establish and
continuously verify a modern security baseline for the public Illithid service.
The plan includes:

- remediation of the non-responsive `illithid.floatingeye.net` HTTPS endpoint
  with automated certificate renewal, modern TLS, redirects, and monitoring;
- a threat model and explicitly authorized Rules of Engagement;
- low-impact external testing plus authenticated host, SSH, Apache,
  dgamelaunch, dependency, backup, logging, and cloud-control assessment;
- production safety boundaries excluding denial of service, brute force,
  destructive exploitation, persistence, and access to private player data;
- a tailored CIS Level 1 Server baseline informed by NIST CSF 2.0, NIST SP
  800-115, OWASP WSTG, current Ubuntu guidance, and CISA KEV prioritization;
- blue-green host replacement using the newest supported Ubuntu LTS that passes
  legacy-runtime and service compatibility testing;
- remediation, retesting, detection and recovery exercises, residual-risk
  review, and recurring security assurance; and
- explicit coordination with `site-ops`, which remains authoritative for the
  host, operating system, firewall, DNS/TLS, SSH endpoint, backups, monitoring,
  public-web deployment, and protected operational evidence.

Registered the new plan as `ready`, priority P0, and added tasks `todo-010`
through `todo-013` for security-scope approval, assessment review,
post-hardening verification, and service-owner acceptance. The plan and task
dashboards passed `make check-work`. No production assessment, deployment, or
configuration change was performed in this planning session.

## 2026-08-24 - Landing Page Ownership And Deployment

Moved the Illithid landing-page source from `site-ops` into the service
repository at `site/illithid.floatingeye.net/`. Illithid now owns the public
content and service claims, while `site-ops` retains the deployment registry,
backup gate, production target, transport, TLS, and live verification.

The source move and authority updates were committed as `d29cdd0`. The final
landing-page content and card presentation were committed as `10b73ae`; the
four repository cards use the FLEY Directory structure of category metadata,
black title, description, and link. The unused JPEG was removed, and the
Floating Eye Software card points to the GitHub organization.

Site-ops commit `b5ae4c0` changed the `illithid-landing` mapping to consume
`../illithid/site/illithid.floatingeye.net/` while continuing to deploy to
`/var/www/html/`. Site-ops then captured the complete production root and
backup receipt under
`/home/mlehotay/backups/site-ops/illithid-landing-20260824/`, deployed Illithid
commit `10b73ae`, and recorded the deployment as site-ops commit `ca1345f`.

Live HTTP verification returned 200 and matched the committed source hashes
for the homepage, stylesheet, robots file, PNG hero image, and favicon. The
obsolete JPEG was removed from production after its exact path was confirmed
unreferenced and backed up; it now returns 404. HTTPS still timed out after ten
seconds, consistent with the open TLS problem addressed by plan `0003`.
