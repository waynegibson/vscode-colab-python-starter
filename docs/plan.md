## Plan: Hybrid Colab + Local VS Code Workflow

Use this repo as a reusable template generator for standalone case-study repositories. Each generated repo gets its own local .venv for IntelliSense and linting while keeping execution flexible between Colab runtime and local kernel. Use pyproject.toml as the editable dependency source of truth and export requirements.txt for Colab parity and submission reproducibility.

**Steps**

1. Phase 1 - Standardize folder workflow
1. Define a repeatable per-case-study folder structure (notebooks, pyproject.toml, requirements.txt, .venv, .vscode/settings.json, .gitignore, .python-version) that is generated into standalone repos outside this template repo.
1. In each case-study folder, create and activate a local .venv and install baseline packaging tools before project-specific dependencies.
1. Configure VS Code per project via .vscode/settings.json with python.defaultInterpreterPath set to ${workspaceFolder}/.venv/bin/python so analysis and IntelliSense always use that folder's .venv.
1. Use Python: Select Interpreter only as a one-time fallback if VS Code does not auto-apply settings.

1. Phase 2 - Dependency source of truth and parity
1. Use pyproject.toml to manage runtime and dev dependencies.
1. Keep dependencies pinned before submission milestones.
1. Export requirements.txt from locked dependency data for Colab installs and reviewer reproducibility.
1. Add a short notebook bootstrap cell that installs from requirements.txt in Colab only when needed.

1. Phase 3 - Notebook execution model
1. Keep two explicit operating modes:
   - Colab mode: execute with Colab kernel, lint and style from local .venv.
   - Offline mode: switch notebook kernel to local .venv Python and run fully local.
1. Document a quick switch procedure (kernel picker only) so interpreter setting is not changed during mode switches.
1. Require a small environment check cell in every notebook (python version, key package versions, active kernel info) and run it first after any kernel switch.

1. Phase 4 - Linting, formatting, and quality gates
1. Install and configure lightweight tooling (ruff for lint + format, optional mypy).
1. Configure editor actions (format on save + organize imports).
1. Add shortcuts for common actions: sync deps, export requirements, lint, format.

1. Phase 5 - Repeatability at scale
1. Create and follow a reusable new case-study checklist.
1. For each new repo, copy only the template payload into a custom target location, then install case-specific extras.
1. Maintain a per-folder dependency freeze update cadence (weekly or before submission).
1. Persist this workflow in project docs for easy reuse.

1. Phase 6 - 2026 best-practice hardening (lightweight)
1. Pin Python major.minor per case-study via .python-version.
1. Commit lock data and export requirements from lock only.
1. Add notebook hygiene rules: clear heavy outputs before submission and commit.
1. Optionally add pre-commit hooks for lint, format, and notebook cleanup.

**Relevant files**

- docs/plan.md - persisted approved setup workflow
- scripts/new_case_study.sh - bootstraps a standalone case-study project at a custom path with optional git init
- templates/case-study/.vscode/settings.json - interpreter and notebook editor defaults
- templates/case-study/pyproject.toml - dependency source of truth
- templates/case-study/requirements.txt - Colab/submission install list
- templates/case-study/.python-version - local Python version pin
- templates/case-study/.gitignore - ignore local env and cache artifacts

**Verification**

1. Open notebook with Colab kernel and confirm local unresolved-import diagnostics are clear.
2. Switch same notebook to local .venv kernel and run offline successfully.
3. Recreate clean .venv from requirements.txt and validate imports.
4. In Colab runtime, install requirements.txt and verify key package versions.
5. Run lint and format checks and ensure diagnostics remain stable after kernel switches.
6. Validate environment check cell output matches expected Python major.minor.
7. Validate notebook output hygiene before submission.
