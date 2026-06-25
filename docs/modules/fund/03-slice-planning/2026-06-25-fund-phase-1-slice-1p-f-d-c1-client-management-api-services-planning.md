# FUND Phase 1 Slice 1P-F-D - C1 Client Management API/Services Planning

Date: 2026-06-25

Status: Planning only

## 1. Slice Goal

Plan the C1 Client Management API/service layer using the schema introduced in Slice 1P-F-C.

This slice should make the new `FundClient` schema usable by the C1 FUND admin foundation without introducing UI, C2 mutations, Client users, invitations, Store, Orders, Commerce, Sales/Reporting, Communications, key-date automation, SeasonPro mapping or reusable core Client/account work.

## 2. Implementation Boundary

Plan API/services only.

Allowed in the implementation slice:

- Zod validation schemas for C1 Client procedures;
- `clients.service.ts`;
- `clients.router.ts`;
- add `clients` to the FUND router index;
- audit events for meaningful Client mutations;
- Project-link helper/validation functions if they are purely service helpers and do not alter Project procedures yet;
- implementation confirmation document.

Not allowed:

- UI;
- Project Client selector;
- Client list/detail UI;
- Client users;
- Client roles;
- invitations;
- C2 dashboard expansion;
- C2 mutations;
- Project Request/onboarding;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- Communications;
- key-date automation;
- SeasonPro Club mapping;
- reusable core Client/account model;
- schema changes or migrations unless a genuine blocker is found and explained first.

## 3. Current Schema Basis

Slice 1P-F-C introduced:

```text
FundClientStatus
FundClient
FundProject.clientId nullable
FundProject.client same-tenant relation
Organization.fundClients
```

Current schema direction:

```text
Fund-specific first, platform-aware.
```

User-facing/admin term:

```text
Client
```

Important rule:

```text
FundProject.clientId is nullable.
Existing Projects must not be auto-linked from organiser snapshot fields.
```

## 4. Router Design

Recommended router file:

```text
src/modules/fund/routers/clients.router.ts
```

Recommended mount:

```text
fund.clients
```

Recommended procedures:

```text
fund.clients.list
fund.clients.get
fund.clients.create
fund.clients.update
fund.clients.archive
fund.clients.restore
```

All procedures should use:

```text
withFeature('fund')
```

Because Clients are C1 account-management records, all procedures should require C1 FUND admin access:

```text
assertFundAdmin(actor)
```

This is stricter than current Event/Project list/get behaviour, but appropriate for the first Client management surface because Client records are account/organisation data, not public or C2 self-service data.

Future C2 Client/account reads should be planned separately and must not reuse C1 admin procedures as a shortcut.

## 5. Service Design

Recommended service file:

```text
src/modules/fund/services/clients.service.ts
```

Recommended service functions:

```text
listClients(prisma, actor, input)
getClient(prisma, actor, id)
createClient(prisma, actor, input)
updateClient(prisma, actor, input)
archiveClient(prisma, actor, id, archivedReason)
restoreClient(prisma, actor, id)
```

Recommended helper functions:

```text
getClientOrThrow(prisma, actor, id)
validateUniqueClientCodeSlug(prisma, actor, input, excludeId?)
assertClientCanBeLinked(client)
auditClient(prisma, actor, action, client, metadata?)
serializeClient(client)
```

Project-linking helper, for later Project create/edit slices:

```text
validateProjectClientLink(prisma, actor, clientId)
```

This helper should:

- return `null` when `clientId` is null/undefined and standalone Projects are allowed;
- require `organizationId = actor.organizationId`;
- throw `NOT_FOUND` if the Client does not exist in the tenant;
- block archived Clients;
- preferably block inactive Clients for new Project linkage unless product policy explicitly approves inactive Client linking later.

Do not wire this into Project create/update in the first Client API/services implementation unless the accepted implementation prompt explicitly includes Project procedure changes.

## 6. Zod Validation Schemas

Recommended validation file:

```text
src/modules/fund/lib/validation/clients.ts
```

Recommended schemas:

```text
clientListInputSchema
clientGetInputSchema
clientCreateInputSchema
clientUpdateInputSchema
clientArchiveInputSchema
clientIdInputSchema
```

Recommended reusable validation:

- reuse `fundCodeSchema`;
- reuse `fundSlugSchema`;
- reuse `fundNameSchema`;
- reuse `fundArchiveReasonSchema`;
- reuse `fundMetadataSchema`;
- use `z.nativeEnum(FundClientStatus)` for status.

Recommended field validation:

- `code`: required on create, optional on update;
- `name`: required on create, optional on update;
- `slug`: required on create, optional on update;
- `clientType`: required on create, optional on update, trimmed max length around 80;
- `description`: optional nullable text;
- `primaryContactName`: optional nullable text;
- `primaryContactEmail`: optional nullable email or empty/null;
- `primaryContactPhone`: optional nullable text;
- `internalNotes`: optional nullable text;
- `metadata`: JSON object via existing FUND metadata schema;
- `status`: optional only if update is allowed to change `ACTIVE`/`INACTIVE`.

Do not expose direct update to `ARCHIVED` via general update. Archive/restore should use dedicated procedures.

## 7. Tenant Scoping Strategy

Every read and write must scope by:

```text
organizationId = actor.organizationId
```

Never accept `organizationId` from client input.

All uniqueness checks must be tenant-scoped.

Cross-tenant ids should return:

```text
NOT_FOUND
```

not `FORBIDDEN`, to avoid leaking tenant existence.

## 8. Access Control And Feature Gating

All Client procedures should:

- use `withFeature('fund')`;
- resolve actor using current/effective user and organization conventions;
- require `assertFundAdmin(actor)`.

Rationale:

- Client management is a C1 admin surface;
- Clients represent C2 organisation/account records;
- first implementation is not C2 self-service;
- future C2 account reads/mutations need separate planning.

## 9. List Procedure

Recommended endpoint:

```text
fund.clients.list
```

Input:

- `status`;
- `clientType`;
- `search`;
- `includeArchived`;
- `sortBy`;
- `sortDirection`.

Recommended search fields:

- `code`;
- `name`;
- `slug`;
- `clientType`;
- `primaryContactName`;
- `primaryContactEmail`;
- `description`.

Recommended default filtering:

```text
Archived Clients hidden by default.
```

Recommended default ordering:

```text
name asc, createdAt desc
```

Recommended allowed sort fields:

- `name`;
- `code`;
- `clientType`;
- `status`;
- `updatedAt`;
- `createdAt`;
- `projectCount`, only if practical using included counts or stable server-side sort.

If project-count sorting is not straightforward in Prisma without expensive logic, defer it and keep visible table sorting client-side for currently loaded rows.

List payload should include:

- Client core fields;
- `_count.projects`;
- minimal status/archive fields;
- no Client users or future commerce data.

## 10. Get Procedure

Recommended endpoint:

```text
fund.clients.get
```

Input:

```text
id
```

Payload should include:

- full Client profile;
- `_count.projects`;
- linked Project summaries.

Project summaries should include:

- `id`;
- `projectNumber`;
- `name`;
- `slug`;
- `status`;
- `lifecycleState`;
- `eventId`;
- Event summary if inexpensive and useful;
- `opensAt`;
- `closesAt`;
- `productionDeadline`;
- `updatedAt`.

Payload should not include:

- Project internal audit data;
- all Project participants;
- Client users;
- orders;
- sales;
- reporting;
- communications.

## 11. Create Procedure

Recommended endpoint:

```text
fund.clients.create
```

Rules:

- `organizationId` comes from actor;
- `status` defaults to `ACTIVE`;
- `code` unique per tenant;
- `slug` unique per tenant;
- `clientType` required;
- primary contact fields are snapshots only;
- no user creation;
- no invitations;
- no Project auto-linking from organiser snapshots.

Duplicate `code` or `slug` should return:

```text
CONFLICT
```

## 12. Update Procedure

Recommended endpoint:

```text
fund.clients.update
```

