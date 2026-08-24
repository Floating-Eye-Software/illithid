# Illithid Security Modernization And Assurance Plan

**Status:** Ready  
**Prepared:** 2026-08-24  
**Service:** `illithid` / `159.203.19.73` / `ssh nethack@floatingeye.net` / `illithid.floatingeye.net`  
**Purpose:** Establish, implement, and continuously verify a modern security baseline for the public Illithid service, including working HTTPS and a bounded security assessment.

## 1. Outcome

Illithid will operate as a deliberately exposed public game service rather than
an organically accumulated server. The target is a current, supportable,
recoverable, least-privilege platform whose externally reachable behavior is
known and tested.

The completed outcome includes:

- a current supported Ubuntu LTS selected after staging compatibility tests;
- a minimal documented network surface protected at both cloud and host layers;
- modern HTTPS for `illithid.floatingeye.net`, with automated certificate
  renewal and monitored expiry;
- strict separation between public dgamelaunch access and privileged operator
  administration;
- patched, pinned, inventoried, and minimally privileged software;
- protected player accounts, saves, locks, bones, configuration, ttyrecs, and
  service records;
- encrypted off-host backups and a demonstrated restore;
- useful security logging, alerting, incident response, and recovery runbooks;
- a documented external and authenticated assessment, followed by remediation
  and an independent or clean-room retest where practical; and
- a recurring maintenance cadence so the baseline does not decay.

“State of the art” is not treated as a permanent certification or a claim that
the service is invulnerable. For this plan it means a current risk-based target,
measured against maintained platform guidance and recognized security testing
methods, with explicit exceptions and recurring reassessment.

## 2. Authority And Coordination

Illithid owns:

- the service threat model and security outcomes;
- dgamelaunch and game-runtime security requirements;
- public-service availability and compatibility acceptance;
- security exceptions that affect player-facing behavior; and
- the final service-level Verification of Effectiveness and closure decision.

`site-ops` owns:

- the DigitalOcean host and cloud firewall;
- operating-system and host controls;
- DNS, TLS, SSH endpoint operations, Apache, backups, monitoring, and incident
  operations;
- public-web deployment and live verification; and
- protected operational evidence that must not be committed here.

Implementation changes to dgamelaunch or NetHack remain in their respective
source repositories and are referenced here by exact commit. Controlled QMS
procedures or formal risk records, if required, belong in `fley-qms`.

This plan defines the coordinated service outcome. It does not itself authorize
a production scan, package change, restart, firewall change, DNS/TLS change,
credential change, deployment, or exploit attempt. Each production execution
record must identify scope, owner, approval, backup state, rollback, and stop
conditions.

## 3. Current Risk Context

The currently documented host is Ubuntu 22.04.5 LTS and has accumulated pending
updates and a required reboot. It exposes a public SSH service in which the
`nethack` and `rogue` accounts intentionally enter dgamelaunch, and it serves an
Apache landing page over HTTP.

Known concerns requiring fresh verification include:

- `https://illithid.floatingeye.net/` times out and no port-443 virtual host is
  documented, even though source metadata declares an HTTPS canonical URL;
- public game accounts use unusual SSH authentication behavior that is
  necessary for anonymous game entry but must be tightly contained;
- the full set of listening services, packages, scheduled jobs, privileged
  paths, firewall layers, and administrative accounts is not current;
- the exact dgamelaunch/chroot trust boundaries and filesystem permissions need
  adversarial review;
- security-update coverage, backup completeness, restore capability, log
  retention, and detection coverage need evidence; and
- active legacy games and player state make an untested in-place hardening or
  OS upgrade unsafe.

The security program must protect confidentiality and integrity without making
legacy saves unplayable or turning availability testing into a production
outage.

## 4. Security Baseline

The baseline is tailored from:

- NIST Cybersecurity Framework 2.0 for governance and the Govern, Identify,
  Protect, Detect, Respond, and Recover outcomes;
- a tailored CIS Level 1 Server profile audited with Ubuntu Security Guide
  where supported; benchmark exceptions must be justified rather than hidden;
- Canonical's current Ubuntu security, update, AppArmor, firewall, and supported
  release guidance;
- NIST SP 800-115 for assessment planning, execution, analysis, and
  post-testing activity;
- the stable OWASP Web Security Testing Guide for the public web surface;
- CISA's Known Exploited Vulnerabilities catalog as an urgent remediation
  input; and
