# Floating Eye Dossier Patch Proposal

**Status:** Proposal\\
**Date:** 2026-08-24\\
**Related:** `FLOATINGEYE.md`, `_work/plans/0004-floatingeye-nethack-5.md`

## Summary

The Floating Eye Dossier patch gives the Floating Eye variant a distinctive
metagame without changing NetHack mechanics. Floating eye monsters collectively
observe heroes, record facts they could witness, and accumulate a persistent
dossier for each dgamelaunch player across games.

Players will eventually view their dossiers, achievements, personal high
scores, game records, ttyrecs, dumplogs, and rc files through an authenticated
Illithid website. Public summaries may be offered separately, subject to an
explicit privacy policy.

The feature has four separable components:

1. **NetHack observation patch:** emits structured, objective observations.
2. **Illithid ingestion service:** validates per-game records and derives
   player dossiers, statistics, and achievements.
3. **Authenticated player website:** presents dossiers beside scores, games,
   ttyrecs, dumplogs, and rc-file tools.
4. **Public integration:** exports compact end-of-game statistics for local
   scoreboards, NetHack Scoreboard links, and tournament-style challenges.

The game remains authoritative only for facts that happened. Achievement rules,
narrative assessments, web presentation, and aggregate challenges belong to
the service layer and may evolve without changing NetHack.

## Purpose

Floating Eye is currently a mostly vanilla NetHack lineage with a small patch
set and public-server integrations. Its name does not yet correspond to a
defining floating-eye feature. The dossier supplies that identity through a
fiction appropriate to the existing monster: floating eyes are stationary
witnesses, and every eye contributes its testimony to a collective record.

The intended experience is not an ordinary analytics dashboard. It is a report
written from the accumulated perspective of the floating eyes:

> **Subject: Alice**\\
> Observed during 31 expeditions by 94 of us.\\
> The subject covered their eyes during 63% of encounters.\\
> A polished silver shield was present on 17 occasions.\\
> Twenty-two witnesses were killed. Three were eaten.\\
> Assessment: cautious, reflective, hungry.

## Design Principles

### Mechanics remain unchanged

Observation must not:

- change monster generation, placement, movement, attacks, gaze effects,
  paralysis, resistances, experience, score, conduct, or object behaviour;
- consume random numbers or alter the order of random-number calls;
- add turns, prompts, messages, delays, or player decisions;
- add fields to save or bones files;
- affect tty output or permit the player to infer otherwise-hidden state;
- block, abort, or slow gameplay materially when logging is unavailable.

The patch records completed facts after the game has already determined them.

### The dossier is observational, not omniscient

A dossier may report only facts that at least one eligible floating eye could
have witnessed. The program knows the hero's complete state, but the collective
eyes do not automatically inherit that knowledge.

Examples of outwardly observable facts include visible equipment, a covered
face, mounting, levitation, visible transformation, attacks, eating, reading,
engraving, praying, petting, retreating, paralysis, and treatment of floating
eyes.

Examples normally excluded include object enchantment, beatitude, unrevealed
object identity, inventory contents not in use, alignment, hunger, intrinsic
properties, private conduct state, and actions performed outside an eye's
observation.

The exact observable-state policy must be enumerated and tested. Narrative text
must not imply that an eye saw more than the structured record establishes.

### Raw evidence and interpretation are separate

Per-game observations are immutable source records. The service derives:

- lifetime totals;
- rates and tendencies;
- notable incidents;
- achievements;
- prose assessments;
- community statistics and tournament challenges.

Changing an achievement threshold or improving dossier prose must require only
a rebuild from stored observations, not a NetHack release.

### No live spoilers

Detailed observation records are published only after the game ends. The game
may append them during play, but neither the player website nor spectator tools
may expose them while the game is active. Ttyrec chapter markers are generated
after completion.

## Observation Model

### Eligible witness

A floating eye is an eligible witness when all applicable conditions are true:

1. it is alive and on the hero's current level;
2. it has an unobstructed sight relationship to the hero;
3. it is capable of seeing;
4. the hero is perceptible to that eye, accounting for invisibility and other
   applicable conditions; and
