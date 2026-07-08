# FUND Phase 1 Slice 1P-G-F-A-R2-A - Public Project Initiation Route And Event-Scoped Form Remediation Confirmation

Date: 2026-06-30

## Slice Goal

Remediate the public Project initiation form before live promotion by making the public route genuinely public, removing the generic IsoStack marketing shell, reinforcing Event-scoped form behaviour, and aligning the first visible form UX with the FUND intake foundation.

## Implementation Summary

Implemented the R2-A remediation as a UI/service boundary fix only:

- `/fund/project-initiation/[formSlug]` and confirmation/status child routes are now public middleware routes.
- Public Project initiation pages were moved out of the generic `(public)` marketing layout so the form renders as a vanilla branded workflow page.
- C1 `/app/fund/project-intake/*` routes remain protected by the existing app/admin route model.
- Event-scoped forms now display linked Event context and date bounds.
- Public submissions now require Project Start and Project Closing Date.
- Event-scoped Project dates default from the linked Event and are constrained to the Event window.
- General/non-Event forms require their own Project Start and Project Closing Date.
- Public submission services write both requested start and requested close dates into the moderation record.
- C1 form create/edit now uses a bounded organisation type selector instead of free text for allowed organisation types.
- Public organisation type selection is filtered from the form definition and validated server-side.

## App Files Changed

- `src/middleware.ts`
- `src/app/fund/project-initiation/[formSlug]/page.tsx`
- `src/app/fund/project-initiation/[formSlug]/confirm/page.tsx`
- `src/app/fund/project-initiation/[formSlug]/submitted/page.tsx`
- `src/app/fund/project-initiation/[formSlug]/expired/page.tsx`
- `src/app/(public)/fund/project-initiation/[formSlug]/page.tsx` moved
- `src/app/(public)/fund/project-initiation/[formSlug]/confirm/page.tsx` moved
- `src/app/(public)/fund/project-initiation/[formSlug]/submitted/page.tsx` moved
- `src/app/(public)/fund/project-initiation/[formSlug]/expired/page.tsx` moved
- `src/modules/fund/components/project-intake-public/PublicProjectInitiationForm.tsx`
- `src/modules/fund/components/project-intake/ProjectIntakeFormsPage.tsx`
- `src/modules/fund/components/project-intake/ProjectIntakeFormDetailPage.tsx`
- `src/modules/fund/lib/validation/project-intake.ts`
- `src/modules/fund/services/project-intake.service.ts`

## Route Access And Security

The public initiation route is now allowed by middleware:

```text
/fund/project-initiation
```

The protected C1 route remains separate:

```text
/app/fund/project-intake
```

This slice does not relax iframe/CSP framing rules globally. Third-party embedding remains a supported future architecture direction, but should use a dedicated embed route or explicit origin policy rather than weakening the standalone public form route.

## Event-Scoped Form Behaviour

When a Project Intake form has a linked default Event:

- the public form displays the Event name and Event window;
- Project Start defaults to the Event start/open date where available;
- Project Closing Date defaults to the Event close date where available;
- Project Start cannot be before the linked Event start/open date;
- Project Closing Date cannot be after the linked Event close date;
- Project Closing Date can be earlier than the Event close date;
- the submission carries the trusted Event context through `requestedEventId`.

When a Project Intake form is not Event-scoped:

- Project Start is required;
- Project Closing Date is required;
- Project Closing Date must be after Project Start.

## Organisation Type Behaviour

C1 form create/edit now uses bounded allowed organisation types:

- School
- Playgroup
- Club
- PTA / Friends group
- Charity / community group
- Other

The public form filters the visible organisation type choices using the C1 form definition, and the public submission service validates the submitted type server-side.

## Public Form UX

The public form now uses the app-aligned Mantine `DateTimePicker` pattern for Project date fields.

The form no longer sits under the generic IsoStack marketing header/nav. Branding continues to use the accepted fallback chain:

```text
tenant branding -> module branding -> platform fallback
```

## Explicit Out Of Scope

This slice did not implement:

- schema changes;
- migrations;
- public embed route or iframe allowlist;
- Event media/image schema;
- configurable Event type/category option sets;
- Client users/members;
- invitations;
- editable notification defaults;
- broader email notifications beyond the existing confirmation/authentication exception;
- Store, Orders, Commerce, Sales/Reporting;
- production, dispatch or fulfilment;
- SeasonPro integration.

## Checks Run

```text
npm run type-check
git diff --check
npm run verify
```

Results:

- `npm run type-check`: passed.
- `git diff --check`: passed.
- `npm run verify`: initially hit the known sandbox `tsx` IPC pipe restriction, then passed when rerun outside the sandbox.

## Notes

The route relocation required clearing stale generated `.next/types` entries for the old `(public)` route location before `tsc` reflected the current app route tree.

## Risks And Follow-Ups

- Browser smoke testing should confirm the route is reachable without authentication on staging.
- Confirm public page has no IsoStack marketing nav/header on staging.
- Confirm Event-scoped forms display and enforce Event date bounds.
- Confirm C1 form create/edit allowed organisation type selector works with existing records that may have stored label-style values.
- Future embed support should be planned as a dedicated public embed route/CSP policy.
- Event media/image and Event type/category configuration remain follow-up planning items.

## Recommended Next Slice

```text
1P-G-F-A-R2-B - Public Project Initiation Remediation Review And Staging Smoke Test
```

Review route access, Event-scoped form behaviour, public form UX, submission moderation record output and pre-live readiness.
