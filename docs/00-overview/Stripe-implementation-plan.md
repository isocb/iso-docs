# Stripe Payment Gateway — Implementation Plan

**Status:** ✅ Phases 1–6 complete (June 2026) | Phase 7 (Client Billing Page) pending | Phase 8 (Team Bundle Add-ons) pending  
**Created:** 9 March 2026 | **Last updated:** 3 June 2026  
**Currency:** GBP only  
**Billing Model:** Both platform-assigned (comped/trial) AND self-service (client-initiated checkout)
**Subscription Scope:** Per `OrganizationProduct` — one Stripe subscription per product, with multiple line items (tier + optional bundles)
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
     ├── createCheckoutSession       → Stripe Checkout (new subscription)
     ├── createCustomerPortalSession → Stripe Portal (manage/cancel/download)
     └── getStatus                   → current subscription status for tenant

     tRPC products.router (P1 only)
     │
     ├── activateForOrganization     → comp a product (cancels Stripe sub if one exists)
     ├── updateOrgProduct            → set back to TRIAL (cancels Stripe sub if one exists)
     ├── extendTrial                 → add N days to trial
     └── cancelForOrganization       → cancel product + disable modules

     Stripe Webhooks → /api/webhooks/stripe
     │
     ├── checkout.session.completed       → ✅ sets ACTIVE, stores stripeSubscriptionId
     ├── customer.subscription.deleted    → ✅ sets EXPIRED, logs audit
     ├── invoice.payment_failed           → ✅ sets SUSPENDED, sends payment failed email
     ├── customer.subscription.updated    → ⏳ TODO
     └── invoice.payment_succeeded        → ⏳ TODO

     Platform Admin (P1)
     └── /platform/clients/[id] → Products tab → row-click modal
         ├── Assign (trial or comped)
         ├── Activate / Comp  (cancels Stripe sub automatically if one exists)
         ├── Extend trial (+N days)
         ├── Set back to trial (cancels Stripe sub automatically if one exists)
         ├── Unsuspend
         ├── Cancel
         └── History tab (full AuditLog timeline per product)
