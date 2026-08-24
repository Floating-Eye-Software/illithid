# 0004 - Port Floating Eye to NetHack 5 and Provide Parallel 3.7/5.0 Play

**Status:** Blocked by plan 0001 repository-topology verification
**Prepared:** 2026-08-24
**Owner:** Illithid public NetHack service
**Priority:** P0
**Related plans:** `0002-illithid-public-nethack-service-plan.md`,
`0003-illithid-security-modernization.md`

## Goal

Bring the Floating Eye patchset forward onto maintained NetHack baselines and
let Illithid players deliberately choose either Floating Eye NetHack 3.7 or
Floating Eye NetHack 5.0.

The work has three coupled outcomes:

1. update the Floating Eye 3.7 source line to a freshly fetched and pinned
   official `NetHack-3.7` baseline;
2. port every intentional Floating Eye change to a reviewed revision on the
   official `NetHack-5.0` line; and
3. update the service integration so 3.7 and 5.0 have explicit, safe,
   independently operable launch paths.

This plan is the NetHack-source and multi-version game-integration work package
for plan 0002. It refines plan 0002's automatic transition model: the service
will continue protecting legacy games, but players may start and maintain games
on either supported Floating Eye line.

## Current Evidence and Planning Baselines

The checked-out sibling `nethack` repository was inspected read-only on
2026-08-24 without fetching. At that snapshot:

- `origin/floatingeye` was `d888d640e`, dated 2024-10-04;
- local `upstream/NetHack-3.7` was `fec99bfb8`, dated 2024-10-29; and
- `git rev-list --left-right --count
  upstream/NetHack-3.7...origin/floatingeye` reported `38 77`.

The observed Floating Eye branch is therefore 38 commits behind that local
vanilla ref, not 50. Both refs are old enough that neither count nor tip may be
used as the execution baseline. The first source action must fetch official
refs and record the exact divergence again.

NetHack 5.0.0 was released on 2026-05-02 from the official
`NetHack-5.0.0_Released` tag. Upstream states that pre-5.0 save and bones files
do not work with 5.0.0. The port should target a reviewed, pinned commit on the
maintained `NetHack-5.0` branch rather than assuming that the release tag or the
moving branch tip is automatically the right service baseline.

The descriptive starting inventory for the variant is repository-root
`FLOATINGEYE.md`. It is not a substitute for the commit-by-commit audit required
by this plan.

## Scope

### Included Floating Eye gameplay

Every intentional gameplay patch currently merged into `floatingeye` must
receive an explicit NetHack 3.7 and 5.0 disposition:

- **QueerHack:** orientation, consent, foocubus behavior, related nymph
  interactions, attributes reporting, and associated text;
- **PetHack:** the `#pet` command and its monster, steed, statue,
  hallucination, slippery-hand, and petrification interactions; and
- **gluten-free conduct:** conduct state, food classification, enlightenment,
  livelog, save/restore, and end-of-game behavior.

### Included server integration

- dgamelaunch extra-info output;
- simple mail and server administrative messages;
- dumplog, logfile, xlogfile, livelog, paniclog, and score behavior;
- longer player-name handling;
- shared-account score identity;
- public-server restrictions on shell, suspend, explore, and debug access;
- runtime defaults and curses/tty behavior;
- build hints, installation inputs, compression, chroot/runtime paths, and
  runtime dependency capture; and
- public news, help, version identification, and service-visible variant name.

### Included service behavior

- explicit dgamelaunch entries for Floating Eye 3.7 and Floating Eye 5.0;
- separate saves, locks, bones, rc files, records, logs, xlogs, livelogs,
  dumplogs, extra-info, and ttyrecs wherever sharing would be unsafe or
  ambiguous;
- deterministic dispatch of an existing legacy 3.7 save to the exact binary
  and data files that created it;
- independent new-game and resume behavior for the updated 3.7 and 5.0 lines;
- distinct version/variant identifiers in public artifacts; and
- documentation and community listings that accurately describe both games.

### Excluded unless separately approved

- the unmerged `towel` stdio window port;
- Nexus game or world changes;
- NLE5 or future-agent interfaces;
- converting a 3.7 save or bones file to 5.0;
- opening an existing save with a merely similar rebuilt binary;
- deleting or retiring the deployed 3.7 runtime or player state;
- production host, DNS, TLS, SSH, firewall, backup, or monitoring mutations
  outside an explicitly authorized `site-ops` execution record; and
- unrelated upstream feature work.

## Patch Disposition Rule

“Apply all Floating Eye changes” means that every effective difference in the
reviewed 3.7 variant receives one of these recorded dispositions for each
target line:

