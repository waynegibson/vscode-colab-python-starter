# Changelog

All notable changes to this template are documented in this file.

The format is based on Keep a Changelog and this project follows Semantic Versioning.

## [Unreleased]

### Added

- Template traceability via generated `TEMPLATE_VERSION` file.
- `--no-bootstrap` option in scaffold script for CI smoke tests.
- CI workflow for shell linting and scaffold smoke testing.
- Explicit CI and versioning documentation.
- Local testing instructions in README.
- Automated version bump script (`scripts/bump_version.sh`).

## [0.1.0] - 2026-03-30

### Added

- Initial template structure for hybrid Colab and local VS Code workflow.
- Scaffold script with `--target`, `--path`, and `--git` support.
- Baseline VS Code, Ruff, and pre-commit configuration.
