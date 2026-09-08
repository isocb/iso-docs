# CR-Fix — FUND Catalogue-Led Product Availability and Event/Project Workflow Authority

Date: 2026-09-08

Status: **Captured; awaiting triage and roadmap selection. Business requirement confirmed by Chris; no implementation authorised by capture.**

Owning lane: FUND. Source: B1 local smoke and owner clarification.
Proposed control depth: **High**, to be confirmed in triage — workflow authority, tenant
scope, readiness, schema migration and immutable offer/Order evidence are affected.

## 1. Confirmed Business Requirement — Refined After Catalogue Discussion

This refinement supersedes the earlier proposal for Product workflow-suitability flags,
including an all-selected multiselect. The existing CR path is retained for continuity;
its final requirement is simplification, not another Product classification control.

- Create a Product once. Shared description, images and commercial configuration must not
  be duplicated merely to support different production workflows.
- The producer curates that Product into one or more Catalogues. Catalogue membership and
  availability are authoritative for where it may be offered.
- For Event-linked Projects, available Event-assigned Catalogues supply the Product set;
  the Event determines the workflow, consistently inherited by its linked Projects.
- For standalone Projects, Catalogues made available to that context supply the Product
  set; the Project determines its own workflow.
- C2 selects the Project's subset from that available set. C2 cannot broaden availability.
- Remove the mandatory Product-level Production Workflow Class choice. Resolve operational
  workflow from Event/Project context wherever the current implementation consumes it.
- Remove the separate Product Suitability eligibility gate. Do not replace it with hidden
  workflow flags, mandatory exceptions, or another Product-level veto over Catalogue choices.
- Purchasers see the selected subset once applicable price, artwork and release/readiness
  requirements are satisfied. These requirements remain; they must explain concrete missing
  facts rather than demand repeated classification. Selection does not itself publish.
- Preserve finalised offers and Order evidence; do not reinterpret their recorded facts
  when Catalogue membership or the current Product changes.

```text
Product -> Catalogue membership -> Event/standalone availability -> C2 Project subset -> ready/released sale subset
Workflow authority: Event for linked Projects; Project for standalone Projects
```

### Manufacturing Change — Required Acceptance Example

One Ceramic Mug is initially offered through Catalogues for several workflows. A manufacturing
change makes it unsuitable for one workflow. C1 removes it from the relevant Catalogue(s),
or adjusts Catalogue availability where the whole range is affected. That is the producer's
compatibility decision: C1 must not then revisit Product Suitability to make it effective.
If manufacturing later enables another use, C1 adds the same Product to the relevant range.
No duplicate Product, second suitability edit or unexplained Product-class blocker is needed.

Catalogue reuse is deliberate: changing membership affects every context supplied through
that Catalogue. The UI should make that reach understandable. Removing one source does not
withdraw a Product if another available Catalogue still supplies it. Do not introduce a new
per-Product/per-Event gate to conceal this multi-source behaviour.

### Acceptance Criteria

1. One Ceramic Mug record is used by Projects with different workflows without duplication.
2. Product creation has no mandatory Production Workflow Class or suitability configuration.
3. Catalogue membership and availability make the Product selectable without another
   Product-suitability step, subject to ordinary active/status rules.
4. Event-linked and standalone Projects resolve their workflow from the correct authority;
   C2 selection remains a subset of the available Catalogue range.
5. The manufacturing-change example works in both directions with no second Product edit.
6. The same Product appearing in several available Catalogues appears once in the Project
   selection, with its source attribution retained.
7. Price/artwork/readiness failures remain specific and understandable; no legacy suitability
   veto survives in UI, API, selection refresh, Store readiness or checkout.
8. Catalogue changes have explicit effects on draft selections and future sale availability,
   while confirmed offer and Order evidence remains unchanged.

### Change Handling To Resolve In Bounded Planning

