#!/usr/bin/env zsh
set -euo pipefail

root_dir="$(cd "$(dirname "$0")/.." && pwd)"
pyproject_file="$root_dir/templates/case-study/pyproject.toml"
changelog_file="$root_dir/CHANGELOG.md"

usage() {
  cat <<'EOF'
Usage: ./scripts/bump_version.sh <major|minor|patch|X.Y.Z> [--dry-run]

Examples:
  ./scripts/bump_version.sh patch
  ./scripts/bump_version.sh minor
  ./scripts/bump_version.sh 0.2.0
  ./scripts/bump_version.sh patch --dry-run

What it updates:
  - templates/case-study/pyproject.toml project.version
  - CHANGELOG.md (adds a new dated release section after Unreleased)
EOF
}

sed_inplace() {
  if sed --version >/dev/null 2>&1; then
    sed -i "$1" "$2"
  else
    sed -i '' "$1" "$2"
  fi
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 1
fi

bump_spec="$1"
dry_run="false"

if [[ $# -eq 2 ]]; then
  if [[ "$2" == "--dry-run" ]]; then
    dry_run="true"
  else
    echo "Unknown option: $2"
    usage
    exit 1
  fi
fi

if [[ ! -f "$pyproject_file" ]]; then
  echo "Missing file: $pyproject_file"
  exit 1
fi

if [[ ! -f "$changelog_file" ]]; then
  echo "Missing file: $changelog_file"
  exit 1
fi

current_version="$(sed -nE 's/^version = "([0-9]+\.[0-9]+\.[0-9]+)"/\1/p' "$pyproject_file" | head -n1)"
if [[ -z "$current_version" ]]; then
  echo "Could not parse current version from $pyproject_file"
  exit 1
fi

if [[ "$bump_spec" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  next_version="$bump_spec"
else
  IFS='.' read -r major minor patch <<<"$current_version"
  case "$bump_spec" in
    major)
      next_version="$((major + 1)).0.0"
      ;;
    minor)
      next_version="$major.$((minor + 1)).0"
      ;;
    patch)
      next_version="$major.$minor.$((patch + 1))"
      ;;
    *)
      echo "Invalid bump spec: $bump_spec"
      usage
      exit 1
      ;;
  esac
fi

if [[ "$current_version" == "$next_version" ]]; then
  echo "Version unchanged: $current_version"
  exit 1
fi

today="$(date +"%Y-%m-%d")"

if grep -qE "^## \[$next_version\]" "$changelog_file"; then
  echo "CHANGELOG already has a $next_version section."
  exit 1
fi

echo "Current version: $current_version"
echo "Next version:    $next_version"

if [[ "$dry_run" == "true" ]]; then
  echo "Dry run: no files changed."
  exit 0
fi

sed_inplace "s/^version = \"$current_version\"/version = \"$next_version\"/" "$pyproject_file"

tmp_file="$(mktemp)"
awk -v ver="$next_version" -v date="$today" '
  {
    print $0
    if (!inserted && $0 ~ /^## \[Unreleased\]/) {
      print ""
      print "## [" ver "] - " date
      print ""
      print "### Added"
      print ""
      print "-"
      print ""
      print "### Changed"
      print ""
      print "-"
      print ""
      print "### Fixed"
      print ""
      print "-"
      inserted=1
    }
  }
' "$changelog_file" > "$tmp_file"

mv "$tmp_file" "$changelog_file"

echo "Updated: $pyproject_file"
echo "Updated: $changelog_file"
echo "Next steps: review changelog bullets, commit, then tag v$next_version"