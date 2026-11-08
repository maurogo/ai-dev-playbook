---
description: Push the branch and open a pull request with the project template.
argument-hint: "[issue-number]"
model: sonnet
---

# Create PR

References: `_partials/github-integration.md`, `_partials/pr-template.md`.

1. Run the `/prepare-pr` checks. Stop if anything fails.
2. Read the issue (#$ARGUMENTS or the number in the branch name) and the full diff.
3. Draft the PR body to a temp file following `_partials/pr-template.md`.
4. Show the title and body to the user and **wait for confirmation** (pushing is outward-facing).
5. `git push -u origin HEAD` then `gh pr create --base {{DEFAULT_BRANCH}} --title ... --body-file ...`.
6. Record the PR URL in the plan JSON `pullRequests` if a plan exists; commit and push that update.
7. Return the PR URL.
