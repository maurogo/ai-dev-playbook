# {{PROJECT_NAME}} — Agent Instructions

> Read this file first. It is the index; details live in the files it points to.
> Prefer retrieval over memory: open the relevant instruction or skill file before changing code.

## Project

- **Purpose**: {{ONE_LINE_PURPOSE}}
- **Stack**: {{STACK_SUMMARY}}
- **Default branch**: `{{DEFAULT_BRANCH}}` (protected — never commit to it directly)

### Commands

| Task | Command |
|------|---------|
| Install | `npm ci` |
| Dev server | `npm run dev` |
| Lint | `npm run lint` |
| Type check | `npx tsc --noEmit` |
| Unit tests | `npm test` |
| Build | `npm run build` |

## Documentation index

```text
[Instructions] root: .github/instructions   (loaded by applyTo glob)
  typescript.instructions.md    → types, no `any`, naming, doc comments
  tests.instructions.md         → test layout, mocking, what to assert
  git-workflow.instructions.md  → branches, commits, PRs
  plan-state.instructions.md    → plan .md + .json protocol
  (stack overlay files, if installed, appear here too)

[Skills] root: .github/skills   (mirrored to .claude/skills)
  domain-driven-design/SKILL.md → folder structure by business domain
  testing-patterns/SKILL.md     → choosing unit vs integration vs e2e

[Commands] root: .claude/commands
  analyze-issue, create-plan, work-issue, review-code, add-tests,
  fix-issues, prepare-pr, create-pr, finalize-pr
```

## Workflow for non-trivial work

| Phase | Actions |
|-------|---------|
| 1. Analyze | Understand the request → search existing code → list affected files → read related docs |
| 2. Plan | Write `docs/<feature>-plan.md`; add `docs/<feature>-plan.json` when a multi-session trigger applies → commit |
| 3. Implement | Per phase: mark in-progress → change code → add/update tests → run tests → update plan JSON → commit |
| 4. Document | Write `docs/<feature>.md` → update README/related docs → delete temporary plan files → commit |

Small fixes (one file, obvious cause) skip the plan, never the tests.

## Plan state (source of truth between sessions)

- `docs/<feature>-plan.md` explains **why**; `docs/<feature>-plan.json` records **where we are**.
- The JSON is **mandatory** when the request mentions phases or several sessions, touches more than
  one repository, or will land in more than one PR. Say which trigger applied, or that none did.
- At session start: read every `docs/*-plan.json` with `"lifecycle": "multi-session"` and continue it.
- After each finished task: update the JSON in the same commit (`status`, item `log`, `changelog`,
  `lastUpdated`). Mark `completed` only after verifying.
- Your in-session todo list mirrors the JSON; it never replaces it.

## Non-negotiable conventions

- Organize code **by domain**, not by technical type. No root-level `utils/`, `helpers/`, `services/`.
- Tests live next to the code in `__tests__/`.
- Strict TypeScript. No `any`; model data with `type`/`interface`.
- Absolute imports through the `@/` alias. Imports grouped and sorted.
- kebab-case file and folder names.
- Every async boundary (network, filesystem, DB) has explicit error handling.
- Public functions have doc comments in English.
- No secrets in code, logs, commits, or PR descriptions.

## Definition of done

- [ ] Lint, type check, tests and build pass locally
- [ ] New behavior has tests; fixed bugs have a regression test
- [ ] No unrelated changes in the diff
- [ ] Docs updated when behavior or setup changed
- [ ] Plan JSON updated (if one exists)

## Commit format

```text
<type>(#<issue>): short imperative summary

- detail 1
- detail 2
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`.
