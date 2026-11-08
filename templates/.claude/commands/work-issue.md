---
description: Implement an issue end to end following its plan, one commit per phase.
argument-hint: <issue-number>
model: sonnet
---

# Work on issue #$ARGUMENTS

References: `_partials/git-operations.md`, `_partials/github-integration.md`, `_partials/validations.md`,
`.github/instructions/plan-state.instructions.md`.

## Setup

1. Read the issue and every `multi-session` plan in `docs/`. Resume an existing plan if there is one.
2. If there is no plan and the work is non-trivial, run the `/create-plan` steps first and get approval.
3. Create or check out the branch for this issue.
4. Mirror the plan's work items into your session todo list.

## For each phase

1. Mark the work item `in-progress` in the plan JSON.
2. Read the instruction files whose `applyTo` matches the files you will touch.
3. Implement the smallest change that satisfies the phase's acceptance criteria.
4. Add or update tests (regression test first for bugs).
5. Run `_partials/validations.md`. Fix failures; do not skip or weaken tests to pass.
6. Update the plan JSON: status, log entry, changelog if relevant, `lastUpdated`.
7. Commit code + plan JSON together: `<type>(#<issue>): <phase summary>`.
8. Report the phase result briefly, then continue to the next phase.

## Finish

- Run the full validations once more.
- Summarize what changed, what was verified, and anything left open.
- Suggest `/review-code` then `/create-pr`.

Stop and ask the user if: acceptance criteria are ambiguous, a phase needs a design change,
or a fix would require touching code outside the issue's scope.
