# FUND Phase 1 Slices 1R-E-B Through 1R-E-D Consolidated Staging Human Smoke Test Schedule

Date: 2026-07-23

Status: Ready for controlled staging execution; results not yet claimed

Environment: Staging only

Application candidate: `99164ddd` (`d14a652f` runtime plus test-only LMSPro assurance)

## 1. Purpose

Provide one definitive, ordered human smoke schedule for the FUND Store-management work
implemented across:

- `1R-E-B - C1 Store Portfolio Oversight And Exceptional Intervention Surface`;
- `1R-E-C - C2 Project Store Control Surface`; and
- `1R-E-D - Default Project Store Instantiation And Eligible Product Reconciliation`.

The individual review/test records remain authoritative for each slice's automated and
scope evidence:

- `docs/modules/fund/05-review-and-test/2026-07-15-phase-1-slice-1r-e-b-r1-c1-store-portfolio-oversight-exceptional-intervention-surface-review-and-test.md`;
- `docs/modules/fund/05-review-and-test/2026-07-15-phase-1-slice-1r-e-c-r1-c2-project-store-control-surface-review-and-test.md`; and
- `docs/modules/fund/05-review-and-test/2026-07-21-phase-1-slice-1r-e-d-r1-default-project-store-instantiation-eligible-product-reconciliation-review-and-test.md`.

This consolidated schedule avoids duplicate fixture setup and ensures one workflow proves
the connected C1, C2, Project, Store, Product-selection, readiness and intervention
contracts. It does not replace or weaken any source acceptance criterion.

## 2. Boundary

This is human staging verification, not implementation authority.

It must not:

- change application code, schema or migrations;
- run `prisma db push`, seed or direct database repair;
- use production data, production R2, production Stripe or live services;
- make a real payment or purchaser checkout;
- use hand-created Store rows to bypass the Project workflow;
- grant C1 routine Project Store preparation/publication authority;
- claim public Store, artwork/template, Order, production or fulfilment completion; or
- authorise `main`, live deployment or live database migration.

Any failure is recorded against the owning source review and stops the affected phase. It
does not authorise an operator to repair rows manually.

## 3. Required Test Identities And Safe Fixtures

Prepare through supported staging UI/workflows:

| Fixture | Requirement |
| --- | --- |
| C1 administrator | Active FUND C1 OWNER or ADMIN |
| C2 manager | Active `PROJECT_MANAGER` or `ADMIN` for the test Client |
| C2 viewer | Active VIEWER for the same Client |
| Isolation identity | User/Client in another tenant or an unauthorised Client |
| Client | Existing staging FUND Client with no personal production data |
| Event | One staging Event with a valid Catalogue/default eligibility route |
| Standalone Project | Created during this schedule |
| Event-linked Project | Created during this schedule |
| Products | At least three eligible Products with distinguishable titles; one additional Product that can safely become newly eligible |
| Commercial readiness | Staging-only seller/price/tax/configuration evidence sufficient to exercise readiness without a real charge |

Use synthetic names such as `SMOKE-1RE-20260723-*`. Record opaque Project/Store IDs in the
result table, but do not place organiser emails, private notes, full configuration hashes,
raw snapshots, credentials or purchaser data in documentation/screenshots.

## 4. Preflight

Complete before creating a Project:

1. Confirm Render shows the staging service at candidate `99164ddd`, or prove the served
   runtime contains accepted ancestors `c45a41d9` (E-D) and `d14a652f` (current runtime).
2. Confirm `/api/health` is HTTP 200 with database `connected` and RLS `11/11`.
3. Confirm the environment is staging by hostname, tenant and visible synthetic data.
4. Confirm the tester can use the four identities above without changing production roles.
5. Confirm the Event/Catalogue has the expected eligible Product set and record its count.
6. Confirm no test requires a real Stripe charge, live Store or public purchaser action.
7. Open the individual E-B/E-C/E-D review records alongside this schedule.

Stop immediately on a commit/environment mismatch, unhealthy database, tenant ambiguity or
need for direct database intervention.

## 5. Consolidated Smoke Sequence

Run in order. Do not skip a failed prerequisite merely because a later screen is reachable.

### Phase A - Atomic Project, Store And Default Product Creation

