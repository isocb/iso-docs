# FUND Phase 1 Slice 1P - C2 Organiser Dashboard Proposal

Date: 2026-06-24

Status: Planning only

Target app branch:

```text
feature/fund-phase-1-c2-project-access
```

## 1. Slice Goal

Plan the future C2 organiser dashboard as the Project operating surface for FUND.

The C1 admin foundation is now staged and provides tenant/admin control over:

- Events;
- Products;
- Catalogues;
- Projects;
- Project Products;
- Project/Event linkage.

Slice 1P asks the next architectural question:

```text
What does the Project organiser see and do once a Project exists?
```

This slice is planning only. It must not implement the C2 dashboard yet.

## 2. Role And Ownership Model

### C1 Users

C1 users are tenant/admin/producer users.

They own and operate the FUND tenant control surface:

- Event management;
- Product management;
- Catalogue management;
- Project creation and oversight;
- Project/Event linkage;
- production and distribution planning;
- communications to organisers;
- future Store, Order, commerce and fulfilment controls.

The current Phase 1 implementation is a C1 admin foundation.

### C2 Users

C2 users are Project organisers.

They operate Projects within the C1 tenant context. They may be school contacts, club contacts, fundraising organisers, parent-teacher association users, AMOW school coordinators or similar external organiser users.

Conceptually:

```text
C1 tenant/admin creates and oversees Projects.
C2 organiser operates assigned Projects.
```

Projects conceptually belong to C2 organisers operationally, but they remain tenant-scoped under the C1 tenant for data isolation, configuration, Products, Events and production oversight.

### Important Current Constraint

Current `FundProject` has optional organiser snapshot/contact fields:

- `organiserName`;
- `organiserEmail`;
- `organiserPhone`.

These fields are contact/display snapshots only. They must not be treated as access control.

## 3. C1 Admin Dashboard Versus C2 Organiser Dashboard

### C1 Admin Dashboard

The C1 admin dashboard is the producer/control surface.

It answers:

- What Events exist?
- What Products and Catalogues are available?
- Which Projects are active, blocked, closing or completed?
- Which organisers need chasing?
- Which production tasks are due?
- Which Stores, Orders, payments and commissions need oversight later?

Routes currently include:

```text
/app/fund
/app/fund/products
/app/fund/projects
/app/fund/projects/[id]
/app/fund/events
/app/fund/events/[id]
```

### C2 Organiser Dashboard

The C2 organiser dashboard is the Project operating surface.

It should answer:

- Which Projects am I responsible for?
- What is the status of each Project?
- What dates and deadlines matter?
- What Products are included?
- What do I need to do next?
- What artwork, data, templates or approvals will be required later?
- What communications or instructions has the C1 tenant sent me?
- What Store/order/payment status will matter later?

It must not expose C1-only controls.

## 4. What C2 Users Should See

The first C2 dashboard should show only assigned Projects and should be mostly read-only until the organiser access model is implemented and reviewed.

Recommended first visible content:

- dashboard welcome/header with C1 tenant context;
- assigned Project cards/list;
- Project number;
- Project name;
- Project status;
- lifecycle state;
- linked Event name where present;
- effective close date;
- production deadline where relevant;
- organiser/contact snapshot;
- selected Project Products and workflow classes;
- Project activation/readiness-style messages adapted for organiser guidance;
- clear next-step placeholders for artwork/data/template work later.

The C2 dashboard should not initially show:

- all tenant Projects;
- Products/Catalogues admin;
- Event admin;
- audit/admin internals;
- C1-only internal notes;
- pricing/admin controls beyond organiser-facing Product information;
- Store/order/payment management until those layers are planned.

## 5. What C2 Users Should Be Allowed To Edit

Recommended first implementation stance:

```text
Read-only first, with tightly scoped contact/preferences edits only after access model is resolved.
```

Potential C2-editable fields later:

- organiser display/contact details for their own Project participant record;
- delivery/contact address after Store/Fulfilment planning;
- artwork/data submissions;
- template download/upload actions;
- approval responses;
- organiser-facing communication preferences;
- Project Request/onboarding forms.

Do not allow C2 users to edit in the first dashboard foundation:

- Project number;
- Project slug;
- Project status;
- lifecycle state;
- Event linkage;
- Products selected for the Project;
- Product pricing;
- Catalogues;
- production deadlines;
- C1 internal notes;
- archive/restore/activate/close/complete actions.

## 6. What Must Remain C1-Only

C1-only controls:

- Event create/edit/status actions;
- Product create/edit/archive/restore/activate;
- Catalogue create/edit/archive/restore/activate;
- Catalogue Product membership;
- Project create/edit/admin fields;
- Project status transitions;
- Project Product membership;
- Project/Event linkage;
- Project internal notes;
- production control;
- distribution and fulfilment control;
- C2 invitation/provisioning until explicitly designed;
- commerce, Store, Order and payment administration;
- commission configuration;
- tenant/product/module allocation.

