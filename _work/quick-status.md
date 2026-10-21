# Quick Status

Repository: illithid  
Last update: 2026-10-21

### Public NetHack service integration
* Illithid owns service-level integration, release coordination, migration
  acceptance, and verification for the public NetHack service
* current baseline work remains blocked until repository topology and workflow
  setup are fully verified

### Security and operational readiness
* establish a modern security baseline covering HTTPS, bounded assessment,
  hardening, recovery, and retesting
* coordinate host, backup, monitoring, DNS/TLS, and deployment work with
  site-ops

### NetHack source and game catalog
* final upstream 3.7 merged and built locally, now on the published
  `floatingeye` branch; plan 0006 in review; production unchanged
* plan the Floating Eye NetHack 5 direction and the curated dgamelaunch game
  catalog, including isolated player-selectable runtimes
* both service expansion fronts remain dependent on the repository-boundary
  foundation

### Gameplay statistics
* design privacy-preserving aggregate statistics for players, accounts, games,
  variants, spectating, and high-score activity
* first review the existing statistics proposal and available service records
  before creating a second telemetry architecture

[//]: # "keep this file under 40 lines; history belongs in reports/"