1. **C1 standalone creation**
   - As C1, create a Standalone Project for the test Client using the retained Project path.
   - Confirm the successful response produces exactly one Project.
   - Open C1 Store oversight and confirm exactly one DRAFT Store exists for it immediately.
   - Confirm all distinct canonically eligible Products are present and selected by default.
   - Confirm there was no separate `Prepare Store` action.
   - Confirm C1 has no routine Prepare, Publish or Product-selection control.

2. **C2 standalone creation**
   - As C2 `PROJECT_MANAGER`/`ADMIN`, create a second Standalone Project.
   - Confirm its Store tab is immediately available with exactly one DRAFT Store and the
     complete default eligible set.
   - Reload the Project and prove the same Store/selection remains.

3. **Event-linked creation**
   - Create an Event-linked Project through the supported retained path.
   - Confirm exactly one DRAFT Store is created and eligibility comes from the same-tenant
     Event/Catalogue contract.
   - Confirm it is distinguishable from Standalone in C1 filters/context.

4. **Intake route**
   - Submit one aligned staging public Intake and complete its accepted automatic route.
   - Where a reviewed outcome is supported, complete a separate Intake through protected
     C1 review.
   - Confirm both use the same Project/delivery/Store/default-Product aggregate and create
     neither a missing Store nor a duplicate Store.

**Phase A stop conditions:** missing or duplicate Store; incomplete default set; partial
Project after an error; separate manual Store preparation; wrong-tenant Event/Product; or
C1 routine Store creation/publication authority.

### Phase B - C1 Portfolio Oversight

5. As C1, open `/app/fund/stores` and confirm every Phase A Store is visible once.
6. Exercise bounded search plus Standalone/Event and lifecycle/readiness filters.
7. Confirm deterministic ordering and continued results when enough safe test data exists
   to exercise pagination/continuation.
8. Open Store detail and confirm Project/Event envelope, effective state, selected Product
   readiness, payment/seller readiness and current configuration evidence are intelligible.
9. Confirm portfolio responses/UI do not expose:
   - C1 intervention notes in the list;
   - raw configuration snapshots;
   - full configuration hashes;
   - purchaser/private recipient data; or
   - routine C1 Project activation, Store preparation or publication controls.
10. Trigger the supported server-owned readiness refresh and confirm the refreshed state is
    explained without raw Prisma/server errors.

**Phase B stop conditions:** missing Phase A Store; duplicate list item; tenant leakage;
private note/snapshot/hash exposure; misleading lifecycle wording; or routine C1 authority
outside exceptional intervention.

### Phase C - C2 Authority, Selection And Presentation

11. As C2 `PROJECT_MANAGER`/`ADMIN`, open one created Project and confirm:
    - Store copy is editable;
    - Product order and visibility are editable;
    - eligible Product selection is editable;
    - supplier price, tax, source media, Catalogue eligibility and readiness evidence are
      read-only.
12. Change Store copy, Product order and visibility; save, reload and confirm persistence.
13. Deselect one Product, refresh readiness and reload:
    - the explicit deselection must persist;
    - historic Store Product/configuration evidence must remain retained; and
    - the Product must not be silently reselected.
14. Through the normal C1 Product/Catalogue route, make the prepared extra Product newly
    eligible. Refresh the Project:
    - the newly eligible Product with no selection history must appear selected by default;
    - the prior explicit deselection must remain deselected.
15. Make one selected Product ineligible, refresh and confirm history is retained but the
    Product cannot trade. Restore eligibility and prove reconciliation does not create a
    duplicate membership/configuration.
16. As VIEWER, repeat reads and confirm every mutation/action is absent or refused.
17. As the isolation identity, attempt the Project/Store route and confirm not-found/denial
    without disclosing whether another tenant's Store exists.

**Phase C stop conditions:** silent reselection; duplicate Product membership; commercial
authority exposed to C2; VIEWER mutation; cross-Client/tenant visibility; or lost Store copy,
order or visibility.

### Phase D - Readiness, Commission, Activation And Time

18. On a Project with a known readiness blocker, attempt activation/publication intent.
    Confirm Project and Store remain DRAFT and the blocker names the responsible party.
