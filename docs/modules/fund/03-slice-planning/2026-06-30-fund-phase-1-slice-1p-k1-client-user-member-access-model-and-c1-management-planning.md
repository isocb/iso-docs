# FUND Phase 1 Slice 1P-K1 - Client User/Member Access Model And C1 Management Planning

Date: 2026-06-30

Status: Planning

## 1. Slice Goal

Plan the Client user/member model and C1 management surface required before FUND can safely expose a C2 Client dashboard.

This slice sits under:

```text
1P-K0 - Client Dashboard And Client-Owned Project Lifecycle Planning
```

K0 defines the destination. K1 defines the access model and C1 management UI needed to make that destination safe.

This is planning only. It does not implement application code, schema changes, migrations, invitations, email sending, notifications, C2 dashboard UI, Store, Orders, Commerce or production workflows.

## 2. Core Model

Accepted conceptual model:

```text
FundClient = C2 Client organisation/account
FundClientUser / ClientMember = person linked to Client
User = authenticated platform identity
Client role label = human/organisation role
Client access permission = what the user can do in FUND
```

Client users/members are the people who will eventually access FUND as C2 users.

They are distinct from:

- `FundClient` primary contact snapshot fields;
- public Project initiation respondents;
- organiser snapshot fields on Projects;
- invitation state;
- email notification consent.

## 3. C1 Client Detail UI Pattern

The C1 Client detail page should evolve into a tabbed management surface.

Recommended top-level tabs:

```text
Client Details
Projects
Users
```

### Client Details

Purpose:

- manage Client organisation/account details;
- edit primary contact snapshots;
- manage status/archive state;
- view C1 internal notes.

Primary contact fields remain C1 operational snapshots only. They do not create users, login identity, invitations, notifications or dashboard access.

### Projects

Purpose:

- show Projects linked to the Client through `FundProject.clientId`;
- support C1 admin review and navigation.

Recommended table behaviour:

- linked Projects table;
- fuzzy search;
- status filter;
- Event filter if useful;
- sortable columns;
- row click opens Project detail;
- no row edit/delete icon clutter unless an existing FUND pattern requires it.

Suggested columns:

- Project name/number;
- status/lifecycle state;
- linked Event;
- start date;
- closing date;
- updated date.

### Users

Purpose:

- manage Client users/members who may later access the C2 Client dashboard;
- make C1 Client-account administration explicit.

Recommended table behaviour:

- Client users/members table;
- fuzzy search;
- status filter;
- role/access filter;
- sortable columns;
- row click opens edit modal or detail;
- add user/member action in the tab header/action area.

Suggested columns:

- name;
- email;
- phone;
- role label;
- access level/permission;
- platform User link state;
- status;
- updated date.

## 4. Add User/Member Boundary

C1 should be able to create or link a Client user/member record, but this must be carefully separated from invitation and email behaviour.

Possible actions:

```text
Create Client user/member record
Link to existing platform User
Mark as dashboard-enabled when access model permits
Invite new platform User later
Send access email later
```

These are not the same operation.

Initial K1 planning should treat user/member creation as a data/access-management operation only.

## 5. Email, Invitation And Notification Boundary

No automatic email should be sent when:

- C1 adds a Client user/member;
- C1 links a Client user/member to an existing platform User;
- C1 updates a Client user/member;
- C1 changes role label or access permission;
- C1 creates a Client;
- C1 approves a Project Intake submission into Client/Project records.

Until the dedicated FUND notification/email planning lane exists, user onboarding email is a manual operational step.

Future email/invitation behaviour must be planned through:

```text
1P-N0 - FUND System Notifications And Editable Email Defaults Planning
```

The future notifications lane should define:

- editable default email content;
- trigger keys;
- default recipients;
- pause/resume controls;
- audit/test behaviour;
- whether invitations are separate from general notifications;
- whether dashboard access emails are sent automatically, manually or queued.

## 6. Role Labels Vs Access Permissions

Role labels are human-facing and organisation-facing.

Examples:

- Treasurer;
- Secretary;
- Club Secretary;
- PTA Chair;
- Headteacher;
- Project Lead;
- Finance Contact;
- General Contact.

Access permissions decide what a user may do.

Example permissions to plan:

- view Client dashboard;
- view all Client Projects;
- create Projects;
- edit Project setup;
- cancel/archive Projects;
- download templates;
- submit artwork/data;
- view sales/order metrics later;
- view/manage commission information later.

