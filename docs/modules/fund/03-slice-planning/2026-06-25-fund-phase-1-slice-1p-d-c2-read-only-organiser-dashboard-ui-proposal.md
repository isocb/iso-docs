# FUND Phase 1 Slice 1P-D - C2 Read-Only Organiser Dashboard UI Proposal

Date: 2026-06-25

Status: Planning only / ready for review

Target app branch:

```text
feature/fund-phase-1-c2-project-access
```

## 1. Slice Goal

Plan the first read-only C2 organiser dashboard UI for FUND.

This dashboard should let authenticated C2 organisers see Projects assigned to them through active `FundProjectParticipant` rows.

The UI must consume only the participant-scoped organiser endpoints:

```text
fund.organiser.projects.list
fund.organiser.projects.get
```

It must not use C1 admin Project endpoints to power organiser pages.

## 2. Current Alignment / Staging Note

Current app branch alignment after 1P-C review:

```text
feature/fund-phase-1-c2-project-access = 69a9632
origin/dev                              = 69a9632
origin/staging                          = 69a9632
main                                    = 62b727e
```

Staging static health check:

```text
https://staging.isostack.app/api/health -> HTTP 200
```

Migration note:

- 1P-B introduced `FundProjectParticipant` schema and migration.
- The Render build script runs `prisma migrate deploy` during deployment.
- Direct staging `_prisma_migrations` table inspection was not available from the local shell.
- Before 1P-D implementation or authenticated staging testing, confirm in Render/Neon that `20260625143000_add_fund_project_participants` has applied to staging.

## 3. Implementation Boundary

Slice 1P-D should implement UI only after this plan is reviewed.

It may create:

- C2 organiser dashboard route(s);
- read-only Project list/card UI;
- read-only Project detail UI;
- loading, empty and error states;
- context-selection / hat-swapping affordance for users who can access both C1 and C2 surfaces;
- implementation confirmation document.

It must not create:

- C2 mutations;
- C1 participant management UI;
- organiser invitations;
- Project Request/onboarding;
- Store schema;
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

## 4. Role And Context Model

C1 users are tenant/admin/producer users.

C2 users are organiser/project users operating assigned Projects within the C1 tenant context.

A single authenticated user may be both:

- a C1 FUND admin; and
- an ACTIVE C2 participant on one or more Projects.

The UI must make this deliberate rather than accidental.

Important rule:

```text
C2 dashboard visibility comes from fund.organiser.projects.* only.
```

Even if a dual-role user can access C1 admin pages, C2 views must still be participant-scoped.

## 5. Recommended Routes

Recommended first C2 organiser routes:

```text
/app/fund/organiser
/app/fund/organiser/projects/[id]
```

Alternative:

```text
/app/fund/my-projects
/app/fund/my-projects/[id]
```

Recommendation: use `/app/fund/organiser`.

Reason:

- matches API naming `fund.organiser.projects.*`;
- leaves room for organiser tasks, submissions and communications later;
- keeps C2 organiser surface visually distinct from C1 admin routes;
- avoids confusing C1 admin `/app/fund/projects` with C2 assigned Projects.

## 6. Navigation / Hat-Swapping Pattern

### C1 FUND Home

The existing C1 FUND home at `/app/fund` should remain the admin foundation surface.

For users who also have assigned organiser Projects, the C1 FUND home may later include a muted card or banner:

```text
Organiser Projects
View Projects assigned to you as an organiser.
```

This card should link to:

```text
/app/fund/organiser
```

### C2 Organiser Home

The C2 organiser dashboard should include a clear route back to C1 admin only when the user has admin access.

Example context switcher copy:

```text
You are viewing organiser Projects.
Switch to FUND admin
```

The switch must be navigation only. It must not change server-side access rules, impersonation state or participant scoping.

### SeasonPro Precedent

SeasonPro has C1 league/admin and lower-level operating surfaces. FUND should borrow the principle of explicit context selection:

- make the current mode visible;
- do not blend admin and organiser actions on the same surface;
- avoid using admin endpoints to populate organiser mode.

