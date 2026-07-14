# FUND Phase 1 Slice 1R-A - Store, Orders And Commerce Core Planning

Date: 2026-07-08

Last reviewed: 2026-07-14

Status: Accepted architecture / 1R-B schema-options planning created

## 1. Slice Decision

Use `1R-A` for the next FUND core lane.

Rationale:

- `1Q` has closed the availability-to-selection baseline:
  Event/Catalogue availability, standalone Catalogue availability, Product suitability and
  selected Project Products are now testable and accepted.
- Store, Orders and Commerce are still Phase 1 structural work because they define the
  operational data spine that later C2 users, C1 production, dispatch, commission and
  reporting depend on.
- Phase 2 is the refinement/resolution phase. It should not start until the Store/Order
  data contracts exist, except where a wishlist item is promoted because it blocks safe
  Store/Orders/Commerce design.
- `1R` follows `1Q` naturally as the next Phase 1 core slice family. The `R` here means the
  next main slice letter after `Q`; it is not an `R1` review/remediation suffix.

Do not use `2A` yet.

Reason:

```text
2A would imply a move into Phase 2 refinement before the Store/Orders/Commerce core exists.
```

The significance of this stage is the reason to keep it in Phase 1: this is foundational
architecture, not polish.

## 2. Slice Goal

Define the Store, Orders and Commerce core model that can safely build on the accepted
1Q-G availability-to-selection baseline.

The planning question:

```text
How does a Project-selected Product become visible in a Store, become an Order line, and
then remain usable for C1 production, dispatch, commission and reporting?
```

This slice should produce implementation-ready boundaries before any Store or Order schema
is added.

## 3. Accepted Inputs From 1Q-G

The accepted baseline is:

```text
Product/Catalogue setup
-> Event or standalone availability
-> Product Project Type suitability
-> Product Organisation Type suitability
-> eligible Products
-> selected FundProjectProduct rows
```

Store and Orders must use selected `FundProjectProduct` rows as their Product source.

They must not use:

- all active tenant Products;
- all Products in an Event Catalogue;
- all Products in a standalone/default Catalogue;
- raw Product rows without Project selection;
- source Catalogue grouping as a duplicate Store display or duplicate Order line rule.

Products available through multiple Catalogues should still appear once in the Store when
selected once for the Project.

## 4. Core Boundaries

This planning slice is allowed to define:

- Store lifecycle and visibility states;
- Store generation/source rules from Project-selected Products;
- Order and Order line snapshot boundaries;
- Project-level and Order-line artwork/image/file production input requirements;
- Product option and dependency boundaries;
- payment/Commerce integration boundaries;
- C1 and C2 visibility boundaries;
- production/dispatch/commission dependency points;
- which Phase 2 wishlist items must be promoted before Store implementation.

This planning slice must not implement:

- Prisma migrations;
- API/services;
- Store UI;
- checkout/payment integration;
- Order management UI;
- production batching;
- dispatch workflows;
- commission calculations;
- Product media/options;
- Catalogue duplication;
- per-Catalogue pricing or commission overrides.

## 5. Required Architectural Decisions

### 5.1 Store Record And Lifecycle

Accepted decision:

- Store should be represented by an explicit Project-scoped Store record rather than being
  derived only from mutable Project state.
- A dedicated Project Store Product record should represent each selected Product as it is
  configured and resolved for the Store.
- Most Projects should have a Store by default.
- Project-level Store enablement should be configurable, defaulting to enabled, but
  enablement alone must not publish the Store.
- Store lifecycle should distinguish at least `DRAFT`, `PUBLISHED`, `PAUSED`, `CLOSED` and
  `ARCHIVED` as conceptual states. Exact enum names belong to schema-options planning.
- Store visibility should be gated by Store lifecycle, Project lifecycle, Project
  close/end date and any accepted Store-specific date window.
- Store closing date should inherit the Project closing date by default, may be earlier,
  and must not be later. A Store-specific opening date remains a business decision.
- C1 should have explicit Publish, Pause and Close actions.
- C2 may manage Store-facing Project settings only within C1-defined boundaries.
- If no Products are selected, the Store should show a safe unavailable state with organiser contact details.

### 5.2 Store Product Source

Accepted rule:

```text
Store Products = active selected FundProjectProduct rows for the Project.
```

This is the source rule, not the complete purchasing rule. A Store Product is purchasable
only when all applicable gates pass:

```text
active selected FundProjectProduct
+ currently eligible Product
+ visible Project Store Product
+ published/open Project Store
+ passed production/readiness gates
```

Accepted decision:

- A Project Store Product must reference one `FundProjectProduct`; it must not create a
  second Product identity or duplicate Catalogue membership.
- The Project Store Product owns Store display order, Store visibility, resolved Store copy,
  resolved option/input configuration, readiness state and effective commercial terms once
  those terms have been decided.
- A Product available through multiple Catalogues still creates at most one selected
  `FundProjectProduct` and one Project Store Product.
- Store display should use a grid layout showing a primary/key Product image, Product title,
  Product subtitle and price.
- Products may support more than one image, but the Store grid should use one key image for
  the initial card view.
- Selecting a Store Product should open a Product detail modal with richer information and
  add-to-basket controls.
- Store display order should be controlled by C1.
- C2 users may show or hide Products within the Project Store, subject to C1-defined
  boundaries.
- Source Catalogue badges/context should be visible in C1 admin only and should not appear
  in the public/C2 Store.
- If a selected Project Product later becomes ineligible, it should be hidden from the
  Store rather than remaining purchasable.
  - C1 should see an admin warning when a previously selected Product is hidden because
  eligibility has changed.
- Store-specific copy may be managed at Project Store level by C1 or by C2 users within
  C1-defined boundaries.
- Event-linked Projects may inherit default Store copy from the Event.
- C2 users may override inherited Event Store copy at Project level where C1 permits it.
- Store copy inheritance should follow: Event default copy -> Project Store override.

### 5.3 Order And Order Line Snapshots

Accepted ownership boundary:

- IsoStack Commerce Core should own generic Order, Order line, checkout, monetary, payment
  and refund lifecycle concepts.
- FUND should own Project Store, Project Store Product, Project/Event/Client context,
  production/personalisation inputs and the FUND-specific extensions associated with a
  Commerce Order line.
- The first schema-options slice must define this cross-core relationship before either a
  FUND-only Order model or payment integration is implemented.
