# FUND Phase 1 Slice 1P-K2 - C2 Client Dashboard And Client-Owned Project Management Planning

Date: 2026-06-30

Status: Planning

## 1. Slice Goal

Plan the first authenticated C2 FUND Client dashboard and Client-owned Project management surface.

This is no longer a read-only-only slice. K1 has made Client members login-capable, so K2 should establish the first useful Client dashboard for demo and core workflow purposes:

- resolve authenticated `User -> FundClientMember -> FundClient`;
- show Client/account context;
- show linked Projects;
- allow authorised Client members to create Projects directly under their Client/account;
- allow safe editing of Project basics;
- support row click from Projects table to Project detail;
- provide Project detail tabs, including current Details plus placeholder Products and Orders tabs.

This planning slice does not implement application code, schema changes or migrations.

## 2. Accepted Foundations

K2 can rely on:

```text
authenticated User
-> active FundClientMember
-> FundClient
-> linked FundProjects
```

Recent accepted foundations:

- `FundClient` is the C2 Client organisation/account.
- `FundProject.clientId` explicitly links Projects to Clients.
- C1 can manage Clients and Projects.
- C1 Client detail has top-level Client Details, Projects and Users tabs.
- C1 can create Client members and same-tenant platform Users without sending email.
- Auth routing recognises active Client members and currently routes them to a safe unavailable state.

K2 replaces that unavailable state with the first real C2 Client dashboard.

## 3. Product Position

The C2 Client dashboard is the surface where a Client organisation manages its own fundraising work.

It is not:

- a C1 admin dashboard;
- a public Project initiation form;
- a moderation queue;
- a Store/Commerce surface yet.

The dashboard is Client-scoped. Client ownership must come from authenticated membership context, not from email inference, organiser snapshots or user-editable client IDs.

## 4. C2 Routes To Plan

Recommended first route set:

```text
/app/fund/client
/app/fund/client/projects
/app/fund/client/projects/[id]
```

Optional route split if the codebase prefers detail isolation:

```text
/app/fund/client/projects/new
/app/fund/client/projects/[id]/edit
```

The implementation may choose modal creation/editing if that better matches existing FUND C1 UI patterns.

## 5. Access Resolution

Every C2 Client dashboard request should resolve context server-side or service-side:

```text
session.user.id
-> active FundClientMember where userId = session.user.id
-> status = ACTIVE
-> dashboardAccessEnabled = true
-> accessLevel != NONE
-> member not archived
-> linked FundClient active and not archived
```

If one Client membership is available, use it as the active Client context.

If multiple memberships are available, first implementation may:

- show a simple Client switcher/selection page; or
- default to the primary membership and provide a visible switcher placeholder.

Do not silently expose Projects from all Clients in one mixed list unless the UI clearly identifies Client context and access is explicitly checked per Client.

## 6. Client Dashboard Landing

The first dashboard should show:

- Client/account name;
- Client type/status if useful;
- main contact snapshot if useful;
- summary counts for linked Projects;
- call-to-action for New Project if the member has create permission;
- Projects table preview or direct Projects table.

Keep the dashboard quiet and operational. It should feel like a tenant/client work surface, not a marketing landing page.

## 7. Projects Page

The Projects page should show a table of Projects linked to the active Client.

Recommended columns:

- Project number;
- Project name;
- status;
- lifecycle state;
- linked Event;
- Project start date;
- Project closing date;
- updated date.

Table behaviour:

- search;
- status filter;
- sort;
- row click opens Project detail;
- no row action icon buttons unless required by an established table pattern.

Empty state:

```text
No Projects yet
```

with New Project action if allowed.

## 8. Client-Owned Project Creation

Authorised Client members should be able to create Projects directly from the Client dashboard.

Required rules:

- set `FundProject.clientId` from authenticated Client context;
- never accept Client ownership from client input;
- C1 tenant/organization scope comes from the Client membership and session context;
- Project starts in a safe editable state;
- C1 can still see/administer the created Project.

Recommended first create fields:

- Project name;
- Project type / fundraising format;
- Event selection or Standalone;
- Project start date;
- Project closing date;
- notes/description.

Event-linked creation:

- Event must be selectable for Client-created Projects;
- Event must belong to the same C1 tenant;
- Event must not be archived;
- Project start date must be on or after Event start/open date;
- Project closing date must be on or before Event closing/end date;
- Project closing date may be earlier than the Event closing/end date.

Standalone creation:

- Project must have its own start and closing dates;
- closing date must be after start date;
- Store/Commerce distribution remains after the closing date and is not implemented here.

## 9. Project Editing

Client members with edit permission should be able to edit safe Project basics while the Project is in safe editable states.

Recommended editable fields in K2:

- Project name;
- Project start date;
- Project closing date;
- notes/description;
- selected Event only while Project has no downstream activity and the lifecycle allows it.

Do not allow C2 edits that undermine C1 operational control.

Project type should use the same tenant-facing option set as the public Project initiation form:

- Individual Artwork Project;
- Group personalised product project;
- Bulk order / club-funded project;
- Not sure yet.

This is a fundraising Project type/format, not a Store, Commerce or Product workflow implementation. In K2 it may be stored as safe Project metadata if no dedicated Project type field exists. Future Product/Catalogue suitability planning should use this value when deciding which Products can be selected.

Out of scope for K2 editing:

- changing Client ownership;
- changing C1 tenant scope;
- Store launch settings;
- order data;
- commerce/payment fields;
- production/dispatch fields;
- commission settings;
- notification triggers.

## 10. Project Detail Page

Row click from the Projects table should open a Client-scoped Project detail page.

Recommended tabs:

```text
Details
Products
Orders
```

### Details Tab

Show Project basics and allow safe edit action where permitted.

Details should include:

- Project number;
- name;
- status/lifecycle;
- linked Event if present;
- dates;
- notes/description;
- C1 operational status where safe to expose.

### Products Tab Placeholder

Show a placeholder explaining that Product selection and availability are planned separately.

Do not implement Product membership, Product deselection, catalogue selection or Store product setup in K2.

Future linkage should align with:

```text
1Q - Event/Catalogue/Product Availability And Workflow Suitability Planning
```

### Orders Tab Placeholder

Show a placeholder explaining that Orders and sales reporting depend on Store/Orders/Commerce.

Do not implement Orders, Commerce, payments, sales reporting or commission in K2.

## 11. Permission Model For K2

Use existing `FundClientMember.accessLevel` as the first coarse permission boundary.

Recommended first mapping:

| Access Level | Dashboard | Projects List | Project Detail | Create/Edit Project |
| --- | --- | --- | --- | --- |
| VIEWER | yes | yes | yes | no |
| PROJECT_MANAGER | yes | yes | yes | yes |
| ADMIN | yes | yes | yes | yes |
| NONE | no | no | no | no |

Role labels such as Treasurer, Secretary or Project Lead remain descriptive labels, not permission checks.

## 12. Service/API Planning

K2 likely needs Client-scoped C2 procedures separate from C1 admin procedures.

Recommended router/service namespace:

```text
fund.clientDashboard.*
```

Possible procedures:

```text
getContext
listProjects
getProject
createProject
updateProject
```

Each procedure must:

- require authenticated session;
- resolve Client from `User -> FundClientMember`;
- require active member and active Client;
- derive organizationId and clientId from trusted context;
- never accept organizationId from client input;
- never trust clientId input as proof of access;
- validate Event references as same-tenant and selectable;
- support retry/double-click protection for direct Client-owned Project creation, using an idempotency key where practical;
- write audit events for Project creation/update where current conventions make this straightforward.

## 13. UI Boundaries

K2 UI should not expose C1 admin controls.

Do not show:

- all Clients;
- C1 Project Intake;
- C1 Product/Catalogue management;
- C1 Event management;
- C1 approval/moderation queues;
- C1 production/dispatch/commission tools.

The navigation should be Client-scoped and separate from the C1 FUND sidebar.

The current `/app/fund/client-unavailable` page should be replaced or bypassed by the new dashboard once K2 is implemented.

## 14. Implementation Split

Recommended implementation split:

```text
1P-K2-A - C2 Client Dashboard API/Services
1P-K2-B - C2 Client Dashboard UI
1P-K2-C - C2 Client Dashboard Review And Smoke Testing
```

K2-A should implement Client-scoped context, Projects list/get and safe create/update services.

K2-B should implement dashboard, Projects page, Project create/edit UI and Project detail tabs with Products/Orders placeholders.

K2-C should review access boundaries, row-click behaviour, create/edit smoke testing and C1/C2 separation.

## 15. Explicit Non-Goals

Do not implement in K2:

- Client user/member schema changes;
- invitations;
- automatic emails;
- notification templates;
- public Project initiation changes;
- C1 approval workflows;
- Product membership management;
- Store;
- Orders;
- Commerce;
- Sales/Reporting;
- production;
- dispatch;
- commission;
- SeasonPro integration.

## 16. Recommended Next Slice

```text
1P-K2-A - C2 Client Dashboard API/Services
```

Implementation goal:

```text
Implement authenticated Client-scoped FUND dashboard API/services for resolving Client context, listing/getting linked Projects, and creating/updating safe Client-owned Project basics from trusted FundClientMember context.
```

Do not implement Store, Orders, Commerce, Product membership, notifications, C1 admin surfaces or schema changes in K2-A unless a blocker is identified and explained first.
