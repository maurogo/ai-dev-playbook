---
description: After approval — merge, write final docs, remove temporary plans, clean up branches.
argument-hint: <pr-number>
model: haiku
---

# Finalize PR #$ARGUMENTS

1. `gh pr view $ARGUMENTS` — approved, checks green, no unresolved threads. Otherwise stop and report.
2. If the feature deserves permanent docs, write `docs/<feature>.md` from the plan's final state
   (what it does, how it works, how to operate it). Commit to the PR branch.
3. Plan files: `single-pr` → delete. `multi-session` → mark items completed, add PR to
   `pullRequests` as merged; delete only when the whole plan is complete.
4. Ask the user to confirm the merge, then `gh pr merge $ARGUMENTS --squash --delete-branch`.
5. `git checkout {{DEFAULT_BRANCH}} && git pull --ff-only`.
6. Comment on the issue with a short summary and close it if not auto-closed.