## 7. Project Visibility Rules For C2 Users

A C2 user should see only Projects assigned to them through an explicit access relationship.

Do not derive C2 visibility from:

- `FundProject.organiserEmail` text equality;
- Project contact snapshots alone;
- all Projects in the user's `organizationId`;
- Event membership;
- Product membership;
- general FUND module access alone.

Recommended visibility rule:

```text
C2 user can see FundProject only when an active Project participant/access record links that user to the Project within the same C1 organizationId.
```

The relationship must include `organizationId` and must validate that Project, user and access record all belong to the same tenant context.

## 8. Organiser / Access Model Options

### Option A - IsoStack User Only

A C2 organiser is just an IsoStack `User` with role/member status.

Pros:

- reuses authentication;
- no extra person table required;
- can use existing session/user patterns.

Cons:

- current `User` belongs to one `organizationId`;
- no Project-specific permissions;
- no support for multiple organisers per Project;
- no support for invitation lifecycle;
- does not model organiser role differences.

Verdict: insufficient by itself.

### Option B - FUND Organiser Record Only

A C2 organiser is a FUND-specific contact/person record independent of auth.

Pros:

- good contact modelling;
- can exist before account invitation;
- supports unknown customer/Project Request flows.

Cons:

- not enough for authenticated dashboard access;
- needs linkage to `User` later;
- can become duplicate identity model if not careful.

Verdict: useful later, but not enough alone for dashboard auth.

### Option C - Project Participant / Access Record

A Project access table links a `User` to a `FundProject`.

Possible future model name:

```text
FundProjectParticipant
```

or:

```text
FundProjectOrganiserAccess
```

Suggested fields to plan later:

- `id`;
- `organizationId`;
- `projectId`;
- `userId` nullable until invitation accepted;
- `email` snapshot/invite target;
- `name` snapshot;
- `role` such as `PRIMARY_ORGANISER`, `COLLABORATOR`, `VIEWER`;
- `status` such as `INVITED`, `ACTIVE`, `DISABLED`, `REMOVED`;
- `isPrimary`;
- `invitedAt`;
- `acceptedAt`;
- `disabledAt`;
- audit fields.

Pros:

- Project-specific access;
- supports one C2 user managing multiple Projects;
- supports multiple C2 users per Project;
- supports invitation/onboarding later;
- clean security boundary.

Cons:

- requires schema and service work before dashboard implementation;
- invitation/user provisioning rules still need design.

Verdict: recommended as the core access model.

### Option D - Hybrid Model

Recommended long-term model:

```text
IsoStack User for authentication
+ FundProjectParticipant for Project access
+ optional future FundOrganiserProfile for reusable organiser identity/contact history
```

This keeps authentication in IsoStack, Project access in FUND and richer organiser identity as a later layer.

## 9. Does C2 Dashboard Require Schema Changes?

Yes, for a safe implementation.

The first real C2 dashboard should not rely on organiser snapshot fields for access. It should wait for a minimal Project participant/access schema or another explicitly approved access model.

Recommended schema planning before implementation:

```text
Phase 1 Slice 1P-A - C2 Project Access Model Planning
```

or include this as the first part of Slice 1Q if the naming sequence is preferred.

Minimum schema need:

- tenant-scoped Project participant/access table;
- active/inactive/removal state;
- user linkage;
- optional invite email snapshot;
- uniqueness constraints preventing duplicate active user/project links;
- audit logging events.

## 10. Initial C2 Dashboard Route Recommendation

Use a clearly separate organiser route from the C1 admin route.

Recommended routes:

```text
/app/fund/organiser
/app/fund/organiser/projects/[id]
```

Rationale:

- avoids overloading `/app/fund/projects`, which is C1 admin today;
- uses existing British spelling already present in FUND fields;
- makes the C1/C2 boundary visible in routing;
- allows different navigation and permission checks.

Alternative route:

```text
/app/fund/my-projects
/app/fund/my-projects/[id]
```

This is friendlier for end users but less explicit architecturally. It may be useful as a redirect or label later.

## 11. C2 Dashboard Landing Page Layout

Recommended first layout:

- compact header with C1 tenant/producer context;
- welcome text using the C2 user's display name;
- summary counts:
  - active Projects;
  - waiting for organiser action;
  - closing soon;
  - completed Projects;
- Project cards/list;
- key deadline panel;
- communications/announcements placeholder;
- next action placeholder.

Avoid a marketing landing page. This should be a working dashboard.

Use SeasonPro club dashboard lessons:

- show the user's scoped entity/context at the top;
- show important dates/deadlines prominently;
- use action cards only when actions are genuinely available;
- show read-only banners when the user can view but not edit;
- avoid C1/admin controls in a C2 surface.