Rules:

- tenant-scoped lookup;
- no `organizationId` input;
- allow profile/contact/metadata updates;
- allow `ACTIVE <-> INACTIVE` if accepted;
- do not allow direct `ARCHIVED` via general update;
- archived Clients should not be updated normally except through `restore`.

If an archived Client is updated through general update, return:

```text
BAD_REQUEST
```

or require restore first.

Duplicate `code` or `slug` should return:

```text
CONFLICT
```

## 13. Archive Procedure

Recommended endpoint:

```text
fund.clients.archive
```

Input:

- `id`;
- `archivedReason`.

Rules:

- soft archive only;
- set `status = ARCHIVED`;
- set `archivedAt`;
- set `archivedById`;
- set `archivedReason`;
- do not hard-delete.

Linked Projects should remain linked and visible historically.

Archiving a Client with linked active Projects should be allowed only if the product decision accepts historical archive-with-active-project semantics. Safer initial recommendation:

```text
Block archive if there are ACTIVE or PAUSED Projects linked to the Client.
Allow archive if linked Projects are DRAFT, CLOSED, COMPLETED or ARCHIVED only.
```

If AMOW needs to archive dormant Clients with old Projects, the service can allow archive once no currently active work depends on the Client.

This rule should be confirmed in implementation prompt.

## 14. Restore Procedure

Recommended endpoint:

```text
fund.clients.restore
```

Rules:

- tenant-scoped lookup;
- only archived Clients can be restored;
- set `status = ACTIVE`;
- clear archive fields;
- do not relink or mutate Projects.

## 15. Project-To-Client Linking Rules For Later Slices

This planning slice should record, but not necessarily implement, Project-linking rules.

Later Project create/edit API work should:

- accept optional `clientId`;
- never infer `clientId` from organiser snapshot fields;
- require same tenant;
- block archived Clients;
- preferably block inactive Clients for new link unless explicitly allowed;
- allow unlinking while Project is still safe to edit;
- keep existing nullable `clientId` for standalone Projects;
- keep organiser fields as contact snapshots.

Recommended first linking rule:

```text
Project create can link to ACTIVE Client or remain standalone.
Project update can link/change/unlink Client while Project is DRAFT.
Non-DRAFT Project Client changes should be read-only until a dedicated operational rule is approved.
```

This mirrors the care used for Event linkage without assuming all date/Event rules apply to Clients.

## 16. Archived Client Behaviour

Archived Clients:

- hidden from list by default;
- visible when `includeArchived` is true or status filter is `ARCHIVED`;
- visible on historical linked Projects;
- not eligible for new Project links;
- not normally editable until restored;
- restorable by C1 admin.

Hard delete:

```text
Not offered.
```

The schema uses `onDelete: Restrict` for Project-linked Clients, and the API should not expose hard delete.

## 17. Audit Logging Requirements

Meaningful mutations should write `AuditLog` records following current FUND service conventions.

Recommended audit actions:

```text
FUND_CLIENT_CREATED
FUND_CLIENT_UPDATED
FUND_CLIENT_ARCHIVED
FUND_CLIENT_RESTORED
FUND_CLIENT_STATUS_CHANGED
FUND_CLIENT_CONTACT_CHANGED
```

Metadata should include:

- `code`;
- `slug`;
- `name`;
- `clientType`;
- status changes;
- contact-field change marker where relevant;
- archive reason where relevant.

Do not log sensitive unnecessary data beyond normal contact snapshot metadata.

## 18. Error Handling

Recommended tRPC error codes:

- `UNAUTHORIZED`: no actor/user.
- `FORBIDDEN`: authenticated actor lacks C1/FUND admin permission.
- `NOT_FOUND`: Client not found in current tenant, including cross-tenant ids.
- `CONFLICT`: duplicate `code` or `slug`, including Prisma `P2002`.
- `BAD_REQUEST`: invalid status operation, archived update, invalid Project-link helper use.

Prisma `P2002` should be caught and converted to `CONFLICT` with a Client-specific message.

## 19. Payload Safety

