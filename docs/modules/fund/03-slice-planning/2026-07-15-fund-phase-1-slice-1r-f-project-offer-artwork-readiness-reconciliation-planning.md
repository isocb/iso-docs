# FUND Phase 1 Slice 1R-F - Project Offer And Artwork Readiness Reconciliation Planning

Date: 2026-07-15

Status: Parent reviewed and accepted; no child implementation authorised

Naming correction: 2026-07-16 — restored alphabetical delivery order by assigning this
parent `1R-F` and moving the previously reserved, unimplemented Public Store Presentation
slice to `1R-G`.

Authoritative controls:

- `docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`
- `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`
- `docs/modules/fund/00-roadmap-control/2026-07-15-fund-store-artwork-orders-and-production-strategic-completion-roadmap.md`

Governed change requests:

- `docs/modules/fund/01-cr-inputs/2026-07-15-fund-application-artwork-template-refinement.md`
- `docs/modules/fund/01-cr-inputs/2026-07-15-fund-project-product-selection-limits-and-template-capacity-cr.md`
- `docs/modules/fund/01-cr-inputs/2026-07-15-fund-collective-project-artwork-composition-approval-and-workflow-aware-product-instructions-remedial-clarification.md`

Supporting brief:

- `docs/modules/fund/01-cr-inputs/2026-07-15-fund-template-manager-brief.md`

Completed dependencies:

- FUND `1C`, `1Q-E`, `1Q-F`, `1R-C1` through `1R-C6`, `1R-D` and `1R-E-A`;
- locally completed/reviewed `1R-E-B` and `1R-E-C` surfaces;
- Project Intake/creation `1P-G-R3-A` through `R3-D` and C2 Client dashboard/K2; and
- Commerce `A1` through `A7`, including dormant Order/Payment/FUND-context creation and
  provider reconciliation boundaries.

`1R-F` follows the completed `1R-E-A/B/C` child set in delivery order. The previously
reserved Public Store Presentation slice moves to `1R-G`; no implemented slice or
historical evidence is renumbered. The critical path is `1R-E -> 1R-F -> 1R-G`.

## 1. Goal

Reconcile the three governed CRs with the implemented Store, Product, asset, Commerce and
C1/C2 authority contracts, then allocate independently testable child lifecycles for:

1. Individual Artwork Project offer/template readiness;
2. Group/Bulk collective artwork composition, approval and Product release;
3. unmodified Standard Product readiness; and
4. one converged Store availability policy consumed later by `1R-G`.

This parent is a control and sequencing decision. It is not an implementation prompt and
creates no schema, migration, renderer, upload, storage, service, route or UI behaviour.

## 2. Accepted Domain Separation

### 2.1 Project type, Product suitability and Workflow Class

These remain separate authorities:

```text
one FundProject.projectType
-> Catalogue availability
-> Product suitability for that Project type and Client context
-> active selected FundProjectProduct membership
-> FundProjectProduct.workflowClass snapshot
-> branch-specific offer/artwork/readiness evidence
```

Rules:

- `ARTWORK_FUNDRAISING` uses the Individual Artwork branch;
- `GROUP_PERSONALISED_PRODUCTS` uses the collective branch for Products whose Workflow
  Class requires shared artwork;
- `BULK_ORDER_CLUB_FUNDED` may contain both collective/shared-artwork Products and
  unmodified Standard Products when each selected Product's explicit Workflow Class and
  suitability permit it;
- `NOT_SURE` cannot finalise an offer, publish or trade; and
- Standard Product remains Workflow Class `C`, not a fifth Project type and not a state
  inferred merely from absent booleans.

The current protected classes `A1`, `A2`, `B` and `C` remain evidence to audit and refine;
the implementation must not route an Individual Artwork Project merely because a Product
has `requiresTemplate = true`. In particular, current class `A2` also carries that flag but
belongs to the collective path.

### 2.2 Three distinct business aggregates

The following must never be collapsed:

| Aggregate | Owner and purpose |
| --- | --- |
| Application Template / Version | Reusable C1-owned A4 design and immutable capacity/layout contract |
| Artwork Template / Version | Generated, immutable, Project-specific Individual Artwork document finalised by C2 |
| Collective Project Artwork / Version | C1-created shared Project composition approved by the exact C2 organiser |

`FundProductionAsset` remains the managed source/composite/presentation binary substrate.
A generated Artwork Template is a different business document and receives its own
aggregate rather than being forced into production-asset review/uploader semantics.

### 2.3 Product presentation and release

Collective Project artwork approval and Store Product release are separate:

```text
exact organiser approves exact shared composition version
+ C1 creates/validates Product presentation from that version
+ C1 explicitly releases that Product presentation
+ all other Store Product readiness passes
-> Product may be displayed
```

