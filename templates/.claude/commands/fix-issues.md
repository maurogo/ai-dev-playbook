---
description: Apply fixes for findings from /review-code or failing validations.
argument-hint: "[findings or 'validations']"
model: haiku
---

# Fix issues

Input: $ARGUMENTS (review findings pasted, or `validations` to fix whatever fails).

1. Make a numbered list of the issues to fix. Skip 🟡 nits unless asked.
2. Fix one at a time with the minimal change. Do not refactor beyond the finding.
3. After each fix, run the relevant test; at the end run `_partials/validations.md`.
4. If a finding is wrong or not worth fixing, say why instead of changing code.
5. Report each item as fixed / skipped (reason) / not reproducible.
