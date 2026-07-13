# FUND Phase 1 Slice 1R-A - Store, Orders And Commerce Core Planning

Date: 2026-07-08

Status: Planning

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

Decide whether Store should be represented by an explicit record such as a Project Store or
whether the first Store view can be derived from Project state.

Draft decision:

- Most Projects should have a Store by default.
- Project-level Store enablement should be configurable, defaulting to enabled.
- Store visibility should be gated by Project status, then Project close/end date, then optional Store closing date.
- Store closing date should inherit the Project closing date by default, may be earlier, and must not be later.
- C1 should have explicit Publish, Pause and Close actions.
- C2 may manage Store-facing Project settings only within C1-defined boundaries.
- If no Products are selected, the Store should show a safe unavailable state with organiser contact details.

### 5.2 Store Product Source

Accepted rule:

```text
Store Products = active selected FundProjectProduct rows for the Project.
```
Draft decision:

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

Orders must not depend on live mutable Product fields for historical correctness.

Plan snapshot fields for:

- Product code/name/description at time of order;
- Project Product identity;
- price, VAT, currency;
- Product option choices where applicable;
- C1-configured custom Product/Project Product field values where applicable;
- personalisation/artwork/person fields where applicable;
- Project-level artwork, images or file references where the Project Type/workflow supplies
  production inputs before purchase;
- Order-line purchaser-supplied images, photographs, artwork or file references where the
  buyer supplies production inputs at purchase time;
- whether required Project-level or Order-level artwork/images/files were present at
  submission time;
- Store/Project/Event context;
- Client/C2 organisation context;
- production status inputs;
- fulfilment/dispatch context.

Questions:

- Are Order lines linked to `FundProjectProduct`, Product, both, or a dedicated Store
  Product snapshot? This is a dedicated Store Product / Project Store Product layer, with Order Lines linked to it plus their own immutable snapshots.


Does an Order need to know source Catalogue, or is selected Project Product enough?

Draft decision:

- Selected Project Product / Store Product is enough as the Order source of truth.
- Order and Order line snapshots may retain Catalogue source context for audit, reporting
  and C1 admin traceability.
- Catalogue context must not create duplicate Store Products or duplicate Order lines.
- If a Product was available through multiple Catalogues, the snapshot should either retain
  all relevant source Catalogue references or the specific C1-selected display/source
  context, without changing the Product identity.
- Public/C2 Store and buyer-facing Order views should not expose Catalogue source badges by
  default.

At what point are price/VAT/currency snapshotted?

Draft decision:

- Cart lines may capture provisional price, VAT and currency at the point they are added to
  the cart or the checkout cart is created.
- Before checkout/order submission, the system must revalidate Store availability, Product
  visibility, selected options, required uploads and current price/VAT/currency.
- The immutable Order and Order-line price/VAT/currency snapshot should be created when the
  buyer submits checkout and the Order is created, before or alongside payment initiation.
- Payment confirmation should update payment status only and should not recalculate historic
  Order-line price/VAT/currency.
- If a checkout session expires or fails before Order creation, a new checkout should use
  the then-current Store Product price/VAT/currency.


At what point are Product option choices, Project-level artwork requirements and
Order-line purchaser uploads validated and snapshotted?

Draft decision:

- Product option choices may be captured provisionally in the cart.
- Project-level artwork/file requirements should be checked when the Store Product is added
  to checkout and revalidated at Order submission.
- Order-line purchaser uploads should be validated before Order submission where they are
  required for the selected Product/Project workflow.
- The immutable snapshot of selected options, required artwork/file evidence, upload
  references and validation state should be created when the buyer submits checkout and the
  Order/Order lines are created.
- Payment confirmation should not alter option, artwork or upload snapshots.

- What happens if C1 removes a selected Product after Orders exist?

Draft decision:

- If Orders exist for a selected Project Product or Store Product, hard removal should be
  prevented.
- C1 should use visibility controls instead: hide, pause, close or archive the Store Product.
- Hidden/archived Products should no longer be purchasable but must remain available for
  historical Orders, production, dispatch, reporting and commission audit.
- C1 admin should clearly show that the Product cannot be removed because historic Orders
  depend on it.

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

