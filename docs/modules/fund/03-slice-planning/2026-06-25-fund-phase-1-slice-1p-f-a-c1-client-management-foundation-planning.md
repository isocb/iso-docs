# FUND Phase 1 Slice 1P-F-A - C1 Client Management Foundation Planning

Date: 2026-06-25

Status: Planning only

## 1. Slice Goal

Plan the C1 Client Management foundation needed for the AMOW founding-tenant presentation and near-term FUND operating model.

This slice re-centres the immediate roadmap around the C1 organisational dashboard rather than the interim C2 read-only organiser dashboard.

The presentation priority is to show and explain that AMOW can manage:

- Clients;
- Products;
- Catalogues;
- Events;
- Projects;
- Project Products;
- Project/Event linkage.

The current 1P-D C2 read-only organiser dashboard remains technically safe, but it is not the immediate product priority for AMOW and must not be treated as the final C2 operating model.

## 2. Context

Current C1 foundation already in place:

- Products;
- Catalogues;
- Projects;
- Events;
- Project/Event linkage;
- Project Product membership;
- C1 admin surfaces.

Important correction from 1P-F:

```text
C2 is the Project management node.
```

However, the immediate AMOW priority is for C1/AMOW to manage the C2 Client/account organisations that own and operate Projects.

Strategic FUND model:

```text
C1 Producer/Admin Tenant
-> C2 Client/account
-> C2 users
-> Projects
-> future Orders / Sales / Reporting / Communications
```

Examples of C2 Client/account organisations:

- school;
- club;
- PTA;
- charity branch;
- fundraising organisation;
- customer account.

## 3. AMOW Presentation Priority

The AMOW presentation should be able to explain this operating model:

```text
AMOW manages Clients, Products, Events and Projects.
Clients are fundraising organisations such as schools, clubs or PTAs.
Projects belong to Clients.
Future Store, Orders, Sales, Communications and Reporting sit naturally under the Client and Project structure.
```

This means the next planning and implementation work should make the C1 organisational dashboard coherent around Client management before expanding the interim C2 dashboard.

## 4. User-Facing Term

Recommended term for AMOW/C1 admin UI:

```text
Client
```

Rationale:

- works for schools, clubs, PTAs, charity branches, fundraising organisations and customer accounts;
- is natural in a C1 producer/admin context;
- avoids treating a single organiser contact as the account owner;
- leaves SeasonPro free to continue using `Club` in module-specific UI while mapping later to the same account concept.

Alternative terms considered:

- Account: platform-friendly but less natural for AMOW presentation language.
- Organisation: technically accurate but too generic for day-to-day admin.
- Organiser: too person-centred and conflicts with contact snapshots.

Recommendation:

```text
Use Client as the FUND C1 admin term.
Keep the underlying schema name open until the schema slice decides FUND-specific vs reusable core.
```

## 5. Minimal Client Record Before Tuesday

The minimal AMOW-facing Client concept should support:

- Client name;
- Client code or slug;
- Client type, such as school, club, PTA, charity branch, fundraising organisation or customer account;
- primary contact name;
- primary contact email;
- primary contact phone;
- address or delivery/contact location, if in scope;
- status, such as active/inactive/archived;
- internal notes;
- tenant ownership via C1 `organizationId`;
- Project relationship.

For the Tuesday presentation, the most important elements are:

```text
Client name
Client type
Primary contact snapshot
Client status
Projects belonging to the Client
```

Users, invitations, orders, sales, reporting and communications can be shown as future tabs/sections in planning or presentation material, but should not be implemented until explicitly sliced.

## 6. Client To Project Relationship

Recommended target relationship:

```text
Client has many Projects.
Project belongs to one Client where the Project is Client-scoped.
```

Likely future Project field:

```text
FundProject.clientId
```

or, if a reusable core account model is adopted:

```text
FundProject.clientAccountId
```

Tenant boundary remains:

```text
FundProject.organizationId = C1 tenant
Client.organizationId = C1 tenant
```

Same-tenant rules should be required when linking a Project to a Client.

Standalone Projects may still exist if explicitly allowed, but AMOW's core operating story should be:

```text
Clients own Projects.
```

## 7. FUND-Specific First Or Reusable IsoStack Core

This slice should not decide schema implementation, but it should frame the next decision.

### FUND-Specific First

Possible shape:

```text
FundClient
FundClientUser
FundProject.clientId
```

Pros:

- fastest path to AMOW clarity;
- lower immediate platform impact;
- can be tailored to FUND client/project needs.

Cons:

- may duplicate SeasonPro Club/client concepts;
- may require later migration to a core account model;
- weakens cross-module Client view if left isolated.

### Reusable IsoStack Core

Possible shape:

```text
ClientAccount
ClientAccountUser
FundProject.clientAccountId
SeasonProClub.clientAccountId
```

Pros:

- strongest long-term architecture;
- supports SeasonPro + FUND integration;
- supports C1 Client view across modules.

