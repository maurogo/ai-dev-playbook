---
applyTo: "**/next.config.*,**/app/**/page.tsx,**/app/**/layout.tsx,**/app/**/route.ts,**/lib/**/*.ts"
description: Next.js caching layers and rules. Read before touching data fetching or revalidation.
---

# Caching (Next.js App Router)

Caching has **independent layers**; fixing one does not fix the others:

| Layer | Controlled by |
|-------|---------------|
| Route (ISR / static vs dynamic) | `export const revalidate`, use of dynamic APIs (`cookies()`, `headers()`, `searchParams`) |
| Data fetch cache | `fetch(url, { next: { revalidate, tags } })` or `"use cache"` |
| Request dedup | Same `fetch` within one render is deduped automatically |
| CDN / edge | `Cache-Control` headers, CDN invalidation |

## Rules

1. **Cache by intent, not HTTP method.** A POST that *reads* (search with a body) gets
   `next: { revalidate, tags }`. Every *mutation* gets `cache: "no-store"`.
2. **Tag every cached read** with stable, domain-based tags (`product:123`, `products`) so it can be
   invalidated precisely.
3. **Invalidate on write**: after a mutation, call `revalidateTag` for the affected tags. Use a
   protected webhook route (`/api/revalidate` with a secret) for changes made outside the app (CMS).
4. Reading `cookies()`/`headers()` makes the route dynamic. Keep those reads in the smallest component
   possible and wrap in `<Suspense>`.
5. Pick `revalidate` per data volatility (e.g. 60s for listings, 1 day for static content) and write
   the reason in a comment.
6. After changing caching, verify with `next build` output (`○` static, `ƒ` dynamic) and response
   `cache-control` headers. Do not claim a page is cached without checking.