```

### Key Principle — Comped vs Paying
- **Comped** = `OrganizationProduct.status = ACTIVE` + `stripeSubscriptionId IS NULL`
- **Paying** = `OrganizationProduct.status = ACTIVE` + `stripeSubscriptionId = sub_xxx`
- Shown in P1 UI as **Manual / Comped** vs **Managed** badge in the Products table
- Stripe is source of truth for **billing state only**; IsoStack `OrganizationProduct` is source of truth for **access control**

### P1 Product Lifecycle — all transitions

| From | Action | Stripe effect |
|---|---|---|
| (none) | Assign → Trial | None |
| (none) | Assign → Active (Comped) | None |
| TRIAL | Activate / Comp | None |
| TRIAL | Extend trial | None |
| TRIAL | Set dates | None |
| ACTIVE (comped) | Set back to trial | None (no sub to cancel) |
| ACTIVE (paying) | Activate / Comp | **Cancels Stripe subscription** |
| ACTIVE (paying) | Set back to trial | **Cancels Stripe subscription** |
| SUSPENDED | Unsuspend | None |
| CANCELLED | Reactivate | None |
| Any | Cancel | None (Stripe sub already cancelled by webhook) |
| Trial org (self-service) | Stripe Checkout | Webhook → sets ACTIVE, stores sub ID |

---

## What Is Built (June 2026)

### ✅ Phase 1 — Schema
Fields added to DB via migration `20260602142038_add_stripe_fields`:
- `Organization.stripeCustomerId`
- `OrganizationProduct.stripeSubscriptionId`
- `OrganizationProduct.stripeCheckoutSessionId`
- `ProductPackage.stripePriceIdMonthly`
- `ProductPackage.stripePriceIdYearly`
- `ProductPackage.priceMonthly` / `priceYearly` / `currency` (used for MRR/ARR calculations)

### ✅ Phase 2 — Environment vars
See **Environment Variables** section below.

### ✅ Phase 3 — Stripe singleton
`src/lib/stripe.ts` — lazy singleton, fails at call-time (not build-time) if key missing.

### ✅ Phase 4 — Stripe Dashboard setup
Partially complete — see **Stripe Dashboard Setup** section below for what still needs doing per environment.

### ✅ Phase 5 — tRPC billing router
`src/server/core/routers/billing.router.ts`:
- `createCheckoutSession` — finds/creates Stripe Customer, creates Checkout session
- `createPortalSession` — creates Billing Portal session
- `getStatus` — returns current subscription status + trial days remaining

### ✅ Phase 6 — Webhook handler
`src/app/api/webhooks/stripe/route.ts`:
- `checkout.session.completed` → activates `OrganizationProduct`, stores `stripeSubscriptionId`
- `customer.subscription.deleted` → sets status to `EXPIRED`, audit log
- `invoice.payment_failed` → sets status to `SUSPENDED`, sends `sendPaymentFailedEmail`

### ✅ P1 Platform — Products tab (June 2026)
`src/app/(platform)/platform/clients/[id]/_components/ClientProductsTab.tsx`:
- Row-click CRUD modal with Details + History tabs
- All lifecycle transitions (see table above)
- Stripe subscription auto-cancelled on comp and on set-back-to-trial
- Revenue summary cards per client (MRR, ARR, Stripe-managed, comped, trial pipeline)
- Audit history timeline per `OrganizationProduct`

### ✅ Revenue dashboard
`/platform` page — two rows of stats:
- Row 1: Client Orgs, Platform Users, Active Modules, Suspended (red when >0)
- Row 2: MRR, ARR, Paying / Comped count, Trial Pipeline value

### ⏳ Phase 7 — Client Billing Page
`src/app/(app)/billing/page.tsx` — placeholder exists, real UI not yet built.

### ⏳ Pending webhook events
- `customer.subscription.updated` — status sync on renewal/upgrade
- `invoice.payment_succeeded` — clear suspended flag on recovery payment

---

## Environment Variables

Three Stripe vars are required per environment. They are different per environment because test mode and live mode are completely separate Stripe accounts/modes.

```env
STRIPE_SECRET_KEY=sk_...           # Server-side only — NEVER expose to browser
STRIPE_WEBHOOK_SECRET=whsec_...    # Per-endpoint — different for every registered webhook
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_...  # Safe to expose — used by Stripe.js if needed
```

### Where to find them in Stripe Dashboard

| Variable | Location in Stripe |
|---|---|
| `STRIPE_SECRET_KEY` | Dashboard → Developers → API keys → **Secret key** (click Reveal) |
| `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY` | Dashboard → Developers → API keys → **Publishable key** (visible by default) |
| `STRIPE_WEBHOOK_SECRET` | Dashboard → Developers → Webhooks → click your endpoint → **Signing secret** (click Reveal) |

**Test mode vs Live mode:** Toggle the "Test mode" switch at the top-right of the Stripe Dashboard. Each mode has entirely separate API keys and webhook secrets. The keys are visually distinct:
- Test: `sk_test_...` / `pk_test_...` / `whsec_...` (same prefix in both modes)
- Live: `sk_live_...` / `pk_live_...` / `whsec_...`

### Per-environment mapping

| Environment | Stripe mode | Key prefix | Webhook points to |
|---|---|---|---|
| Local dev (`localhost`) | Test | `sk_test_` | Stripe CLI forward (not a registered endpoint) |
| Staging (`staging.isostack.app`) | Test | `sk_test_` | Stripe test-mode webhook endpoint |
| Production / main (`isostack.app`) | **Live** | `sk_live_` | Stripe live-mode webhook endpoint |

---

## Stripe Dashboard Setup — Per Environment

### What you need to create in Stripe

You need to create **Products and Prices** in Stripe Dashboard. These correspond 1:1 to your `ProductPackage` records in the database. You need to do this **twice** — once in Test mode (for staging), once in Live mode (for production).

#### Step 1 — Create Products in Stripe

In Stripe Dashboard (make sure you're in the correct mode — Test or Live):

1. Go to **Products → Add product**
2. For each IsoStack product package, create a Stripe Product:

| IsoStack Package slug | Stripe Product Name |
|---|---|
| `lmspro-starter` | LMSPro Starter |
| `lmspro-pro` | LMSPro Pro |
| `lmspro-enterprise` | LMSPro Enterprise |
| *(add any others that exist in your DB)* | |

#### Step 2 — Add Prices to each Product

For each Stripe Product, add two Prices:
- **Monthly**: Recurring · Monthly · GBP · your price (e.g. £149.00)
- **Yearly**: Recurring · Yearly · GBP · your price (e.g. £1,490.00)

**Where the Price ID is:** After saving a Price, it appears in the price list as `price_xxxxxxxxxxxxxxxxxx`. Click the price row to see the full ID, or it's shown directly in the product's price list.

#### Step 3 — Store Price IDs in the database

Each `ProductPackage` record has `stripePriceIdMonthly` and `stripePriceIdYearly` columns. You need to populate these with the `price_xxx` IDs from Stripe. Do this via Prisma Studio (`npm run db:studio`) or the seed script:

```bash
# Edit scripts/seed-stripe-price-ids.ts with your actual price_xxx IDs
# Then run:
npx tsx scripts/seed-stripe-price-ids.ts
```

> ⚠️ You need **separate price IDs for staging (test) and production (live)** — they are different Stripe modes. The staging DB needs test price IDs; the production DB needs live price IDs.

#### Step 4 — Also update priceMonthly / priceYearly

The `ProductPackage.priceMonthly` and `priceYearly` fields (plain `Decimal`) are used for **MRR/ARR display in the P1 dashboard**. These are independent of Stripe — set them to your GBP prices in Prisma Studio or via migration seed. Without these set, all revenue figures show £0.

---

## Webhook Setup — Per Environment

### Local development

Use the Stripe CLI to forward events to your local server. The webhook secret is generated fresh each `stripe listen` session.

```bash
# Install CLI (once)
brew install stripe/stripe-cli/stripe

