# FUND Phase 1 Slice 1P-R1 - C1 Admin Immediate Remediation

Date: 2026-06-25

Status: Planning only

Target app branch:

```text
feature/fund-phase-1-c2-project-access
```

Source documents:

- `00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`
- `01-cr-inputs/change-request-cmqt61xmf000612xt5ifl1mdn-2026-06-25.md`
- `02-triage/2026-06-25-fund-c1-admin-remediation-and-architecture-triage.md`

## 1. Slice Goal

Implement the immediate C1 admin remediation accepted from the first post-release CR batch.

Primary goal:

```text
Fix blockers or near-blockers in the released C1 admin foundation before C2 dashboard implementation begins.
```

This is a remediation slice, not a new feature slice.

## 2. Implementation Boundary

Allowed:

- Project/Event date constraint remediation for Issue #46.
- Issue Manager module filter/server-render remediation for Issue #50.
- Small C1 admin UX polish only if it stays contained:
  - Issue #47 Project Product activation gate visibility.
  - Issue #44 Products breadcrumb navigation.
  - Issue #45 sidebar icon specificity and UI guidance.

Not allowed:

- C2 dashboard implementation.
- C2 organiser invitations.
- Project Request/onboarding.
- Store schema.
- Order schema.
- Commerce Core.
- payments.
- commissions.
- production batching.
- Event-Catalogue availability schema.
- Product workflow suitability schema.
- lifecycle engine.
- AI workflows.

Do not edit Prisma schema unless a genuine bug requires it and is explained first.

Do not create migrations.

Do not run:

```text
db:push
seed/reset commands
```

## 3. Issues In Scope

### Issue #46 - Project/Event Close-Date Constraint

Required behaviour:

- Standalone Projects may use any valid `closesAt` after `opensAt`.
- Event-linked Projects may set `closesAt` earlier than or equal to linked `FundEvent.closesAt`.
- Event-linked Projects must never set `closesAt` later than linked `FundEvent.closesAt`.
- If linked Project `closesAt` is blank, linked Event `closesAt` may be treated as inherited/effective for readiness and display.
- Event `closesAt` is not a forced copied Project close date.

Areas to inspect:

- Project create modal.
- Project detail/edit form.
- Project Event selector/helper text.
- Project readiness/effective close-date display.
- Project service create/update validation.
- Project activation readiness validation.

Server-side validation remains authoritative.

### Issue #50 - Issue Manager Module Filtering / Server Render Error

Required behaviour:

- P1/platform owner can filter issue manager records by `fund`.
- FUND issues created during testing are discoverable.
- Issue create/edit module field and issue list module filter use a consistent module id/source.
- Server render errors are replaced by stable behaviour.

Areas to inspect:

- Issue manager list route/page.
- Issue manager filters.
- Issue create/edit module fields.
- Module catalogue/module option sources.
- Role/product/module scoping used by P1.

If a wider platform issue is discovered, keep the fix scoped to stable Issue Manager behaviour and document follow-up architecture questions separately.

## 4. Optional Small Polish

Include only if still small and low-risk.

### Issue #47 - Project Product Activation Gate Visibility

Potential remediation:

- Make missing active Project Product prominent in Project Overview/readiness.
- Add a clear path to the Products tab.
- Show active Project Product count.
- Do not duplicate the full Project Product manager on Overview.

### Issue #44 - Product Breadcrumb Navigation

Potential remediation:

- Add breadcrumb navigation to `/app/fund/products`.
- Match existing IsoStack page breadcrumb conventions.

### Issue #45 - Sidebar Icons Repeated

Potential remediation:

- Replace repeated generic Home icons with content-appropriate icons.
- Update UI guidance to discourage repeated generic sidebar icons.

## 5. Files Likely To Change

Likely Project/Event files:

