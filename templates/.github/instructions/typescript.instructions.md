---
applyTo: "**/*.ts,**/*.tsx,**/*.mts,**/*.cts"
description: TypeScript rules for all source files.
---

# TypeScript

## Types

- `strict` is on. Never use `any`. Use `unknown` at untrusted boundaries and narrow it.
- Model domain data with `interface` (object shapes) or `type` (unions, mapped types).
- Shared types live in the domain's `types.ts`, not inside components or route handlers.
- Validate external input (HTTP bodies, env vars, third-party responses) at the boundary
  with a schema (e.g. Zod) and derive the type from the schema.
- Prefer discriminated unions over boolean flags for states:
  `type Result<T> = { ok: true; data: T } | { ok: false; error: string }`.

## Style

- Destructure objects in parameters and loops: `for (const { id, name } of users)`.
- Early returns over nested conditionals.
- `const` by default; no `var`.
- No non-null assertions (`!`) unless a comment explains why it is safe.
- Absolute imports via `@/`. Group: external → internal → relative → types; sort alphabetically.

## Naming

| Thing | Convention | Example |
|-------|------------|---------|
| Files, folders | kebab-case | `user-profile.ts` |
| Types, interfaces, components | PascalCase | `UserProfile` |
| Functions, variables | camelCase | `getUserById` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRIES` |

## Errors

- Wrap every `await` that crosses a process boundary in `try/catch`, or return a `Result`.
- Log with context (`{ userId, operation }`); never log secrets or full request bodies.
- Throw `Error` subclasses with a clear message, not strings.

## Doc comments

Public functions get a short doc comment in English: what it does, params, return, errors.