## 7. C2 Dashboard Landing Page

Recommended route:

```text
/app/fund/organiser
```

Purpose:

- show assigned Projects;
- provide a calm operational starting point;
- explain empty or access states clearly;
- remain read-only.

Recommended layout:

- page header: `My FUND Projects` or `Organiser Projects`;
- short supporting text: Projects assigned to you by the tenant/admin team;
- optional context switch link to C1 admin when applicable;
- search/filter controls;
- Project card/list surface.

Do not include marketing hero treatment.

## 8. Project List / Card Design

Use cards or a compact table depending on expected count.

Recommendation for first slice:

- use responsive Project cards if most organisers will have few Projects;
- keep a list/table option viable if counts grow;
- use the same muted IsoStack card style as FUND admin cards;
- make each card a whole click target;
- use brand primary/secondary accent only for navigation affordance;
- use status colours only for semantic status/RAG meaning.

Each Project card should show:

- Project name;
- Project number;
- status badge;
- lifecycle state;
- linked Event name if present;
- effective close date;
- active Product count;
- participant role label if useful.

Card click target:

```text
/app/fund/organiser/projects/[id]
```

## 9. Project List Search / Filter Behaviour

Use the existing organiser endpoint list inputs only:

- `search`;
- `status`;
- `includeArchived` if needed.

Recommended first UI controls:

- universal search field;
- status filter with current statuses;
- optional `Show archived` toggle if archived Projects are supported.

Status filter options:

- All current;
- Draft;
- Active;
- Paused;
- Closed;
- Completed;
- Archived.

Default:

```text
All current / archived hidden
```

## 10. Empty States

No assigned Projects:

```text
No Projects assigned to you yet.
```

Supporting text:

```text
Your organisation will assign Projects here when they are ready for organiser access.
```

No matching search/filter results:

```text
No Projects match these filters.
```

Do not offer create/request actions in 1P-D.

Project Request/onboarding remains future work.

## 11. Access And Error States

Use clear states:

- loading: standard skeleton/loader in the Project list area;
- unauthorised/session issue: existing auth redirect/session handling;
- forbidden/FUND feature missing: explain that FUND access is not enabled for this account/tenant;
- not found detail: stale or unassigned Project message;
- generic error: retry affordance.

For detail `NOT_FOUND`, the UI should not say whether the Project exists in another tenant or for another organiser.

Suggested copy:

```text
Project not available
This Project could not be found or is not assigned to your organiser account.
```

## 12. Project Detail Route

Recommended route:

```text
/app/fund/organiser/projects/[id]
```

Purpose:

- show safe Project overview;
- show Event/date context;
- show Product snapshot rows;
- show status/lifecycle/readiness information;
- remain read-only.

Recommended sections:

1. Header and breadcrumb.
2. Project overview.
3. Dates and Event context.
4. Products included in this Project.
5. Contact/context information.
6. Next steps placeholder panel.

Do not use a CRUD modal. This is a child/detail page.

## 13. Project Detail Header

Header should show:

- Project name;
- Project number;
- status badge;
- lifecycle state;
- breadcrumb back to organiser dashboard;
- optional context switch to C1 admin only if user has C1 admin rights.

No admin status-action buttons should appear.

## 14. Event Context Display

If Project has linked Event:

- show Event name/code;
- show Event status;
- show Event opensAt/closesAt/productionDeadline if present;
- explain date constraint in short operational language.

Suggested wording:

```text
This Project is linked to the Event window shown below.
```

If standalone:

```text
Standalone Project
This Project is not linked to an Event window.
```

Do not expose Event admin edit links in the C2 organiser dashboard.

## 15. Effective Close Date Display

Display `effectiveClosesAt` and `closeDateSource` from `fund.organiser.projects.get/list`.

Recommended labels:

- `PROJECT`: `Project close date`;
- `EVENT`: `Inherited Event close date`;
- `NONE`: `No close date set`.