An exceptional physical-sample/reproduction hold applies to the affected Store Product.
It does not block the whole Store when at least one other displayed Product is released and
ready. No approval or release is inferred from upload, scan completion, current-version
selection or mutable metadata.

## 3. Existing Foundation And Demonstrated Gaps

### 3.1 Reused without redesign

- `FundProjectProduct` already records the selected Product and Workflow Class snapshot.
- `FundProjectStoreProduct` and immutable configuration versions already retain Product,
  copy, commercial, input, media and readiness evidence.
- `FundProductionAsset`, immutable versions and Project/Store Product links already retain
  managed source, composite and presentation binaries with malware/retention evidence.
- `1R-D`/`1R-E-A` already supply Store Product refresh, Store readiness, effective state,
  Project/Event date authority and C1/C2 action policy.
- Commerce A7 already snapshots the exact accepted Store configuration and typed FUND
  context into an Order; it must consume, not recreate, the future offer lock.

### 3.2 Proven gaps

1. There is no Application Template identity/version/assignment or validated Product-grid
   capacity model.
2. There is no Project-specific Individual Artwork offer lock, generated Artwork Template
   version, generation attempt/job or secure delivery grant.
3. The current `FundProductionAsset.artworkReview*` evidence is a mutable C1-user review of
   one asset/current version; it cannot prove exact-organiser approval of one immutable
   Project-level composition.
4. Current asset links can express source/composite/presentation lineage, but there is no
   typed collective-artwork approval aggregate, Product presentation release or physical-
   sample hold.
5. Current Store Product readiness accepts a generically approved/clean presentation
   asset; it does not derive the required branch from Project type plus Workflow Class or
   prove organiser approval/release.
6. Product-specific C2 instructions have no immutable ownership/version/snapshot contract.
7. Individual Artwork selection currently has no shared default-all/minimum/maximum/
   template-capacity policy or offer-finalisation lock.
8. There is no deployed Chromium renderer proof, private generated-document contract,
   secure organiser delivery or physical print/QR evidence.

Only these demonstrated gaps may create later schema or service work. Existing C4 asset
models must not be duplicated merely to give new UI convenient names.

## 4. Accepted Cross-CR Decisions

### 4.1 C2 authority

- active same-Client `PROJECT_MANAGER` and `ADMIN` members may review and mutate eligible
  Project Product selection and supply Project source material;
- the exact `FundProject.organiserMemberId` alone initially finalises/unlocks an Individual
  Artwork offer and approves/requests changes to Collective Project Artwork;
- active authorised Project members may view readiness and download an authorised current
  document, but only the exact organiser may issue/reissue an external organiser grant or
  perform the business lock transitions; and
- no authority derives from organiser email/name snapshots or a browser-supplied Client,
  tenant or actor identifier.

### 4.2 Individual selection/capacity

- the minimum is one selected Project Product;
- maximum selected Project Products belongs only to immutable Application Template
  Version and cannot exceed validated Product-grid capacity;
- a new Individual Artwork selection starts with every distinct eligible Product selected;
- an eligible pool above the maximum produces a C1 warning but is not an Application
  Template/Event activation blocker; C2 sees the full over-maximum selection and must
  deselect Products;
- C1 and C2 use one server policy; no UI/API bypass exists; and
- one selected Project Product initially consumes one printable row. Options/modifiers are
  not allowed to multiply printable rows until the renderer proof and a separately
  accepted printable-option convention support them.

### 4.3 Template assignment and locking

- an Event assignment points to an Application Template identity and follows its current
  active valid version before Project finalisation;
- an Event-linked Project does not fall back to the Standalone default and receives no
  Project-specific override in the first release;
- a Standalone Project uses an exact C1 Project override when present, otherwise the
  tenant's active default Standalone template;
- finalisation pins the exact Application Template Version, ordered Product membership,
  exact Store Product configuration versions, resolved prices, canonical Store URL/QR,
  resolved content and renderer contract;
- the Store/configuration rows are not duplicated into a second mutable lock authority;
  every relevant mutation, readiness, publication and checkout path verifies the exact
  immutable offer lock; and
- an Artwork Template may be finalised before Store publication, but finalisation never
  publishes or authorises checkout.

### 4.4 Unlock and revision

- before paid Orders, exact-organiser unlock requires a nonblank reason, audit and a
  complete refinalisation; a published Store must first become non-trading under the same
  server authority;
- a paid Order or recorded physical distribution prohibits ordinary unlock;
- later C1-controlled reconciliation may supersede prospective evidence but must never
  rewrite an existing Order, Artwork Template Version or distributed document; and
- no current public Order route exists, so rollout needs no destructive legacy inference.

### 4.5 Collective branch

- organiser instructions are versioned by Product + Project type + Workflow Class; this
  preserves different operational treatments for the same Product/type;
