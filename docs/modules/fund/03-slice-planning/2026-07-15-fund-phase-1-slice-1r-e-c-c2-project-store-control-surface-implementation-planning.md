# FUND Phase 1 Slice 1R-E-C - C2 Project Store Control Surface Implementation Planning

Date: 2026-07-15
Status: Reviewed and accepted for bounded implementation
Parent: `1R-E - C1 Store Oversight And C2 Project Store Control Alignment`
Depends on: completed `1R-E-A`; completed local `1R-E-B`; completed `1Q-E/1Q-F`, `1R-D`, `C1-C6`, `K1-F/K2`, `R3-D` and Commerce `A1-A7`
Migration baseline: complete 141-migration application history; this slice adds no migration

Roadmap renumbering notice: references in this accepted historical record to `1R-F` as
the public Store/C2 display slice now mean `1R-G`. Current `1R-F` is the later accepted
Project Offer And Artwork Readiness parent. The original wording is retained for audit.

## 1. Purpose

Add the normal C2 Project Store control surface to the existing Client Project detail route.
The surface consumes the typed `1R-E-A` authority contract. It does not create a second Store
lifecycle, duplicate readiness logic in the browser or give C1 routine publication authority.

The Store remains Project-owned. C2 manages its Project and Store inside C1-owned Product,
commercial, presentation-release, payment-readiness and exceptional-intervention boundaries.

## 2. Bounded Outcome

The existing route:

```text
/app/fund/client/projects/[id]
```

gains a Store tab that can:

- show Project and linked Event date boundaries;
- show the server-derived effective Store state, readiness and responsible blockers;
- prepare a missing Store, or refresh an existing Store, when the server permits it;
- show and edit C2-owned Store title, introduction and fundraising objective;
- show eligible Products and manage Project Product selection;
- manage Store Product visibility and ordering without exposing C1 commercial writers;
- show current commission-offer evidence and accept an exact proposed assignment;
- show bounded artwork/presentation status and remediation destinations without inventing
  missing workflow evidence;
- activate, pause or resume the Project where the existing K2/E-A service permits it;
- publish, pause or resume the Store through the E-A effective-state policy; and
- explain scheduled, Project-ended and exceptional C1-intervention states without exposing
  C1 operator notes.

## 3. Authority And Access

All identity and current-time authority is server derived.

| Actor | Read | Normal mutation |
| --- | --- | --- |
| active C2 `VIEWER` | exact Client-owned Project and Store | none |
| active C2 `PROJECT_MANAGER` | exact Client-owned Project and Store | Project/Store actions allowed by E-A |
| active C2 `ADMIN` | exact Client-owned Project and Store | Project/Store actions allowed by E-A |
| C1 role without active matching C2 membership | none through C2 route | none |

The browser may send only resource identity and bounded user-entered values. It must not send
`organizationId`, actor identity, evaluation time, effective state, readiness, blocker,
commercial amount, tax, source media, configuration hash/revision or accepted status.

Cross-tenant and cross-Client identifiers return not-found or the established safe C2 error.
Multiple Client memberships continue to use the existing explicitly selected, server-verified
`clientId` context.

## 4. Store Read Model

`getStore` remains the canonical C2 Store query and must be expanded only where the UI needs
safe evidence. Its response may contain:

- safe Store copy and status;
- Project and Event date evidence already exposed by the Project route;
- selected Store Products with safe display evidence, ordering, visibility and server-derived
  readiness codes;
- eligible Product candidates through the existing eligibility service;
- current accepted/finalized or proposed commission assignment summary, policy/version label,
  rate presentation and acceptance state;
- server-derived effective state, readiness codes, blockers, responsible actor and remediation
  destination; and
- exact server-authorised allowed actions.

It must not contain:

- C1 intervention operator or resolution notes;
- raw configuration/snapshot JSON;
- full configuration hashes;
- internal payment/provider secrets or references;
- cross-Client identities;
- mutable metadata presented as authority; or
- Product commercial/source writers.

## 5. Commission Acceptance

