# FUND Store, Artwork, Orders And Production Strategic Completion Roadmap

Created: 2026-07-15

Last consolidated: 2026-07-21

Status: Subordinate strategic capability overview; planning coordination only

Authoritative FUND roadmap and slice control:

`docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

Parent cross-lane roadmap:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

Sibling Commerce Core roadmap:

`docs/core/commerce/00-roadmap-control/2026-07-13-commerce-core-roadmap-and-slice-control.md`

Subordinate refinement and pilot-placement register:

`docs/modules/fund/00-roadmap-control/2026-07-20-fund-refinement-wishlist-and-slice-control.md`

## 1. Purpose

This document provides one strategic completion view from the Commerce payment foundation
through an operational FUND Store, workflow-appropriate artwork readiness, public ordering,
production, fulfilment, commission and release hardening.

It exists because the capability crosses several established FUND and Commerce lanes and
cannot be understood safely as one implementation slice or as `COMMERCE-A7` alone.

This overview:

- explains how the major capabilities depend on one another;
- incorporates three named FUND change requests;
- distinguishes technical transaction completion from operational FUND completion;
- identifies where existing foundations are reused rather than rebuilt;
- provides completion gates for future roadmap refinement; and
- gives later slice-planning work a shared strategic destination.

It does not implement code, change schema, create migrations, deploy infrastructure or
authorise any application work.

## 2. Authority And Reading Rule

This is not a second authoritative roadmap.

Authority remains:

1. the root roadmap for cross-lane FUND/Commerce selection and dependencies;
2. the authoritative FUND roadmap for FUND status, next-slice selection and implementation
   permission;
3. the Commerce Core roadmap for Commerce sequencing and status;
4. accepted bounded `03-slice-planning` documents for individual executable contracts;
5. `04-implementation-confirmations` for implementation evidence; and
6. `05-review-and-test` for independent review, test and deployment gates.

This document is subordinate to those controls. Its stage numbers and candidate workstream
names are strategic coordination labels, not executable FUND slice identifiers.

No stage is authorised merely because the preceding stage completes. Every executable
slice must be selected by the controlling roadmap and complete the normal lifecycle:

```text
03-slice-planning acceptance
-> bounded implementation
-> 04 implementation confirmation
-> 05 independent review/test
-> authoritative roadmap reconciliation
-> stop before the next slice
```

Where this overview and a current authoritative control differ on status or next action,
the current authoritative control wins.

## 3. Controlling Strategic Inputs

### 3.1 Architecture And Existing Planning

- **FUND Roadmap And Slice Control** —
  `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`
- **IsoStack Commerce Core Roadmap And Slice Control** —
  `docs/core/commerce/00-roadmap-control/2026-07-13-commerce-core-roadmap-and-slice-control.md`
- **FUND Store, Orders And Commerce Core Planning** —
  `docs/modules/fund/03-slice-planning/2026-07-08-fund-phase-1-slice-1r-a-store-orders-commerce-core-planning.md`
- **Event/Catalogue/Product Availability And Workflow Suitability Planning** —
  `docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1q-event-catalogue-product-availability-and-workflow-suitability-planning.md`
- **Project Context And Suitability Testability Remediation Planning** —
  `docs/modules/fund/03-slice-planning/2026-07-08-fund-phase-1-slice-1q-g-a-project-context-and-suitability-testability-remediation-planning.md`
- **C1 Production, Dispatch And Commission Workflow Planning** —
  `docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-i-c1-production-dispatch-commission-workflow-planning.md`
- **FUND Refinement Wishlist And Pilot Placement Control** —
  `docs/modules/fund/00-roadmap-control/2026-07-20-fund-refinement-wishlist-and-slice-control.md`

The refinement register is a subordinate absent-work and placement record. It can add a
proven prerequisite to a strategic stage, but it cannot select or authorise an executable
slice.

### 3.2 Named Change Requests

This overview coordinates, but does not replace, these change requests:

1. **FUND Application Template And Artwork Template Refinement** —
   `docs/modules/fund/01-cr-inputs/2026-07-15-fund-application-artwork-template-refinement.md`
2. **FUND Project Product Selection Limits And Template Capacity Change Request** —
   `docs/modules/fund/01-cr-inputs/2026-07-15-fund-project-product-selection-limits-and-template-capacity-cr.md`
3. **FUND Collective Project Artwork Composition, Approval And Workflow-Aware Product
   Instructions Remedial Clarification** —
   `docs/modules/fund/01-cr-inputs/2026-07-15-fund-collective-project-artwork-composition-approval-and-workflow-aware-product-instructions-remedial-clarification.md`

Each CR remains authoritative for its own accepted business decisions and open questions
until later triage/planning explicitly resolves or supersedes them.

Supporting provenance for the first CR is retained in:

- **FUND Project Template And PDF Generation Roadmap brief** —
  `docs/modules/fund/01-cr-inputs/2026-07-15-fund-template-manager-brief.md`

The brief is source evidence, not a fourth change request or an executable `T`-slice
roadmap. Its provisional `T1`-`T5` labels must be reconciled into the authoritative FUND
slice sequence before any implementation.

## 4. Controlling Domain Distinctions

### 4.1 Project Type / Fundraising Format

A Project has one mutually exclusive Project type/fundraising format:

| Stable code | Client-facing label | Strategic path |
| --- | --- | --- |
| `ARTWORK_FUNDRAISING` | Individual Artwork Project | Application Template, Artwork Template, bounded Product grid and physical/online Order matching |
| `GROUP_PERSONALISED_PRODUCTS` | Group personalised product project | C1 collective Project artwork composition, C2 organiser approval and Product presentation release |
| `BULK_ORDER_CLUB_FUNDED` | Bulk order / club-funded project | Shared collective artwork or an unmodified Product path; ordering may be C2 bulk or individual public Orders under separate policy |
| `NOT_SURE` | Not sure yet | Intake/configuration state that must be resolved before operational Product selection or Store publication |

An unmodified Standard Product is a Product configuration/fulfilment path, not a fourth
Project type.

### 4.2 Product Suitability

Product suitability determines whether a Product from the Event/Standalone Catalogue
source is appropriate to the Project type and organisation context.

It is an eligibility filter. It does not define the Project type, choose the Product for
the Project or replace the Product Workflow Class.

### 4.3 Product Workflow Class

The accepted distinction remains:

- `FundProduct.workflowClassId` is the Product default/initial operational classification;
  and
- `FundProjectProduct.workflowClassId` is the selected Product's operational workflow
  snapshot for that Project.

A single-Project-type Project may contain suitable Products with different compatible
operational Product Workflow Classes. That is not a mixed Project type.

### 4.4 Artwork Template And Collective Project Artwork

An **Artwork Template** is the immutable Project-specific generated document that C2
downloads and distributes for an Individual Artwork Project.

**Collective Project Artwork** is an immutable C1-created shared composition approved by
the exact C2 Project organiser for a Group personalised or applicable Bulk order/club-funded
Project.

They are different aggregates, authorities and physical workflows and must not be
collapsed into a generic `template` or `artwork approved` state.

### 4.5 Project Artwork Approval And Store Product Release

For collective artwork:

- C2 organiser approval locks the exact shared Project artwork composition; and
- C1 Store Product release determines whether a particular Product presentation may appear
  in the Store.

An exceptional Product may remain held for physical-sample or reproduction review without
misrepresenting the Project artwork itself as unapproved.

## 5. Current Foundation Baseline

The authoritative controls currently establish:

- `1Q-E` Project Product eligibility services and `1Q-F` Catalogue-centric selection are
  accepted foundations;
- `1R-C3` provides Project Store, Store Product and immutable Store Product configuration
  versions;
- `1R-C4` provides production asset/version evidence vocabulary but not upload, scanning or
  complete production authority;
- `1R-C5` provides commission policy/assignment evidence but not commission calculation or
  statements;
- `1R-C6` provides typed FUND Commerce context but no runtime checkout behaviour;
- `1R-D` provides internal Store preparation, readiness, configuration and lifecycle
  services but no C1 UI or public Store;
- Commerce A1 through A5 are complete through their accepted lifecycles;
- Commerce A6-A through A6-D and A7 are implemented/reviewed on the unchanged
  140-migration baseline;
- the complete Commerce/A7 foundation bundle was promoted through dev/staging at
  `91e8751c`, and completed E-A/E-B/E-C is now promoted through dev/staging at `e3f44b4b`,
  with green automated gates and healthy staging/database/RLS evidence; prior FUND-admin
  login and pre-existing UI smoke passed, while E-B/E-C human acceptance is blocked by the
  missing default Project Store initiation workflow;
- application `main`, live deployment and real Stripe configuration remain separate; and
- FUND `1R-E - C1 Store Oversight And C2 Project Store Control Alignment` is an accepted
  non-executable parent; its bounded E-A lifecycle is implemented/reviewed at application
  commit `daafc349` on the 141-migration disposable baseline and included in promoted
  application `e3f44b4b`; the configured development database was not migrated in the
  promotion turn, and no direct staging migration inventory was queried locally;
  the bounded E-B portfolio-oversight implementation/review lifecycle is promoted at
  `e3f44b4b` with no E-B schema/migration; and
- `1R-E-C - C2 Project Store Control Surface` is promoted at `e3f44b4b` without an E-C
  migration; its automated evidence passes and human acceptance now awaits controlled
  promotion of E-D plus the recorded real-workflow schedule.
- `1R-E-D - Default Project Store Instantiation And Eligible Product Reconciliation` is
  implemented/reviewed as passed at isolated application `c45a41d9` as the mandatory bridge
  from Project creation to the E-B/E-C surfaces. It uses the existing 141-migration schema,
  retains default-all rather than silently truncating future Individual Artwork selections,
  is not promoted and leaves human workflow acceptance pending controlled promotion.
- `1R-F - Project Offer And Artwork Readiness Reconciliation` is reviewed/accepted as the
  non-executable parent; and
- `1R-F-A - Real AMOW Template, Pricing And Deployed Renderer Proof` is the single next
  planning candidate; implementation is not authorised.

This baseline is a summary only. Commit, migration, deployment and current-next-action
claims must be read from the authoritative controls.

## 6. Definitions Of Completion

The programme should not use `complete` without identifying the level meant.

| Completion level | Required outcome |
| --- | --- |
| **Commerce complete** | Generic checkout, Order, money, connected-account payment, verified webhook, refund and reconciliation services are reliable and reviewed |
| **Transactionally integrated** | A7 can turn an authoritative ready FUND Store offer into a correctly paid Commerce Order with typed FUND Order/line context |
| **Store operational** | C2 can control its Project Store within C1-defined commercial and readiness rules; C1 can oversee all Stores, perform its supplier-side release duties and use only audited exceptional pause/resume/closure/C1-only-reopen authority; a public purchaser can safely browse the currently released offer |
| **Artwork ready** | The applicable Individual Artwork, collective artwork or unmodified Standard Product branch passes its exact readiness contract |
| **Consumer journey complete** | A purchaser can order, pay, receive confirmation/Order Code and safely understand pending, paid, failed and refunded states |
| **AMOW operationally complete** | Artwork intake, scanning, returned-artwork/Order matching and explicit C1 production authorisation work |
| **Fulfilment complete** | Production batching and dispatch/fulfilment are controlled and visible from Project/Client context |
| **Financially complete** | Commission is calculated from accepted aggregate sales evidence, adjusted, finalised and statemented |
| **Release complete** | The whole process is secure, accessible, observable, supportable, retention-controlled and proven in target environments |

`COMMERCE-A7` reaches transactionally integrated. It does not by itself reach Store,
artwork, production, fulfilment, financial or release completion.

## 7. Strategic Dependency Map

```text
Commerce A6-D verified payment/refund reconciliation (complete locally)
-> Commerce A7 thin FUND consumer integration
                     +
