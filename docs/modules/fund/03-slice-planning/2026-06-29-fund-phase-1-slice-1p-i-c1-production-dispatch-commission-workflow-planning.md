# FUND Phase 1 Slice 1P-I - C1 Production, Dispatch And Commission Workflow Planning

Date: 2026-06-29

Status: Planning note / do not implement yet

## 1. Purpose

Record the future C1 production/admin workflow surface before FUND proceeds into Store, Orders, Commerce, Sales/Reporting or fulfilment implementation.

Core clarification:

```text
The C1 dashboard is the Project administration, production, dispatch and commission workflow surface.
```

The current C1 foundation already supports Clients, Products, Catalogues, Events, Projects, Project/Event linkage and Project Product membership. Future commerce must fit into this operational surface rather than treating orders as an isolated checkout feature.

## 2. Current Foundation

Current accepted foundation:

- C1 Client Management.
- Products.
- Catalogues.
- Events.
- Projects.
- Project/Event linkage.
- Project/Product membership.
- Project/Client linkage.
- Project Intake schema/moderation planning.

Still deferred:

- Store.
- Orders.
- Commerce Core.
- Sales/Reporting.
- Production batching.
- Artwork checking.
- Dispatch/fulfilment.
- Commission.
- Communications.

## 3. C1 Project Administration

C1/AMOW needs to administer Projects through their operational lifecycle.

Future C1 Project administration should include:

- Project profile and Client context;
- Event context where linked;
- Product membership and Product readiness;
- artwork/data readiness;
- production readiness;
- order/sales status once commerce exists;
- dispatch/fulfilment status;
- commission status;
- communications status once planned.

Project remains the operational context C1 users recognise, even when production batching groups work across Projects.

## 4. Artwork Checking

Artwork checking is Project-linked.

Future workflow should support:

- Project-level artwork checklist;
- Product-specific artwork requirements;
- submitted artwork/data references;
- C1 review status;
- approval/rejection/needs-change status;
- reviewer notes;
- timestamps and audit events;
- visibility to future Client dashboard where appropriate.

Out of scope for this note:

- file upload implementation;
- asset storage;
- proofing UI;
- approval notifications.

Those require separate planning before implementation.

## 5. Grouping Similar Products Across Projects

Production may need to be grouped by similar Products across Projects for efficiency.

Examples:

- the same Product ordered by multiple school Projects;
- the same Catalogue/Product/workflow class across an Event;
- multiple Projects sharing a production batch window.

Planning implication:

```text
Production grouping is not always one Project at a time.
```

Future production planning should support:

- Project context;
- Product/workflow grouping;
- Event/campaign grouping;
- production batch grouping;
- filtering by Product, Catalogue, workflow class, Event, Client and deadline;
- batch status separate from Project status.

## 6. Project-Level Production Status

Project-level production status should answer:

- Is this Project ready for production?
- Are artwork/data checks complete?
- Are all required products ready?
- Are orders/sales closed or still active?
- Is the Project part of one or more production batches?
- Has production completed?
- Is dispatch ready?

Potential future statuses:

- `NOT_READY`
- `AWAITING_ARTWORK`
- `READY_FOR_PRODUCTION`
- `IN_PRODUCTION`
- `PRODUCTION_COMPLETE`
- `READY_FOR_DISPATCH`
- `DISPATCHED`
- `COMPLETED`

These are planning concepts only. Do not add lifecycle/status schema until a dedicated slice accepts it.

## 7. Dispatch / Fulfilment

Dispatch is Project/client-linked.

Future dispatch workflow should consider:

- Client delivery/contact details;
- Project delivery point;
- Event/campaign dispatch windows;
- grouped dispatch by Client, Project, Event or batch;
- dispatch notes;
- tracking/reference fields;
- partial dispatch handling;
- pickup vs shipping vs internal handover;
- audit events.

Dispatch should not be bolted onto Orders alone. It must remain visible from Project and Client context.

## 8. Commission

Commission should later sit under the Client/Project/Order/Commerce structure.

Future commission planning should decide:

- whether commission belongs primarily to Client, Project, Event, Product, Order line or some combination;
- whether commission rates vary by Product/Catalogue/Event;
- how commission is calculated from paid Orders;
- when commission is recognised;
- how commission is reported to C1 and possibly C2;
- how adjustments/refunds affect commission.

Do not implement commission before Commerce/Orders and reporting are planned.

## 9. Relationship To Store, Orders And Commerce

Store, Orders and Commerce must support:

- Client/account context;
- Project context;
- Event context where relevant;
- Product/Catalogue availability rules;
- production readiness;
- dispatch/fulfilment requirements;
- commission/reporting needs.

Control rule:

```text
Do not design Store, Orders or Commerce as isolated checkout/order features.
They must preserve C1 production/admin workflow and future Client dashboard engagement surfaces.
```

## 10. Relationship To Client And Project

Client is the C2 organisation/account.

Project is the operational fundraising unit under a Client.

Future production/admin views should allow C1 to move between:

- Client overview;
- Client Projects;
- Project production readiness;
- Product/workflow production grouping;
- dispatch status;
- commission/sales reporting once planned.

## 11. Relationship To Client Dashboard

The future Client dashboard is expected to support:

- Project initiation;
- Project status visibility;
- engagement prompts;
- C1 announcements;
- special offers/campaign prompts;
- 1:1 Client communication;
- dashboard-visible messages.

Those communications are not implemented by production workflow planning, but the production workflow should eventually provide appropriate status signals to the Client dashboard.

Example:

```text
Artwork needs attention.
Project approved for production.
Dispatch ready.
Campaign/order window closing.
```

Notification sending remains deferred until controlled communications are planned.

## 12. SeasonPro Precedent

SeasonPro precedent:

- C1 League manages Clubs, Teams, processes, communications and automation.
- Clubs have dashboards.
- Announcements and communications are controlled C1-to-C2 surfaces.
- Key dates support automation and dashboard-visible messages.

FUND should follow the same principle:

- C1 Producer/Admin manages Clients, Projects, production and communications.
- Client dashboard becomes the C2 engagement surface.
- Production/admin workflows remain C1-controlled.

## 13. Deferred Implementation Boundaries

Do not implement in this slice:

- Prisma schema;
- migrations;
- routers/services/Zod;
- C1 production UI;
- artwork upload/checking UI;
- production batching;
- dispatch/fulfilment;
- commission;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- Client dashboard communications;
- announcement delivery;
- special offers/campaign prompts;
- 1:1 messaging;
- notification sending;
- key-date automation.

## 14. Recommended Future Split

Recommended future planning sequence:

1. `1P-I-A - C1 Production Workflow Schema Options`
2. `1P-I-B - Artwork/Data Submission And Checking Planning`
3. `1P-I-C - Production Batch Planning`
4. `1P-I-D - Dispatch/Fulfilment Planning`
5. `1P-I-E - Commission And Reporting Planning`

Only after these planning decisions should Store, Orders and Commerce implementation proceed in detail.

## 15. Recommended Control Decision

Before Store/Commerce work starts, confirm:

- how Orders map to Project and Client;
- how Product lines map to production grouping;
- how artwork/data readiness is represented;
- how dispatch/fulfilment is tracked;
- how commission is calculated/reported;
- which C1 production statuses may later surface to Client dashboards.

Until then:

```text
Commerce and Store remain future planning lanes.
```