## 12. Project Card / List Design For C2

Project cards/list should show:

- Project number;
- Project name;
- status badge;
- lifecycle state;
- Event name where linked;
- effective close date;
- production deadline;
- number of active Products;
- next action label, if known;
- warning state when key dates or products are missing.

Recommended interaction:

- card/row click opens `/app/fund/organiser/projects/[id]`;
- no C1 admin action buttons;
- no archive/activate/close controls;
- search/filter can be added once a C2 user may have many Projects.

## 13. Project Detail View For C2

The C2 Project detail view should be an organiser-facing operational summary.

Recommended tabs/sections:

1. Overview
   - Project number, name, status, lifecycle state;
   - Event context;
   - effective close date;
   - production deadline;
   - organiser-facing instructions.

2. Products
   - selected Products;
   - workflow class labels;
   - prices/currency where organiser-facing;
   - no membership mutation controls.

3. Dates / Deadlines
   - Project opens/closes;
   - inherited Event close date display;
   - future Store close-date placeholder, explicitly deferred.

4. Tasks / Next Steps
   - placeholder for template/artwork/data/approval tasks;
   - no workflow engine yet.

5. Communications
   - placeholder for messages from C1;
   - no communications implementation yet unless explicitly planned.

6. Files / Artwork
   - placeholder only;
   - no media/asset workflow in first C2 dashboard.

## 14. Lifecycle / Status Visibility For C2

C2 users should see Project status and lifecycle state, but not mutate them in the first dashboard.

Recommended status wording:

- `DRAFT`: Being prepared by the organiser/producer.
- `ACTIVE`: Open or live for organiser activity.
- `PAUSED`: Temporarily paused.
- `CLOSED`: Closed to new activity/orders later.
- `COMPLETED`: Production/fulfilment complete.
- `ARCHIVED`: Historical Project.

C2 wording should be user-friendly and may differ from internal enum names, but should not contradict server state.

Lifecycle state `SETUP` is currently a string. Do not create lifecycle tables or a transition engine in the first C2 dashboard.

## 15. Artwork / Data / Template Submission Areas To Plan Later

Future C2 dashboard areas will likely include:

- downloadable templates;
- artwork upload;
- artwork return tracking;
- child/name/personalisation data upload;
- proof approval;
- submission status;
- production-ready checks;
- corrections/rejection loop.

These are central to FUND, especially AMOW A1/A2/B workflows, but should be planned after the C2 access model is correct.

Do not implement these in the first C2 dashboard slice.

## 16. Communication Surfaces To Plan Later

Future communication surfaces may include:

- C1 announcements to C2 organisers;
- Project-specific messages;
- deadline reminders;
- template/artwork instructions;
- order/Store launch notices;
- production or dispatch updates;
- notification preferences.

Planning dependency:

- decide whether FUND uses core communications directly;
- decide whether messages are Project-scoped, Event-scoped or tenant-scoped;
- decide whether C2 users can reply or only receive/read.

## 17. Store / Order / Payment Touchpoints To Defer

Do not build Store, Order or payment features as part of the C2 dashboard foundation.

The C2 dashboard should reserve space for future commerce states, but must not assume one store model.

Future modes already captured in FUND docs include:

- individual buyer / Project bulk fulfilment;
- C2 organiser / bulk Project purchase;
- conventional individual e-commerce.

These affect Store, Order, Checkout, Shipping, Production Export and Fulfilment design and should be handled in later Commerce Core and FUND Store planning.

## 18. Security And Tenant-Scoping Rules

Required security principles:

- C2 dashboard access must require authentication.
- FUND module access must still be feature/product gated.
- C2 user must only see Projects assigned to them.
- Project access must be scoped by `organizationId`.
- Cross-tenant Project ids must return `NOT_FOUND` or `FORBIDDEN` without leaking details.
- C1-only endpoints must remain protected by admin checks.
- C2 endpoints must not reuse C1 admin mutations casually.
- Snapshot contact fields must not grant access.
- Event linkage must remain same-tenant only.
- Audit logs should record meaningful C2 actions once mutations exist.

Open tenant question:

Current `User` has a single `organizationId`. If a C2 organiser must work with multiple C1 tenants using one login, IsoStack may need a broader membership model. Until then, Phase 1 can require one C2 user account per C1 tenant or defer multi-tenant organiser access.

## 19. Out Of Scope

Out of scope for Slice 1P and the first C2 dashboard planning pass:

- application code changes;
- Prisma schema edits;
- migrations;
- `db:push`;
- seed/reset commands;
- routers;
- services;
- Zod schemas;
- tRPC endpoints;
- C2 dashboard implementation;
- organiser invitation implementation;
- public Project Request/onboarding implementation;
- C2 user provisioning implementation;
- Store schema;
- Order schema;
- Commerce Core implementation;
- payments;
- commissions;
- production batching;
- fulfilment/shipping;
- lifecycle tables;
- lifecycle transition engine;
- SeasonPro integration;
- marketplace expansion;
- AI workflows.