Client payloads may expose:

- Client profile fields;
- primary contact snapshot fields;
- linked Project summaries;
- Project count.

Client payloads must not expose:

- unrelated tenant data;
- C2 user membership data;
- participant lists;
- order/sales/reporting placeholders from non-existent future domains;
- audit log internals unless a future audit view is explicitly planned.

## 20. Manual / API Test Checklist

Implementation review should test or inspect:

- C1 admin can list Clients for current tenant.
- Archived Clients are hidden by default.
- Archived Clients can be included explicitly.
- Search covers code/name/slug/client type/contact email.
- C1 admin can get Client detail with Project summaries.
- Cross-tenant Client id returns `NOT_FOUND`.
- Create defaults to `ACTIVE`.
- Duplicate code returns `CONFLICT`.
- Duplicate slug returns `CONFLICT`.
- Update changes profile/contact fields.
- Update does not infer Client from Project organiser fields.
- Archive soft-archives only.
- Restore clears archive state.
- Linked Projects remain linked after archive/restore.
- No hard delete endpoint exists.
- Non-FUND or non-admin actor cannot mutate Clients.
- No UI, Client users, invitations, Store, Orders, Commerce, Sales/Reporting, Communications or SeasonPro mapping were introduced.

## 21. Recommended Implementation Prompt

```text
Proceed with FUND Phase 1 Slice 1P-F-D implementation: C1 Client Management API/services only.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-d-c1-client-management-api-services-planning.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-f-c-c1-client-management-schema-confirmation.md
- current FUND router/service/Zod conventions
- current Product, Catalogue, Project and Event service patterns

Implement C1 Client Management API/services only.

Use existing 1P-F-C schema:
- FundClientStatus
- FundClient
- nullable FundProject.clientId

Add procedures:
- fund.clients.list
- fund.clients.get
- fund.clients.create
- fund.clients.update
- fund.clients.archive
- fund.clients.restore

Implementation requirements:
- create clients validation schemas;
- create clients service;
- create clients router;
- mount clients router under fund.clients;
- use withFeature('fund');
- require assertFundAdmin for all Client procedures;
- never accept organizationId from client input;
- scope all reads/writes to actor.organizationId;
- code and slug unique per tenant;
- convert Prisma P2002 to CONFLICT;
- include linked Project summaries in get payload;
- hide archived Clients by default;
- soft archive only;
- do not expose hard delete;
- write AuditLog records for meaningful mutations;
- primary contact fields are snapshots only;
- do not infer Client ownership from organiserName, organiserEmail or organiserPhone;
- do not auto-link existing Projects;
- plan Project-to-Client linking helper only if it does not mutate Project procedures in this slice.

Do not implement:
- UI;
- Project Client selector;
- Client users;
- Client roles;
- invitations;
- C2 dashboard expansion;
- C2 mutations;
- Project Request/onboarding;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- Communications;
- key-date automation;
- SeasonPro Club mapping;
- reusable core Client/account model;
- schema changes or migrations unless a genuine blocker is found and explained first.

Do not run db:push.
Do not run seed/reset commands.

Run:
- npx prisma validate
- npm run db:generate
- npm run type-check
- npm run verify
- git diff --check

Create implementation confirmation document:
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-f-d-c1-client-management-api-services-confirmation.md

The confirmation should include:
- slice name and date;
- implementation summary;
- files changed;
- endpoints/procedures created;
- service functions created;
- validation schemas created;
- tenant scoping strategy;
- access control/feature gating;
- audit events;
- archived Client behaviour;
- Project-linking boundary;
- explicit out-of-scope confirmation;
- confirmation that no schema/migration/db push/seed/reset work was done unless a blocker was documented first;
- checks run and results;
- risks/follow-ups;
- recommended next slice.
```

## 22. Planning Verdict

Verdict:

```text
Proceed to API/services implementation after review.
```

Recommended next implementation:

```text
1P-F-D - C1 Client Management API/services only.
```

Recommended next product slice after API/services:

```text
1P-F-E - C1 Client Management UI.
```
