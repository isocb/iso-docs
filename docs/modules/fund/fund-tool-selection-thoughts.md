# FUND — Tool Selection Thoughts

*Status: Planning | Date: June 2026*

---

## Platform

**IsoStack Bedrock** — FUND will be built as a dedicated module (`src/modules/fund/`) on top of the existing IsoStack platform.

FUND inherits:

- Multi-tenancy via `organizationId`
- NextAuth authentication
- User roles and platform permissions
- Audit logging
- Email via Resend
- File/media storage via Cloudflare R2 and `MediaFile`
- Branding/theming per tenant
- Tooltip/help system
- Product/package allocation and metric limits
- Platform admin tooling

---

## Naming Decision

Earlier AMOW planning is now folded into FUND.

- **AMOW** = founding business/use case and likely production partner/tenant
- **FUND** = reusable IsoStack module capability

This avoids baking one production provider into the module name or domain model.

---

## E-Commerce

**Selected direction: Stripe direct integration.**

Rationale:

- FUND needs custom project/store initiation flows rather than a fixed product catalogue overlay
- Stripe Checkout Sessions can be generated programmatically per store/order/project
- Payment confirmation via Stripe webhooks can move lifecycle state and trigger downstream work
- Stripe Invoicing remains available for batched/staged billing
- Stripe Tax can be evaluated for VAT handling

Alternatives considered and rejected:

- **Snipcart** — too catalogue-centric for dynamic fundraising/project workflows
- **Lemon Squeezy / Paddle** — stronger for SaaS subscriptions than custom project/store lifecycle commerce

---

## PDF / Artwork Generation

**Decision pending first production template.**

### Option A: CraftMyPDF

Best if templates are fixed-layout and non-technical users need visual template editing.

Pros:

- Visual template designer
- REST API generation
- Low infrastructure burden

Cons:

- Per-PDF cost
- External vendor dependency

### Option B: Puppeteer / Playwright

Best if templates require high-fidelity browser rendering and bespoke layout control.

Pros:

- Full HTML/CSS layout control
- No per-document vendor cost
- Can render internal Next.js routes

Cons:

- Heavier runtime
- Render instance may need more capacity

### Option C: `@react-pdf/renderer`

Best if templates are moderately complex and can live as React components.

Pros:

- No browser runtime
- React-native authoring style
- No external vendor dependency

Cons:

- Limited CSS subset
- Complex image placement may be harder than browser/Puppeteer

### Initial Recommendation

Start with a template spike before final selection:

1. Select one real AMOW/FUND output template
2. Build it in CraftMyPDF and Puppeteer/HTML
3. Compare fidelity, operational complexity, cost, and template editability
4. Choose the default path for MVP

---

## File Storage

Use existing IsoStack media stack:

- Upload source artwork/data files to R2
- Store records in `MediaFile`
- Link generated PDFs/proofs/delivery files via `MediaUsage` or module-specific foreign keys
- Keep generated output immutable where possible

---

## Project Initiation Methods

Expected methods:

- Admin-created project
- Organiser/self-serve project request
- Stripe checkout triggered store/project creation
- Imported/bulk-created projects
- Future integration/API-created projects

Each initiation method should converge into the same FUND project lifecycle engine.

---

## Metrics / Product Limits

FUND should register module metrics once real tables exist.

Likely metrics:

- `fund_projects`
- `fund_active_stores`
- `fund_orders`
- `fund_products`
- `fund_organisers`

Counters must be wired in `src/server/core/metricCounters.ts` using the key format `fund.<metricSlug>`.

---

## Open Tool Decisions

- PDF generation engine
- Whether storefront is internal Next.js pages or a dedicated public route group
- Whether to use Stripe Checkout only or add embedded Payment Element later
- Whether production exports are CSV-first, PDF-first, or API-first
- Whether workflow automation should use existing audit/event patterns or a dedicated queue
