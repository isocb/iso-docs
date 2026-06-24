# FUND Open Questions

**Canonical location:** `isodocs/docs/modules/fund/05-fund-open-questions.md`  
**Module slug:** `fund`  
**Status:** Active planning questions  
**Source documents:** `01-fund-module-brief.md`, `02-fund-architecture-principles.md`, `03-fund-functional-specification.md`, `04-fund-phase-1-implementation-plan.md`  
**Purpose:** Questions to resolve before schema and implementation work.

---

## 1. Schema Decisions And Deferred Questions

### 1.1 Product Workflow Classes

Phase 1 decision: resolved.

- A1, A2, B and C are protected platform defaults.
- They are database records with metadata and are read-only for normal tenant workflows.
- Tenant-specific extensions can come later.

---

### 1.2 FUND Module Roles

Current user assignment uses module-specific arrays:

- `lmsproRoleIds`;
- `bedrockRoleIds`;
- `tailoraidRoleIds`.

There is no `fundRoleIds`.

Decision needed:

1. Add `fundRoleIds` to `User`.
2. Create generic module-role assignment table.
3. Use platform OWNER/ADMIN only for Phase 1 and defer FUND module roles.

This affects schema, routers, permissions, dashboards and future organiser access.

---

### 1.3 Project Number Scope

Phase 1 decision: resolved.

- Project numbers are tenant-scoped for Phase 1.
- Slice 1H implemented tenant-unique Project numbers.
- Future event-scoped, producer-scoped or year/campaign-prefixed display conventions can be layered later if needed.

AMOW may still need Project numbers that are meaningful on printed templates and parent instructions, but that is a formatting/operational convention on top of tenant-scoped uniqueness.

---

### 1.4 Organiser Model

What is an organiser in Phase 1?

Options:

- IsoStack `User`;
- `Organization`;
- separate FUND contact/person record;
- project participant record;
- hybrid.

This affects organiser dashboard access, invitations, communications and future customer-facing flows.

---

### 1.5 Product Ownership and Producer Access

If AMOW owns a product catalogue, can another tenant use those products in its Projects?

Decision needed:

- direct cross-tenant product visibility;
- explicit catalogue sharing;
- marketplace-style product availability;
- copy product into tenant;
- defer until after AMOW-only launch.

This is a major tenant-safety and commercial modelling decision.

---

### 1.6 Event Date Semantics

Phase 1 / 1L-A clarification: resolved enough for FundEvent schema planning.

- `FundEvent.opensAt` is the Event opening boundary.
- `FundEvent.closesAt` is the latest permissible effective close date for linked Projects.
- `FundEvent.productionDeadline` is the Event-level production deadline guidance/constraint.
- `FundEvent.closesAt` is not a forced persisted Project close date.
- Store-specific close dates remain future Store planning and must not be introduced into the 1L-A Event schema.

Standalone Project rule:

```text
FundProject.closesAt must be after FundProject.opensAt, when both exist
```

Planned Phase 1 Event-linked Project rule:

```text
FundProject.opensAt >= FundEvent.opensAt, when both exist
FundProject.closesAt <= FundEvent.closesAt, when Project closesAt is set
FundProject.productionDeadline <= FundEvent.productionDeadline, when both exist
```

If an Event-linked Project has no `FundProject.closesAt`, the UI/API may treat `FundEvent.closesAt` as the inherited/effective close date for display, activation readiness and future Store generation, without necessarily persisting that value into `FundProject.closesAt`.

Deferred:

- Store close dates;
- dispatch deadlines;
- Store/Order-specific production deadlines;
- automatic persisted date copying/cascading.

---

### 1.7 Lifecycle Modelling

Should lifecycle states be:

- enums;
- database records;
- workflow templates;
- JSON definitions;
- hybrid core enum plus workflow-specific records?

Recommendation to review:

- use a stable common lifecycle;
- model workflow-specific extensions flexibly enough for A1/A2/B/C;
- avoid hard-coding every future production state too early.

---

### 1.8 Schema Placement

Phase 1 decision: resolved.

- FUND uses a dedicated Postgres schema named `fund`.
- Tenant-owned FUND tables include explicit required `organizationId`.
- Schema separation is not tenant isolation; tenant isolation still relies on `organizationId`, service scoping and future RLS posture.

---

## 2. Questions Before Phase 1 UI Work

### 2.1 Management Surfaces

Phase 1 decision: resolved through Slice 1J-B for the first admin sequence.

- Workflow Classes are implemented as protected defaults.
- Products and Catalogues admin is implemented.
- Projects admin is implemented through 1J-B.
- Optional Events are next.

Deferred:

- lifecycle visibility;
- operations dashboard;
- organiser dashboard.

Dashboard boundary clarification:

