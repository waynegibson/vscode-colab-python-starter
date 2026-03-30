# Changelog

All notable changes to this template are documented in this file.

The format is based on Keep a Changelog and this project follows Semantic Versioning.

## [Unreleased]

## [1.0.1] - 2026-03-30

### Fixed

- Ruff version update to 0.15.8 to address linting issues.

## [1.0.0] - 2026-03-30

### Added

- Template traceability via generated `TEMPLATE_VERSION` file.
- `--no-bootstrap` option in scaffold script for CI smoke tests.
- CI workflow for shell linting and scaffold smoke testing.
- Explicit CI and versioning documentation.
- Local testing instructions in README.
- Automated version bump script (`scripts/bump_version.sh`).
- MIT license (`LICENSE`).
- Public repository docs (`CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `SUPPORT.md`).
- GitHub issue and pull request templates.
- Release helper script (`scripts/release_prepare.sh`).
- Tag-driven GitHub release workflow (`.github/workflows/release.yml`).

## [0.1.0] - 2026-03-30

### Added

- Initial template structure for hybrid Colab and local VS Code workflow.
- Scaffold script with `--target`, `--path`, and `--git` support.
- Baseline VS Code, Ruff, and pre-commit configuration.