- Group/Bulk Product selection remains normal C2 selection inside C1 eligibility;
- the exact organiser supplies/declares the source set submitted, while C1 validates
  completeness and alone creates the composition;
- the organiser may approve one shared composition with representative Product mock-ups;
  C1 may create remaining presentations afterward, but no Product appears until its exact
  presentation is released;
- release is an explicit C1 individual or bounded bulk action, never an automatic side
  effect of organiser approval; and
- ordinary revision after Store publication/open checkout/paid Orders is prohibited until
  the later audited reconciliation child defines prospective and historic treatment.

### 4.6 Existing data

FUND carries no live production business data at this point, but migrations must still be
non-inferential. They may add nullable/new empty aggregates and report test/dev
noncompliance; they must not guess Project type, approval, release, selection, template,
lock or workflow state. Any cleanup of disposable FUND test data is a separate explicit
environment action, never migration behaviour.

## 5. Converged Readiness Contract

Later children extend the existing `1R-D`/`1R-E-A` policy; they do not create a competing
Store state machine.

```text
ARTWORK_FUNDRAISING
-> current finalised Individual Artwork offer lock and successful current Artwork
   Template Version required

GROUP_PERSONALISED_PRODUCTS / applicable BULK_ORDER_CLUB_FUNDED Product
-> exact approved Collective Project Artwork Version
+ exact released Product presentation/configuration required

unmodified Workflow Class C Product
-> ordinary immutable Store Product configuration/media/readiness only

NOT_SURE
-> finalisation/publication/trading prohibited
```

A mixed Bulk Project may converge ready collective and Standard Products. Each displayed
Store Product passes its own branch, while the Store still requires at least one visible,
released and ready Product and all Store-level E-A gates. Browser booleans such as
`requiresArtworkApproval`, mutable Workflow Class JSON and metadata are never authority.

## 6. Bounded Child Sequence

Each child requires its own planning review/acceptance, implementation confirmation and
review/test record unless explicitly described as a planning/proof-only child.

### 6.1 1R-F-A — Real AMOW Template, Pricing And Deployed Renderer Proof

Single next planning candidate.

Bounded outcome:

- use one genuine AMOW Individual Artwork design and representative resolved A7/Store
  commercial data;
- prove controlled HTML/React-to-one-page-A4 PDF rendering with short, long, maximum and
  deliberate-overflow fixtures;
- prove title, bounded rich text, five empty Order Code boxes, protected artwork area,
  Product/price/blank quantity/total grid, canonical URL and scannable QR;
- compare browser preview/PDF, inspect with `pdf-lib`, bundle fonts, and prove the pinned
  browser in a deployment-equivalent worker;
- exercise private test-object write/read without defining the production storage model;
- establish initial safe-print, legibility, standard/compact grid-capacity and generation
  resource envelopes; and
- produce schema inputs and an explicit human physical-print/QR testing schedule.

It adds no production schema, public/C1/C2 route, reusable editor, operational job, email,
Store publication or real Order behaviour. Final physical print acceptance requires the
user/client and is the first planned human stop.

### 6.2 1R-F-B — Individual Artwork Template And Offer-Lock Schema Foundation

Plan the accepted Application Template identity/version/assignment, Project offer lock,
Artwork Template identity/version, generation attempt and secure grant evidence only after
A proves the renderer/layout contract.

### 6.3 1R-F-C — Individual Selection, Template Lifecycle And C1 Management

Implement the shared minimum/maximum policy, template lifecycle/assignment services and
bounded C1 basic management/validation. A dedicated visual-editor sub-slice may be split
when planning demonstrates that it is not safely bounded with basic management.

### 6.4 1R-F-D — C2 Individual Offer Preview, Finalisation And Lock

Implement default-all selection, exact organiser preview/finalisation/unlock, immutable
commercial/configuration lock and workflow-aware Store readiness consumption. No renderer
job or public Store route.

### 6.5 1R-F-E — Artwork Template Generation, Storage And Delivery

Implement the dedicated idempotent worker, immutable generated versions, private managed
storage, authorised C2 download, exact-version secure organiser grant/email, operational
history, invalidation/revision and automated/visual/physical release evidence.

### 6.6 1R-F-F — Workflow Instructions And Collective Artwork Schema Foundation

Plan/implement Product+Project-type+Workflow-Class instruction versions/snapshots,
Collective Project Artwork/version/approval evidence, source lineage, Store Product
presentation release and physical-sample hold using C4 assets without duplicating them.

### 6.7 1R-F-G — Collective Composition, Approval, Release And Readiness Services

Implement exact C1 composition, exact-organiser approval/change request/locking, explicit
C1 Product release/hold and branch-aware E-A readiness. Include prospective revision and
historic Commerce evidence protection; no production authorisation.

### 6.8 1R-F-H — Collective C1/C2 Surfaces And Secure Source Handling

