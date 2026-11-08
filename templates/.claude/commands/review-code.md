---
description: Review the current diff for bugs, convention violations, and missing tests.
argument-hint: "[base-branch]"
model: haiku
---

# Review code

Base: `$ARGUMENTS` (default `{{DEFAULT_BRANCH}}`). Read-only — report, do not fix.

1. `git diff <base>...HEAD --stat`, then read the full diff.
2. For each changed file, load the matching `.github/instructions/*` and check against them.
3. Look for, in priority order:
   - **Correctness**: logic errors, unhandled errors/rejections, race conditions, off-by-one, null paths.
   - **Security**: unvalidated input, secrets, injection, missing auth checks, data leaks in logs.
   - **Tests**: new behavior without tests, bug fix without regression test.
   - **Conventions**: `any`, naming, folder placement (DDD), import style, doc comments.
   - **Simplicity**: dead code, duplication, needless abstraction.
4. Report each finding as:

```markdown
### [severity] path:line — short title
What is wrong, concrete failing scenario, suggested fix.
```

Severity: 🔴 blocker · 🟠 should fix · 🟡 nit. End with a one-line verdict.
Do not report style issues that ESLint/Prettier already enforce.