E-C may add the minimum internal C2 service required to accept the exact current proposed
`FundProjectCommissionAssignment`; it adds no commission configuration or calculation.

Acceptance must:

1. resolve the active C2 member and require `PROJECT_MANAGER` or `ADMIN` access;
2. lock the Project and assignment in one serializable transaction;
3. revalidate exact tenant, Client, Project, Store, proposal status, Project close snapshot and
   policy/version ownership;
4. require an explicit bounded confirmation from the C2 UI;
5. set `acceptedAt` from server time and `acceptedById` to the exact `FundClientMember.id`;
6. if this is an accepted replacement, supersede the prior accepted assignment atomically with
   nonblank audited replacement evidence before making the proposal effective;
7. use a separate idempotency key and return stable success on replay; and
8. write redacted transactional audit evidence.

It must not create or edit a policy/version/step, choose a rate, accept on behalf of C2, finalize
terms, calculate commission or expose the control to public purchasers. If no valid proposal is
available, the UI shows a C1-responsible blocker and no acceptance action.

## 6. Project And Event Dates

Project `opensAt` and `closesAt` are the Store trading window. A linked Event is only the outer
envelope.

- C2 Project edits may use narrower explicit dates.
- Event defaults are copied only during Project creation.
- Event edits never cascade into existing Projects.
- Current Project editing continues to reject dates outside the linked Event envelope.
- The Store UI explains the Event envelope and the explicit Project window.
- Passing Project close makes the Store non-trading without a Store-close mutation.

The UI does not derive boundary state from browser time. It renders the server evaluation.

## 7. C2-owned Store Configuration

C2 may edit only:

- Store title;
- introduction;
- fundraising objective;
- eligible Project Product membership;
- Store Product order; and
- Store Product visibility where the server says the Product is eligible/released.

C2 cannot edit Product identity, net/gross price, tax, source media, Catalogue eligibility,
configuration snapshots, release evidence, readiness codes or C1-held presentation copy.

Prepare and refresh remain server recomputations from C1-owned source authority. The browser
never supplies a configuration version or readiness result.

## 8. Effective State And Actions

The UI renders E-A machine codes and allowed actions. It does not reproduce the state machine.

Required states include draft/unprepared, scheduled, open, C2-paused, C1-paused, C1-closed,
Project-ended, completed and archived. C1 intervention explanation shown to C2 is bounded and
public-safe; internal notes remain C1-only.

C2 cannot bypass C1 pause or closure. Resolution or reopen by C1 recalculates state and does not
force publication. Normal Store actions remain:

- prepare/refresh;
- publish when all server gates pass;
- pause; and
- resume when all server gates pass.

Project activate/pause/resume remains a separate Project action. Store state does not silently
rewrite Project dates or lifecycle.

## 9. UI Structure

The Project detail tabs become:

```text
Details | Store | Orders
```

The obsolete Products placeholder is absorbed into Store because selection and Store Product
presentation are one governed workflow. Orders remains a clearly labelled future/read-only
placeholder; no Commerce Order operation is added.

The Store panel provides:

- summary/status and boundary cards;
- blocker list with responsible-party labels and bounded remediation links;
- configuration copy editor;
- selected and eligible Product controls;
- commission-offer summary and acceptance confirmation;
- readiness refresh;
- Project and Store lifecycle actions with confirmation where state changes; and
- loading, empty, not-prepared, stale, error and read-only states.

All controls are keyboard reachable, labelled, focus-safe and responsive. Mutations disable
duplicate submission, use idempotency where applicable, invalidate the exact Project/Store
queries and re-render server authority.

## 10. Files And Implementation Boundary

Expected application changes are bounded to:

```text
src/modules/fund/components/client-dashboard/ClientDashboardShell.tsx
src/modules/fund/components/client-dashboard/ClientProjectStorePanel.tsx
src/modules/fund/lib/client-project-store.ts
src/modules/fund/lib/client-project-store.test.ts
src/modules/fund/lib/validation/client-dashboard.ts
src/modules/fund/routers/client-dashboard.router.ts
src/modules/fund/services/client-dashboard.service.ts
scripts/verify-fund-1r-e-c-client-store-surface.ts
scripts/run-fund-1r-e-c-client-store-tests.ts
```