FUND 1Q eligibility/selection + 1R-C3/C4/C5/C6 + 1R-D foundations
                     |
                     v
          Project Offer And Artwork Readiness
          |                 |                    |
          |                 |                    |
  Individual Artwork   Group/Bulk collective   Unmodified Standard
  selection limits     artwork/instructions    Product path
  + Artwork Template   + C2 approval           + ordinary readiness
          |                 |                    |
          +-----------------+--------------------+
                            |
                            v
              C2 Project Store control + C1 Store oversight
              -> public Store presentation
              -> checkout and Order confirmation
              -> C1/C2 Order operations
              -> asset intake/scanning and production authorisation
              -> production batching and dispatch
              -> commission calculation/statements
              -> operational hardening and release
```

The branches are conditional requirements derived from trusted Project type, Product
suitability, selected Project Product Workflow Class and immutable Store Product
configuration. A client-supplied `requiresTemplate` or `requiresArtworkApproval` boolean is
not authority.

## 8. Change-Request Traceability

| Change request | Exact strategic scope | Principal stages | Hard completion gates | Explicit exclusions |
| --- | --- | --- | --- | --- |
| **FUND Application Template And Artwork Template Refinement** | `ARTWORK_FUNDRAISING` Application Templates, Project-specific Artwork Templates, generation, delivery and immutable Project-offer lock | Stage 2 Individual Artwork branch; Stages 3–4 integration; Stage 10 print/release QA | Applicable active Application Template Version; exact Store Product/commercial configuration; stable Store URL; successful one-page render; finalised locked Artwork Template Version | Group/Bulk collective composition; Standard Product path; C2 design authority |
| **FUND Project Product Selection Limits And Template Capacity Change Request** | `ARTWORK_FUNDRAISING` default-all Product selection, minimum/maximum selected Project Products and validated Product-grid capacity | Stage 1 C1 visibility; Stage 2 Individual Artwork branch; Stage 3 publication gate | Selection within the pinned minimum/maximum; maximum at or below validated grid capacity; actual Project-specific grid fit | No Group/Bulk/Standard template maximum; no generic non-template Store Product maximum |
| **FUND Collective Project Artwork Composition, Approval And Workflow-Aware Product Instructions Remedial Clarification** | Group/Bulk collective composition; exact organiser approval; workflow-aware C2 Product instructions; Store Product presentation/release; Standard Product boundary | Stage 1 C1 visibility; Stage 2 collective/Standard branches; Stages 3, 6 and 7 integration | C1-created exact artwork version; exact organiser approval and lock; accepted Product presentation; C1 Product release; workflow-aware readiness | No Individual Artwork Template; no checkout approval; no automatic per-Product C2 approval requirement |

The CRs are coordinated but remain separate so their different business boundaries can be
triaged, planned, implemented and reviewed without creating one oversized executable unit.

## 9. Strategic Stage 0 — Commerce Transaction Spine Closure

### Outcome

Build A7 on the completed A6-D boundary so an authoritative ready FUND offer can produce
and reconcile a paid Commerce Order through the tenant's connected Stripe account.

### Existing foundation

- Commerce A1-A5 complete;
- A6-A/A6-B/A6-C/A6-D implemented/reviewed locally with fake-provider and disposable-
  database evidence; and
- FUND Store/configuration and typed Commerce context foundations exist.

A7 implemented/reviewed as a dormant internal transaction spine:

`docs/core/commerce/03-slice-planning/2026-07-15-isostack-commerce-core-slice-commerce-a7-fund-consumer-integration-implementation-planning.md`

Its application ancestry is promoted through dev/staging at `91e8751c`; A7 remains dormant
because no public Store/Checkout route or UI invokes it yet.

### Required proof

A7 and its retained A6-D dependency must prove at least:

- verified connected-account events, not browser return, control Payment state;
- duplicate/out-of-order provider events are safe;
- refunds reconcile independently from Order and FUND production states;
- Checkout accepts authoritative IDs and re-reads price, seller, currency and amount;
- Commerce Order/lines retain exact FUND Project, Store and Store Product context;
- failed, expired and retried checkout behaviour is coherent;
- provider and application idempotency are preserved; and
- paid does not mean artwork accepted or production authorised.

### Completion gate

```text
authoritative ready FUND offer
-> connected-account Checkout
-> verified paid/refunded Commerce evidence
-> typed FUND Order/line context
```

### Still incomplete afterward

C1 oversight/C2 Project Store surfaces, workflow-specific artwork readiness, finished
public Store UX, operational Order surfaces, production, fulfilment and commission remain
separate.

## 10. Strategic Stage 1 — C1 Store Oversight And C2 Project Store Control Alignment (`1R-E`)

### Outcome

Correct the completed `1R-D` C1-only service authority before exposing Store operations.
Normal Project Store control belongs to authorised C2 Client members. C1 receives a
tenant-wide Store overview, supplier-side readiness/release actions and audited exceptional
pause, resume and closure authority.

The Store has no independent opening or closing dates. Its trading window is derived from
the Project's explicit dates and lifecycle. A linked Event prefills those Project dates at
creation and supplies the outer permissible date envelope: C2 may narrow the copied dates,
and a later Event-date change does not cascade automatically into existing Project dates.

### Candidate workstreams

- service/permission alignment before either UI consumes the lifecycle contract;
- C2 Project detail Store tab for normal Store control;
- C1 tenant-wide Store overview and Project Store drill-down;
- Store Product configuration and immutable version inspection;
- Product tax, price, copy, media and input blockers;
- connected-account payment readiness;
- workflow-aware artwork/readiness status;
- Individual Artwork selected/minimum/maximum Product counts;
- Group/Bulk instruction, collective artwork, approval and Product-release status;
- canonical Store URL;
- C2 enable/publish, pause and resume actions within server-enforced Project, Event and
  readiness rules;
- derived non-trading state outside the Project window, without duplicating Store dates;
- audited C1 exceptional pause, resume, closure and C1-only reopen actions for legal,
  payment, safety or seller-of-record intervention, rather than routine C1 moderation; and
- operational exception explanations and remediation links.

### CR implications

All three CRs contribute C1- and C2-visible readiness, but `1R-E` must not implement the
complete editor/generator/composition workflows merely to show their status and actions.
C1 remains authoritative for Product, price, tax, Catalogue eligibility, collective
artwork composition and Store Product presentation release. C2 remains authoritative for
its eligible Project Product selection, commission acceptance, required organiser artwork
approval and normal Project Store operation.

### Completion gate

C2 can identify and resolve the blockers within its authority and perform normal Project
Store transitions; C1 can see every Store and blocker, perform only supplier-side actions
or exceptional audited intervention, and neither surface can bypass the same server-
enforced contract.

### Still incomplete afterward

The public Store and workflow-specific capability implementations may remain incomplete.

## 11. Strategic Stage 2 — Project Offer And Artwork Readiness

This stage is conditional by Project/Product workflow and must not become one monolithic
implementation slice.

### 11.1 Individual Artwork Branch

Applies to:

```text
Project type = ARTWORK_FUNDRAISING
```

Candidate workstreams:

1. real AMOW template, pricing and deployed-renderer proof;
2. Application Template identity/version/assignment and validation foundation;
3. shared Individual Artwork Product-selection limit policy;
4. C1 Application Template basic management and controlled editor;
5. C2 default-all Product selection, preview, finalisation and Project-offer lock;
6. Artwork Template job, renderer, private storage and immutable version;
7. C2 download, secure organiser delivery and C1 operational history; and
8. unlock/revision, visual regression, physical print and QR QA.

Completion gate:

```text
eligible Individual Artwork Products
+ selection within pinned template capacity
+ exact resolved Store commercial configuration
+ stable Store URL
+ successful one-page Artwork Template generation
-> finalised locked Individual Artwork Project offer
```

### 11.2 Group/Bulk Collective Artwork Branch

Applies to Group personalised and applicable Bulk order/club-funded Projects requiring
shared artwork.

Candidate workstreams:

1. existing model, data and terminology reconciliation;
2. Product suitability/Workflow-Class-aware C2 instruction contract;
3. C2 source-asset submission and secure asset handling;
4. Collective Project Artwork identity, immutable versions and source lineage;
5. C1 composition and Product presentation/mock-up creation;
6. exact C2 Project organiser approval/change-request/locking lifecycle;
7. C1 Store Product release and exceptional physical-sample hold; and
8. revision after publication/Orders, history, audit and regression coverage.

Completion gate:

```text
appropriate selected Products
+ required source material
+ C1-created exact Collective Project Artwork Version
+ exact Project organiser approval and lock
+ accepted Product presentations/configurations
+ C1 release for every displayed Store Product
-> collective-artwork Project offer ready for publication
```

C2 approval applies to the shared Project composition, not automatically as a separate
decision for every Product mock-up.

### 11.3 Unmodified Standard Product Branch

Standard Product is not a Project type. It is an unmodified Product path with:

- no Application/Artwork Template;
- no collective Project artwork composition;
- no purchaser modification inputs;
- accepted standard Product/Store Product media; and
- ordinary eligibility, configuration and Store Product readiness.

Completion gate:

```text
suitable selected unmodified Product
+ valid immutable Store Product configuration
+ accepted media/copy/price/tax/input state
+ C1 release where required
-> Standard Product ready for Store display
```

### 11.4 Convergence Rule

A Store may contain only Products valid for the Project's one Project type. Every displayed
Store Product must pass its applicable operational branch. `NOT_SURE` cannot publish.

### 11.5 Pilot And Refinement Gate Before Public Store

The 2026-07-20 reconciliation must inform the real AMOW proof and be applied before work is
accepted beyond `1R-F-A`. It does not create another executable stage.

Before the public Store pilot, planning must distinguish:

- essential purchaser-facing option-to-media authority and Product configuration needed
  for correct choice and immutable Order evidence; from
- rich multi-image gallery merchandising, which follows pilot evidence unless the actual
  AMOW pilot Product set proves it necessary.

Before pilot Intake, confirmation polish and indispensable organiser notifications are
required. Embed/CSP is required only if AMOW confirms embedded Intake. Configurable Event
or Client type options are required only if a pilot option-fit assessment proves the
current bounded choices unsuitable.

Product duplication is a pre-UAT operational accelerator only where repeated AMOW setup
would otherwise be materially slow or error-prone. Public Store correctness must not
depend on duplication.

## 12. Strategic Stage 3 — Public Store Presentation (`1R-G`)

### Outcome

Turn the ready Store offer into a safe, accessible purchaser-facing experience without
duplicating A7 Checkout orchestration.

### Candidate workstreams

- stable public Project Store route;
- Client/Project/Event branding and context;
- current released Store Product list;
- exact locked display copy, images and consumer prices;
- Product option, option-to-media and purchaser-input controls required by the authoritative
  pilot offer;
- unavailable, unpublished, not-yet-open, paused and closed states;
- basket/selection behaviour;
- mobile and accessibility support; and
- transition into the A7 checkout invocation.

### CR implications

- Individual Artwork Store Products must match the locked Artwork Template offer.
- Group/Bulk Product images must derive from the accepted presentation/release contract.
- Standard Products use accepted standard presentation evidence.

### Completion gate

A purchaser can browse only the authoritative currently released offer and cannot invoke
checkout against stale, hidden, held or unready Store Product configuration.

## 13. Strategic Stage 4 — Consumer Order Completion And Communications

### Outcome

Complete the purchaser journey around the A7 payment invocation.

### Candidate workstreams

- purchaser/contact evidence;
- authoritative five-digit Order Code policy and generation;
- pending-payment, paid, failed, cancelled and expired experiences;
- confirmation/receipt and Order summary;
- transactional confirmation email containing the Order Code;
- indispensable Project-organiser notifications required by the pilot workflow;
- safe retry and duplicate-submission protection;
- refund communication; and
- workflow-appropriate artwork backup-upload prompt.

### Boundary

Browser return is advisory. Only verified Commerce provider evidence controls Payment
state. Checkout performs no C2 collective-artwork approval and no C1 production
authorisation.

Transactional and bounded pilot-lifecycle messages must reuse the existing LMSPro sequence
engine, Resend delivery and shared rendering/scheduling/retry methods. FUND adds only its
domain triggers, recipient authority, templates and bounded management surfaces; it does
not create a parallel communications engine.

The general Event/Project campaign editor is intentionally separate from transactional
completion. It is a required pre-wider-rollout sales-promotion capability for configurable
sequences and timely nudges that help Project owners complete setup, promote Stores and
improve sales.

### Completion gate

The purchaser receives durable, non-ambiguous Order/payment evidence and the Order Code
needed by the applicable physical/production workflow.

## 14. Strategic Stage 5 — C1 And C2 Order Operations

### Outcome

Make paid/refunded Orders operationally visible within correct role and privacy boundaries.

### Candidate workstreams

- C1 Project Order list and Order detail;
- Payment/refund and reconciliation evidence;
- Order Code search and matching;
- Product quantities, options, inputs and production requirements;
- safe purchaser/contact visibility;
- C1 exception/refund initiation where authorised;
- failed-event/reconciliation work queue;
- C2 Project-scoped sales summary/detail under accepted privacy rules; and
- public purchaser status access under a separate secure contract where required.

### Completion gate

C1 can diagnose and operate Orders; C2 sees only its authorised Project/Client sales
context; neither surface confuses Payment state with production authority.

## 15. Strategic Stage 6 — Upload, Scanning And Artwork Intake

### Outcome

Activate the `1R-C4` asset/version foundation through secure, typed asset services.

### Candidate workstreams

- managed upload initiation/completion;
- actual MIME/content inspection;
- size/type allowlists and SHA-256 evidence;
- malware scanning, quarantine and rejection;
- private authenticated/signed download;
- version, replacement and retention behaviour;
- C2 Project source-artwork/data uploads;
- C1 composite/presentation asset creation;
- purchaser Order-line backup artwork; and
- C1 review/selection of production-authoritative assets.

### Boundary

C2 Project source assets, C1 collective/presentation assets, purchaser backup artwork and
generated Artwork Template PDFs retain different purposes, authorities and retention
semantics.

### Completion gate

Every asset used by Store presentation or production has verified tenant ownership,
inspected content, immutable version/provenance evidence and an authorised purpose.

## 16. Strategic Stage 7 — Production Matching And Authorisation

### Outcome

Turn paid Orders plus valid artwork/data into explicitly authorised production work.

### Candidate workstreams

1. production state and authority contract;
2. Project/Order/Order-line artwork and data readiness;
3. Order Code and returned physical Artwork Template matching for Individual Artwork;
4. approved collective-artwork and purchaser-input matching for Group/Bulk products;
5. backup-source selection where physical originals are unavailable;
6. C1 artwork/data checks and exception handling; and
7. explicit C1 production authorisation.

### Central rule

```text
paid Commerce evidence
+ required physical/digital artwork or data
+ asset scanning/review passed
+ Order/Project/Product details reconciled
+ workflow-specific approval/lock evidence
+ explicit C1 authorisation
-> production eligible
```

Payment alone must never trigger production.

## 17. Strategic Stage 8 — Production Batching And Dispatch

### Outcome

Group authorised production efficiently while retaining exact Project, Client, Order and
Product context through fulfilment.

### Candidate workstreams

- production grouping by Product/workflow/Event/deadline;
- batch identity and lifecycle separate from Project status;
- line/item membership and exception handling;
- Project-level production progress projection;
- delivery-profile resolution;
- grouped and partial dispatch;
- dispatch notes/evidence; and
- C1/C2 status visibility under accepted permissions.

### Completion gate

Every produced item remains traceable from batch and dispatch evidence back to its exact
Order line, Store Product configuration, Project and authoritative artwork/input evidence.

## 18. Strategic Stage 9 — Commission Calculation And Statements

### Outcome

Convert immutable paid/refunded Project sales evidence and accepted commission policies
into aggregate commission calculations, statements and settlement evidence.

### Candidate workstreams

1. eligible Project-sales aggregation;
2. applicable flat/ladder policy and immutable policy evidence;
3. refund, cancellation and adjustment treatment;
4. accepted recognition/finalisation event;
5. immutable commission statement;
6. C1 reporting and controlled adjustments;
7. C2 statement visibility/acceptance where required; and
8. payment/settlement recording.

### Boundary

Commission is not an independently rounded final payable amount on each Stripe payment.
Order lines supply sales evidence; payable commission is calculated at the accepted
aggregate Project boundary.

### Completion gate

Later policy changes cannot rewrite finalised historic commission, and every statement is
reconcilable to immutable Commerce/FUND evidence and adjustments.

## 19. Strategic Stage 10 — Release Hardening And Promotion

### Outcome

Prove the complete operational chain in target environments and make it supportable.

### Cross-capability gates

- real connected-account test coverage;
- delayed, duplicated and out-of-order webhook testing;
- reconciliation/support procedures;
- tenant and role isolation;
- audit, retention and secure-object access;
- accessibility and mobile testing;
- print/QR and physical-workflow QA;
- asset scanning and quarantine operations;
- background-worker retry, stale-claim and graceful-shutdown tests;
- monitoring, safe diagnostics and operational alerts;
- backup/recovery;
- staging promotion and business UAT; and
- controlled live rollout/rollback.

Before wider rollout, the programme must also schedule the accepted refinement set:

- general Event/Project campaign editor and promotional nudge sequences;
- aligned email content editor experience;
- Client dashboard announcements;
- richer Catalogue merchandising;
- Catalogue duplication built on the proven Product-duplication primitive; and
- reusable Product type/option templates.

Tenant terminology, dashboard widget standardisation and workflow grouping remain
post-pilot evidence-led refinements unless the authoritative roadmap promotes them earlier.

### Completion gate

The complete path is secure, observable, recoverable and operationally owned from Project
setup through payment, production, dispatch and commission.

## 20. Recommended Strategic Sequence

The strategic dependency order is:

```text
A6-D lifecycle complete
-> A7 thin FUND consumer integration complete and promoted through staging
-> 1R-E C1 Store oversight and C2 Project Store control alignment
   (parent accepted)
