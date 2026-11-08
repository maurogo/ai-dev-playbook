---
applyTo: "**"
description: Branching, commit and pull request rules.
---

# Git workflow

## Branches

- Never commit to `{{DEFAULT_BRANCH}}`, `main`, `master`, `dev` or `staging` (the pre-commit hook blocks it).
- Name: `feature/<issue>-short-description`, `bugfix/<issue>-...`, `hotfix/<issue>-...`.
- Branch from an up-to-date `{{DEFAULT_BRANCH}}`.

## Commits

- One logical change per commit; one commit per plan phase.
- Format: `<type>(#<issue>): imperative summary` + bullet details.
- Never commit secrets, `.env*`, build output, or generated coverage.
- Do not amend or force-push commits that are already pushed to a shared branch.

## Pull requests

- Target `{{DEFAULT_BRANCH}}`. Use `.github/pull_request_template.md`.
- Keep PRs reviewable (< ~400 changed lines when possible); split by phase otherwise.
- Link the issue (`Closes #123`).
- Every review comment gets a reply: fixed (with commit), or reasoned disagreement.
