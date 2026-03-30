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
   - CI smoke mode (no local setup): `./scripts/new_case_study.sh --target '/tmp' --git --no-bootstrap case-study-name`
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
- Version bump script: scripts/bump_version.sh

## Local Testing

Run these checks locally before pushing changes:

1. Lint and syntax-check scripts
   - `shellcheck -s bash -e SC1091 scripts/new_case_study.sh scripts/bump_version.sh`
   - `zsh -n scripts/new_case_study.sh`
   - `zsh -n scripts/bump_version.sh`
2. Run scaffold smoke test
   - `tmp_dir="$(mktemp -d)"`
   - `./scripts/new_case_study.sh --target "$tmp_dir" --git --no-bootstrap ci-local-smoke`
   - `test -f "$tmp_dir/ci-local-smoke/TEMPLATE_VERSION"`
   - `test -d "$tmp_dir/ci-local-smoke/.git"`

These mirror the CI checks in .github/workflows/ci.yml.

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
- `TEMPLATE_VERSION`

## Template Versioning

Track template releases using semantic version tags on this repository (`vMAJOR.MINOR.PATCH`) and maintain release notes in `CHANGELOG.md`.

Each generated project includes a `TEMPLATE_VERSION` file with:

- template release/tag (`template_version`)
- template commit (`template_commit`)
- generation timestamp (`generated_at_utc`)

This makes every generated repo traceable to an exact template state.

Automate version bumps with:

- `./scripts/bump_version.sh patch`
- `./scripts/bump_version.sh minor`
- `./scripts/bump_version.sh major`
- `./scripts/bump_version.sh 0.2.0`

The script updates:

- `templates/case-study/pyproject.toml` project version
- `CHANGELOG.md` with a dated release section scaffold

Use `--dry-run` to preview.

## CI Policy

Use GitHub Actions to enforce quality on push and pull requests:

- script linting (`shellcheck`, `zsh -n`)
- scaffold smoke test (`scripts/new_case_study.sh --target ... --git --no-bootstrap ...`)

As the template grows, add Python or notebook tests to CI in the same workflow.

## Copilot Handoff

When starting a fresh chat in a new workspace, paste this prompt:

"Start from docs/plan.md and docs/new-case-study-checklist.md. Use scripts/new_case_study.sh with --target and --git. Keep Pylance enabled and Ruff as formatter/linter. Use local .venv for IntelliSense and switch only notebook kernel (Colab online, local offline)."
