---
applyTo: "docs/**/*-plan.json,docs/**/*-plan.md"
description: Protocol for plan files. The JSON is the source of truth between sessions.
---

# Plan state

A plan that outlives one session is two files:

- `docs/<feature>-plan.md` — narrative: problem, design, risks, rollback (**why**).
- `docs/<feature>-plan.json` — execution state: status, logs, findings (**where we are**).

Templates: `docs/_templates/plan-template.{md,json}`. Schema: `plan-state.schema.json`.

## Lifecycle

Use `"lifecycle": "multi-session"` when **any** applies:

1. The request mentions phases, stages, or several sessions.
2. The work touches more than one repository.
3. The work will land in more than one pull request.

Otherwise `"single-pr"` or no JSON at all. State which trigger applied.

- `single-pr`: delete both plan files when the PR is opened.
- `multi-session`: commit both; keep updating the JSON until the work is complete.

## Session start

1. List `docs/*-plan.json`.
2. Read every `multi-session` plan.
3. Resume `in-progress` and `blocked` items first. Trust `findings` over your own recollection.
4. Never start a second plan for the same work.

## After each finished task or commit (same commit)

1. Set the work item `status`.
2. Append `{ "date", "summary", "commit"? }` to that item's `log`.
3. Append to top-level `changelog` when it matters beyond one item.
4. Record discoveries other sessions must know in `findings`.
5. Bump `lastUpdated`.
6. Mark `completed` only after verifying (tests pass, behavior checked).

Validate: `node scripts/validate-plan.mjs docs/<feature>-plan.json`.

Do **not** create separate "progress notes" files. The JSON is the only state.
