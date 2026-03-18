---
title: Upstash Redis — Rate Limiting
version: 1.0.0
status: active
description: How IsoStack uses Upstash Redis for rate limiting, account lock tracking, and DDoS protection
---

# Upstash Redis — Rate Limiting

IsoStack uses [Upstash Redis](https://upstash.com) as the rate limiting layer for all server-side endpoints. It sits between incoming requests and the application/database layer, acting as a traffic governor that prevents abuse, brute-force attacks, and accidental overload.

**Status as of March 2026:** Infrastructure fully built — wiring pending. See [Current Status](#current-status).

---

## Why Redis for Rate Limiting?

Rate limiting requires:
- **Atomic counters** — increment and check must happen in a single operation
- **Millisecond precision** — response must be near-instant, not database-query speed
- **Short-lived keys** — counters expire automatically (sliding windows)
- **Cross-region consistency** — must work across all serverless instances

Postgres is too slow and expensive for this job. In-memory counters don't survive serverless cold starts or scale across regions. Redis is the industry standard, and Upstash is the serverless-native Redis provider — pay-per-use, globally distributed, no persistent connections.

---

## Environment Variables

| Variable | Visibility | Purpose |
|----------|-----------|---------|
| `UPSTASH_REDIS_REST_URL` | Server-only | Upstash REST endpoint URL |
| `UPSTASH_REDIS_REST_TOKEN` | Server-only | Upstash REST API token |

**Per-environment setup:**
- Each environment (Dev, TechTest, Staging, Production) should have its **own Upstash database** to prevent rate limit state bleeding between environments
- Create databases at [console.upstash.com](https://console.upstash.com) — free tier supports multiple databases
- Local dev: use real Upstash credentials (free tier), OR leave `UPSTASH_REDIS_REST_URL` pointing to `localhost` to auto-disable rate limiting via the guard in `src/lib/rate-limit.ts`

---

## Implementation Files

| File | Purpose |
|------|---------|
| `src/lib/rate-limit.ts` | Upstash `Ratelimit` instances, account lock helpers, `safeRateLimit()` wrapper |
| `src/lib/rate-limit-middleware.ts` | `withRateLimit()` middleware function, per-route limiter map |

---

## Limiters Defined

| Limiter | Limit | Window | Intended Use |
|---------|-------|--------|--------------|
| `authRateLimiter` | 5 req | 1 minute | Sign-in, credentials callback |
| `signupRateLimiter` | 3 req | 1 hour | New account creation |
| `apiRateLimiter` | 100 req | 1 minute | All tRPC requests (per IP) |
| `sensitiveRateLimiter` | 20 req | 1 hour | Password reset, forgot password |
| `globalDDoSLimiter` | 500 req | 1 minute | Global catch-all per IP |

All limiters use a **sliding window** algorithm — smoother and more accurate than fixed windows for bursty traffic.

---

## Route Limiter Map

`rate-limit-middleware.ts` maps URL path prefixes to specific limiters:

| Route pattern | Limiter |
|--------------|---------|
| `/api/auth/signin` | `authRateLimiter` |
| `/api/auth/callback/credentials` | `authRateLimiter` |
| `/api/auth/signup` | `signupRateLimiter` |
| `/api/auth/forgot-password` | `sensitiveRateLimiter` |
| `/api/auth/reset-password` | `sensitiveRateLimiter` |
| `/api/trpc/*` (all other) | `apiRateLimiter` |
| Everything else | `globalDDoSLimiter` |

---

## Account Lock Tracking

`rate-limit.ts` also contains account-level brute force protection via Redis keys:

| Function | Behaviour |
|----------|-----------|
| `checkAccountLock(email)` | Returns `{ isLocked, message }` — locks after 10 failed attempts within 30 minutes |
| `trackFailedLogin(email)` | Increments failed attempt counter (TTL 30 min) |
| `resetFailedLogins(email)` | Deletes the counter on successful login |

These are **not yet wired** into the credentials sign-in flow. See wiring instructions below.

---

## Wiring Plan

The infrastructure is built but not connected to the request path. When ready to wire:

### Step 1 — tRPC handler

**File:** `src/app/api/trpc/[trpc]/route.ts`

```typescript
import { withRateLimit } from '@/lib/rate-limit-middleware';

export async function POST(req: NextRequest, ctx: { params: { trpc: string } }) {
  return withRateLimit(req, () => handler(req, ctx));
}

export async function GET(req: NextRequest, ctx: { params: { trpc: string } }) {
  return withRateLimit(req, () => handler(req, ctx));
}
```

### Step 2 — Credentials sign-in

**File:** `src/server/auth/index.ts` — in the `credentials` provider `authorize` callback:

```typescript
// Before checking password:
const lockStatus = await checkAccountLock(credentials.email);
if (lockStatus.isLocked) {
  throw new Error(lockStatus.message);
}

// After failed login:
await trackFailedLogin(credentials.email);

// After successful login:
await resetFailedLogins(credentials.email);
```

### Step 3 — Local dev guard

If `UPSTASH_REDIS_REST_URL` points to localhost, rate limiting auto-disables. To make this explicit, add to `rate-limit.ts`:

```typescript
const RATE_LIMIT_ENABLED = !!(
  process.env.UPSTASH_REDIS_REST_URL &&
  process.env.UPSTASH_REDIS_REST_TOKEN &&
  !process.env.UPSTASH_REDIS_REST_URL.includes('localhost')
);

export async function safeRateLimit(
  limiter: Ratelimit,
  identifier: string
): Promise<{ success: boolean }> {
  if (!RATE_LIMIT_ENABLED) return { success: true };
  return checkRateLimit(limiter, identifier);
}
```

### Step 4 — Auth route handlers

**Files to check:** `src/app/api/auth/[...nextauth]/route.ts` and any custom `/api/auth/*` routes. Apply `withRateLimit` to each handler.

---

## Response Behaviour When Rate Limited

When a request is blocked, `withRateLimit()` returns:
- HTTP status: `429 Too Many Requests`
- Headers: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`
- Body: JSON with `error: "Too many requests"` and `retryAfter` seconds

---

## Current Status

| Item | Status |
|------|--------|
| `src/lib/rate-limit.ts` built | ✅ Done |
| `src/lib/rate-limit-middleware.ts` built | ✅ Done |
| Env vars in Render (TechTest, Staging, Production) | ✅ Present |
| `withRateLimit()` wired into tRPC handler | ❌ Not done |
| Account lock wired into sign-in | ❌ Not done |
| Auth route handlers wrapped | ❌ Not done |
| Local dev env vars pointing to real Upstash | ❌ Still using localhost dummy |

**Full wiring spec:** `docs/BETA-TODOs/rate-limiting.md` in `isostack-bedrock`

---

## Module Usage

Rate limiting protects all modules equally through the tRPC handler. Module-specific considerations:

- **APIKeyChain** — particularly critical; proxies third-party API calls and holds secrets. Rate limiting prevents upstream API abuse, credential stuffing, and cost spikes
- **Bedrock** — prevents excessive dataset refresh triggers
- **LMSPro** — protects club registration submit endpoint (also covered by Cloudflare Turnstile)
- **TailorAid** — limits AI generation calls to control cost

---

## Related

- `docs/00-overview/architecture.md` — Section 14.1
- `docs/00-overview/cloudflare-turnstile.md` — Bot protection on public forms
- `docs/BETA-TODOs/rate-limiting.md` (isostack-bedrock) — Detailed wiring CR
