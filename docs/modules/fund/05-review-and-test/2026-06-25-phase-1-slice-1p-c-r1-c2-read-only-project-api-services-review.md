# FUND Phase 1 Slice 1P-C-R1 - C2 Read-Only Project API/Services Review

Date: 2026-06-25

## 1. Review Verdict

Proceed with caveats.

The Slice 1P-C implementation is correctly bounded as read-only organiser-facing Project API/services and is safe to use as the basis for C2 dashboard UI planning.

Caveat:

```text
Runtime/API smoke testing still needs suitable FundProjectParticipant rows in the target environment.
```

The static/code review confirms the access predicates, payload shaping and non-goal boundaries. The next review should exercise the endpoints with ACTIVE, INVITED, DISABLED, REMOVED and null-user participant rows.

## 2. Files Reviewed

App repo:

- `src/modules/fund/lib/validation/organiser-projects.ts`
- `src/modules/fund/services/organiser-projects.service.ts`
- `src/modules/fund/routers/organiser-projects.router.ts`
- `src/modules/fund/routers/organiser.router.ts`
- `src/modules/fund/routers/index.ts`

Docs reviewed:

- `docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-c-c2-read-only-project-api-services-proposal.md`
- `docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-c-c2-read-only-project-api-services-confirmation.md`
- `docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-b-c2-project-participant-schema-confirmation.md`
- `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 3. Endpoint Access-Rule Assessment

Endpoints reviewed:

```text
fund.organiser.projects.list
fund.organiser.projects.get
```

The router uses existing FUND feature gating:

```text
withFeature('fund')
```

The organiser endpoints do not call `assertFundAdmin`.

Access is enforced in the organiser service through Project participant joins requiring:

```text
participant.organizationId = actor.organizationId
participant.userId = actor.userId
participant.status = ACTIVE
participant.projectId = project.id
```

The service never accepts client-supplied `organizationId` or `userId`.

Cross-tenant, unassigned or missing Project ids return `NOT_FOUND` through the same lookup path, avoiding a permission/existence leak.

## 4. Snapshot / Email Access Boundary

Confirmed access is not derived from:

- `FundProject.organiserName`;
- `FundProject.organiserEmail`;
- `FundProject.organiserPhone`;
- `FundProjectParticipant.email` without linked `userId`.

The service only returns organiser snapshot fields in the detail payload for display/contact context. They are not used in access predicates.

Participants with these statuses do not grant access:

- `INVITED`;
- `DISABLED`;
- `REMOVED`.

Participants with `userId = null` do not grant access because the predicate requires `userId = actor.userId`.

## 5. Payload Safety Assessment

### List Payload

`fund.organiser.projects.list` returns assigned Project summaries only.

Safe fields include:

- Project id, number, name and slug;
- status and lifecycle state;
- Project dates;
- effective close date and source;
- linked Event summary;
- current participant role/status/isPrimary;
- active Project Product count.

No C1 internal/admin fields are exposed in the list payload.

### Detail Payload

`fund.organiser.projects.get` returns one assigned Project only.

Safe fields include:

- Project summary/detail fields;
- description;
- organiser snapshot contact/context fields;
- linked Event summary;
- current participant role/status/isPrimary;
- active Project Product count;
- active Project Product snapshot rows.

Confirmed omitted:

- `internalNotes`;
- all-participant lists;
- audit metadata;
- C1 admin controls;
- mutation affordances;
- live editable Product admin records.

## 6. Effective Close-Date Assessment

The implementation computes:

```text
effectiveClosesAt
closeDateSource
```

Rules confirmed:

- Project `closesAt` wins when present: `closeDateSource = PROJECT`;
- linked Event `closesAt` is inherited when Project `closesAt` is blank: `closeDateSource = EVENT`;
- no close date returns `closeDateSource = NONE`.

The implementation does not copy Event dates into Project date fields.

## 7. Project Product Snapshot Serialisation

The detail endpoint exposes active Project Product snapshot rows only.

Decimal snapshot fields are serialised safely:

- `unitPriceNetSnapshot` -> number or null;
- `vatRateSnapshot` -> number or null.

The endpoint exposes snapshot fields, not live editable Product admin records.

## 8. C1 Admin Endpoint Regression Assessment

The existing C1 admin Project router/services remain unchanged.

The Slice 1P-C implementation added a new organiser router under the FUND router and did not alter:

- `fund.projects.list`;
- `fund.projects.get`;
- `fund.projects.create/update/status actions`;
- Project Product mutation endpoints.

## 9. Non-Goal Boundary Confirmation

Confirmed no work was introduced for:

- dashboard UI;
- C2 mutations;
- C1 participant management UI;
- invitations;
- Project Request/onboarding;
- Store;
- Orders;
- Commerce Core;
- payments;
- commissions;
- production batching;
- Event/Catalogue/Product availability changes;
- workflow suitability changes;
- Prisma schema changes;
- migrations;
- `db:push`;
- seed/reset commands.

## 10. Checks Run

- `npm run type-check` - passed.
- `git diff --check` - passed.
- `npm run verify` - first sandboxed run failed because `tsx` could not create its local IPC pipe; rerun with approved escalation passed.

## 11. Manual / API Smoke Tests Defined

These should be run once the environment has suitable participant rows:

- ACTIVE participant can list assigned Projects.
- ACTIVE participant can get assigned Project detail.
- INVITED participant cannot access.
- DISABLED participant cannot access.
- REMOVED participant cannot access.
- Participant with `userId = null` cannot access.
- Matching Project `organiserEmail` alone does not grant access.
- Cross-tenant Project id returns `NOT_FOUND`.
- Unassigned Project id returns `NOT_FOUND`.
- C2 endpoints expose no mutations.
- C1 admin Project endpoints still work.

## 12. Defects Found

No code defects found in static review.

## 13. Follow-Up Items

- Add or document a safe way to create test participant rows for local/staging API smoke testing.
- Decide whether first C2 dashboard should show archived assigned Projects by default or only via an explicit historical filter.
- Plan C1 participant management separately before non-technical users need to assign organiser access.
- Keep C2 dashboard UI read-only until participant-scoped API smoke tests pass.

## 14. Recommendation On Aligning `69a9632` To Dev/Staging

Recommendation: align `69a9632` to `dev` and `staging` after confirming the 1P-B participant migration has been applied in the target database.

Reason:

- 1P-C is read-only API/service work;
- no schema changes were introduced by 1P-C;
- the implementation is additive under `fund.organiser.projects`;
- C1 admin endpoints remain unchanged;
- the dashboard UI slice should use the same API shape that will exist in staging.

Hold condition:

```text
Do not align to staging if the 1P-B participant migration has not been applied there.
```

## 15. Recommendation On 1P-D Dashboard UI Planning

Recommendation: 1P-D dashboard UI planning may begin.

The planning should remain read-only and should explicitly depend on:

```text
fund.organiser.projects.list
fund.organiser.projects.get
```

Do not implement C2 mutations, invitations, participant management or Project Request/onboarding in 1P-D.
