# FUND Project Product Selection Limits And Template Capacity Change Request

Date: 2026-07-15

Status: Draft change-request input for refinement and roadmap reconciliation

Related change requests by name:

- **FUND Application Template And Artwork Template Refinement** —
  `docs/modules/fund/01-cr-inputs/2026-07-15-fund-application-artwork-template-refinement.md`
- **FUND Collective Project Artwork Composition, Approval And Workflow-Aware Product
  Instructions Remedial Clarification** —
  `docs/modules/fund/01-cr-inputs/2026-07-15-fund-collective-project-artwork-composition-approval-and-workflow-aware-product-instructions-remedial-clarification.md`

Authoritative roadmap:

`docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

Accepted reconciliation successor:

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-f-project-offer-artwork-readiness-reconciliation-planning.md`

The successor preserves this CR as governed source evidence, accepts the shared
Individual Artwork selection/capacity contract and routes renderer-dependent capacity
values to bounded `1R-F-A`. The formerly reserved public Store slice moves to `1R-G` so
alphabetical identifiers continue to express delivery order. This input still does not
itself authorise implementation.

Related accepted foundations:

- `1Q-E` Project Product eligibility services;
- `1Q-F` Catalogue-centric Project Product selection;
- `1R-C3` Project Store, Store Product and immutable Store Product configuration versions;
- `1R-D` Store readiness and C1 Store configuration services;
- `1P-K2` C2 Client dashboard and Client-owned Project management; and
- the planned Application Template and Artwork Template capability.

This document is a change-request input. It does not authorise schema, migration, service,
UI, infrastructure, deployment or other implementation work.

## 1. Purpose

This change request establishes a consistent Individual Artwork Project Product
selection-limit contract so that:

- an Individual Artwork Project cannot finalise or publish an empty offer;
- C1 can configure the maximum number of selected Project Products supported by an
  Application Template Version;
- C2 begins Project Product selection with every eligible Product selected by default;
- C1 and C2 receive clear count, warning and prevention behaviour before exceeding the
  effective maximum; and
- the finalised Artwork Template Product grid and the online Project Store remain based on
  the same bounded Project Product selection.

The change has retroactive implications for existing `ARTWORK_FUNDRAISING` Project Product
selection, Store readiness, C1/C2 Product-selection UI and the linked **FUND Application
Template And Artwork Template Refinement** change request.

It does not impose an Application Template capacity maximum on Group personalised product,
Bulk order/club-funded or unmodified Standard Product paths. Those paths are controlled by
the linked **FUND Collective Project Artwork Composition, Approval And Workflow-Aware
Product Instructions Remedial Clarification**.

## 2. Controlling Language

All later planning, schema, services, UI and user guidance should use the following terms.

### 2.0 Scope: Individual Artwork Projects

Every named selection-limit rule in this CR applies only when:

```text
Project type / fundraising format = ARTWORK_FUNDRAISING
```

The maximum exists to protect the Product-grid capacity of an Individual Artwork
Application Template Version. It must not be inferred for:

- `GROUP_PERSONALISED_PRODUCTS`;
- `BULK_ORDER_CLUB_FUNDED`;
- `NOT_SURE`; or
- an unmodified Standard Product operational path.

`NOT_SURE` remains ineligible for Store publication until resolved to a concrete Project
type. Non-Individual-Artwork Stores must still contain at least one visible, released and
ready Store Product before publication, but that is ordinary Store readiness rather than
the `minimum selected Project Products` contract defined here.

### 2.1 Selected Project Product

A **selected Project Product** is one distinct active `FundProjectProduct` membership in the
Project's intended offer.

Catalogue appearances do not multiply the count. One Product available through several
eligible Catalogues remains one selected Project Product.

### 2.2 Selected Project Product Count

The **selected Project Product count** is the number of distinct active selected Project
Products in the intended Project offer.

Eligibility and Store/Product readiness remain separate gates. A selected Project Product
that has become ineligible or invalid does not become acceptable merely because the count
is within limits.

### 2.3 Minimum Selected Project Products

The **minimum selected Project Products** is the lowest selected Project Product count
permitted for Individual Artwork Project offer finalisation/publication.

The initial system rule is:

```text
minimum selected Project Products = 1
```

