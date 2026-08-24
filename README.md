# Illithid

Illithid is the FLEY service-integration repository for the public Floating Eye
NetHack service at `ssh nethack@floatingeye.net`.

The public landing-page source is under `site/illithid.floatingeye.net/`.
Deployment, production backups, hosting, DNS/TLS, and live verification remain
managed by the sibling `site-ops` repository through its `illithid-landing`
public-surface mapping.

The current NetHack variant and its differences from vanilla are described in
[`FLOATINGEYE.md`](FLOATINGEYE.md).

Workflow plans and tasks are under `_work/`. Run `make check-work` after
changing workflow records.
