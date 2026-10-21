# 0006 - Build Floating Eye Against Final Upstream 3.7

**Status:** review
**Prepared:** 2026-10-21
**Priority:** P1

## Scope

Maintainer requested a local trial merge and build of the final vanilla
`NetHack-3.7` changes into Floating Eye. NetHack 5.0 work is deferred.
This is a bounded build experiment independent of plan 0004's full migration
and multi-version rollout gates; it does not establish production readiness.

## Baselines

- Illithid `~/build/nethack`: clean `floatingeye` checkout from the personal
  HTTPS fork at `632276732623c36e48cb08e1d7276708ec00c62d`.
- Turnip `~/projects/nethack`: clean `floatingeye` checkout at
  `d888d640e`; origin is the same personal fork, using SSH.
- Official final 3.7 branch fetched on October 21:
  `b63ec1faa7ed7589c5d3f2dc19c154ab6e13f800` (May 2, 2026).
  It retains 3.7.0 WIP status, edit level 143, and is superseded by 5.0;
  it is not an official stable 3.7 release.
- Local Floating Eye is 77 commits ahead and 1,378 behind this upstream tip.

## Execution And Acceptance

Work in the owning source repository's linked worktree at
`/home/mlehotay/projects/nethack-37-integration`, branch
`floatingeye-3.7-final`. Keep the original checkout and both starting tips
unchanged. Do not commit without a maintainer request.

Acceptance for this experiment:

- resolve merge conflicts without discarding the variant features;
- compile the final merged 3.7 source with the Floating Eye server hints;
- record reproducible commands, dependency versions, artifact checksums,
  build diagnostics, and the limits of verification;
- retain production checkout, installed binary, accounts, and saves unchanged.

No production installation, save compatibility claim, complete gameplay
regression claim, or NetHack 5.0 port is in scope. Keep plan open for
maintainer review after the local build.

## Verification Result

Local merge resolved and server-targeted build passed on October 21.
See [`final-37-build-2026-10-21.md`](../notes/final-37-build-2026-10-21.md)
for source identities, conflict decisions, commands, hashes, and limits.
Task 030 is done; this plan remains open for maintainer review.

Maintainer requested committing all work. Source merge committed as
`df68139c3040dcabd8257a6f6c72ef6f2aeea592` on `floatingeye-3.7-final`;
production and the original `floatingeye` checkout remain unchanged.
Plan closure has not been requested.