- A temporary FUND-only Order model is not accepted unless a later planning decision records
  a bounded compatibility and migration path explicitly.

Orders must not depend on live mutable Product, Store Product, option, commercial-term or
file metadata for historical correctness. A Commerce Order line should link to the Project
Store Product used for purchase and retain its own immutable resolved snapshot.

Required Order and Order-line evidence includes:

- Product code, name, description and Project Store Product identity at submission;
- Project, Store, Event and Client/C2 organisation context;
- quantity, unit price and option price modifiers;
- line net, tax and gross amounts;
- Order subtotal, discount, delivery, tax and final total as applicable;
- currency, minor-unit representation and rounding basis;
- VAT/tax rate, amount and inclusive/exclusive display basis;
- selected Product option choices and C1-configured custom input values;
- personalisation, artwork and person/participant evidence where applicable;
- immutable Project-level and Order-line asset-version evidence where applicable;
- whether required inputs were present and valid at submission;
- purchaser/contact identity snapshot appropriate to the accepted Store mode;
- fulfilment mode and immutable recipient/address context where applicable;
- later cancellation, refund and adjustment evidence needed for reporting and aggregate
  Project commission calculation.

Catalogue context may be retained for C1 audit and reporting, but it must not create a
second Store Product or Order line identity and should not be exposed in public/C2 views by
default.

Snapshot and validation timing:

- Cart lines may hold provisional configuration and commercial values.
- Submission must revalidate Store availability, Product eligibility and visibility,
  resolved options/inputs, required uploads and effective commercial terms.
- Immutable snapshots are created when checkout is submitted and the Order is created,
  before or alongside payment initiation.
- Payment confirmation changes payment state only; it must not recalculate historic line
  values or replace option/artwork snapshots.
- Expired or failed checkout sessions must use current values when retried through a new
  checkout.
- Order creation and payment/webhook handling require idempotency so retries cannot create
  duplicate Orders, payments or fulfilment work.

Order, payment, production and fulfilment are separate state dimensions. The Commerce
boundary must support at least pending-payment, paid, failed/expired, cancelled and refunded
outcomes without treating them as production states. Exact state machines belong to the
schema-options planning slice.

If Orders exist for a selected Project Product or Project Store Product, hard removal must
be prevented. C1 should hide, pause, close or archive it instead. Historical Orders,
production, dispatch, reporting and commission audit must remain usable.

### 5.4 Purchaser Uploads, Artwork Requirements And Submission Gates

Artwork/image upload is not a universal Store requirement. It is conditional by Project
Type / Store workflow and then refined by the selected Product, Product Type / Option
Template, Project Product, Store Product or Product option rules. Some Project Types supply
production artwork at Project setup. Some require purchaser-supplied artwork at checkout.
Other Project/Product combinations require no upload at all.

This is production information, not just public Store presentation. C1 users will need to
see whether the production inputs for a Project, Product or Order line have been supplied,
are missing, are awaiting review, or are approved for production. C2 users may also need to
upload and manage Project-level production files where the Project workflow makes them
responsible for artwork collection.

Accepted boundary:

- Artwork/file upload requirements should be determined primarily by the Project Type /
  Store workflow.
- Product, Product Type / Option Template, Project Product, Store Product and Product option
  rules may refine the exact required inputs for a specific Store Product or Order line.
- Individual artwork Projects may require purchaser-side upload at checkout. Example: a
  parent receives original artwork at home for review and ordering, but is asked to upload a
  photo of the artwork during purchase as a production backstop if the original artwork is
  later mislaid.
- Other Project Types may require C2 organiser-side upload of many artwork files through the
  C2 dashboard, with the Store and Orders referencing those Project-level files.
- Upload timing and ownership must therefore support Project-level C1/C2 uploads,
  Order-line purchaser uploads, hybrid workflows and no-upload workflows.

Examples:

- a Project-level school/club logo uploaded during Project setup and reused across Orders;
- Project-level group artwork or production files approved before the Store opens;
- many artwork files uploaded by a C2 Project organiser through the C2 dashboard;
- a photograph uploaded by a purchaser for an Order-line personalised Product;
- a purchaser-uploaded photo of individual artwork as a backstop if physical artwork is lost;
- an artwork file for a Product purchased at checkout;
- a child/person image for an individual artwork Project;
- supporting text/instructions for a bespoke Product.

Timing models:

- `PROJECT_LEVEL`: C1/C2 supplies one or more production files before purchase. The Store
  and Orders reference the Project-level production inputs.
- `ORDER_LINE_LEVEL`: the purchaser supplies one or more files when ordering, and the files
  belong to the Order line.
- `HYBRID`: the Project supplies base artwork, but the purchaser also supplies per-Order
  images, text or choices.
- `NONE`: no artwork/file upload is relevant for this Project/Product workflow.

Accepted configuration boundary:

- Project Type / Store workflow supplies the baseline artwork timing and gate policy;
- Product supplies Product-specific input requirements;
- Project Product may refine those requirements for the selected Project context;
- Project Store Product stores the resolved Store/checkout requirements;
- a specific Product option or custom input may activate a conditional Order-line upload;
- reusable Product Type / Option Templates remain deferred and are not a first-pass source
  of hard checkout validation.

Business decision recorded in section 9.2:

```text
Can a Project Store open, or an Order be submitted, without the required production
artwork, image or file inputs for this Project/Product context?
```

Possible policies:

- `PROJECT_INPUT_REQUIRED`: Store/Product selection cannot proceed until Project-level
  production files are supplied;
- `BLOCK_STORE_OPENING`: the Store cannot be published/opened until required Project-level
  production files are supplied;
- `BLOCK_ORDER_SUBMISSION`: the purchaser cannot submit until required Order-line uploads
  are present;
- `ALLOW_WITH_WARNING`: the Store can open or the Order can be submitted, but the relevant
  Project, Store Product or Order line is marked incomplete;
- `OPTIONAL`: uploads are allowed but not required;
- `NOT_REQUIRED`: no upload is required for this Project/Product context.

Order and Order line snapshots must retain enough evidence to prove what was supplied at
submission time, even if the live Product, Store Product, Project-level artwork record or
file metadata changes later.

File references alone are not sufficient immutable evidence. The snapshot should reference
an immutable asset version and retain the submitted filename, MIME type, size, checksum,
scan state, validation/review state and relevant timestamps. Storage retention and deletion
must reconcile production/audit needs with consent, GDPR data minimisation and defined
retention periods, especially where images contain children or sensitive content.