For an unfinalised Project, evaluate current Catalogue availability when selecting or
refreshing Products. A Product losing its final available source cannot silently remain
eligible; explain the affected selection and required action. Planning must choose whether
that action is automatic deselection or an explicit blocked selection with C2 acknowledgement.
Adding availability makes a Product available for selection; it must not silently override
C2's curated subset. Reconcile this with existing default-all selection behaviour.

For finalised offers, published Stores and Orders, preserve snapshots and agreed prices.
Planning must distinguish withdrawal from future sales from alteration of historic evidence,
and decide how an operational hold is applied when manufacturing prevents fulfilment.
No automatic unlock, replacement, repricing, Order deletion or retroactive reclassification
is authorised here. Reuse the existing intervention mechanism where appropriate; do not
invent historical-customer remediation under the no-user position below.

## 2. Owner-Confirmed Data And User Position — Important

Chris explicitly states that FUND has **no users until he specifically says otherwise**,
and **no existing FUND data requires remedial conversion**. The development test bed may
be recreated; he is happy to recreate it while the model is being corrected.

Planning must not invent an existing-customer migration, classification-remediation campaign,
legacy adoption programme or prolonged compatibility period for nonexistent operational
FUND data. Assess current Product fields to design the corrected model, not to manufacture
historical data-repair work.

**Staging still requires a versioned schema migration.** No users does not mean no schema,
no migration history or permission to reset a shared environment. The eventual plan should
choose the simplest safe schema transition under this confirmed no-user/no-remediation
assumption, with target verification and repeatable migration evidence. No reset, data
recreation or migration is performed by this CR capture. Non-FUND tenant/user/Commerce data
is outside any permission to recreate FUND development fixtures.

Finalised-offer and Order protection remains a design invariant and a synthetic regression
case, not a claim that operational historical FUND Orders exist. If contrary data appears,
report the discrepancy and reconcile it with Chris before changing that evidence.

## 3. Observed Implementation Mismatch

Application inspected: `57e1454b530ae19dc586768fd996ff230d84421c`, B1 work branch.

- `ProductModal.tsx` requires one `workflowClassId` at Product creation.
- `FundProduct` has a mandatory single Workflow Class foreign key; `FundProjectProduct`
  also stores a Workflow Class reference.
- A separate `FundProductProjectTypeSuitability` relation already supports Project-type
  suitability. This extra veto must be retired from the Catalogue-led eligibility contract.
- B1 readiness reads the Product's Workflow Class, including `requiresGroupArtwork`.
  Workflow consumers therefore need review before moving authority away from the Product.
- The eligibility service already resolves Event Catalogues, deduplicates Products across
  sources, then applies Project-type and organisation-type Product suitability filters.
  Inventory both filters so the retired Product Suitability gate cannot survive indirectly.
- Standalone sourcing currently uses default standalone Catalogues (or the sole available
  Catalogue), not arbitrary per-Project assignment. Planning must reconcile the required
  standalone availability experience rather than claiming it already exists.

Relevant paths in isostack-bedrock: `prisma/schema.prisma`,
`src/modules/fund/components/products/ProductModal.tsx`,
`src/modules/fund/services/products.service.ts`,
`src/modules/fund/services/product-eligibility.service.ts`, and
`src/modules/fund/services/individual-offer.service.ts`.

Reproduction: create a Ceramic Mug intended for several workflows. The mandatory single
Product class cannot express compatibility without attaching one set of production rules
or duplicating the Product. The earlier empty-selector issue was separately repaired by
restoring missing reference rows; that repair does not resolve this structural mismatch.
The last inspected source baseline is known; no prior correctly implemented authority model
has been established. This is a confirmed design mismatch, not a claimed recent regression.

## 4. Impact, Containment And B1 Acceptance

Severity: significant functional/design blocker to representative FUND workflow acceptance;
not a live-user incident. C1 would otherwise maintain duplicate Products, while C2 eligibility,
artwork readiness and downstream fulfilment could follow the wrong authority.

Current containment: no implementation or promotion from this CR; B1 remains open on its
work branch. Current UI testing can expose other issues, but choosing an arbitrary Product
class or making duplicate Products is not acceptance of the intended model.

