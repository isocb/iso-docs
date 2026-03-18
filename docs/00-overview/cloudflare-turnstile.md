---
title: Cloudflare Turnstile — Bot & Spam Protection
version: 1.0.0
status: active
description: How IsoStack uses Cloudflare Turnstile to protect public-facing forms from bots and spam submissions
---

# Cloudflare Turnstile — Bot & Spam Protection

IsoStack uses [Cloudflare Turnstile](https://www.cloudflare.com/products/turnstile/) to protect public-facing forms from automated submissions, bots, and spam.

**Status as of March 2026:** Implemented on all current public forms (LMSPro club registration).

---

## What is Turnstile?

Turnstile is Cloudflare's CAPTCHA alternative. Unlike reCAPTCHA or hCaptcha:

- **Invisible to legitimate users** — challenges are solved automatically by analysing browser signals
- **Privacy-respecting** — no user tracking, no data sold
- **Free** — no usage limits or pricing tiers for standard use
- **Zero maintenance** — Cloudflare rotates challenge logic automatically

When a form is submitted, the browser requests a one-time token from Cloudflare. The server verifies this token against Cloudflare's API before processing the submission. Bots that can't pass the challenge never receive a valid token.

---

## Environment Variables

| Variable | Visibility | Purpose |
|----------|-----------|---------|
| `NEXT_PUBLIC_TURNSTILE_SITE_KEY` | Public (browser) | Site key from Cloudflare dashboard — **safe to expose** |
| `TURNSTILE_SECRET_KEY` | Server-only | Secret key — **never expose to client** |

---

## Per-Environment Key Setup

Cloudflare validates the site key against the domain it's served from. A token issued for `app.yourdomain.com` will be rejected if the site key is only registered for `techtest.yourdomain.com`.

**You must create a separate Cloudflare Turnstile site per environment tier:**

| Environment | Cloudflare site | Hostnames to register |
|------------|----------------|----------------------|
| TechTest + Staging | Site 1 | `techtest.yourdomain.com`, `staging.yourdomain.com` |
| Production | Site 2 | `app.yourdomain.com` (and any custom domains) |

**Steps:**
1. Go to [dash.cloudflare.com → Turnstile](https://dash.cloudflare.com/?to=/:account/turnstile)
2. Click **Add site**
3. Enter the hostnames for that tier
4. Widget type: **Managed** (recommended — Cloudflare decides when to show a visible challenge)
5. Copy the **Site Key** and **Secret Key**
6. Add to the appropriate Render environment service(s)

**Render environment variables to set:**

| Render service | `NEXT_PUBLIC_TURNSTILE_SITE_KEY` | `TURNSTILE_SECRET_KEY` |
|---------------|----------------------------------|------------------------|
| TechTest | Site 1 site key | Site 1 secret key |
| Staging | Site 1 site key | Site 1 secret key |
| Production | Site 2 site key | Site 2 secret key |

---

## Local Development

Use Cloudflare's official always-pass test keys locally — no real Cloudflare account needed:

| Variable | Test value |
|----------|-----------|
| `NEXT_PUBLIC_TURNSTILE_SITE_KEY` | `1x00000000000000000000AA` |
| `TURNSTILE_SECRET_KEY` | `1x0000000000000000000000000000000AA` |

These keys always return a passing result and are [documented by Cloudflare](https://developers.cloudflare.com/turnstile/troubleshooting/testing/) for local/CI use.

---

## Implementation

### Server-side verification (`src/lib/turnstile.ts`)

```typescript
export async function verifyTurnstileToken(token: string): Promise<boolean>
```

Behaviour:
- Calls `https://challenges.cloudflare.com/turnstile/v0/siteverify` with the token
- Returns `true` if valid
- Returns `false` and logs a warning if invalid
- If `TURNSTILE_SECRET_KEY` is unset and `NODE_ENV !== 'production'`: returns `true` (graceful dev skip)
- If `TURNSTILE_SECRET_KEY` is unset in production: returns `false` and logs an error

### Client-side widget (`@marsidev/react-turnstile`)

```tsx
import { Turnstile } from '@marsidev/react-turnstile';

<Turnstile
  siteKey={process.env.NEXT_PUBLIC_TURNSTILE_SITE_KEY!}
  onSuccess={(token) => setCaptchaToken(token)}
  onExpire={() => setCaptchaToken(null)}
/>
```

### tRPC mutation pattern

Any tRPC mutation on a public form must:
1. Accept `captchaToken: z.string().min(1)` in the input schema
2. Call `verifyTurnstileToken(input.captchaToken)` before any processing
3. Throw `TRPCError({ code: 'BAD_REQUEST' })` if verification fails

```typescript
.input(z.object({
  // ... form fields
  captchaToken: z.string().min(1),
}))
.mutation(async ({ ctx, input }) => {
  const captchaValid = await verifyTurnstileToken(input.captchaToken);
  if (!captchaValid) {
    throw new TRPCError({ code: 'BAD_REQUEST', message: 'Invalid captcha. Please try again.' });
  }
  // ... process form
})
```

---

## Where It's Used

| Form | Route | File | Notes |
|------|-------|------|-------|
| Club registration (public) | `/register/club` | `src/app/(public)/register/club/page.tsx` | Step 4 (final step) |
| Club registration (embed) | `/embed/register/club` | `src/app/(embed)/embed/register/club/page.tsx` | Step 5 (final step) |

### Rules for future public forms

**All future forms accessible without authentication must include Turnstile.** This includes:
- Any new registration or enquiry forms
- Public-facing contact or application forms
- Any embedded widgets served to third-party sites

Forms behind authentication (tRPC `protectedProcedure`) do **not** need Turnstile — the session is already verified.

---

## UX Behaviour

- Widget appears on the final step, above the submit button
- Submit button is **disabled** until a valid token is received (`disabled={!captchaToken}`)
- If the token expires before submission, `onExpire` clears the token and re-disables the button
- On successful verification, the widget typically shows a green checkmark; the challenge is silent unless Cloudflare detects suspicious signals

---

## Current Status

| Item | Status |
|------|--------|
| `src/lib/turnstile.ts` server verification utility | ✅ Done |
| `@marsidev/react-turnstile` installed | ✅ Done |
| LMSPro club registration (public) | ✅ Implemented |
| LMSPro club registration (embed) | ✅ Implemented |
| Local dev test keys configured | ✅ Done |
| Render env vars (TechTest, Staging, Production) | ⚠️ Must be added manually per environment |

---

## Related

- `docs/00-overview/architecture.md` — Section 14.2
- `docs/00-overview/upstash-redis-rate-limiting.md` — Rate limiting (complements Turnstile)
- Cloudflare docs: [developers.cloudflare.com/turnstile](https://developers.cloudflare.com/turnstile/)
