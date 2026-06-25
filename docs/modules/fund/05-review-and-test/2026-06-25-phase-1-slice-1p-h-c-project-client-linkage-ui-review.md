# FUND Phase 1 Slice 1P-H-C - Project Client Linkage UI Review And Authenticated Smoke Testing

Date: 2026-06-25

Status: Review complete / proceed with caveats

## 1. Review Verdict

Proceed with caveats.

The Project Client linkage API/services and UI are correctly scoped and passed code/static verification. Authenticated browser smoke testing was not completed from this shell because no logged-in local or staging browser session was available.

Recommendation:

```text
Commit the 1P-H-A/1P-H-B batch, align to dev, then align to staging after a quick authenticated smoke test or with the smoke test explicitly accepted as a post-deploy check.
```

## 2. Files Reviewed

App repo:

- `src/modules/fund/lib/validation/projects.ts`
- `src/modules/fund/services/projects.service.ts`
- `src/modules/fund/components/projects/ProjectClientSelector.tsx`
- `src/modules/fund/components/projects/ProjectCreateModal.tsx`
- `src/modules/fund/components/projects/ProjectDetailPage.tsx`
- `src/modules/fund/components/projects/ProjectTable.tsx`

Docs repo:

- `docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-h-project-client-selector-linkage-planning.md`
- `docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-h-a-project-client-linkage-api-services-confirmation.md`
- `docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-h-b-project-client-selector-ui-confirmation.md`

## 3. Scope Reviewed

Reviewed:

- Project create Client selector.
- Project detail linked Client display.
- DRAFT-only Client link/change/unlink UI.
- Non-DRAFT read-only Client display.
- linked Client navigation to `/app/fund/clients/[id]`.
- Client selector loading/empty/error handling.
- Query invalidation for Project and Client counts/detail.
- Project Client linkage service validation and audit events from 1P-H-A.

## 4. Endpoint Usage Assessment

The Project Client UI uses the accepted C1 endpoints:

- `fund.projects.create`
- `fund.projects.update`
- `fund.projects.get`
- `fund.projects.list`
- `fund.clients.list`

The update flow also invalidates existing Client queries where available:

- `fund.clients.list`
- `fund.clients.get`

No C2 organiser endpoints are used in the Project Client selector/display implementation.

No Client user, invitation, Project Intake, Store, Order or Commerce endpoint usage was found in the Project Client linkage changes.

## 5. Project Create Assessment

Passed by code/static review:

- Optional Client selector is present in `ProjectCreateModal`.
- Project can be created without a Client.
- Project can be created with a selected active Client.
- Client and Event selection are independent.
- Client selector uses `fund.clients.list` with active/current filtering.
- Archived/inactive Clients are not included as new selectable options.
- Client is not inferred from organiser snapshot fields.
- Client contact fields are not copied into Project organiser fields.
- Client list is invalidated after create when a Client is linked.

Authenticated browser check remains required to confirm the actual selector data and create flow in the running environment.

## 6. Project Detail Assessment

Passed by code/static review:

- Project detail Overview includes a Client Linkage section.
- Linked Client name, code, type and status are displayed.
- Linked Client name navigates to `/app/fund/clients/[id]`.
- Standalone Project state is explicit when no Client is linked.
- DRAFT Projects can link/change/unlink Client through the existing Project save flow.
- Non-DRAFT Projects display Client linkage read-only.
- Archived/inactive linked Clients remain visible as historical context.
- UI text confirms Client linkage does not copy Client contact fields into organiser fields.
- Project and Client queries are invalidated after successful link/change/unlink.

Authenticated browser check remains required to confirm the end-to-end save behaviour and navigation.

## 7. Project List Assessment

Project list Client display is intentionally deferred.

Reason accepted:

- the current Project table is already dense;
- Project detail now provides the authoritative Client display/edit surface;
- adding a Client column is better handled in a later table-density review.

No Project table row action buttons were introduced.

## 8. Service / Access Rule Assessment

Passed by code/static review:

- `projectCreateInputSchema` and `projectUpdateInputSchema` accept optional nullable `clientId`.
- `createProject` validates selected Client through `validateProjectClientLink`.
- `updateProject` allows Client linkage changes only while Project is `DRAFT`.
- non-DRAFT Client linkage changes return `BAD_REQUEST`.
- archived/inactive Client linkage is rejected by Client validation.
- missing/cross-tenant Client ids are rejected through tenant-scoped Client lookup.
- `FundProject.organiserName`, `organiserEmail` and `organiserPhone` are not used as Client ownership or access-control sources.
- Project Client audit events are written for link/change/unlink.

## 9. Out-Of-Scope Confirmation

Not introduced:

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

## 10. Authenticated Smoke Test Status

Not completed from this shell.

Required browser smoke checklist before or immediately after staging alignment:

- `/app/fund/projects` loads for C1 admin.
- Create Project modal loads active Clients in the Client selector.
- Project can be created with no Client.
- Project can be created with an active Client.
- Client and Event can be selected independently.
- Project detail shows linked Client name/code/type/status.
- Linked Client navigates to `/app/fund/clients/[id]`.
- DRAFT Project can link/change/unlink Client and save.
- Non-DRAFT Project shows Client linkage read-only.
- Archived/inactive linked Client remains visible historically if test data exists.
- Archived/inactive Clients are not offered for new selector linkage.
- Stale or malicious non-DRAFT Client linkage update is rejected by the server if API smoke tooling is available.
- Project organiser fields remain unchanged when Client changes.
- Existing Products, Clients, Events and Project Products pages still load.

## 11. Checks Run

App repo:

- `npm run type-check` - passed.
- `npm run verify` - passed after rerunning with elevated permissions because the sandbox blocked the `tsx` IPC pipe.
- `git diff --check` - passed.

Docs repo:

- `git diff --check` - passed.

## 12. Defects / Fixes

No code defects were found during static review.

No fixes were made in this review slice.

## 13. Alignment Recommendation

Recommendation:

```text
Proceed with caveats.
```

Suggested sequence:

1. Commit the 1P-H-A API/services and 1P-H-B UI batch.
2. Align the committed batch to `dev`.
3. Run the authenticated smoke checklist locally or on dev/staging.
4. Align to `staging` if the smoke checklist passes, or align deliberately with the smoke test recorded as post-deploy validation.

Because 1P-H-A/1P-H-B introduce no schema changes or migrations, staging alignment does not require a new migration gate.

## 14. Recommended Next Slice

Recommended next slice after alignment decision:

```text
1P-G-A - Project Intake Schema And Moderation Planning
```

Keep Project Intake as planning-only until Project Client linkage is accepted in the C1 admin workflow.