Open design points:

- accepted file/image types, including whether one workflow can require several different
  file types;
- maximum file size and file/image count;
- storage location and retention policy;
- whether uploaded files are linked to Project, Project Product, Store Product, Order,
  Order line or person/participant records;
- whether Project-level C2 artwork uploads need batching, naming, participant matching or
  review tools before Store opening;
- whether purchaser uploads at checkout are mandatory evidence, optional fallback evidence
  or production-critical assets;
- virus/malware scanning and safe download policy;
- C1 artwork review state, notes and production-facing visibility;
- C2 organiser visibility into missing, rejected or approved Project-level files;
- GDPR/data minimisation where uploaded images may contain children or sensitive content.

### 5.5 Product Options, Dependencies And Store MVP

Wishlist items:

- `2R-PRODUCT-01` - Product Media, Gallery And Option Definition Planning;
- `2R-PRODUCT-02` - Product Option Image Mapping Planning.

Controlled appraisal input:

- `docs/modules/fund/00-roadmap-control/2026-07-08-fund-ecwid-commerce-platform-appraisal.md`

Accepted decision:

- Product options are required for the Store MVP.
- This richness is central to the client value of FUND and should not be deferred as later
  presentation polish.
- Store MVP should support structured buyer-facing option groups, required/optional choices,
  display labels, selected option validation and Order-line option snapshots.
- Upload requirements may be expressed through Project Type / Store workflow rules and
  Product/Product Type option rules where relevant.
- Product Variants should still be avoided unless a choice combination genuinely needs its
  own SKU, stock, image, weight, fixed price or fulfilment treatment.
- Full gallery/media richness and advanced option-image mapping may be phased, but the core
  option model must exist before safe Order capture.
- First-pass options include typed input definitions, option choices, required/default
  behaviour, simple price modifiers, validation and immutable Order-line snapshots.
- Complex dependency graphs may be deferred unless a confirmed first-pass Product cannot be
  ordered safely without them.
- Option/input configuration resolves in this order: Product base -> Project Product
  override -> Project Store Product resolved configuration. Schema-options planning must
  decide merge-versus-replace behaviour per field and preserve a configuration version.
- A cart must detect when its resolved configuration version has changed and require
  revalidation before submission.

Product options are not stock-control inventory in this context. They are buyer-facing
configuration and evidence capture rules for an Order line.

The Ecwid appraisal supports this shape:

- keep a stable base Product;
- attach structured options/choices to that Product;
- snapshot selected choices onto the Order line;
- promote an option combination to a Product Variant only when it genuinely needs its own
  SKU, stock control, image, weight, fixed price or fulfilment treatment.

Option controls may include:

- enum/dropdown values, such as `Small`, `Medium`, `Large`;
- colour values shown as text, swatches or another visual control;
- free-text inputs;
- numeric inputs;
- yes/no toggles;
- single or multi-select values;
- image/file upload controls;
- artwork/person/personalisation fields.

Upload controls should not imply that every Product needs purchaser artwork. They should be
available only where the Project Type/workflow and Product/Product Type rule require or
allow Project-level or Order-line production files.

Options may be mutually dependent. Example:

```text
Size = Large -> Colours available: Red, Blue
Size = Small -> Colours available: Red, Blue, Green
```

This implies an option model needs more than flat labels. It may need:

- option groups;
- option value sets;
- display/control type;
- required/optional flags;
- default/preselected values;
- C1-managed custom field definitions for Product-specific or Project Product-specific
  Order inputs;
- price modifiers that adjust the base Product/Project Product price rather than replacing
  it, unless a Product Variant or commercial override is explicitly introduced;
- dependency rules between option groups;
- conditional upload requirements driven by Project Type, Product Type and option choices;
- snapshot rules for chosen labels, values and display text;
- validation that unavailable option combinations cannot be ordered.

Do not create a separate Product for every buying choice. That would make Catalogues noisy,
make Project Product selection harder, and increase the risk that historic Orders become
unclear. Product Variants should be planned deliberately and sparingly.

### 5.5.1 C1-Managed Custom Order Fields

Some Products will need ad-hoc data at Order time that is not worth modelling as a
dedicated schema column.

Examples:

- text to print on a Product;
- production notes for a specific Product;
- sponsor wording;
- class/team/group label;
- an external artwork reference;
- an optional contact/detail field required by one Product only.

C1 should be able to define these fields against a Product, Product Type / Option Template
or Project Product using standard data/control types. This keeps one-off production needs
inside the C1 configuration surface rather than requiring hard-coded fields.

Product options and custom Order fields may share one typed input/control foundation, but
their semantics must remain clear: options configure the purchased Product, while custom
fields capture additional buyer or production data. Schema-options planning should avoid
duplicating two incompatible validation and snapshot systems.

Candidate custom field data/control types:

- short text;
- long text;
- number;
- date;
- yes/no;
- single select;
- multi-select;
- colour/swatch;
- file upload;
- email/phone-style contact input where appropriate.

Custom field definitions should support:

- label;
- help text;
- required/optional flag;
- default value where relevant;
- allowed choices where relevant;
- validation constraints;
- customer-facing visibility;
- C1 production/admin visibility.

Non-negotiable:

```text
Custom field submitted values must be snapshotted onto the Order line.
```

This prevents historic Orders from becoming unclear if C1 later renames, removes or changes
the custom field definition.

### 5.6 Product Type / Option Template Planning

Product options are required for Store MVP, but a reusable Product Type / Option Template
model is not required before first Store MVP.

It may still be useful later to define a Product Type, or more precisely a Product Type /
Option Template, that sets the expected option structure for a class of Products.

Examples:

- `Clothing`;
- `Printed mug`;
- `Towel`;
- `Artwork upload Product`;
- `Logo/bulk order Product`.

The Product Type / Option Template may define likely option groups and controls, for
example:

- clothing: size, colour, optional initials, optional image;
- artwork Product: required uploaded artwork or photograph;
- logo/bulk Product: logo upload, approval required, quantity notes.

Important boundary:

```text
Product Type / Option Template is not inventory stock control.
```

It should help C1 configure Store/order capture correctly. It should not imply stock levels,
warehousing, SKU inventory, fulfilment availability or purchase-order behaviour unless a
future inventory lane is explicitly planned.

Accepted decision:

- Product Type / Option Template is not required before the first Store MVP.
- Store MVP still requires Product options, but those options can initially be configured
  directly on the Product, Project Product or Store Product.
- Product Type / Option Template should remain a later refinement for reusable C1 tenant
  default option structures across similar Products.
- Product duplication reduces the urgency of Product Type / Option Template because C1 can
  copy a configured Product and adapt its options, copy and media for a new use case.
- Do not block Store/Order schema or Store MVP on reusable Product Type / Option Template
  modelling.
- When introduced, Product Type / Option Template should be C1 tenant-configurable rather
  than a fixed module-default list, although IsoStack may provide starter examples or
  suggested defaults.
- Product Type / Option Template should initially drive default option groups and workflow
  suggestions only; hard Order validation should come from the resolved Product, Project
  Product, Store Product and Project Type / Store workflow rules used at checkout.
- C1 should be able to override template defaults per Product, Project Product or Store
  Product.
- Product Type labels and tenant terminology remain Phase 2 refinement unless the wording
  blocks safe Store/Order implementation.

Implication:

```text
Do not confuse Product options required for MVP with reusable Product Type / Option Template
abstractions. Options are first-order Store/Order behaviour; templates are later C1
configuration acceleration.
```

### 5.7 Commercial Terms And Catalogue Boundary

Wishlist item:

- `2R-CATALOGUE-04` - Catalogue Product Commercial Terms And Override Planning.

Accepted decision:

```text
Does price, VAT/tax policy and buyer-facing display copy come from Product,
Catalogue/Product membership, Event, Project Product, Store Product or Order line snapshot?
```

Accepted snapshot boundary:

- Commission is not buyer-facing Store commercial data and should not be shown to Store
  customers.
- Commission accrues as a benefit to the C2 tenant/client or fundraising beneficiary, not
  to the individual buyer.
- The Store may show fundraising progress, for example `We've raised £x for [objective]`,
  where the objective is Project-level Store/display copy.
- Buyer-facing price comes from the effective Store Product price and is snapshotted onto
  the Order line at checkout/order creation.
- The Project Store Product should expose the resolved effective commercial terms used by
  Store readiness and checkout; it must not silently read several mutable price sources.
- The Order-line snapshot must retain quantity, unit price, option modifiers, discounts,
  net, VAT/tax and gross amounts, VAT/tax rate, inclusive/exclusive display basis, currency,
  minor-unit representation and rounding basis.
- Order-level delivery, discount, tax and total evidence must also be retained where
  applicable.
- VAT/tax must be evidenced per purchase/Order line and reconciled at Order level under the
  accepted tax and rounding policy.
- Product owns first-pass base price and tax category. Catalogue membership, Event, Project
  Product and Project Store Product do not override those values in the first pass.
- The C1 tax profile supplies seller, jurisdiction, currency, rates, tax-inclusive display
  and rounding rules. The Project Store Product resolves these values for Store readiness
  and checkout without becoming another mutable commercial source.
- Commission payable should be calculated from aggregate Project sales against the
  applicable inherited Event or standalone Project commission policy, not as independently
  rounded per-transaction or per-Order-line commission.
- C1/C2 dashboards may show live estimated/accrued fundraising or commission figures, but
  final payable commission belongs to later accounting/reporting logic.

Correction to earlier planning:

```text
Commission must not be treated as a final per-transaction or per-Order-line payable value.
Order lines provide sales evidence for later aggregate Project commission calculation.
```

Do not implement per-Catalogue commercial terms in the first Store/Order model. A
differently priced seasonal or contextual offering is a duplicated, independently editable
Product. Schema-options planning must still define discount/delivery allocation, Order-total
reconciliation and refund/adjustment evidence without reopening commercial ownership.

### 5.8 Client Address, Delivery And Fulfilment Context

Wishlist item:

- `2R-CLIENT-02` - Client Address And Delivery Defaults Planning.

Accepted decision:

- Promote the bounded fulfilment-mode and delivery snapshot part of `2R-CLIENT-02` before
  Order schema, even if full address-management and dispatch UI remain deferred.
- The first-pass fulfilment mode is Project bulk delivery to the Project organiser. Products
  are not delivered directly to purchasers.
- The Order must retain an immutable Project organiser recipient/contact/address snapshot.
- The Project Type resolves one fulfilment method for the Project even though later planning
  may introduce additional methods.
- Full dispatch workflow, tracking, batching and delivery-default management may remain in
  later production/dispatch slices.

### 5.9 Production, Dispatch And Commission Dependencies

Relevant existing planning:

- `docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-i-c1-production-dispatch-commission-workflow-planning.md`

Wishlist items:

- `2R-PROD-01` - Production Workflow Refinement;
- `2R-PROD-02` - Artwork Checking Workflow;
- `2R-PROD-03` - Dispatch And Delivery Defaults;
- `2R-PROD-04` - Commission Surface Planning;
- `2R-PROD-05` - Event And Standalone Project Commission Ladder Planning, expanded from the
  original Event-window input.

Planning input:

- `docs/modules/fund/01-cr-inputs/2026-07-13-fund-cr-commission-ladder-planner-input.md`
  - Commission Ladder Planner.

Planning question addressed by the accepted boundary below:

```text
Which production, dispatch and commission calculation inputs must exist in Order/Order line
snapshots even if the first implementation does not build the full C1 production UI?
```

Accepted commission-policy hierarchy:

- An Event may define either a flat commission rate or a stepped Event commission ladder as
  the default for its linked Projects.
- A linked Project inherits that Event default unless C1 gives the individual Project an
  explicit flat-rate override for an ad-hoc commercial agreement.
- An active Project-specific policy wins only for its owning Project; it does not change the
  Event default or another linked Project.
- A standalone Project has no Event policy to inherit and therefore uses its own C1-managed
  flat or stepped Project policy.

Each stepped ladder must use exactly one timing method:

- offset-based thresholds calculated from the Project closing date;
- fixed calendar-date thresholds.

The two timing methods must not be mixed within the same ladder.

Business commission decisions are consolidated in section 9.2. Later ladder schema
planning must also define:

- which sales evidence, ladder version and calculation basis must be retained so aggregate
  Project commission can be recalculated or audited without changing historical Orders;
- how draft, active and archived ladders are handled;
- what validation prevents overlapping, duplicated or incorrectly ordered steps.

Boundary:

```text
1R-A plans ladder configuration, aggregate Project sales calculation inputs and audit
evidence. It does not implement ladder schema, services, UI, commission accounting or
payment.
```

