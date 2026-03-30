# New Case Study Checklist

1. Create a standalone project from the template repo: `./scripts/new_case_study.sh --target '/path/to/case-study-repos' --git <case-study-name>`
2. Open the generated case-study folder directly in VS Code.
3. Confirm interpreter path comes from .vscode/settings.json.
4. In notebook, choose kernel:
   - Colab kernel when online
   - .venv kernel when offline
5. Run notebook environment-check cells first.
6. Add any case-specific dependencies to pyproject.toml.
7. Export and sync requirements.txt before submission.
8. Run lint and format before commit.
9. Strip heavy notebook outputs before submission.
10. Optionally publish the repo with `gh repo create` after local verification.
