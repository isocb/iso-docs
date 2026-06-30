# FUND Phase 1 Slice 1P-K0 - Client Dashboard And Client-Owned Project Lifecycle Planning

Date: 2026-06-30

Status: Planning

## 1. Slice Goal

Define the next core FUND lane for authenticated C2 Client dashboard capability.

The Client dashboard should become the operational surface where Clients of the C1 FUND tenant can:

- monitor their own Projects;
- create new Client-owned Projects directly under their Client/account;
- choose live/selectable C1 Events or create standalone Projects where allowed;
- access Project templates and setup assets;
- later monitor sales/order performance once Store/Orders/Commerce exists.

This planning slice does not implement application code, schema changes, migrations, dashboards, services, Store, Orders, Commerce, production workflows, communications or commission features.

## 2. Product Position

FUND has three major operating surfaces:

| Surface | Actor | Purpose |
| --- | --- | --- |
| C1 FUND admin dashboard | AMOW / producer tenant admin | Manage Clients, Products, Catalogues, Events, Projects, Project Intake, production, dispatch and commission. |
| Public Project initiation form | Unknown/new or not-yet-authenticated respondent | Submit a moderated Project request that C1 may approve into Client/Project records. |
| C2 Client dashboard | Authenticated Client organisation/user | Manage the Client's own Projects and later sales/order engagement. |

The C2 Client dashboard is not an intake form by default.

For existing authenticated Client users:

```text
authenticated C2 Client user
-> Client dashboard
-> New Project
-> create FundProject directly
-> set FundProject.clientId from authenticated Client/account context
-> Project starts in a safe pre-operational state
```

C1 does not approve the mere existence of every authenticated Client-created Project by default. C1 remains the producer/supplier/fulfilment tenant and may apply downstream gates before Store launch, public ordering, production, dispatch, commerce or notifications.

## 3. Why This Is The Next Core Slice

This is the next sensible core planning phase because it connects the foundation already built:

- `FundClient` exists as the C2 organisation/account.
- `FundProject.clientId` exists and Project-to-Client linkage is implemented.
- C1 can manage Clients and Projects.
- Project Intake can create/link Client and Project records after moderation.
- Public initiation can onboard new Client/first Project requests.

What is missing is the authenticated Client-owned operating surface.

Without this lane, Store/Orders/Commerce would risk being designed around public checkout only, rather than around the Client/account and Project owner who needs to monitor and manage the fundraising activity.

## 4. Core Dashboard Roles

### 4.1 Monitor Projects

The dashboard should show Projects linked to the authenticated Client/account.

Initial monitoring should include:

- Project name;
- status/lifecycle state;
- linked Event if present;
- Project start and closing dates;
- C1-provided operational status where available;
- key links into Project detail.

Sales metrics should be planned as a placeholder only until Store/Orders/Commerce exists.

### 4.2 Create New Projects

Authenticated Client users with the correct future role/permission should be able to create Projects directly from the Client dashboard.

The Project must be scoped by trusted authenticated Client context:

```text
FundProject.clientId = authenticated Client/account id
```

The UI must not let the Client spoof another Client/account.

Supported creation options:

- Event-linked Project from selectable live/available Events;
- standalone Project where C1 allows standalone Client Projects.

Creation should require:

- Project name;
- Project type/format;
- Project start date;
- Project closing date;
- optional description/notes;
- selected Event where Event-linked.

Event-linked Project date constraints should mirror the public initiation form:

- Project Start cannot be before Event start/open date;
- Project Closing Date cannot be after Event close date;
- Project Closing Date may be earlier than the Event close date;
- Closing Date must be after Start Date.

Standalone Projects must have their own Project Start and Project Closing Date.

### 4.3 Download Templates And Setup Assets

The Client dashboard should provide Project setup resources.

Initial planning should allow for:

- generic module templates;
- Event-specific templates;
- Product/catalogue-specific templates;
- Project-specific uploaded templates or instructions;
- artwork guidance and submission requirements.

Template download support is core dashboard value, but it should not trigger production/artwork workflow implementation in the first dashboard slice.

### 4.4 Monitor Sales And Orders

Sales monitoring is a core future purpose of the Client dashboard, but it depends on Store/Orders/Commerce.

For K0, record the surface but do not implement it.

Future metrics may include:

- total orders;
- gross sales;
- commission estimate;
- units sold;
- product breakdown;
- Store status;
- payment/settlement state.

Until Store/Orders/Commerce exists, the dashboard may show placeholder/empty states only if that is useful and not misleading.

## 5. Wishlist/Future Dashboard Surfaces

These are desirable but not part of the first core Client dashboard implementation:

- C1 announcements to Clients;
- special offers / campaign prompts;
- 1:1 C1/Client communication;
- dashboard-visible messages;
- editable notification defaults;
- commission payment management;
- payout statements;
- Store/Commerce controls beyond safe placeholders.

These should be tracked through the Phase 2 refinement wishlist and future communications/commerce planning lanes.

## 6. Required Access Model

The Client dashboard cannot be safely implemented as a full authenticated C2 surface until the Client user/member model is accepted.

Future model:

```text
FundClient = C2 Client organisation/account
FundClientUser / ClientMember = person linked to Client
User = authenticated platform identity
Client role/permission = access model for Client dashboard actions
```

Minimum role/permission questions:

- who can view Client Projects?
- who can create Projects?
- who can edit Projects?
- who can cancel/archive Projects?
- who can download templates?
- who can view sales/order metrics later?
- who can see or manage commission information later?