Store/Orders must not be designed as isolated checkout features. They must leave usable
data for the C1 production/admin workflow.

Accepted boundary:

- Orders and Order lines preserve paid, cancelled, refunded and adjusted sales evidence;
  they do not calculate a final payable commission amount.
- A flat policy applies one rate to aggregate eligible Project sales.
- For a stepped policy, each eligible paid sale is assigned to the applicable ladder band
  using its recognised payment timestamp. Sales are aggregated by Project and ladder band
  before commission is calculated, avoiding independently rounded per-line commission.
- Offset-based bands use the Project closing date as their reference. Fixed-date bands use
  the dates stored on the assigned Event-default or Project-specific ladder.
- The final active band applies until Project close. After Project close the Store accepts
  no new Orders.
- Aggregate Project commission calculation belongs to later accounting/reporting logic.
- The effective ladder/policy version is resolved and offered before Store publication.
  Publication requires explicit acceptance by an authorised C2 Project organiser; C1
  configures and oversees the offer but does not moderate or approve publication.
- C1 may later propose replacement terms, including after paid sales exist. The replacement
  becomes effective only when C2 accepts it and then applies retrospectively to all eligible
  sales in the Project window. The first eligible paid sale does not lock the assignment.
- Project close fixes the sales window and later calculation period. Terms become final only
  when the post-close commission evidence is finalized; until then displayed commission is
  provisional and recalculates from the current accepted assignment.
- The assignment, calculation basis and recognition event should be preserved through a
  Project commission assignment/period record. They should not be copied independently onto
  every Order line unless later audit design demonstrates that this is required.
- Full production workflow still requires dedicated planning, but the Order contract must
  preserve Product, option, artwork, Project, Event, fulfilment and status evidence usable
  for production grouping and handoff.

### 5.10 Commerce Core Boundary

The roadmap identifies Commerce Core as a future reusable IsoStack platform lane.

Accepted decision:

- Commerce Core owns generic Commerce Orders, Order lines, checkout sessions, monetary
  totals, payments, refunds and provider/audit lifecycle.
- FUND owns Project Stores, Project Store Products and FUND-specific production,
  personalisation and Project/Event/Client context attached to Commerce records.
- Store configuration and readiness work may proceed before payment integration, but Order
  capture must not introduce a parallel FUND-only commerce architecture.
- Manual/offline payment is a Commerce payment method/status, not a reason to create a
  separate FUND Order model.
- Payment integration waits for the Commerce Core provider boundary, webhook/idempotency,
  audit and tenant-safety model.
- A separate Commerce Core schema-options planning document must be created outside FUND
  and aligned with FUND as its first or an early consumer.
- `docs/00-overview/e-commerce-analysis-options.md` is an old feature-bundle/subscription
  analysis, not an authoritative Commerce Core design input. Replace or clearly retire that
  reference when the dedicated Commerce Core planning document is created.

## 6. Relevant Wishlist Items Pulled Into This Planning Slice

The following dispositions are accepted. Promotion means the stated planning or foundation
boundary is required; it does not automatically authorise the full wishlist implementation.

| Wishlist ID | Accepted disposition | Boundary |
| --- | --- | --- |
| `2R-CATALOGUE-02` | Partially promote | Define a bounded Product/Store readiness checklist before public Store UI. |
| `2R-CATALOGUE-04` | Boundary resolved / implementation parked | Product and C1 tax profile are the accepted sources. Do not add per-Catalogue commercial overrides in the first Store/Order model. |
| `2R-PRODUCT-01` | Partially promote | Require one primary Store image and immutable media reference; defer full galleries. |
| `2R-PRODUCT-02` | Partially promote | Require typed options/inputs, choices, required/default flags, simple modifiers, validation, versioning and snapshots. Defer advanced image mapping and dependency graphs unless an accepted MVP Product requires them. |
| `2R-PRODUCT-03` | Promote | Product duplication is required Product Manager behaviour before Store preparation relies on distinct seasonal or differently priced Products. Copy Product configuration without introducing per-Catalogue commercial overrides. |
| Future `2R-PRODUCT-04` | Park | Reusable Product Type / Option Templates are later configuration acceleration, not an MVP blocker. |
| `2R-CLIENT-02` | Partially promote | Decide fulfilment mode and immutable delivery/contact snapshot boundary before Order schema; defer full address-management UI. |
| `2R-PROD-01` | Use as constraint | Preserve production grouping and handoff evidence; defer full workflow. |
| `2R-PROD-02` | Partially promote | Define minimum immutable asset/version, validation and review evidence before Store/Order schema. |
| `2R-PROD-03` / `2R-PROD-04` | Use as constraints | Preserve dispatch and commission evidence; defer full workflows and surfaces. |
| `2R-PROD-05` | Promote architecture only | Cover Event-default policies, C1 Project-specific overrides and standalone Project policies. Decide version and aggregate-sales audit boundaries; defer ladder UI/accounting. |
| `2R-EVENT-03` / `2R-EVENT-04` | Use as constraints | Resolve the Store/Project/Event date hierarchy and later reuse it for reminders and commission timing. |
| `2R-DASH-01` / `2R-DASH-02` | Park | Wait until accepted Store/Order states exist. |

## 7. Proposed 1R Sub-Slices

Recommended sequence:

### 1R-A - Store, Orders And Commerce Core Planning

This document.

Output:

- accepted Store/Order/Commerce architecture;
- promoted wishlist decisions, if any;
- implementation split for schema/API/UI.

### 1R-B - Commerce Core And FUND Store Schema Options Planning

Planning only. Required before schema implementation.

Scope:

- define Commerce Core ownership of Order, Order line, checkout, money, payment and refund;
- define FUND ownership of Project Store, Project Store Product and production extensions;
- define cross-core references, tenancy, public access and audit boundaries;
- resolve effective commercial terms, tax evidence, fulfilment modes and state dimensions;
- define option/input precedence, configuration versioning and immutable snapshots;
- define immutable asset/version evidence and retention boundary;
- produce the accepted split between Commerce Core schema and FUND schema.

### 1R-C - FUND Project Store And Store Product Schema Foundation

Potential implementation scope after 1R-B passes:

- explicit Project Store and Project Store Product records;
- Store lifecycle and date-window fields;
- Product option/input definitions required by the accepted MVP boundary;
- primary Product media reference required for Store readiness;
- Product duplication foundations needed to create independent seasonal or differently
  priced Products from an existing configured Product;