# Authenticate (once)
stripe login

# Start forwarding (run every dev session alongside npm run dev)
stripe listen --forward-to localhost:3000/api/webhooks/stripe
```

The CLI prints a `whsec_...` secret on startup — copy it into your `.env.local` as `STRIPE_WEBHOOK_SECRET` for that session. (Or set it once if you use `stripe listen --print-secret`.)

Events to test:
```bash
stripe trigger checkout.session.completed
stripe trigger customer.subscription.deleted
stripe trigger invoice.payment_failed
```

### Staging (Test mode webhook)

1. In Stripe Dashboard → ensure you are in **Test mode**
2. Go to **Developers → Webhooks → Add endpoint**
3. **Endpoint URL:** `https://staging.isostack.app/api/webhooks/stripe`
4. **Events to listen for:**
   - `checkout.session.completed`
   - `customer.subscription.updated`
   - `customer.subscription.deleted`
   - `invoice.payment_succeeded`
   - `invoice.payment_failed`
5. Save → click the endpoint → **Signing secret → Reveal** → copy `whsec_...`
6. Add to Render staging environment:
   - `STRIPE_SECRET_KEY` = `sk_test_...`
   - `STRIPE_WEBHOOK_SECRET` = `whsec_...` (from this endpoint)
   - `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY` = `pk_test_...`

### Production (Live mode webhook)

1. In Stripe Dashboard → switch to **Live mode**
2. Go to **Developers → Webhooks → Add endpoint**
3. **Endpoint URL:** `https://isostack.app/api/webhooks/stripe` *(or your live domain)*
4. **Same events as above**
5. Save → copy the live `whsec_...` signing secret
6. Add to Render production environment:
   - `STRIPE_SECRET_KEY` = `sk_live_...`
   - `STRIPE_WEBHOOK_SECRET` = `whsec_...` (from the LIVE endpoint — **different from staging**)
   - `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY` = `pk_live_...`

