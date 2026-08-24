# 0001 - Establish the NetHack Repository and Workflow Topology

**Status:** In progress
**Prepared:** 2026-08-24  
**Owner:** Illithid public NetHack service  
**Priority:** P0

## Goal

Establish a durable repository and workflow topology for the current Illithid
public NetHack service, the future Nexus engine, NLE5, and later agent work.

The topology must let FLEY plan and verify work performed against upstream-
derived source repositories without adding FLEY `_work/` or `AGENTS.md` files
to those repositories.

This plan prepares the authority and workflow structure required before
executing plan `0002-illithid-public-nethack-service-plan.md`.

## Problem

Several related repositories currently represent different kinds of work:

- Illithid runs a public dgamelaunch and Floating Eye NetHack service;
- `dgamelaunch` and `nethack` are upstream-derived source repositories used by
  that service;
- Nexus is a future FLEY NetHack 5 derivative that keeps the engine while
  replacing the canonical Dungeons of Doom and Mazes of Menace world;
- NLE5 is a future control and observation bridge intended to work with Nexus;
- a later AI bot may depend on both Nexus and NLE5.

These concerns must not share one undifferentiated workflow. Public-service
operations must not take over Nexus product planning, and future learning work
must not drive the Nexus engine prematurely.

## Governing Principles

### Workflow follows declared product or service identity

Git ancestry alone does not determine whether a repository may carry FLEY
workflow files.

- An upstream-preserving fork or source checkout does not receive FLEY
  `_work/` or `AGENTS.md` files.
- A declared FLEY product or service repository may carry its own workflow
  even when its source history ultimately derives from an upstream project.

Nexus is a declared FLEY derivative product. Illithid is a declared FLEY
service integration repository. Both may own workflows. The `nethack` and
`dgamelaunch` repositories remain upstream-derived source targets and do not.

### Workflow authority and source ownership are distinct

The authoritative workflow repository owns plans, tasks, decisions,
acceptance criteria, and verification evidence. Source changes may still be
committed in another repository.

For example, an Illithid task may require a dgamelaunch source change. The
implementation commit belongs in `dgamelaunch`; the reason, service acceptance
criteria, migration evidence, and deployment decision belong in Illithid.

### Private operational data stays outside Git

Do not commit credentials, account databases, saves, locks, private rc files,
mail, raw ttyrecs containing private information, production backups, host
exports, or secrets. Repositories may retain public-safe manifests, checksums,
redacted observations, procedures, and verification receipts.

## Target Topology

```text
Current public service

illithid
├── workflow authority for dgamelaunch
├── workflow authority for nethack
├── coordinates service releases and migration evidence
└── delegates host and public-web operations to site-ops

Future engine and learning stack

nexus
  ↓ target engine for
nle5
  ↓ control and observation interface for
future NetHack agent project
```

`fley-org` records the topology and cross-repository authority. It does not
replace any of these execution workflows.

## Repository Responsibilities

| Repository | Identity | Owns | Must not own |
| --- | --- | --- | --- |
| `illithid` | FLEY public-service integration repository | service plans and tasks; dgamelaunch and game-version integration; release manifests; multi-version dispatch; save-migration test evidence; service-level acceptance and rollback coordination | raw production state; credentials; unrelated Nexus product direction |
| `site-ops` | FLEY infrastructure and public-surface operations repository | Droplet inventory and provisioning; OS and host controls; DNS, TLS, SSH endpoint operations; backups and restore operations; monitoring; public web deployment; protected operational receipts | NetHack engine design; NLE5 API design; service product priorities |
| `dgamelaunch` | upstream-derived service source repository | dgamelaunch source, upstream-compatible fixes, build-system changes, configuration examples that belong with the program | FLEY `_work`, `AGENTS.md`, service dashboards, private account or host data |
| `nethack` | upstream-derived Floating Eye server source repository | current public-service NetHack source lineage, source patches, build hints that belong with the program | FLEY `_work`, `AGENTS.md`, Illithid service dashboards, Nexus future-world planning |
| `nexus` | FLEY NetHack 5 engine derivative product | engine and topology changes; custom worlds and Lua levels; Nexus builds; human-playable runtime; upstream divergence records | current Illithid modernization; dgamelaunch operations; NLE5 or bot ownership |
| `nle5` | FLEY learning-environment adapter project | reset/step API; action injection; observations; Python/Gym interface; reproducible adapter verification; later Nexus integration | Nexus engine ownership; Illithid hosting; agent policy and training ownership |
| future agent repository | future FLEY learning project | bot behavior; training and evaluation; datasets and experiment records appropriate for Git | Nexus engine, NLE5 bridge, or public-service operations |
| `fley-org` | organization governance root | repository registry; workflow-authority relationships; portfolio and cross-repository coordination | implementation details or duplicate execution dashboards |
| `fley-qms` | controlled governance repository | controlled SOP, WI, Change Control, CAPA, approval, or evidence-retention requirements when applicable | ordinary repository implementation work |

