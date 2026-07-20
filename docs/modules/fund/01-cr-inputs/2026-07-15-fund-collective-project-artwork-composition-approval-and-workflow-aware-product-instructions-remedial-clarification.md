# FUND Collective Project Artwork Composition, Approval And Workflow-Aware Product Instructions Remedial Clarification

Date: 2026-07-15

Status: Draft change-request input for refinement and roadmap reconciliation; planning and
documentation only

Related change requests by name:

- **FUND Application Template And Artwork Template Refinement** —
  `docs/modules/fund/01-cr-inputs/2026-07-15-fund-application-artwork-template-refinement.md`
- **FUND Project Product Selection Limits And Template Capacity Change Request** —
  `docs/modules/fund/01-cr-inputs/2026-07-15-fund-project-product-selection-limits-and-template-capacity-cr.md`

Authoritative roadmap:

`docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

Accepted reconciliation successor:

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-f-project-offer-artwork-readiness-reconciliation-planning.md`

The successor preserves this CR as governed source evidence, confirms the separate
collective/Standard branches and routes their typed evidence and service/UI work to
bounded `1R-F-F` through `1R-F-I`. The formerly reserved public Store slice moves to
`1R-G` so alphabetical identifiers continue to express delivery order. This input still
does not itself authorise implementation.

Controlling availability and suitability planning:

- `docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1q-event-catalogue-product-availability-and-workflow-suitability-planning.md`
- `docs/modules/fund/03-slice-planning/2026-07-08-fund-phase-1-slice-1q-g-a-project-context-and-suitability-testability-remediation-planning.md`

Related accepted foundations:

- `1C` Product Workflow Classes;
- `1Q-E` Project Product eligibility services;
- `1Q-F` Catalogue-centric Project Product selection;
- `1R-C3` Project Store, Store Product and immutable Store Product configuration versions;
- `1R-C4` production asset/version foundation; and
- `1R-D` Store readiness and C1 Store configuration services.

This document is a remedial clarification of downstream workflow behaviour. It does not
introduce new Project-type nomenclature and does not authorise schema, migration, service,
UI, infrastructure, deployment or implementation work.

## 1. Purpose

The established FUND availability model already distinguishes:

- Project type/fundraising format;
- Product suitability; and
- Product Workflow Class.

This change request preserves that nomenclature and clarifies the missing operational
contract for collective Project artwork used by Group personalised product and applicable
Bulk order/club-funded Projects.

The clarification establishes that:

- C1 creates the collective Project artwork composition;
- the exact C2 Project organiser approves the Project artwork before the Store opens;
- approval locks an exact immutable Project artwork version;
- one approved Project artwork composition may be applied to several suitable Products;
- C1 manages workflow-aware, Product-specific C2 instructions through Product Manager;
- each Store Product requires an approved/released presentation before it appears in the
  Store, while exceptional physical-sample approval can remain a C1-controlled hold; and
- the Application Template, Artwork Template and template-capacity selection-limit
  contracts apply only to Individual Artwork Projects.

## 2. Controlling Nomenclature

The previously accepted nomenclature remains authoritative. Later planning and UI must not
collapse the following concepts.

### 2.1 Project Type / Fundraising Format

A Project carries one mutually exclusive Project type/fundraising format.

The established initial codes and client-facing labels are:

| Stable code | Client-facing label | Operational meaning |
| --- | --- | --- |
| `ARTWORK_FUNDRAISING` | Individual Artwork Project | Individual child/participant artwork workflow using the separate Application Template and Artwork Template capability |
| `GROUP_PERSONALISED_PRODUCTS` | Group personalised product project | Several supplied files/elements are composed by C1 into collective Project artwork |
| `BULK_ORDER_CLUB_FUNDED` | Bulk order / club-funded project | Shared organisation/club artwork or an unmodified Product offer, regardless of whether C2 orders in bulk or parents order individually |
| `NOT_SURE` | Not sure yet | Intake/configuration state that must be resolved before operational Product selection, artwork readiness or Store publication |

