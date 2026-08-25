# 0005 - Expand the Illithid dgamelaunch Game Catalog

**Status:** Blocked by plan 0001 repository-topology verification
**Prepared:** 2026-08-24
**Owner:** Illithid public game service
**Priority:** P1
**Related plans:** `0002-illithid-public-nethack-service-plan.md`,
`0003-illithid-security-modernization.md`,
`0004-floatingeye-nethack-5.md`

## Goal

Expand the public Illithid dgamelaunch menu beyond Floating Eye NetHack while
preserving the same account, isolation, recording, recovery, and operational
safety standards.

The initial catalog candidates are:

- What Fools These Mortals;
- Rogue Clone IV; and
- a small curated interactive-fiction catalog running through a Z-machine
  interpreter.

The catalog should be easy to extend without turning dgamelaunch configuration
into an undocumented collection of one-off paths and commands.

## Authority and Coordination

Illithid owns:

- the supported-game catalog and player-facing menu;
- game and interpreter integration requirements;
- dgamelaunch configuration and acceptance criteria;
- source/release selection and public claims; and
- service-level verification and rollout decisions.

Implementation commits remain in the applicable source repository. The initial
source candidates are:

- [mlehotay/WhatFools](https://github.com/mlehotay/WhatFools);
- [mlehotay/rogue](https://github.com/mlehotay/rogue); and
- the selected interpreter's upstream repository.

Before treating these as maintained FLEY source projects, consult `fley-org`
for project identity, repository registration, and workflow authority. The
current registry lists `rogue` only as an idea without a local checkout and
does not yet identify WhatFools as a project. Illithid may still own their
service integration without duplicating source history or organizational
records.

`site-ops` owns host capacity, operating-system packages, chroot deployment,
backups, monitoring, SSH account behavior, and production verification. The
current site-ops record identifies a 1 GB RAM/25 GB disk host, an existing
`~/build/WhatFools/` checkout, and two public Unix accounts (`nethack` and
`rogue`) that enter the same `/opt/dgl/dgamelaunch` shell. Those facts must be
reverified before execution. The `rogue` login name does not prove that a Rogue
game is installed.

No production change is authorized by this plan.

## Current Candidate Baselines

The following public source state was observed on 2026-08-24 and must be
refreshed before implementation:

| Candidate | Observed source | Observed tip | Current concern |
| --- | --- | --- | --- |
| What Fools These Mortals | `mlehotay/WhatFools`, `main` | `5262b1b022a4202ae3395e108b6417d7960b0476` | The script explicitly invokes Python 2, which is not an acceptable new production dependency. |
| Rogue Clone IV 2.1 | `mlehotay/rogue`, `master` | `4308a4eec60aab789020503d9fda7a9920ddac31` | Historical build files target DOS and Windows; the existing TODO says Linux builds need repair. |
| Z-machine interpreter | Not selected | Not selected | Terminal behavior, save confinement, maintenance, and story-file rights require comparison. |

WhatFools carries the NetHack General Public License because it uses NetHack's
introductory text. Rogue Clone IV carries a three-clause BSD-style license in
`doc/license.txt`. Confirm notices, source-availability obligations, and the
exact deployed source for both during release review.

## Catalog Model

Maintain one reviewed catalog record per game or story. At minimum it should
identify:

- stable game ID, display name, version, source URL, commit/tag, and license;
- build or packaging procedure and checksums;
- executable and argument vector as seen inside the chroot;
- runtime dependencies and chroot files;
- effective uid/gid, working directory, environment, and resource limits;
- save, score, configuration, transcript, and temporary-file behavior;
- in-progress and ttyrec directories;
- spectator/watching and message support;
- backup, restore, retention, and rollback requirements;
- public artifact behavior and whether scores are meaningful;
- security limitations and accepted exceptions; and
- verification fixtures and last-supported date.

Generate or review dgamelaunch menu/configuration changes from this catalog so
displayed keys, launch definitions, directories, and documentation cannot drift
independently.

## Candidate 1 — What Fools These Mortals

What Fools These Mortals is Leonard Richardson's NetHack parody in which the
player acts as a deity responding to a chosen hero. It is a short terminal game
with one-character prompts and no known persistent campaign state.

Required work:

1. Audit `mlehotay/WhatFools` against its historical upstream and preserve
   authorship and licensing.
2. Port it to a supported Python 3 release; do not add Python 2 to the new host
   or chroot.
3. Add automated deterministic tests for startup, deity selection, help/more
   prompts, discovery-mode policy, quit, death, victory, malformed input,
   terminal disconnect, and non-interactive EOF.
4. Define whether scores should remain session-only, be logged, or be omitted
   from public score aggregation.
5. Package only the interpreter/runtime files required inside the chroot and
   verify that the game cannot import or open unintended host or player files.
6. Add a distinct dgamelaunch game definition, in-progress directory, ttyrec
   directory, display name, and help text.

WhatFools is not ready for deployment merely because a production-host build
checkout already exists.

## Candidate 2 — Rogue Clone IV

The target is the maintainer's Rogue Clone IV 2.1 lineage at
`mlehotay/rogue`, not the separate preserved Rogue V3 example found in migrated
dgamelaunch notes.

Required work:

1. Reconstruct a clean supported Linux build using modern C and ncurses while
   preserving intended Rogue Clone IV behavior.
2. Record compiler warnings, architecture assumptions, path constants, random
   seeding, terminal-size behavior, signal handling, and save/restore format.
3. Replace compile-time global paths where necessary with reviewed chroot paths
   for per-player saves and an append-only shared score/log surface.
4. Ensure player identity comes from a bounded dgamelaunch argument or
   environment contract and cannot select arbitrary paths or impersonate
   another player.
5. Back up an existing save before launch only if the operation is atomic,
   bounded to that player, resistant to symlinks, and covered by restore tests.
6. Add stable score records suitable for local publication if the existing
   format can be made safe and unambiguous; do not promise NetHack Scoreboard
   compatibility.
7. Test play, save, restore, death, quit, score submission, concurrent players,
   watching, ttyrec, disconnect, crash recovery, and corrupted-save failure.

## Candidate 3 — Curated Z-machine Interactive Fiction

The service may offer a small set of individually named Z-machine stories. The
interpreter and each story file are separate release inputs with separate
licenses and provenance.

### Interpreter shortlist

Evaluate at least:

| Interpreter | Reasons to evaluate | Known tradeoff |
| --- | --- | --- |
| Frotz | Maintained Unix implementation; native curses and dumb terminal frontends; all Z-code versions including V6; GPL-2.0-or-later | Curses and dumb modes must be tested under dgamelaunch; optional sound/graphics dependencies should be excluded. |
| Bocfel | Actively maintained modern implementation; MIT license; Unicode, undo, transcript, and command-record features | Terminal deployment uses the non-Glk dumb frontend or adds a Glk terminal dependency; V6 support is limited. |
| Fizmo | Native ncurses and console frontends; BSD-style license | Latest stable release is from 2017, making maintenance and dependency risk less attractive. |

Frotz is the preliminary favorite because its maintained curses frontend most
closely matches an SSH/ttyrec service and it supports the complete Z-code
version range. This is a hypothesis, not a selection. Compare Frotz and Bocfel
in the actual chroot using the same story and test matrix before approval.

The interpreter evaluation must cover:

- maintained-source and release provenance;
- license and source-distribution obligations;
- terminal resize, color, Unicode, line editing, paging, and disconnects;
- versions 3, 5, and 8 at minimum, plus an explicit V6 decision;
- Quetzal save/restore compatibility and per-player save confinement;
- filename prompts, transcripts, command recording/playback, auxiliary files,
  and every other story-controlled file operation;
- environment, locale, terminal, current-directory, and home-directory use;
- CPU, memory, file-size, process, and execution-time limits;
- malformed and adversarial story files;
- ttyrec and live-watch output;
- dependency and chroot footprint; and
- behavior when a story, save, or resource file is absent or corrupt.

### Story catalog

Do not equate “downloadable,” “archived,” or “free to play” with permission for
Illithid to redistribute and host a story. The Interactive Fiction Archive
states that donated files remain the property of their creators and that files
without an attached distribution license are presumed personal-use-only.

For every offered story, record:

- title, author, canonical source, exact release/serial, checksum, Z-code
  version, and required Blorb resources;
- an explicit license or permission allowing the intended server-side copy and
  public play;
- content warnings, age suitability, accessibility, and terminal requirements;
- save and auxiliary-file needs;
- a clean-room smoke-test transcript or automated walkthrough where permitted;
  and
- update/removal ownership.

Start with a handful of text-first, freely redistributable stories that exercise
different supported Z-code versions without requiring graphics or sound. Do not
bundle commercial Infocom story files, including Zork, merely because an
interpreter can run them. Any Zork-family candidate requires its own exact
source/build/license review before addition.

## Shared Safety and Service Requirements

Every game must:

- run inside the reviewed dgamelaunch confinement boundary with least
  privilege and no general shell;
- use explicit immutable release paths and bounded writable directories;
- prevent path traversal, symlink escape, cross-player access, arbitrary
  command execution, and uncontrolled subprocess creation;
- behave safely on terminal disconnect, duplicate login, signals, malformed
  input, missing files, and resource exhaustion;
- keep private saves and configuration outside public roots;
- produce ttyrecs and in-progress metadata only through reviewed paths;
- disclose recording and watching behavior to players;
- have a backup, restore, rollback, removal, and incident path;
- have a source/license manifest and update owner; and
- pass staging tests before any production consideration.

Do not enable dgamelaunch spectator messaging for a game unless its message
spool integration is explicitly implemented and tested. Existing notes warn
that messaging without a configured spool can crash the relevant launcher
process.

## Delivery Phases

### Phase 0 — Baseline, ownership, and catalog decisions

1. Complete plan 0001's repository-boundary work.
2. Reverify the deployed dgamelaunch version, configuration, chroot, menu,
   public accounts, capacity, and existing game/build remnants read-only.
3. Fetch and pin the WhatFools and Rogue source baselines.
4. Consult `fley-org` and record the source-repository/workflow authority model
   without adding workflow files to a source fork by default.
5. Complete source and content license reviews.
6. Select the first interactive-fiction stories and approve evaluation
   fixtures.
7. Define the catalog record and generated/reviewed dgamelaunch configuration
   approach.

**Exit gate:** Sources, authority, licenses, candidate stories, infrastructure
constraints, and acceptance owners are known; no deployment relies on an
unverified production remnant.

### Phase 1 — Modernize WhatFools and Rogue

1. Port WhatFools to supported Python 3 with automated behavior tests.
2. Restore a warning-clean supported Linux/ncurses build for Rogue Clone IV.
3. Implement safe identity, save, score, log, and failure behavior where each
   game requires it.
4. Produce reproducible packages and dependency manifests for the selected
   staging platform.
5. Retain source changes and tests in their applicable source repositories and
   reference exact commits from Illithid.

**Exit gate:** Both games build/package reproducibly, pass focused tests outside
dgamelaunch, and have accepted licensing and support boundaries.

### Phase 2 — Select the interpreter and curate stories

1. Build minimal terminal-only Frotz and Bocfel packages from pinned sources.
2. Run the same representative stories and failure/security tests through both.
3. Select one interpreter or record why the Z-machine catalog is deferred.
4. Pin a small licensed story catalog with checksums and metadata.
5. Create safe per-player launch wrappers only if dgamelaunch cannot express
   the required working directory and file policy directly. Wrappers must not
   invoke a shell with player-controlled text.

**Exit gate:** The interpreter decision is evidence-based; every selected story
is licensed and reproducible; save and auxiliary-file confinement passes.

### Phase 3 — Integrate the catalog with dgamelaunch

Coordinate with plan 0004's versioned dgamelaunch design rather than creating a
second competing menu architecture.

1. Add stable menu groups and keys for NetHack, Rogue, WhatFools, and
   interactive fiction.
2. Create per-game/user ttyrec and state directories idempotently at
   registration and login.
3. Add immutable game definitions, argument vectors, working directories,
   in-progress directories, resource limits, and message policy.
4. Ensure the watch menu displays game/story identity without leaking private
   paths or state.
5. Keep games without scores out of score feeds rather than synthesizing
   misleading cross-game rankings.
6. Validate menu/help/MOTD text against actual commands and supported status.

**Exit gate:** A clean staging account can launch, resume where applicable,
watch, record, and exit every catalog entry without cross-game or cross-player
state access.

### Phase 4 — Staging verification

Test at minimum:

| Area | Required cases |
| --- | --- |
| Accounts | New/existing user, both public SSH account routes, duplicate login, unusual valid player names. |
| Menu | Every displayed key, nested return/quit, unavailable game, unsupported terminal size, help and recording notice. |
| Isolation | Path traversal, symlinks, environment manipulation, working directory, file prompts, cross-player and cross-game reads/writes. |
| Lifecycle | Start, save, restore, quit, death/win where applicable, EOF, disconnect, signal, crash, host restart, stale in-progress record. |
| Observation | Live watch, ttyrec playback, resize, Unicode/color, spectator messaging disabled unless supported. |
| Resources | Concurrent sessions, CPU/memory/file/process limits, disk growth, malformed input and story files. |
| Recovery | Backup/restore of each persistent surface, failed deployment, catalog rollback, removal of one game without affecting others. |

Run the dgamelaunch stress tests after adapting them to the catalog, but do not
run stress or resource-exhaustion tests against production.

**Exit gate:** Functional, security, resource, recording, recovery, and rollback
evidence passes review; the service owner approves production preparation.

### Phase 5 — Controlled deployment and publication

1. Coordinate a `site-ops` execution record with exact packages, chroot changes,
   capacity impact, backup state, monitoring, stop conditions, and rollback.
2. Deploy only after plans 0003 and 0004 satisfy their applicable security,
   dgamelaunch, recovery, and production gates.
3. Smoke-test every game through both public SSH routes without disturbing
   active NetHack state.
4. Soak with per-game launch/error/resource/disk monitoring and retain the prior
   catalog configuration for rollback.
5. Update the Illithid landing page, service help/news, and community listings
   to name only games actually supported in production.
6. Publish source, version, license, recording/privacy, save, score, and support
   information for the catalog.

**Exit gate:** The deployed catalog matches public documentation, existing
NetHack service behavior is preserved, no isolation or resource regression is
observed during soak, and rollback remains tested.

## Principal Risks and Controls

| Risk | Control |
| --- | --- |
| Python 2 expands unsupported attack surface | Port WhatFools to supported Python 3; do not deploy Python 2. |
| Historical Rogue code is unsafe or non-portable | Modern compiler warnings, source review, sanitizers where practical, bounded paths, and staging fault tests. |
| Story files lack redistribution rights | Per-title license and provenance gate; absence of an explicit acceptable grant blocks inclusion. |
| Interpreter file prompts escape player storage | Dedicated working/home directory, wrapper or interpreter controls, symlink/path tests, and least privilege. |
| Malicious story or game input consumes resources | Process limits, timeouts where compatible, disk quotas/alerts, malformed-input tests, and monitoring. |
| Added dependencies weaken the chroot | Minimal packages, dependency manifest, no GUI stack, security review, and immutable deployment. |
| Menu growth confuses users | Grouped stable keys, accurate help, version labels, and automated config/menu consistency checks. |
| New game damages NetHack state | Separate writable trees, negative tests, backup gate, and deployment smoke tests covering legacy NetHack. |
| Ttyrecs or saves exhaust the 25 GB disk | Capacity model, retention, off-host archive, per-game monitoring, and conservative initial catalog. |
| Unmaintained game silently becomes permanent | Named owner, pinned source, review cadence, supported-status date, and removal procedure for each entry. |

## Acceptance Criteria

This plan is ready for closure review only when:

1. WhatFools runs on supported Python 3 from a pinned, reviewed source commit.
2. Rogue Clone IV builds and runs safely on the selected supported Linux host
   from a pinned, reviewed source commit.
3. A terminal Z-machine interpreter has been selected through comparative
   staging evidence, or the interpreter/catalog has been explicitly deferred
   without blocking the two definite games.
4. Every hosted interactive-fiction story has exact provenance, checksum, and
   an accepted license or permission for the service's use.
5. The catalog records all required source, runtime, state, recording, support,
   and operational metadata.
6. All games are reachable through clear dgamelaunch menu entries and run
   without a general shell.
7. Player/game saves, scores, configuration, transcripts, temporary files,
   in-progress data, and ttyrecs are appropriately separated and protected.
8. Watching and recordings work as documented; unsupported messaging is
   disabled.
9. Functional, isolation, malformed-input, disconnect, concurrency, resource,
   backup/restore, and rollback tests pass in staging.
10. Site-ops approves and verifies the host/chroot deployment through a
    backup-gated production record after applicable plans 0003 and 0004 gates.
11. Existing NetHack 3.7/5.0 behavior and legacy state remain intact.
12. Public documentation accurately identifies games, sources, versions,
    licenses, recordings, scores, saves, and support limitations.
13. No credentials, player data, saves, ttyrecs, private configuration, or raw
    operational exports are committed.
14. The maintainer explicitly approves closure.

## Immediate Next Actions

1. Complete plan 0001 and the dgamelaunch baseline work shared with plan 0004.
2. Fetch and inspect the current WhatFools and Rogue forks locally in approved
   source workspaces.
3. Open source-repository tasks for the Python 3 and Linux/ncurses ports.
4. Build the catalog schema and licensing checklist.
5. Select representative licensed Z-code fixtures and run the Frotz/Bocfel
   terminal bake-off outside production.

## References

- [What Fools These Mortals source](https://github.com/mlehotay/WhatFools)
- [What Fools These Mortals description](https://www.crummy.com/software/WhatFools/)
- [Rogue Clone IV source](https://github.com/mlehotay/rogue)
- [Frotz](https://davidgriffith.gitlab.io/frotz/) — maintained Unix Z-machine
  interpreter with curses and dumb terminal frontends.
- [Bocfel](https://cspiegel.github.io/bocfel/) — modern Z-machine interpreter
  with dumb and Glk-based interfaces.
- [Fizmo](https://fizmo.spellbreaker.org/) — ncurses and console interpreter
  retained as a comparison candidate.
- [IF Archive terms](https://www.ifarchive.org/misc/license.html) — story-file
  ownership and distribution constraints.
- `../site-ops/_work/plans/0007-illithid-maintenance.md`
- `../site-ops/docs/illithid-current-state.md`
- `../site-ops/_work/floatingeye-ssh-routing.md`
- `../fley-org/projects/project-map.md`
- `../fley-org/projects/projects.csv`
