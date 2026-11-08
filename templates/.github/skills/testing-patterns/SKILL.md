---
name: testing-patterns
description: Use when deciding what kind of test to write, designing test data, or testing async code, UI, or external integrations. Complements tests.instructions.md with strategy.
---

# Testing patterns

## Choose the cheapest test that gives confidence

| Level | Use for | Speed | Example |
|-------|---------|-------|---------|
| Unit | Pure logic, transformations, validation | ms | `calculateTotal()` |
| Integration | A unit plus its real collaborators (route + validation + mocked HTTP) | 10–100 ms | POST `/orders` returns 422 on bad body |
| Component | UI behavior through the DOM | 10–100 ms | Form shows error after invalid submit |
| E2E | Critical user journeys only | seconds | Sign up → checkout |

Aim for many unit, some integration/component, few E2E.

## Patterns

**Test data builders** keep tests readable and resilient to schema changes:

```ts
const buildOrder = (overrides: Partial<Order> = {}): Order => ({
  id: "o-1", items: [], status: "pending", ...overrides,
});
```

**Async**: always `await` the assertion target; use `findBy*` for UI that appears later;
test both resolve and reject paths.

**HTTP clients**: mock `fetch` (or use MSW) at the transport layer; assert the request you sent
and how you handled each response class (2xx, 4xx, 5xx, network error).

**Time**: inject a clock or use fake timers. Never `sleep` in tests.

**Bug fixes**: write the failing test first, see it fail for the right reason, then fix.

## Coverage

Coverage is a smoke detector, not a goal. Review uncovered **branches** in changed files;
ignore generated code and trivial re-exports.
