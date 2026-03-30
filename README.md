# VS Code Colab Python Template

This repository is a template repo for creating standalone Python notebook repositories with a hybrid Colab and local VS Code workflow:

- Execute notebooks on Colab kernel when online.
- Keep IntelliSense, linting, and formatting tied to each folder's local .venv.
- Switch to local kernel when offline.
- Keep each case study in its own repo without copying scaffold automation into the generated project.

## Quick Start

Prerequisite: install Python 3.14.3 on macOS and confirm `python3.14 --version` works before creating a case-study folder.

1. Create a new standalone case-study project from this template repo:
   - `./scripts/new_case_study.sh --target '/path/to/case-study-repos' --git case-study-name`
   - Or create at an exact path: `./scripts/new_case_study.sh --path '/path/to/case-study-name' --git case-study-name`
2. Open the generated case-study folder directly in VS Code.
3. Keep Pylance enabled and Ruff as formatter/linter.
4. Use notebook kernel picker:
   - Colab kernel for online compute.
   - Local .venv kernel for offline execution.
5. Keep interpreter stable from .vscode/settings.json and switch only notebook kernel.
6. Optionally publish the local repo with `gh repo create` after review.

## Template Repo Contents

- Persisted implementation plan: docs/plan.md
- Starter template: templates/case-study
- Bootstrap script: scripts/new_case_study.sh

## Generated Repo Contents

Each generated case-study repo contains only the working project payload:

- `.vscode/settings.json`
- `.vscode/extensions.json`
- `.python-version`
- `pyproject.toml`
- `requirements.txt`
- `.gitignore`
- `.pre-commit-config.yaml`
- `NOTEBOOK_ENV_CHECK.md`

## Copilot Handoff

When starting a fresh chat in a new workspace, paste this prompt:

"Start from docs/plan.md and docs/new-case-study-checklist.md. Use scripts/new_case_study.sh with --target and --git. Keep Pylance enabled and Ruff as formatter/linter. Use local .venv for IntelliSense and switch only notebook kernel (Colab online, local offline)."