This minimum is not initially a C2 input. Making the minimum tenant-configurable is outside
this change request unless later business evidence requires it.

### 2.4 Maximum Selected Project Products

The **maximum selected Project Products** is the highest selected Project Product count
permitted by the effective Application Template Version and its validated Product-grid
capacity.

It is a C1-controlled configuration value. C2 can select within it but cannot change it.

Avoid ambiguous variants such as:

- maximum Products;
- Product maximum;
- template max;
- Product limit; or
- max rows.

UI labels may use concise copy where space requires it, but help text and service contracts
must identify the value as `maximum selected Project Products`.

### 2.5 Project Offer Publication

The current FUND schema has `FundProjectStatus` values such as `DRAFT` and `ACTIVE`, while
`FundProjectStoreStatus` owns `PUBLISHED`. This change request must not invent or imply a
new `FundProjectStatus.PUBLISHED` value.

For this change request, **Project offer publication** means the point at which an
Individual Artwork Project's selected Products become externally operational through one
or more of:

- Artwork Template finalisation;
- Project Store publication or resume; and
- any later public Project offer transition accepted by the FUND roadmap.

The minimum and maximum selected Project Product gates must be enforced at every applicable
Project offer publication boundary.

## 3. Accepted Business Rules

### 3.1 Minimum Rule

An Individual Artwork Project offer must contain at least one selected Project Product.

```text
selected Project Product count < minimum selected Project Products
-> Project offer is not ready for publication
```

An empty selection may exist temporarily while a Project is being configured, but it blocks:

- Artwork Template finalisation;
- Project Store publication/resume; and
- any later public Project offer transition.

### 3.2 C1 Maximum Configuration Rule

C1 configures `maximum selected Project Products` on each Individual Artwork Application
Template Version.

The configured value must:

- be a positive integer;
- be at least the minimum selected Project Products;
- not exceed the Product-grid capacity proven by Application Template validation;
- participate in Application Template Version immutability;
- be visible during Event/default/Project assignment; and
- be pinned into the finalised Artwork Template/Project offer lock snapshot.

C1 may configure a value lower than the physical validated Product-grid capacity when a
business or design reason requires a smaller offer.

C1 must not configure a value greater than the validated Product-grid capacity. The UI and
activation service should prevent it rather than merely warn.

### 3.3 Default-All Selection Rule

When the C2 Individual Artwork Product-selection step is initialised, all distinct eligible
Products default to selected.

```text
deduplicated eligible Products
-> all initially selected
-> C2 reviews and deselects Products where required
```

The default must use deduplicated Product identity, not Catalogue membership rows.

If the number of eligible Products exceeds the effective maximum selected Project Products:

- all eligible Products still default to selected;
- the selection step immediately displays an over-maximum blocking state;
- C2 must deselect enough Products to reach the effective maximum before continuing to a
  valid finalisation/publication state; and
- C1 must already have received an upstream warning that the eligible Product pool exceeds
  the Application Template maximum.

FUND must not silently select only the first Products, because this would hide Products and
make ordering or sort order an accidental business-selection rule.

### 3.4 UI Assistance And Prevention Rule

C1 and C2 Individual Artwork Product-selection/configuration surfaces must display:

- selected Project Product count;
- minimum selected Project Products;
- maximum selected Project Products;
- remaining selectable capacity;
- under-minimum state;
- at-maximum state; and
- over-maximum state.

At Project Product save/finalisation/publication boundaries, FUND must prevent a selected
Project Product count outside the accepted range.

C1 also requires upstream assistance where Product eligibility is configured. Event,
Catalogue, Standalone-default and Application Template assignment/configuration surfaces
should show the deduplicated eligible Product count against the effective maximum selected
Project Products where that count can be resolved.

An eligible pool greater than the maximum should produce a prominent C1 warning before C2
begins selection. Planning must decide which upstream C1 actions are warnings and which are
hard activation blockers; C2 must always be able to resolve an over-maximum default by
deselecting eligible Products unless a stricter business rule is accepted.

## 4. Authority And Responsibility

### 4.1 C1

C1 owns:

