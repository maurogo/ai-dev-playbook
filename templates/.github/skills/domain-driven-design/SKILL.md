---
name: domain-driven-design
description: Use when creating new folders or modules, moving code, or deciding where a new function, type, or component belongs. Explains organizing code by business domain instead of technical type.
---

# Domain-driven folder structure

## Principle

Group code by **what it is about** (orders, billing, users), not **what kind of file it is**
(components, services, utils). Everything needed to change one business capability should live
close together.

```text
✅ By domain                         ❌ By type
src/                                 src/
├── orders/                          ├── components/
│   ├── components/order-summary/    ├── services/
│   ├── api.ts                       ├── utils/
│   ├── pricing.ts                   ├── types/
│   ├── types.ts                     └── helpers/
│   └── __tests__/pricing.test.ts
├── billing/
└── shared/ui/        (truly generic, domain-free pieces only)
```

## Rules

1. A new concept gets a domain folder named after the business term the team uses.
2. Domain-specific helpers stay inside the domain. `shared/` is only for code with zero domain knowledge.
3. Each domain exposes a small public surface (`index.ts`); other domains import from it, not from internals.
4. Dependencies point one way. If `orders` imports `billing` and `billing` imports `orders`, extract the
   shared concept or invert with an interface.
5. External integrations (third-party APIs, DB) get their own domain folder with a thin client,
   so the rest of the app never sees raw responses.
6. Tests sit in the domain's `__tests__/`.

## Deciding where code goes

| Question | Answer → location |
|----------|-------------------|
| Does it mention a business term? | That domain's folder |
| Used by 2+ domains and has no business meaning? | `shared/` |
| Wraps an external API? | `<provider>/` integration domain |
| Only used by one component? | Next to that component (`helpers.ts`, `constants.ts`) |

## Smells

- Folders named `utils`, `helpers`, `misc`, `common` growing past a few files.
- A change to one feature touching 5+ top-level folders.
- Circular imports between domains.