Supporting fixes are permitted only where required to remove browser-supplied evaluation time
from the C2 contract or to return bounded safe evidence from existing E-A services. No Prisma
schema or migration is authorised.

## 11. Explicit Exclusions

E-C adds no:

- public Store, checkout or return route;
- C1 portfolio or intervention behavior beyond completed E-B;
- real Stripe action;
- Product/Catalogue commercial editor;
- Application Template or collective artwork implementation;
- upload, malware scanning or artwork intake;
- Order operation, confirmation, code or email;
- production, fulfilment or dispatch behavior;
- commission calculation, accrual, statement or settlement;
- Store-specific date fields;
- automatic Event-to-Project date cascade; or
- unrelated LMSPro change.

## 12. Validation

Use only `TEST_DATABASE_URL` after proving it differs from `DATABASE_URL`. Require:

- unchanged complete 141-migration baseline;
- static proof of route/authority/redaction boundaries;
- C2 `VIEWER`, `PROJECT_MANAGER`, `ADMIN`, inactive member and C1-only actor coverage;
- cross-tenant, cross-Client and wrong-Project refusal;
- Store absent/prepare/refresh and stale-response behavior;
- standalone and Event-linked Project dates, scheduled/open/ended boundary instants;
- Project activate/pause/resume and Store publish/pause/resume permissions;
- C1 pause/closure visibility without notes and C2 bypass refusal;
- copy, Product selection, visibility and ordering constraints;
- proposed/accepted/replacement commission acceptance, idempotency, concurrency and rollback;
- every readiness/blocker/action presentation and responsible-party mapping;
- no browser evaluation-time or commercial/readiness authority;
- E-A/E-B, 1R-D, K1-F/K2, R3-D, A1-A7 and C1-C6 regressions;
- responsive and accessibility static/component checks;
- exact-tree TypeScript check and production build; and
- zero disposable test residue.

No shared development, staging or production database is modified by implementation testing.

## 13. Human UI Test Schedule Requirement

The E-C review/test record must include a staged human schedule rather than claiming unrun
browser proof:

1. local dev role and workflow smoke after the 141st migration exists on the selected dev DB;
2. local desktop/mobile accessibility and boundary-state pass;
3. controlled dev/origin-dev promotion and repeat smoke;
4. staging C2 role/workflow pass after the normal controlled promotion procedure; and
5. cross-role C1-intervention/C2-observation regression before public Store work begins.

It must list prerequisites, test personas/data, scenarios, expected results, evidence to capture,
stop conditions and any remaining manual status.

## 14. Review And Acceptance Outcome

Review result: accepted for bounded implementation on 2026-07-15.

The review confirmed that:

- the parent assigns normal Project Store authority to exact C2 Project members;
- E-A already supplies the canonical effective-state, readiness and action contract;
- the current C2 router/service already contains the bounded internal Store mutations but no UI;
- browser-supplied evaluation time must be removed before exposing those actions;
- the C2 Store response can be expanded without schema change while preserving C1-note and
  commercial-authority redaction;
- C5 schema can record exact C2 acceptance, but E-C must implement the missing transactional
  acceptance service rather than fabricate accepted state in the UI;
- Project dates remain the sole trading window and Event dates remain a non-cascading envelope;
- Product selection and Store Product ordering/visibility use existing governed services;
- no business decision remains unresolved inside this bounded surface; and
- UI browser proof must be scheduled honestly and not represented as completed automated proof.

No E-C implementation existed at acceptance. Acceptance does not authorise `1R-F` or another
slice.

## 15. Bounded Implementation Direction

Implement only this accepted E-C plan on the current local E-A/E-B application baseline. Add no
schema or migration. Keep all C2 identity, time, authority, readiness and lifecycle decisions on
the server; add the bounded Store tab and transactional commission acceptance; validate only on
the disposable database; then create separate implementation-confirmation and review/test records,
including the human UI schedule, and update all controlling roadmaps. Stop before `1R-F`.
