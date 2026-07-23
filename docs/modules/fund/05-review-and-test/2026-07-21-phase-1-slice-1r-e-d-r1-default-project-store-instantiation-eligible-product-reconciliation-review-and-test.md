# FUND Phase 1 Slice 1R-E-D R1 - Default Project Store Instantiation And Eligible Product Reconciliation Review And Test

Date: 2026-07-21

Status: Automated review and integrated revalidation passed; E-D is in current staging
ancestry; consolidated human workflow acceptance pending

Application implementation reviewed: `c45a41d9`

Integrated application commit revalidated: `174dc8ac` on `dev`/`origin/dev`

## Review Result

Accepted implementation is present and remains within E-D. The three user routes converge on
the same Store outcome through two retained aggregate writers: shared direct creation serves
C1/C2, while R3-B serves automatic/reviewed Intake. No parallel writer, schema change or
clientless legacy path was introduced.

## Safety And Database Evidence

- `TEST_DATABASE_URL` was proved distinct from `DATABASE_URL` before database access.
- The disposable database contained exactly 141 applied migrations and zero failed migrations.
- Prisma schema and migration directories have no diff from `origin/dev`.
- No shared database, reconciliation command, Stripe action or deployment was used.
- Every test fixture was removed; zero E-D residue remained.

Before dev consolidation, E-D was merged with the current `e850c47b` application bundle and
revalidated against the resulting complete 143-migration TEST-only inventory. The E-D suite,
expanded R3-B suite, full test run, type-check, verification and production build passed. E-D
changed neither Prisma schema/migrations nor dependency manifests. No shared database or
reconciliation command was used during consolidation.

## Automated Evidence

Passed:

- `scripts/verify-fund-1r-e-d-default-store.ts`;
- `scripts/run-fund-1r-e-d-default-store-tests.ts`;
- expanded `scripts/run-fund-1p-g-r3-b-service-tests.ts` for automatic/reviewed Store evidence
  and rollback after CLIENT, USER, MEMBER, PROJECT, DELIVERY, DEFAULT_PRODUCTS, STORE,
  CONFIGURATION and AUDIT;
- `scripts/run-fund-1p-g-r3-d-integration-tests.ts`;
- E-A Store authority/intervention disposable tests;
- E-B Store oversight static and disposable tests;
- E-C C2 Store surface static and disposable tests, updated to require removal of routine
  Prepare/Publish routes;
- 1R-D Store readiness/configuration disposable tests;
- A7 ownership/no-schema static regression;
- Prisma validation and client generation;
- full TypeScript type-check; and
- production build.

The E-D suite proved:

- direct C1 and C2 creation each create one DRAFT Store and the complete eligible set;
- automatic Intake stores null actor evidence and reviewed Intake stores the exact C1 actor;
- same-request replay converges without duplicate Store evidence;
- injected failure at every aggregate stage leaves no partial Project;
- inactive membership remains an explicit exclusion through refresh and renders unselected;
- newly eligible Products are added only without history; newly ineligible history is retained;
- normal re-eligibility recovers eligibility without recreating membership;
- immutable Store Product configuration evidence is present; and
- failed activation/readiness leaves both Project and Store DRAFT.

## Human Smoke Schedule After Controlled Promotion

E-D is now included in the promoted staging ancestry. Do not substitute hand-created Store
fixtures. The definitive connected E-B/E-C/E-D schedule is:

`docs/modules/fund/05-review-and-test/2026-07-23-fund-phase-1-slice-1r-e-b-through-1r-e-d-consolidated-staging-human-smoke-test-schedule.md`

The following retained E-D requirements are incorporated there:

1. **C1 creation:** as FUND C1, create a Project for an existing Client. Confirm the Project
   immediately appears in C1 Store oversight with one DRAFT Store and the complete eligible
   default Product set. Confirm C1 has no routine Prepare, Publish or Product-selection action.
2. **C2 creation:** as a C2 PROJECT_MANAGER/ADMIN, use New Project. Confirm the Store tab is
   immediately available and shows the same default eligible set. A VIEWER must remain read-only.
3. **Public Intake:** submit and confirm one aligned automatic Intake form. Where a reviewed
   outcome is needed, complete it through the protected C1 review path. Confirm both outcomes
   create the same delivery/Store/default Product aggregate and appear in C1 oversight/C2.
4. **Selection:** deselect one Product, refresh readiness and reload. Confirm it remains excluded
   even though its historic Store Product/configuration evidence remains; restore it explicitly.
5. **Presentation:** change C2 Store copy, ordering and visibility; refresh and reload. Confirm
   these values persist and supplier-owned commercial values remain read-only.
6. **Activation gate:** first attempt activation with a known blocker and confirm Project and
   Store remain DRAFT with an actionable reason. Satisfy commission/payment/readiness gates,
   activate again and confirm the first publication intent is atomic.
7. **Time behavior:** for a future `opensAt`, confirm effective state is SCHEDULED; within the
   Project window confirm OPEN only when every E-A gate passes; after `closesAt` confirm the
   Store is non-trading without an exceptional C1 closure.
8. **Pause authority:** confirm C2 voluntary pause/resume. Separately prove C1 exceptional
   pause/release and closure/reopen with reason/audit, without gaining routine publication.
9. **Tenant isolation/accessibility:** repeat C1/C2 reads with another tenant/Client and confirm
   denial; check keyboard, focus, dialog labels, mobile and empty/error/loading states.

Record pass/fail, actor role, Project/Store identifiers and screenshots without purchaser or
organiser personal data. Any failure blocks E-B/E-C human acceptance and promotion onward; it
does not authorize manual database repair.

## Conclusion

Automated E-D implementation review and integrated revalidation pass. E-D is in current
staging ancestry, so E-B/E-C/D human acceptance is testable and remains pending under the
consolidated schedule. `1R-F-A` remains a planning candidate only; no implementation has begun.
