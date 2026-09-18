# FUND 1R-F-B1 — Individual Offer And Artwork Implementation

Date: 2026-09-07

## 18 September — C1 Operation And Real Notes Smoke

```text
Exact commit: 039757e57894f49b6bb372bc2c011b14b2c96992 on feature/fund-accepted-pdf-integration, descendant of e8a3c900 / c3998084
Files/change boundary: C1 contact-only preparation, Client-linked Project inputs/contact selection, direct C1 finalisation and immutable actor evidence, compatible migration 159, post-finalisation internal notes, and connected accepted-PDF notes smoke
Automated checks: PASS: 23 focused tests, C1/C2 service/router/SQL/concurrency proof, baseline preservation, PDF generation/recovery, authenticated browser, type/lint/repository checks and production compilation; detail in 05
Human evidence: New two-check C1/editor-to-PDF smoke pending. Chris's accepted PDF checks 1/2 and handwritten-field confirmation remain PASS; no repeat requested.
Environment proven: isolated local candidate, synthetic disposable TEST databases and actual authenticated browser/application; no retained DevData, staging, main/live or provider changes
Known residual risk: human acceptance pending; no protected-branch security scan or new online/runtime evidence. Detailed PDF is integrated locally; operational Store destination/private runtime and classroom distribution remain unfinished.
Next authorised action: Chris performs the two checks below; agent records acceptance and cleans up the owned temporary target. No dev consolidation, retained migration or promotion in this increment.
```

Chris's explicit implementation instruction supersedes the earlier planning-only amendment.
Control depth remains **High**. The implementation uses C1's own active OWNER/ADMIN identity,
with fresh actor/contact checks inside the finalisation transaction. Owning Client, organiser
contact and acting User remain distinct. Contact-only creation does not create an account;
explicit dashboard enablement retains account provisioning and existing linked Users are
preserved when dashboard access is disabled. Normal exact-organiser C2 operation remains.

Migration `20260918120000_fund_c1_finalisation_evidence` makes the finaliser member nullable
for C1 and adds capacity plus strict versioned evidence. Existing C2 rows keep their actor,
member, immutable offer and financial snapshots; no historic display name/authority note is
invented. New C1 writes record the actual operator, represented Client, timestamp and bounded
instruction note, with a matching audit event. The note is private Project evidence, not PDF
content. Old binaries expecting every finaliser to be a Client member are unsuitable after
C1 records exist: preserve rows and reads/downloads, stop new finalisation if needed, and use
a compatible forward fix. No rollback by deletion, relabelling or historical rewrite.

The accepted portrait/landscape design and template generation remain one connected flow.
The saved C1 artwork/ordering instructions enter the frozen v2 snapshot and the actual PDF
above/below its QR. The editor waits for saved defaults before accepting input. Default edits
apply to future finalisations; confirmed offers/PDFs retain their original instructions.
After finalisation C1 can still save Internal Notes and use permitted lifecycle actions on
the same Client-owned Project; confirmed content remains locked.

