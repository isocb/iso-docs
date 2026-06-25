# FUND Phase 1 Slice 1P-F-B - C1 Client Management Schema Options

Date: 2026-06-25

Status: Planning only

## 1. Slice Goal

Decide the minimum safe schema direction for C1 Client Management before implementation.

The immediate AMOW founding-tenant priority is the C1 organisational dashboard:

- Clients;
- Products;
- Catalogues;
- Events;
- Projects;
- Project/Event linkage;
- Project Product membership.

The current 1P-D C2 read-only dashboard is technically safe but functionally interim. It is not the immediate AMOW presentation priority and must not become the final C2 operating model by accident.

## 2. Core Decision

Recommended schema direction:

```text
FUND-specific first, platform-aware.
```

Recommended first implementation:

```text
FundClient
FundProject.clientId nullable
```

Rationale:

- gives AMOW a clear C1 Client management concept quickly;
- fits the current FUND schema boundary under the dedicated `fund` schema;
- avoids a platform-wide Client/account migration before Tuesday;
- protects future mapping to a reusable IsoStack Client/account model;
- protects future SeasonPro Club mapping;
- keeps existing Projects valid while Client linkage is introduced gradually.

## 3. Alternatives Considered

### Option A - No Client Schema Yet

Continue using organiser snapshot fields and Project participants only.

Verdict:

```text
Not recommended.
```

Why:

- organiser name/email/phone are contact snapshots, not account ownership;
- `FundProjectParticipant` is useful for access and contacts but not the strategic Client ownership model;
- AMOW needs to explain Clients as fundraising organisations, not only people attached to Projects.

### Option B - FUND-Specific Client First

Create a FUND-owned Client model.

Potential shape:

```text
FundClient
FundProject.clientId
```

Verdict:

```text
Recommended for the next implementation slice.
```

Why:

- lowest near-term blast radius;
- follows current FUND schema conventions;
- gives C1 admin a real Client surface;
- allows existing Projects to remain standalone until linked;
- can later be mapped to a reusable core Client/account model.

### Option C - Reusable IsoStack Core Client Account Now

Create a platform-level Client/account model for FUND, SeasonPro and future modules.

Potential shape:

```text
ClientAccount
ClientAccountUser
FundProject.clientAccountId
LMSProClub.clientAccountId
```

Verdict:

```text
Defer.
```

Why:

- strategically attractive but too broad for the immediate AMOW presentation;
- would require wider platform review;
- would likely touch SeasonPro concepts before the required mapping is fully planned.

### Option D - Hybrid Foundation

Create `FundClient` now, with explicit future mapping to core Client/account.

Verdict:

```text
Recommended strategic interpretation of Option B.
```

This lets FUND move now without pretending the FUND-specific model is necessarily the final cross-module platform account model.

## 4. Recommended Model

Recommended model:

```text
FundClient
```

Recommended relation:

```text
FundClient has many FundProjects.
FundProject optionally belongs to one FundClient.
```

Recommended Project field:

```text
FundProject.clientId String? @map("client_id")
```

Recommended Prisma relation shape:

```text
clientId String?     @map("client_id")
client   FundClient? @relation(fields: [organizationId, clientId], references: [organizationId, id], onDelete: Restrict)
```

This mirrors the current nullable same-tenant `FundProject.eventId` pattern.

## 5. Minimal Model Fields

Recommended minimal `FundClient` fields:

```text
id
organizationId
code
name
slug
clientType
description
status
primaryContactName
primaryContactEmail
primaryContactPhone
internalNotes
metadata
archivedAt
archivedById
archivedReason
createdById
updatedById
createdAt
updatedAt
```

Recommended notes:

- `organizationId` is the C1 tenant boundary.
- `clientType` should be a flexible string initially, not a hard enum.
- `primaryContactName/email/phone` are contact snapshots only, not identity or access control.
- `metadata` allows harmless future presentation/support attributes without immediate schema churn.
- archive should follow existing FUND soft-archive conventions.

## 6. Recommended Status Strategy

Recommended enum:

```text
FundClientStatus
```

Recommended values:

```text
ACTIVE
INACTIVE
ARCHIVED
```

Recommended default:

```text
ACTIVE
```

Rationale:

- Client is an account/profile concept, not a campaign lifecycle object;
- `DRAFT` is less useful for an internal C1-managed Client record;
- `INACTIVE` supports dormant Clients without deleting or archiving them;
- `ARCHIVED` aligns with soft-archive UI behaviour.

