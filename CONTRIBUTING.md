# Contributing

Thanks for contributing.

## Development Setup

1. Install shell tooling used in CI: `zsh` and `shellcheck`.
2. Run local checks before opening a pull request:
   - `shellcheck -s bash -e SC1091 scripts/new_case_study.sh scripts/bump_version.sh scripts/release_prepare.sh`
   - `zsh -n scripts/new_case_study.sh`
   - `zsh -n scripts/bump_version.sh`
   - `zsh -n scripts/release_prepare.sh`
   - `tmp_dir="$(mktemp -d)" && ./scripts/new_case_study.sh --target "$tmp_dir" --git --no-bootstrap ci-local-smoke`

## Pull Request Guidelines

1. Keep pull requests focused and small.
2. Update docs and changelog when behavior changes.
3. Use clear commit messages.
4. Ensure CI passes before requesting review.

## Release Changes

If your change affects generated output or release process:

1. Add an entry under `## [Unreleased]` in `CHANGELOG.md`.
2. Update README usage docs when commands or behavior change.
