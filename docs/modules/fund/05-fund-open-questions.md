# FUND Open Questions

**Canonical location:** `isodocs/docs/modules/fund/05-fund-open-questions.md`  
**Module slug:** `fund`  
**Status:** Active planning questions  
**Source documents:** `01-fund-module-brief.md`, `02-fund-architecture-principles.md`, `03-fund-functional-specification.md`, `04-fund-phase-1-implementation-plan.md`  
**Purpose:** Questions to resolve before schema and implementation work.

---

## 1. Questions That Block Schema Work

### 1.1 Product Workflow Classes

Should Product Workflow Classes be:

- fixed platform-defined records;
- tenant-customisable records;
- enum-backed records with database metadata;
- fully database-defined records;
- hybrid defaults with tenant extensions?

Recommendation to review:

- A1, A2, B and C should be protected system defaults.
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

What is the uniqueness scope for project numbers?

Options:

- global across FUND;
- tenant-scoped;
- event-scoped;
- producer-scoped;
- year/campaign-prefixed.

AMOW may need project numbers that are meaningful on printed templates and parent instructions.

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

Which Event date is authoritative for Project constraints?

Candidate fields:

- event date;
- campaign open date;
- final project creation date;
- latest store close date;
- production deadline;
- dispatch deadline.

Rule proposed for Phase 1:

```text
Project Closing Date <= Event Latest Store Close
```

If no latest store close exists:

```text
Project Closing Date <= Event Production Deadline
```

Confirm before schema work.

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

Should FUND use a dedicated Postgres schema?

Current repo uses:

- `public`;
- `bedrock`;
- `lmspro`;
- `pulse`.

Recommendation:

- use dedicated `fund` schema;
- add explicit `organizationId` on tenant-owned tables;
- do not treat schema separation as tenant isolation.

---

## 2. Questions Before Phase 1 UI Work

### 2.1 Management Surfaces

Which Phase 1 admin surfaces are required first?

Options:

- workflow classes;
- products;
- catalogues;
- events;
- projects;
- operations dashboard;
- organiser dashboard.

Recommended order:

1. workflow class visibility;
2. products/catalogues;
3. projects;
4. optional events;
5. lifecycle visibility;
6. dashboards.

---

### 2.2 CRUD Pattern

Should all early admin lists follow the existing IsoStack table CRUD pattern?

Recommended answer:

- yes;
- row click opens edit modal;
- delete/archive actions live in modal footer;
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

### 3.2 Customer Accounts

Do customers/parents/supporters need IsoStack accounts?

Likely answer:

- not for early storefront ordering;
- customer identity should be order/contact-based unless account creation is required later.

---

### 3.3 Payment Provider

Stripe direct integration is the current preferred direction.

Open questions:

- Stripe Checkout only or embedded Payment Element later?
- Is GoCardless required for organisation-level subscription/billing, customer purchases, or both?
- How should offline payments or school-paid batch orders be represented?

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

Resolve in this order:

1. Product Workflow Class modelling.
2. FUND module role assignment strategy.
3. Project number scope.
4. Organiser model.
5. Product ownership and catalogue sharing.
6. Event date semantics.
7. Lifecycle modelling.
8. Dedicated `fund` schema confirmation.
9. Phase 1 UI management surface order.
10. Store association model.

---

## 9. Current Safe Next Step

The next safe step is a schema design proposal only.

Do not edit Prisma schema until these questions have been reviewed and enough decisions have been made to avoid rework.

