.PHONY: help check-work check-repo-workflow check-plans check-tasks repo-tour

PYTHON ?= python3
FLEY_ORG ?= ../fley-org

help:
	@printf '%s\n' \
		'Illithid workflow targets:' \
		'  check-work           Run all local workflow checks.' \
		'  check-repo-workflow  Compare the local workflow with the canonical copy.' \
		'  check-plans          Validate the plan dashboard.' \
		'  check-tasks          Validate the task dashboard.' \
		'  repo-tour            Report organization repository workflow state.'

check-work: check-repo-workflow check-plans check-tasks

check-repo-workflow:
	@$(MAKE) -C "$(FLEY_ORG)" check-repo-workflow REPO_WORKFLOW="$(abspath _work/repo-workflow.md)"

check-plans:
	@FLEY_ORG="$(abspath $(FLEY_ORG))" $(PYTHON) scripts/check_work_dashboard.py plan _work/plans/plans.csv

check-tasks:
	@FLEY_ORG="$(abspath $(FLEY_ORG))" $(PYTHON) scripts/check_work_dashboard.py todo _work/tasks.csv

repo-tour:
	@$(MAKE) -C "$(FLEY_ORG)" repo-tour WORKSPACE_ROOT="$(abspath ..)"
