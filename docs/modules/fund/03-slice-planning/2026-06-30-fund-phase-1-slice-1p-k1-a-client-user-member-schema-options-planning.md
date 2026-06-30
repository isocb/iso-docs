# FUND Phase 1 Slice 1P-K1-A - Client User/Member Schema Options Planning

Date: 2026-06-30

Status: Planning

## 1. Slice Goal

Plan the smallest safe schema direction for FUND Client users/members so C1 can later manage Client dashboard access from the Client detail page.

This is planning only. It does not implement application code, Prisma schema changes, migrations, invitations, email sending, notifications, C2 dashboard UI, Store, Orders, Commerce or production workflows.

## 2. Context

Accepted model:

```text
FundClient = C2 Client organisation/account
FundClientUser / ClientMember = person linked to a FundClient
User = authenticated platform identity
Role label = human-facing organisation role
Access permission = what the person may do in FUND
```

The C1 Client detail page should evolve into:

```text
Client Details
Projects
Users
```

The `Users` tab needs a model that can hold people associated with the Client before, during and after they become authenticated platform users.

## 3. Current Schema Signals

Current relevant structures:

- `FundClient` is tenant-scoped by `organizationId` and has same-tenant unique keys for `id`, `code` and `slug`.
- `FundProject.clientId` links Projects to Clients through a same-tenant relation.
- `FundProjectParticipant` is Project-scoped and may link to a platform `User`, but it represents participation in a specific Project rather than Client/account membership.
- `LMSProClubOfficial` provides a useful precedent for a person linked to an organisation/account-like record, with a `role` label and `isPrimary` marker.
- `User` already belongs to an `Organization`, but that alone does not prove access to a specific FUND Client/account.

Important distinction:

```text
FundProjectParticipant = Project-level contact/participant
FundClientUser / ClientMember = Client/account-level member
```

Do not use Project participant records as the Client dashboard access model.

## 4. Option A - FUND-Specific Client Member Model

Create a new FUND-owned model such as:

```text
FundClientMember
```

or:

```text
FundClientUser
```

Recommended working name:

```text
FundClientMember
```

Rationale:

- avoids implying every member already has a platform login;
- allows C1 to capture real Client contacts before invitation/access exists;
- keeps the Client/account membership model separate from Project-level participant records;
- mirrors the SeasonPro Club/user concept without forcing SeasonPro coupling.

Likely fields:

```text
id
organizationId
clientId
userId nullable
firstName
lastName
displayName nullable
email
phone nullable
roleLabel nullable
accessLevel
status
isPrimary
dashboardAccessEnabled
lastAccessedAt nullable
createdById nullable
updatedById nullable
createdAt
updatedAt
archivedAt nullable
```

Recommended status enum:

```text
FundClientMemberStatus

DRAFT
ACTIVE
INACTIVE
ARCHIVED
```

Recommended access enum for first implementation:

```text
FundClientMemberAccessLevel

NONE
VIEWER
PROJECT_MANAGER
ADMIN
```

`NONE` supports contact-only records that do not have dashboard access.

## 5. Option B - Reuse FundProjectParticipant

Do not choose this option for Client dashboard access.

Problems:

- Project participants are scoped to one Project, not the Client/account.
- A Client member may need access to all Client Projects.
- A Client member may exist before any Project is approved or created.
- Project participant status/invitation fields are not the same as Client dashboard access state.

`FundProjectParticipant` can remain useful later for Project-specific organiser/contact roles.

## 6. Option C - Platform User Only

Do not choose this option as the first model.

Problems:

- A platform `User` belongs to a tenant, not automatically to a specific FUND Client/account.
- The same C1 tenant may manage many Clients.
- Contact/member records may need to exist before login access.
- Role label and Client-level access permission need to be scoped to a Client.

A nullable `userId` on `FundClientMember` gives the useful part of this option without making platform identity the whole model.

## 7. Recommended Schema Direction

Use Option A:

```text
FundClientMember
```

The model should be FUND-specific, tenant-scoped and Client-scoped.

Recommended relations:

```text
FundClientMember.organizationId -> Organization.id
FundClientMember.clientId -> FundClient.id through same-tenant relation
FundClientMember.userId -> User.id nullable
```

