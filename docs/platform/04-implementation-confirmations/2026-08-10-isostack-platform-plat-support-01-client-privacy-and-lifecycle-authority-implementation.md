# PLAT-SUPPORT-01 Client Privacy And Lifecycle Authority Implementation

Date: 2026-08-10

Status: **DELIVERED IN EXACT `cde4eaff` AND ALIGNED THROUGH MAIN; LOCAL/STAGING HUMAN
GATES, ALL PROTECTED SCANS AND PUBLIC HEALTH CHECKS PASS; PRODUCTION RENDER IDENTITY
PENDING FOR CLOSURE**

Plan:

[`PLAT-SUPPORT-01 planning`](../03-slice-planning/2026-08-10-isostack-platform-plat-support-01-client-privacy-and-lifecycle-authority-gate-planning.md)

Combined review/gate:

[`Support Ticketing combined local review and smoke gate`](../05-review-and-test/2026-08-10-isostack-platform-support-ticketing-combined-local-review-and-smoke-gate.md)

Application boundary:

```text
branch                 dev
base commit            60ac76c17dea54db77097a4c3232f4874f9abe3f
implementation state   uncommitted local working tree
shared environments    unchanged
```

The table records the original implementation boundary. After the corrective 03A/03B
cycle and 24/24 local human pass, this slice was included in exact Support commit
`cde4eaff1e14b2f02ba0953fe8693e7feb02bb61`, now aligned through dev/staging with both
protected Security Scans green. The separate staging gate controls deployment acceptance.

## 1. Delivered Outcome

Support-ticket authority is now enforced at the server response and mutation boundary:

- P1 retains explicit cross-tenant queue/detail, full lifecycle, classification and
  internal-note authority;
- tenant Owner/Admin sees tickets owned by that tenant;
- an ordinary Member sees only a ticket for which that user is the requester, with a safe
  fallback for an unmigrated same-user legacy ticket;
- cross-tenant and same-tenant other-requester identifier probes are refused;
- client responses are shaped before serialisation and never contain internal notes;
- malformed/unknown legacy discussion entries fail closed instead of being presumed public;
- client callers cannot create an internal note or call the P1 triage mutation;
- C1 lifecycle status is read-only and Close/Reopen use a separately validated transition;
- all comment appends use an optimistic updated-at check/retry to avoid a silent lost reply;
  and
- mutation audit evidence retains real actor, ticket tenant and material before/after facts.

The C1 interface labels the list according to authority (`Organisation Tickets` for
Owner/Admin and `My Tickets` for Member), hides client priority editing and exposes only the
accepted reply and bounded lifecycle actions.

## 2. Requester Data Refinement

An explicit nullable `requesterId` was required to satisfy both this privacy boundary and
`PLAT-SUPPORT-02` P1-on-behalf-of notification semantics. This is an accepted additive
refinement to the plan's initial no-schema presumption:

- old tickets are retained;
- only a ticket whose creator currently belongs to the ticket organisation is backfilled to
  that creator;
- a P1-created ticket can retain the real P1 actor while separately identifying a client
  requester; and
- no unmatched historic ticket is assigned an invented requester.

The existing JSON discussion remains in place. No history rewrite or typed-comment table was
required.

## 3. Principal Implementation

- `src/server/core/services/support-ticket-policy.ts` — canonical visibility, category,
  lifecycle, fail-closed discussion and age policy;
- `src/server/core/routers/support.router.ts` — shared server boundary, requester-aware
  creation, separate P1/client mutations, response shaping and auditable concurrency-safe
  discussion persistence;
- `src/app/(app)/support/page.tsx` — truthful C1 authority presentation; and
- `src/app/(platform)/platform/_components/SupportTicketsTab.tsx` — retained P1 lifecycle
  and internal-note controls.

The additive requester fields are carried by migration
`20260810150000_platform_support_ticket_client_readiness`.

## 4. Verification And Recovery

Focused policy/router tests cover requester visibility, cross-boundary refusal, client
mutation refusal, internal-note response shaping, P1 retention, exact Close/Reopen and
fail-closed discussion parsing. Full automated, TypeScript, repository verification,
production build and changed-production-file lint gates pass at the combined record.

Recovery is application rollback plus forward-compatible retention of the nullable requester
columns. No destructive down migration is required or authorised. The combined local and
staging human privacy/authority gates pass; exact production identity remains controlled by
the shared Support closure record.