If source is `EVENT`, make it clear that the Project is using the Event close date without copying it into the Project:

```text
Using linked Event close date
```

If source is `NONE`, show a muted warning/notice only:

```text
No effective close date is currently available.
```

Do not add date editing in 1P-D.

## 16. Project Product Snapshot Rows

Use Project Product snapshot data from:

```text
fund.organiser.projects.get.projectProducts
```

Display fields:

- product code snapshot;
- product name snapshot;
- short description snapshot where present;
- workflow class name/code snapshot;
- unit price net snapshot;
- VAT rate snapshot;
- currency snapshot.

Recommended component shape:

- read-only table for desktop;
- stacked cards/rows for mobile;
- no edit/delete/reorder controls;
- no live Product admin links;
- no C1 Product/Catalogue management links.

Empty state:

```text
No Products are currently active for this Project.
```

This should be informational only. Adding Products remains C1-only in the current foundation.

## 17. Status / Lifecycle / Readiness Display

Show status and lifecycle state as display-only values.

Useful organiser-facing statuses:

- Draft;
- Active;
- Paused;
- Closed;
- Completed;
- Archived.

Readiness information should be simple and server-aligned.

In 1P-D, do not recreate all C1 admin readiness logic. Instead:

- show obvious data such as effective close date and active Product count;
- surface missing data as informational context;
- avoid making client-only promises about activation or workflow eligibility.

Suggested first readiness panel:

```text
Project status
Close date
Products included
Event window
```

No C2 actions should be attached to readiness in this slice.

## 18. Archived / Closed / Completed Handling

Default list:

- hide archived Projects unless `includeArchived` is enabled;
- show CLOSED and COMPLETED Projects by default as historical/current assigned Projects unless design review says otherwise.

Detail page:

- assigned CLOSED/COMPLETED Projects remain readable;
- assigned ARCHIVED Projects may be readable if reached from an archive filter/direct link and endpoint allows it;
- no mutation controls appear in any status.

The implementation should follow whatever the 1P-C endpoint supports; do not add client-side assumptions that contradict the API.

## 19. C1 / C2 Boundary In UI

C2 organiser dashboard must not include:

- Project create button;
- Project edit forms;
- Product membership controls;
- Event selector/edit controls;
- archive/restore/activate/pause/close/complete buttons;
- participant management controls;
- invitation controls.

If a user has both C1 and C2 access, C1 links may navigate to C1 admin surfaces, but C2 components must not call C1 APIs.

## 20. tRPC Usage Plan

Use only:

```text
trpc.fund.organiser.projects.list.useQuery(...)
trpc.fund.organiser.projects.get.useQuery(...)
```

Do not use:

```text
trpc.fund.projects.*
```

inside C2 organiser pages.

Query invalidation is minimal because 1P-D is read-only.

If future C1 actions affect C2 visible data, normal page refresh/refetch is enough for this slice.

## 21. Component / File Plan

Likely files:

```text
src/app/(app)/app/fund/organiser/page.tsx
src/app/(app)/app/fund/organiser/projects/[id]/page.tsx
src/modules/fund/components/organiser/OrganiserProjectList.tsx
src/modules/fund/components/organiser/OrganiserProjectCard.tsx
src/modules/fund/components/organiser/OrganiserProjectDetailPage.tsx
src/modules/fund/components/organiser/OrganiserProjectProductsTable.tsx
src/modules/fund/components/organiser/OrganiserContextSwitch.tsx
```

Keep components read-only and closely scoped.

## 22. UI Standard Compliance

Follow current IsoStack/FUND UI conventions:

- muted operational UI;
- brand colour only for primary navigation/accent;
- semantic colours for status/action-required states;
- whole-card navigation where a card represents a destination;
- no decorative random card colours;
- clear breadcrumbs on child pages;
- column-click sorting where tables are used;
- responsive text that does not overflow;
- no nested cards unless required for repeated items.

If a table is used:

- rows may be clickable only for navigation;
- no destructive inline actions;
- no edit/delete action column;
- no C1 admin controls.

