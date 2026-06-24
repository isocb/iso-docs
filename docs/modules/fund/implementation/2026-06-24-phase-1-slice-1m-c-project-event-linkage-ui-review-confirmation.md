# Phase 1 Slice 1M-C - Project/Event Linkage UI Review

Date: 2026-06-24

## Review Summary

Reviewed the implemented Project/Event linkage UI from Slice 1M-B against the 1M-B proposal and confirmation notes.

Review scope:

- Project create Event selector.
- Project Overview Event linkage section.
- DRAFT-only link/change/unlink behaviour.
- Effective close-date readiness display.
- Event date helper text and client-side date validation.
- Query invalidation.
- Error notification mapping.
- Tenant/security boundary.
- Regression surface for Project, Event and Product/Catalogue admin routes.

No new features were implemented during this review slice.

## Manual Tests And Review Completed

### Project Create

Verified by code review:

- Event selector is present in `ProjectCreateModal`.
- Event selector uses `fund.events.list`.
- Selector filters visible options to DRAFT and ACTIVE Events.
- CLOSED and ARCHIVED Events are not eligible for new selection.
- Standalone Project creation remains available by leaving Event blank.
- Selected Event id is sent as `eventId` to `fund.projects.create`.
- Event close date helper text appears when an Event is selected.
- Project close date can remain blank when selected Event has `closesAt`.
- Client-side validation prevents Project close date later than selected Event close date.
- Event dates are not copied into Project date fields.

Limit:

- Full create/save browser testing requires an authenticated tenant session and suitable fixture Events.

### Project Detail/Edit

Verified by code review:

- Existing linked Event is displayed in the Project Overview tab.
- Standalone Project state is displayed when no Event is linked.
- DRAFT Project can link/change/unlink Event through the Project details save flow.
- Non-DRAFT Projects show Event linkage read-only.
- CLOSED or ARCHIVED linked Events remain visible as historical context through the current linked Event data.
- General Save calls `fund.projects.update` and does not mutate Project status.
- Event/date helper text remains attached to the current selected Event state.
- Client-side validation covers linked Event opensAt, closesAt and productionDeadline constraints where fields exist in the Project detail form.

Limit:

- Full link/change/unlink browser testing requires authenticated access and fixture Projects in DRAFT and non-DRAFT states.

### Activation/Readiness

Verified by code review:

- Standalone Projects still show Project close date as required for activation readiness.
- Linked Projects can satisfy close-date readiness through Project `closesAt` or linked Event `closesAt`.
- Missing Project and Event close dates show a missing effective close-date warning.
- Readiness uses the Project detail response and refreshes after Project detail invalidation.
- Activation still calls the existing `fund.projects.activate` status action.
- Server activation validation remains authoritative.

### Tenant/Security

Verified by code review:

- Event selector uses `fund.events.list`, which is tenant-scoped server-side.
- Project create/update submit only `eventId`; server-side Project/Event same-tenant validation remains authoritative.
- No cross-tenant Event query or selector bypass was introduced.
- No C2 organiser dashboard, organiser invitation, Project Request/onboarding or Project ownership/access change was introduced.

### Regression

Route smoke checks were run against a local Next.js dev server on port `3022`.

The following protected routes returned expected unauthenticated redirects to sign-in:

- `/app/fund/projects`
- `/app/fund/events`
- `/app/fund/products`

No missing table, route compile or immediate runtime route error was observed in the server log.

## Defects Found

No product defects found in this review pass.

No code fixes were made during Slice 1M-C.

## Checks Run

- `npm run type-check` - passed.
- `npm run verify` - initially blocked by sandbox `tsx` IPC permissions, rerun outside the sandbox with approval and passed.
- `git diff --check` in `isostack-bedrock` - passed.
- `git diff --check` in `isodocs` - passed.

## Explicit Non-Actions

Confirmed no work was done in this review slice for:

- Prisma schema changes.
- Migrations.
- `db:push`.
- Seed/reset commands.
- Router changes.
- Service changes.
- Zod schema changes.
- New tRPC endpoints.
- Stores.
- Orders.
- Commerce.
- Payments.
- Commissions.
- Production batching.
- SeasonPro integration.
- Marketplace exposure.
- Media/asset workflows.
- Lifecycle engine.
- Organiser identity/account linking.
- Project Request/onboarding.
- C2 organiser dashboard.
- Organiser invitations.
- Project ownership/access changes.
- AI workflows.

## C1/C2 Boundary Confirmation

The implemented UI remains a C1 tenant/admin surface.

- C1/admin users can select Events for Projects through the existing Project admin UI.
- Events remain C1 tenant-owned and tenant-scoped.
- C2 organiser dashboard behaviour is not implemented.
- Organiser invitation, Project Request/onboarding and Project ownership/access flows remain future slices.

## Remaining Risks And Follow-Ups

- Complete authenticated browser testing with real or fixture C1 tenant data.
- Browser-test selector usability with many Events.
- Browser-test stale Event status scenarios, especially an Event becoming CLOSED or ARCHIVED while a Project edit page is open.
- Consider whether a future Project create child page is preferable if the create modal becomes too dense.
- Keep Commerce Core planning outside FUND, as captured in open questions.

## Recommendation

Proceed.

Slice 1M-B is review-clean at code/static-route level. The next practical step is authenticated browser testing or committing the current 1M-A/1M-B/1M-C batch before starting the next architectural slice.

Recommended next slice:

```text
Phase 1 Slice 1N - C1 FUND Admin Foundation Review / Authenticated Browser Testing
```

