---
applyTo: "src/**/*.ts"
description: Error handling, logging, and configuration for Node services.
---

# Error handling

- Define domain errors extending a base `AppError` with `statusCode` and `code`.
- Services throw domain errors; one central Express error middleware maps them to HTTP.
  Unknown errors → 500 with a generic message; log the full error server-side.
- Async route handlers must forward rejections (Express 5 does it natively; on Express 4 use a wrapper).
- Never swallow errors silently. If you catch, either handle meaningfully or rethrow with context.
- Handle `unhandledRejection` / `uncaughtException`: log, then exit and let the supervisor restart.

# Logging

- Structured JSON logs (pino). Include a request ID on every log line.
- Never log secrets, tokens, passwords, or full request bodies with personal data.

# Configuration

- Read env vars once at startup, validate with Zod, export a typed `config` object.
- Fail fast on missing required config.