-> 1R-E-A Store authority/intervention service implemented/reviewed locally
-> 1R-E-B C1 Store portfolio oversight and exceptional intervention surface
   implemented/reviewed as passed locally; no shared deployment
-> 1R-E-C C2 Project Store control surface
   implemented/reviewed/promoted; human acceptance pending promoted E-D workflow
-> 1R-E-D Default Project Store instantiation and eligible Product reconciliation
   implemented/reviewed at isolated application c45a41d9; no migration; not promoted
-> 1R-F workflow-conditional Project Offer And Artwork Readiness parent accepted
-> 1R-F-A Real AMOW Template, Pricing And Deployed Renderer Proof
   single next planning candidate; proof implementation not authorised
-> apply confirmed pilot gates: Intake confirmation/conditional embed and type fit,
   essential purchaser option/media authority, required messages and evidence-led
   Product duplication
-> 1R-G public Store presentation
-> consumer Order completion and Order Code
-> C1/C2 Order operations
-> upload/scanning and typed artwork intake
-> production matching and authorisation
-> production batching and dispatch
-> commission calculation and statements
-> wider-rollout campaign editor, promotional sequences and accepted merchandising/setup
   refinements
-> full release hardening
```

This does not require every future UI or schema slice to be implemented in one strictly
linear series. Planning proofs and schema-option work may be discussed earlier where safe.
Implementation order remains controlled one bounded lifecycle at a time unless the user
and authoritative roadmap explicitly authorise otherwise.

## 21. Cross-Stage Non-Negotiable Gates

1. A public Store never exposes raw Catalogue membership; it exposes ready, released
   Project Store Products.
2. Store and Artwork Template pricing consume the same immutable resolved commercial
   evidence.
3. Project type, Product suitability and Product Workflow Class remain distinct.
4. `NOT_SURE` cannot become Store-ready.
5. Individual Artwork template-capacity limits do not apply to Group/Bulk/Standard paths.
6. Collective artwork is created by C1 and approved by the exact C2 Project organiser.
7. Collective-artwork approval locks one exact Project artwork version; Product release is
   separately controlled by C1.
8. Checkout never performs artwork approval or production authorisation.
9. Browser return never marks a Payment paid.
10. Paid never means production authorised.
11. Historic Artwork Template, collective artwork, Store Product, Order and commission
    evidence is not silently rewritten.
12. Generated documents and production assets use secure managed storage and typed access.
13. Commission is based on accepted aggregate Project sales evidence, not an incidental
    per-payment calculation.
14. FUND communications reuse the existing LMSPro sequence and Resend delivery
    infrastructure; owning workflows define transactional events, while the general
    Event/Project campaign editor remains a bounded wider-rollout capability.

## 22. Converting Strategic Workstreams Into Slices

Before a workstream becomes executable, planning must:

1. reconcile the latest root, Commerce and FUND controls;
2. identify the owning lane;
3. identify the exact CR decisions and open questions in scope;
4. inspect existing schema/services/UI rather than assume a gap;
5. define one bounded outcome and explicit non-goals;
6. assign a non-conflicting slice identifier through roadmap control;
7. define migration/data/tenant/permission/rollback policy where relevant;
8. define automated, disposable-database, browser, visual, physical or provider evidence
   proportionate to risk;
9. accept the `03-slice-planning` document before implementation; and
10. stop after its `04` and `05` lifecycle until the roadmap selects another slice.

The strategic stages must not be copied directly into implementation prompts.

## 23. Open-Question Routing

This overview does not duplicate every CR question. Later planning must read the relevant
source CR in full.

Use:

- the Application/Artwork Template CR for renderer, assignment, authority, lock, secure
  delivery, print and Order Code questions;
- the Product-selection limits CR for Individual Artwork maximum, eligible-pool warning,
  legacy Project and printable-row questions; and
- the Collective Project Artwork CR for instruction ownership, Group/Bulk selection
  authority, source completion, presentation generation, Product release, physical sample,
  revision and Standard Product Workflow Class questions.

Cross-CR decisions that affect more than one aggregate must be resolved in the later parent
planning/reconciliation document and reflected back into every affected CR or accepted
successor.

## 24. Maintenance Rule

This is a living strategic overview, updated in place.

When a related CR is accepted/refined or a strategic workstream becomes a planned,
implemented or reviewed slice:

- update `Last consolidated`;
- add the accepted slice reference under the applicable stage;
- change no stage status without support from the authoritative roadmap;
- keep commit, migration, deployment and current-next-action detail in the authoritative
  controls rather than duplicating it here;
- update the CR traceability table when scope changes;
- reconcile promoted pilot/refinement decisions with the 2026-07-20 register;
- preserve resolved terminology; and
- verify that the overview still does not compete with current slice authority.

The authoritative FUND roadmap and this folder's README should retain a concise link to
this overview. They should not duplicate its full strategic content.

## 25. Strategic Handoff

The current executable action remains whatever the root, Commerce and FUND controls state.
At the current consolidation point, A6-D and the bounded `COMMERCE-A7 - FUND Consumer
Integration` are implemented/reviewed, and their application ancestry is promoted through
dev/staging at `91e8751c`. The A7 plan is retained at:

`docs/core/commerce/03-slice-planning/2026-07-15-isostack-commerce-core-slice-commerce-a7-fund-consumer-integration-implementation-planning.md`

A7 implementation commit `598305ce` remains a dormant internal boundary with no public
surface or real provider action. Staging health and human smoke gates passed. The FUND
`1R-E - C1 Store Oversight And C2 Project Store Control Alignment` parent plan is reviewed
and accepted at:

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-c1-store-oversight-c2-project-store-control-alignment-planning.md`