- FUND is expected to have both C1 and C2 dashboard surfaces.
- The C1 dashboard is the tenant/admin/producer control surface. It will eventually support Event management, Products, Catalogues, Project oversight, production, distribution and communications to C2 organisers.
- The C2 dashboard is the organiser/project operating surface. It will eventually allow Project organisers to manage their own Projects, fundraising lifecycle, project communications, template creation, artwork file upload, submission/approval tasks and progress.
- Current Phase 1 admin work is building the C1 dashboard/admin foundation only.
- Current C1 admin work must not be mistaken for the future C2 organiser dashboard.
- C2 dashboard, organiser invitations, Project ownership/access rules and Project Request/onboarding remain future slices.

---

### 2.2 CRUD / Child Page Pattern

Phase 1 clarification: resolved enough for current UI work.

- Simple CRUD entities may use modal editing when the record is compact and has no meaningful child domain.
- Complex parent entities with child domains or operational state should use child pages.
- Products and Catalogues may use the table CRUD modal pattern.
- Projects use child pages.
- Events should use child pages when implemented because they will likely contain date constraints, linked Projects and later campaign defaults.

Guidance:

- row click opens modal for simple CRUD;
- row click opens child page for complex parent entities;
- delete/archive actions live in modal footer or child page action area;
- no action icon clutter in table rows.

---

### 2.3 Tooltip Coverage

Which early UI elements require tooltip anchors?

Likely anchors:

- `fund.workflowClasses.list`;
- `fund.products.list`;
- `fund.catalogues.list`;
- `fund.projects.list`;
- `fund.events.list`;
- `fund.lifecycle.status`;
- `fund.operations.dashboard`;
- `fund.organiser.dashboard`;

---

## 3. Questions Before Store and Commerce Work

### 3.1 Store Type

What is a Store in the first commerce phase?

Options:

- internal Next.js storefront;
- Stripe Checkout-only surface;
- embedded checkout;
- external store reference;
- provider-neutral store association.

Recommendation:

- keep internal model provider-neutral;
- associate Store to Project only after Project and Lifecycle foundations are stable.

---

### 3.2 Future Store / Commerce Modes

FUND Store and Order planning must not assume a single conventional e-commerce model.

Future Store modes may include:

1. Individual buyer / Project bulk fulfilment

   - anonymous or public buyers purchase through a Project-linked Store;
   - orders are associated with the Project;
   - fulfilment/shipping is to the Project or organiser address rather than individual buyer addresses.

2. C2 organiser / bulk Project purchase

   - the Project admin, club, school or organiser purchases on behalf of the Project;
   - products may be bulk products, mass-customised products or individually named/personalisable products;
   - fulfilment/shipping is to the Project address.

3. Conventional individual e-commerce

   - individual purchasers buy and receive goods directly;
   - shipping is to the individual purchaser address.

This should be captured before Store, Order, Checkout, Shipping, Production Export and Fulfilment design begins.

Do not implement this in Slice 1L-A. Slice 1L-A remains FundEvent schema only.

---

### 3.3 Customer Accounts

Do customers/parents/supporters need IsoStack accounts?

Likely answer:

- not for early storefront ordering;
- customer identity should be order/contact-based unless account creation is required later.

---

### 3.4 Payment Provider

Stripe direct integration is the current preferred direction.

Open questions:

- Stripe Checkout only or embedded Payment Element later?
- Is GoCardless required for organisation-level subscription/billing, customer purchases, or both?
- How should offline payments or school-paid batch orders be represented?

---

### 3.5 IsoStack Commerce Core Boundary

Deferred cross-module architecture note.

Commerce should become a core IsoStack capability rather than a FUND-specific or SeasonPro-specific implementation.

Working principle:

```text
Commerce should be core IsoStack infrastructure;
Stores, subscriptions, fines and fundraising are module-specific uses of that infrastructure.
```

Likely boundary:

| Layer | Owns |
| --- | --- |
| IsoStack Commerce Core | generic products/prices, provider records, invoices/orders, payment status, subscriptions, entitlements |
| SeasonPro | leagues, clubs, subscriptions, fines, one-off charges, who owes what |
| FUND | Projects, Events, Products/Catalogues, Stores, production workflow |
| FUND Store layer | how a Project becomes a public/private selling surface |
| Production/Fulfilment | batch production, shipping, export, artwork/data handling |

Possible future Commerce Core entities:

- `CommerceProduct`;
- `CommercePrice`;
- `CommerceCustomer`;
- `CommerceOrder`;
- `CommerceOrderLine`;
- `CommerceInvoice`;
- `CommercePayment`;
- `CommerceSubscription`;
- `CommercePaymentProviderAccount`;
- `CommerceEntitlement`;
- `CommerceLedgerEntry`.