- a maintained modern/intermediate server-side TLS profile, applied only after
  compatibility testing.

Compliance-tool output is evidence, not the objective. A control may be
tailored when Illithid's public game function genuinely requires it, but the
exception must record the threat, compensating control, owner, and review date.

### Target controls

| Area | Required target state |
| --- | --- |
| Platform | Minimal cloud image on the newest supported Ubuntu LTS that passes the complete staging compatibility matrix; supported repositories only; unused packages and services removed. |
| Updates | Security updates applied automatically on a defined schedule; pending reboots monitored; emergency path for internet-exposed and known-exploited vulnerabilities; staged compatibility checks for dgamelaunch and game runtimes. |
| Cloud account | MFA, least-privilege operator access, protected recovery methods, reviewed API tokens, and auditable changes. |
| Network | Default-deny DigitalOcean and host firewalls; only explicitly justified ports exposed; listeners reconciled to firewall rules and DNS. |
| Administration | Named operator accounts, key-only authentication, no direct root login, least-privilege `sudo`, reviewed keys, and preferably source-restricted or private-network administrative access. |
| Public SSH game access | Public game accounts cannot forward, tunnel, obtain a general shell, modify SSH environment, or escape the intended dgamelaunch path; effective per-user SSH configuration and chroot boundaries are tested. |
| Web and TLS | Valid ACME-managed certificate; TLS 1.2 and 1.3 only unless a documented client requirement proves otherwise; HTTP redirects to HTTPS; safe headers; minimal Apache modules; automated renewal and expiry alerting. |
| Service isolation | Separate service identities and writable trees; least privilege; AppArmor and systemd sandboxing where compatible; player/private state outside the document root; safe mount flags where verified. |
| Software integrity | Exact source revisions, build flags, packages, patches, and dependencies recorded; public-safe software inventory/SBOM; secrets excluded; unsupported components replaced or explicitly isolated. |
| Data protection | Public, private-operational, and secret data classified; strict ownership and permissions; no public directory traversal or unintended listings; private backups encrypted off-host. |
| Detection | Time-synchronized logs, adequate retention, authentication and privilege-change visibility, service and file-integrity signals, disk/inode/backup/certificate alerts, and an off-host or failure-resistant log copy. |
| Recovery | Documented and tested restore, rebuild, credential-rotation, host-key-change, certificate, compromise-containment, and rollback procedures. |

The public SSH endpoint is intentional. Moving it to an obscure port is not a
substitute for access control. The important design is separation: game users
may reach only dgamelaunch, while privileged administration uses a stronger and
preferably separately restricted path.

## 5. Assessment Rules Of Engagement

Before any active testing, create a dated Rules of Engagement record containing:

- written authorization from the system owner;
- exact IP addresses, hostnames, services, source addresses, and cloud assets in
  scope;
- the tester, test window, contacts, monitoring coverage, and emergency stop
  contact;
- permitted techniques, request/packet rate, credentials, evidence handling,
  and whether a maintenance window is required;
- current backup and restore status; and
- immediate stop conditions and recovery authority.

### Permitted production baseline

The first production assessment is read-only and low-rate:

- passive DNS and public-record review;
- TCP service discovery and conservative version detection against the single
  approved Illithid address;
- SSH host-key, algorithm, banner, authentication-path, and forwarding-policy
  checks without password guessing;
- HTTP/TLS protocol, certificate, redirect, method, header, content-exposure,
  and safe known-file checks;
- a passive or baseline web scan that does not submit destructive payloads;
- authenticated configuration and package review using approved operator
  access; and
- source/configuration review against redacted copies or direct read-only host
  inspection.

### Prohibited without separate explicit approval

- denial-of-service, stress, resource-exhaustion, or race testing;
- brute force, credential stuffing, broad username enumeration, or lockout
  testing against real accounts;
- destructive or persistent exploitation, malware, shells, persistence, or
  lateral movement;
- modifying or opening player saves, locks, bones, account records, private rc
  files, mail, or ttyrecs for test purposes;
- extracting secrets or private player data as proof;
- social engineering;
- scanning unrelated DigitalOcean or third-party infrastructure; and
- automated exploit-template sets that have not been reviewed and allowlisted.

Potentially disruptive validation belongs on a representative staging host.
Production exploit validation requires a separate maintenance window, exact
test case, explicit approval, clean backup, monitoring, stop condition, and
rollback. A finding can be accepted based on configuration/version evidence
without proving impact on production.

