# The Floating Eye NetHack Variant

Floating Eye is the NetHack 3.7 lineage used by the public Illithid service.
It combines a mostly vanilla NetHack game with a small set of gameplay patches,
public-server integrations, build settings, and maintainer preferences.

This file is a descriptive inventory, not a specification. It explains the
variant as found in the sibling `nethack` repository and provides a place to
record why Floating Eye differs from vanilla NetHack. Source changes themselves
remain in that repository.

The maintained 3.7 update, NetHack 5.0 port, and parallel-service rollout are
planned in `_work/plans/0004-floatingeye-nethack-5.md`.

## Baseline

The vanilla comparison branch is `upstream/NetHack-3.7`, from the official
NetHack repository. The Floating Eye aggregate branch is `floatingeye`, which
tracks `origin/floatingeye` in the service source fork.

The branch inventory below was observed on 2026-08-24 without fetching:

| Ref | Observed commit | Meaning |
| --- | --- | --- |
| `upstream/NetHack-3.7` | `fec99bfb8` | Vanilla comparison baseline |
| `origin/floatingeye` | `d888d640e` | Aggregate Floating Eye variant |
| `origin/gluten` | `9694afe1e` | Isolated gluten-free conduct patch |
| local `towel` | `b59ec4ef0` | Stdio window-port work merged onto the then-current vanilla branch |
| `origin/towel` | `b26ff9106` | Older published stdio window-port tip |
| `origin/gender` | `5460a4ac4` | Misleading ref: points at an aggregate Floating Eye merge |
| `origin/pethack` | `5460a4ac4` | Misleading ref: points at the same aggregate merge |

At that snapshot, `floatingeye` had 77 commits not present in the vanilla
branch and was missing 38 newer vanilla commits. Those counts include merge and
maintenance history; they are not a count of independent patches.

## Gameplay Patches

### QueerHack

**QueerHack** is the canonical name for the patch family historically
represented by the `consent` and later `gender` branches. The name follows the
same style as PetHack while retaining the original patch's identity.