Payment provider modelling should be provider-aware but provider-neutral. Stripe, GoCardless, offline/manual payments and future invoice-only flows should not force FUND or SeasonPro into one payment shape.

Naming discipline is important because IsoStack already has multiple product concepts:

| Term | Meaning |
| --- | --- |
| Platform Product | IsoStack subscription package/gating product |
| FUND Product | physical/fundraising item selected into Projects |
| Commerce Product | generic sellable thing |
| Commerce Price | price/recurrence/currency/tax/provider mapping |
| Entitlement | access/capability unlocked by payment or subscription |

Recommended sequencing:

1. Finish the C1 FUND admin foundation: Products, Catalogues, Projects, Project Products, Events and Project/Event linkage.
2. Create a separate IsoStack Commerce Core planning document outside FUND.
3. Plan cross-module requirements using SeasonPro billing and FUND Store examples.
4. Build Commerce Core schema-only on a dedicated branch, for example `feature/isostack-commerce-core` or `feature/core-commerce-billing`.
5. Add provider abstraction, likely Stripe first with GoCardless and offline/manual support designed in but not necessarily implemented immediately.
6. Wire either SeasonPro billing or FUND Store as the first consumer.

Do not build Commerce Core as a side-effect of FUND Store work.

Existing related background note:

```text
docs/00-overview/e-commerce-analysis-options.md
```

Future full planning should probably live outside FUND, for example:

```text
docs/core/commerce/isostack-commerce-core-planning.md
```

---

## 4. Questions Before Artwork and Template Work

### 4.1 First AMOW Template

Which real AMOW template should be used for the first proof?

The first template should exercise:

- project number;
- product/pricing information;
- parent instructions;
- artwork space;
- return instructions.

---

### 4.2 PDF Generation Tool

Candidate options:

- CraftMyPDF;
- Puppeteer/Playwright HTML rendering;
- `@react-pdf/renderer`.

Decision should follow a real template spike, not abstract preference.

---

### 4.3 Artwork Asset Model

How will artwork arrive?

Options:

- physical return only;
- organiser upload;
- producer upload;
- parent/customer upload;
- scanned batch upload;
- hybrid.

Phase 1 should not overbuild this, but the schema must not block A1/A2 later.

---

## 5. Questions Before Commission Work

### 5.1 Commission Participants

Which participants are required for first implementation?

Possible participants:

- Isoblue;
- AMOW;
- producer;
- production partner;
- school;
- organiser;
- league;
- club.

SeasonPro league/club commission should remain future-channel work unless explicitly prioritised.

---

### 5.2 Commission Basis

Commission may be calculated from:

- order gross;
- order net;
- product margin;
- fixed value per item;
- fixed project value;
- producer-specific margin.

No rates should be hard-coded.

---

## 6. Questions Before SeasonPro Integration

SeasonPro is a future distribution channel, not a Phase 1 dependency.

Questions to defer:

- How does a league enable FUND for clubs?
- Are clubs organisers, beneficiaries or both?
- Does each club get one Project or many Projects?
- How are league and club commissions split?
- Which SeasonPro roles map to FUND organiser permissions?
- How are football-specific labels kept out of FUND core?

---

## 7. Questions Before Marketplace Expansion

Marketplace-style expansion should wait until AMOW workflow is proven.

Questions to defer:

- Can multiple producers publish catalogues?
- Can tenants request access to producer catalogues?
- How are producer terms accepted?
- How are production partner responsibilities assigned?
- How are marketplace commissions configured?
- How are product quality and fulfilment SLAs represented?

---

## 8. Recommended Decision Order

Resolved for Phase 1:

- Product Workflow Class modelling: A1, A2, B and C protected platform defaults.
- Project number scope: tenant-scoped.
- Schema placement: dedicated `fund` schema plus `organizationId` on tenant-owned tables.
- Initial UI order: workflow classes, products/catalogues and projects complete through 1J-B; optional Events next.
- Event date semantics for 1L-A: `FundEvent.opensAt`, `FundEvent.closesAt`, `FundEvent.productionDeadline`; `FundEvent.closesAt` is the latest permissible effective close date for linked Projects.

Still deferred:

1. FUND module role assignment strategy.
2. Organiser model.
3. Product ownership and catalogue sharing.
4. Lifecycle modelling beyond current Project `lifecycleState`.
5. Store and commerce modes.
6. Store association model.
7. Commission model.
8. SeasonPro integration.
9. Marketplace expansion.

---

## 9. Current Safe Next Step

The next safe implementation step is Slice 1L-A: FundEvent schema only.

Do not introduce Store-specific close dates, Store schema, Order schema, commerce, organiser identity, Project Request flows or dashboards in 1L-A.
