#!/usr/bin/env zsh
set -euo pipefail

root_dir="$(cd "$(dirname "$0")/.." && pwd)"
template_dir="$root_dir/templates/case-study"

usage() {
  cat <<'EOF'
Usage: ./scripts/new_case_study.sh [--target PARENT_DIR | --path PROJECT_DIR] [--git] <case-study-name>

Options:
  --target PARENT_DIR  Create the project inside a custom parent directory.
  --path PROJECT_DIR   Create the project at an exact destination path.
  --git                Initialize a standalone git repository in the generated project.
  --help               Show this help message.
EOF
}

target_parent=""
target_path=""
init_git="false"

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

python_bin="$(command -v python3.14 || true)"
if [[ -z "$python_bin" ]]; then
  echo "python3.14 not found. Install Python 3.14.3 first, then re-run this script."
  exit 1
fi

if [[ -e "$target_dir" ]]; then
  echo "Target already exists: $target_dir"
  exit 1
fi

mkdir -p "$target_dir"
cp -R "$template_dir"/. "$target_dir"

pushd "$target_dir" >/dev/null

# Keep project metadata unique per case-study.
sed -i '' "s/^name = \"case-study\"/name = \"$package_name\"/" pyproject.toml
sed -i '' "s/^description = \"Course case-study notebook project\"/description = \"$name notebook project\"/" pyproject.toml

"$python_bin" -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
python -m pip install -r requirements.txt
python -m pip install ruff mypy pre-commit nbstripout
python -m ipykernel install --user --name "$name" --display-name "Python ($name)"

if [[ "$init_git" == "true" ]]; then
  git init >/dev/null
  git branch -M main >/dev/null 2>&1 || true
  pre-commit install || true
fi

popd >/dev/null

echo "Created case-study at: $target_dir"
echo "Next: Open that folder directly in VS Code and run notebook environment-check cells first."

if [[ "$init_git" == "true" ]]; then
  echo "Git repository initialized."
  echo "Optional GitHub step: gh repo create $package_name --source '$target_dir' --private --push"
else
  echo "Optional git step: rerun with --git, or run 'git init && git branch -M main' inside '$target_dir'"
  echo "Optional GitHub step later: gh repo create $package_name --source '$target_dir' --private --push"
fi