## 20. Risks And Open Questions

### Key Risks

- Building C2 dashboard before access model would create unsafe visibility rules.
- Treating organiser snapshot fields as auth would be brittle and insecure.
- Letting C2 users edit Project admin fields could undermine C1 production control.
- Starting commerce before C2 operating needs are clear could bake in the wrong Store model.
- Multi-tenant C2 organisers may exceed current `User.organizationId` assumptions.

### Open Questions

1. Is a C2 organiser always an authenticated IsoStack `User`?
2. Should an unauthenticated organiser be represented first as a pending participant/invite email?
3. Does FUND need a `FundOrganiserProfile`, or is `FundProjectParticipant` enough for Phase 1?
4. Can one C2 user manage multiple Projects?
5. Can one Project have multiple C2 users?
6. Can one C2 user belong to multiple C1 tenants with one login?
7. Should C2 access be granted by C1 assignment, invitation acceptance or Project Request approval?
8. Should C2 dashboard be read-only until Project Request/onboarding is designed?
9. Which Project statuses should be visible to C2 users?
10. Should archived/completed Projects remain visible historically?
11. What is the first safe C2 mutation before commerce exists?
12. Should C2 users ever see Product pricing before Store planning?
13. What communications should be visible in the first C2 dashboard?
14. Does C2 dashboard need separate module navigation from C1 FUND admin navigation?

## 21. Recommended Implementation Split

Recommended next sequence:

### 1P-A - C2 Access Model Planning

Planning only.

Decide:

- `FundProjectParticipant` versus other access model;
- User relationship;
- invitation placeholder fields;
- role/status enum needs;
- tenant constraints;
- audit events.

### 1P-B - C2 Project Participant Schema

Schema only, if approved.

Implement minimal Project participant/access table. No UI.

### 1Q-A - C2 Read-Only API/Services

Create C2-specific read endpoints:

- list assigned Projects;
- get assigned Project;
- no C1 mutations;
- no Store/Order/commerce;
- strict tenant and participant checks.

### 1Q-B - C2 Dashboard Foundation UI

Build read-only organiser dashboard:

```text
/app/fund/organiser
/app/fund/organiser/projects/[id]
```

Show assigned Projects, dates, status, products and next-step placeholders.

### 1Q-C - C2 Dashboard Review

Authenticated browser review of C2 dashboard and access isolation.

Only after this should planning continue into:

- Project Request/onboarding;
- Commerce Core;
- FUND Store;
- production/fulfilment/communications.

## 22. Recommended Next Implementation Prompt

```text
Proceed with FUND Phase 1 Slice 1P-A planning only: C2 Project Access Model.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-24-fund-phase-1-slice-1p-c2-organiser-dashboard-proposal.md
- active FUND docs in isodocs/docs/modules/fund/
- all Slice 1C through 1O confirmation and planning documents
- current FUND Project schema and services
- current IsoStack User, ModuleRole and product/module access patterns
- SeasonPro club user access patterns where useful

Planning only.

Do not edit application code.
Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not create routers, services, Zod schemas or tRPC endpoints.
Do not implement C2 dashboard.
Do not create organiser invitations, Project Request/onboarding, Store schema, Orders, Commerce Core, payments, commissions, production batching, lifecycle engine or AI workflows.

The goal is to decide the minimal safe access model for C2 organisers before any C2 dashboard implementation.

The proposal must cover:
1. Whether C2 organiser is an IsoStack User, FUND organiser profile, Project participant/access record or hybrid.
2. Recommended `FundProjectParticipant` or equivalent model.
3. Tenant scoping and same-tenant constraints.
4. Whether `userId` can be nullable for pending invites.
5. Role/status enum strategy.
6. Whether one user can manage multiple Projects.
7. Whether one Project can have multiple users.
8. Whether one user can belong to multiple C1 tenants under current IsoStack constraints.
9. Relationship to existing `FundProject.organiserName/email/phone` snapshot fields.
10. C1 assignment flow.
11. Future invitation/onboarding compatibility.
12. C2 read-only dashboard implications.
13. Audit events.
14. Required indexes and uniqueness constraints.
15. Migration risks.
16. Open decisions before schema implementation.
17. Recommended schema-only implementation prompt.

Planning only. Do not implement.
```

## 23. Planning Recommendation

Proceed to C2 access model planning before any C2 dashboard implementation.

The first C2 dashboard should be narrow and mostly read-only, but even read-only access needs an explicit Project participant/access relationship. This should be resolved before building routes or UI.

Recommended next slice:

```text
Phase 1 Slice 1P-A - C2 Project Access Model Planning
```
