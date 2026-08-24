# Illithid Codex Log

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