> ⚠️ **The `STRIPE_WEBHOOK_SECRET` is unique per registered endpoint.** Staging and production will have different `whsec_` values even if they look similar. Using the wrong one causes all webhooks to fail signature verification with a 400 error.

---

## Phase 7 — Client Billing Page (Pending)
**Estimated time: 3 hrs**  
**Edit:** `src/app/(app)/billing/page.tsx` (placeholder exists)

### Page Sections

**7a. Active Subscriptions**
- `trpc.billing.getStatus.useQuery()`
- Card per product: name, status badge, billing interval, next payment date
- "Manage / Cancel" button → `createPortalSession` → redirect

**7b. Add a Product (Self-Service Checkout)**
- Lists available `ProductPackage` records not yet subscribed
- Monthly / Yearly toggle
- "Subscribe" button → `createCheckoutSession` → redirect to Stripe Checkout
- After success: Stripe redirects to `/app?checkout=success` → banner

**7c. Invoice History**
- `trpc.billing.listInvoices.useQuery()` *(not yet built — needs adding to billing.router)*
- Table: Date | Description | Amount | Status | Download PDF
- If `stripeCustomerId` is null (comped org): "Contact your account manager for invoices"

**7d. Payment Method**
- "Update Payment Method" → `createPortalSession` → redirect
- Card details never stored in IsoStack — Stripe Portal handles entirely

---

## Phase 8 — Testing

### Test Card Numbers (Stripe test mode)
- `4242 4242 4242 4242` — successful payment (any future expiry, any CVC)
- `4000 0000 0000 9995` — card declined
- `4000 0025 0000 3155` — requires 3DS authentication

### Test Scenarios

| Scenario | Steps | Expected Result |
|---|---|---|
| New self-service subscription | Click Subscribe → test card `4242...` → complete | `OrganizationProduct` → ACTIVE, `stripeSubscriptionId` set |
| Webhook: subscription cancelled | `stripe trigger customer.subscription.deleted` | Status → EXPIRED |
| Webhook: payment failed | `stripe trigger invoice.payment_failed` | Status → SUSPENDED, billing gate shown |
| P1: comp a paying org | Products tab → row → Activate/Comp | Stripe sub cancelled, badge → Manual/Comped |
| P1: set paying org back to trial | Products tab → row → Set back to trial | Stripe sub cancelled, status → TRIAL |
| P1: unsuspend | Products tab → row → Unsuspend | Status → ACTIVE, billing gate gone |
| Customer portal | Click "Manage Billing" | Redirect to Stripe Portal |
| Comped org billing page | No stripeCustomerId | Invoice section shows "Contact account manager" |

---

## File Reference

| File | Purpose |
|---|---|
| `src/lib/stripe.ts` | Stripe singleton client |
| `src/server/core/routers/billing.router.ts` | `createCheckoutSession`, `createPortalSession`, `getStatus` |
| `src/server/core/routers/products.router.ts` | P1 lifecycle management incl. Stripe cancel on comp/trial |
| `src/app/api/webhooks/stripe/route.ts` | Webhook handler (checkout, subscription deleted, payment failed) |
| `src/app/(gate)/account/billing-gate/page.tsx` | C1 Owner/Admin gate — trial expired or payment failed |
| `src/app/(gate)/account/suspended/page.tsx` | C2 Member gate — neutral suspended message |
| `src/app/(app)/app/lmspro/layout.tsx` | Billing interceptor — checks status, redirects to gate |
| `src/app/(platform)/platform/clients/[id]/_components/ClientProductsTab.tsx` | P1 product management UI |
| `scripts/seed-stripe-price-ids.ts` | One-time script to populate price IDs *(create after Stripe setup)* |

---