Draft decision:

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

Planning must decide whether upload requirements are configured:

- on the Project Type / Store workflow;
- on the Product;
- on the Product Type / Option Template;
- on Project Product;
- on Store Product;
- on a specific Product option;
- or as a combination of Project Type / Store workflow plus Product/Product Type rules.

Decision needed:

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

Decision needed:

```text
Are Product options, option dependencies or upload requirements required for a safe Store
MVP, or can Store MVP proceed with simple Product display and defer richer presentation?
```

Draft decision:

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

Draft decision:

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

### 5.7 Per-Catalogue Commercial Terms

Wishlist item:

- `2R-CATALOGUE-04` - Catalogue Product Commercial Terms And Override Planning.

Decision needed before Order snapshots:

```text
Does price, VAT/tax policy and buyer-facing display copy come from Product,
Catalogue/Product membership, Event, Project Product, Store Product or Order line snapshot?
```

Draft decision:

- Commission is not buyer-facing Store commercial data and should not be shown to Store
  customers.
- Commission accrues as a benefit to the C2 tenant/client or fundraising beneficiary, not
  to the individual buyer.
- The Store may show fundraising progress, for example `We've raised £x for [objective]`,
  where the objective is Project-level Store/display copy.
- Buyer-facing price comes from the effective Store Product price and is snapshotted onto
  the Order line at checkout/order creation.
- The Order line snapshot must retain final price, VAT/tax amount, VAT/tax rate,
  VAT/tax-inclusive or VAT/tax-exclusive display basis, and currency.
- VAT/tax is calculated per purchase/order line because buyer receipts, invoices and
  payment records need point-in-time tax evidence.
- C1 needs a Store/Event/Catalogue commercial decision for whether displayed prices include
  or exclude VAT/tax and which VAT/tax rate applies.
- Commission payable should be calculated from aggregate Project sales against the
  applicable Project/Event commission ladder, not as independently rounded per-transaction
  or per-Order-line commission.
- C1/C2 dashboards may show live estimated/accrued fundraising or commission figures, but
  final payable commission belongs to later accounting/reporting logic.

Correction to earlier planning:

```text
Commission must not be treated as a final per-transaction or per-Order-line payable value.
Order lines provide sales evidence for later aggregate Project commission calculation.
```

Unresolved commercial-term source decisions:

- whether first-pass buyer-facing price can safely come from Product only;
- whether Event-level or Catalogue-level VAT/tax policy is needed before checkout;
- whether Store Product needs an effective commercial terms snapshot layer before Orders;
- whether Project Product should carry commercial overrides or only selection state;
- how public Store price display should show VAT/tax-inclusive versus VAT/tax-exclusive
  amounts;
- how refunds, cancellations or adjustments feed the aggregate Project sales basis used for
  later commission accounting.

Do not implement per-Catalogue commercial terms inside the first Store picker. But before
Orders are implemented, decide whether the first version can safely use Product-level price
and simple C1 tax policy only, or whether commercial terms need a planned Event,
Catalogue, Project Product or Store Product snapshot layer.

### 5.8 Client Address, Delivery And Fulfilment Context

Wishlist item:

- `2R-CLIENT-02` - Client Address And Delivery Defaults Planning.

Decision needed:

```text
Can Orders be implemented safely without structured Client/Project delivery defaults?
```

If first Store/Orders work does not include dispatch, delivery defaults may be deferred.

If Orders need shipping/fulfilment from the outset, promote Client address/delivery
planning before implementation.

### 5.9 Production, Dispatch And Commission Dependencies

Relevant existing planning:

- `docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-i-c1-production-dispatch-commission-workflow-planning.md`

Wishlist items:

- `2R-PROD-01` - Production Workflow Refinement;
- `2R-PROD-02` - Artwork Checking Workflow;
- `2R-PROD-03` - Dispatch And Delivery Defaults;
- `2R-PROD-04` - Commission Surface Planning;
- `2R-PROD-05` - Event-Window Commission Ladder Planning.

Planning input:

- `docs/modules/fund/01-cr-inputs/2026-07-13-fund-cr-commission-ladder-planner-input.md`
  - Commission Ladder Planner.