## Dependency Rules

### Current service

Illithid may consume pinned commits from `dgamelaunch` and `nethack`. Neither
source repository depends on the Illithid workflow.

Illithid coordinates with site-ops for host and public-web changes. A service
release must reference the exact source commits and the applicable site-ops
deployment or infrastructure evidence.

The current public service must not depend on Nexus until a later plan
explicitly qualifies Nexus as a supported service game. Plan 0002 currently
targets a maintained NetHack 5 release alongside the pinned legacy runtime.

### Future platform

The intended dependency direction is:

```text
Nexus engine → NLE5 adapter → future agent
```

- Nexus remains useful and human-playable without NLE5.
- NLE5 may target Nexus after its basic bridge works.
- Nexus must not depend on NLE5.
- The future agent depends on the NLE5 interface and selected Nexus runtime,
  not the reverse.
- Agent requirements must not reshape Nexus or NLE5 without explicit
  interface review in their owning workflows.

## Illithid Repository Setup

The Illithid repository now has a confirmed public GitHub identity and a local
FLEY workflow. Complete the remaining record routing and cross-repository
verification deliberately.

Required setup:

1. Confirm the canonical repository name, visibility, remote, and intended
   organization before initializing or publishing Git.
2. Add `AGENTS.md` defining service authority, production-safety boundaries,
   upstream-source rules, and session wrap-up behavior.
3. Add `_work/README.md`.
4. Copy the canonical FLEY workflow to `_work/repo-workflow.md`.
5. Add `_work/local-workflow.md` for Illithid-specific production safety and
   cross-repository implementation rules.
6. Add `_work/plans/plans.csv` and register plans 0001 and 0002.
7. Add `_work/tasks.csv` and task context as needed.
8. Add `_work/codex-log.md`.
9. Add a narrow `check-work` command or documented equivalent that validates
   the workflow copy, plans, tasks, and repository-specific invariants.
10. Register the repository and project in `fley-org` after its identity and
    local path are confirmed.

Plan 0002 should depend on completion of the authority and minimum-workflow
parts of plan 0001. Production discovery may begin read-only, but no
production mutation is authorized merely by creating these plans.

## Authority and Registry Changes

Update `fley-org` to represent:

- `illithid workflow-authority-for dgamelaunch`;
- `illithid workflow-authority-for nethack`;
- Nexus no longer serving as workflow authority for those current-service
  source repositories;
- `site-ops` retaining Illithid infrastructure and public-surface operations;
- Nexus and NLE5 remaining separate FLEY projects with the future dependency
  direction recorded without merging their workflows;
- the future agent remaining an uncreated project until a durable proposal or
  implementation front exists.

Workflow authority must have one unambiguous owner per target in the current
registry model. Cross-repository collaboration is recorded through tasks,
evidence links, and repository relationships rather than duplicate dashboards.

## Record Migration and Cleanup

Review existing NetHack-related workflow records and route them as follows:

- Move Illithid service integration context currently under
  `nexus/_work/integrations/dgamelaunch/` into Illithid, preserving provenance.
- Keep Nexus product and engine records in Nexus.
- Keep NLE5 bridge and learning-environment records in NLE5.
- Keep host inventory, backup procedures, monitoring, DNS/TLS, and deployment
  records in site-ops, with pointers from Illithid where service coordination
  needs them.