The E-A implementation plan is created at:

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-a-store-authority-exceptional-intervention-lifecycle-service-alignment-implementation-planning.md`

Its local implementation and review/test lifecycle passed against the complete
141-migration disposable baseline with zero residue. E-A/E-B/E-C are now promoted through
dev/staging at `e3f44b4b`. The bounded `1R-E-B - C1 Store Portfolio Oversight And
Exceptional Intervention Surface` implementation/review lifecycle passed and is committed
without an E-B schema or migration change. `1R-E-C - C2 Project Store Control Surface` is
included in the same promoted application commit without an E-C migration. Human-smoke
preparation then exposed the missing mandatory Project-to-Store/default-Product workflow.
E-D has now implemented that correction locally; E-B/E-C human acceptance awaits controlled
promotion and the schedule recorded in the E-D review at
`docs/modules/fund/03-slice-planning/2026-07-21-fund-phase-1-slice-1r-e-d-default-project-store-instantiation-eligible-product-reconciliation-implementation-planning.md`.
The reconciled
`1R-F - Project Offer And Artwork Readiness` parent is reviewed/accepted at:

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-f-project-offer-artwork-readiness-reconciliation-planning.md`

It allocates separate Individual, collective and Standard Product readiness branches
after `1R-E`; the formerly reserved Public Store slice moves to `1R-G`. E-D is
implemented/reviewed locally at `c45a41d9`. `1R-F-A - Real AMOW Template, Pricing And
Deployed Renderer Proof` is the single next planning candidate. This document authorises no
proof implementation, `1R-G` or artwork/template production implementation.

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-b-c1-store-portfolio-oversight-exceptional-intervention-surface-implementation-planning.md`

A7 planning must read the three CRs but remain a thin consumer boundary. It may preserve
typed workflow, immutable Store/configuration and input/asset references needed by the
accepted Commerce/FUND contract; it must not absorb Application/Artwork Template design,
collective artwork approval, Store-management/public-Store UI, production, fulfilment or
commission work. Those capabilities remain later FUND workstreams selected through the
authoritative roadmap.

The created 1R-E parent performs the first reconciliation of:

- `1R-E` C1 Store oversight, C2 Project Store control and service-authority alignment;
- the three named CRs;
- workflow-aware `1R-D` readiness extensions;
- `1R-G` public Store boundaries; and
- the exact parent/child split for Individual Artwork and collective Project artwork.

The parent originally allocated bounded E-A, E-B and E-C lifecycle candidates without
consuming `1R-G` or unrelated roadmap reservations. Post-promotion testability review adds
corrective E-D for mandatory default Project Store/Product initiation. Every child requires
separate planning, acceptance, implementation and review/test records.