The Project type is Product eligibility context, not merely a reporting label. A Project
must not offer more than one Project type.

`BULK_ORDER_CLUB_FUNDED` does not determine the purchasing channel or purchaser count. The
same Project type may support one C2 bulk Order or multiple individual parent Orders through
the Store under separately accepted ordering policy.

### 2.2 Product Suitability

Product suitability answers whether a Product is appropriate for a Project type and
organisation context.

It:

- filters the Products in the Event/Standalone Catalogue source set;
- may permit one Product to support several Project types;
- excludes Products inappropriate to the Project context;
- remains distinct from Project Product selection; and
- does not by itself define how an eligible Product is produced.

Catalogue availability remains the source list. Product suitability filters that list.
Active `FundProjectProduct` membership remains the selected Product list.

### 2.3 Product Workflow Class

The accepted interpretation remains:

- `FundProduct.workflowClassId` is the Product default/initial operational classification;
  and
- `FundProjectProduct.workflowClassId` is the operational workflow snapshot for that
  Product in that Project.

Product Workflow Class describes production/fulfilment behaviour. It must not replace the
multi-select Product suitability rules that decide whether the Product is available to a
Project type.

A single-Project-type Project may contain several suitable Products with different
compatible operational Product Workflow Classes. That is not a mixed Project type.

### 2.4 Standard Product

A **Standard Product** is an unmodified Product configuration/fulfilment path, not a fourth
Project type.

It has:

- no Project artwork modification;
- no purchaser modification inputs;
- no collective artwork composition or C2 artwork approval gate; and
- ordinary Product media, Store Product configuration and Store readiness requirements.

Planning must identify the accepted Product Workflow Class representation for this path
without introducing a new Project-type code.

### 2.5 Collective Project Artwork

**Collective Project Artwork** is the Project-level composition created by C1 for a
`GROUP_PERSONALISED_PRODUCTS` Project or an applicable `BULK_ORDER_CLUB_FUNDED` Project.

It is not:

- an Application Template;
- an Artwork Template;
- a purchaser's Individual Artwork submission;
- a per-Product approval decision; or
- an editable Store Product image without version/provenance evidence.

One approved Collective Project Artwork Version may be applied to several suitable Project
Products.

## 3. Workflow Relationship

The controlling relationship is:

```text
one Project type / fundraising format
-> Event or Standalone Catalogue availability
-> Product suitability filters eligible Products
-> selected FundProjectProducts
-> each selected Product records its operational Product Workflow Class
-> workflow-aware instructions, artwork, inputs and Store-readiness gates
```

`NOT_SURE` cannot become Store-ready. C1 must first resolve it to one concrete operational
Project type and re-evaluate Product eligibility.

## 4. Workflow-Aware Operational Matrix

| Project/Product path | Product eligibility and selection | Artwork preparation | Pre-Store artwork gate | Presentation image |
| --- | --- | --- | --- | --- |
| Individual Artwork Project | Product suitability followed by C2 selection; Individual Artwork default-all and template-capacity minimum/maximum rules apply | C1 Application Template resolves into a Project-specific Artwork Template distributed by C2 | Artwork Template finalisation and Project-offer lock; no advance C2 approval of each child's later artwork | Accepted Product/Store Product presentation media |
| Group personalised product project | Product suitability excludes Products unable to support the Project context; selected Products retain operational Workflow Class snapshots | C1 composes several supplied files/elements into one collective Project artwork | Exact C2 Project organiser approves and locks the collective Project artwork before Store opening | Product presentations/mock-ups derived from the approved Project artwork and released by C1 |
| Bulk order / club-funded project with shared artwork | Product suitability excludes inappropriate Products; ordering may be C2 bulk or individual public Orders | C1 composes/prepares the shared logo/artwork | Exact C2 Project organiser approves and locks the collective Project artwork before Store opening | Product presentations/mock-ups derived from the approved Project artwork and released by C1 |
| Unmodified Standard Product path | Product remains subject to Catalogue availability, Product suitability, Project selection and ordinary Store readiness | None | No collective artwork approval | Accepted standard Product/Store Product media |