Stop immediately for service instability, unexpected player-data access,
evidence of active compromise, a target mismatch, an unapproved third-party
route, or monitoring loss.

## 6. Delivery Phases

### Phase 0 — Threat Model, Scope, And Recovery Gate

1. Identify service assets, trust boundaries, identities, data classes, network
   flows, administrative paths, build inputs, and external dependencies.
2. Model abuse cases for public anonymous SSH entry, account registration,
   dgamelaunch/chroot escape, path traversal and symlink attacks, malformed
   terminal input, Apache exposure, stolen operator credentials, vulnerable
   packages, supply-chain compromise, denial of service, and backup theft.
3. Reconcile authority and create linked execution tasks in `site-ops` for host,
   TLS, backup, monitoring, and live verification work.
4. Confirm the private backup manifest and complete an isolated restore test
   before any remediation that could affect runtime behavior.
5. Approve the Rules of Engagement and evidence-handling method.

**Exit gate:** Scope and threat model reviewed; exact targets and prohibited
actions recorded; backup/restore evidence accepted; no production testing is
blocked by an unknown owner or recovery path.

### Phase 1 — Read-Only Baseline And Quick Security Test

Perform three complementary reviews.

**External review:**

- verify DNS, routes, certificate transparency, and public metadata;
- inventory reachable TCP services and conservatively fingerprint versions;
- inspect SSH host keys, algorithms, authentication methods, rate behavior,
  banners, and the game-account boundary;
- inspect HTTP/HTTPS, certificate chain and names, supported protocols/ciphers,
  redirects, methods, headers, caching, directory listings, backup files,
  default files, information leakage, and virtual-host behavior; and
- run a reviewed low-impact web baseline scan, then manually validate findings.

**Authenticated host audit:**

- capture OS/kernel/packages, pending updates/reboots, security-support status,
  CISA KEV relevance, listening processes, firewall layers, and cloud controls;
- review effective `sshd` configuration globally and for each public/operator
  account, including root access, passwords, empty passwords, forwarding,
  environment, command/shell behavior, session limits, and modern algorithms;
- review Apache virtual hosts/modules, ACME readiness, document-root ownership,
  writable paths, aliases, logs, and error disclosure;
- review users, groups, `sudo`, authorized keys, service identities, cron,
  timers, systemd units, startup paths, sockets, containers/chroots, SUID/SGID
  files, capabilities, world-writable paths, mounts, AppArmor, and kernel
  hardening;
- review dgamelaunch, NetHack, compiler/runtime dependencies, permissions, input
  boundaries, temporary files, symlink behavior, and public/private artifact
  separation; and
- assess backups, restore evidence, encryption, log retention, alerting, time
  sync, disk pressure, and incident readiness.

**Repository and supply-chain review:**

- map deployed binaries and configuration to exact reviewed source revisions;
- identify vendored, abandoned, or unsupported dependencies;
- scan source and dependencies with maintained tools, then triage results
  manually; and
- check committed history and deployment inputs for accidental secrets without
  recording any discovered secret value in the repository.

Produce a redacted report containing scope, dates, tools and versions, test
limitations, evidence references, findings, affected assets, reproducible safe
checks, likelihood, impact, recommended control, owner, and retest method.
Prioritize using actual exposure and service impact, with CVSS only as one
input. Internet-exposed CISA KEV matches, credible remote compromise, privilege
escalation, player-data exposure, and ineffective recovery are P0 candidates.

**Exit gate:** Findings manually triaged; false positives removed; urgent risks
have owners and containment decisions; no sensitive evidence is committed.

### Phase 2 — HTTPS And Immediate Risk Reduction

1. Protect current state and confirm an actionable rollback.
2. Resolve P0 findings that can be safely contained without changing game data
   or combining unrelated migrations.
3. Configure an Apache `*:443` virtual host for
   `illithid.floatingeye.net`, obtain a certificate through an automated ACME
   client, and allow port 443 through both firewall layers.
4. Verify certificate name/chain, TLS protocols and ciphers, renewal dry run,
   Apache reload behavior, landing-page content, and monitoring.
5. Change the HTTP virtual host to a permanent HTTPS redirect only after HTTPS
   passes externally. Add HSTS only after a defined successful soak; do not use
   preload until every affected subdomain and recovery consequence is reviewed.
6. Correct canonical metadata and every maintained link only after the secure
   endpoint is live.