5. the observed property or action is outwardly visible.

This is a logging predicate, not a new monster ability. Implementation must use
existing NetHack visibility and monster-state semantics wherever possible. It
must not make a floating eye more perceptive in the game.

The hero need not be able to see the eye. A blindfolded hero can be observed
wearing a blindfold. This asymmetry is central to the dossier.

### Observation session

An observation session begins when one or more eligible eyes first perceive the
hero and ends when no eye remains eligible, the hero changes level, or the game
ends. The patch records:

- a starting appearance snapshot;
- meaningful changes to visible appearance during the session;
- selected visible actions and outcomes;
- the witness set for each event;
- the end of the session and its reason.

It must not emit an identical snapshot every turn. The implementation should
compute a visible-state fingerprint and emit a change only when an approved
observable field changes.

### Actions and witnesses

One player action may be seen by several eyes. The record distinguishes the
action from the number of witnesses:

```text
action_count = 1
eye_witness_count = 3
```

This permits statements such as "The subject killed a dwarf while three of us
watched" without counting three kills.

Each floating eye requires a game-local stable identifier so distinct witnesses
can be counted without storing pointers or modifying save data. Use an existing
monster identifier if it is stable and already available; otherwise derive an
observation-only identifier that does not enter saved state.

### Initial observation vocabulary

The first schema should be deliberately bounded.

#### Visible appearance

- eyes covered, distinguishing blindfold and towel when visibly knowable;
- visibly blind where that condition has an outward representation;
- visible, invisible to the witness, or otherwise perceptible;
- displaced image, where meaningful to the witness model;
- levitating or flying;
- mounted and visible steed type;
- visible polymorphed form;
- visible worn armor slots;
- visible shield appearance, including a polished silver shield;
- wielded weapon, tool, or bare hands;
- visible light sources or other conspicuous carried equipment selected during
  schema review.

Object descriptions should use an explicitly chosen observer vocabulary.
Unidentified appearances are preferable when revealing true identity would
make the dossier sound omniscient.

#### Visible behaviour

- attacking or killing a monster;
- attacking, killing, sparing, taming, feeding, or petting a floating eye;
- eating a floating-eye corpse;
- becoming paralyzed following an interaction with a floating eye;
- recovering from that paralysis and its duration;
- eating, drinking, reading, zapping, engraving, praying, or looting;
- mounting, dismounting, transforming, or changing visible equipment;
- moving toward, away from, or repeatedly avoiding a floating eye, if a clear
  non-speculative definition can be established.

"Avoidance" and other inferred intentions should not be emitted by NetHack as
facts. The game records movements and circumstances; the service may derive a
cautiously worded tendency from an approved rule.

#### Game outcomes

- death directly attributed to a floating eye;
- end of a game in which eyes supplied observations;
- ascension after being observed;
- witness survival status at game end or level departure;
- links to the relevant dumplog and ttyrec timestamps.

## Event Format

Use a versioned, append-only JSON Lines record for each game. JSONL supports
streaming writes, recovery after partial failure, human inspection, fixtures,
and independent ingestion.

Illustrative event:

```json
{
  "schema": 1,
  "game_id": "20260824-184455-Alice-nh500",
  "seq": 12,
  "turn": 4812,
  "realtime": 1787611495,
  "event": "appearance_observed",
  "witnesses": [193],
  "subject": {
    "eyes_covered": true,
    "eye_covering": "blindfold",
    "shield_appearance": "polished silver shield",
    "wielded_appearance": "long sword",
    "mounted": false
  }
}
```

The final schema should include:

| Field | Purpose |
| --- | --- |
| `schema` | Event-schema version |
| `game_id` | Stable game identifier shared with xlog/dumplog records |
| `seq` | Monotonic event number within the game |
| `turn` | NetHack move count |
| `realtime` | Timestamp usable for ttyrec correlation |
| `event` | Enumerated event type |
| `witnesses` | Distinct game-local eye identifiers |
| `subject` / `action` / `outcome` | Event-specific allowlisted data |
| `variant` and `version` | Producer identity |

