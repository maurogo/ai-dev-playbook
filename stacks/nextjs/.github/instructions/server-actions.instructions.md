---
applyTo: "**/actions/**/*.ts,**/*-action.ts,**/app/**/route.ts"
description: Server Actions and Route Handlers — validation, authorization, error handling.
---

# Server Actions and Route Handlers

Treat every Server Action and Route Handler as a **public HTTP endpoint**.

## Rules

1. `"use server"` at the top of action files. Name files `<verb>-<noun>-action.ts`.
2. **Validate input** with a schema (Zod) first. Never trust `FormData` or JSON shape.
3. **Authorize** inside the action. Never rely on the UI hiding a button.
4. **Server decides sensitive values** (IDs of targets, prices, roles). The client sends intent, not trusted data.
5. Return a typed result; do not throw to the client:

```ts
type ActionResult<T> = { success: true; data: T } | { success: false; message: string; fieldErrors?: Record<string, string[]> };
```

6. Wrap external calls in `try/catch`; log with context server-side; return a generic message to the client.
7. Mutations use `cache: "no-store"` and then `revalidateTag`/`revalidatePath` for affected data.
8. Bot-facing forms verify CAPTCHA/rate limits server-side before doing any work.

## Template

```ts
"use server";

import { z } from "zod";

const schema = z.object({ email: z.string().email(), message: z.string().min(1).max(2000) });

export default async function sendContactAction(formData: FormData): Promise<ActionResult<null>> {
  const parsed = schema.safeParse(Object.fromEntries(formData));
  if (!parsed.success) {
    return { success: false, message: "Invalid input", fieldErrors: parsed.error.flatten().fieldErrors };
  }

  try {
    await deliverContact(parsed.data);
    return { success: true, data: null };
  } catch (error) {
    console.error("sendContactAction failed", { error });
    return { success: false, message: "Something went wrong. Please try again." };
  }
}
```