Decision needed:

```text
Which production, dispatch and commission calculation inputs must exist in Order/Order line
snapshots even if the first implementation does not build the full C1 production UI?
```

Commission ladder planning must decide whether C1 can configure:

- a flat commission rate for an Event or Project;
- a stepped Event-level ladder inherited by linked Projects;
- a Project override that uses either a Project-specific ladder or a flat rate.

Each ladder must use exactly one timing method:

- offset-based thresholds calculated from the relevant closing date;
- fixed calendar-date thresholds.

The two timing methods must not be mixed within the same ladder.

Open commission calculation decisions:

- which closing date controls offset calculations when a Project closes before its Event;
- what commission applies after the final ladder threshold has passed;
- whether the applicable ladder/rate basis is evaluated from Store close, Project close,
  payment totals, production/dispatch milestone or another explicit accounting event;
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

### 5.10 Commerce Core Boundary

The roadmap identifies Commerce Core as a future reusable IsoStack platform lane.

Decision needed:

- Is first FUND Store an enquiry/order capture flow without payment?
- Is first FUND Store allowed to create Orders with manual/offline payment status?
- Does payment integration wait for platform Commerce Core?
- If payment is included, what provider boundary, webhook/audit policy and tenant safety
  model is required?

This slice should avoid hard-coding a FUND-only payment architecture if platform Commerce
Core is likely to become shared infrastructure.

## 6. Relevant Wishlist Items Pulled Into This Planning Slice

These wishlist items are not automatically promoted to implementation, but they must be
considered because they may affect safe Store/Orders/Commerce design:

| Wishlist ID | Relevance To 1R-A | Initial Position |
| --- | --- | --- |
| `2R-CATALOGUE-02` | Catalogue/Product public Store readiness | Treat as a Store readiness review input. |
| `2R-CATALOGUE-04` | Pricing, VAT/tax policy and buyer-facing display copy may affect Store/Product and Order snapshots | Decide commercial-term source before Orders. Do not implement in 1R-A. |
| `2R-PRODUCT-01` | Product media and conditional Project/Order uploads may be needed for Store confidence, production readiness and Order evidence | Decide whether MVP blocker. |
| `2R-PRODUCT-02` | Product options, option images, dependency rules and conditional upload requirements may be needed for valid Store/Order flows | Promote if Project or Order flows require options, uploads or dependent choices. |
| Future `2R-PRODUCT-04` | Product Type / Option Template planning may simplify repeated C1 Product configuration | Park as later refinement; Store MVP needs Product options, not reusable templates. |
| `2R-CLIENT-02` | Delivery defaults may affect fulfilment-ready Orders | Promote if dispatch/shipping is in first Order scope. |
| `2R-PROD-01` to `2R-PROD-04` | Store/Orders must support production, dispatch and commission later | Use as constraints, not immediate implementation. |
| `2R-PROD-05` | Commission ladders affect aggregate Project-sales commission calculation and audit evidence | Promote into 1R-A planning as a dependency; do not implement ladder schema/UI/accounting in 1R-A. |
| `2R-EVENT-03` / `2R-EVENT-04` | Event dates/windows may drive Store open/close and later reminders | Use as date-window design context. |
| `2R-DASH-01` / `2R-DASH-02` | C1 dashboard may need Store/Order action cards later | Keep parked until Store/Order states exist. |

## 7. Proposed 1R Sub-Slices

Recommended sequence:

### 1R-A - Store, Orders And Commerce Core Planning

This document.

Output:

- accepted Store/Order/Commerce architecture;
- promoted wishlist decisions, if any;
- implementation split for schema/API/UI.

### 1R-B - Store And Order Schema Foundation

Likely schema-only or schema/API foundation.

Potential scope:

- Project Store or Store state model if accepted;
- Order model;
- Order line model;
- Product option, option choice and Order line option snapshot model if accepted as a
  first-order requirement;
- C1-managed custom field definition and Order line custom field snapshot model if accepted
  as a first-order requirement;
- Product Variant boundary only if options alone cannot represent the first Store/Order
  products safely;
- Order snapshot fields;
- sales evidence fields needed for later aggregate Project commission calculation if
  accepted as a first-order requirement;