Free-form player-generated text, private rc content, email addresses, IP
addresses, terminal input, and chat/mail content must never enter the dossier.

### File lifecycle

During play, write to a private spool path outside the web root. On normal game
completion:

1. append a terminal event;
2. flush and close the file;
3. atomically mark or rename it complete;
4. let the ingestion service validate and import it;
5. retain the immutable source according to the service retention policy.

Incomplete records from crashes may be retained as partial evidence but must be
marked incomplete and must not receive outcome-dependent achievements.

## Per-Player Dossier

The durable logical record belongs to the dgamelaunch player identity. Do not
make NetHack continually rewrite one lifetime file. The ingestion service
combines immutable per-game files into a rebuildable dossier.

Suggested logical products:

```text
floatingeye/<player>/
    dossier.json
    achievements.json
    games/<game-id>.jsonl
```

The physical paths are service configuration, not part of the patch contract.
Private source records must remain outside the public web root.

The derived dossier should contain:

- schema and generator versions;
- first and most recent observation dates;
- observed games and ascensions;
- number of distinct floating-eye witnesses;
- number and duration of observation sessions;
- frequency of visible equipment and conditions;
- behaviour categories witnessed;
- treatment of floating eyes;
- gaze/paralysis history;
- notable incidents with completed-game artifact links;
- earned achievements and their evidence;
- sufficient aggregate provenance to reproduce every displayed claim.

The dossier is a server record, not a NetHack save component. Deleting or
rebuilding it must not affect games.

## Narrative Presentation

The website should provide both exact statistics and generated collective-eye
prose. The prose must be deterministic, attributable to explicit rules, and
careful about low sample sizes.

Possible sections:

1. **Identification** — how many expeditions and witnesses.
2. **Typical appearance** — equipment and conditions most often observed.
3. **Behaviour under observation** — visible action categories.
4. **Treatment of witnesses** — eyes attacked, spared, tamed, killed, or eaten.
5. **The gaze** — gaze interactions, paralysis, recovery, and death.
6. **Notable testimony** — unusual events with ttyrec chapter links.
7. **Assessment** — short generated characterization.
8. **Distinctions** — achievements and challenge progress.

Example:

> We have observed Bob during four expeditions. Eleven of us contributed. The
> subject usually approached with uncovered eyes and was twice seen carrying a
> polished silver shield. One witness was killed; none were consumed. Our
> evidence remains limited.

The final sentence demonstrates appropriate uncertainty rather than inventing a
confident personality from a few observations.

## Achievements and Challenges

Achievements are derived service data. They carry no in-game rewards, score,
conduct effects, or mechanical advantages.

Initial candidates:

| Achievement | Candidate rule |
| --- | --- |
| **Eye Contact** | Be observed by a floating eye |
| **Known to the Eyes** | Be observed by 100 distinct eyes |
| **Incognito** | Be observed wearing a blindfold in ten completed games |
| **Reflective Subject** | Be observed with a polished silver shield on ten occasions |
| **Under Continuous Observation** | Have five eyes witness the same action |
| **Person of Interest** | Be witnessed performing ten approved action categories |
| **Unblinking** | Recover from floating-eye paralysis |
| **The Long Gaze** | Survive an approved threshold of paralysis turns |
| **No Witnesses** | End a completed game having killed every eye that observed the hero |
| **Reliable Witness** | Ascend while leaving every eye that observed the hero alive |
| **The Eye Remembers** | Ascend after being observed |
| **The Last Thing You See** | Die directly because of a floating eye |
| **Illithid's Regard** | Complete the principal dossier challenge set |

Names and thresholds require balance and attainability review against real
telemetry. Initially calculate them in shadow mode so the maintainer can inspect
their frequency before declaring the public rules stable.

Tournament-style challenges may use the same facts, for example:

- most distinct witnesses during an ascension;
- most observation sessions without killing an eye;
- longest survived gaze paralysis;
- most varied behaviour observed in one game;
- community goal for total distinct witnesses;
- ascend after being observed while leaving all witnesses alive.

