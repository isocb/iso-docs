# PLAT-SUPPORT-01 Client Privacy And Lifecycle Authority Gate Planning

Date: 2026-08-10

Status: **DELIVERED IN EXACT `cde4eaff` AND ALIGNED THROUGH MAIN; LOCAL/STAGING HUMAN
GATES, ALL PROTECTED SCANS AND PUBLIC HEALTH CHECKS PASS; PRODUCTION RENDER IDENTITY
PENDING FOR CLOSURE**

Accepted triage:

[`Support Ticketing client-readiness triage`](../02-triage/2026-08-10-isostack-platform-support-ticketing-client-readiness-triage.md)

Source CR:

[`Support Ticketing client readiness and communications`](../01-cr-inputs/2026-08-05-isostack-core-platform-support-ticketing-client-readiness-and-communications-cr.md)

## 1. Objective

Make the existing Support Ticket capability safe for a later client-enablement decision by
enforcing tenant visibility, requester visibility, P1-only internal notes and lifecycle
authority at the server boundary.

This slice does not enable Support for clients. It creates the mandatory privacy and
authorisation prerequisite for the later routing and P1 operations slices.

## 2. Accepted Authority Contract

| Actor | Read contract | Mutation contract |
| --- | --- | --- |
| P1 support operator | Cross-tenant queue and detail under explicit P1 authority | Full supported lifecycle/priority and P1-only internal/public comments |
| Tenant `OWNER`/`ADMIN` | Every ticket owned by that tenant | Public reply and explicit Close/Reopen only |
| Tenant `MEMBER` | Only tickets for which the user is the requester | Public reply and explicit Close/Reopen on that requester ticket only |
| Other tenant/public | No discovery, detail, discussion, requester or configuration access | None |

Close and Reopen are named client actions with exact server transitions. They are not a
general status update schema. P1 retains the full lifecycle selector.

## 3. Implementation Boundary

In scope:

- centralise the support read predicate used by list, detail and mutation procedures;
- apply tenant plus Core-authority/requester filtering before returning records;
- shape every client response so internal notes are removed before serialisation;
- reject client attempts to submit or relabel an internal note;
- split or strictly discriminate P1 lifecycle/priority update from client Close/Reopen;
- remove the general status dropdown from the C1 detail modal and retain read-only status,
  reply and bounded Close/Reopen presentation;
- ensure P1 continues to receive full lifecycle and internal-note controls;
- protect or remove `platformEmails.getForTicket` from non-P1 callers;
- retain real actor, target tenant and prior/new lifecycle values in audit; and
- add negative direct-procedure tests, not only browser tests.

Likely application areas:

```text
src/server/core/routers/support.router.ts
src/server/core/routers/platformEmails.router.ts
src/app/(app)/support/page.tsx
src/app/(platform)/platform/_components/SupportTicketsTab.tsx
src/server/core/routers/**/__tests__ or the established router-test location
```

## 4. Data And Compatibility

No schema or historic data rewrite is planned initially. Existing JSON discussion records
remain readable, but all parsing is fail-closed: malformed/unknown entries must never be
treated as public merely because `isInternal` is absent or invalid.

If safe server shaping, validated comment creation and concurrency-safe persistence cannot
be proved against the existing JSON representation, stop and plan a typed comment migration.
Do not introduce that migration silently.

Existing tickets remain organisation-owned. No ticket, requester, discussion or status is
reassigned by this slice.

## 5. Automated Acceptance

Prove that:

1. tenant A cannot list or probe tenant B tickets by identifier;
2. a tenant Owner/Admin can list and open its tenant tickets;
3. a Member cannot list or open another same-tenant requester's ticket;
4. the requester Member can open and reply to its own ticket;
5. no client response contains an internal note, including malformed legacy discussion data;
6. a client cannot submit `isInternal=true` or call the P1 comment/update operation;
7. a client cannot select `in-progress`, `waiting-response`, `resolved`, priority or other
   P1 fields by direct procedure invocation;
8. Close/Reopen performs only its named accepted transition and is audited;
9. P1 retains cross-tenant list/detail, full lifecycle and internal-note behaviour; and
10. routing configuration cannot be queried by an unauthorised tenant caller.

Run focused tests, full relevant tests, type-check, changed lint, repository verification,
production build and Security Scan before any shared promotion proposal.

## 6. Human Local Gate

Use disposable/non-sensitive tickets:

1. as C1 Owner/Admin, confirm tenant tickets are visible and status is read-only;
2. confirm reply and named Close/Reopen operate and reopen is stable;
3. as C2/Member requester, confirm only the requester's ticket is visible;
4. as another same-tenant Member, confirm that ticket cannot be discovered;
5. as P1, add one internal note and one public reply;
6. confirm the client sees only the public reply, including after refresh/direct navigation;
7. confirm P1 retains the full lifecycle selector and internal-note presentation; and
8. repeat a cross-tenant identifier probe and confirm a neutral refusal.

## 7. Non-Goals, Recovery And Stop

Non-goals:

- no notification routing changes;
- no P1 count, aging, search or classification changes;
- no Platform Notice;
- no attachment work; and
- no general Core-role redesign.

Application revert is the recovery boundary because no schema change is planned. Stop on a
need for live data repair, typed-comment migration, altered Core authority or weakened
tenant isolation. `PLAT-SUPPORT-02` does not begin until this slice passes its required
technical and human gate.

## 8. Implementation Disposition — 2026-08-10

Local implementation is recorded at the
[`PLAT-SUPPORT-01 implementation confirmation`](../04-implementation-confirmations/2026-08-10-isostack-platform-plat-support-01-client-privacy-and-lifecycle-authority-implementation.md).
An additive nullable requester link was accepted during implementation because requester-only
Member visibility and P1-on-behalf-of notification cannot safely share `createdById`. It
retains historic data and does not rewrite discussion JSON. All three authorised Support
slices now culminate in the
[`combined local smoke gate`](../05-review-and-test/2026-08-10-isostack-platform-support-ticketing-combined-local-review-and-smoke-gate.md).
