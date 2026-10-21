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

## 2026-10-21 - Refresh Public NetHack High Scores

Replaced the September 12 score snapshot with the maintainer-provided
October 21 output from `sudo chroot /opt/dgl /nh370/nethack -s -v all`,
saved on Illithid as `illithid-high-scores-2026-10-21.txt`. The list now
contains 94 retained scores; updated the homepage count and both page dates.
Validated consecutive ranks, descending points, and exact decoded HTML text
against the saved output. No game runtime or player state was changed.

Deployed only `index.html` and `scores.html` to `/var/www/html/` through
site-ops `scripts/manage_static_site.py` and its `illithid-landing` mapping.
The pre-deployment web-root backup and matching receipt are at
`/tmp/illithid-landing-20261021-scores/` (temporary rollback storage).
Source validation and deployment preview passed. Both live HTTP pages
returned successfully and matched local source by SHA-256:

- `scores.html`: `30aabee2e57c33b57763a378579da02dc0d73dde27612dfc13f0acf9c04cc58b`
- `index.html`: `02203cb0159ae543d6eb1ec2a4d42aeb5bc88e32a9473d3c587aa23c1ab64022`

Changes remain uncommitted. This refresh does not change the modernization
plan's execution state or establish automatic score publication.

Verification limits: HTTPS still timed out after 10 seconds, matching the
previously recorded TLS gap; HTTP is the verified publication transport.
`make check-work` stopped on pre-existing `unreviewed-drift` in the unchanged
`_work/repo-workflow.md` canonical-copy check.

## 2026-10-21 - Read-Only Saved-Game Inventory

At 09:44 EDT, inspected only save-file metadata, launcher status files,
process names, and iia dumplog filenames on Illithid. Found 40 primary
`*.gz` saves and 22 `*.gz.bak` files in `/opt/dgl/nh370/var/save`,
an empty launcher in-progress directory, and no running NetHack or
dgamelaunch processes. Primary saves are candidates for continuation;
validity and compatibility were not tested by resuming them.

The May 22 site-ops observation explicitly identifies iia at D38. The
current published #1 score is also iia (1,933,968 points; escaped; maximum
depth 49), but available readable evidence does not establish that these
are the same game. The current iia save was modified September 28 at
05:06 EDT; its last launcher status says D3. Launcher status files can be
stale and were not treated as authoritative decoded save contents.

Game logs, save contents, and iia dumplog contents are permission-protected.
No sudo access was available, no save was opened by NetHack, no raw player
state was copied into the repository, and production was unchanged.
Matching iia's completed-game start/end dates and score from the protected
xlogfile would resolve more of the historical identity question.

## 2026-10-21 - Identify iia's May Deep-Level Game

Read the maintainer-extracted `/home/mlehotay/iia-games.tsv` on Illithid
without changing production. Its five completed-game records establish
that iia's #1 score (1,933,968) was an elven female chaotic Wizard,
started July 24, 2025 at 10:34:35 EDT and ended May 27, 2026 at
10:07:12 EDT by escaping, with maximum depth 49 and 71,322 turns.
Recorded active playing time was 165,090 seconds (45h 51m 30s).

This is the game matching the May 22, 2026 site-ops observation of iia
at D38: its lifetime spans that observation; the preceding recorded
games ended in July 2025 and the next recorded games began May 27, 2026.
The launcher's May 22 start timestamp described that session, whereas
xlog starttime identifies the original game start. The exact recalled
D39 moment is not independently established by these records.

The later Tourist game started May 27 and ended September 28 at
04:07:06 EDT with 2,942 points. The present primary save was modified
at 05:06:08 that day and therefore represents a subsequent game; its
last launcher status is D3. No saves or account data were copied into Git.

## 2026-10-21 - Build Final Upstream 3.7 With Floating Eye

Maintainer requested a local final-3.7 build and explicitly deferred 5.0.
Created plan 0006 and completed task 030 independently of the full migration
gates in plan 0004. Verified Illithid's source clone is clean at 632276732
and its build executable matches the deployed legacy binary. Turnip's clean
source is at d888d640e. Fetched official final-3.7 b63ec1faa, resolved three
conflicting files in a separate NetHack worktree on floatingeye-3.7-final,
and built successfully with the existing Floating Eye server hints and
verified Lua 5.4.8. Serial build avoids a recursive Lua parallel-build race.

Binary reports 3.7.0-143 WIP, not an official stable 3.7 release. Exact
source tree, build commands, artifact hashes, conflict review, diagnostics,
and verification limits are recorded in `_work/notes/final-37-build-2026-10-21.md`.
The source merge is staged and uncommitted; original checkout and production
are unchanged. No installation or save-continuation test occurred. Plan 0006
remains in review; 5.0 and production rollout remain separate.

## 2026-10-21 - Commit Session Work

Maintainer explicitly requested committing all work across Illithid, the
NetHack integration worktree, and site-ops. Committed the resolved NetHack
merge as `df68139c3040dcabd8257a6f6c72ef6f2aeea592` on
`floatingeye-3.7-final`; its tree matches the previously verified build
source. Updated the build report and quick status to reflect committed
source. Illithid retains the score refresh and deployment evidence,
saved-game investigation findings, and final-3.7 build records. Site-ops
retains the deferred Ubuntu upgrade task. No push or further deployment.
Plan 0006 stays in review pending explicit closure approval.

Validation: Illithid plan/task checks and whitespace checks pass. Full
`make check-work` remains blocked by the pre-existing unchanged canonical
workflow-copy drift. Site-ops `make check-work` passed for its task changes.

## 2026-10-21 - Publish Final 3.7 Merge On Floating Eye

Maintainer requested the existing `floatingeye` branch rather than a new
branch. Confirmed `origin/floatingeye` was still d888d640e and the merge
commit df68139c3 descended from it. Fast-forwarded the original turnip
checkout and pushed `floatingeye:floatingeye` without force. Remote now
points to df68139c3. Detached the build worktree at that commit and deleted
the temporary `floatingeye-3.7-final` local branch. No temporary remote
branch was created. The compiled binary remains in the detached worktree.
Production was not changed.