Tournament rules must pin a dossier schema, generator version, time window, and
tie-breaking rule. Historical achievements should not silently disappear when
thresholds change.

## Xlogfile and External Integration

The detailed event stream is Illithid-specific and should not be forced into
the ordinary xlogfile. Add only compact end-of-game summaries when useful:

```text
fley_eye_schema=1
fley_eye_witnesses=4
fley_eye_sessions=2
fley_eye_kills=1
fley_eye_paralyses=1
fley_eye_paralysis_turns=37
fley_eye_corpses_eaten=0
fley_eye_death=0
```

Before deployment, verify how local and external scoreboard parsers treat
unknown fields. If compatibility is uncertain, publish a separate joined feed
keyed by `game_id` and leave the standard xlog unchanged.

Achievement names should not be stored as the primary evidence. Consumers can
derive them from schema-versioned facts or use an explicitly versioned
achievement export.

## Illithid Player Website

The dossier is one section of a future authenticated player portal rather than
a standalone application.

Suggested player navigation:

- **Dossier** — collective floating-eye account and achievements;
- **Games** — personal game history and details;
- **Scores** — personal high scores, ascensions, streaks, and conducts;
- **Recordings** — ttyrec browsing and playback, including eye-event chapter
  markers;
- **Dumplogs** — completed-game reports;
- **Configuration** — view and edit version-specific rc files;
- **Account** — password and privacy controls, if safely supported.

### Authentication boundary

The portal may authenticate against dgamelaunch identity, but the web process
must not receive shell access or unrestricted access to the DGL database and
userdata tree. The final design must provide:

- HTTPS only;
- secure password verification compatible with the deployed DGL account store;
- rate limiting and login monitoring;
- session expiration and secure cookies;
- CSRF protection for every write;
- strict mapping from authenticated identity to allowed dossier and rc paths;
- symlink and traversal rejection;
- atomic, bounded rc-file writes with backup-on-save;
- no display of password hashes, save files, private mail, or raw operational
  paths.

The dossier page is read-only. RC editing is a separate, higher-risk capability
and should not block initial dossier deployment.

### Public and private views

Recommended initial policy:

- authenticated players can view their complete dossier;
- public score pages show only existing public game facts and optional coarse
  eye statistics;
- detailed lifetime dossiers are private by default until the service adopts a
  clear notice and opt-in control;
- public aggregate statistics must not expose private account information;
- usernames are treated as pseudonymous game identities, never linked to IP,
  email, or real-world identity through this feature.

The SSH registration flow and website should disclose that completed public
games, ttyrecs, scores, and floating-eye observations may be retained. Existing
players should receive notice before dossier publication.

## Component Ownership

| Component | Likely owner | Responsibility |
| --- | --- | --- |
| Observation patch and event schema | Floating Eye NetHack repository | Correct event production without gameplay changes |
| Runtime paths and spool permissions | Illithid operations | Safe deployment inside the DGL environment |
| Ingestion and dossier generator | Illithid web/service code | Validation, aggregation, achievements, prose |
| Portal and rc editor | Illithid website | Authentication, presentation, player-scoped access |
| Static/public score pages | `site-ops` or designated web owner | Publication and live verification |
| Challenge definitions | Floating Eye maintainer | Versioned rules and review |

The repository boundary should be decided before implementation. The game patch
must not absorb web templates, authentication code, or host-specific paths.

## Implementation Sequence

### Phase 1 — Observation specification

1. Audit NetHack visibility and monster-identifier semantics.
2. Define the exact eligible-witness predicate.
3. Enumerate schema-1 observable fields and event types.
4. Decide object appearance versus true-identity wording.
5. Create fixtures and expected dossier calculations before patching gameplay
   code.

### Phase 2 — Shadow telemetry patch

1. Implement a compile-time or sysconf-controlled observation logger.
2. Emit private per-game JSONL without terminal or xlog changes.
3. Verify zero RNG, save, bones, message, score, and ttyrec differences in
   controlled paired runs.
4. Exercise crash, disk-full, permission-denied, and partial-write behavior.
5. Deploy only to staging, then to production in private shadow mode.