The matrix is a planning contract. Exact Workflow Class codes, schema ownership and UI
labels require a bounded model audit before implementation.

## 5. Collective Project Artwork Lifecycle

The initial lifecycle should support:

```text
C2 reviews Product-specific preparation instructions
-> C2 supplies required Project source files/data
-> C1 validates the supplied material
-> C1 creates a collective Project artwork composition
-> C1 prepares representative Product presentations/mock-ups
-> C1 submits the Project artwork to the exact Project organiser
-> organiser approves or requests changes
-> approval locks the exact Collective Project Artwork Version
-> eligible Product presentations may be released
-> Store publication proceeds only when all other readiness gates pass
```

Planning should use explicit states with safe equivalents of:

- awaiting source material;
- composition in progress;
- awaiting C2 approval;
- changes required;
- approved and locked; and
- superseded.

The exact state names must follow accepted FUND conventions and must not conflate upload,
malware-scan, artwork-review, Store Product readiness or Store lifecycle state.

## 6. Creation And Approval Authority

### 6.1 C1 Composition Authority

C1 always creates or records the collective Project artwork composition. C1 may consume
source assets supplied by C2, but C2 does not publish its own file as approved collective
artwork merely by uploading it.

The C1 actor and exact source/current version evidence must be auditable.

### 6.2 C2 Approval Authority

The exact `FundProject.organiserMemberId` is the initial C2 approval authority.

Approval must not be inferred from:

- general Client membership;
- an uploader identity;
- an email recipient alone;
- a public link without the accepted secure authority contract; or
- a C1 composition action.

Any later delegation or substitute-organiser approval requires a separately accepted
permission rule.

### 6.3 Approval Scope

C2 approval applies to the exact Project artwork composition, not independently to every
Product mock-up.

One shared approved composition may produce several Product presentations. The approval
record must identify the exact immutable Collective Project Artwork Version approved.

## 7. Approval Lock And Revision

Approval locks the exact approved Collective Project Artwork Version.

While approved and locked:

- its binary/content and provenance evidence cannot be edited in place;
- it remains the authoritative shared artwork for linked current Product presentations;
- Store readiness must reject an unapproved replacement as though it were approved;
- later Product configuration cannot silently point to a different Project artwork
  version; and
- historic Orders and Store configuration versions retain the exact artwork/presentation
  evidence they used.

A change requires:

```text
new composition version
-> current approval becomes superseded/outdated for prospective use
-> Store publication/readiness is blocked or safely paused under accepted policy
-> C1 resubmits
-> exact Project organiser approves the new version
-> affected Product presentations/configurations are regenerated and released
```

Ordinary replacement after Store publication or paid Orders must be prohibited until a
separate C1-controlled exception/reconciliation policy is accepted.

## 8. Product Presentations And Store Release

Project artwork approval and Store Product release are related but distinct.

### 8.1 Project Artwork Approval

**Project Artwork Approved** means the exact C2 Project organiser approved the shared
composition version.

### 8.2 Store Product Release

**Store Product Released** means C1 has allowed a particular ready Product presentation to
appear in the Store.

For the ordinary path:

```text
approved Collective Project Artwork Version
+ Product presentation derived from that version
+ valid Store Product configuration
+ every other Product readiness gate
-> C1 may release the Store Product
```

Only released, visible and otherwise ready Store Products appear in the Store.

### 8.3 Exceptional Product Hold / Physical Sample

C1 must be able to hold an individual Product where:

- a physical sample is required;
- reproduction on that Product is unsuitable;
- its mock-up is misleading or incomplete;
- Product-specific re-composition is required; or
- another reasoned supplier-side exception applies.