Implement C2 instructions/source submission/approval UI and C1 composition/presentation/
release/exception UI through the accepted services. Upload/scanning must use a separately
accepted managed-upload boundary and may be split if it cannot be safely bounded.

### 6.9 1R-F-I — Standard Path And Cross-Branch Release Reconciliation

Prove explicit Workflow Class `C` Standard readiness, Bulk mixed-path behaviour, C1/C2
diagnostics, A7 non-trading consumption and the final converged policy needed by `1R-G`.

## 7. Deferred Questions Routed To Owning Children

The parent does not invent visual or operational detail that requires proof:

- A owns exact safe-print inset, font pack, grid capacities, long-content envelopes,
  Product code/grand-total/currency presentation and printer/QR acceptance;
- B/D own precise lock table shape and offer mutation chronology;
- E owns organiser-email automatic-versus-explicit trigger, secure-link expiry/reissue,
  retention and physical-distribution evidence;
- F owns exact source-completion contracts and typed physical-sample evidence;
- G owns exceptional post-publication/open-checkout/paid-Order reconciliation; and
- the later consumer Order/Order Code lane owns numeric code uniqueness, issuance timing,
  email and production matching. The template may render five empty boxes but cannot
  invent Order Code authority.

Any child encountering a choice that changes the business workflow rather than its
technical expression must stop and request user input before acceptance/implementation.

## 8. Validation Strategy

Every executable child must retain the complete application migration baseline and use
only `TEST_DATABASE_URL` after proving it differs from `DATABASE_URL`.

Across the lane, evidence must include:

- Prisma multi-schema validation/generation and bounded migration review where applicable;
- fresh replay and representative existing-data migration with zero semantic backfill;
- tenant, Client, actor, exact-organiser, Project/Product/Store/configuration ownership;
- Project type, suitability and Workflow Class branch selection;
- immutable version/current-pointer/supersession/deletion constraints;
- selection/capacity, approval, Product release/hold and Store/A7 non-trading gates;
- concurrency, idempotency, rollback, retries and zero residue;
- secure upload/storage/download/redaction tests where applicable;
- renderer visual fixtures plus actual-size physical print and QR testing for Individual
  Artwork; and
- a human UI testing schedule in every review/test record that introduces or materially
  changes C1/C2/public UI.

No test uses real Stripe payments, production authorisation or shared development,
staging or production data unless a separately controlled promotion/test process is
explicitly authorised.

## 9. Review Outcome

Review against the three CRs, the current 141-migration schema lineage, E-A authority,
E-B/E-C surfaces, C4 asset contract, 1R-D readiness and A7 consumer boundary found the
parent acceptable after the decisions recorded above.

Accepted conclusions:

1. `1R-F` follows `1R-E`; the formerly reserved Public Store slice is now `1R-G`.
2. Individual, collective and Standard paths remain separate but converge through one
   existing Store authority/readiness boundary.
3. Current C4 assets are reused, but exact-organiser approval and Product release require
   new typed evidence.
4. A generated Artwork Template requires its own aggregate.
5. No artwork/template implementation is safe before a real deployed-renderer/print proof.
6. `1R-F-A` is therefore the single next planning candidate.

Because this is a non-executable parent reconciliation, no `04-implementation-confirmations`
or `05-review-and-test` record is created. Each executable child receives the full
lifecycle independently.

## 10. Single Next Prompt

```text
Continue only accepted FUND Phase 1 Slice 1R-F-A planning. Do not implement production
schema or application behaviour and do not begin 1R-F-B through 1R-F-I, 1R-G, Order Code,
production, commission or another slice.

Create one bounded Real AMOW Template, Pricing And Deployed Renderer Proof plan against the
accepted 1R-F parent, completed Commerce A1-A7, FUND C1-C6/1R-D/1R-E and the current
141-migration application history.

Plan an isolated proof using one genuine AMOW Individual Artwork design and representative
resolved Store/A7 commercial fixtures. Resolve the exact proof inputs, controlled
HTML/React composition, pinned Chromium/Playwright deployment-equivalent runtime, bundled
fonts, pdf-lib inspection, QR generation/decode, one-page A4 portrait/landscape validation,
safe-print inset, protected artwork area, bounded rich text, five empty Order Code boxes,
Product/unit-price/blank quantity/total grid, short/long/maximum/overflow content,
standard/compact capacity measurement, preview/PDF parity, resource/retry envelope and
private test-object write/read boundary.

Define automated, visual and physical print/QR evidence. Include an explicit human test
schedule and identify the single AMOW design/print input required from me before physical
acceptance. Add no Prisma model or migration, production template/editor/job/storage/email
service, public/C1/C2 route or UI, Store publication, real Order/Order Code, Stripe,
production or commission behaviour.

Leave the A proof plan awaiting explicit review/acceptance and provide its single bounded
review prompt. Make no application or infrastructure change during planning.
```