Role labels such as Treasurer, Secretary, PTA Chair, Project Lead and Finance Contact are not automatically access permissions. A separate permission model is needed.

## 7. Client-Owned Project Lifecycle

Direct Client-created Projects should start safe.

Recommended initial lifecycle:

```text
DRAFT or REQUESTED
```

The exact state should be decided in the implementation planning slice, but the principle is:

- Project record exists and is owned by the Client.
- Client can manage early setup within permitted rules.
- C1 can see/administer the Project.
- Downstream gates still protect Store launch, public ordering, production, dispatch, payment and notifications.

Client actions to plan:

- create Project;
- edit Project basics while in safe editable states;
- cancel Project where no downstream activity exists;
- archive completed or abandoned Projects where allowed;
- view Project status/history.

Do not allow Client edits that undermine C1 production/admin control.

## 8. Event Selection And Availability

The Client dashboard should not expose all Events blindly.

Selectable Events should be:

- C1 tenant Events;
- active/open for Client Project creation;
- within relevant dates;
- not archived;
- optionally constrained by future catalogue/product availability.

This may need a future Event availability service before implementation.

Initial planning can use existing safe Event list/read APIs only if they are tenant-scoped and expose no supplier internals.

## 9. Data Dependencies

Already available:

- `FundClient`;
- `FundProject.clientId`;
- Project-to-Client same-tenant linkage;
- C1 Client and Project management;
- Project Intake moderation and approval;
- Event-linked Project support.

Likely needed before full implementation:

- Client user/member relationship;
- Client dashboard access context;
- Client role/permission checks;
- Client-scoped Project list/get services;
- Client-scoped Project create/update/cancel/archive services;
- Event availability rules for Client creation;
- Project template/resource source model or safe existing file/document pattern.

Deferred dependencies:

- Store;
- Orders;
- Commerce;
- Sales/reporting;
- commission calculation/payment;
- production/artwork workflow;
- communications/announcements.

## 10. Proposed Implementation Split

Recommended split:

```text
1P-K1 - Client User/Member Access Model Planning
1P-K2 - Client Dashboard Read-Only Project View API/Services
1P-K3 - Client Dashboard Read-Only Project View UI
1P-K4 - Client-Owned Project Creation API/Services Planning
1P-K5 - Client-Owned Project Creation UI Planning
1P-K6 - Project Template/Resource Access Planning
```

Rationale:

- solve authenticated Client context before mutations;
- start with Project visibility before Project creation;
- keep Project creation bounded and safe;
- keep templates/assets independent from Store/Commerce;
- leave sales, communications and commission to later dedicated planning.

## 11. UI Direction

Initial Client dashboard should be operational and restrained.

Possible first screen areas:

- Client/account header;
- active Projects list/cards;
- Project status summary;
- "New Project" action when role/permission allows;
- available Events section;
- templates/resources section;
- future Sales/Orders placeholder only if appropriate.

Avoid:

- C1 admin controls;
- supplier/internal production tools;
- Store/Orders/Commerce controls before those models exist;
- broad communications UI before the notification/communication lane is planned.

## 12. Security And Tenant Guardrails

Required guardrails:

- never accept `organizationId` from Client dashboard input;
- never accept `clientId` from untrusted input for Client-owned Project creation;
- derive Client scope from authenticated Client membership/context;
- enforce same-tenant Client/Project/Event relations;
- cross-Client access returns not found or forbidden according to existing conventions;
- Client Project creation must be idempotent against double-click/retry;
- Client dashboard must not expose C1 supplier internals unless explicitly intended.

## 13. Store/Orders/Commerce And Production Position

Store/Orders/Commerce should follow the Client dashboard planning, not precede it.

Reason:

```text
Store and order activity belongs to a Project, and the Project belongs to a Client/account.
```

Production should follow or run alongside Store/Orders/Commerce planning, because C1 production needs:

- Project context;
- Product/catalogue membership;
- order/product quantities;
- artwork status;
- dispatch/delivery information;
- commission/settlement context.

Recommended major planning sequence after K0:

```text
1P-K - Client Dashboard And Client-Owned Project Lifecycle
1P-L - Store, Orders And Commerce Core Planning
1P-M - C1 Production, Dispatch And Commission Implementation Planning
```

## 14. Explicit Non-Goals

This slice does not implement:

- application code;
- Prisma schema changes;
- migrations;
- Client users/members;
- invitations;
- notifications;
- C2 dashboard UI;
- Client dashboard mutations;
- Store;
- Orders;
- Commerce;
- payments;
- sales reporting;
- commission payments;
- production/artwork/dispatch workflows;
- SeasonPro integration.

## 15. Open Questions

- Should the first Client dashboard be read-only until Client users/members are implemented?
- Does Client Project creation require `DRAFT` or `REQUESTED` as the safest initial state?
- Which Event states make an Event selectable for Client-created Projects?
- Should standalone Client-created Projects be globally allowed, tenant-configurable or form/Event-specific?
- Where should Project templates live: Product, Catalogue, Event, Project or module resources?
- What is the minimum sales placeholder that helps without implying Store/Orders exists?

## 16. Recommended Next Slice

```text
1P-K1 - Client User/Member Access Model Planning
```

Planning goal:

```text
Define the authenticated Client user/member, role and permission model required before the Client dashboard can safely expose Client-owned Project views or creation actions.
```

Do not implement the Client dashboard before K1 has resolved trusted Client/account context.