7. Patch supported packages, remove or disable unexplained listeners and
   default content, and establish safe automatic security updates and reboot
   handling.

**Exit gate:** HTTP reliably redirects to HTTPS; external TLS tests pass the
selected modern profile; renewal and expiry alerting work; SSH game access is
unchanged; rollback is tested.

### Phase 3 — Replacement Host And Defense In Depth

Prefer a blue-green replacement over stacking an OS upgrade, security
hardening, and service migration on the production host. Evaluate Ubuntu 26.04
LTS, the newest LTS when this plan was prepared, against 24.04 LTS and select
the newest release that passes the complete dgamelaunch, legacy-runtime,
backup/restore, and operational compatibility matrix.

1. Build a minimal, reproducible staging host from a reviewed image and pinned
   configuration.
2. Apply a tailored CIS Level 1 Server profile in staging. Never run a blanket
   compliance fix on production; review each exception and test service impact.
3. Implement default-deny cloud/host firewalls, administrative access controls,
   operator MFA where supported, least-privilege service identities, secure
   mounts, AppArmor/systemd containment, log protection, monitoring, and
   encrypted backups.
4. Separate public dgamelaunch SSH behavior from operator access. Test that game
   accounts cannot forward, tunnel, execute arbitrary commands, influence the
   environment, write outside approved paths, or reach private data belonging
   to another user.
5. Rebuild or preserve runtimes according to the migration plan, using exact
   manifests and disjoint writable paths. Do not allow security modernization
   to open an incompatible save with the wrong binary.
6. Run functional, security, restore, failure, and rollback matrices in staging.
7. Cut over only with explicit authority, quiesced service state, fresh verified
   backup, monitored smoke tests, retained old host, and a defined soak period.

**Exit gate:** The replacement meets the tailored baseline; all exceptions are
owned and dated; legacy and current game tests pass; recovery and rollback are
demonstrated; post-cutover soak has no unexplained security or availability
event.

### Phase 4 — Retest And Verification Of Effectiveness

1. Repeat the external and authenticated checks from Phase 1 from a clean test
   environment.
2. Verify every P0/P1 remediation and sample P2 controls; do not close findings
   from change records alone.
3. Ask an independent tester to review the Rules of Engagement, threat model,
   public SSH boundary, HTTPS configuration, and highest-risk remediations where
   practical.
4. Test detection by generating approved benign events: failed operator login,
   privilege use, service restart in staging, certificate warning threshold,
   backup-age threshold, and disk/inode threshold.
5. Perform a tabletop compromise exercise covering operator-key theft,
   dgamelaunch escape suspicion, player-data exposure, malicious package or
   source revision, and total host loss.
6. Record residual risks, exceptions, evidence, and follow-up owners in a
   redacted Verification of Effectiveness.

**Exit gate:** No open critical finding; no unaccepted high finding; controls
work in retest; detection and recovery are demonstrated; service owner approves
the residual-risk statement.

### Phase 5 — Continuous Assurance

- monitor service health, certificate expiry, backup age, disk/inodes, security
  updates, reboots, authentication anomalies, privilege changes, and integrity
  signals continuously;
- review Ubuntu notices, upstream dependencies, and CISA KEV additions at least
  weekly, with an emergency path for credible exposed exploitation;
- apply routine security updates within a documented risk-based window and
  verify service behavior afterward;
- review accounts, keys, tokens, firewall rules, listeners, DNS, TLS, packages,
  and exceptions quarterly;
- perform a monthly restore sample and at least annual full recovery exercise;
- repeat the low-impact external assessment quarterly and after material
  exposure changes;
- perform a deeper authenticated assessment and independent review annually and
  after a major host or authentication redesign; and
- review the threat model and this plan after incidents, major releases, new
  web features, or changes to player authentication or public data.

## 7. Remediation Priorities

| Priority | Target response | Examples |
| --- | --- | --- |
| P0 | Contain immediately; remediate or formally accept before unrelated rollout | Active compromise, exposed secret/private player data, internet-reachable KEV, credible remote code execution, ineffective backup/restore, administrative authentication bypass. |
| P1 | Plan promptly and fix in the next controlled maintenance window | Unsupported exposed component, privilege-boundary escape, serious SSH/web misconfiguration, missing detection for privileged changes. |
| P2 | Fix on a scheduled hardening cycle | Defense-in-depth gap with limited exploitability, incomplete headers, excessive but non-exploitable package or module. |
| P3 | Backlog with owner and review date | Hygiene, documentation, or low-impact improvement. |