- Product definitions and price configuration;
- Catalogue/Event/Standalone Product eligibility;
- Application Template design and validation;
- maximum selected Project Products configuration;
- visibility of eligible Product count versus Application Template capacity;
- remediation of Application Templates whose capacity is too small for the intended offer;
  and
- operational review of existing noncompliant Projects after rollout.

### 4.2 C2

For an Individual Artwork Project, the authorised C2 Project organiser/owner/admin owns:

- review of the default-all eligible Product selection;
- deselection/reselection within C1-defined eligibility;
- resolution of an under-minimum or over-maximum selection state; and
- finalisation of the Project-specific Artwork Template and locked Project offer.

C2 cannot:

- increase maximum selected Project Products;
- change Application Template Product-grid capacity;
- make an ineligible Product eligible;
- edit C1 Product definitions or configured price; or
- bypass the publication gate.

The exact C2 access mapping remains controlled by the linked **FUND Application Template
And Artwork Template Refinement** open authority question.

## 5. Effective Maximum Resolution

For an Individual Artwork Project, the effective maximum selected Project Products must
resolve from the same Application Template assignment used for Artwork Template
preview/finalisation.

### 5.1 Event-Linked Project

```text
Event-linked Project
-> Event-assigned Application Template Version
-> maximum selected Project Products
```

A missing or invalid Event Application Template/capacity prevents a valid Artwork Template
finalisation and Project offer publication. FUND must not silently use the Standalone
default.

### 5.2 Standalone Project

```text
exact C1 Project Application Template override, when present
else tenant default Standalone Application Template Version
-> maximum selected Project Products
```

### 5.3 Version Pinning

Before finalisation, Product selection uses the currently effective Application Template
Version and its maximum selected Project Products.

At finalisation, the Project offer lock snapshots:

- exact Application Template Version;
- minimum selected Project Products policy/version;
- maximum selected Project Products;
- selected Project Product count;
- exact ordered selected Project Product identities; and
- exact resolved Store Product Configuration Versions.

A later Application Template Version may have a different maximum. It does not rewrite the
limit or selection of an existing locked Artwork Template Version.

## 6. Relationship To Product-Grid Capacity

Maximum selected Project Products and Product-grid capacity are related but not identical.

### 6.1 Validated Product-Grid Capacity

The **validated Product-grid capacity** is the greatest number of Product rows that the
Application Template renderer and print QA have proven can fit legibly on one A4 page for
the configured orientation, grid style, typography, safe-print inset and representative
content envelope.

### 6.2 Configured Maximum

The C1-configured maximum selected Project Products must be:

```text
minimum selected Project Products
<= maximum selected Project Products
<= validated Product-grid capacity
```

Application Template activation must fail if this invariant is not met.

### 6.3 Runtime Fit Validation

Count compliance does not replace runtime fit validation. Long Product names or supported
option summaries may still overflow within the configured count.

Artwork Template finalisation must therefore require both:

- selected Project Product count within the configured minimum/maximum; and
- successful Project-specific one-page Product-grid layout validation.

FUND must not silently add a second page, omit a selected Project Product or shrink below an
accepted legibility threshold.

## 7. C2 Individual Artwork Product-Selection Experience

The C2 Individual Artwork Project creation/management flow should be:

```text
choose Event or Standalone context
-> resolve eligible Products and effective Application Template capacity
-> preselect all eligible Products
-> show selected/minimum/maximum counts
-> C2 reviews and deselects/reselects
-> block continuation while count is outside range
-> preview exact Artwork Template Product grid
-> finalise and lock the bounded Project offer
```

Recommended UI behaviour:

- persistent count summary near the selection controls;
- `All eligible Products are selected by default` explanation;
- visible remaining-capacity count;
- warning when the selection reaches the maximum;
- blocking error when the selection exceeds the maximum;
- blocking error when no Product is selected;
- clear guidance to deselect Products or ask C1 for an Application Template with greater
  validated capacity;
- no arbitrary hiding of Products that start above the maximum; and
- accessible non-colour-only warning/error semantics.

If the UI prevents a further selection once at maximum, it must still allow an existing
over-maximum default or legacy state to be displayed and remediated by deselection.

## 8. C1 Assistance Surfaces

C1 assistance should be present in at least:

### 8.1 Application Template Editor

