# Illithid Codex Log

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
