# Stripe Payment Gateway — Implementation Plan

**Status:** 📋 Ready to Execute  
**Created:** 9 March 2026  
**Currency:** GBP only  
**Billing Model:** Both platform-assigned (comped/trial) AND self-service (client-initiated checkout)  
**Subscription Scope:** Per `OrganizationProduct` — one Stripe subscription per product assigned to an org  
**Client Billing Page:** Self-service with PDF invoice downloads  

---

## Architecture Overview

```
Client Browser
     │
     ├── /billing          → Shows active products, Stripe-managed subscriptions
     │                        Self-service checkout + Stripe Customer Portal
     │
     └── /pricing          → Public product listing → triggers checkout

     tRPC billing.router
     │
     ├── createCheckoutSession     → Stripe Checkout (new subscription)
     ├── createCustomerPortalSession → Stripe Portal (manage/cancel/download)
     └── listInvoices              → Stripe API invoice history

     Stripe Webhooks → /api/stripe/webhook
     │
     ├── checkout.session.completed       → assignProductToOrganization (ACTIVE)
     ├── customer.subscription.updated    → update OrganizationProduct status
     ├── customer.subscription.deleted    → CANCELLED + disable modules
     ├── invoice.payment_failed           → flag as past_due
     └── invoice.payment_succeeded        → ensure ACTIVE, extend expiresAt

     Platform Admin (P1)
     └── /platform/clients/[id]/products → assign COMPED/TRIAL manually
                                           (no Stripe, existing flow unchanged)
```

### Key Principle
- Platform-assigned products (comped/trial by P1) → **no Stripe involvement**, existing `assignProductToOrganization()` flow unchanged
- Self-service purchases → Stripe Checkout → webhook → calls `assignProductToOrganization()`
- Stripe is the source of truth for **billing state only**; IsoStack `OrganizationProduct` remains source of truth for **access control**

---

## Pre-Implementation Checklist

- [ ] Stripe account created and in test mode
- [ ] Stripe CLI installed locally for webhook testing (`brew install stripe/stripe-cli/stripe`)
- [ ] `.env.local` has placeholder vars (see Phase 2)
- [ ] All `ProductPackage` records seeded in dev database (`npm run seed:products`)

---

## Phase 1 — Schema Migration
**Estimated time: 30 min**  
**File:** `prisma/schema.prisma` + migration

### Changes Required

**1a. Add to `Organization` model:**
```prisma
stripeCustomerId String? @unique @map("stripe_customer_id")
```

**1b. Add to `OrganizationProduct` model:**
```prisma
stripeSubscriptionId  String?  @unique @map("stripe_subscription_id")
stripePriceId         String?  @map("stripe_price_id")
billingInterval       String?  @map("billing_interval")  // "month" | "year"
```

**1c. Add to `ProductPackage` model:**
```prisma
stripePriceMonthly  String?  @map("stripe_price_monthly")  // e.g. price_xxx
stripePriceYearly   String?  @map("stripe_price_yearly")   // e.g. price_xxx
```

### Migration Command
```bash
npm run db:migrate:dev -- --name add_stripe_billing_fields
```

### Test
- Open Prisma Studio: `npm run db:studio`
- Verify new columns exist on `organizations`, `organization_products`, `product_packages`

---

## Phase 2 — Package Install & Environment
**Estimated time: 15 min**

### Install
```bash
npm install stripe
```

### Environment Variables
Add to `.env.local` (dev) and Render environment (deployed):

```env
# Stripe
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
```

**Note:** Use `sk_test_` / `pk_test_` keys during development. Switch to live keys for production deployment only.

### Render Config
Add the three vars to:
- TechTest environment
- Staging environment  
- Production environment (live keys only)

---

## Phase 3 — Stripe Singleton Client
**Estimated time: 15 min**  
**New file:** `src/lib/stripe.ts`

```typescript
import Stripe from 'stripe';

if (!process.env.STRIPE_SECRET_KEY) {
  throw new Error('STRIPE_SECRET_KEY is not set');
}

export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY, {
  apiVersion: '2024-06-20',
  typescript: true,
});
```

Import this wherever Stripe is needed — never instantiate `new Stripe(...)` directly elsewhere.

---

## Phase 4 — Stripe Dashboard Setup
**Estimated time: 1 hr**

This must be done before Phase 5/6 so Price IDs exist to store.

### 4a. Create Products in Stripe Dashboard

For each `ProductPackage` in the database, create a matching Stripe Product:

| IsoStack Product | Stripe Product Name | Monthly Price (GBP) | Yearly Price (GBP) |
|---|---|---|---|
| LMSPro Starter | LMSPro Starter | £49/mo | £490/yr |
| LMSPro Pro | LMSPro Pro | £149/mo | £1,490/yr |
| LMSPro Enterprise | LMSPro Enterprise | £499/mo | £4,990/yr |
| Bedrock Starter | Bedrock Starter | £99/mo | £990/yr |
| Bedrock Enterprise | Bedrock Enterprise | £299/mo | £2,990/yr |
| Pulse Starter | Pulse Starter | £79/mo | £790/yr |
| Pulse Pro | Pulse Pro | £199/mo | £1,990/yr |
| Pulse Enterprise | Pulse Enterprise | £399/mo | £3,990/yr |
| Platform Enterprise Bundle | Platform Enterprise Bundle | £999/mo | £9,990/yr |

**Steps in Stripe Dashboard:**
1. Products → Add Product → enter name + description
2. Add two prices per product: one `Recurring/Monthly` (GBP), one `Recurring/Yearly` (GBP)
3. Copy each Price ID (`price_xxx`) — you'll need them in step 4b

### 4b. Seed Price IDs into Database

After creating prices in Stripe, update each `ProductPackage` record via a script or Prisma Studio:

```typescript
// scripts/seed-stripe-price-ids.ts
// Run once after Stripe products are created: npx tsx scripts/seed-stripe-price-ids.ts

const PRICE_MAP = [
  { slug: 'lmspro-starter',       monthly: 'price_xxx', yearly: 'price_xxx' },
  { slug: 'lmspro-pro',           monthly: 'price_xxx', yearly: 'price_xxx' },
  { slug: 'lmspro-enterprise',    monthly: 'price_xxx', yearly: 'price_xxx' },
  { slug: 'bedrock-starter',      monthly: 'price_xxx', yearly: 'price_xxx' },
  { slug: 'bedrock-enterprise',   monthly: 'price_xxx', yearly: 'price_xxx' },
  { slug: 'pulse-starter',        monthly: 'price_xxx', yearly: 'price_xxx' },
  { slug: 'pulse-pro',            monthly: 'price_xxx', yearly: 'price_xxx' },
  { slug: 'pulse-enterprise',     monthly: 'price_xxx', yearly: 'price_xxx' },
  { slug: 'platform-enterprise',  monthly: 'price_xxx', yearly: 'price_xxx' },
];
```

This script will be created and populated with real Price IDs once Stripe products are set up.

### 4c. Configure Webhook Endpoint

In Stripe Dashboard → Developers → Webhooks:
- **Endpoint URL:** `https://techtest.isostack.app/api/stripe/webhook`
- **Events to listen for:**
  - `checkout.session.completed`
  - `customer.subscription.updated`
  - `customer.subscription.deleted`
  - `invoice.payment_succeeded`
  - `invoice.payment_failed`
- Copy the **Webhook Signing Secret** (`whsec_...`) → goes in `STRIPE_WEBHOOK_SECRET`

For local dev, use Stripe CLI:
```bash
stripe listen --forward-to localhost:3000/api/stripe/webhook
```

---

## Phase 5 — tRPC Billing Router
**Estimated time: 2 hrs**  
**New file:** `src/server/core/routers/billing.router.ts`  
**Edit:** `src/server/core/routers/index.ts` (register router)

### Procedures to Implement

**5a. `createCheckoutSession`** (protected, any authenticated user)
- Input: `{ packageId, billingInterval: 'month' | 'year' }`
- Finds or creates a Stripe Customer linked to `organization.stripeCustomerId`
- Looks up the correct `stripePriceMonthly` or `stripePriceYearly` from `ProductPackage`
- Creates `stripe.checkout.sessions.create()` with:
  - `mode: 'subscription'`
  - `customer: stripeCustomerId`
  - `line_items: [{ price: priceId, quantity: 1 }]`
  - `metadata: { organizationId, packageId }` ← **critical for webhook**
  - `success_url`, `cancel_url`
- Returns `{ url: session.url }` → frontend redirects to Stripe Checkout

**5b. `createCustomerPortalSession`** (protected)
- Input: none (uses session org)
- Requires `organization.stripeCustomerId` to exist (throws if not)
- Creates `stripe.billingPortal.sessions.create()`
- Returns `{ url: session.url }` → frontend redirects to Stripe Portal
- Portal handles: invoice downloads, card updates, cancellations

**5c. `getSubscriptions`** (protected)
- Returns all `OrganizationProduct` records for current org
- Includes `package.name`, `status`, `stripeSubscriptionId`, `billingInterval`
- Used by the billing page to show current subscriptions