- Project-level production asset/evidence references;
- readiness, audit and same-tenant foundations;
- no Commerce Order, checkout or payment schema inside FUND.

### 1R-D - Store Readiness And C1 Store Configuration API/Services

Potential scope:

- derive Project Store Products from active selected `FundProjectProduct` rows;
- revalidate current eligibility and all accepted purchasability gates;
- resolve and version copy, options/inputs and commercial terms;
- provide safe Product duplication that copies Product configuration while assigning a new
  Product identity and independent future edit path;
- expose Store readiness checks and publish/pause/close actions;
- preserve same-tenant safety;
- no checkout/payment.

### 1R-E - C1 Store Management UI

Potential scope:

- Project detail Store tab;
- Project Store Product management;
- Product Manager duplication action and target Catalogue selection where included in the
  accepted implementation split;
- Store readiness warnings and lifecycle actions;
- no public checkout until the Store and Commerce foundations pass review.

### 1R-F - Public/C2 Store Display MVP

Potential scope:

- the accepted public and/or authenticated Store mode;
- resolved Product list and primary images;
- Product option/input controls required for MVP;
- safe unavailable and readiness states;
- no Order submission until Commerce Core Order capture is accepted.

### Commerce Core implementation lane - exact slice identifier to be assigned

This is a separate IsoStack core lane, aligned with FUND requirements. Its planning and
implementation should cover Commerce Order/line snapshots, checkout idempotency, monetary
totals, payment/refund state, purchaser/contact evidence and provider boundaries.

### Later 1R consumer slices - identifiers to be assigned after Commerce Core planning

- FUND Order capture integration and production-extension validation;
- C1/C2 Order visibility with explicit privacy and scope rules;
- production/admin handoff indicators;
- payment-provider integration only after provider, webhook, idempotency, audit and tenant
  safety are accepted.

## 8. Non-Negotiable Rules

- Store must be Project-scoped.
- Store and Store Product must be explicit records.
- Store Products must come from active selected `FundProjectProduct` rows and remain
  purchasable only while all eligibility, visibility, lifecycle and readiness gates pass.
- Commerce Core owns generic Order, Order line, checkout, money, payment and refund
  lifecycles; FUND must not create a parallel generic commerce model.
- Order lines must snapshot mutable commercial and Product display data.
- Order lines must snapshot selected Product options, Order-level purchaser uploads/artwork
  evidence and validation state where those are required for the Product/Project workflow.
- Order lines must snapshot C1-configured custom field values where those fields are used
  for a Product/Project Product.
- Project-level artwork/files must be modelled separately from Order-line purchaser uploads
  where the Project Type supplies production inputs before purchase.
- Product options are the default model for buyer choices; Product Variants should only be
  introduced where a choice combination needs its own SKU, stock, image, weight, fixed
  price or fulfilment treatment.
- Catalogue membership must not override Product commercial/configuration data in the first
  pass; distinct seasonal or differently priced offerings use independent Product copies.
- Safe, idempotent Product duplication is required before Store preparation relies on it.
- Option/input resolution must be versioned and revalidated at submission.
- Payment, Order, production and fulfilment statuses must be separate.
- Order creation, payment handling and webhooks must be idempotent.
- Fulfilment mode and applicable delivery/contact evidence must exist before Orders are
  treated as operationally useful.
- Orders preserve sales/refund/adjustment evidence for later aggregate commission; they do
  not calculate final payable commission.
- Event-linked Projects use their Event's default commission policy unless C1 assigns an
  explicit Project-specific flat-rate override. Standalone Projects use a C1-managed flat
  rate or ladder.
- File evidence must use immutable asset versions and an explicit retention/privacy policy.
- Removing a Product after Orders exist must not corrupt historical Orders.
- C1 admin/production workflow must remain visible in the design.
- C2/public Store access must not expose C1 supplier internals.
- Same-tenant checks must apply to Store, Order and Product selection reads/mutations.
- Public Store access must resolve tenant and Store scope from a non-enumerable public Store
  identifier rather than trusting caller-supplied tenant context, and it must enforce
  published/open state on every read and mutation.
- C2 Order access must apply explicit Project/Client scope and purchaser-privacy rules.
- Phase 2 refinements should stay parked unless they block safe Store/Order snapshots.

## 9. Decision Register And Remaining Questions

### 9.1 Accepted Architecture

| Decision | Status |
| --- | --- |
| Keep the work in the Phase 1 `1R` family | Accepted |
| Store source is selected `FundProjectProduct`, deduplicated by Product identity | Accepted |
| Use explicit Project Store and Project Store Product records | Accepted |
| Use full purchasability gates, not active selection alone | Accepted |
| Commerce Core owns generic Order/line/checkout/payment/refund concepts | Accepted |
| FUND owns Store and production/personalisation context attached to Commerce records | Accepted |
| Order lines retain immutable resolved commercial, Product, input and asset evidence | Accepted |
| Product options/typed inputs are required for MVP; Variants remain exceptional | Accepted |
| Product remains commercially consistent across Catalogues; distinct offerings use Product duplication | Accepted |
| Product duplication is required Product Manager behaviour | Accepted |
| Reusable Product Type / Option Templates remain deferred | Accepted |
| Primary Store media is required; full galleries may be deferred | Accepted |
| Project-level and Order-line assets remain separate | Accepted |
| Fulfilment mode and delivery/contact snapshot boundary precede Order schema | Accepted |
| Payment, Order, production and fulfilment states remain separate | Accepted |
| Stripe is the first online provider; pro-forma invoice is a separate Commerce route | Accepted |
| Event-linked Projects inherit the Event default unless C1 assigns a Project-specific override | Accepted; revised 2026-07-14 from unoverrideable Event policy after client input |
| Every standalone Project uses a C1-managed Project flat rate or ladder | Accepted |
| Commission is calculated later from aggregate Project sales evidence | Accepted |

### 9.2 Accepted Business And Workflow Decisions

#### Public Store Access And Branding

The first Store is public and does not require purchaser authentication.

Each Store has a non-enumerable public URL that identifies and allocates the purchase to the
correct Project. The same URL may be distributed directly, encoded as a QR code, embedded
in a C2 website where framing is supported, or shared through services such as Facebook.

Facebook sharing should use the public Store link and appropriate preview metadata rather
than assuming that Facebook supports an embedded storefront.

