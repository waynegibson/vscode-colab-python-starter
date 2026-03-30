# New Case Study Checklist

1. Create a standalone project from the template repo: `./scripts/new_case_study.sh --target '/path/to/case-study-repos' --git <case-study-name>`
2. Open the generated case-study folder directly in VS Code.
3. Confirm interpreter path comes from .vscode/settings.json and stays on local .venv.
4. Keep Pylance enabled and Ruff as formatter/linter.
5. In notebook, choose kernel:
   - Colab kernel when online
   - .venv kernel when offline
6. Switch only notebook kernel between online/offline modes; do not switch interpreter.
7. Run notebook environment-check cells first.
8. Add any case-specific dependencies to pyproject.toml.
9. Export and sync requirements.txt before submission.
10. Run lint and format before commit.
11. Strip heavy notebook outputs before submission.
12. Optionally publish the repo with `gh repo create` after local verification.
