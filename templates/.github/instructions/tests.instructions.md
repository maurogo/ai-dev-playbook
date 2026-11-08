---
applyTo: "**/__tests__/**,**/*.test.ts,**/*.test.tsx,**/*.spec.ts,**/*.spec.tsx"
description: How tests are written and organized.
---

# Tests

## Layout

- Tests live in `__tests__/` next to the code they cover: `src/orders/__tests__/pricing.test.ts`.
- One `describe` per unit; `it` names read as behavior: `it("rejects an expired coupon")`.

## What to test

- Behavior through the public API, not implementation details.
- Every bug fix ships with a regression test that fails before the fix.
- Cover: happy path, each validation failure, each error branch, boundary values.

## Structure

Arrange / Act / Assert, separated by a blank line. One behavior per test.

## Mocking

- Mock at the boundary (HTTP, DB, clock, randomness), never the unit under test.
- Reset mocks between tests (`afterEach(() => jest.resetAllMocks())`).
- Use fake timers for time-dependent code.

## UI tests (React Testing Library)

- Query by role and accessible name: `getByRole("button", { name: /submit/i })`.
- Use `userEvent` over `fireEvent`.
- Assert what the user sees, not component state.

## Do not

- Snapshot large trees as the only assertion.
- Depend on test order or shared mutable state.
- Hit real network or real databases in unit tests.