The standalone FUND Store page should use:

1. the C2 Client logo and permitted branding where supplied;
2. the C1 tenant logo and branding as fallback.

Event imagery may provide Store context, such as an Event banner, without changing the
underlying Product identity or commercial terms.

Purchasers do not need an IsoStack account. Checkout should capture only the purchaser
identity and contact information required for payment, receipts, Order administration and
the accepted production workflow.

#### Store Dates And Lifecycle

A Project Store does not have an independent opening or closing date.

The Project opening and closing date/time determine the Store trading window exactly. C2
changes the Store window by editing the Project dates where C1 permissions allow it.

This produces the rule:

```text
Project dates and times determine the Store trading window.
```

Store lifecycle remains separately controllable by C1. A Store must still be published and
may be paused or closed manually even while the Project is inside its trading window.

All date/time evaluation must use the Project's accepted timezone rules.

#### Seller And Commercial Ownership

The legal seller is the C1 tenant.

The C2 Client provides the Project context and fundraising outlet, but it does not become
the supplier or seller of record. The Order must snapshot the effective C1 legal seller and
tax profile used at checkout.

The C1 tax profile should define at least:

- legal seller name and address;
- VAT/tax registration details where applicable;
- operating jurisdiction and currency;
- whether public prices are tax-inclusive or tax-exclusive;
- tax-point and rounding policy.

Product owns the first-pass base price and Product tax category.

Product tax categories must distinguish standard-rated, reduced-rated, zero-rated and
exempt treatment. For example, qualifying children's clothing is zero-rated rather than
exempt. FUND must not infer tax treatment from a Product name; C1 configures the Product tax
category and the effective C1 tax profile supplies the applicable rate.

Public Store prices should be tax-inclusive by default. Checkout must show the net, VAT/tax
and gross calculation explicitly, including a zero amount and the applicable category where
the Product is zero-rated or exempt.

Money is stored and calculated using integer currency minor units. VAT/tax is calculated
consistently at Order-line level, rounded to the nearest minor unit using the accepted C1
tax-profile rule, and reconciled to the Order total.

Catalogues are merchandising and availability collections. One Product remains consistent
across every Catalogue that references it. Catalogue membership does not override the
Product's price, options, tax category or Product media in the first pass.

For example, a Christmas Mug and Father's Day Mug may be distinct configured Product
records even when they use the same underlying physical mug. Event and Catalogue imagery
may provide seasonal Store context, while the Product remains the source of its price.

Product duplication is therefore essential Product Manager behaviour. C1 may use a suitably
named Product as a starting point, duplicate it, and independently change the copy's name,
price, media, options and other configuration for a seasonal or contextual offering.

Duplication must:

- create a new Product identity and unique reference;
- copy Product details, price/tax configuration, suitability rules, options, choices and
  custom input definitions within the accepted boundary;
- copy media associations so the new Product can change them independently without
  duplicating immutable binary assets unnecessarily;
- allow C1 to choose the target Catalogue membership rather than silently copying all source
  Catalogue memberships;
- be idempotent so retries cannot create unintended duplicate Products.

The Project Store Product resolves the Product, relevant presentation context and effective
commercial terms for Store display and checkout.

#### Fulfilment And Production Aggregation

The first-pass fulfilment method is Project bulk delivery to the Project organiser. Products
are not shipped directly to individual purchasers.

Each Project has one fulfilment method determined by its Project Type. The Order snapshots
the Project, organiser delivery recipient and delivery address that applied when the Order
was submitted.

Commerce Orders remain the accounting and purchaser record, including mixed-product
baskets. FUND production must provide a separate projection that can:

- flatten Order lines into production units where necessary;
- group and total quantities by Project and Project Store Product;
- subdivide totals by relevant option or personalisation configuration;
- preserve traceability from every production unit or aggregate back to its Order line;
- export production-oriented data without corrupting the original Order.

An Order containing Product X and Product Y must therefore remain commercially intact while
production can independently total Product X and Product Y across all eligible paid Orders
for the Project.

#### Artwork And Production Inputs

Artwork requirements are resolved from Project Type/workflow and refined by Product or
Project Store Product requirements.

The first-pass workflow interpretation is:

- `Individual Artwork Project`
  - purchaser upload is normally `ORDER_LINE_LEVEL`;
  - the upload is supporting/backstop evidence because original artwork may arrive through
    an offline channel;
  - it does not normally block Store publication;
  - whether it blocks Order submission follows the accepted C1 submission policy.

- `Group personalised product project`
  - Project artwork is normally `PROJECT_LEVEL` or `HYBRID`;
  - C2 supplies source artwork/data;
  - C1 reviews and collates it and may create composite Store Product imagery;
  - publication is blocked when required sellable presentation imagery or other explicitly
    required Store inputs are not ready.

- `Bulk order / club-funded project`
  - logo/source artwork is normally `PROJECT_LEVEL` or `HYBRID`;
  - C1 may need to approve artwork and create Store Product imagery before publication;
  - additional names, quantities or production data may be collected through the Store,
    an uploaded file or a manual/pro-forma route.

- Products without artwork requirements use `NONE`.

Artwork review and Store readiness are related but separate. Suggested minimum artwork
states are:

- `NOT_REQUIRED`;
- `AWAITING_UPLOAD`;
- `SUBMITTED`;
- `UNDER_REVIEW`;
- `CHANGES_REQUIRED`;
- `APPROVED`.

Store readiness should separately record whether required sellable presentation media and
production inputs are ready. Approval should block publication only where the resolved
workflow declares it to be a publication requirement.

Missing mandatory Project inputs should block publication or the affected Store Product
elegantly, using a readiness checklist with a clear explanation and direct corrective
action.

#### Upload Policy

All upload requirements may accept multiple files. The pre-upload UI must allow selected
files to be reviewed and removed before submission.

FUND should accept a broad C1-configurable set of ordinary business and artwork formats,
including common image, PDF and Office-document formats. Broad file support must not mean
unrestricted executable or script upload.

Every upload must be subject to:

- permitted-type and MIME/content validation;
- configurable size and count limits;
- malware scanning and quarantine;
- immutable asset-version evidence;
- safe preview/download behaviour;
- retention and privacy policy.

For required Order-line uploads, C1 Settings should provide:

- `BLOCK_SUBMISSION`; or
- `ALLOW_WITH_DISCLAIMER`.