Cons:

- larger design and migration surface;
- riskier before the Tuesday presentation;
- needs wider platform review.

### Recommended Planning Position

For AMOW presentation:

```text
Present the concept as Client.
Plan the foundation now.
Defer the final schema choice to a dedicated schema-options slice.
```

Implementation should not proceed until the schema choice is explicitly approved.

## 8. SeasonPro Mapping

SeasonPro precedent:

```text
C1 League
-> C2 Club
-> Club users
-> Teams
```

FUND parallel:

```text
C1 Producer/Admin
-> C2 Client
-> C2 users
-> Projects
```

Integrated SeasonPro + FUND:

```text
SeasonPro Club may also be the FUND Client/account and Project creator.
```

Planning implication:

```text
Do not create a FUND Client model that makes future SeasonPro Club mapping awkward without first documenting the trade-off.
```

## 9. C1 Client List

A C1 Client list should eventually show:

- Client name;
- Client type;
- status;
- primary contact;
- Project count;
- active Project count;
- latest or next relevant Event context, if useful;
- last updated date;
- created date;
- quick link to Client detail.

Table behaviour should follow the current IsoStack table convention:

- fuzzy search;
- column-click sorting with direction indicator;
- clear archived filtering;
- stable empty/loading/error states;
- no decorative colour use.

## 10. C1 Client Detail / View

A C1 Client detail page should be a child management page, not a simple CRUD modal, because Client is an operational parent entity.

Likely sections:

- overview/profile;
- contacts;
- Projects;
- Events/context;
- users, future;
- Products/Catalogues context, future;
- Orders, future;
- sales/reporting, future;
- communications/announcements, future;
- key-date automation status, future;
- internal notes/audit context.

Near-term AMOW-safe detail view:

```text
Client profile
Primary contact snapshot
Projects list/summary
Future tabs clearly deferred
```

## 11. C1 Client View vs Hat-Swapping

Client view:

```text
C1 admin enters a managed Client/account context for support, preview or administration.
```

Hat-swapping:

```text
The same authenticated user chooses between their own C1 admin context and their own C2 Client/user context.
```

Rules:

- Client view must not rely on unsafe impersonation.
- Client view must remain a C1 admin/support capability.
- Hat-swapping must only expose contexts the authenticated user actually has.
- Future implementation must keep these concepts visually and technically distinct.

## 12. Relationship To FundProjectParticipant

`FundProjectParticipant` remains useful as an interim and future supporting model for:

- named Project contacts;
- Project-level role overrides;
- exception access;
- helper/contact visibility;
- transition access.

It should not be treated as the strategic ownership model for Projects.

Strategic ownership should move toward:

```text
Client/account owns Projects.
C2 users belong to Client/account.
```

## 13. What Must Be Deferred Until After Presentation

Defer:

- C2 dashboard expansion beyond the current read-only interim surface;
- C2 mutations;
- C2 invitations;
- Project Request/onboarding;
- Store schema;
- Orders;
- Commerce Core;
- payments;
- commissions;
- sales/reporting implementation;
- communications implementation;
- key-date automation implementation;
- SeasonPro mapping implementation;
- C1 Client view impersonation/support tooling;
- final reusable core Client/account schema unless explicitly approved.

## 14. Risks And Open Questions

Open questions:

- Is `Client` definitely the AMOW-facing term?
- Is a minimal Client model needed before Tuesday, or is a planning/presentation model sufficient?
- Should the first schema be FUND-specific or reusable core?
- Should Projects be required to belong to a Client, or may some remain standalone?
- How should existing Projects be backfilled if a Client relationship is added?
- Can a Client have multiple active primary contacts?
- How soon does C1 need to manage Client users?
- How should SeasonPro Clubs map without forcing immediate platform migration?

Risks:

- building further participant-scoped C2 dashboard features could harden the wrong model;
- rushing a reusable core Client/account schema could create platform blast radius before the AMOW presentation;
- building a FUND-only Client model may create future migration work;
- confusing Client view with hat-swapping could create unsafe access semantics.

## 15. Recommended Next Slice

Recommended next controlled slice:

```text
FUND Phase 1 Slice 1P-F-B - C1 Client Management Schema Options
```

Goal:

```text
Decide whether the Client/account foundation should be FUND-specific, reusable IsoStack core, or a hybrid, and define the minimum safe schema before implementation.
```

The schema-options slice should explicitly cover:

- model name and user-facing term;
- tenant scoping;
- Client to Project relationship;
- Client users relationship;
- SeasonPro Club mapping;
- migration/backfill strategy;
- C1 Client list/detail UI implications;
- what can be safely implemented before the AMOW presentation.

## 16. Recommended Implementation Boundary

Do not implement from this planning document directly.

Before code/schema work:

1. Review and accept the Client/account direction.
2. Create a schema-options slice.
3. Decide FUND-specific vs reusable core vs hybrid.
4. Create an implementation prompt from the accepted schema-options plan.
