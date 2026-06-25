# FUND Phase 1 Slice 1P-H-A - Project Client Linkage API/Services Confirmation

Date: 2026-06-25

Status: Implemented / API-services only

## 1. Slice Name

FUND Phase 1 Slice 1P-H-A - Project Client Linkage API/Services

## 2. Implementation Summary

Implemented Project Client linkage at the Project API/service layer using the existing schema:

- `FundClient`
- nullable `FundProject.clientId`
- same-tenant `FundProject.client` relation

Project create/update can now accept optional nullable `clientId`.

Project list/get payloads now include a safe linked Client summary where a Project has a Client.

No UI was implemented in this slice.

## 3. Files Changed

App repo:

- `src/modules/fund/lib/validation/projects.ts`
- `src/modules/fund/services/projects.service.ts`

Docs repo:

- `docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-h-a-project-client-linkage-api-services-confirmation.md`

## 4. Project Validation Changes

Added optional nullable `clientId` to:

- `projectCreateInputSchema`
- `projectUpdateInputSchema`

Accepted shape:

```text
clientId?: string | null
```

No `organizationId`, Client code, Client slug or organiser snapshot field is accepted as a Client linkage source.

## 5. Project Service / Router Changes

No new Project router procedures were added.

Existing Project procedures now support Client linkage where appropriate:

- `fund.projects.list`
- `fund.projects.get`
- `fund.projects.create`
- `fund.projects.update`

The router continues to use the existing Project validation schemas. Create/update remain C1/admin-gated through existing `assertFundAdmin` calls.

## 6. Payload Changes For List / Get

Project list and detail includes now load a safe linked Client summary:

- `id`
- `code`
- `name`
- `slug`
- `clientType`
- `status`
- `archivedAt`

This supports historical display of existing linked Clients without exposing Client internals, users, roles, invitations, notifications or private notes.

## 7. Create Client Linkage Behaviour

Project create now supports:

- `clientId` omitted or `null`: Project remains standalone / no Client linkage.
- `clientId` as UUID: Project links to the active same-tenant Client after validation.

Validation uses the existing Client helper:

```text
validateProjectClientLink
```

That helper rejects:

- missing/cross-tenant Client ids as not found;
- archived Clients;
- inactive Clients.

Project create does not infer Client ownership from organiser snapshot fields.

Project create does not create Client users, invitations, notifications, intake submissions or Client records.

## 8. Update Client Linkage Behaviour

Project update now supports:

- `clientId` omitted: no Client linkage change.
- `clientId: null`: unlink Client when allowed.
- `clientId: <uuid>`: link/change Client when allowed and valid.

Client link/change/unlink is allowed only while the Project is `DRAFT`.

Non-DRAFT Client linkage changes return `BAD_REQUEST` with a clear message:

```text
Project Client linkage can only be changed while the Project is draft
```

Changing Client does not overwrite:

- `organiserName`
- `organiserEmail`
- `organiserPhone`

## 9. DRAFT / Non-DRAFT Rule Implementation

The service compares requested `clientId` changes with the existing Project `clientId`.

If the linkage changes and the Project is not `DRAFT`, the update is rejected before mutation.

This mirrors the conservative Project/Event linkage rule and protects future Store, Order, reporting and audit semantics.

## 10. Archived / Inactive Client Behaviour

New linkage to archived Clients is blocked by the Client validation helper.

New linkage to inactive Clients is blocked by the Client validation helper.

Existing linked archived/inactive Clients remain visible historically on Project list/get payloads through the safe Client summary relation include.

## 11. Same-Tenant Validation

Client linkage validation is tenant-scoped through the current actor's `organizationId`.

Cross-tenant or missing Client ids do not leak tenant existence and are rejected through the existing Client lookup behaviour.

The database relation also remains same-tenant:

```text
FundProject(organizationId, clientId)
-> FundClient(organizationId, id)
```

## 12. Audit Events

Added Project Client audit events where linkage changes occur:

- `FUND_PROJECT_CLIENT_LINKED`
- `FUND_PROJECT_CLIENT_CHANGED`
- `FUND_PROJECT_CLIENT_UNLINKED`

Audit metadata includes where practical:

- `previousClientId`
- `newClientId`
- `previousClientCode`
- `previousClientName`
- `newClientCode`
- `newClientName`

Existing `FUND_PROJECT_CREATED` and `FUND_PROJECT_UPDATED` audit behaviour continues and now includes Client id context.

## 13. Organiser Snapshot Field Confirmation

Client ownership is not inferred from:

- `FundProject.organiserName`
- `FundProject.organiserEmail`
- `FundProject.organiserPhone`

Changing Project Client does not mutate organiser snapshot fields.

Organiser/contact snapshots remain separate from Client/account ownership.

## 14. Explicit Out Of Scope

Not implemented:

- UI;
- Project Client selector;
- Project create/edit UI changes;
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
- automatic Project creation from Client creation;
- schema changes;
- migrations.

## 15. db:push / Seed / Reset Confirmation

`db:push` was not run.

Seed commands were not run.

Reset commands were not run.

No schema changes or migrations were introduced in this slice.

## 16. Checks Run

- `npx prisma validate` - passed.
- `npm run db:generate` - passed.
- `npm run type-check` - passed.
- `npm run verify` - passed after rerunning with elevated permission because the sandbox blocked the `tsx` IPC pipe.
- `git diff --check` - passed in the app repo.
- `git diff --check` - passed in the docs repo.

## 17. Risks / Follow-Ups

- Project Client selector UI is still required for C1 users to manage the linkage in the browser.
- Authenticated API/manual testing should cover active, inactive, archived and cross-tenant Client linkage attempts.
- Historical display of inactive/archived Clients should be verified once UI consumes the new payload.
- Project Intake planning should continue to depend on this accepted Project Client linkage model.

## 18. Recommended Next Slice

Recommended next slice:

```text
1P-H-B - Project Client Selector UI
```

After 1P-H-B, run:

```text
1P-H-R1 - Project Client Linkage Review And Smoke Testing
```