## 23. Manual Test Checklist For Implementation

When implemented, test:

- C2 organiser with ACTIVE participant sees assigned Projects.
- C2 organiser with no assigned Projects sees empty state.
- C2 organiser cannot see unassigned Projects.
- C2 organiser cannot see Projects where participant status is INVITED/DISABLED/REMOVED.
- C2 organiser cannot see Projects where only organiserEmail matches.
- Project detail loads through `fund.organiser.projects.get`.
- Direct URL to unassigned Project shows safe not-available state.
- Event context displays correctly.
- effective close date source displays correctly for PROJECT/EVENT/NONE.
- Product snapshot rows display safe values.
- No C1 admin controls appear.
- Dual-role user can intentionally navigate between C1 admin and C2 organiser surfaces.
- C2 pages do not call `trpc.fund.projects.*`.
- FUND C1 admin pages remain unchanged.

## 24. Deliberately Out Of Scope

Do not implement:

- C2 Project edit actions;
- C2 Product selection actions;
- C2 Event selection actions;
- organiser invitations;
- participant management;
- Project Request/onboarding;
- Store;
- Orders;
- Commerce Core;
- payments;
- commissions;
- production batching;
- artwork/data/template upload;
- communication workflows;
- Event/Catalogue/Product availability changes;
- workflow suitability changes;
- schema changes;
- migrations.

## 25. Risks And Open Questions

Risks:

- without participant-management UI, test data may require manual/admin setup;
- dual-role users may be confused if C1/C2 surfaces are visually too similar;
- a future C2 dashboard may need more readiness metadata than 1P-C currently returns;
- C2 access depends on 1P-B migration being applied in each environment.

Open questions:

- Should `/app/fund` show a context-choice screen for dual-role users, or stay C1-first with an organiser card?
- Should archived assigned Projects be shown in C2 UI at all in the first dashboard?
- Should C2 see DRAFT Projects immediately after assignment?
- Should C2 Project detail show organiser snapshot contact fields, or hide them unless needed?
- Should future participant-management UI live in C1 Project detail or a separate access tab?

## 26. Recommended Implementation Prompt

```text
Proceed with FUND Phase 1 Slice 1P-D implementation: C2 Read-Only Organiser Dashboard UI.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-d-c2-read-only-organiser-dashboard-ui-proposal.md
- isodocs/docs/modules/fund/05-review-and-test/2026-06-25-phase-1-slice-1p-c-r1-c2-read-only-project-api-services-review.md
- current FUND UI conventions
- current IsoStack routing/navigation conventions

Implement read-only C2 organiser dashboard UI only.

Use only these endpoints:
- fund.organiser.projects.list
- fund.organiser.projects.get

Do not use C1 admin Project endpoints for organiser pages.

Recommended routes:
- /app/fund/organiser
- /app/fund/organiser/projects/[id]

Requirements:
- show assigned Project list/card landing page;
- show Project detail/read-only page;
- show Event context and effective close date/source;
- show Project Product snapshot rows;
- show status/lifecycle/readiness context as display-only;
- support loading, empty and error states;
- include clear C1/C2 context navigation for dual-role users without bypassing participant-scoped access;
- keep all C2 surfaces read-only.

Do not implement:
- C2 mutations;
- C1 participant management UI;
- organiser invitations;
- Project Request/onboarding;
- Store, Orders or Commerce Core;
- Event/Catalogue/Product availability changes;
- workflow suitability changes;
- schema changes or migrations;
- db:push;
- seed/reset commands.

Run:
- npm run type-check
- npm run verify
- git diff --check

Create implementation confirmation document:
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-d-c2-read-only-organiser-dashboard-ui-confirmation.md

Do not promote to main after implementation.
```

## 27. Recommendation

Review this plan before implementation.

Recommended next sequence:

```text
1P-D - C2 Read-Only Organiser Dashboard UI
1P-E - C2 Dashboard API/UI Review And Manual Testing
1Q - Event/Catalogue/Product Availability And Workflow Suitability Planning
```