- validated Product-grid capacity;
- maximum selected Project Products input;
- minimum selected Project Products reference;
- activation prevention when maximum exceeds validated capacity;
- sample preview at the configured maximum; and
- warning when assigned Event/Project eligible counts exceed the configured maximum.

### 8.2 Event And Standalone Product Availability

- deduplicated eligible Product count;
- effective Application Template name/version;
- effective maximum selected Project Products;
- excess count;
- navigation to Application Template or Product-availability remediation; and
- warning before activating an Event/default combination that will initialise C2 in an
  over-maximum state.

### 8.3 C1 Project Product Management

The existing C1 Project Product picker is retroactively in scope when it manages an
Individual Artwork Project. It should use the same selected Project Product count and
minimum/maximum enforcement as C2. C1 must not have an ordinary bypass that creates an
Individual Artwork offer the Artwork Template cannot represent.

An exceptional override, if ever required, needs a separately planned, reasoned and audited
workflow rather than a hidden UI bypass.

### 8.4 Operational Exception View

C1 needs a way to identify existing Projects that are:

- under minimum;
- over maximum;
- missing an effective maximum;
- linked to an invalid/archived Application Template Version; or
- locked under an earlier limit policy.

## 9. Service And Validation Contract

One shared server-side Individual Artwork policy must calculate and return at least:

- selected Project Product count;
- minimum selected Project Products;
- maximum selected Project Products;
- effective Application Template/version source;
- remaining capacity;
- `UNDER_MINIMUM`, `WITHIN_LIMIT`, `AT_MAXIMUM`, `OVER_MAXIMUM` state;
- stable blocking/warning reason codes; and
- whether selection mutation, Artwork Template finalisation and Store publication are
  permitted.

Candidate stable reason codes for later planning are:

```text
PROJECT_PRODUCT_SELECTION_EMPTY
PROJECT_PRODUCT_SELECTION_BELOW_MINIMUM
PROJECT_PRODUCT_SELECTION_ABOVE_MAXIMUM
APPLICATION_TEMPLATE_CAPACITY_MISSING
APPLICATION_TEMPLATE_CAPACITY_INVALID
ELIGIBLE_PRODUCT_POOL_ABOVE_MAXIMUM
PROJECT_PRODUCT_GRID_DOES_NOT_FIT
PROJECT_PRODUCT_SELECTION_LOCKED
```

The final names must follow accepted FUND naming conventions. UI prose must not be persisted
as contract data.

All Individual Artwork Project Product mutation paths must use the shared policy,
including:

- C2 create/update selection;
- C1 Project Product management;
- reactivation/deactivation;
- Store preparation/refresh where selected membership is consumed;
- Artwork Template finalisation/unlock/refinalisation; and
- any import, automation or administrative service capable of changing Project Products.

Client-side checkbox limits alone are not enforcement.

## 10. Finalisation, Locking And Publication

Artwork Template finalisation must fail unless:

```text
minimum selected Project Products
<= selected Project Product count
<= maximum selected Project Products
```

It must also fail when Product-grid runtime validation does not fit the actual resolved
content.

Successful finalisation locks the exact bounded Project offer as described in the linked
**FUND Application Template And Artwork Template Refinement** CR.

While locked:

- selected Project Products cannot be varied;
- the maximum selected Project Products used by the lock does not change;
- the Store cannot silently move to different Product/commercial configuration versions;
  and
- unlock/revision is required before selection changes.

Store publication/resume for an Individual Artwork Project must independently recheck that
the current locked offer satisfies the same selection-limit contract. It must not trust an
earlier browser response.

Group personalised, Bulk order/club-funded and unmodified Standard Product paths instead
apply their accepted workflow-aware artwork, Product-release and ordinary non-empty Store
readiness gates.

## 11. Retroactive And Existing-Project Policy

This change request applies prospectively to all applicable Individual Artwork mutation,
finalisation and publication paths, and it requires a safe audit of existing
`ARTWORK_FUNDRAISING` Projects.

### 11.1 No Destructive Automatic Rewrite

Rollout must not automatically:

- deselect existing Project Products;
- select additional Products on existing Projects;
- reorder existing Project Products;
- rewrite historic Artwork Template Versions;
- change a pinned Application Template Version; or
- silently unpublish an existing Store.