The first release need not require separate C2 approval of every Product mock-up. Planning
should preserve a future explicit physical-sample approval record without mislabelling the
ordinary Project artwork approval as a set of per-Product approvals.

## 9. Workflow-Aware Product Instructions

C1 manages Product-specific C2 organiser instructions through Product Manager when Product
suitability/workflow support is configured.

Instructions may describe:

- acceptable file types and minimum resolution;
- logo/artwork dimensions and colour requirements;
- number and type of source files;
- spreadsheet/name-data format;
- Product-specific composition constraints;
- deadlines and submission expectations; and
- whether purchaser-specific inputs will later be collected.

The instructions must:

- be C1-authored through a constrained, sanitised rich-text editor reusing the accepted
  IsoStack rich-text stack where suitable;
- be read-only to C2;
- be shown in the C2 Project Product/setup workflow;
- support different instructions for the same Product under different Project type or
  operational workflow contexts;
- preserve same-tenant authority;
- use versioned or snapshotted evidence when applied to an active Project; and
- not be confused with public Product sales copy, internal C1 production notes or
  purchaser Order inputs.

Planning must decide whether instruction ownership is keyed by:

```text
Product + Project type suitability
```

or, where one Product supports several operational treatments inside one Project type:

```text
Product + Project type suitability + Product Workflow Class
```

The second form is likely necessary when one Product can be offered as shared logo, shared
logo plus individual name, or unmodified standard stock inside the same broader Project
type.

## 10. Purchaser-Specific Customisation

Purchaser customisation at checkout is not part of C2 Project artwork approval.

Example:

```text
approved club-logo Collective Project Artwork Version
+ purchaser enters a child's name at checkout
-> Product created from the locked shared artwork and immutable Order-line input
```

C2 approves the shared Project artwork before Store opening. Commerce/FUND later snapshots
the purchaser's exact customisation inputs on the Order line. Checkout performs no Project
artwork approval.

Production therefore consumes two different evidence sets where applicable:

- the exact approved Collective Project Artwork Version/derived presentation contract;
  and
- the exact purchaser customisation values snapshotted for the Order line.

## 11. Workflow-Aware Store Readiness

Completed `1R-D` remains the Store readiness service foundation. This CR requires bounded
workflow-aware extension, not a second competing readiness system.

The later readiness matrix must express at least:

```text
ARTWORK_FUNDRAISING
-> applicable finalised Artwork Template Version and locked Project offer required

GROUP_PERSONALISED_PRODUCTS with collective artwork
-> approved locked Collective Project Artwork Version required
-> every displayed Store Product released and tied to an accepted presentation/configuration

BULK_ORDER_CLUB_FUNDED with collective artwork
-> approved locked Collective Project Artwork Version required
-> every displayed Store Product released and tied to an accepted presentation/configuration

unmodified Standard Product path
-> no Artwork Template or collective artwork approval
-> ordinary Store Product readiness only

NOT_SURE
-> Store publication prohibited
```

The actual rule must be derived from trusted Project type, Product suitability, selected
Project Product Workflow Class and immutable Store Product configuration. The client must
not submit a boolean such as `requiresArtworkApproval` as authority.

## 12. Relationship To Individual Artwork CRs

### 12.1 Application Template And Artwork Template

The linked **FUND Application Template And Artwork Template Refinement** applies to
`ARTWORK_FUNDRAISING` Individual Artwork Projects.

It does not supply the collective composition/approval workflow for Group personalised or
Bulk order/club-funded Projects.

### 12.2 Product Selection Limits And Template Capacity

The linked **FUND Project Product Selection Limits And Template Capacity Change Request**
also applies only to `ARTWORK_FUNDRAISING` Individual Artwork Projects because its maximum
is governed by the Artwork Template Product-grid capacity.

Other Project types remain subject to:

- Catalogue availability;
- Product suitability;
- valid Project Product selection;
- at least one visible, released and ready Store Product before Store publication; and
- workflow-specific artwork/readiness gates.

That ordinary non-empty Store readiness rule must not be called `minimum selected Project
Products` and no separate non-template Product maximum is inferred by either CR.

## 13. Existing Foundation And Gap Audit

This clarification does not reopen completed foundations by default.

The planning audit should determine how far the accepted models already support the
contract:

- `1Q-E` already derives eligible Products from availability and Product suitability;
- `FundProjectProduct.workflowClassId` already snapshots operational Product workflow;
- `1R-C3` already provides Project Store Products, immutable configuration versions and
  Store-Product-owned inputs;
- `1R-C4` already anticipates C2 source assets, distinct C1 composite/presentation assets,
  asset versions, review evidence and Store Product asset links; and
- `1R-D` already provides readiness and lifecycle services.

Planning must not assume that current asset review fields already express C2 organiser
approval of a Project-level composition. It must inspect:

- whether the aggregate is Project-level or only file/Store-Product-level;
- current reviewer identity semantics;
- immutable approval/version locking;
- one approved artwork version to many Product presentations;
- instruction ownership/versioning;
- Store Product release/hold evidence; and
- checkout/Order-line customisation linkage.

Only demonstrated gaps should create schema or service remediation.

## 14. Retroactive And Existing-Project Policy

The later remediation must audit existing Projects without guessing workflow state.

It must not automatically:

- change Project type;
- reinterpret `NOT_SURE` as a concrete type;
- change Product suitability;
- rewrite `FundProjectProduct.workflowClassId`;
- mark uploaded assets as approved collective artwork;
- infer C2 organiser approval;
- release Store Products;
- replace Store Product images/configuration versions; or
- unpublish a Store without an accepted operational plan.

Existing noncompliance should be reported to C1 and gated at the next applicable
configuration, approval, release, publication or resume transition.

## 15. Roadmap And Planning Impact

This CR requires a named remedial parent/capability in the future roadmap. It must not
consume or rename completed `1R-E` Store control work or `1R-G` public/C2 Store display or
the Individual Artwork Template lane.

Candidate workstreams, not executable slice identifiers, are:

1. Nomenclature, existing schema/service and existing-data reconciliation.
2. Product suitability/workflow-aware C2 instruction contract.
3. Collective Project Artwork identity, immutable version and source/presentation linkage.
4. C1 composition services and C2 Project-organiser approval/locking.
5. Product presentation derivation, C1 release and exceptional physical-sample hold.
6. Workflow-aware `1R-D` readiness reconciliation.
7. C1/C2 UI, secure asset delivery and Store presentation integration.
8. Revision, historic Order protection, audit, regression and release testing.

The clarification may be planned while Commerce A6 continues, but its accepted contract is
required before:

- A7 assumes one FUND workflow can represent every Store Product;
- `1R-E` finalises C1 readiness/approval controls;
- `1R-G` finalises public Product presentation;
- the Individual Artwork Template implementation relies on a broad `requiresTemplate`
  inference; or
- production authorisation consumes collective artwork.

The active root/FUND roadmap remains authoritative for selecting the next executable
slice. This CR does not authorise implementation or interrupt the current Commerce slice.

## 16. Refined Acceptance Principles

The clarification is successfully planned when:

- existing Project-type codes and labels remain authoritative;
- a Project has one Project type and `NOT_SURE` cannot publish;
- Product suitability remains the Product eligibility filter;
- Product Workflow Class remains the operational Product/Project Product classification;
- Standard Product is represented as an unmodified Product path, not a new Project type;
- C1 alone creates the collective Project artwork composition;
- the exact C2 Project organiser approves the exact immutable composition version;
- approval is Project-artwork approval, not automatically a separate C2 decision for every
  Product mock-up;