### Phase 3 — Dossier generator

1. Validate and ingest completed records idempotently.
2. Generate exact player aggregates and notable-event indexes.
3. Correlate events with completed ttyrecs and dumplogs.
4. Add deterministic prose with minimum-evidence thresholds.
5. Rebuild all derived records from fixtures and retained source events.

### Phase 4 — Achievement calibration

1. Calculate proposed achievements without displaying them.
2. Review rarity, exploitability, and version bias.
3. Pin versioned definitions and preserve award evidence.
4. Add local challenge and community-aggregate views.

### Phase 5 — Player website

1. Implement read-only authenticated dossier and personal score pages.
2. Add games, dumplogs, and ttyrec playback with eye-event chapter markers.
3. Add privacy settings and disclosure.
4. Implement rc viewing and editing as a separately reviewed security change.
5. Consider opt-in public dossier summaries only after private operation is
   proven.

## Verification

### Gameplay non-interference

- Identical seeded/test scenarios produce identical game outcomes with logging
  enabled and disabled.
- RNG state is unchanged after every observation hook.
- Save and bones formats are byte-compatible apart from ordinary nondeterminism
  unrelated to the patch.
- No new terminal output, input, prompts, delays, score effects, or conducts.
- Logging failure cannot end or alter a game.

### Observational correctness

- No event is emitted through walls, across levels, or without an eligible eye.
- Invisible heroes are handled according to existing eye perception.
- Blindfold and polished-silver-shield observations are recorded only when
  visible under the approved policy.
- Multiple witnesses produce one action with the correct witness count.
- Repeated unchanged state does not flood the record.
- Witness death, polymorph, blindness, level change, and hero movement end or
  update sessions correctly.
- Hidden properties never enter event data or prose.

### Data integrity and web security

- Duplicate ingestion is idempotent.
- Truncated and invalid JSONL is quarantined without corrupting dossiers.
- Every displayed statistic can be traced to source game IDs and events.
- A full dossier rebuild produces stable results.
- One authenticated player cannot read another private dossier or rc file.
- Paths, symlinks, encoded traversal, oversized files, CSRF, and brute-force
  authentication receive dedicated tests.
- Active-game observations never appear through the website.

## Acceptance Criteria

The first public dossier release is acceptable when:

1. the eligible-witness and observable-state specifications are reviewed;
2. instrumentation demonstrably changes no game mechanics, RNG, save/bones
   format, messages, scoring, or ttyrec output;
3. private per-game records survive normal completion and fail safely;
4. the dossier can be rebuilt exactly from immutable records;
5. displayed prose and statistics contain no unobserved or hidden facts;
6. achievements are versioned and backed by traceable evidence;
7. authenticated players can read only their own private dossiers;
8. active-game data cannot leak through the portal;
9. disclosure, retention, backup, and deletion policies are documented; and
10. production rollout and rollback receive explicit maintainer approval.

## Open Questions

- What exact monster-vision predicate best represents what a floating eye can
  witness without inventing a new ability?
- Should the collective recognize true object types, or only their visible
  unidentified appearances?
- Which player actions are sufficiently unambiguous to include in schema 1?
- Should an eye that is peaceful, tame, sleeping, cancelled, or otherwise
  impaired contribute observations?
- How should polymorphed floating eyes enter or leave the collective witness
  identity?
- Should incomplete games contribute ordinary observations but remain
  ineligible for outcome achievements?
- What constitutes "sparing" or "avoiding" an eye without attributing intent
  too aggressively?
- Which dossier fields, if any, are public by default?
- How long are raw per-game observations retained after a dossier is rebuilt?
- Should NetHack 3.7 and 5.0 observations share one lifetime dossier, and how
  should version-specific differences be represented?
- Which code repository owns the website and dossier service?

## Recommended First Decision

Approve the concept and the epistemic rule before selecting achievements:

> The collective dossier records only facts witnessed by eligible floating
> eyes. NetHack emits objective observations; Illithid derives the story.

Once that rule is fixed, the next artifact should be a schema-1 observation
catalog with an explicit visibility rule and one test case for every field.