### 11.2 Existing Unfinalised Projects

An existing unfinalised Project should be evaluated against its currently effective
Application Template Version.

- zero selected Project Products produces an under-minimum blocker;
- selection above the maximum produces an over-maximum blocker;
- missing maximum configuration produces an explicit configuration blocker; and
- all-eligible default selection is not retroactively applied without an explicit reset or
  business-approved backfill action.

### 11.3 Existing Finalised/Locked Artwork Templates

An existing locked Artwork Template Version retains its pinned Application Template Version,
selected Product set and limit evidence. A later Application Template maximum does not
rewrite it.

Unlocking/refinalising moves the Project onto the then-effective selection-limit policy.

### 11.4 Existing Published Stores

Rollout should not silently unpublish an existing Store. Existing published noncompliance
must be surfaced to C1 as an operational exception.

At minimum, noncompliance should block:

- ordinary Store resume after pause;
- new Artwork Template finalisation/refinalisation;
- Product-selection changes that do not restore compliance; and
- later publication transitions.

Whether an already-published noncompliant Store may continue accepting new Orders until C1
remediation is a business decision that must be resolved before implementation.

### 11.5 Audit/Backfill Evidence

Planning should require an assessment/report that counts existing Individual Artwork
Projects by:

- no selected Project Products;
- within effective limits;
- above effective maximum;
- missing Application Template/capacity;
- finalised/locked; and
- Store publication state.

Any later data backfill must be explicit, reversible where practical, tenant-scoped and
independently reviewed. The migration must not guess Product selection.

## 12. Invalidation And Configuration Changes

Changing maximum selected Project Products requires a new Application Template Version. It
must not mutate an active version.

For unfinalised Projects using the new version:

- selection-limit evaluation updates to the new maximum;
- an existing selection may become over maximum and require remediation; and
- a larger maximum does not auto-select newly available Products.

For finalised Projects:

- the locked version remains stable;
- the current Artwork Template is not rewritten;
- adopting the new maximum requires the accepted unlock/revision/refinalisation path; and
- prior printed/distributed copies remain historic operational evidence.

Changes to eligible Product membership should recalculate the eligible count warning and
default behaviour for a newly initialised selection. They must not silently change a locked
selection.

## 13. Testing And Acceptance Evidence

Planning must require automated coverage for:

- tenant and C1/C2 authority isolation;
- minimum of one selected Project Product;
- C1 maximum validation;
- maximum not exceeding validated Product-grid capacity;
- deduplication across several eligible Catalogues;
- all eligible Products selected by default;
- initial eligible count below, equal to and above maximum;
- C1 and C2 mutation enforcement;
- direct service/API bypass refusal;
- Event-linked maximum resolution;
- Standalone default and exact Project override resolution;
- finalisation and Store publication gates;
- lock/unlock/refinalisation behaviour;
- Project-specific grid overflow despite count compliance;
- immutable historic limit/selection snapshots; and
- existing-data audit and zero destructive auto-selection/deselection.

Representative UI/browser checks should confirm:

- counts and remaining capacity remain correct during selection;
- default-all state is clear;
- at-maximum warning appears;
- over-maximum default can be remediated by deselection;
- under-minimum state blocks continuation;
- C1 sees upstream eligible-count warnings;
- C1 cannot activate an impossible Application Template maximum; and
- a locked Project clearly explains why Product selection is disabled.

## 14. Roadmap Impact

This CR affects, but does not authorise, later planning for:

- Application Template/version/assignment schema;
- C1 Application Template editor and activation validation;
- C1 Event/Catalogue/Standalone availability UI;
- C1 Project Product manager remediation;
- C2 Project creation and Product-selection workflow;
- Store readiness/publication services;
- Artwork Template preview/finalisation/locking;
- public Store/checkout configuration pinning; and
- retrospective Project compliance audit/operations.

These impacts are confined to `ARTWORK_FUNDRAISING`. The linked **FUND Collective Project
Artwork Composition, Approval And Workflow-Aware Product Instructions Remedial
Clarification** controls the different Group/Bulk collective-artwork, Product instruction,
Product release and Standard Product readiness paths.

