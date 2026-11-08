---
description: Read-only analysis of an issue — scope, affected code, risks, questions. Changes nothing.
argument-hint: <issue-number>
model: haiku
---

# Analyze issue #$ARGUMENTS

Read-only. Do not edit files, create branches, or commit.

References: `_partials/github-integration.md`.

1. Read the issue with comments. Extract: goal, acceptance criteria, constraints, linked work.
2. Read `AGENTS.md` and any `docs/*-plan.json` related to this area.
3. Delegate code search to the `Explore` subagent: where does the affected behavior live today?
4. Classify: bug / feature / refactor / chore. For bugs, state the likely root cause with `path:line`.
5. Report:

```markdown
## Summary
## Acceptance criteria (as understood)
## Affected code   (path:line list)
## Approach        (1–3 options, recommend one)
## Risks
## Open questions  (things only the issue author can answer)
## Size            S / M / L, and whether a multi-session plan trigger applies
```