Same-tenant Client relation should follow existing FUND composite relation conventions:

```text
client FundClient @relation(fields: [organizationId, clientId], references: [organizationId, id], onDelete: Cascade or Restrict)
```

Recommended deletion behaviour:

- if a Client is hard-deleted by future maintenance tooling, members may cascade with the Client;
- operational C1 UI should archive Clients and members rather than hard-delete;
- platform `User` deletion should set `userId` to null if supported by relation policy, preserving the Client contact/member record as audit context.

## 8. Role Label Vs Access Permission

Keep role label and access permission separate.

Role labels are tenant/client-facing descriptors:

- Treasurer;
- Secretary;
- Club Secretary;
- PTA Chair;
- Headteacher;
- Project Lead;
- Finance Contact;
- General Contact.

Access level controls what the member may do:

- `NONE` - contact/member only, no dashboard access;
- `VIEWER` - view Client dashboard and Projects;
- `PROJECT_MANAGER` - create/update Client Projects within allowed rules;
- `ADMIN` - manage Client account users/settings once those surfaces exist.

Do not encode all role labels as permissions.

## 9. Same-Tenant Scoping

Required rules:

- `organizationId` is always the C1 FUND tenant boundary;
- `clientId` must belong to the same `organizationId`;
- if `userId` is set, the linked `User.organizationId` must match `FundClientMember.organizationId`;
- Client dashboard access derives from authenticated platform `User` plus active same-tenant `FundClientMember` relation;
- Client dashboard routes must not accept trusted Client ownership from public input, hidden fields or respondent email.

Recommended indexes and constraints:

```text
@@unique([organizationId, id])
@@unique([organizationId, clientId, email])
@@unique([organizationId, clientId, userId])
@@index([organizationId, clientId, status])
@@index([organizationId, userId, status])
@@index([organizationId, email, status])
@@index([organizationId, dashboardAccessEnabled])
```

The `userId` uniqueness needs care because nullable unique behaviour differs by database. If a nullable composite unique is awkward, implement it as a non-unique index first and enforce duplicate linked users in service logic, or use a partial unique index in SQL if that is already an accepted local pattern.

## 10. Primary Member Handling

`isPrimary` is useful, but it must not replace `FundClient.primaryContactName`, `primaryContactEmail` and `primaryContactPhone` immediately.

Recommended first rule:

- primary contact snapshot fields remain on `FundClient`;
- one Client member may be marked `isPrimary = true`;
- C1 UI may later offer to sync/set snapshots from a primary member, but this must be explicit;
- no automatic invitation or notification is sent when a primary member is set.

If the database must enforce only one primary member per Client, prefer a future partial unique index after the first model is accepted. For the first schema slice, service-level enforcement may be simpler and safer.

## 11. C1 Client Detail Users Tab Implications

The future C1 `Users` tab should use `FundClientMember`.

Expected table behaviour:

- search by name/email/phone;
- filter by status;
- filter by access level;
- sort by name, email, role/access, status and updated date;
- row click opens edit modal/detail;
- add user/member action in the tab header/action area.

Expected create/edit fields:

- first name;
- last name;
- email;
- phone;
- role label;
- access level;
- status;
- primary member marker;
- dashboard access enabled marker only when access policy is ready.

Do not add row edit/delete action icons if the existing IsoStack table CRUD pattern expects row click and action areas.

## 12. C1 Client Detail Projects Tab Implications

The `Projects` tab should remain driven by `FundProject.clientId`.

Expected table behaviour:

- linked Projects table;
- search by Project name/number;
- status filter;
- Event filter if useful;
- sortable columns;
- row click to Project detail.

This tab does not depend on the Client member schema, but it should be delivered alongside the Client detail tab structure so C1 can manage Client/account context coherently.

## 13. Manual Onboarding And Email Boundary

No automatic email should be sent when:

- a Client member is created;
- a Client member is linked to an existing platform `User`;
- access level changes;
- dashboard access is enabled or disabled;
- a member is marked primary;
- a member is archived or restored.

Until the dedicated notification/email lane exists, onboarding and access communication is manual.

Future email behaviour belongs to:

```text
1P-N0 - FUND System Notifications And Editable Email Defaults Planning
```