## Decisions / Assumptions

| Decision | Rationale |
|---|---|
| Comped = ACTIVE + no stripeSubscriptionId | No separate DB field needed; Stripe column in P1 UI shows Manual/Comped vs Managed |
| Comp from paying auto-cancels Stripe sub | Prevents ghost subscriptions accruing charges after P1 comps an org |
| Set-back-to-trial auto-cancels Stripe sub | Same reason — ensures billing stops when P1 demotes a paid org |
| One Stripe Customer per Organization | Org pays, not individual users |
| One Stripe Subscription per OrganizationProduct | Per-product billing and cancellation |
| Stripe Portal handles card/cancellation | No custom payment forms; PCI compliance via Stripe |
| MRR/ARR from priceMonthly field | Avoids Stripe API call for dashboard stats; P1 sets prices once in DB |
| Invoice PDFs served from Stripe | `invoice_pdf` URL — no R2 storage needed |

---

## Out of Scope (Future)

- Multi-currency
- Usage-based billing
- Dunning email sequences (Stripe handles basic failed payment emails via Dashboard settings)
- `invoice.payment_succeeded` / `subscription.updated` webhook handlers (currently TODO)

---

## Phase 8 — Team Bundle Add-ons (Pending)

**Status:** Design complete (3 June 2026) — schema migration not yet run  
**Estimated time: 2–3 days across 4 phases**

### Overview

Tenants can top-up their team capacity by purchasing Team Bundle add-ons in addition to their base tier subscription. Designed for LMSPro only (metric = active teams in current season).

**Key rules:**
- Tier is always quantity 1 on the subscription
- Bundles can be quantity N (each bundle = X additional teams)
- Tier 3 has a different (bigger/cheaper) bundle than lower tiers — each tier has its own `ProductAddon` record with its own Stripe Price ID
- Comped leagues do **not** purchase bundles — P1 sets a `overrideTeamLimit` directly (no Stripe)
- Stripe handles proration silently on mid-cycle bundle changes — UI notes this without calculating it

### Stripe Subscription Structure

A subscribing tenant creates **one Stripe Checkout Session** with multiple `line_items`:

```typescript
stripe.checkout.sessions.create({
  mode: 'subscription',
  line_items: [
    { price: 'price_tier3_monthly', quantity: 1 },        // Tier — always qty 1
    { price: 'price_bundle_tier3_monthly', quantity: 2 }, // Optional at signup
  ],
});
```

After checkout, `subscription.items.data` returns two item IDs:
- `si_abc` — tier line item → stored in `OrganizationProduct.stripeSubscriptionItemId`
- `si_xyz` — bundle line item → stored in `OrganizationProductAddon.stripeSubscriptionItemId`

### Self-Serve Bundle Changes (No New Checkout)

Once subscribed, bundles are updated via direct subscription update — no Stripe redirect:

```typescript
// Increase quantity on existing bundle item
stripe.subscriptions.update(subscriptionId, {
  items: [{ id: storedBundleItemId, quantity: 3 }],
  proration_behavior: 'always_invoice',
});

// Add first bundle (no bundle item yet)
stripe.subscriptions.update(subscriptionId, {
  items: [{ price: 'price_bundle_tier3_monthly', quantity: 1 }],
  proration_behavior: 'always_invoice',
});

// Remove all bundles
stripe.subscriptions.update(subscriptionId, {
  items: [{ id: storedBundleItemId, quantity: 0 }],
});
```

### Tier Upgrade

Swap the tier line item's price, keep the bundle item:

```typescript
stripe.subscriptions.update(subscriptionId, {
  items: [
    { id: storedTierItemId, price: 'price_tier4_monthly' },
    // bundle item untouched
  ],
  proration_behavior: 'always_invoice',
});
```

UI shows: *"Your next invoice will include a prorated charge for the upgrade."* — no calculation needed.

### Checkout Flow Summary