Detailed verification, the minimal human smoke and temporary-target ownership/cleanup are recorded in the [existing B1 review](../05-review-and-test/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-review-and-test.md#18-september--c1-operation-and-real-notes-smoke). The sole restart checkpoint remains in the B1 plan. This is implementing-agent review, not an independent-agent review. B1 Now / 1R-G planning Next is unchanged.

## 17 September — Accepted Layout Connected Locally

```text
Exact commit: e8a3c900931ae4c28cba04181c2cd00722710ad7 (based on c3998084), feature/fund-accepted-pdf-integration
Files/change boundary: shared accepted portrait/landscape layout, v2 immutable print snapshot, local isolated renderer, C1 inherited instruction/logo defaults, existing C2 finalise/download journey, compatible document constraint migration and focused proof tooling
Automated checks: 13 focused tests PASS; disposable 157-to-158 preservation and fresh 158 replay PASS; connected v1/v2 service proof PASS; real-component synthetic browser proof PASS; PDF text/geometry/raster-QR PASS; type/lint/verify/build results in the review record
Human evidence: 18 September — Chris accepts PDF checks 1 and 2 PASS, including portrait/no-logo, and confirms handwritten fields present/correct. The two C1 instruction inputs above/below QR could not be human-tested from static PDFs; their editor-to-PDF check remains pending.
Environment proven: local code and newly created disposable test databases only; no retained DevData, staging, main/live or provider changes
Known residual risk: local temporary storage and an isolated local process are not an operational renderer/storage service; canonical public Store destination and C1 instruction-editing human verification remain open
Next authorised action: prepare isolated local C1 instruction-input smoke as recorded in the review; preserve both accepted PDF checks. Stop before retained/shared database migration or promotion.
```

Chris explicitly authorised this bounded local implementation after reviewing the existing
[B1 plan](../03-slice-planning/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md).
Control depth remains **High**. B1 remains Now and open; 1R-G planning remains Next.
The previously accepted preparation release at `d13ecb39` and SeasonPro release at
`c3998084` are preserved. Historical September evidence below remains historical.

### Implemented boundary

- The accepted template is now shared at
  `src/modules/fund/lib/individual-offer/accepted-template.tsx`; the historical proof uses
  a thin adapter. All six proof fixtures produce byte-identical HTML to `c3998084`.
  The proof Dockerfile and path trigger include the shared source. No layout redesign,
  capacity change, template editor or new purchaser-preview screen was introduced.
- `fund-b1-local-pdf/v2` captures Product codes/titles/gross prices/order, Project number,
  fixed template title, two sanitised instruction blocks and optional C1 PNG content/hash.
  C1 saves inherited defaults once in the existing Project panel; C2 reviews instructions
  and Product codes before finalisation. Later defaults edits do not alter confirmed offers.
  The accepted monochrome portrait and optional-logo landscape behaviour are preserved.
- A separate credential-free Node/Chromium process renders only local/test output. External
  requests and browser JavaScript are blocked. One local render runs at a time; the child
  has an 18-second deadline and bounded Node/Chromium V8 heaps. These are not an OS-level
  total-memory guarantee. Cancellation uses normal process exit so Playwright closes its
  separately detached browser and removes its temporary profile.
- Existing lease/attempt, current-member/tenant checks, opaque private files and hash-locked
  recovery are reused. Output is capped at 1,000,000 bytes; measured synthetic PDFs are
  19,495 bytes (landscape) and 17,750 bytes (portrait). The v1 generation limit remains
  256,000 bytes. Old snapshots dispatch to the unchanged v1 emulator.
- Migration `20260917160000_fund_b1_local_pdf_contract` admits only the explicit
  `LOCAL_PDF`/v2 pair alongside the existing `EMULATED`/v1 pair. It preserves all existing
  status/hash/identity guards and edits no applied migration. There is no model/table,
  backfill, historical replacement or financial calculation change.
- `.env.example` documents `local-pdf` with target `local` or `test`. Deployed targets and
  provider signals refuse it. No actual environment file/provider setting was changed.
  Detailed output retains an explicit development-only footer, the existing invalid Store
  destination derived from `publicId`, and the unconditional development-only trading blocker.

Recovery is same-version retry with the original output hash. After v2 evidence exists,
use a compatible forward fix; do not replace old documents or deploy a binary that cannot
read their contract. A crash can leave the local render lock; inspect and remove it only
once its owning process/browser has ended. Production retention/recovery/runtime ownership
and a real durable Store URL remain the existing later operating decision.

### Historical disposition — 2026-09-12: Product modal correction
`e7e8837c5e18bc1b94457edecc6f52b75678f0e9` is committed and aligned on dev/staging. It shows
assigned primary media and removes the generic library selector from the interim panel.
Build, seven focused tests, lint/type/verify, read-only staging media/authority proof and
exact dev/staging security scans PASS. Exact Render deployment and three-domain health/
anonymous-access checks PASS. Human modal and
C2 finalisation/download smoke remain pending; earlier implementation evidence is retained.
No database/schema/runtime change or main/live promotion is part of this correction.

### Original September 7 implementation evidence

```text
Exact commit: 57e1454b530ae19dc586768fd996ff230d84421c
Files/change boundary: B1 four-model additive migration, offer/template/document services, C1/C2 routers and UI, existing-write guards, readiness blockers and tests; example/legacy credential sanitation only outside that runtime boundary
Automated checks: PASS; detailed checks and qualifications in the review/test record
Human evidence: authenticated C1/C2 smoke pending; synthetic component checks do not replace it
Environment proven: prior disposable tests plus owner-authorised existing Neon DevData preparation and localhost:3000 health/login checks; no staging/live promotion
Known residual risk: independent review and human acceptance pending; emulated PDF/private temporary storage do not prove production or physical-print suitability
Next authorised action: independent review of the exact candidate, then authenticated local C1/C2 smoke and recorded disposition before promotion
```

Status: Implemented; automated validation passed. Independent review, human local acceptance
and any environment promotion remain pending.

Control depth: **High**. Owner authority: Chris explicitly requested technical review and
implementation after accepting D1–D4. The [B1 plan](../03-slice-planning/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md)
owns the boundary and sole restart checkpoint.

Application baseline: `14077382`. Candidate commit: `57e1454b530ae19dc586768fd996ff230d84421c` (published to the approved work branch).
Work branch: `work/fund-b1-individual-offer`. No dev/staging/main promotion or deployed
configuration change is claimed.

## Delivered Behaviour

- C1 assigns either fixed template to an Event, standalone Project or standalone default.
  Event Projects cannot override or fall back to the standalone default.
- C2 sees capacity and readiness feedback and an exact offer preview. Only the active
  organiser, through their own session, can finalise. The confirmation explains the lock.
- Finalisation atomically stores the offer, ordered Product/commercial evidence and pending
  document. Identical concurrent submissions converge; stale or conflicting ones refuse.
- C1 or authorised C2 managers can generate/retry a deterministic development PDF. Current
  Client viewers can download through authenticated tRPC, without a public object locator.
  The matching Store preview uses the immutable confirmed snapshot.
- Lost or changed files require same-offer recovery. Regeneration must reproduce the original
  output hash. Failed deletion retains cleanup locators and reports `CLEANUP_REQUIRED`;
  retry also performs cleanup when the current document is already available.
- Database guards protect confirmed Project content, Product selection/order, Store copy and
  Store ordering/visibility across old write paths. Offer and price evidence are immutable.
- Canonical Individual Store readiness remains blocked for real trading. Public Store,
  payment, Order and operational slices remain required later in Phase 1; the editor is Phase 2.

## Schema And Technical Boundary

One additive Prisma migration, `20260907120000_fund_b1_individual_offer`, adds four records:
`FundIndividualTemplateAssignment`, `FundIndividualOffer`, `FundIndividualOfferProduct` and
`FundIndividualArtworkDocument`. Composite foreign keys retain exact tenant/Project/Store/
Product/version lineage. Scope, uniqueness, row matching, immutable-evidence and complete-
aggregate checks accompany the schema. No existing Project is backfilled or finalised.

Technical review found that Prisma 5 can return without surfacing a deferred trigger failure
at COMMIT although PostgreSQL rolls back the incomplete aggregate. Finalisation therefore
forces `SET CONSTRAINTS fund.b1_offer_complete IMMEDIATE` inside the transaction before
returning success. Negative tests also independently read back the absence of partial offers.

`FUND_INDIVIDUAL_ARTWORK_MODE` defaults to `disabled`. Emulation requires explicit target
`local`, `test` or `staging`; `production`, unknown targets and known production provider
signals refuse it. Only `.env.example` documents these settings; no deployed settings changed.
Files use private temporary storage, restricted permissions, opaque validated names and
bounded payloads. No provider credential, external worker, email grant or production asset
service was added. The fixed PDF emulator refuses unsupported font text and labels every
output as a development preview; it does not prove print layout, logo imagery or QR fitness.

## Validation And Remaining Gate

Detailed outcomes and residual limits are in the [review/test record](../05-review-and-test/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-review-and-test.md).
The authenticated C1/C2 human journey is still pending. Component visual checks use synthetic
transport and cannot replace that gate. No staging/live or physical-print PASS is claimed.

Disablement preserves confirmed evidence. Before shared deployment, reconcile existing
Individual Stores against the new readiness blockers and prove the chosen environment's
private storage/recovery contract. No evidence-table deletion is an ordinary production rollback.

Local smoke preparation subsequently authorised by Chris is complete: the existing DevData
database has B1 applied with data preservation checked, and local emulation is enabled.
See the review/test record for entry points and the outstanding Project/organiser choice.


## Local Workflow Reference Repair — 2026-09-08

[CR-Fix](../01-cr-inputs/CR-Fix-2026-09-08-fund-local-workflow-class-reference-data.md):
Create Product had no choices for its mandatory Production Workflow Class. DevData had zero
reference rows despite the original migration being complete; this is missing reference
data, not a missing enum. Under accepted local smoke preparation, restored only the four
canonical INSERT rows from committed migration `20260623130000_add_fund_product_workflow_classes`.
Target fingerprint `0970d1fe7a73` was checked distinct from staging/production. The transaction
rechecked table emptiness under lock; no schema/ledger change, full seed, user-row update,
reset or application edit was performed. Application remains `57e1454b`.

Database repair/readback: PASS — A1, A2, B and C are active, system-default and read-only;
independent readback confirms the original migration marker remains complete. Cause/timing
of prior removal remains unknown. The modal's active-class query can now return these rows.
Authenticated UI Product creation: pending Chris's retry after refresh/reopening the modal.
For B1 Individual Artwork Products choose A1; Product Suitability remains separately required.


## Authorised Technical Corrections — 2026-09-12

Application base: `133a4638`, existing work branch; corrections remain local/uncommitted.
No applied migration, DevData/staging database, provider setting or deployment changed.

- `individual-offer-readiness.ts` now assigns organiser finalisation to C2. Focused tests
  retain C1 setup responsibility and prove development documents never remove the trading gate.
- `projects.service.ts` now protects context saves with the planned availability/Event/Project
  lock order, rejects concurrent stale edits and rechecks protected evidence before updating.
- The B1 disposable runner and connected suite now include chronological migration selection,
  exact ledger checksums, four constraint-valid migration refusal fixtures, catalogue races,
  lock timeout/retry, stale-save and private development-checkout checks with bounded cleanup.

Build, 533 unit tests, application and proof-script TypeScript, and changed application lint
pass. The connected migration/service/concurrency proof, separate fresh 156-migration replay
and verified removal of both disposable databases also pass (runner exit 0). Exact scope, failures, evidence limits and
focused human follow-up are in the [technical review](../05-review-and-test/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-review-and-test.md).
This records a dedicated technical review/correction pass, not independent second-reviewer
sign-off or full B1/live acceptance.


## C2 Finalisation Setup Controls — 2026-09-12

The authorised follow-up resolves missing Product tax/image controls and unhelpful offer
feedback. `ProductModal` exposes the existing tax-treatment field. The new
`ProductPrimaryImagePanel`, Product router endpoints and `product-image.service` allow C1 to
assign a same-tenant image with transactional revision/audit and retained media references.
No schema change, upload-provider change or new tax default is introduced.

`IndividualOfferPanel` names the requirements beside finalisation, refreshes Store and offer
together and enables acknowledgement only for a valid review. `ClientProjectStorePanel`
invalidates the offer after Store changes and shows readable Product reasons. The offer
service reports individual setup actions and missing Seller configuration without relaxing
any readiness, finaliser or trading guard. See B1 05 for tests, read-only staging diagnosis,
conditional test-profile preparation and the user-authorised dev/staging promotion.


Promotion complete: `3379c4e9` is on local/online dev and staging; Render deployment
`dep-daii93ss728c73aj7tng` is Live at the exact commit. Both staging URLs pass health
(DB connected, RLS 11/11) and unauthenticated route/mutation boundary checks. The approved
DRAFT synthetic Seller is retained; C1 Product choices and corrected C2 walkthrough await
Chris. No FUND main/live promotion occurred. B1 05 carries exact time and security evidence.

### Temporary Tenant-Logo Product Image — 2026-09-12

Application remains `3379c4e994a225c78238b5aed1d114e94c7dbaf0`; this is a staging fixture and
documentation change, with no application deployment, schema or runtime-setting change.
Chris authorised using the existing tenant logo while Product-media refinement is planned.

The staging target was verified distinct from configured local and production databases.
A Serializable transaction held availability, Project/Store and Product locks and guarded against
unexpected selection, existing primary media, finalised offer, non-draft/published Store,
FUND Orders or ambiguous/foreign-tenant media. It associated only the exact existing managed
tenant light-logo SVG with Product fingerprint `c532f932` on Project `a15cde9b`, labelled
“Temporary tenant-logo placeholder — replace with Product image”. It incremented Product
configuration revision to 3 and recorded `FUND_STAGING_TENANT_LOGO_PLACEHOLDER_ASSIGNED`.
This exact branding-asset fixture does not expand the application's raster upload policy.

The existing Store refresh service ran within the same transaction, with automatic default
selection disabled. Independent read-only verification through a separate connection proved
the same-tenant logo reference, label/revision, preserved STANDARD tax, one selected Product,
exact-organiser permission, zero offer reasons and valid snapshot/input hash. Store status
remains DRAFT and unpublished; no finalised offer or FUND Order was created. No existing media
reference was removed. Temporary local orchestration is removed after verification; the
authorised placeholder remains for human smoke. The B1 plan records rollback boundaries.

Human finalisation and PDF download remain pending. The present C2 Store panel does not
render Product images; this fixture resolves image data readiness, not gallery presentation.
The generic library
journey is not accepted as final Product-media UX. The [refinement input](../01-cr-inputs/2026-09-12-fund-product-media-gallery-options-and-option-image-refinement-input.md)
is registered for triage without changing Now/Next or accepting a completed gallery.

### Product Modal Placeholder Visibility — 2026-09-12

The next human report confirmed that the fixture alone left the old library prompt and an
empty selector in the Product modal. The bounded correction changes three application files:
`ProductPrimaryImagePanel.tsx`, `product-image.service.ts` and its tests. The modal now shows
the assigned primary image with a temporary-tenant-logo label when applicable. The generic
library link, dropdown and separate image Save controls are removed from this interim panel.
Loading, error and genuinely unassigned states remain explicit. The C1 query returns only
the Product's active same-tenant primary media and no longer enumerates the generic library.
The existing SVG branding fixture is displayed as an image, without inline SVG injection or
expansion of the raster-only assignment API. No database, schema, runtime or offer changes.

Focused tests: 7 PASS; source lint and repository/type verification PASS. Read-only execution
of the corrected service against staging confirms the exact assigned tenant logo and label,
HTTP 200/image SVG from the asset endpoint, C2 FORBIDDEN and foreign-tenant NOT_FOUND.
Build PASS (131 pages). Exact commit/promotion follows below; human modal display remains pending.

Promotion outcome: `e7e8837c5e18bc1b94457edecc6f52b75678f0e9` is aligned on local/online dev
and staging through the existing work branch and local fast-forward promotion corridor.
Render `dep-daiivvojo6nc73bl6u8g` is Live at that commit, completed
`2026-09-12T11:03:03.30739Z`. The user's `staging.seasonpro.co.uk`, `staging.isostack.app`
and `sating-isostack.onrender.com` each return healthy HTTP 200, connected database, RLS
11/11 and HTTP 401 for a signed-out image-settings query. Dev/staging Security Scans
`34689761185` / `34689769969` PASS. B1 05 holds proof qualifications. No environment variables
or credentials are in the three-file application commit; main/live remains `0397bba9`.