That lane should define editable email defaults, trigger keys, default recipients, pause/resume controls, audit/test behaviour and whether invitations are separate from general notifications.

## 14. Project Intake Approval Implications

Project Intake approval may eventually create or link:

- `FundClient`;
- `FundClientMember`;
- platform `User`;
- `FundProject`;
- `FundEvent` linkage.

For now:

- email matching may suggest a member match but must not prove ownership;
- a public initiation respondent becomes a Client member only after explicit C1 approval;
- approval must not send onboarding email automatically;
- any created member should start in a safe status/access state chosen by the approval slice.

Recommended safe default for approval-created member:

```text
status = ACTIVE
accessLevel = NONE
dashboardAccessEnabled = false
```

This records the person as a Client contact/member without granting C2 dashboard access until C1 deliberately enables it through a later workflow.

## 15. C2 Dashboard Implications

The C2 Client dashboard should later require:

- authenticated platform `User`;
- active same-tenant `FundClientMember`;
- `dashboardAccessEnabled = true`;
- suitable `accessLevel`.

First dashboard slices can then derive:

```text
authenticated User -> FundClientMember -> FundClient -> FundProjects
```

Do not build C2 dashboard Project creation until member access rules and idempotency are implemented.

## 16. Schema Implementation Notes

Future schema implementation should:

- add `FundClientMemberStatus`;
- add `FundClientMemberAccessLevel`;
- add `FundClientMember`;
- add `members FundClientMember[]` relation to `FundClient`;
- add optional relation from `User` if useful for navigation;
- add `fundClientMembers FundClientMember[]` relation to `Organization`;
- use snake_case database mappings consistent with FUND models;
- create a migration only through the normal Prisma migration workflow;
- not backfill from primary contact snapshots automatically.

Do not infer members from:

- `FundClient.primaryContactEmail`;
- `FundProject.organiserEmail`;
- `FundProjectParticipant.email`;
- public initiation respondent email;
- hidden/public form fields.

## 17. Implementation Split

Recommended next slices:

```text
1P-K1-B - Client User/Member Schema Implementation
1P-K1-C - C1 Client User/Member API/Services
1P-K1-D - C1 Client Detail Tabs: Details / Projects / Users UI
1P-K1-E - Client User/Member Review And Authenticated Smoke Test
1P-K2 - C2 Client Dashboard Read-Only Project View Planning
```

## 18. Explicit Non-Goals

This planning slice does not implement:

- app code;
- Prisma schema changes;
- migrations;
- Client member records;
- platform User creation;
- invitations;
- automatic email;
- notification templates;
- C2 dashboard UI;
- Client-owned Project creation;
- Store;
- Orders;
- Commerce;
- Sales/Reporting;
- commission payment management;
- production/artwork/dispatch workflows;
- SeasonPro integration.

## 19. Recommended Next Slice

```text
1P-K1-B - Client User/Member Schema Implementation
```

Implementation goal:

```text
Add the smallest safe FUND Client member schema foundation: enums, FundClientMember model, same-tenant Client relation, optional User relation, tenant indexes and no invitation/email behaviour.
```

Do not implement APIs, UI, invitations, notifications or C2 dashboard in the schema slice.

## 20. Suggested Implementation Prompt

```text
Proceed with FUND Phase 1 Slice 1P-K1-B implementation: Client User/Member Schema Foundation.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1p-k1-a-client-user-member-schema-options-planning.md
- isodocs/docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1p-k1-client-user-member-access-model-and-c1-management-planning.md
- current FUND schema conventions
- current same-tenant FundClient/FundProject relation patterns
- current User/Organization relation conventions

Implement schema only.

Add:
- FundClientMemberStatus enum;
- FundClientMemberAccessLevel enum;
- FundClientMember model;
- same-tenant relation to FundClient;
- optional relation to platform User;
- relation from Organization and FundClient;
- tenant-scoped indexes and safe uniqueness constraints.

Do not:
- infer members from primary contact snapshots;
- create Client members from existing data;
- create platform Users;
- send email;
- create invitations;
- implement services, routers, UI or C2 dashboard;
- run db:push;
- run seed/reset commands.

Run:
- npx prisma validate
- npm run db:generate
- npm run type-check
- npm run verify
- git diff --check

Create implementation confirmation documentation.
```
