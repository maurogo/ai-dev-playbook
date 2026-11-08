# Partial: GitHub (gh CLI)

- Read an issue: `gh issue view <n> --comments`
- Search related work: `gh issue list --search "<terms>"`, `gh pr list --search "<terms>"`
- PR diff: `gh pr diff <n>`; PR checks: `gh pr checks <n>`
- Create PR: `gh pr create --base {{DEFAULT_BRANCH}} --title "<title>" --body-file <file>`
- Comment: `gh issue comment <n> --body-file <file>`

`gh` must be authenticated (`gh auth status`). If it is not, stop and tell the user.