**5d. `listInvoices`** (protected)
- Requires `stripeCustomerId`; returns `[]` gracefully if not set
- Calls `stripe.invoices.list({ customer: stripeCustomerId, limit: 24 })`
- Returns: `id`, `created`, `amount_due`, `currency`, `status`, `invoice_pdf`, `description`
- Frontend renders table with PDF download link per row

### Registration in `index.ts`
```typescript
import { billingRouter } from './billing.router';
// Add to appRouter:
billing: billingRouter,
```

---

## Phase 6 — Webhook Handler
**Estimated time: 3 hrs**  
**New file:** `src/app/api/stripe/webhook/route.ts`

### Implementation Notes

- Must use `req.text()` (raw body) for signature verification — **never parse JSON first**
- Use `stripe.webhooks.constructEvent(body, sig, process.env.STRIPE_WEBHOOK_SECRET!)`
- All handlers should be idempotent (safe to receive same event twice)
- Wrap each handler in try/catch; log errors but return `200` to Stripe to prevent retries on permanent failures

### Event Handlers

**`checkout.session.completed`**
```
1. Extract metadata.organizationId + metadata.packageId
2. Get subscription ID from session.subscription
3. Get price ID from session (line_items)
4. Determine billingInterval from price.recurring.interval
5. Call assignProductToOrganization({ organizationId, packageId, status: ACTIVE, startTrial: false })
6. UPDATE OrganizationProduct SET stripeSubscriptionId, stripePriceId, billingInterval
7. UPDATE Organization SET stripeCustomerId (if not already set)
8. Audit log: STRIPE_SUBSCRIPTION_CREATED
```

**`customer.subscription.updated`**
```
1. Find OrganizationProduct by stripeSubscriptionId
2. Map Stripe status → IsoStack ProductStatus:
   - 'active'    → ACTIVE
   - 'past_due'  → leave as ACTIVE (grace period), add metadata flag
   - 'cancelled' → CANCELLED (also fires subscription.deleted)
   - 'trialing'  → TRIAL
3. UPDATE OrganizationProduct.status
4. If cancelled/expired: disable modules via prisma.organisationModule.updateMany
5. Audit log: STRIPE_SUBSCRIPTION_UPDATED
```

**`customer.subscription.deleted`**
```
1. Find OrganizationProduct by stripeSubscriptionId
2. Call cancelProductForOrganization (existing function in access-control.ts)
3. Audit log: STRIPE_SUBSCRIPTION_CANCELLED
```

**`invoice.payment_succeeded`**
```
1. Find OrganizationProduct by stripeSubscriptionId (from invoice.subscription)
2. Ensure status is ACTIVE
3. Clear any past_due flags in metadata
4. Set expiresAt = null (continuous subscription, no fixed expiry)
5. Audit log: STRIPE_PAYMENT_SUCCEEDED
```

**`invoice.payment_failed`**
```
1. Find OrganizationProduct by stripeSubscriptionId
2. Store failure count in metadata
3. After 3 failures (or Stripe's own cancellation): set EXPIRED, disable modules
4. Audit log: STRIPE_PAYMENT_FAILED
```

### Webhook Route Structure
```typescript
export async function POST(req: Request) {
  const body = await req.text();
  const sig = req.headers.get('stripe-signature')!;
  
  let event: Stripe.Event;
  try {
    event = stripe.webhooks.constructEvent(body, sig, process.env.STRIPE_WEBHOOK_SECRET!);
  } catch (err) {
    return new Response(`Webhook Error: ${err}`, { status: 400 });
  }

  try {
    switch (event.type) {
      case 'checkout.session.completed': ...
      case 'customer.subscription.updated': ...
      case 'customer.subscription.deleted': ...
      case 'invoice.payment_succeeded': ...
      case 'invoice.payment_failed': ...
      default:
        console.log(`Unhandled event type: ${event.type}`);
    }
  } catch (err) {
    console.error(`Error handling ${event.type}:`, err);
    // Still return 200 — Stripe will retry on non-200
  }

  return new Response('OK', { status: 200 });
}
```

---

## Phase 7 — Client Billing Page
**Estimated time: 3 hrs**  
**Edit:** `src/app/(app)/billing/page.tsx` (full replacement of placeholder)

### Page Sections

**7a. Active Subscriptions**
- `trpc.billing.getSubscriptions.useQuery()` 
- Card per product: name, status badge, billing interval, next payment date
- "Manage / Cancel" button → `createCustomerPortalSession` → redirect

**7b. Add a Product (Self-Service Checkout)**
- Lists available `ProductPackage` records not yet subscribed
- Monthly / Yearly toggle
- "Subscribe" button → `createCheckoutSession` → redirect to Stripe Checkout
- After success, Stripe redirects back to `/billing?success=true` → show confirmation banner