If implementation wants to avoid a new enum, a string status could work, but current FUND schema conventions favour enums for meaningful status fields.

## 7. Tenant Scoping

Tenant boundary:

```text
FundClient.organizationId = C1 tenant
FundProject.organizationId = C1 tenant
```

Required uniqueness:

```text
@@unique([organizationId, id])
@@unique([organizationId, code])
@@unique([organizationId, slug])
```

Required indexes:

```text
@@index([organizationId, status])
@@index([organizationId, clientType])
@@index([archivedAt])
```

Organization relation:

```text
organization Organization @relation(fields: [organizationId], references: [id], onDelete: Cascade)
```

Organization should gain:

```text
fundClients FundClient[]
```

## 8. Same-Tenant Project-To-Client Linkage

Project-to-Client relation should be same-tenant:

```text
FundProject.clientId
FundProject.client
```

Recommended relation:

```text
client FundClient? @relation(fields: [organizationId, clientId], references: [organizationId, id], onDelete: Restrict)
```

Required Project index:

```text
@@index([organizationId, clientId])
```

Recommended delete/archive strategy:

- do not hard-delete Clients with linked Projects;
- use soft archive on Clients;
- relation should be `Restrict` so Project history is protected;
- archived Clients should remain visible on historical Projects;
- future Project create/update services should block linking new Projects to archived Clients.

## 9. Standalone Projects

Standalone Projects should remain allowed in this schema slice.

Recommendation:

```text
FundProject.clientId remains nullable.
```

Why:

- existing Projects already exist without Clients;
- AMOW may need standalone or internal Projects;
- Project Request/onboarding is not designed yet;
- backfilling all existing Projects immediately would be artificial;
- requiring a Client can be a future service/UI rule once the Client model is tested.

Presentation wording:

```text
Most operational Projects belong to Clients, but the schema permits standalone Projects while the model is phased in.
```

## 10. Migration / Backfill Approach

Recommended migration approach:

- create `FundClientStatus` enum;
- create `fund.fund_clients`;
- add nullable `client_id` column to `fund.fund_projects`;
- add same-tenant foreign key from Project to Client;
- add indexes and uniqueness constraints;
- do not backfill existing Projects automatically;
- do not create placeholder Clients automatically;
- do not use seed/reset/db:push.

Backfill recommendation:

```text
Leave existing Projects with clientId = null.
```

Reason:

- no authoritative Client source exists yet;
- organiser snapshot fields are not ownership;
- automatic Client creation from organiser text/email would create false account records;
- C1 admin can link existing Projects deliberately in a later API/UI slice.

## 11. UI Implications

First C1 Client UI should consume:

- Client list;
- Client detail;
- linked Project summaries;
- Client create/update/archive/restore procedures.

Client list should show:

- Client name;
- Client type;
- status;
- primary contact;
- Project count;
- active Project count if inexpensive;
- updated date;
- archived filtering.

Client detail should be a child management page, not a modal-only entity, because Client is an operational parent entity.

Near-term Client detail should show:

- Client profile;
- contact snapshot;
- linked Projects;
- future placeholders only where useful and clearly non-functional.

Do not add Store, Orders, Sales, Communications or Client users UI in the first Client UI slice.

## 12. Relationship To Existing Project Fields

Existing Project organiser fields remain:

```text
organiserName
organiserEmail
organiserPhone
```

Interpretation remains:

```text
Project contact snapshots only.
```

They must not become:

- Client identity;
- user identity;
- access control;
- ownership;
- invitation state.

When a Project is linked to a Client, organiser fields may still describe the day-to-day Project contact.

## 13. Relationship To FundProjectParticipant

`FundProjectParticipant` remains useful for:

- interim read-only dashboard access;
- named Project contacts;
- role overrides;
- exception access;
- temporary access bridges;
- future helper/contact visibility.

It should not be treated as the final Project ownership model.

Future target:

```text
Client owns Projects.
Client users operate Projects.
FundProjectParticipant handles Project-specific exceptions/contacts.
```

## 14. SeasonPro Mapping Guardrails

SeasonPro Club precedent:

```text
LMSProClub
organizationId
seasonId
fullName
shortName
status
primaryContact
officials
teams
```

Guardrails:

- do not modify SeasonPro Club schema in this slice;
- do not add SeasonPro-to-FUND mapping fields yet;
- do not assume every FUND Client is a SeasonPro Club;
- do not assume every SeasonPro Club is immediately a FUND Client;
- document future mapping path from `LMSProClub` to either `FundClient` or a future core `ClientAccount`;
- avoid naming that prevents a later `ClientAccount` abstraction.