| Disposition | Meaning |
| --- | --- |
| Port | Reimplement or adapt the behavior on the target NetHack line. |
| Upstream | Confirm that upstream now provides equivalent behavior and retain a verification test rather than duplicate code. |
| Externalize | Move host-, identity-, path-, or deployment-specific policy to reviewed release/service configuration. |
| Retire | Omit only with documented rationale, compatibility impact, and explicit maintainer approval. |

No patch may silently disappear because a cherry-pick is empty, conflicts, or
compiles successfully. The disposition matrix must reference original commits,
affected behavior, target commits, tests, and any known save/bones or artifact
format impact.

## Runtime and Data Architecture

During migration, distinguish three runtime identities even if the public menu
shows only two game families:

```text
dgamelaunch
├── Floating Eye 3.7
│   ├── existing legacy save -> frozen deployed nh370 runtime
│   └── no legacy save       -> updated Floating Eye 3.7 runtime
└── Floating Eye 5.0
    └── separate Floating Eye 5.0 runtime and state
```

The exact deployed legacy runtime includes its executable, data files, build
options, system configuration, required libraries, and writable-path contract.
Do not replace it merely because the updated 3.7 build reports the same game
version.

If testing cannot prove that the updated 3.7 runtime safely resumes an existing
save, keep legacy and updated 3.7 state in separate trees. A player with an
active legacy save must continue that save with the frozen runtime; failure to
launch it must stop with an operator-visible error and must never fall through
to updated 3.7 or 5.0.

The 5.0 runtime must never read from a 3.7 save or bones path. Records and
published artifacts may be aggregated only after version and variant identity
are unambiguous and the aggregation is read-only with respect to game state.

## Source and Branch Strategy

Implementation commits remain in the sibling `nethack` source repository.
Illithid records intent, acceptance, exact commit IDs, integration decisions,
and verification evidence.

Before implementation:

1. fetch official and fork refs without rewriting working branches;
2. preserve the observed and deployed Floating Eye tips with immutable tags or
   otherwise durable commit references;
3. identify the exact production source and binary baseline rather than
   assuming it equals `origin/floatingeye`;
4. choose and record the official 3.7 and 5.0 target commits;
5. reconstruct patch ancestry from commits, not the misleading current
   `gender` and `pethack` refs; and
6. agree on maintained aggregate and topic-branch names, with `QueerHack` as
   the feature name and `queerhack` as the proposed branch stem.

Prefer reviewable topic commits or branches for QueerHack, PetHack, gluten-free
conduct, and service integration. Preserve original authorship and provenance
where patches are adapted. Do not merge `towel` as an incidental consequence of
branch cleanup.

## Delivery Phases

### Phase 0 — Establish exact source and production baselines

1. Fetch the official `NetHack-3.7`, `NetHack-5.0`, and relevant release tags.
2. Recalculate ahead/behind counts and produce commit and file inventories for
   Floating Eye against the refreshed 3.7 baseline.
3. Identify the exact deployed 3.7 executable, source commit, patch state,
   build flags, data files, configuration, libraries, and state paths through
   the approved read-only production inventory.
4. Record checksums and private evidence locations without committing binaries,
   saves, configuration secrets, or player data.
5. Build the patch disposition matrix, including changes that are configuration
   preferences rather than source features.
6. Reconcile plan 0002's default-only NH5 dispatch wording with the explicit
   3.7/5.0 choice defined here.

**Exit gate:** Official and deployed baselines are pinned; divergence is exact;
every observed Floating Eye difference has an owner and proposed disposition;
legacy runtime preservation is independently reviewable.

### Phase 1 — Update and stabilize Floating Eye 3.7

1. Create a clean integration line from the selected official 3.7 commit.
2. Apply or reconstruct each approved gameplay and service patch.
3. Replace obsolete build assumptions and resolve upstream-equivalent changes
   without losing intended behavior.
4. Build reproducibly on the selected staging platform with recorded compiler,
   dependencies, flags, generated inputs, and output checksums.
5. Run vanilla tests plus focused QueerHack, PetHack, gluten conduct, score,
   logging, mail, extra-info, dumplog, curses, tty, and path tests.
6. Test copied legacy saves only in isolation. Preserve originals and compare
   hashes around expected-failure cases.

**Exit gate:** The updated 3.7 line is reviewable, reproducible, and functionally
equivalent to the accepted variant inventory; its compatibility boundary with
the deployed runtime is proven and documented.

### Phase 2 — Port Floating Eye behavior to NetHack 5.0

1. Create a clean integration line from the selected official 5.0 commit.
2. Port semantic behavior rather than blindly replaying 3.7 diffs.
3. Use upstream 5.0 facilities where they replace custom code, retaining tests
   that demonstrate equivalent service behavior.
4. Adapt persistent structures, save/restore handling, command registration,
   status/enlightenment output, logging, and build-system integration to 5.0.