Do not collapse role label and access permission into one field without a deliberate planning decision.

## 7. Suggested Model Fields

Future `FundClientUser` / `FundClientMember` fields may include:

- id;
- organizationId;
- clientId;
- userId nullable;
- firstName;
- lastName;
- displayName;
- email;
- phone;
- roleLabel;
- accessLevel or permissionSet;
- status;
- isPrimaryContact;
- dashboardAccessEnabled;
- lastAccessedAt;
- invitedAt nullable;
- invitationAcceptedAt nullable;
- createdById;
- updatedById;
- createdAt;
- updatedAt.

Potential statuses:

```text
DRAFT
ACTIVE
INACTIVE
ARCHIVED
```

Do not send invitations from status changes until notification planning exists.

## 8. Tenant And Access Guardrails

Required guardrails:

- `FundClientUser.organizationId` is the C1 tenant boundary;
- `FundClientUser.clientId` must be same-tenant;
- a platform `User` cannot gain Client dashboard access unless linked through a valid same-tenant Client user/member record;
- C2 Client dashboard access must derive Client context from authenticated membership, not from URL/input alone;
- cross-Client access must return not found/forbidden according to current conventions;
- archived/inactive Client users should not access the Client dashboard.

## 9. Project Intake Approval Impact

Project Intake approval may eventually create or link:

- Client organisation/account;
- Client user/member;
- platform User identity where appropriate;
- Project;
- Event link.

K1 should define the Client user/member part, but not implement automatic invitation or notification sending.

The main organiser captured on public initiation may become a Client user/member only after explicit C1 approval and only once the user/member model exists.

## 10. C2 Dashboard Impact

K1 unlocks future C2 dashboard slices by defining:

- who can access the Client dashboard;
- which Client/account they belong to;
- whether they can view Projects;
- whether they can create Projects;
- how C1 can manage that access;
- how user/member access is audited.

Do not implement the C2 dashboard before this model is accepted.

## 11. Implementation Split Recommendation

Recommended sequence:

```text
1P-K1-A - Client User/Member Schema Options Planning
1P-K1-B - Client User/Member Schema Implementation
1P-K1-C - C1 Client User/Member API/Services
1P-K1-D - C1 Client Detail Tabs: Details / Projects / Users UI
1P-K1-E - Client User/Member Review And Authenticated Smoke Test
1P-K1-F - Client Member Login/Onboarding And Auth Routing Planning
1P-K2 - C2 Client Dashboard Read-Only Project View Planning
```

This keeps the C1 management surface, access model and auth-routing policy ahead of C2 dashboard implementation.

## 12. Explicit Non-Goals

This planning slice does not implement:

- application code;
- Prisma schema changes;
- migrations;
- Client user/member records;
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

## 13. Recommended Next Slice

```text
1P-K1-A - Client User/Member Schema Options Planning
```

Planning goal:

```text
Choose the smallest safe schema direction for FUND Client users/members, including same-tenant Client relation, optional platform User relation, status/access fields and explicit no-email/no-invitation boundaries.
```

K1-A planning is captured in:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1p-k1-a-client-user-member-schema-options-planning.md
```

## 14. Suggested Implementation Prompt For Next Chat

```text
Proceed with FUND Phase 1 Slice 1P-K1-A planning: Client User/Member Schema Options.

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1p-k1-client-user-member-access-model-and-c1-management-planning.md
- isodocs/docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1p-k0-client-dashboard-and-client-owned-project-lifecycle-planning.md
- isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-f-client-organisation-users-roles-notification-planning.md
- current FUND Client, Project and User/organization relation conventions

Planning only.

Goal:
Plan the smallest safe schema option for Client users/members so C1 can later manage Client dashboard access from the Client detail page.

Include:
- FundClientUser / ClientMember model direction;
- relation to FundClient;
- optional relation to platform User;
- role label vs access permission;
- status model;
- same-tenant scoping;
- C1 Client detail Users tab implications;
- Projects tab implications;
- manual onboarding/email boundary;
- explicit no automatic invitation or notification rule;
- implementation split.

Do not implement app code.
Do not edit Prisma schema.
Do not create migrations.
Do not send notifications.
Do not create invitations.
Do not implement C2 dashboard.

Run docs git diff --check.
```