| Action | Stripe Operation |
|---|---|
| First purchase (tier only) | Checkout Session, 1 line item |
| First purchase (tier + bundles) | Checkout Session, 2 line items |
| Add bundle on existing sub | `subscriptions.update` — add item |
| Increase bundle qty | `subscriptions.update` — change quantity |
| Remove all bundles | `subscriptions.update` — quantity: 0 |
| Upgrade tier | `subscriptions.update` — swap price on tier item |
| Cancel | `subscriptions.cancel` |

### RAG Team Limit Warning System

The billing page and dashboard show a RAG indicator based on active team count vs effective limit:

- 🟢 **Green** — >25% capacity remaining (configurable threshold)
- 🟡 **Amber** — within 10% of limit (configurable threshold)
- 🔴 **Red** — at or over 100% of limit

Thresholds are configured per `ProductPackage` by P1 in the Product Manager.

**Effective team limit formula:**
```
effectiveLimit = baseTeamLimit + (sum of addon.quantity × addon.teamsPerBundle)
```

For comped orgs: `effectiveLimit = overrideTeamLimit` (set directly by P1, no addons).

When Red: soft warning only (no hard block) + email sent to P1.

### Schema Changes Required

#### On existing `ProductPackage` model (new fields)
```prisma
baseTeamLimit        Int?      // Max teams included in this tier (e.g. 30)
teamLimitRagAmber    Int?      // Amber threshold as % of limit (e.g. 90)
teamLimitRagRed      Int?      // Red threshold as % of limit (e.g. 100)
```

#### On existing `OrganizationProduct` model (new field)
```prisma
stripeSubscriptionItemId  String?  // si_xxx for the tier line item
overrideTeamLimit         Int?     // Comped orgs only — P1 sets directly
```

#### New `ProductAddon` table
```prisma
model ProductAddon {
  id                   String         @id @default(cuid())
  name                 String         // "Team Bundle"
  slug                 String         @unique
  description          String?
  teamsPerBundle       Int            // Teams unlocked per bundle unit
  priceMonthly         Decimal        @db.Decimal(10, 2)
  priceYearly          Decimal        @db.Decimal(10, 2)
  stripePriceIdMonthly String?
  stripePriceIdYearly  String?
  moduleSlug           String         // "lmspro"
  isActive             Boolean        @default(true)
  packageId            String         // Tier this bundle applies to
  package              ProductPackage @relation(fields: [packageId], references: [id])
  orgAddons            OrganizationProductAddon[]
  createdAt            DateTime       @default(now())
  updatedAt            DateTime       @updatedAt
}
```

#### New `OrganizationProductAddon` table
```prisma
model OrganizationProductAddon {
  id                       String       @id @default(cuid())
  organizationId           String
  addonId                  String
  quantity                 Int          @default(1)
  stripeSubscriptionItemId String?      // si_xxx — needed to update quantity later
  createdAt                DateTime     @default(now())
  updatedAt                DateTime     @updatedAt
  organization             Organization @relation(...)
  addon                    ProductAddon @relation(...)
}
```

### Build Phases

| Phase | Work | Files |
|---|---|---|
| 8a | Schema migration | `prisma/schema.prisma` + migration |
| 8b | tRPC routers | `addons.router.ts` — list, add, updateQuantity; update `billing.router.ts` checkout to include bundles |
| 8c | Platform Product Manager UI | Configure `ProductAddon` per tier, set `baseTeamLimit` + RAG thresholds |
| 8d | Tenant billing page | Real billing page replacing placeholder — tier card, bundle picker, RAG indicator, invoice history |

### Naming: IsoStack wins over Stripe

- All names and prices displayed in the app come from IsoStack DB (`ProductPackage.name`, `ProductAddon.name`, `priceMonthly`)
- Stripe holds only `price_xxx` IDs — never fetched to display names
- Stripe product names (visible on invoices) should be set to match marketing names in Stripe Dashboard — one-time admin task
- You can rebrand any tier name in IsoStack at any time without touching Stripe