19. Resolve only through supported staging controls:
    - required Product/configuration readiness;
    - seller/payment readiness;
    - commission offer and explicit C2 acceptance; and
    - required Project/Event/date evidence.
20. Activate through the C2 Project workflow and confirm the Project transition and first
    Store publication intent are atomic.
21. For a Project whose `opensAt` is in the future, confirm effective Store state is
    SCHEDULED rather than OPEN.
22. For a separate safe Project currently inside its trading window, confirm OPEN only
    when every gate passes.
23. For a Project outside/after its window, confirm non-trading
    `Project window ended` behaviour without inventing an exceptional C1 closure.
24. Confirm stale Project/date/readiness evidence is refused rather than silently
    overwriting a newer state.

**Phase D stop conditions:** activation with a blocker; Store/Project partial transition;
OPEN before `opensAt`; trading after `closesAt`; missing commission acceptance; stale write
accepted; or any real provider/payment action.

### Phase E - Voluntary And Exceptional Authority

25. As C2 manager, exercise voluntary pause and resume; confirm effective state and audit
    evidence change without altering C1 authority.
26. As C1, apply exceptional pause with an approved reason and private operator note.
27. Confirm C2 cannot bypass the intervention and cannot see the C1 private note.
28. Release the exceptional pause and confirm the correct prior/effective state resumes.
29. Apply exceptional closure and then the supported reopen/resolution path.
30. Repeat the exact intervention action to prove idempotent replay does not create a
    second effective intervention.
31. Attempt with a stale modal/state where safely reproducible and confirm a clear refusal.

**Phase E stop conditions:** C2 bypass; private-note exposure; C1 gains routine
publication; duplicate intervention; lost chronology; or cross-tenant intervention.

### Phase F - Responsive, Accessible And Failure Presentation

32. Check the C1 portfolio/detail and C2 Store tab at representative desktop and mobile
    widths.
33. Use keyboard-only navigation for filters, rows, Store controls and intervention dialogs.
34. Confirm visible labels, focus entry/return, confirmation wording and non-colour state
    cues.
35. Confirm loading, empty, no-results and safe error states. Do not deliberately damage
    data or disconnect shared staging services to manufacture an error.
36. Confirm C2 never sees C1 notes/private commercial evidence and C1 does not receive
    purchaser/public Store controls.

## 6. Result Capture

Complete this table during execution:

| Phase | Result | Tester role(s) | Safe Project/Store reference | Evidence/note |
| --- | --- | --- | --- | --- |
| Preflight | PENDING |  |  |  |
| A - Creation | PENDING |  |  |  |
| B - C1 oversight | PENDING |  |  |  |
| C - C2 selection/presentation | PENDING |  |  |  |
| D - Readiness/lifecycle/time | PENDING |  |  |  |
| E - Intervention authority | PENDING |  |  |  |
| F - Responsive/accessibility | PENDING |  |  |  |
| Post-test health | PENDING |  |  |  |

For every failure record:

- exact numbered test;
- role and safe Project/Store reference;
- visible message and expected result;
- safe screenshot/log correlation;
- whether subsequent phases were stopped; and
- owning review record: E-B, E-C or E-D.

Do not record secret values, complete database URLs, private notes, organiser/purchaser data
or raw configuration payloads.

## 7. Post-Test Reconciliation

After the last permitted test:

1. repeat `/api/health`;
2. confirm no unexpected cron/application/database errors occurred;
3. archive or clearly label synthetic Projects through supported UI policy; do not delete
   retained evidence directly;
4. append results to this table;
5. update each source review with only its relevant human result and a link back here;
6. update the FUND controlling roadmap;
7. update the root production assessment; and
8. stop before `main`, live migration or live configuration.

## 8. Acceptance Decision

E-B/E-C/E-D consolidated human acceptance is PASS only when:

- every preflight and Phases A-F item passes or is explicitly documented as genuinely not
  applicable under an already accepted contract;
- no stop condition occurred;
- individual source reviews are reconciled;
- post-test health remains green; and
- no production or public purchaser action was used.

A partial run is not a combined PASS. One failed tenant, authority, atomicity,
deselection/readiness or intervention test keeps the combined production release gate on
HOLD.
