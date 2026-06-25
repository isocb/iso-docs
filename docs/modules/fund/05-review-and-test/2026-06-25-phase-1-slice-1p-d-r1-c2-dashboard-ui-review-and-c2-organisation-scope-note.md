# FUND Phase 1 Slice 1P-D-R1 - C2 Dashboard UI Review And C2 Organisation Scope Note

Date: 2026-06-25

## 1. Review Verdict

Proceed with caveats.

The implemented Slice 1P-D C2 read-only organiser dashboard UI is safe to keep as an interim participant-scoped dashboard.

Caveats:

- authenticated browser testing still needs suitable C2 participant test data;
- before authenticated staging testing, confirm in Render/Neon that migration `20260625143000_add_fund_project_participants` has applied;
- further C2 dashboard expansion must pause before mutations, participant management, invitations, sales/reporting, Store, Orders or Commerce until the C2 organisation/account model is decided.

## 2. Files Reviewed

App repo:

- `src/app/(app)/app/fund/page.tsx`
- `src/app/(app)/app/fund/organiser/page.tsx`
- `src/app/(app)/app/fund/organiser/projects/[id]/page.tsx`
- `src/modules/fund/components/organiser/OrganiserContextSwitch.tsx`
- `src/modules/fund/components/organiser/OrganiserDashboardPage.tsx`
- `src/modules/fund/components/organiser/OrganiserProjectDetailPage.tsx`
- `src/modules/fund/components/organiser/OrganiserProjectProductsTable.tsx`

Docs reviewed:

- `00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`
- `01-cr-inputs/2026-06-25-c2-organisation-scope-clarification.md`
- `03-slice-planning/2026-06-25-fund-phase-1-slice-1p-d0-c2-organisation-scope-clarification.md`
- `04-implementation-confirmations/2026-06-25-phase-1-slice-1p-d-c2-read-only-organiser-dashboard-ui-confirmation.md`
- `05-review-and-test/2026-06-25-phase-1-slice-1p-c-r1-c2-read-only-project-api-services-review.md`

## 3. Routes Reviewed

Reviewed implemented routes:

- `/app/fund/organiser`
- `/app/fund/organiser/projects/[id]`

Route entry files exist and delegate to read-only organiser components.

The existing `/app/fund` route remains the C1 admin home. It now includes a muted `Organiser Projects` navigation card linking to `/app/fund/organiser`.

## 4. Endpoint Usage Proof

Grep confirmed the organiser UI uses only:

- `trpc.fund.organiser.projects.list.useQuery`
- `trpc.fund.organiser.projects.get.useQuery`

Grep found no use of:

- `trpc.fund.projects.*`
- `fund.projects`
- C1 admin Project mutation names

inside:

- `src/app/(app)/app/fund/organiser`
- `src/modules/fund/components/organiser`

This confirms the C2 pages are powered by participant-scoped organiser endpoints, not C1 admin Project endpoints.

## 5. Read-Only Boundary Assessment

No mutation hooks or write controls were found in the C2 organiser UI.

Confirmed absent:

- create/edit/save/archive/delete controls;
- Project status transition controls;
- Project Product add/remove/reactivate/reorder controls;
- participant management controls;
- invitation controls;
- Store, Order or Commerce controls.

The only interactive controls are navigation, search/filter, retry and card/detail links.

## 6. Dual-Role / Context-Switch Assessment

`OrganiserContextSwitch` is navigation only.

It provides:

- current-context text: organiser Projects;
- optional back-to-organiser-list navigation on detail pages;
- `Switch to FUND admin` only when the existing session indicates platform admin, owner or admin access.

It does not introduce:

- impersonation;
- server-side role switching;
- access-rule changes;
- use of C1 endpoints to populate organiser views.

The `/app/fund` organiser card is safe because it is only a link. It does not grant access. Participant scoping remains enforced by `fund.organiser.projects.*`.

## 7. UI Data Safety Assessment

The organiser list displays safe Project summary fields:

- Project name, number and slug;
- Project status and lifecycle state;
- linked Event name/code when present;
- effective close date/source;
- active Project Product count;
- participant role display.

The organiser Project detail displays safe read-only fields:

- Project overview;
- organiser contact snapshots for display only;
- linked Event context;
- effective close date/source;
- readiness context values as display-only;
- active Project Product snapshot rows.

Project Product rows are snapshot-only and show:

- Product code/name/short description snapshots;
- Workflow Class code/name snapshots;
- unit price net snapshot;
- VAT rate snapshot;
- currency snapshot.

No live Product admin edit surface is exposed.

## 8. Loading / Empty / Error States

Confirmed implemented:

- loading placeholder cards on `/app/fund/organiser`;
- loading panel on `/app/fund/organiser/projects/[id]`;
- empty state: `No Projects assigned to you yet.`;
- retryable error states for list and detail queries.

Direct URL access to an unassigned or missing Project will rely on the organiser `get` endpoint returning `NOT_FOUND`, which renders the page error state without exposing other Project data.

## 9. C1 Admin Regression Assessment

C1 admin Project, Event and Product management components were not changed by 1P-D.

The only C1 admin surface change is the additional muted organiser navigation card on `/app/fund`.

Existing C1 admin routes remain distinct from organiser routes:

- C1: `/app/fund/projects`
- C1: `/app/fund/events`
- C1: `/app/fund/products`
- C2 interim: `/app/fund/organiser`

The organiser card does not alter C1 permissions, C2 permissions or server access rules.

## 10. Authenticated / Staging Test Status

Static/code review completed.

Authenticated browser testing was not run in this review because suitable target participant data and Render/Neon migration confirmation are still required.

Local migration file exists:

```text
prisma/migrations/20260625143000_add_fund_project_participants
```

Required staging gate remains:

```text
Confirm in Render/Neon that 20260625143000_add_fund_project_participants has applied before authenticated 1P-D staging testing.
```

## 11. Smoke Tests Still To Run With Test Data

Run when suitable C2 participant test data exists:

- ACTIVE participant sees assigned Projects.
- User with no assigned Projects sees empty state.
- INVITED participant does not gain access.
- DISABLED participant does not gain access.
- REMOVED participant does not gain access.
- `userId = null` participant does not gain access.
- Matching `organiserEmail` alone does not grant access.
- Direct URL to unassigned Project shows safe not-available/error state.
- Dual-role user can navigate between C1 admin and C2 organiser surfaces.

## 12. C2 Organisation / Account Caveat

1P-D was implemented before the C2 organisation/account clarification was raised.

Current implemented model:

```text
User -> FundProjectParticipant -> FundProject
```

This is safe for the current read-only interim dashboard.

It should not be treated as the final C2 operating model.

Future C2 architecture may need:

```text
C1 Producer/Admin Tenant
-> C2 Fundraising Organisation / School / Club / PTA / Customer Account
-> Projects
-> C2 users
```

Integrated SeasonPro + FUND may use a SeasonPro Club as the C2 fundraising Project creator/account.

Further C2 expansion must pause before adding mutations, participant management, invitations, sales/reporting, Store, Orders or Commerce until the C2 organisation/account decision is made.

## 13. Defects Found

No concrete product defects found in static/code review.

No application code changes were made in this review slice.

## 14. Checks Run

App repo:

- `npm run type-check` - passed.
- `git diff --check` - passed.
- endpoint boundary grep - passed.
- local migration folder presence check - passed.

Docs repo:

- review document updated.

## 15. Recommendation On Aligning 1P-D To Dev/Staging

Recommendation: align 1P-D to `dev` after this review is accepted.

Recommendation: align 1P-D to `staging` only after confirming in Render/Neon that migration `20260625143000_add_fund_project_participants` has applied in the target staging database.

Reason:

- 1P-D is additive UI only;
- it is read-only;
- it consumes only participant-scoped organiser endpoints;
- it introduces no schema or migration work;
- it does not change C1 admin Project/Event/Product management.

## 16. Recommended Next Architecture Planning Slice

Proceed next to a C2 organisation/account scope decision slice before any C2 write-capable or commercially meaningful work.

Recommended next slice:

```text
FUND Phase 1 Slice 1P-D0 / 1P-F - C2 Organisation/Account Scope Decision
```

Suggested goal:

```text
Decide whether FUND should continue direct Project participants, introduce a FUND-specific C2 organisation/account model, introduce a reusable IsoStack C2 organisation/account model, or use a hybrid.
```

Hold until this is decided:

- C2 mutations;
- C1 participant management UI;
- organiser invitations;
- Project Request/onboarding;
- sales/reporting;
- Store;
- Orders;
- Commerce Core coupling.
