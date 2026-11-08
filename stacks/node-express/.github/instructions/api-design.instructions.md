---
applyTo: "src/**/routes/**/*.ts,src/**/*.routes.ts,src/**/*.controller.ts"
description: HTTP API design for Node/Express services.
---

# API design

## Layering (per domain)

```text
src/orders/
├── orders.routes.ts      // HTTP wiring only: path, middleware, call controller
├── orders.controller.ts  // parse + validate request, call service, map to response
├── orders.service.ts     // business rules, no req/res
├── orders.repository.ts  // persistence only
├── orders.schemas.ts     // Zod schemas → inferred types
└── __tests__/
```

Request/response objects never reach the service layer.

## Conventions

- Resource-oriented URLs, plural nouns: `GET /orders/:id`, `POST /orders`.
- Validate `params`, `query`, and `body` with Zod in a middleware; reject with **422** and field errors.
- Status codes: 200 read, 201 create (with `Location`), 204 no body, 400 malformed, 401 unauthenticated,
  403 forbidden, 404 missing, 409 conflict, 422 validation, 500 unexpected.
- Consistent error body: `{ "error": { "code": "ORDER_NOT_FOUND", "message": "...", "details"?: {} } }`.
- Pagination: `?limit=&cursor=`; return `{ data, nextCursor }`.
- Never return internal fields (password hashes, internal IDs not meant for clients). Map to DTOs.

## Testing

Use Supertest against the app instance (no real port): status, body shape, and that the service
was called with the validated input.