5. Give the runtime and public artifacts a stable Floating Eye 5.0 identity.
6. Build reproducibly and run the common and patch-specific verification
   suites on a clean staging system.

**Exit gate:** Every disposition-matrix entry is implemented, verified as
upstream-equivalent, externalized, or explicitly approved for retirement; no
unexplained 3.7 patch is absent from 5.0.

### Phase 3 — Build multi-version dgamelaunch integration

1. Define explicit and understandable 3.7 and 5.0 menu entries.
2. Implement safe existing-save dispatch within the 3.7 choice.
3. Prevent either selected game from reading or writing the other line's save,
   lock, bones, configuration, score, log, or artifact path.
4. Decide and document whether rc files are separate, copied once, or shared
   through a proven compatible subset; never let one version corrupt the
   other's configuration.
5. Preserve live watching and ttyrec behavior with game/version labels.
6. Validate permissions, symlink handling, username edge cases, command queues,
   chroot contents, environment, and failure behavior.
7. Update public artifact routing and feed identifiers without exposing private
   state.

**Exit gate:** Both choices start and resume the intended game deterministically;
failure is closed rather than falling through; writable paths and public
identities are disjoint and auditable.

### Phase 4 — Staging verification and migration rehearsal

Run the full plan 0002 migration matrix plus these cases:

| Test | Expected result |
| --- | --- |
| Existing deployed 3.7 save chooses 3.7 | Frozen legacy binary resumes it; updated 3.7 does not open it. |
| Player without a legacy save chooses 3.7 | Updated Floating Eye 3.7 starts or resumes only its own state. |
| Any player chooses 5.0 | Floating Eye 5.0 starts or resumes only 5.0 state. |
| Player maintains games on both lines | Each game resumes independently with distinct locks and artifacts. |
| Legacy runtime is unavailable | Launch stops clearly; neither updated runtime starts as fallback. |
| Wrong-version path is deliberately populated in staging | Launch rejects or ignores it without mutation. |
| Either runtime crashes or host restarts | The other version's state remains untouched and both recovery paths behave as documented. |
| A game ends on either line | Versioned xlog, dumplog, score, and ttyrec are written once with correct identity. |
| Rollback is invoked | The retained production service and untouched legacy state remain usable. |

Also test all supported hero gender/orientation combinations and foocubus/nymph
paths for QueerHack; tame, peaceful, hostile, humanoid, petrifying, mounted,
statue, hallucination, and slippery-hand cases for PetHack; and every classified
gluten food plus save/restore and conduct reporting for gluten-free conduct.

**Exit gate:** Functional, security, save-isolation, artifact, restore, and
rollback evidence passes review; all failures preserve original state; the
service owner explicitly approves production preparation.

### Phase 5 — Controlled deployment and soak

Production work is owned and executed through `site-ops` under plans 0002 and
0003. Before cutover:

1. resolve blocking security findings and pass the backup/restore gate;
2. approve exact release commits, manifests, configuration, migration steps,
   stop conditions, rollback, maintenance window, and operators;
3. quiesce launches, verify no active process will be interrupted, and take a
   fresh verified backup;
4. deploy immutable versioned runtimes and reviewed dgamelaunch configuration;
5. run smoke tests for legacy resume, updated 3.7, 5.0, watching, ttyrec, mail,
   extra-info, logs, dumplogs, scores, and failure isolation; and
6. monitor both lines through a defined soak while retaining the old host or
   release and an immediately usable rollback.

**Exit gate:** Both public choices remain stable through soak, all baseline
legacy saves remain reachable, no cross-version state access occurs, artifacts
are correct, monitoring is effective, and rollback remains available.

### Phase 6 — Publish and maintain

1. Update the Illithid landing page, help, news, and version descriptions.
2. Update the NetHackWiki public-server entry to name Floating Eye 3.7 and 5.0,
   QueerHack, PetHack, and any other user-visible patch appropriate for the
   community listing.
3. Publish stable versioned xlog and dumplog URL patterns and coordinate
   external scoreboard ingestion under plan 0002.
4. Establish a recurring upstream review cadence for both maintained source
   lines, with reproducible staging rebuild and regression checks.
5. Retire the frozen legacy runtime only after no dependent saves remain and
   the maintainer explicitly approves a separate, backup-gated change.

**Exit gate:** Public descriptions match deployed behavior; external consumers
can distinguish the game lines; maintenance ownership and update procedures are
active; legacy retirement remains a separate decision.

## Verification Requirements

At minimum retain public-safe evidence of:

