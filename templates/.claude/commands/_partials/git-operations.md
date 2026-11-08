# Partial: git operations

- Sync first: `git fetch origin && git checkout {{DEFAULT_BRANCH}} && git pull --ff-only`.
- Create the branch: `git checkout -b <type>/<issue>-<kebab-summary>` (`feature`, `bugfix`, `hotfix`).
- Stage explicitly by path. Never `git add -A` without reviewing `git status` first.
- Commit format: `<type>(#<issue>): imperative summary` plus bullet details.
- Never commit to protected branches, never `--no-verify`, never force-push a shared branch.
