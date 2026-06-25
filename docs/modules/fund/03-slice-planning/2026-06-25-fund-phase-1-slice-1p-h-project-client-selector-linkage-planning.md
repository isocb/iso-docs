# FUND Phase 1 Slice 1P-H - Project Client Selector And Linkage Planning

Date: 2026-06-25

Status: Planning only

## 1. Slice Goal

Plan how C1 admin users link FUND Projects to FUND Clients.

This is the bridge between the new C1 Client Management foundation and future Project Intake / Client onboarding work.

Current foundation:

- `FundClient` schema exists.
- `FundProject.clientId` exists and is nullable.
- `fund.clients.*` C1 Client API/services exist.
- C1 Client Management UI exists.
- Project create/update currently does not expose or accept `clientId`.

Goal:

```text
Allow C1 admins to create, view, change and clear a Project's Client linkage safely.
```

## 2. Why 1P-H Comes Before 1P-G-A

Project Intake and Client onboarding will eventually create or link operational records:

- Client/account;
- C2 user/member;
- Project;
- Event linkage where appropriate.

Before intake/moderation can be designed safely, the normal operational Project-to-Client linkage must be clear.

Therefore:

```text
1P-H Project Client linkage first.
1P-G-A Project Intake schema/moderation planning after linkage rules are accepted.
```

## 3. Role And Ownership Model

Client is the C2 organisation/account concept in FUND.

Examples:

- school;
- club;
- PTA;
- charity branch;
- fundraising organisation;
- customer account.

Project belongs to a Client when `FundProject.clientId` is set.

`FundProject.organiserName`, `organiserEmail` and `organiserPhone` remain contact snapshots only. They must not be used as Client ownership or access control.

## 4. Current Schema Position

Existing schema foundation:

```text
FundClient
FundProject.clientId String?
FundProject.client FundClient?
```

Tenant safety:

```text
FundProject(organizationId, clientId)
-> FundClient(organizationId, id)
```

Existing Projects remain valid with:

```text
clientId = null
```

Standalone Projects remain allowed.

## 5. Required Linkage Rules

Project Client linkage must be C1/admin only in this slice.

Rules:

- C1 admin can create a Project with no Client.
- C1 admin can create a Project linked to an active Client.
- C1 admin can link an existing Project to an active Client.
- C1 admin can change Project Client linkage while the Project is still operationally editable according to the accepted rule below.
- C1 admin can unlink a Project where policy allows.
- Archived Clients must remain visible historically on already-linked Projects.
- New linkage to archived Clients must be blocked.
- New linkage to inactive Clients should be blocked unless explicitly accepted later.
- Cross-tenant Client ids must return `NOT_FOUND` or `BAD_REQUEST` according to existing service convention.
- Client ownership must not be inferred from organiser snapshot fields.
- No Client users, invitations or notifications are created.

Recommended first rule:

```text
Client linkage/change/unlink is allowed while Project is DRAFT.
Non-DRAFT Projects show Client linkage read-only.
```

Reason:

- This mirrors the conservative Project/Event linkage rule.
- It prevents rewriting ownership context after operational activity has started.
- It keeps future Store, Orders, reporting and audit dependencies safer.

Open decision:

```text
Should C1 OWNER/ADMIN be allowed to correct Client linkage after activation through a dedicated correction flow?
```

Recommendation:

```text
Defer post-DRAFT correction flow. Start with DRAFT-only mutation.
```

## 6. API / Service Planning

Existing procedures likely affected:

- `fund.projects.list`
- `fund.projects.get`
- `fund.projects.create`
- `fund.projects.update`

Existing procedure already available:

- `fund.clients.list`

Recommended API changes:

### Project List Payload

Add safe Client summary:

```text
clientId
client: {
  id
  code
  name
  slug
  clientType
  status
  archivedAt
}
```

or a compact equivalent.

### Project Detail Payload

Add Client detail summary for display:

```text
clientId
client summary
```

Client summary must be tenant-scoped through the Project include.

### Project Create Input

Add:

```text
clientId?: string | null
```

Create rules:

- null/undefined means standalone/no Client linkage.
- non-null must validate through `validateProjectClientLink`.
- active same-tenant Clients only.

### Project Update Input

Add:

```text
clientId?: string | null
```

Update rules:

- `undefined` means no Client linkage change.
- `null` means unlink Client if allowed.
- string means link/change to that Client if allowed.
- first implementation should allow change/unlink only while Project is `DRAFT`.
- archived Projects remain immutable under existing rules.

### Audit Events

Recommended audit events:

- `FUND_PROJECT_CLIENT_LINKED`
- `FUND_PROJECT_CLIENT_CHANGED`
- `FUND_PROJECT_CLIENT_UNLINKED`

General `FUND_PROJECT_UPDATED` may also continue to be written.

Audit metadata should include:

- previousClientId;
- newClientId;
- previousClientCode/name if easily available;
- newClientCode/name if easily available.

## 7. Validation Rules

Project create/update schemas should accept optional nullable `clientId`.

Validation should not accept:

- organizationId from client input;
- Client code or slug as linkage source;
- organiser email/name/phone as linkage source.

Server-side validation remains authoritative.

Client selector UI may pre-filter eligible Clients, but stale/malicious Client ids must still be rejected server-side.

## 8. UI Planning

Project Client UI should appear in:

- Project create modal;
- Project detail Overview/Profile section.

Recommended UI shape:

- optional Client selector near Event selector;
- helper text explaining Client is the fundraising organisation/account;
- standalone option: `No Client / standalone Project`;
- eligible list shows active Clients only for new linkage;
- existing archived linked Client remains visible historically;
- non-DRAFT Projects show Client linkage read-only;
- DRAFT Projects may link/change/unlink;
- do not copy Client contact fields into Project organiser fields;
- do not silently overwrite organiser snapshot fields when Client changes.

## 9. Client Selector Behaviour

Selector should use:

```text
fund.clients.list
```

Recommended query:

```text
includeArchived: false
status: ACTIVE
```

If the current linked Client is archived or inactive, it should still be displayed in read-only Project detail through `fund.projects.get`.

Selector item labels:

```text
Client name
Code
Client type
Status where useful
```

Do not show Client internal notes in selector.

## 10. Project Create Behaviour

Create Project flow:

- allow Project with no Client;
- allow Project linked to active Client;
- allow Event and Client to be selected independently;
- do not require Event when Client is selected;
- do not require Client when Event is selected;
- do not infer Client from organiser contact fields.

Questions to answer in implementation:

- Should Client be optional or recommended in create UI?
- Should AMOW presentation copy encourage Client linkage without making it mandatory?

Recommendation:

```text
Keep Client optional in Phase 1.
Display clear helper text that linking a Client is recommended for Client-based reporting and future Project Intake.
```

## 11. Project Detail Behaviour

Project detail should show:

- Client name/code/type/status;
- standalone status when no Client is linked;
- linked archived Client historical warning where applicable;
- DRAFT-only edit selector;
- read-only display when Project is non-DRAFT;
- no Client user/invitation controls.

Linked Client display may navigate to:

```text
/app/fund/clients/[id]
```

Only C1 admin pages should receive this link.

## 12. Query Invalidation

After Project Client link/change/unlink:

- invalidate `fund.projects.get({ id })`;
- invalidate `fund.projects.list`;
- invalidate `fund.clients.get({ id: oldClientId })` if old Client id exists;
- invalidate `fund.clients.get({ id: newClientId })` if new Client id exists;
- invalidate `fund.clients.list` where project counts may be visible.

## 13. Error Handling

Surface clearly:

- duplicate Project fields from existing Project validation;
- invalid Client id;
- archived/inactive Client cannot be linked;
- Client not found;
- cross-tenant Client rejected;
- Client linkage change blocked after DRAFT;
- generic server errors.

Preserve form state on mutation errors.

## 14. Out Of Scope

Do not implement in Project Client linkage:

- Client users;
- Client roles;
- invitations;
- notification sending;
- Project Intake / Project Request forms;
- public embedded forms;
- C2 dashboard expansion;
- C2 Project creation;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- Communications;
- key-date automation;
- SeasonPro Club mapping implementation;
- automatic Client creation from organiser snapshots;
- automatic Project creation from Client creation.

## 15. Manual Test Checklist

API/service tests:

- create Project with no Client;
- create Project linked to active same-tenant Client;
- create Project rejects archived Client;
- create Project rejects inactive Client;
- create Project rejects cross-tenant Client;
- update DRAFT Project to link active Client;
- update DRAFT Project to change Client;
- update DRAFT Project to unlink Client;
- update non-DRAFT Project rejects Client change;
- organiser snapshot fields do not create/link Client;
- linked archived Client remains visible on existing Project detail.

UI tests:

- Project create selector lists active Clients;
- Project create can leave Client blank;
- Project create can select Client and Event independently;
- Project detail shows linked Client;
- Project detail shows standalone status;
- DRAFT Project can link/change/unlink Client;
- non-DRAFT Project shows read-only Client linkage;
- linked Client summary navigates to `/app/fund/clients/[id]`;
- no Client user/invitation/notification surfaces appear;
- Products, Events, Projects and Clients pages still load.

## 16. Recommended Implementation Split

Recommended sequence:

1. `1P-H-A - Project Client Linkage API/Services`
2. `1P-H-B - Project Client Selector UI`
3. `1P-H-R1 - Project Client Linkage Review And Smoke Testing`
4. `1P-G-A - Project Intake Schema And Moderation Model Planning`

Reason:

```text
API/service linkage should be confirmed before UI builds on it.
Project Intake planning should build on accepted Project Client linkage semantics.
```

## 17. Recommended Implementation Prompt For 1P-H-A

```text
Proceed with FUND Phase 1 Slice 1P-H-A implementation: Project Client Linkage API/Services.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-h-project-client-selector-linkage-planning.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-f-d-c1-client-management-api-services-confirmation.md
- current Project API/service conventions
- current Client API/service conventions

Implement Project Client linkage API/services only.

Use existing schema:
- FundClient
- FundProject.clientId

Update only:
- Project validation schemas;
- Project service list/get/create/update payloads and logic;
- Project audit events where current conventions support them;
- tests/checks or confirmation docs as required.

Rules:
- Client linkage is C1/admin only.
- Project create may link to active same-tenant Client or remain standalone.
- DRAFT Project update may link/change/unlink Client.
- Non-DRAFT Project update must reject Client linkage changes.
- Archived/inactive Clients cannot be newly linked.
- Cross-tenant Client ids must be rejected.
- Existing archived linked Clients remain visible historically.
- Do not infer Client ownership from organiserName, organiserEmail or organiserPhone.
- Do not create Client users, invitations, notifications or Project Intake forms.

Do not implement UI.
Do not create schema changes or migrations unless a genuine blocker is found and explained first.
Do not run db:push.
Do not run seed/reset commands.

Run:
- npx prisma validate
- npm run db:generate
- npm run type-check
- npm run verify
- git diff --check

Create implementation confirmation document:
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-h-a-project-client-linkage-api-services-confirmation.md

Do not promote to main after implementation.
```