- refreshed upstream refs and exact selected commits;
- source and binary provenance for all three runtime identities;
- the completed patch disposition matrix;
- reproducible build commands, dependencies, flags, and checksums;
- clean-tree build and test results for updated 3.7 and 5.0;
- focused regression results for each Floating Eye patch family;
- save, bones, lock, rc, score, log, dumplog, extra-info, and ttyrec isolation;
- copied-save failure tests with before/after hashes;
- dgamelaunch selection, watching, disconnect, concurrency, and failure tests;
- restore and rollback rehearsal;
- reviewed release manifests and protected operational evidence references; and
- explicit service-owner acceptance.

Private saves, bones, locks, account data, rc files, mail, raw administrative
exports, protected configurations, credentials, and backups must not be
committed.

## Principal Risks and Controls

| Risk | Control |
| --- | --- |
| A rebased 3.7 binary corrupts a legacy save | Preserve and dispatch to the exact deployed runtime; isolate updated 3.7 state until compatibility is proven. |
| 5.0 reads 3.7 saves or bones | Disjoint paths, negative tests, least privilege, and fail-closed launch rules. |
| A patch disappears during conflict resolution | Mandatory per-change disposition matrix and behavior-focused regression tests. |
| A 3.7 implementation is inappropriate on 5.0 | Port semantics onto native 5.0 facilities and review the resulting code rather than accepting mechanical cherry-picks. |
| Added persistent fields break saves | Explicit structure/save audit and save/restore tests for QueerHack and gluten conduct; never infer compatibility from version text. |
| Shared rc or artifact paths create ambiguity | Separate by default; share only a reviewed compatible subset; label every public artifact with version and variant. |
| Feature branches lose provenance | Preserve exact original commits/authorship and reconstruct from ancestry rather than current ref names. |
| New runtimes weaken the chroot boundary | Security review, dependency manifest, least privilege, path/symlink tests, and plan 0003 staging gate. |
| Migration and host replacement fail together | Rehearse independently, use immutable releases, retain the prior host/runtime, and keep one tested rollback authority. |

## Acceptance Criteria

This plan is ready for closure review only when:

1. The official 3.7 and 5.0 baselines and exact deployed legacy runtime are
   pinned and reproducible or preserved as applicable.
2. Every effective Floating Eye difference has an approved disposition for
   both maintained source lines.
3. Updated Floating Eye 3.7 and Floating Eye 5.0 build reproducibly from exact
   referenced source commits.
4. QueerHack, PetHack, gluten-free conduct, public-server integration, and
   accepted preferences behave as documented on both lines.
5. Existing legacy saves can resume only with their exact compatible runtime;
   no test or production path exposes them to 5.0.
6. Players can deliberately start and resume independent 3.7 and 5.0 games
   through understandable dgamelaunch choices.
7. Save, bones, lock, rc, score, log, xlog, livelog, dumplog, extra-info, and
   ttyrec boundaries are tested and unambiguous.
8. Watching, mail, admin messages, public artifacts, and variant/version labels
   work for both supported lines.
9. Backup restore and rollback have been rehearsed, and production deployment
   passes the security, recovery, authorization, and soak gates from plans 0002
   and 0003.
10. The landing page and NetHackWiki public-server entry match the deployed
    choices.
11. No private player or operational data is committed.
12. The maintainer reviews the evidence and explicitly approves closure. A
    passing test suite alone does not close the plan or retire legacy 3.7.

## Immediate Next Actions

1. Complete the remaining plan 0001 topology and workflow-boundary tasks.
2. Fetch official NetHack refs and record refreshed 3.7 and 5.0 baselines.
3. Complete the read-only production runtime/state inventory and recovery gate.
4. Build the patch disposition matrix from `FLOATINGEYE.md` and commit history.
5. Reconcile plan 0002's launch UX with explicit parallel 3.7/5.0 play.
6. Begin the updated 3.7 integration line before the 5.0 port so the accepted
   current behavior has a tested reference implementation.

## References

- [`FLOATINGEYE.md`](../../FLOATINGEYE.md) — current descriptive variant and
  branch inventory.
- [Official NetHack 5.0.0 release](https://github.com/NetHack/NetHack/releases/tag/NetHack-5.0.0_Released)
  — release date, source tag, major build changes, and save/bones
  incompatibility.
- [Official NetHack 5.0 branch](https://github.com/NetHack/NetHack/tree/NetHack-5.0)
  — maintained target line; pin a reviewed commit before implementation.
- [NetHack 5.0 information](https://www.nethack.org/common/info.html) — current
  release and compatibility guidance.
- [NetHackWiki public-server listing](https://nethackwiki.com/wiki/Public_server)
  — community-maintained listing for deployed games and connection details.
- `0002-illithid-public-nethack-service-plan.md` — service modernization,
  recovery, migration, artifacts, and external integration.
- `0003-illithid-security-modernization.md` — host hardening, security testing,
  staging, production authorization, and Verification of Effectiveness.
