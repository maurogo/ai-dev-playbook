---
description: Create an implementation plan (docs/<feature>-plan.md, plus .json when multi-session).
argument-hint: <issue-number or short description>
model: sonnet
---

# Create plan for $ARGUMENTS

References: `.github/instructions/plan-state.instructions.md`, `_partials/git-operations.md`.

1. If an issue number was given, read it (`_partials/github-integration.md`).
2. Check `docs/*-plan.json` for an existing plan on the same work. If one exists, update it instead.
3. Investigate the current code (delegate wide searches to `Explore`). Collect `path:line` evidence.
4. Decide the lifecycle and **state which trigger applied** (phases/sessions, multi-repo, multi-PR, or none).
5. Copy `docs/_templates/plan-template.md` to `docs/<feature>-plan.md` and fill every section:
   problem, objectives, non-goals, current architecture, before/after code, phases, risks, tests, rollback.
6. If multi-session (or the user asked), copy `docs/_templates/plan-template.json` to
   `docs/<feature>-plan.json`; one work item per phase; ids must match the Markdown table.
7. Validate: `node scripts/validate-plan.mjs docs/<feature>-plan.json`.
8. Show the plan summary to the user and **wait for approval** before committing.
9. On approval, commit: `docs(#<issue>): add <feature> implementation plan`.