Operational urgency does not waive backup, stop, or rollback controls. When the
host may already be compromised, preserve evidence and prefer isolation or
replacement over trying to clean it in place.

## 8. Evidence And Data Handling

Commit only public-safe artifacts:

- redacted inventories, threat model, Rules of Engagement, checklists, finding
  summaries, exception records, procedures, public-safe manifests, and hashes;
- tool names/versions and safe reproduction steps; and
- links or identifiers for protected evidence.

Never commit credentials, private keys, tokens, password/account databases,
saves, locks, bones, private rc files, mail, raw ttyrecs, complete host exports,
unredacted scan output containing sensitive paths/data, or private backups.
Store protected operational receipts in the approved `site-ops` location with
least privilege, encryption where appropriate, retention, and deletion rules.

## 9. Acceptance Criteria

This plan is ready for closure review only when:

1. A reviewed threat model, asset/data inventory, and Rules of Engagement exist.
2. The initial external, authenticated, and supply-chain assessments are
   complete, manually triaged, and represented by a redacted findings record.
3. `https://illithid.floatingeye.net/` presents a trusted certificate, passes
   the selected TLS baseline, renews automatically, and is monitored.
4. HTTP redirects to HTTPS without loops or content drift, and maintained
   canonical metadata and links use HTTPS.
5. The host runs a selected supported Ubuntu LTS with current security updates,
   justified software, and a tailored hardening audit whose exceptions are
   owned and dated.
6. Cloud and host firewall rules match the documented minimum network surface;
   no unexplained listener is externally reachable.
7. Privileged administration is key-only, least-privilege, and separated from
   public game access; direct root login is disabled.
8. Public game accounts are demonstrably confined to intended dgamelaunch
   behavior and cannot forward, tunnel, obtain a general shell, or cross player
   and service data boundaries.
9. Private state is absent from the web root and protected by tested ownership,
   permission, publication, and backup boundaries.
10. Security updates, logs, time sync, monitoring, certificate alerts, backup
    alerts, and incident escalation are operational and tested.
11. An encrypted off-host backup and isolated restore—including required legacy
    runtime state—have been demonstrated without risking production saves.
12. Post-remediation retesting finds no open critical issue and no high issue
    lacking explicit owner-approved treatment.
13. Deployment, rollback, restore, credential/host-key rotation, certificate,
    compromise, and total-host-loss runbooks are current.
14. The service owner reviews the Verification of Effectiveness, residual risks,
    and maintenance cadence and explicitly approves closure.

## 10. Immediate Next Actions

1. Create the linked `site-ops` execution record under its Illithid host plan.
2. Prepare and approve the threat model and Rules of Engagement.
3. Verify current private backup coverage and run the isolated restore gate.
4. Execute the bounded Phase 1 read-only assessment and triage urgent findings.
5. Remediate HTTPS as a narrow backup-gated change, then externally verify TLS,
   redirects, renewal, SSH availability, and landing-page content.
6. Decide whether the hardened target will use Ubuntu 26.04 LTS or 24.04 LTS
   based on staging compatibility, then build the replacement host in parallel.
7. Schedule the post-remediation retest and independent review before cutover is
   considered complete.

## References

- [NIST Cybersecurity Framework 2.0](https://doi.org/10.6028/NIST.CSWP.29)
- [NIST SP 800-115, Technical Guide to Information Security Testing and Assessment](https://doi.org/10.6028/NIST.SP.800-115)
- [Ubuntu Security Guide and CIS auditing](https://documentation.ubuntu.com/security/docs/compliance/usg/)
- [Ubuntu security updates](https://documentation.ubuntu.com/security/security-updates/)
- [Ubuntu security features](https://documentation.ubuntu.com/security/security-features/security-features-overview/)
- [Ubuntu release cycle](https://ubuntu.com/about/release-cycle)
- [OWASP Web Security Testing Guide](https://wstg.owasp.org/stable/)
- [CISA Known Exploited Vulnerabilities Catalog](https://www.cisa.gov/known-exploited-vulnerabilities-catalog)
- [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org/)

## Related Work

- `site-ops/_work/plans/0007-illithid-maintenance.md`
- `site-ops/_work/plans/0011-product-site-deployment.md`
- `illithid/_work/plans/0002-illithid-public-nethack-service-plan.md`
- `site-ops/_work/notes/illithid-data-preservation.md`