- one approved composition may support several suitable Products;
- only C1-released, otherwise-ready Product presentations appear in the Store;
- C1 can hold exceptional Products for physical-sample or reproduction review;
- C2 sees sanitised workflow-aware Product instructions managed by C1;
- purchaser customisation remains Order-line input and is not approved at checkout;
- Store publication applies the correct workflow-aware artwork gate;
- Individual Artwork Template capacity limits are not imposed on Group, Bulk or Standard
  Product paths; and
- historic approvals, configurations and Orders are not silently rewritten.

## 17. Resolved Business Decisions

1. The established Project-type, Product suitability and Product Workflow Class
   nomenclature remains controlling.
2. A Project has one mutually exclusive Project type.
3. `NOT_SURE` is not an operational Store-ready Project type.
4. `BULK_ORDER_CLUB_FUNDED` covers the established bulk order/club-funded concept whether
   Products are ordered in one C2 bulk Order or individually through the Store.
5. Standard Product is an unmodified Product path with no modification inputs, not a new
   Project type.
6. Product suitability excludes Products inappropriate to the Project type.
7. C1 always creates the collective Project artwork composition.
8. The exact C2 Project organiser is the collective Project artwork approval authority.
9. Approval applies to the Project artwork composition and locks its exact version.
10. One approved Project artwork composition may be applied to several suitable Products.
11. Checkout performs no C2 artwork approval.
12. Collective Project artwork approval is completed before the Store opens where the
    workflow requires it.
13. C1 manages Product-specific C2 instructions in Product Manager through a constrained,
    sanitised rich-text editor.
14. Only released/approved Products appear in the Store.
15. C1 may hold an individual Product for exceptional physical-sample or reproduction
    approval.
16. Application Template, Artwork Template and template-capacity selection-limit rules are
    confined to `ARTWORK_FUNDRAISING`.

## 18. Open Business And Planning Questions

### 18.1 Instruction Ownership Key

Are C2 organiser instructions versioned by Product plus Project type suitability, or by
Product plus Project type suitability plus Product Workflow Class when several operational
treatments are supported?

### 18.2 Bulk Standard And Modified Products

May one `BULK_ORDER_CLUB_FUNDED` Project offer both unmodified Standard Products and
Products derived from the approved shared artwork? If yes, confirm that the Project remains
one Project type while individual `FundProjectProduct` Workflow Class snapshots determine
which readiness branch applies.

### 18.3 Product Selection Authority Outside Individual Artwork

Confirm whether C1, the exact C2 Project organiser, or both under bounded rules select the
eligible Products for Group personalised and Bulk order/club-funded Projects.

### 18.4 Source Asset Completion

What exact source files/data are mandatory for each workflow, who can declare the source
set complete, and when may C1 begin or complete composition?

### 18.5 Product Presentation Generation

Must every selected modified Product have a generated mock-up before C2 approves the shared
composition, or may C2 approve the Project artwork using representative Products and C1
later create the remaining presentations from the locked version?

### 18.6 C1 Product Release Default

When Project artwork is approved and every Product presentation passes automated/readiness
validation, are all affected Products released automatically, released through one explicit
C1 bulk action, or released individually?

### 18.7 Physical Sample Exception

Define who requests a physical sample, who records its approval, whether C2 is notified or
must also approve, and whether one held Product blocks the entire Store or is simply omitted
until released.

### 18.8 Revision After Publication Or Orders

Define the C1-controlled reconciliation path when approved collective artwork must change
after Store publication, an open checkout or paid Orders. Ordinary edit/reapproval must not
silently change existing Order production evidence.

### 18.9 Bulk Ordering Policy

Define separately whether a Bulk order/club-funded Project permits C2 bulk ordering,
individual public ordering or both, including minimum quantities and delivery grouping.
This must not be inferred from Project type alone.

### 18.10 Standard Product Workflow Class

Confirm the existing or required Product Workflow Class used for unmodified Standard
Products and whether no modification inputs is sufficient to derive that path or must be
explicitly snapshotted.
