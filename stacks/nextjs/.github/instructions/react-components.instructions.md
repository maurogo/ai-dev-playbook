---
applyTo: "**/*.tsx"
description: React component structure, naming, and hook rules.
---

# React components

## Structure

- One component per folder: `src/<domain>/components/user-card/index.tsx`. Folder in kebab-case.
- `export default function UserCard(...)` in PascalCase. Barrel re-exports with a named alias:
  `export { default as UserCard } from "./user-card";`
- Props interface named `<Component>Props`, defined in the same file right above the component.
- The component file holds only the component and its props. Helpers → `helpers.ts`,
  constants → `constants.ts`, shared types → `types.ts` in the same folder.

```tsx
interface UserCardProps {
  user: User;
  className?: string;
}

export default function UserCard({ user, className }: UserCardProps) {
  const [expanded, setExpanded] = useState(false);

  if (!user.active) return null;

  return <article className={cn("rounded-lg p-4", className)}>…</article>;
}
```

## Hooks

- All hooks run before any early return.
- Custom hooks start with `use`, live in the domain (or `shared/hooks/`), and are tested.
- Derive values during render instead of syncing them with `useEffect`.
- `useEffect` only for real side effects (subscriptions, imperative APIs); always clean up.

## Server vs Client (App Router)

- Default to Server Components. Add `"use client"` only for state, effects, browser APIs, or handlers.
- Push `"use client"` to the leaves; pass server-fetched data down as props.
- Never import server-only modules (DB, secrets) into client components; mark them with `import "server-only"`.

## Accessibility

- Semantic elements first (`button`, `nav`, `main`, `article`); ARIA only to fill gaps.
- Every interactive element is keyboard-reachable and has an accessible name.
- Images have meaningful `alt` (or `alt=""` if decorative).