**7c. Invoice History**
- `trpc.billing.listInvoices.useQuery()`
- Table: Date | Description | Amount | Status | Actions
- Each row has a "Download PDF" link (opens `invoice_pdf` URL from Stripe — Stripe-hosted PDF, no generation needed)
- If `stripeCustomerId` is null (platform-comped org): show "Contact your account manager for invoices"

**7d. Payment Method**
- "Update Payment Method" button → `createCustomerPortalSession` → redirect
- Note: Card details are never stored in IsoStack — Stripe Portal handles this entirely

### Empty State
If org has no `stripeCustomerId` and no self-service subscriptions:
- Show available products with "Get Started" CTAs
- Explain any platform-assigned products (trials) with upgrade path

---

## Phase 8 — Testing
**Estimated time: 2 hrs**

### Local Testing with Stripe CLI

```bash
# Terminal 1: Run app
npm run dev

# Terminal 2: Forward webhooks
stripe listen --forward-to localhost:3000/api/stripe/webhook

# Terminal 3: Trigger test events
stripe trigger checkout.session.completed
stripe trigger customer.subscription.deleted
stripe trigger invoice.payment_failed
```

### Test Scenarios

| Scenario | Steps | Expected Result |
|---|---|---|
| New self-service subscription | Click Subscribe → Stripe test card `4242 4242 4242 4242` → complete | `OrganizationProduct` created with `ACTIVE` status |
| Webhook: subscription cancelled | `stripe trigger customer.subscription.deleted` | Status → `CANCELLED`, modules disabled |
| Webhook: payment failed | `stripe trigger invoice.payment_failed` | Metadata flagged, audit log created |
| Customer portal | Click "Manage Billing" | Redirect to Stripe Portal |
| Invoice PDF download | Click download on invoice row | Opens Stripe-hosted PDF |
| Platform-comped org | No stripeCustomerId | Invoice section shows "Contact account manager" |

### Test Card Numbers (Stripe)
- `4242 4242 4242 4242` — successful payment
- `4000 0000 0000 9995` — card declined
- `4000 0025 0000 3155` — requires authentication (3DS)

---

## File Change Summary

| File | Action | Phase |
|---|---|---|
| `prisma/schema.prisma` | Edit — add 5 new nullable fields | 1 |
| `prisma/migrations/...add_stripe_billing_fields` | New — auto-generated | 1 |
| `src/lib/stripe.ts` | **New** — Stripe singleton | 3 |
| `scripts/seed-stripe-price-ids.ts` | **New** — populate Price IDs after Stripe setup | 4 |
| `src/server/core/routers/billing.router.ts` | **New** — 4 tRPC procedures | 5 |
| `src/server/core/routers/index.ts` | Edit — register billing router | 5 |
| `src/app/api/stripe/webhook/route.ts` | **New** — webhook handler | 6 |
| `src/app/(app)/billing/page.tsx` | Edit — replace placeholder with real UI | 7 |

**Total new files: 4 | Edited files: 4**

---

## Deployment Sequence (TechTest → Staging → Production)

1. Merge `dev` → `techtest` 
2. Apply migration: `npm run db:migrate` (Render Shell on TechTest)
3. Add env vars to Render TechTest
4. Create Stripe **test mode** products + configure webhook pointing to `techtest.isostack.app`
5. Run `scripts/seed-stripe-price-ids.ts` against TechTest DB
6. Smoke test all scenarios in the test table above
7. Merge to `staging` → repeat steps 2-6
8. For production: create Stripe **live mode** products, swap to live keys, merge to `main`

---

## Decisions / Assumptions

| Decision | Rationale |
|---|---|
| One Stripe Customer per Organization | Simplest model; org pays, not individual users |
| One Stripe Subscription per OrganizationProduct | Allows per-product billing, cancellation, and upgrade independently |
| Platform-comped products bypass Stripe entirely | P1 workflow unchanged; no accidental billing |
| `stripeCustomerId` stored on `Organization` | Single customer across all their subscriptions |
| Stripe Portal handles card/cancellation | No need to build custom payment forms; PCI compliance handled by Stripe |
| Invoice PDFs served from Stripe | `invoice_pdf` URL from Stripe API — no S3/R2 storage needed |
| `billingInterval` stored on `OrganizationProduct` | Needed to display "£149/mo" vs "£1,490/yr" in UI without re-querying Stripe |

---

## Out of Scope (Future)

- Upgrade/downgrade between tiers (swap `packageId` on existing subscription)
- Proration handling
- Multi-currency support (GBP only for now)
- Usage-based billing
- Team seat limits enforced at Stripe level
- Dunning email sequences (Stripe handles basic failed payment emails)
