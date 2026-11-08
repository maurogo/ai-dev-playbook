---
description: Run quality gates and clean up the branch before opening a PR.
model: haiku
---

# Prepare PR

1. `git status` — no stray files, no secrets, no debug logs (`console.log`, `debugger`).
2. `git log {{DEFAULT_BRANCH}}..HEAD --oneline` — commits follow the format; one per phase.
3. Run `_partials/validations.md`.
4. If a plan JSON exists: all completed phases are marked, `lastUpdated` is today, it validates.
   For `single-pr` plans, delete both plan files now.
5. Docs: README/related docs reflect any behavior or setup change.
6. Report a ✅/❌ checklist. Do not push.