Possible future mapping:

```text
FundClient.externalSource = "seasonpro"
FundClient.externalSourceId = LMSProClub.id
```

or, if reusable core is later adopted:

```text
ClientAccount
-> LMSProClub
-> FundClient / FundProject
```

Do not implement either mapping in the first schema slice.

## 15. Fields To Defer

Defer:

- Client users;
- Client roles;
- invitations;
- login/account provisioning;
- billing details;
- payment settings;
- Store settings;
- Order settings;
- commission settings;
- sales/reporting aggregates;
- communications preferences;
- dashboard announcements;
- key-date automation configuration;
- SeasonPro Club mapping fields;
- reusable core Client/account links.

These are important but should not be packed into the AMOW foundation schema.

## 16. Safe Before Tuesday

Safe to implement before Tuesday if accepted:

- `FundClientStatus` enum;
- `FundClient` model;
- nullable `FundProject.clientId`;
- Organization relation;
- Client to Project relation;
- same-tenant foreign key;
- migration only;
- schema validation/generation/checks;
- confirmation document.

Potentially safe after schema:

- C1 Client API/services;
- C1 Client list/detail UI;
- Project create/edit Client selector;
- Project Overview Client display.

Not safe before Tuesday unless explicitly re-approved:

- Client users;
- invitations;
- C2 mutations;
- Project Request/onboarding;
- Store/Orders/Commerce;
- Sales/Reporting;
- Communications/key-date automation;
- SeasonPro mapping implementation;
- reusable core Client/account schema.

## 17. Implementation Boundary

The next implementation slice should be schema-only.

Do not implement in the schema slice:

- routers;
- services;
- Zod schemas;
- UI;
- Project selectors;
- participant management;
- Client users;
- invitations;
- Store;
- Orders;
- Commerce;
- Sales/Reporting;
- Communications;
- key-date automation;
- SeasonPro integration.

Do not run:

- `db:push`;
- seed commands;
- reset commands.

## 18. Recommended Next Implementation Slice

Recommended next slice:

```text
FUND Phase 1 Slice 1P-F-C - C1 Client Management Schema
```

Recommended implementation prompt:

```text
Proceed with FUND Phase 1 Slice 1P-F-C implementation: C1 Client Management schema only.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-b-c1-client-management-schema-options.md
- current Prisma schema conventions
- current FundProject schema
- current FUND tenant scoping patterns

Implement only:
- FundClientStatus enum;
- FundClient model;
- nullable FundProject.clientId;
- FundClient/FundProject relations;
- Organization relation;
- tenant-scoped uniqueness/indexes;
- same-tenant Project-to-Client foreign key;
- migration.

Recommended schema direction:
- FUND-specific first, platform-aware;
- user-facing term is Client;
- model name is FundClient;
- FundProject.clientId is nullable;
- organizationId remains the C1 tenant boundary;
- same-tenant relation uses [organizationId, clientId] -> [organizationId, id];
- Client hard delete should be restricted by linked Projects;
- existing Projects should not be backfilled automatically.

Do not implement:
- routers;
- services;
- Zod schemas;
- UI;
- Project Client selector;
- Client users;
- invitations;
- C2 mutations;
- Project Request/onboarding;
- Store;
- Orders;
- Commerce Core;
- payments;
- commissions;
- Sales/Reporting;
- Communications;
- key-date automation;
- SeasonPro Club mapping;
- reusable core Client/account model.

Do not run db:push.
Do not run seed/reset commands.

Run:
- npx prisma validate
- npm run db:generate
- npm run type-check
- npm run verify

Create implementation confirmation document:
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-f-c-c1-client-management-schema-confirmation.md

The confirmation should include:
- slice name and date;
- implementation summary;
- files changed;
- Prisma schema changes;
- migration created and SQL summary;
- models/enums created;
- tenant scoping strategy;
- Project/Client same-tenant relation;
- nullable/backfill strategy;
- SeasonPro mapping guardrails;
- out-of-scope confirmation;
- confirmation that db:push, seed and reset were not used;
- checks run and results;
- recommended next slice.
```

## 19. Planning Verdict

Verdict:

```text
Proceed to schema-only implementation after review.
```

Recommended option:

```text
FundClient + nullable FundProject.clientId.
```

This gives AMOW the C1 Client management foundation needed for the founding-tenant presentation while protecting future C2 Client/account, SeasonPro and Commerce architecture.
