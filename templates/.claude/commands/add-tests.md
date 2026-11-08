---
description: Add missing tests for a file, folder, or the current diff.
argument-hint: "[path]"
model: haiku
---

# Add tests for $ARGUMENTS

Default target: files changed vs `{{DEFAULT_BRANCH}}`.

1. Read `.github/instructions/tests.instructions.md` and `.github/skills/testing-patterns/SKILL.md`.
2. For each target, list its public behaviors and branches; check which existing tests cover them.
3. Write tests for the uncovered behaviors in `__tests__/` next to the code.
4. Run them. A new test must pass for the right reason; if it reveals a bug, stop and report it
   instead of changing production code.
5. Report: behaviors now covered, behaviors still uncovered (and why).