- Project-level and Order-line file reference fields if accepted as first-order requirement;
- status enums;
- audit events;
- no public Store UI and no payment integration unless explicitly accepted.

### 1R-C - Store Readiness And C1 Store Configuration API/Services

Potential scope:

- derive Store Products from active `FundProjectProduct`;
- expose Store readiness checks;
- publish/pause/close Store actions if accepted;
- C1 same-tenant safety;
- no checkout/payment.

### 1R-D - C1 Store Management UI

Potential scope:

- Project detail Store tab;
- selected Project Products visible as Store Products;
- Store readiness warnings;
- Store lifecycle actions;
- no public checkout unless 1R-C passes.

### 1R-E - Public/C2 Store Display MVP

Potential scope:

- public or C2-accessible Store display;
- Product list from selected Project Products;
- Product option controls if required for MVP;
- Project-level readiness indicators or Order-line upload controls if required for MVP;
- safe unavailable states;
- no payment if Commerce Core is deferred.

### 1R-F - Order Capture API/Services

Potential scope:

- create Orders;
- snapshot Order lines;
- validate required Product options;
- validate required Project-level production inputs and Order-line purchaser uploads where
  applicable;
- prevent Orders for unavailable Stores or unavailable Products;
- no provider payment unless accepted.

### 1R-G - C1/C2 Order Visibility And Management UI

Potential scope:

- C1 Order list/detail;
- C2 Project/Client Order visibility;
- status transition policy;
- production/admin handoff indicators.

### 1R-H - Commerce/Payment Integration Planning Or Implementation

Only start after the platform Commerce Core boundary is accepted.

## 8. Non-Negotiable Rules

- Store must be Project-scoped.
- Store Products must come from active selected `FundProjectProduct` rows.
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
- Payment status and production status must be separate.
- Removing a Product after Orders exist must not corrupt historical Orders.
- C1 admin/production workflow must remain visible in the design.
- C2/public Store access must not expose C1 supplier internals.
- Same-tenant checks must apply to Store, Order and Product selection reads/mutations.
- Phase 2 refinements should stay parked unless they block safe Store/Order snapshots.

## 9. Open Questions

1. Should first Store implementation be public, authenticated C2-only, or both?
2. Should first Order implementation include payment or manual/offline status only?
3. Is Product media required for Store MVP?
4. Are Product options required before any Order can be safely created?
5. Which Project Types require Project-level production artwork/files, Order-line
   purchaser uploads, hybrid uploads, optional uploads or no uploads?
6. Can a workflow require multiple files or different file types?
7. Should missing required Project-level inputs block Store opening/Product selection?
8. Should missing required Order-line uploads block Order submission or create incomplete
   Orders?
9. Does C1 need artwork approval states before Orders can move into production?
10. Does the first Order model need dependent Product option validation?
11. Should a Product Type / Option Template model be introduced before Store MVP?
12. Do first-pass options need price modifiers, required/default flags and option-choice
    snapshots?
13. Are C1-managed custom fields needed in the first Order model, or can all first-pass
    fields be represented as Product options?
14. Are any first-pass buyer choices genuinely Product Variants rather than Product options?
15. Does price come from Product, Project Product, Store Product or Order line?
16. Should Store have its own open/close dates or inherit Project/Event dates?
17. Should Event windows later drive Store reminders and commission ladders?
18. What minimum dispatch/delivery data is required before Orders are useful?
19. What C1 dashboard action cards are needed once Stores and Orders exist?
20. Should old C2 dashboard placeholder Orders tab be wired in this lane or later?

## 10. Review/Test Expectations For This Planning Slice

Planning review should confirm:

- the `1R` naming is accepted;
- no premature Phase 2 `2A` refinement boundary is introduced;
- Store source is selected Project Products only;
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
- the next implementation slice can be created without unresolved foundation questions.

## 11. Suggested Implementation Prompt After Acceptance

```text
Proceed with FUND Phase 1 Slice 1R-A planning review. Do not implement code. Confirm the
Store/Orders/Commerce architecture, decide which wishlist items must be promoted before
Store implementation, then create the first implementation planning slice for the accepted
schema/API foundation.
```