- Leave source code and upstream-compatible technical documentation in
  `dgamelaunch` and `nethack`.
- Confirm that `dgamelaunch` and `nethack` contain no FLEY `_work` or
  `AGENTS.md` surfaces after migration.
- Remove Windows `Zone.Identifier` metadata rather than migrating it into a
  workflow repository.

Do not delete the source copy of a durable record until its destination and
content have been verified.

## Plan 0002 Reconciliation

Revise `0002-illithid-public-nethack-service-plan.md` so its ownership language
matches this topology:

- service planning, cross-component release decisions, and migration evidence
  belong in Illithid;
- dgamelaunch and NetHack implementation commits belong in their source
  repositories and are referenced from Illithid tasks;
- host, backup, monitoring, DNS/TLS, and web deployment work is delegated to
  site-ops;
- Nexus and NLE5 are outside the initial public-service modernization scope;
- private production evidence remains outside Git.

## Work Phases

### Phase 1 — Confirm identities and authority

- approve the repository table and dependency rules in this plan;
- confirm Illithid repository name, visibility, and remote;
- record the accountable service owner;
- update `fley-org` repository and relationship registries.

### Phase 2 — Establish the Illithid workflow

- create the minimum Illithid workflow surface;
- register plans 0001 and 0002;
- create initial setup and Phase 0 service tasks;
- add local validation.

### Phase 3 — Route existing records

- transfer Illithid/dgamelaunch integration records from Nexus;
- reconcile site-ops plan 0007 as the infrastructure work package;
- update references without duplicating task state;
- remove stale or source-repository workflow artifacts only after verification.

### Phase 4 — Verify the topology

- run Illithid workflow checks;
- run Nexus, NLE5, and site-ops local checks;
- run `fley-org` registry checks and repo-tour;
- confirm that source forks remain free of FLEY workflow surfaces;
- confirm every open task has exactly one authoritative dashboard.

## Initial Task Seeds

Create stable task identifiers in the Illithid dashboard for at least:

1. confirm Illithid repository identity, visibility, and remote;
2. install the Illithid workflow surface and checks;
3. update FLEY repository and workflow-authority registries;
4. migrate Illithid service-integration records from Nexus;
5. reconcile site-ops plan 0007 and its operational references;
6. revise and register plan 0002;
7. verify clean workflow boundaries in `nethack` and `dgamelaunch`;
8. document the Nexus → NLE5 → future-agent dependency direction;
9. run cross-repository validation and propose plan closure.

## Acceptance Criteria

- Illithid has a confirmed repository identity and an adopted local workflow;
- plans 0001 and 0002 are registered and mechanically valid;
- Illithid is the recorded workflow authority for `dgamelaunch` and `nethack`;
- site-ops remains authoritative for Illithid host and public-web operations;
- Nexus owns only the future engine/product work described here;
- NLE5 owns only the bridge and learning-environment interface work described
  here;
- the future agent boundary and dependency direction are documented without
  prematurely creating implementation state;
- `dgamelaunch` and `nethack` have no FLEY `_work` or `AGENTS.md` surfaces;
- existing service-integration records are routed without loss or duplicate
  task authority;
- private production data and secrets remain outside Git;
- plan 0002 uses the authority model in this plan;
- local workflow checks, FLEY registry checks, and repo-tour pass;
- closure is explicitly approved by the maintainer after evidence review.

## Out of Scope

- executing the Illithid production modernization;
- changing, rebuilding, restarting, or deploying the live service;
- choosing the future agent architecture or learning algorithm;
- forcing Nexus to satisfy NLE5 or agent requirements before its own
  milestones;
- importing upstream source into Illithid;
- storing production backups, player data, credentials, or raw administrative
  exports in any repository.

## Immediate Next Actions

1. Review and approve this repository topology.
2. Confirm whether `illithid` will be a private or public Git repository and
   where its remote will live.
3. Establish the minimum workflow surface and dashboards.
4. Update the FLEY authority relationships.
5. Route the existing integration records and reconcile plan 0002.