**Capture assessment: this mismatch must be resolved before B1 can be accepted as conforming
to the clarified workflow-authority requirement.** Existing B1 test results retain their
original technical scope; they are not erased or elevated into business acceptance. Triage
must explicitly record whether the correction precedes B1 closure or whether the owner
accepts a precisely bounded partial B1 disposition with the defect still open. The default
at capture is that overall acceptance remains pending, not that B1 is silently complete.

No emergency expedite is proposed: there are no FUND users. Triage must decide sequencing
relative to B1 and the proposed 1R-G plan through root/FUND controls. Capture does not select
a new Now/Next. B1 retains the sole active restart checkpoint.

## 5. Required Triage And Planning Assessment

Before selecting implementation slices, assess:

1. Exact relationship between existing Project types and A1/A2/B/C Workflow Classes;
   one explicit authority-resolution contract, including unresolved Project type behaviour.
2. Removal of Product-owned Workflow Class and separate Product Suitability gates, including
   validation, relation/schema retirement, filtering and explanatory UI; replace operational
   consumers with Event/Project-derived workflow and the required immutable context evidence.
3. Event workflow persistence, Project creation/Intake inheritance, mismatch refusal and
   standalone workflow selection; authority for later changes and affected Project selections.
4. Catalogue membership and Event/standalone availability as the sole compatibility-scoping
   mechanism; multi-source removal, default-all versus C2 selection, and manufacturing-change
   effects on draft selections, finalised offers and future sales; enforce consistently
   outside UI paths and identify the smallest change to standalone Catalogue assignment.
5. B1 templates/offer locks, workflow-aware instructions, collective/Standard readiness,
   public presentation, Commerce submission/context, production and fulfilment consumers.
6. Minimal local/staging schema migration without legacy FUND data remediation; preservation
   of non-FUND data and synthetic immutable-evidence tests; failure/rollback boundaries.
7. Meaningful same-Product/multiple-workflow, Catalogue manufacturing delta, wrong-Event/tenant,
   no-suitability-veto, multi-Catalogue deduplication/source removal, exclusion, stale-selection,
   readiness and finalised-offer/Order negative tests, followed by C1/C2 human acceptance.

Keep business definition, schema design and delivery ordering distinct. Do not assume this
is one UI change, or pre-allocate a large sequence before examining actual dependencies.

## 6. Lifecycle And Non-Goals

Required route: **CR -> triage -> roadmap selection -> bounded planning -> implementation
-> 04 confirmation -> 05 independent review/test -> human acceptance -> controlled promotion**.

This pass creates the CR and its registration/evidence links only. No code, schema, database,
configuration, reset, production infrastructure, checkout/payment feature or environment
promotion is authorised by capture. Future implementation records must state actual changes,
exact commits and evidence; do not create empty 04/05 completion records for this CR now.

Safe resumption: triage this CR against the confirmed no-user/no-remediation position and
B1 findings, record the acceptance/dependency decision, then select bounded planning through
the existing roadmaps. Preserve the running local test bed until an actual recreation step
is needed and its scope is explicit.

## 7. Related Authority And Evidence

- [FUND roadmap](../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md)
- [B1 plan/checkpoint](../03-slice-planning/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md)
- [B1 review and smoke findings](../05-review-and-test/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-review-and-test.md)
- [Prior suitability clarification](2026-07-08-fund-cr-project-context-and-suitability-testability-remediation-input.md)
- [Prior workflow-aware instructions input](2026-07-15-fund-collective-project-artwork-composition-approval-and-workflow-aware-product-instructions-remedial-clarification.md)
- [Separate missing-reference-data repair](CR-Fix-2026-09-08-fund-local-workflow-class-reference-data.md)
- [English situation report](../00-roadmap-control/2026-08-25-fund-complete-module-smoke-readiness-business-overview.md)

The confirmed definition here supersedes conflicting Product-owned-workflow and separate
Product-suitability-veto assumptions in earlier inputs for subsequent triage. Historical records and their original
evidence remain preserved; their existence is not acceptance of the now-identified mismatch.