`BLOCK_SUBMISSION` should be the safe default. Disclaimer wording should have a proposed
default and be editable by C1. The applied policy, displayed wording, purchaser
acknowledgement and missing-input state must be snapshotted with the Order line.

#### Product Options, Images And Custom Fields

No advanced dependent-option requirement has yet been identified for the first pass.

A dependent option is a rule where one answer changes which later answers are available,
for example:

```text
Size = Small -> Red, Blue or Green
Size = Large -> Red or Blue only
```

Complex dependency graphs may therefore remain deferred unless a confirmed Product requires
them.

A colour choice that changes the displayed Product image is option-to-image mapping. It does
not require a Product Variant unless that choice also needs its own SKU, stock, weight,
fixed price or fulfilment treatment.

No genuine first-pass Product Variant has yet been identified.

C1-managed custom Order-line fields are required in the first Commerce integration.
Initial field types should prioritise short text and other simple typed controls.

Examples include:

- child's name;
- class;
- team or group;
- production reference;
- delivery-routing note.

These values belong to the Order line because the purchaser may not be the child or intended
recipient. Submitted definitions, labels and values must be snapshotted for production and
historical clarity.

One Order line represents one resolved Product and personalisation configuration. Several
identical units with the same options, name, artwork and other inputs may use one line with a
quantity greater than one. Units with different personalisation must be added as separate
configured basket lines and become separate Order lines. Production may later flatten a
line quantity into traceable production units without changing the commercial Order.

#### Payment And Manual/Pro-Forma Routes

Stripe is the accepted first online payment provider.

Online provider payment is required for normal individual and group-artwork basket Orders,
including mixed baskets and quantities greater than one.

Logo and bulk workflows may use either:

- the same online Store and provider-payment route;
- a manual/offline payment route;
- a pro-forma invoice route.

These remain Commerce Core payment and Order routes rather than separate FUND Order models.
The Project Type and effective Store configuration should determine which routes are
available.

Accepted first-pass route and status concepts are:

```text
Payment route:
- STRIPE_ONLINE
- PRO_FORMA_INVOICE

Payment status:
- NOT_REQUIRED
- PENDING
- PAID
- FAILED
- CANCELLED
- PARTIALLY_REFUNDED
- REFUNDED

Pro-forma status:
- DRAFT
- ISSUED
- ACCEPTED
- CANCELLED
- SETTLED
```

`SETTLED` means the corresponding offline/manual payment has been received and recorded.
Schema-options planning may refine naming and decide whether an overdue state is required,
but it must preserve the separation between Order, payment and pro-forma lifecycle.

#### Commission Window

Commission policy resolves by Project context:

- an Event-linked Project uses the commission policy configured on its Event by default;
- C1 may replace that default for one Project with an explicit Project-specific flat-rate
  policy for an ad-hoc commercial agreement;
- the Project-specific policy wins only for that Project and leaves the Event default
  unchanged for other linked Projects;
- a standalone Project uses a C1-managed Project policy because there is no Event policy to
  inherit;
- an Event default or standalone Project policy may be flat or stepped, while an
  Event-linked Project override is flat only;
- a stepped ladder uses either offset-based thresholds or fixed calendar dates, never both.

For offset-based ladders, the Project closing date is the timing reference. For fixed-date
ladders, the configured assigned Event-default or Project-specific dates apply directly.

Each eligible paid sale is assigned to the ladder band active at its recognised payment
timestamp. Eligible sales are aggregated by Project and band, then commission is calculated
on each aggregate rather than independently rounded on every Order line. A flat policy uses
one rate for all aggregate eligible Project sales.

The final active ladder step applies until the Project closes. Once the Project closing
date/time passes, the Store no longer accepts new Orders.

The effective inherited, standalone or Project-override policy version is resolved and
offered before Store publication. An authorised C2 Project organiser must explicitly
accept the offer before publication; C1 has configuration and overview responsibility but
does not moderate publication. A later C1 replacement offer, including one made after paid
sales exist, becomes effective only when C2 accepts it and then applies retrospectively to
all eligible sales in the Project window. The first eligible paid sale does not lock the
assignment. Project close fixes the sales window and later calculation period; final terms
are locked only when the post-close commission evidence is finalized. Until then any
displayed earned commission is provisional and recalculates from the current accepted
assignment. Later payment reconciliation, refunds or adjustments must remain auditable
without changing the historical Store window.

All section 9.2 decisions required to begin `1R-B` are now recorded. Schema-options planning
may refine entity and enum names without reopening these business boundaries.


### 9.3 May Be Answered Before Later UI Slices

1. Which C1 dashboard action cards are needed once Stores and Orders exist?
2. Should the old C2 dashboard placeholder Orders tab be wired in this lane or later?
3. Which Order details may C2 organisers see without exposing purchaser-sensitive or C1
   supplier/production information?
4. What fallback should the Store show if a selected Product has no valid primary image?

## 10. Review/Test Expectations For This Planning Slice

Planning review should confirm:

- the `1R` naming is accepted;
- no premature Phase 2 `2A` refinement boundary is introduced;
- Store source and purchasability gates are explicit;
- Project Store and Project Store Product ownership is explicit;
- Commerce Core and FUND ownership are separated;
- Order snapshot boundaries are explicit;
- Project-level and Order-line production input gates are explicitly accepted, parked or
  promoted;
- Product option dependency handling is explicitly accepted, parked or promoted;
- C1-managed custom Order field handling is explicitly accepted, parked or promoted;
- the Ecwid appraisal has been used as a reference model without importing Ecwid-specific
  constraints that do not fit FUND;
- Product Type / Option Template planning is explicitly accepted, parked or promoted;
- production/dispatch/commission constraints are not lost;
- relevant wishlist items are either parked or promoted deliberately;
- all business decisions required by section 9.2 are recorded;
- `1R-B` can produce a cross-core schema split without unresolved foundation questions.

## 11. 1R-B Planning Handoff

Created planning document:

```text
docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-b-commerce-core-and-fund-store-schema-options-planning.md
```

Next review prompt:

```text
Review and accept FUND Phase 1 Slice 1R-B Commerce Core And FUND Store Schema Options
Planning. Do not implement Commerce Orders or payment inside FUND. Create 1R-C FUND
Store/Input Schema Foundation planning for the accepted FUND-owned models, and create a
separate IsoStack Commerce Core planning slice for the commerce-schema foundation.
```
