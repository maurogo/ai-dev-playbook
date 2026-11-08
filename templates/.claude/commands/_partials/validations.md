# Partial: validations

Run in order and stop at the first failure; fix it before continuing.

```bash
npm run lint
npx tsc --noEmit
npm test
npm run build
```

Report each step as ✅/❌ with the relevant error lines. Never claim a step passed without running it.
