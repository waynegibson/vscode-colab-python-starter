#!/usr/bin/env zsh
set -euo pipefail

root_dir="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root_dir"

usage() {
  cat <<'EOF'
Usage: ./scripts/release_prepare.sh <major|minor|patch|X.Y.Z> [--push] [--dry-run]

What it does:
  1. Runs scripts/bump_version.sh
  2. Commits version + changelog updates
  3. Creates annotated git tag vX.Y.Z
  4. Optionally pushes commit + tag

Examples:
  ./scripts/release_prepare.sh patch
  ./scripts/release_prepare.sh minor --push
  ./scripts/release_prepare.sh 1.0.0 --dry-run
EOF
}

if [[ $# -lt 1 || $# -gt 3 ]]; then
  usage
  exit 1
fi

bump_spec="$1"
push_changes="false"
dry_run="false"

for arg in "${@:2}"; do
  case "$arg" in
    --push)
      push_changes="true"
      ;;
    --dry-run)
      dry_run="true"
      ;;
    *)
      echo "Unknown option: $arg"
      usage
      exit 1
      ;;
  esac
done

if [[ "$dry_run" == "false" ]]; then
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Working tree has staged or unstaged changes. Commit or stash first."
    exit 1
  fi

  if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
    echo "Working tree has untracked files. Commit, stash, or remove first."
    exit 1
  fi
fi

if [[ "$dry_run" == "true" ]]; then
  ./scripts/bump_version.sh "$bump_spec" --dry-run
  echo "Dry run: release commit and tag were not created."
  exit 0
fi

./scripts/bump_version.sh "$bump_spec"

new_version="$(sed -nE 's/^version = "([0-9]+\.[0-9]+\.[0-9]+)"/\1/p' templates/case-study/pyproject.toml | head -n1)"
if [[ -z "$new_version" ]]; then
  echo "Could not parse bumped version from templates/case-study/pyproject.toml"
  exit 1
fi

git add templates/case-study/pyproject.toml CHANGELOG.md
git commit -m "chore(release): v$new_version"
git tag -a "v$new_version" -m "Release v$new_version"

echo "Created release commit and tag: v$new_version"

if [[ "$push_changes" == "true" ]]; then
  current_branch="$(git rev-parse --abbrev-ref HEAD)"
  git push origin "$current_branch"
  git push origin "v$new_version"
  echo "Pushed branch and tag to origin."
else
  echo "Not pushed. To publish:"
  echo "  git push origin \"$(git rev-parse --abbrev-ref HEAD)\""
  echo "  git push origin \"v$new_version\""
fi