The lineage descends from the NetHack 3.4.3 **Queer Characters** patch. That
patch allowed succubi and incubi to interact with the hero regardless of the
hero's gender and added straight, gay, and celibate challenges. The historical
entry is [NHPatchDB patch 66](https://nhpatchdb.alt.org/?66).

The current Floating Eye implementation expands that idea:

- foocubi ask for consent and remember the hero's preferences;
- the hero's responses establish an ace, gay, straight, or bi orientation;
- the attributes screen reports that orientation;
- chatting with a foocubus can change the stored preferences;
- foocubus headache and cancellation probabilities are adjusted to retain
  approximate game balance for different orientations;
- asexual heroes receive alternate foocubus behavior;
- nymph messages and interactions take the preferences into account; and
- generated "dishwasher" foocubi use a compatible gender.

The implementation is principally in `src/mhitu.c`, `src/sounds.c`,
`src/insight.c`, `src/role.c`, `src/dokick.c`, `include/flag.h`, and
`include/you.h`. Its development notes and test matrix are currently in
`doc/consent.txt` in the source repository.

Important history:

- the first current-line implementation commit is `b41b38177`;
- early merges called the branch `consent`;
- the later compatibility tip was `4818a2cc3` and was merged as `gender`; and
- neither surviving remote ref isolates the patch today.

### PetHack

PetHack adds the `#pet` extended command. It lets the hero pet an adjacent
non-humanoid monster, their steed, or themself, with responses based on the
target and its disposition. Tame monsters enjoy being petted; peaceful monsters
can take offense. The command includes interactions for statues, hallucination,
slippery hands, and bare-handed contact with petrifying monsters.

The initial patch appears as commits `df8c1c784` and `88f3da0a8` on different
rebased lines. Commit `83d372d34` disallows petting humanoids, and later work
ends at `809ddb3be`. It is implemented mainly in `src/dog.c`, with command-table
and interface declarations elsewhere.

### Gluten-free conduct

The `gluten` branch adds a voluntary gluten-free food conduct. It records and
live-logs the first consumption of a pancake, fortune cookie, cream pie, candy
bar, or cram ration, and reports an intact gluten-free diet during conduct
enlightenment. Lembas wafers are explicitly treated as gluten-free.

The three-commit patch is:

1. `1682d2e9b` — add gluten-free conduct;
2. `e5f8d623b` — add the missing conduct field; and
3. `9694afe1e` — improve logging.

It is merged into `floatingeye`.

## Public-service Integration

These differences support running NetHack under dgamelaunch and preserving
useful public-server artifacts. They are part of the deployed service shape,
not intended as general changes to vanilla gameplay.

### Dgamelaunch integration

- `DGAMELAUNCH` support is enabled.
- The game writes periodic extra-info files under
  `/dgldir/extrainfo-nh370/` for external display of a player's dungeon
  location and progress.
- Simple mail is enabled, checked every five turns, and integrated with the
  dgamelaunch mail spool.
- Server administrative messages are enabled through `adminmsg`.
- Per-game dumplogs are written under the player's
  `/dgldir/userdata/<name>/nh370/dumplog/` tree.

The extra-info work was cherry-picked as `c741f4edd`. Simple-mail configuration
also appears in `422114575`.

### Community server listing

The service is listed on the NetHackWiki
[Public server](https://nethackwiki.com/wiki/Public_server) page. This is the
community-maintained place where Floating Eye is effectively "registered" as a
public server; it is not an official enrollment or service registry.

As observed on 2026-08-24, the entry identifies `floatingeye.net` as a Toronto,
Canada server running NetHack 3.7.0 with a custom patchset, mentions the consent
and dog `#petting` patches, and publishes the connection command
`ssh nethack@floatingeye.net`. The wiki wording predates the QueerHack name and
does not mention every difference recorded here.

### Player and score records

- Up to 16 player-name characters are shown in the status line rather than 10.
- Full player names are retained in record/logfile-related operations.
- Panic logs use the public-server-oriented format that includes player and
  game-start information.
- Score retention is 1,000 total entries and 10 entries per player name.
- Score identity is based on player name rather than Unix uid, as required when
  dgamelaunch users share an operating-system account.

The longer-name patch is `37ee418f3`.

### Build and runtime layout

The source tree contains server and development build material for three named
environments:

- `sys/unix/hints/floatingeye` builds the public-server runtime for a chroot
  rooted at `/opt/dgl`, with NetHack installed as `/nh370`;
- `sys/unix/hints/avocado` is a local single-user curses build; and
- `sys/unix/hints/turnip` is a local WSL tty build.

The public build enables tty and curses window ports, DLB, the secure system
configuration file, timed delays, dumplogs, gzip compression, libc panic
traces, and server paths. It disables shell escapes and process suspension.
`sys/unix/mkchroot.sh` copies the executable's required shared libraries and
terminal data into the chroot. Installation notes are retained alongside the
hints files.

These build files describe the historical Ubuntu 20.04-era environment. They
must be reviewed rather than assumed correct for a replacement host.

## Maintainer and Service Preferences

The checked-in `sys/unix/sysconf` also differs from vanilla for policy or
personal-preference reasons:

- explore mode is disabled;
- wizard mode names `root`, `games`, and `mlehotay`;
- wizard/explore authorization is checked against the player name;
- NetHack's own `MAXPLAYERS` limit is disabled, leaving session control to the
  service layer;
- the support message names the current maintainer address;
- the GDB panic-trace method is disabled in favor of libc tracing; and
- system defaults include `!selectsaved`, `!null`, `timed_delay`, and
  `toptenwin`.

The build also enables editable `getlin` input and the curses mixed-output
routine. These are user-interface choices rather than defining gameplay
features.

Maintainer identity, contact information, paths, and host-specific build
assumptions should eventually move to reviewed service configuration where
practical. Their presence in the variant is recorded here, but it does not make
them permanent characteristics of Floating Eye.

## Experimental Work Not in the Variant

### Stdio window port (`towel`)

The `towel` branch is an experimental stdio window port. The name is unrelated
to NetHack's towel object. Its eleven substantive commits add:

- a minimal tty-build fix for Ubuntu Linux;
- declarations and stubs for a stdio window processor;
- reuse of safe window procedures;
- implementations of the stdio window operations;
- window-chain and `+trace` support;
- extended-command and general window utility routines; and
- `sys/unix/hints/stdio` for a Linux build.

The published feature tip is `b26ff9106`. Local commit `b59ec4ef0` merges a
newer `NetHack-3.7` into it. Neither tip is an ancestor of `floatingeye`, so the
stdio port is not currently part of the Floating Eye variant.

## Branch Hygiene and Interpretation

The historical feature branches cannot presently be treated as an accurate
patch stack:

- `consent` has disappeared as a ref;
- `gender` replaced that name even though the patch concerns queer orientation
  and consent rather than gender generally;
- `origin/gender` and `origin/pethack` were both advanced to the same aggregate
  `floatingeye` merge in 2024;
- local `gender` and `pethack` are stale vanilla checkouts configured to track
  upstream; and
- `origin/towel` was not updated when newer vanilla history was merged into the
  local `towel` branch.

Use commit ancestry and the identifiers in this file when reconstructing a
patch. Do not infer feature content from the current branch names alone.

## Known Follow-up

This first inventory is intentionally high-level. Before rebasing or producing
a new service release:

- audit every effective source difference against the selected vanilla commit;
- decide which service configuration belongs in source, release packaging, or
  site operations;
- reconstruct clean `queerhack`, `pethack`, `gluten`, and `stdio` patch lines;
- test gameplay patches independently and in combination;
- identify save and bones compatibility effects, especially added persistent
  fields for queer preferences and gluten conduct;
- replace host- and maintainer-specific values where appropriate; and
- record exact source commits, build inputs, and verification evidence in the
  applicable Illithid plan before deployment.
