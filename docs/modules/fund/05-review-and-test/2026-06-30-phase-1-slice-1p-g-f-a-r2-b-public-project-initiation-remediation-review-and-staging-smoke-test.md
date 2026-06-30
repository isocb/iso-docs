# FUND Phase 1 Slice 1P-G-F-A-R2-B - Public Project Initiation Remediation Review And Staging Smoke Test

Date: 2026-06-30

## Verdict

Proceed to live.

Local browser smoke testing was completed by the product owner and the remediation changes were visible in the UI and working as expected.

Staging browser smoke testing did not reveal any major problems. Remaining refinements/remedial observations can be handled as a batched CR rather than blocking live promotion.

## Scope Reviewed

Reviewed the R2-A remediation for:

- public route access for `/fund/project-initiation/[formSlug]`;
- vanilla public form presentation without the generic IsoStack marketing navigation;
- Event-scoped form context from C1-selected `FundProjectIntakeForm.defaultEventId`;
- Project Start and Project Closing Date fields;
- Event date defaulting and boundary validation;
- standalone/non-Event Project date requirement;
- bounded organisation type selection;
- server-side public submission validation;
- C1 form create/edit controls for Default Event and allowed organisation types;
- preservation of the moderation-first public intake boundary.

## Files Reviewed

App files:

- `src/middleware.ts`
- `src/app/fund/project-initiation/[formSlug]/page.tsx`
- `src/app/fund/project-initiation/[formSlug]/confirm/page.tsx`
- `src/app/fund/project-initiation/[formSlug]/submitted/page.tsx`
- `src/app/fund/project-initiation/[formSlug]/expired/page.tsx`
- `src/modules/fund/components/project-intake-public/PublicProjectInitiationForm.tsx`
- `src/modules/fund/components/project-intake/ProjectIntakeFormsPage.tsx`
- `src/modules/fund/components/project-intake/ProjectIntakeFormDetailPage.tsx`
- `src/modules/fund/lib/validation/project-intake.ts`
- `src/modules/fund/services/project-intake.service.ts`

Docs reviewed:

- `docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1p-g-f-a-r2-public-project-initiation-security-event-scope-and-form-ux-remediation-planning.md`
- `docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1p-g-f-a-r2-a-public-project-initiation-route-and-event-scoped-form-remediation-confirmation.md`
- `docs/modules/fund/05-review-and-test/2026-06-30-phase-1-slice-1p-g-f-a-r1-public-project-initiation-staging-security-and-pre-live-review.md`
- `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`
- `docs/00-overview/ui_ux_components/isostack-ux-ui-standard.md`

## Technical Review

Route access:

- `/fund/project-initiation/*` is explicitly public in middleware.
- `/app/fund/project-intake/*` remains protected by the existing authenticated app/admin route model.
- Module-domain redirect handling now also allows the public initiation route.

Public presentation:

- public Project initiation pages were moved out of the generic `(public)` marketing route group;
- the public form is now a branded workflow surface rather than an IsoStack marketing page;
- the route remains suitable for future embed planning because it is not coupled to the app shell.

Event-scoped behaviour:

- Event-scoped forms display linked Event context;
- Project Start defaults from the linked Event start/open date where available;
- Project Closing Date defaults from the linked Event close date where available;
- Project Start cannot be before the linked Event start/open date;
- Project Closing Date cannot be after the linked Event close date;
- Project Closing Date may be earlier than the linked Event close date;
- submissions preserve trusted Event context through `requestedEventId`.

Standalone form behaviour:

- non-Event forms require Project Start;
- non-Event forms require Project Closing Date;
- Project Closing Date must be after Project Start.

Organisation type behaviour:

- C1 form create/edit uses a bounded allowed organisation type selector;
- public form options are filtered from the form definition;
- public submission service validates the submitted organisation type server-side.

## Local Browser Smoke Test

Confirmed by product owner:

- public form remediation is visible locally;
- UI changes are working as expected;
- Event-scoped form context and date fields are evident;
- C1 form controls are visible and usable.

## Staging Smoke Checklist

Staging smoke testing was completed by the product owner. No major blockers were found.

Checked/covered areas:

- unauthenticated `/fund/project-initiation/[formSlug]` loads without redirecting to sign-in;
- public page has no generic IsoStack marketing header/navigation;
- missing/inactive form slug shows a safe unavailable state;
- active Event-scoped form shows Event context;
- Event-scoped dates default from the Event;
- date validation blocks start before Event start/open date;
- date validation blocks close after Event close date;
- standalone form requires Project Start and Project Closing Date;
- C1 `/app/fund/project-intake` remains authenticated/admin-only;
- C1 form create/edit Default Event selector works;
- C1 form allowed organisation type selector works;
- submitted public request enters confirmation-pending/submitted moderation flow as expected;
- no Store, Orders, Commerce, Client user/member, invitation or broader workflow notification behaviour appears.

Remedial observations should be collected through a CR and planned as a batch remediation slice rather than interrupting this live promotion.

## Checks Run

```text
npm run type-check
npm run verify
git diff --check
docs git diff --check
```

Results:

- `npm run type-check`: passed.
- `npm run verify`: passed after rerun outside the sandbox for the known `tsx` IPC pipe restriction.
- `git diff --check`: passed.
- `docs git diff --check`: passed.

## Blockers

No blockers found for live promotion.

## Caveats

- Remaining remedial observations should be captured through a CR and grouped into a batch remediation plan.
- Third-party embed support remains future architecture work; this remediation does not relax iframe/CSP policy globally.
- Event media/imagery and configurable Event type/category option sets remain follow-up items.

## Explicit Out Of Scope Confirmation

This review confirms the remediation did not implement:

- schema changes;
- migrations;
- public embed route or iframe allowlist;
- Event media/image schema;
- configurable Event type/category option sets;
- Client users/members;
- invitations;
- editable notification defaults;
- broader workflow notifications;
- Store, Orders, Commerce, Sales/Reporting;
- production, dispatch or fulfilment;
- SeasonPro integration.

## Recommendation

Promote the R2-A remediation from staging to live.

After live promotion:

- complete a light live smoke check for the public Project initiation route and C1 Project Intake admin;
- capture any minor UI/UX or workflow observations in a CR;
- create a batch remediation plan from that CR rather than treating non-blocking refinements as live blockers.