The linked **FUND Application Template And Artwork Template Refinement** must include this CR
as a named dependency. Its future slice roadmap must sequence the shared selection-limit
contract before Artwork Template finalisation and Store publication are declared complete.

The active root/FUND roadmaps remain authoritative for selecting an executable slice.

## 15. Refined Acceptance Principles

This change is successful when, for Individual Artwork Projects:

- every Individual Artwork Project offer has at least one selected Project Product before
  finalisation/publication;
- every effective Application Template Version has a C1-configured maximum selected Project
  Products within validated Product-grid capacity;
- all eligible Products default to selected for a newly initialised C2 selection;
- over-maximum default state is explicit and resolvable rather than silently truncated;
- C1 sees eligible Product counts and receives upstream capacity warnings;
- C1 and C2 use the same count and enforcement policy;
- no ordinary API/UI path can save/finalise/publish an out-of-range offer;
- the finalised Artwork Template and online Store share the exact bounded Product offer;
- locked historic Artwork Templates retain their original limit and selection evidence;
- existing data is audited without destructive automatic Product changes; and
- terminology is homogeneous across both linked CRs, UI guidance and later planning.

## 16. Resolved Decisions

This CR records the following as accepted inputs:

1. Initial minimum selected Project Products is one.
2. Maximum selected Project Products is configured by C1.
3. Maximum selected Project Products belongs to an immutable Application Template Version.
4. The configured maximum cannot exceed validated Product-grid capacity.
5. All distinct eligible Products default to selected when C2 selection is initialised.
6. An eligible pool above maximum is shown as an explicit over-maximum blocking state; FUND
   does not silently choose a subset.
7. C1 receives upstream assistance/warning where eligible Product count exceeds the
   effective maximum.
8. C1 and C2 Individual Artwork Project Product management share server-side
   minimum/maximum enforcement.
9. Individual Artwork Template finalisation and Store publication/resume enforce the same
   limits.
10. The finalised Project offer lock pins the applicable minimum/maximum and exact selected
    Product set.
11. Existing Products are not automatically selected/deselected or reordered during rollout.
12. Historic locked Artwork Template Versions are not rewritten by later maximum changes.
13. Every rule in this CR is scoped to `ARTWORK_FUNDRAISING`; no Application Template
    capacity maximum is inferred for Group personalised, Bulk order/club-funded or
    unmodified Standard Product paths.

## 17. Open Business And Planning Questions

### 17.1 Upstream Warning Versus Activation Block

When an Event or Standalone eligible Product pool exceeds maximum selected Project Products,
should C1 be:

- warned but allowed to activate because C2 can deselect a subset;
- blocked from activation until eligibility is reduced or template capacity increased; or
- allowed only through a reasoned C1 acknowledgement?

The C2 selection and publication gates remain hard regardless.

### 17.2 Existing Published Store Behaviour

May an already-published Store that is over the new effective maximum continue accepting
new Orders pending C1 remediation, or must it be paused through a controlled rollout action?

No automatic unpublish should occur without an accepted operational plan.

### 17.3 Existing Zero-Selection Projects

Should C1 receive only a remediation queue for existing Projects with no selection, or
should there be an explicit reviewed action that applies the default-all eligible selection?

The initial rollout must not guess or backfill selection silently.

### 17.4 Maximum Change And Assigned Projects

When C1 activates a new Application Template Version with a lower maximum, should the UI
block assigning it to an unfinalised Project whose existing selection is above that maximum,
or permit assignment while immediately creating an over-maximum remediation state?

### 17.5 Maximum Value Ownership

Confirm that maximum selected Project Products is stored only on Application Template
Version, rather than duplicated into Event, Project or tenant settings. Event/Project lock
snapshots may retain the resolved value as immutable evidence but should not become
independent editable sources.

### 17.6 Product Options And Printable Rows

Confirm whether one selected Project Product always consumes one Product-grid row. If
supported Product options can create several printed rows, validated capacity and selected
Project Product count may need a separate calculated printable-row count.

### 17.7 At-Maximum Checkbox Behaviour

Once a valid selection reaches maximum selected Project Products, should the UI disable
remaining unselected checkboxes, or allow another selection and immediately show an
over-maximum error?

In either case, existing/default over-maximum states must remain visible and remediable.
