#!/usr/bin/env zsh
set -euo pipefail

root_dir="$(cd "$(dirname "$0")/.." && pwd)"
template_dir="$root_dir/templates/case-study"

usage() {
  cat <<'EOF'
Usage: ./scripts/new_case_study.sh [--target PARENT_DIR | --path PROJECT_DIR] [--git] [--no-bootstrap] <case-study-name>

Options:
  --target PARENT_DIR  Create the project inside a custom parent directory.
  --path PROJECT_DIR   Create the project at an exact destination path.
  --git                Initialize a standalone git repository in the generated project.
  --no-bootstrap       Skip .venv creation, package installs, and kernel registration.
  --help               Show this help message.
EOF
}

sed_inplace() {
  if sed --version >/dev/null 2>&1; then
    sed -i "$1" "$2"
  else
    sed -i '' "$1" "$2"
  fi
}

target_parent=""
target_path=""
init_git="false"
bootstrap_env="true"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      [[ $# -ge 2 ]] || {
        echo "Missing value for --target"
        usage
        exit 1
      }
      target_parent="$2"
      shift 2
      ;;
    --path)
      [[ $# -ge 2 ]] || {
        echo "Missing value for --path"
        usage
        exit 1
      }
      target_path="$2"
      shift 2
      ;;
    --git)
      init_git="true"
      shift
      ;;
    --no-bootstrap)
      bootstrap_env="false"
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    --*)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

name="$1"
package_name="$(echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9._-]/-/g; s/--*/-/g; s/^-//; s/-$//')"

if [[ -z "$package_name" ]]; then
  echo "Case-study name must contain at least one letter or number."
  exit 1
fi

if [[ -n "$target_parent" && -n "$target_path" ]]; then
  echo "Use either --target or --path, not both."
  exit 1
fi

if [[ -n "$target_path" ]]; then
  target_dir="$target_path"
elif [[ -n "$target_parent" ]]; then
  target_dir="$target_parent/$name"
else
  target_dir="$root_dir/$name"
fi

if [[ ! -d "$template_dir" ]]; then
  echo "Template folder missing: $template_dir"
  exit 1
fi

python_bin=""
if [[ "$bootstrap_env" == "true" ]]; then
  python_bin="$(command -v python3.14 || true)"
  if [[ -z "$python_bin" ]]; then
    echo "python3.14 not found. Install Python 3.14.3 first, then re-run this script."
    exit 1
  fi
fi

if [[ -e "$target_dir" ]]; then
  echo "Target already exists: $target_dir"
  exit 1
fi

mkdir -p "$target_dir"
cp -R "$template_dir"/. "$target_dir"

template_version="${TEMPLATE_VERSION:-$(git -C "$root_dir" describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0-dev")}"
template_commit="$(git -C "$root_dir" rev-parse --short HEAD 2>/dev/null || echo "unknown")"
generated_at="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

pushd "$target_dir" >/dev/null

# Keep project metadata unique per case-study.
sed_inplace "s/^name = \".*\"/name = \"$package_name\"/" pyproject.toml
sed_inplace "s/^description = \".*\"/description = \"$name notebook project\"/" pyproject.toml

cat > TEMPLATE_VERSION <<EOF
template_version=$template_version
template_commit=$template_commit
generated_at_utc=$generated_at
EOF

if [[ "$bootstrap_env" == "true" ]]; then
  "$python_bin" -m venv .venv
  source .venv/bin/activate
  python -m pip install --upgrade pip setuptools wheel
  python -m pip install -r requirements.txt
  python -m pip install ruff mypy pre-commit nbstripout
  python -m ipykernel install --user --name "$name" --display-name "Python ($name)"
fi

if [[ "$init_git" == "true" ]]; then
  git init >/dev/null
  git branch -M main >/dev/null 2>&1 || true
  if command -v pre-commit >/dev/null 2>&1; then
    pre-commit install || true
  fi
fi

popd >/dev/null

echo "Created case-study at: $target_dir"
echo "Next: Open that folder directly in VS Code and run notebook environment-check cells first."

if [[ "$bootstrap_env" == "false" ]]; then
  echo "Bootstrap skipped (--no-bootstrap). Create .venv and install deps before running notebooks locally."
fi

if [[ "$init_git" == "true" ]]; then
  echo "Git repository initialized."
  echo "Optional GitHub step: gh repo create $package_name --source '$target_dir' --private --push"
else
  echo "Optional git step: rerun with --git, or run 'git init && git branch -M main' inside '$target_dir'"
  echo "Optional GitHub step later: gh repo create $package_name --source '$target_dir' --private --push"
fi