- `src/modules/fund/components/projects/ProjectCreateModal.tsx`
- `src/modules/fund/components/projects/ProjectDetailPage.tsx`
- `src/modules/fund/components/projects/ProjectEventSelector.tsx`
- `src/modules/fund/services/projects.service.ts`
- `src/modules/fund/lib/validation/projects.ts`

Likely Issue Manager files:

- issue manager route/page files under `src/app/(app)/app/...`
- issue manager router/service files under `src/server` or `src/modules`
- module catalogue/filter helper files if the filter source is inconsistent

Likely polish files:

- `src/app/(app)/app/fund/products/page.tsx`
- `src/core/config/module-navigation.ts`
- relevant UI guidance docs in `isodocs` or `isostack-bedrock/docs`

The implementation pass must inspect actual paths before editing.

## 6. Confirmation Document Required

After implementation, create:

```text
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-r1-c1-admin-immediate-remediation-confirmation.md
```

The confirmation must include:

1. Slice name and date.
2. Issues addressed.
3. Files changed.
4. Behaviour changed.
5. Confirmation that Prisma schema was not changed, or explanation if it was.
6. Confirmation that no migrations, `db:push`, seed or reset commands were used.
7. Checks run and results.
8. Manual verification checklist.
9. Known risks/follow-ups.
10. Recommended next slice.

## 7. Checks To Run

Run:

```text
npm run type-check
npm run verify
```

If verify fails because of known local sandbox/tsx IPC limitations, rerun using the established unsandboxed workflow and report that clearly.

## 8. Manual Verification Checklist

Issue #46:

- Create standalone Project with valid close date after open date.
- Create standalone Project without Event and confirm no Event date constraint is applied.
- Create Event-linked Project with blank Project close date and Event close date present.
- Create Event-linked Project with Project close date before Event close date.
- Attempt Event-linked Project close date after Event close date and confirm rejection.
- Update DRAFT linked Project to an invalid close date and confirm rejection.
- Confirm advisory/effective close-date text remains accurate.

Issue #50:

- As P1/platform owner, open Issue Manager.
- Confirm module filter includes FUND / `fund`.
- Confirm filtering by FUND returns FUND issues where they exist.
- Confirm empty states are stable when no matching issues exist.
- Confirm no Server Components render error occurs.

Optional polish:

- Confirm Project Overview clearly surfaces missing active Project Product gate.
- Confirm Products page has breadcrumb navigation.
- Confirm FUND sidebar icons are not repeated generic Home icons.

## 9. Next Slice

After implementation:

```text
Slice 1P-R2 - C1 Admin Remediation Review And Staging Readiness
```

The review should produce:

```text
isodocs/docs/modules/fund/05-review-and-test/2026-06-25-phase-1-slice-1p-r2-c1-admin-remediation-review.md
```

Then update:

```text
isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md
```

## 10. Recommended Implementation Prompt

```text
Proceed with FUND Phase 1 Slice 1P-R1 implementation: C1 Admin Immediate Remediation.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md
- isodocs/docs/modules/fund/01-cr-inputs/change-request-cmqt61xmf000612xt5ifl1mdn-2026-06-25.md
- isodocs/docs/modules/fund/02-triage/2026-06-25-fund-c1-admin-remediation-and-architecture-triage.md
- isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-r1-c1-admin-immediate-remediation.md

Implement only:
1. Issue #46 Project/Event close-date constraint remediation.
2. Issue #50 Issue Manager module filtering/server render remediation.
3. Issues #47/#44/#45 only if they remain small and contained.

Do not start C2 dashboard, Commerce Core, Store, Order, payments, commissions, production batching, organiser onboarding, Event-Catalogue availability schema or Product workflow suitability schema.

Do not run db:push.
Do not run seed/reset commands.
Do not create migrations unless a genuine schema bug is discovered and explained first.

Run:
- npm run type-check
- npm run verify

Create implementation confirmation:
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-r1-c1-admin-immediate-remediation-confirmation.md
```

