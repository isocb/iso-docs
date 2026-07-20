# FUND Application Template And Artwork Template Refinement

Date: 2026-07-15

Status: Draft refinement for review; planning and documentation only

Source brief:

`docs/modules/fund/01-cr-inputs/2026-07-15-fund-template-manager-brief.md`

Related change requests by name:

- **FUND Project Product Selection Limits And Template Capacity Change Request** —
  `docs/modules/fund/01-cr-inputs/2026-07-15-fund-project-product-selection-limits-and-template-capacity-cr.md`
- **FUND Collective Project Artwork Composition, Approval And Workflow-Aware Product
  Instructions Remedial Clarification** —
  `docs/modules/fund/01-cr-inputs/2026-07-15-fund-collective-project-artwork-composition-approval-and-workflow-aware-product-instructions-remedial-clarification.md`

Authoritative roadmap:

`docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

Accepted reconciliation successor:

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-f-project-offer-artwork-readiness-reconciliation-planning.md`

The successor preserves this CR as governed source evidence, resolves its cross-CR
questions at parent level where safe and routes proof-dependent questions to bounded
`1R-F` children. The reconciliation moves the previously reserved public Store slice from
`1R-F` to `1R-G` so alphabetical identifiers continue to express delivery order. This
input still does not itself authorise implementation.

Related accepted foundations:

- `1Q-E` Project Product eligibility services;
- `1Q-F` Catalogue-centric Project Product selection;
- `1R-C3` Project Store, Store Product and immutable Store Product configuration versions;
- `1R-C4` production asset/version foundation;
- `1R-D` Store readiness and C1 Store configuration services;
- `1P-K2` C2 Client dashboard and Client-owned Project management; and
- the planned `1P-K6` Project template/resource access outcome.

This document refines the source brief before a separate roadmap and bounded slice-planning
exercise. It does not authorise application code, schema, migration, infrastructure,
deployment or implementation work.

This refinement applies specifically to the established `ARTWORK_FUNDRAISING` Individual
Artwork Project type. It does not define the collective Project artwork composition and
approval workflow for `GROUP_PERSONALISED_PRODUCTS` or applicable
`BULK_ORDER_CLUB_FUNDED` Projects, and it does not treat an unmodified Standard Product as
a fourth Project type. Those boundaries are controlled by the linked **FUND Collective
Project Artwork Composition, Approval And Workflow-Aware Product Instructions Remedial
Clarification**.

## 1. Strategic Decision

FUND should own the creation, finalisation, retention and delivery of the Project-specific
artwork sheet used in the AMOW workflow.

This is not a generic PDF-export feature. The downloaded document is a central workflow
artefact that:

- carries the child's artwork through the physical process;
- identifies the Project and C2 Client organisation;
- presents the exact Products and prices offered for the Project;
- records handwritten quantity and total information supplied by the parent;
- routes the parent to the correct Project Store through a printed URL and QR code; and
- provides a physical summary that C1 can cross-check against the paid online Order before
  approving the artwork for production.

The capability is therefore a coherent and essential part of FUND's A1 artwork workflow.
It must be lifecycle-aware, Store-aware and production-aware rather than implemented as a
standalone document utility.

The accepted technical direction is a controlled Application Template system with
Project-specific Artwork Template generation. A real AMOW template and deployed-renderer
proof must validate the final renderer choice before implementation is committed to a
large visual editor.

The linked **FUND Project Product Selection Limits And Template Capacity Change Request**
controls the minimum and maximum selected Project Product rules used by Project Product
selection, Artwork Template finalisation and Store publication. Both change requests must
use the same terms and be planned as one coherent offer-capacity contract.

## 2. Controlling Terminology

The word `template` has two legitimate business meanings in this workflow. These meanings
must not be collapsed or casually renamed.

### 2.1 Application Template

An **Application Template** is the reusable design definition created, configured,
versioned, activated and managed by C1.

It owns the controlled visual design, including:

- A4 orientation;
- optional background;
- C1 branding;
- protected artwork area;
- approved layout components;
- component positions and dimensions;
- typography, colours, borders and alignment;
- product-grid design and capacity rules; and
- approved variable placements.

C2 has no authority to edit the Application Template design, layout, styling, background,
component configuration or variable registry.

### 2.2 Artwork Template

An **Artwork Template** is the Project-specific, customised and finalised document that C2
downloads.

In system terms it is a completed generated artefact. In the physical AMOW workflow it
remains a template because:

- C2 prints or distributes copies;
- a child applies artwork to its protected artwork area;
- the parent records the ordered Product quantities and totals on it; and
- the completed physical Artwork Template is returned and matched to the online Order for
  production.

`Artwork Template` is therefore the required product and user-facing term for the generated
PDF. Terms such as `Artwork Sheet`, `Project Document` or `generated PDF` may be used as
technical descriptions in explanatory prose, but must not replace the established Artwork
Template business term in the domain or C2 experience.

### 2.3 Application Template Version

An **Application Template Version** is an exact immutable version of a C1 Application
Template definition. A finalised Artwork Template always records the exact Application
Template Version used.

### 2.4 Artwork Template Version

An **Artwork Template Version** is an immutable successful Project-specific generation.
Unlocking and changing the Project offer never rewrites a prior Artwork Template Version.
Refinalisation creates a later version.

### 2.5 Components And Variables

The Application Template editor manages **components**, not only variables.

Initial component types should include:

- printed title;
- controlled static rich-text instructions;
- approved resolved-data text;
- Project Store QR code;
- printed Project Store URL;
- Product/price/quantity/total grid;
- child-name label and writable area;
- five-digit handwritten Order Code area with one outlined box per digit; and
- protected artwork area.

The approved variable registry supplies safe data to resolved-data components. It does not
permit arbitrary database paths, expressions, HTML, CSS or scripting.

The printed title, rich-text instructions and Order Code writing area are versioned
Application Template components. They are not unrestricted page-builder content. The Order
Code boxes are deliberately empty when the Artwork Template is generated because the parent
writes the code after completing online checkout.

### 2.6 Project Product Selection Limits

This document uses the controlling language established by the linked **FUND Project
Product Selection Limits And Template Capacity Change Request**:

- **selected Project Product count** — the number of distinct active selected
  `FundProjectProduct` memberships in the intended Project offer;
- **minimum selected Project Products** — initially one, below which the Project offer
  cannot be finalised or published;
- **maximum selected Project Products** — the C1-configured maximum on the effective
  Application Template Version; and
- **validated Product-grid capacity** — the greatest Product-row count proven to fit the
  Application Template under its accepted print/layout envelope.

`maximum selected Project Products` must not exceed `validated Product-grid capacity`.
Avoid ambiguous phrases such as `Product maximum`, `template max` or `max Products` in
later planning and UI guidance.

These named minimum/maximum rules apply only to `ARTWORK_FUNDRAISING` Individual Artwork
Projects. Other Project types remain subject to Product suitability and ordinary
workflow-aware Store readiness, not Application Template Product-grid capacity.

## 3. Ownership And Responsibilities

### 3.1 C1

C1 is the FUND tenant administrator and owns:

- Product definitions and configured prices;
- Catalogues and Product eligibility;
- Application Template creation and versioning;
- maximum selected Project Products configuration within validated Product-grid capacity;
- Event-to-Application-Template assignment;
- the default Standalone Project Application Template;
- creation and assignment of special Standalone Project Application Template versions;
- Application Template preview, validation, activation and archive; and
- operational inspection of current and historic Artwork Template Versions.

### 3.2 C2

Within the Products made eligible by C1, the authorised C2 Project organiser/owner/admin
owns:

- review and adjustment of the default-all eligible Project Product selection within the
  effective minimum and maximum selected Project Products;
- review of the Project-specific resolved preview;
- creation/finalisation of the Project-specific Artwork Template;
- download of the current finalised Artwork Template; and
- printing copies or distributing the downloaded Artwork Template to parents.

C2 selection determines which configured Product prices appear because the selected
Project Products define the Project offer. C2 does not edit Product price, VAT, currency,
Application Template design or layout.

The exact mapping of the business phrase `C2 owner/admin` to the current
`FundClientMember` access levels and the exact `FundProject.organiserMemberId` must be
resolved in planning before permissions are implemented.

### 3.3 Email Recipient

FUND sends the Artwork Template availability email or secure link to the C2 Project
organiser. FUND does not initially send the Artwork Template directly to parent recipients.

The organiser may then:

- download and print the required number of copies; or
- download and distribute the Artwork Template to parents through the organiser's chosen
  communication channel.

## 4. Project Types And Application Template Assignment

FUND has two broad Application Template assignment paths.

### 4.1 Event-Linked Project

An Event-linked Project resolves its Application Template through its same-tenant Event.

```text
FundEvent
-> assigned C1 Application Template
-> active/eligible Application Template Version
-> Project-specific resolved variables and selected Products
-> finalised Artwork Template Version
```

The Event Application Template supplies the bulk of the Event-specific design and
customisation. Project-specific values augment that design without allowing C2 to alter
the design itself.

An Event-linked Project must not silently fall back to the Standalone Project default when
its Event Application Template is missing or invalid. Finalisation must fail with a clear
readiness reason.

### 4.2 Standalone Project

A Standalone Project resolves the tenant's active default Standalone Project Application
Template unless C1 has assigned an approved special Application Template or version to the
specific Project.

```text
exact C1 Project override, when present
else tenant default Standalone Project Application Template
else not ready for finalisation
```

C2 cannot select or create the special design. C1 creates and assigns it; C2 resolves the
Project-specific content and finalises the resulting Artwork Template.

### 4.3 Exact Version Pinning

Before finalisation, a Project may preview the currently effective Application Template
Version under the assignment rules. At finalisation, the exact Application Template
Version is pinned into the immutable Artwork Template Version.

A later Event assignment, Standalone default or Application Template activation must not
rewrite an existing Artwork Template Version.

The effective Application Template Version also supplies maximum selected Project Products
to the C2 Product-selection step. Finalisation pins that exact value so a later Application
Template Version cannot change the limit of a locked Project offer.

## 5. Project Eligibility

The Artwork Template workflow applies when the established Project type/fundraising format
is:

```text
ARTWORK_FUNDRAISING
```

Product suitability then filters which Products are eligible for that Individual Artwork
Project. Each selected `FundProjectProduct.workflowClassId` remains its operational Product
Workflow Class snapshot, but a Product-level `requiresTemplate` value must not by itself
route a Group personalised or Bulk order/club-funded Project into this Application
Template/Artwork Template workflow.

A Project has one mutually exclusive Project type. It may contain several selected
Products with different compatible operational Product Workflow Classes; that is not a
mixed Project type. Planning must ensure that every Product included in the Artwork
Template grid is suitable for `ARTWORK_FUNDRAISING` and compatible with the Individual
Artwork physical/production workflow.

`NOT_SURE` is not eligible for Artwork Template finalisation or Store publication until C1
resolves it to a concrete Project type and re-evaluates Product eligibility.

The first operational proof should use a genuine AMOW A1 Individual Artwork Project.

## 6. Authoritative Resolved Data

The Artwork Template is a snapshot of the resolved Project Store offer. It must not be
composed directly from live Catalogue rows or from an unrestricted query across current
Product data.

| Artwork Template value                        | Authoritative source                                                                       |
| --------------------------------------------- | ------------------------------------------------------------------------------------------ |
| C1 tenant identity/branding                   | same-tenant `Organization` and approved Application Template branding assets/configuration |
| School, club or fundraising organisation name | `FundClient.name`                                                                          |
| Project name                                  | `FundProject.name`                                                                         |
| Project number/reference                      | `FundProject.projectNumber`                                                                |
| Project opening/closing dates                 | `FundProject.opensAt` / `FundProject.closesAt`                                             |
| Event name/context                            | linked same-tenant `FundEvent`, when the component is present                              |
| Event closing date                            | linked `FundEvent.closesAt`, only when explicitly configured as a separate variable        |
| Store stable locator                          | `FundProjectStore.publicId`                                                                |
| QR and printed URL                            | canonical Store URL resolver output, snapshotted as the exact string used                  |
| selected Project Product identity             | active C2-selected `FundProjectProduct` membership                                         |
| printable Store Product row                   | resolved `FundProjectStoreProduct` included by the accepted print policy                   |
| display title and commercial evidence         | exact `FundStoreProductConfigurationVersion` snapshot used by the locked offer             |
| ordering                                      | locked Project/Store Product order, not live Catalogue ordering                            |
| currency and tax display                      | accepted resolved consumer-price service output                                            |

Catalogue membership explains why a Product is eligible. `FundProjectProduct` records the
C2-selected subset. The resolved Store Product configuration version supplies the exact
customer-facing Product and commercial evidence. One Product available through multiple
Catalogues still appears once.

`organisation name` must not remain an ambiguous variable label. The registry must
distinguish at least:

- `Client organisation name` for the school, club or fundraising body; and
- `C1 tenant name/branding` for the FUND operator/seller.

## 7. Pricing Contract

Pricing on the Artwork Template is determined by C2 Project Product selection in this
sense:

```text
C1 configures eligible Products and prices
-> C2 selects Project Products
-> Store configuration resolves exact Product/price versions
-> Artwork Template finalisation locks and prints those resolved prices
```

C2 does not manually enter or override the price printed on the Artwork Template.

The current `unitPriceNet`, VAT, tax-treatment and price-entry-basis evidence is not by
itself a complete consumer-price presentation contract. Before production Artwork Template
generation is complete, the accepted pricing service must define:

- net, tax and gross resolution;
- tax-inclusive customer display;
- seller rounding policy;
- currency formatting;
- price modifiers that are relevant to the printable Product row; and
- immutable resolved price evidence shared by Store ordering and Artwork Template
  generation.

The online Store and finalised Artwork Template must consume the same locked commercial
configuration. They must not independently recalculate prices from current Product rows.

## 8. Product, Quantity And Total Grid

The grid is essential to the physical/online cross-check workflow.

The initial required columns are:

```text
Product
Unit price
Quantity
Total
```

The `Quantity` and `Total` cells provide writable blank space. A parent may, for example,
record two mugs and three tea towels using the same artwork. When C1 receives the physical
Artwork Template, the handwritten summary is cross-checked with the paid online Order
before production approval.

The grid is not a substitute checkout system and handwritten values are not themselves
payment authority. The online paid Order remains the Commerce authority. The grid is
physical matching and checking evidence.

The printable row set must be derived from the finalised locked Project offer. It must not
include Products merely because they remain in a Catalogue.

The component must define:

- deterministic Product ordering;
- exact display-title source;
- consumer unit-price formatting;
- blank writable quantity and total dimensions;
- long-name wrapping rules;
- minimum font size and row height;
- validated Product-grid capacity;
- maximum selected Project Products within that validated capacity;
- compact and standard approved styles;
- behaviour for Products with options or price modifiers; and
- a hard failure when the selected offer cannot fit legibly on one A4 page.

Validated Product-grid capacity will be established iteratively against real AMOW Projects
and print tests. C1 then configures maximum selected Project Products at or below that
capacity. FUND must not silently add pages or reduce content below an accepted legibility
threshold.

The initial minimum selected Project Products is one. A newly initialised C2 Product
selection preselects all distinct eligible Products. When that default exceeds maximum
selected Project Products, the UI must show every selection and require C2 to deselect
enough Products before finalisation; it must not silently choose a subset.

## 9. Application Template Definition

The recommended conceptual model separates stable identity from immutable versions.

### 9.1 Application Template Identity

The stable Application Template identity should support:

- tenant ownership;
- name and description;
- active/archived identity state;
- current draft and/or active-version pointers where accepted;
- created/updated actor and timestamp evidence; and
- Event, Standalone default and explicit Project-override assignments.

### 9.2 Application Template Version

An Application Template Version should contain:

- positive version number;
- `PORTRAIT` or `LANDSCAPE` orientation;
- A4 page contract;
- versioned structured layout configuration;
- optional background `MediaFile` reference and fit policy;
- immutable branding asset references/configuration;
- component configuration;
- printed-title and controlled rich-text instruction content/configuration;
- five-digit Order Code writing-area configuration;
- protected artwork area configuration;
- Product-grid configuration and capacity envelope;
- validated Product-grid capacity;
- C1-configured maximum selected Project Products;
- minimum selected Project Products policy/version used for validation;
- safe-print-area policy/version;
- approved font-pack/version;
- draft/active/retired state;
- validation result/version;
- activation actor and timestamp; and
- audit evidence.

Editing an active Application Template Version creates a new draft version. It never
rewrites the version used by an existing Artwork Template Version.

### 9.3 Structured Layout

The layout should store physical measurements in millimetres and use a versioned,
discriminated component schema. Each component should have:

- stable component ID;
- supported component type;
- x/y position;
- width/height where applicable;
- controlled layer or stacking rule;
- visibility;
- type-specific approved configuration; and
- validation metadata only where it is durable contract data.

Arbitrary HTML, CSS, scripts, executable expressions, database paths and unrestricted
layering remain prohibited.

Rich-text content should be stored in a versioned structured editor format and rendered
through a sanitised allowlist. The stored contract must not rely on unsanitised arbitrary
HTML from the browser.

## 10. Background, Branding And Protected Artwork Area

The background image is optional. An Application Template without a background may be
activated only when its controlled components still instantiate the required C1 branding.

Background upload must:

- use IsoStack-managed storage and typed tenant-scoped association;
- accept PNG initially;
- inspect actual content/type rather than trust the browser MIME claim;
- validate dimensions and aspect ratio for the selected orientation;
- report effective print resolution;
- show fit/crop/fail behaviour; and
- preserve the exact background asset used by an activated version.

Recommended 300 dpi reference dimensions remain approximately:

- portrait: 2480 x 3508 pixels;
- landscape: 3508 x 2480 pixels.

The **protected artwork area** is a first-class Application Template component independent
of the background. It should render an enforced white area above the background and prevent
other ordinary components from overlapping it. Its name should describe the physical
artwork workspace rather than only an exclusion rule.

The document must use a centrally defined safe-print inset consistent with the accepted
office/production-print standard. The exact initial numeric inset is confirmed during the
real-template print QA and then versioned as part of the rendering/layout contract.

## 11. Application Template Content And Approved Variable Registry

### 11.1 Printed Title

Each Application Template Version should support one printed-title component distinct from
the internal C1 Application Template name.

The printed title should support:

- C1-authored plain text;
- position and size in millimetres;
- approved font family, size, weight, colour, alignment and line-height controls;
- one or more lines within a validated bound;
- representative preview; and
- nonblank and fit validation when the title is required by the Application Template
  policy.

Changing the printed title creates/updates only a draft Application Template Version. It
never changes an active version or an existing Artwork Template Version.

### 11.2 Controlled Rich-Text Instructions

Each Application Template Version should support one or more controlled static rich-text
instruction components authored by C1 through a rich-text editor.

The initial editor should support a safe print-oriented subset such as:

- paragraphs and intentional line breaks;
- bold, italic and underline emphasis;
- approved text sizes/styles;
- ordered and unordered lists where they fit the design;
- text alignment; and
- insertion of approved variable tokens where the registry explicitly permits them.

It should not expose arbitrary HTML, CSS, script, embedded frames, remote media, executable
expressions or unrestricted links. Approved variable tokens must be selected from the
registry and remain visibly distinct/read-only inside the editor.

Implementation planning should assess reuse of IsoStack's existing Mantine/Tiptap rich-text
stack and sanitisation patterns rather than introduce a second general-purpose editor. The
stored/print contract remains the bounded Application Template schema, not whatever HTML a
browser editor happens to emit.

Illustrative C1-authored wording may include:

> Please complete the order details. You can select any single or multiple products.
> **ORDER ONLINE** — Scan the QR code or visit the printed Store URL. Select and pay for
> your products. Our team work from this paper order form, so you must also complete the
> order information on this page. Once your online order is complete, it will generate an
> ORDER CODE, which will also be on your emailed order confirmation. Copy it onto this
> sheet and return this form to school to complete your order.

This wording is an example, not hard-coded system copy. C1 may create different wording for
different Event or Standalone Application Template Versions.

The rich-text component requires:

- a bounded physical rectangle;
- overflow and clipping prevention;
- maximum content/structure limits appropriate to the renderer;
- sanitisation at the service boundary and again where rendered where appropriate;
- preview using exact print typography and approved variable sample values; and
- activation failure when content cannot fit legibly within the configured component.

### 11.3 Five-Digit Order Code Writing Area

The initial component registry should include a singleton **Order Code writing area** that
renders a C1-configurable label and exactly five individual outlined boxes:

```text
ORDER CODE: [ ] [ ] [ ] [ ] [ ]
```

This is a physical write-in component, not a resolved Project variable and not an
interactive PDF form field. The parent receives the Order Code after online checkout and
copies one digit into each box on the printed Artwork Template.

C1 should be able to configure, within safe limits:

- label text;
- component position and total size in millimetres;
- label placement and typography;
- individual box width and height;
- spacing between boxes;
- outline colour, thickness and approved line style;
- background/fill, normally white; and
- alignment of the five-box group.

The first release fixes the box count at five so the physical component matches the
accepted five-digit Order Code contract. It must not silently render fewer/more boxes or
prefill a code at Artwork Template generation time.

Activation and finalisation validation must confirm that:

- all five boxes are present and equal in size;
- each box is large enough for legible handwriting;
- outlines remain print-visible;
- the group remains within the safe-print area;
- it does not overlap the Product grid, QR/URL, child-name area or protected artwork area;
  and
- the instructional wording and Order Code writing area can be understood together in the
  final preview.

The generated Order Code remains Commerce/Order evidence and is not an authentication
secret. Its generation, uniqueness and emailed Order-confirmation contract are dependencies
to resolve before the wording is operationally relied upon.

### 11.4 Approved Variable Registry

Each approved variable requires:

- stable code;
- user-facing label;
- component/value type;
- authoritative resolver;
- permission and tenant boundary;
- formatting rule;
- null behaviour;
- sample value;
- singleton/repeatable rule; and
- invalidation/fingerprint participation rule.

Initial candidates are:

- Client organisation name;
- Project name;
- Project number/reference;
- Project opening date;
- Project closing date;
- Event name;
- Event closing date;
- canonical Store URL;
- Store QR code;
- C1 tenant name/branding;
- child-name label/writable area;
- Product/price/quantity/total grid.

The printed title, static instructional rich text and blank Order Code writing area are
controlled component values, not ordinary resolved variables. Approved variable tokens may
be inserted into rich text only through the registry-aware editor control.

## 12. C1 Application Template Experience

C1 should be able to:

- list Application Templates through the IsoStack Table CRUD Pattern;
- create a draft;
- assign a clear name and description;
- select portrait or landscape;
- upload, replace or remove an optional background;
- instantiate required C1 branding;
- add and configure approved components;
- configure the printed title independently from the internal Application Template name;
- author and format bounded instructional wording through the controlled rich-text editor;
- insert only approved variable tokens into rich text;
- add and configure the singleton five-digit Order Code writing area;
- position/size components through drag interaction and numeric millimetre inputs;
- configure the Product grid within safe limits;
- see validated Product-grid capacity and configure maximum selected Project Products at
  or below it;
- see deduplicated eligible Product counts for assigned Events/Projects and warnings where
  those counts exceed maximum selected Project Products;
- configure the protected artwork area;
- preview representative short, long and maximum sample data;
- preview an eligible real Project where authorised;
- generate a test PDF;
- see activation failures before activation;
- activate an immutable version;
- assign an Application Template to an Event;
- maintain the default Standalone Project Application Template;
- create/assign a special C1 Project override for a Standalone Project;
- archive an Application Template without breaking history; and
- inspect which Application Template Version produced an Artwork Template Version.

The visual editor should be a dedicated child page. The physical A4 design remains fixed;
the administration shell may be responsive without pretending the page itself is
responsive.

## 13. C2 Artwork Template Experience

The authorised C2 Project surface should present one integrated Project-offer workflow:

```text
select eligible Project Products
-> preselect all distinct eligible Products
-> show selected Project Product count, minimum and maximum selected Project Products
-> require C2 to resolve any under-minimum or over-maximum state
-> review resolved Product/pricing grid
-> preview Project-specific Artwork Template
-> resolve readiness failures
-> finalise Artwork Template
-> Project offer becomes locked
-> generation runs
-> download and organiser email become available
```

C2 may review resolved content but receives no layout, background, typography, component or
Application Template selection controls.

C2 can preview the C1-authored title, resolved/sanitised instructions and empty five-box
Order Code writing area, but cannot edit their text, format, geometry or box count.

The Project panel should show:

- effective Application Template name/version where appropriate;
- preview;
- readiness state and actionable failures;
- selected Project Product count and the effective minimum/maximum selected Project
  Products;
- finalisation/lock state;
- Artwork Template generation state;
- current Artwork Template Version;
- generated date;
- outdated or unlocked warning;
- Download Artwork Template;
- email/send-link status for the C2 Project organiser;
- explicit Unlock and revise action when authorised; and
- historical-version information only to the extent appropriate for C2.

## 14. Finalisation And Project Offer Lock

Finalisation is a first-class business transition, not merely a Generate PDF button.

### 14.1 Finalisation Preconditions

Before finalisation, FUND must prove at least:

- Project and C2 authority are valid;
- an applicable active Application Template Version resolves;
- required branding/background rules pass;
- selected Project Product count is at least minimum selected Project Products;
- selected Project Product count is no greater than maximum selected Project Products;
- every selected Project Product is otherwise eligible and valid;
- exact Store Products and configuration versions resolve;
- all printed consumer prices resolve under the accepted pricing contract;
- the Store has a stable canonical URL even if unpublished;
- the QR payload is valid;
- required Project and Client variables resolve;
- required printed title and rich-text instructions are nonblank, sanitised and fit their
  configured bounds;
- the five-digit Order Code writing area is present where required and passes physical
  component validation;
- the Product grid fits;
- all components remain within the A4 safe area;
- protected components do not overlap the artwork area; and
- the render is exactly one A4 page in the configured orientation.

### 14.2 Atomic Lock Snapshot

Finalisation should atomically record and lock:

- exact Application Template Version;
- exact ordered Project Product membership set;
- selected Project Product count;
- minimum selected Project Products policy/version;
- maximum selected Project Products;
- exact Store Product identities;
- exact Store Product Configuration Version identities;
- exact resolved consumer prices and formatting evidence;
- exact canonical Store URL and QR value;
- exact resolved variable payload;
- exact printed title, rich-text editor document/render contract and Order Code writing-area
  configuration through the pinned Application Template Version;
- exact Project/Event/Client values printed;
- composition schema, renderer and font-pack versions; and
- canonical payload fingerprint.

Locking only Product membership is insufficient. If Store Product copy, price, tax or
configuration could change independently after finalisation, the printed Artwork Template
would no longer reliably cross-check the online Order.

### 14.3 Effects Of The Lock

While locked:

- C2 cannot add, remove, reactivate, deactivate or reorder Project Products;
- the pinned minimum and maximum selected Project Products do not change;
- the Store cannot silently move the locked offer to different commercial configuration
  versions;
- Product/price/configuration changes detected upstream do not mutate the Artwork Template;
- any attempted change must be rejected with a clear lock explanation or enter the explicit
  unlock/revision workflow;
- idempotent regeneration from identical locked inputs may reproduce the current Artwork
  Template Version without creating a conflicting current version; and
- Store publication remains a separate transition.

The Store may be unpublished when the Artwork Template is finalised. Finalisation proves a
stable destination and locks the offer; it does not publish the Store or permit checkout.

### 14.4 Unlock And Revision

Unlocking must be a conscious, strongly warned and audited action.

The warning must explain that:

- printed or distributed Artwork Templates may already exist;
- changing Products or prices can cause mismatch with those copies;
- the existing Artwork Template Version remains historical and immutable;
- the current download becomes unlocked/outdated as appropriate; and
- a new finalisation and Artwork Template Version will be required before the revised offer
  is operationally current.

Unlock should:

- record actor, timestamp and required reason;
- preserve the prior lock snapshot and generated PDF;
- enable authorised Project Product variation;
- permit the effective Application Template or resolved inputs to be revised under policy;
- prevent the prior version from being represented as the current locked offer; and
- require readiness, finalisation, locking and generation again.

Unlock behaviour after the Store has accepted Orders requires an explicit stricter business
rule before implementation.

## 15. Artwork Template And Generation Model

The conceptual persistence boundary should separate:

### 15.1 Project Artwork Template Aggregate

- tenant and Project ownership;
- current finalised/locked state;
- current Artwork Template Version pointer;
- current lock snapshot/fingerprint pointer;
- outdated/unlocked reason evidence; and
- audit timestamps/actors.

### 15.2 Immutable Artwork Template Version

- positive Project-scoped version;
- exact Application Template and version;
- exact input/lock snapshot or immutable snapshot reference;
- generated managed-object/`MediaFile` reference;
- PDF checksum, size, MIME and page evidence;
- orientation;
- generated timestamp and actor/system evidence;
- renderer/composition/font versions;
- canonical Store URL/QR value used; and
- supersession relationship where useful.

### 15.3 Generation Attempt/Job

- tenant, Project and requested lock snapshot;
- `QUEUED`, `RUNNING`, `SUCCEEDED` or `FAILED` generation state;
- idempotency key;
- attempt/retry count;
- lock/claim evidence;
- requested/requesting actor;
- queued/started/completed timestamps;
- safe diagnostic code/message; and
- successful Artwork Template Version reference.

A failed attempt does not create a failed pseudo-version. Only successful validated output
creates an immutable Artwork Template Version.

Generation status and document lifecycle must not be collapsed into one enum.

## 16. Invalidation And Fingerprinting

The finalisation payload should be canonicalised and hashed. Outdated detection compares
the effective resolved payload rather than treating every related database edit as a direct
invalidation.

Potential source changes should trigger reconciliation of the effective fingerprint,
including:

- Application Template assignment/version;
- layout/background/branding/font configuration;
- Project or Client values used by present components;
- Event values used by present components;
- canonical Store URL;
- selected Project Product membership/order;
- effective maximum selected Project Products before finalisation;
- locked Store Product display/commercial configuration versions; and
- accepted resolved pricing rules/version.

Examples:

- a Product name change does not invalidate a locked Artwork Template when the locked Store
  Product display snapshot remains unchanged;
- a Catalogue ordering change does not invalidate it when locked Project/Store Product
  ordering is authoritative;
- an Event date change matters only if that Event value participates in the resolved
  payload; and
- activation of a new Application Template Version does not rewrite an existing pinned
  Artwork Template Version.

When a locked upstream contract genuinely needs to change, FUND should require the explicit
unlock/revision flow rather than silently regenerate.

## 17. Store URL And Unpublished Store Behaviour

`FundProjectStore.publicId` is the stable locator. The full canonical URL should be resolved
through a controlled Store URL/domain service and snapshotted into the finalised Artwork
Template Version.

The durable identity should not be a user-entered URL and should not depend on a raw object
storage URL.

An Artwork Template may be finalised before Store publication when:

- the Store exists;
- its stable public locator exists;
- the canonical public route/domain contract exists; and
- the locked Project offer passes Artwork Template readiness.

Before publication or opening, the canonical Store destination must return a safe,
intentional unavailable/coming-soon experience rather than a broken route. Store
publication, trading dates, checkout readiness and payment readiness remain separate gates.

## 18. Rendering Tool Decision And Required Proof

The preferred long-term direction remains controlled HTML/React composition rendered to
PDF through Playwright/headless Chromium.

Reasons:

- physical A4 and millimetre CSS support;
- accurate portrait/landscape handling;
- strong variable-grid and typography support;
- shared composition concepts between preview and final output;
- bundled-font control;
- print-background support; and
- practical visual-regression testing.

`pdf-lib` should support PDF inspection, page-size/page-count validation, stamping or later
merging. It should not be the primary coordinate renderer for the variable grid/editor.

The final tool decision remains gated by a pre-implementation proof using one genuine AMOW
Application Template and representative Project data. The proof must exercise:

- portrait and/or landscape required by the real template;
- optional background and explicit branding;
- short and long Client/Project/Product values;
- a distinct printed title;
- the representative multi-paragraph rich-text instructions, including emphasis and line
  breaks;
- five individually outlined empty Order Code boxes;
- minimum-size, at-maximum and deliberate overflow Product grids;
- writable quantity/total cells;
- protected artwork area;
- Store URL and QR scanning from printed output;
- browser preview versus generated PDF;
- exact one-page A4 validation;
- bundled font and colour output;
- deployed Render browser installation;
- worker memory, generation time and retry behaviour;
- managed storage write/read; and
- comparison with CraftMyPDF operational effort and fidelity as a fallback.

The renderer should compose from already-resolved controlled data. It should not navigate
an authenticated live application page or load user-controlled remote resources. Static
text must be escaped/sanitised, fonts bundled and asset origins restricted.

## 19. Background Job Direction

Production Artwork Template generation must be asynchronous and idempotent.

The existing five-minute shared Render cron demonstrates useful PostgreSQL claim, locking,
retry and stale-lock patterns, but it is not an adequate interactive queue for C2
finalisation or C1 test generation.

Recommended first direction:

- database-backed Artwork Template generation jobs;
- a dedicated Render background worker;
- PostgreSQL row claiming with `FOR UPDATE SKIP LOCKED` or the accepted equivalent;
- bounded retries/backoff and stale-claim recovery;
- tenant/Project concurrency protection;
- pinned Playwright/Chromium runtime;
- explicit R2/private-object environment configuration;
- graceful shutdown; and
- operational logs plus safe failure codes surfaced to C1/C2.

Render Workflows may be appraised separately, but the first FUND implementation should not
depend on a beta orchestration product without an explicit platform decision.

## 20. Managed Storage And Secure Delivery

Artwork Template PDFs should use IsoStack-managed object storage, but the current public
`MediaFile.fileUrl` pattern does not by itself meet secure delivery requirements.

The refined direction requires:

- private or access-controlled generated PDF objects;
- durable storage identity separate from a public URL;
- authenticated C1/C2 download routes or short-lived signed GET delivery;
- no raw public R2 URL in the dashboard or email;
- immutable checksum/file evidence;
- tenant and Project access checks;
- retention and deletion policy; and
- audit of generation and relevant access/delivery actions.

The system-generated Artwork Template should not be forced into
`FundProductionAsset` without a separate accepted redesign. That model currently carries
artwork review, malware, uploader and production-purpose semantics that do not naturally
describe this generated business document. The generated document should have its own FUND
aggregate while reusing the managed binary/`MediaFile` substrate where safe.

## 21. Secure Organiser Link And Email

The initial email flow should:

1. complete and validate the finalised Artwork Template Version;
2. create a secure grant for that exact immutable version;
3. email the C2 Project organiser through the approved FUND/IsoStack communications path;
4. allow the organiser to download the file; and
5. retain delivery/audit evidence without exposing raw storage location.

The secure grant should be:

- non-guessable;
- stored hashed at rest;
- tenant, Project and exact Artwork Template Version scoped;
- expiring;
- revocable;
- auditable; and
- replaceable without changing the underlying Artwork Template Version.

The secure link must not mean `latest version`, because that could silently change the file
received after a revision. Authenticated C2 dashboard access may separately expose the
current authorised version.

## 22. Validation And Print QA

Automated validation should cover:

- tenant and role isolation;
- Event and Standalone assignment rules;
- immutable Application Template Versions;
- variable resolution/null behaviour;
- exact C2 Project Product selection;
- all distinct eligible Products selected by default for a newly initialised selection;
- minimum selected Project Products enforcement;
- maximum selected Project Products configuration and enforcement;
- maximum selected Project Products not exceeding validated Product-grid capacity;
- under-minimum, at-maximum and over-maximum UI/service behaviour;
- exact locked Store Product configuration versions;
- consumer pricing and formatting;
- quantity/total writing areas;
- printed-title distinction from internal Application Template name;
- rich-text allowlist, sanitisation, variable-token resolution and overflow refusal;
- exact five-box Order Code rendering and physical-dimension validation;
- Order Code area non-overlap with QR, Product grid, child-name and protected artwork
  components;
- finalisation atomicity;
- Product selection mutation refusal while locked;
- explicit unlock/revision/refinalisation;
- generation idempotency and retry;
- A4 size/orientation and one-page output;
- secure-link expiry/revocation/version pinning;
- historical C1 access; and
- C2 denial from Application Template design controls.

Representative print/visual fixtures should cover:

- portrait and landscape;
- background and no-background branded designs;
- long school/club and Project names;
- short, long, at-maximum and deliberate over-maximum Product selections;
- Product names wrapping to multiple lines;
- writable child name, quantity and total spaces;
- short and long instructional rich text with intentional line breaks and emphasis;
- five equal, legible and individually outlined Order Code boxes;
- protected artwork area;
- printed title and controlled rich-text instructions;
- singleton five-digit Order Code writing area;
- office-printer safe area and actual-size printing;
- QR scanning from multiple physical printers/devices; and
- visual comparison of browser preview with generated PDF.

## 23. Roadmap And Sequencing Position

The source brief's `T1` through `T5` labels are useful workstream headings but are not final
FUND slice identifiers.

The current roadmap already reserves:

- `1R-E` for C1 Store Management UI;
- `1R-G` for public/C2 Store display; and
- `1P-K6` for the narrower Project template/resource access outcome.

This capability is larger than `1P-K6` and must not consume or rename `1R-E`. The future
roadmap refinement should create a dedicated parent capability/lane and reconcile its C2
delivery outcome with the earlier `1P-K6` placeholder without renaming unrelated slices.

Candidate planning workstreams, not implementation authorisation, are:

1. Real-template, pricing and deployed-renderer proof.
2. Application Template/version/assignment, Project Product selection-limit and Artwork
   Template lock/document schema proposal.
3. Application Template services, lifecycle and C1 basic management.
4. Controlled component registry and C1 visual editor.
5. Default-all C2 Project Product selection, shared minimum/maximum enforcement, preview,
   finalisation and offer locking.
6. Artwork Template generation jobs, worker, renderer and managed storage.
7. C2 download, secure organiser email and C1 operational history.
8. Invalidation/revision, visual regression, print QA and release documentation.

Schema and C1 Application Template planning may proceed before the public Store is complete.
Production finalisation cannot be declared complete until consumer pricing, stable canonical
Store routing, locked Store configuration and secure generated-object delivery are complete.

The linked **FUND Project Product Selection Limits And Template Capacity Change Request** is
a named dependency. Its shared server-side selection-limit contract must be established
before Artwork Template finalisation and Store publication are declared complete.

The linked **FUND Collective Project Artwork Composition, Approval And Workflow-Aware
Product Instructions Remedial Clarification** is also a named boundary dependency. It
preserves the established Project type/Product suitability/Product Workflow Class
nomenclature, confines this capability to Individual Artwork Projects and separately
controls Group/Bulk collective artwork approval and Standard Product readiness.

The global roadmap remains authoritative for selecting the next executable slice. This
refinement does not supersede the currently controlled Commerce/FUND sequence.

## 24. Refined MVP Boundary

The first operational release should include:

- C1-managed Application Templates;
- immutable Application Template Versions;
- Event assignment;
- tenant default Standalone Project assignment;
- C1 special Standalone Project override;
- portrait and landscape;
- optional PNG background with mandatory instantiated C1 branding;
- controlled components and approved variables;
- C1-authored printed title distinct from the internal Application Template name;
- bounded, sanitised rich-text instructions with approved formatting and optional approved
  variable tokens;
- singleton five-digit Order Code writing area with separate outlined boxes;
- protected artwork area;
- Product/unit-price/quantity/total grid;
- validated Product-grid capacity and C1-configured maximum selected Project Products;
- initial minimum selected Project Products of one;
- default-all C2 Project Product selection from eligible C1 Products;
- shared C1/C2 under-minimum and over-maximum prevention;
- Project-specific preview;
- C2 finalisation and atomic Project-offer lock;
- unpublished-Store support with stable canonical destination;
- immutable Artwork Template Versions;
- Playwright/Chromium generation subject to the accepted proof;
- private managed storage;
- authenticated C2 download;
- secure organiser email/link;
- explicit warned unlock/revision/refinalisation;
- C1 current/historic operational visibility; and
- representative automated, visual and physical print QA.

Defer unless a real AMOW proof requires otherwise:

- arbitrary HTML/CSS/script;
- arbitrary database expressions;
- non-A4 sizes;
- multi-page Artwork Templates;
- unrestricted layering;
- rich desktop-publishing features;
- decorative QR codes;
- C2 layout or design controls;
- direct FUND email distribution to parent lists;
- interactive PDF annotations/form fields; the printed Order Code boxes remain ordinary
  Artwork Template graphics intended for handwriting;
- automatic background design generation; and
- general-purpose document generation outside the FUND Artwork Template workflow.

## 25. Refined Acceptance Principles

The capability is successful when:

- C1 can create, brand, validate, version and assign an Application Template without
  technical knowledge;
- Event-linked and Standalone Projects resolve the correct Application Template under an
  explicit rule;
- C2 can select eligible Project Products but cannot alter C1 Product definitions, price
  configuration or Application Template design;
- all eligible Products default to selected for a newly initialised C2 selection;
- selected Project Product count must remain between minimum and maximum selected Project
  Products before finalisation/publication;
- C1 cannot configure maximum selected Project Products above validated Product-grid
  capacity;
- the resolved preview shows the exact Product and consumer-price offer;
- Product, Quantity and Total columns provide a dependable physical/online checking tool;
- C1 can create a distinct printed title and flexible, sanitised, bounded rich-text
  instructions for each Application Template Version;
- every applicable Artwork Template renders five separate outlined Order Code boxes that a
  parent can complete legibly after checkout;
- finalisation locks Product membership and exact Store commercial configuration together;
- the Store may remain unpublished without producing a broken QR destination;
- changing the locked offer requires a conscious, warned and audited unlock;
- prior Artwork Template Versions never change retrospectively;
- every generated version is traceable to its Application Template, locked offer, resolved
  inputs and renderer contract;
- C2 can download the correct finalised Artwork Template and receives the organiser email;
- C1 can diagnose failures and inspect history;
- secure delivery exposes no raw public storage URL;
- the protected artwork area survives background/design errors; and
- physical print/QR tests demonstrate a reliable path from returned artwork to the correct
  paid online Order and Project Store.

## 26. Resolved Business Decisions

This refinement records the following decisions as accepted inputs for later planning:

1. C1 creates and manages Application Templates.
2. C2 has no design or layout input.
3. The generated C2 download is called the Artwork Template.
4. C2 selects Project Products from C1-controlled eligible Products.
5. C2 Product selection determines which configured Products/prices appear; C2 does not
   edit price configuration.
6. Quantity and Total writing boxes are essential to the artwork/online-Order cross-check.
7. Event-linked Projects use Event-assigned Application Templates.
8. Standalone Projects use a tenant default with an optional special C1 Project override.
9. An Artwork Template may be finalised while the Store is unpublished.
10. Finalisation locks Project Product variation and the corresponding commercial offer.
11. Unlock is conscious, warned and audited, and revision creates a new immutable Artwork
    Template Version.
12. The initial FUND email recipient is the C2 Project organiser.
13. Backgrounds are optional when the Application Template otherwise instantiates required
    C1 branding.
14. Safe-print margins follow one centrally controlled print standard.
15. Validated Product-grid capacity is established iteratively through real-template and
    physical print testing.
16. Initial minimum selected Project Products is one.
17. Maximum selected Project Products is configured by C1 on the immutable effective
    Application Template Version and cannot exceed validated Product-grid capacity.
18. All distinct eligible Products default to selected when C2 Product selection is first
    initialised.
19. An over-maximum default remains visible and blocks finalisation/publication until C2
    deselects enough Products; FUND does not silently select a subset.
20. C1 and C2 Product-selection paths share the same server-side minimum/maximum contract.
21. Existing Projects are audited and gated without automatic Product selection,
    deselection or reordering.
22. The printed title is C1-authored versioned content distinct from the internal
    Application Template name.
23. C1 authors Event/Standalone instructions through a constrained, sanitised rich-text
    editor with optional approved variable-token insertion.
24. The Artwork Template includes a configurable physical Order Code writing-area component
    with exactly five individually outlined empty boxes in the initial release.
25. The Application Template, Artwork Template and template-capacity Product-selection
    rules in this refinement apply only to `ARTWORK_FUNDRAISING` Individual Artwork
    Projects.
26. Group personalised and applicable Bulk order/club-funded Projects use the separate
    collective Project artwork composition/approval contract; an unmodified Standard
    Product is not a Project type.

## 27. Open Business And Planning Questions

The following questions must be answered or explicitly deferred in the later planning
documents. They are intentionally placed at the end so resolved decisions are not reopened
accidentally.

### 27.1 Exact C2 Authority

How does the business phrase `C2 owner/admin` map to current FUND identities?

Options to assess include:

- exact `FundProject.organiserMemberId` only;
- organiser plus `FundClientMember.accessLevel = ADMIN`;
- organiser, `ADMIN` and `PROJECT_MANAGER`; or
- a future explicit Project permission.

The same decision must separately cover Product selection, preview, finalisation, download,
email-link issue/reissue and unlock.

### 27.2 Unlock After Orders Or Distribution

What happens when an unlock is requested after:

- the Artwork Template has been downloaded;
- the organiser has confirmed physical printing/distribution;
- the Store has been published;
- an unpaid basket/checkout exists; or
- one or more paid Orders exist?

The likely safe direction is a progressively stricter gate, with paid Orders prohibiting
ordinary unlock and requiring a C1-controlled exception/reconciliation process. This needs
an explicit business decision.

### 27.3 Lock Scope In Store And Checkout

Should finalisation pin the Project Store itself to the exact locked Store Product
Configuration Versions until unlock, or should Store readiness maintain a separate lock
record checked by every refresh/publication/checkout action?

The outcome must guarantee that the online Order and printed Artwork Template use the same
Product and price contract.

### 27.4 Event Assignment Version Behaviour

Before a Project is finalised, does an Event assignment follow the Event Application
Template's latest active version automatically, or must the Event assignment point to an
exact version?

After finalisation the Project is always pinned to the exact recorded version.

### 27.5 Event-Linked Project Override

May C1 assign an exceptional Project-specific Application Template to an Event-linked
Project, or are Project overrides permitted only for Standalone Projects in the initial
release?

### 27.6 Compatible Product Workflow Classes Inside Individual Artwork

A Project has one Project type, so this is not a question about mixing Individual, Group
and Bulk Project types. Planning must instead confirm which operational Product Workflow
Classes are compatible with `ARTWORK_FUNDRAISING`, and whether every suitable selected
Product consumes one row in the Individual Artwork Template grid.

Products whose operational workflow is incompatible with Individual Artwork must be
excluded through Product suitability/workflow validation rather than included and handled
through a second Project workflow.

### 27.7 Product Options And Price Modifiers

When an online Product has purchaser-selected options or price modifiers, does the Artwork
Template:

- print only the base Product and base unit price;
- print approved option rows;
- print a price range; or
- use another summary convention?

This must remain reconcilable with handwritten quantities and the exact paid Order.

### 27.8 Quantity And Total Grid Detail

Confirm whether the initial grid requires:

- one handwritten total per Product row;
- a final handwritten grand-total box;
- currency symbol repeated per row or only in the header;
- Product code in addition to Product name; and
- a parent/order reference writing field separate from the child's name.

### 27.9 Finalisation And Email Trigger

Should organiser email be sent automatically when generation succeeds, or only through an
explicit C2 `Email Artwork Template` action after previewing the final PDF?

Define resend behaviour, recipient snapshot, delivery evidence and failure handling.

### 27.10 Secure-Link Policy

Confirm:

- initial expiry duration;
- whether opening is unlimited before expiry;
- who may revoke/reissue;
- whether organiser identity must be rechecked; and
- how an organiser obtains the file after link expiry.

### 27.11 Minimum Branding Contract

When no background is used, what exact elements satisfy `C1 branding is instantiated`?

Candidates include required C1 logo, operator name, brand colours, footer identity and
contact/return instructions. The minimum must be machine-validatable at activation.

### 27.12 Safe-Print Inset

Confirm the exact numeric safe-print inset and whether the same inset applies to background,
ordinary components, QR quiet zone and the protected artwork area. Record the accepted
value/version after real printer QA rather than leaving it as informal UI guidance.

### 27.13 Validated Product-Grid Capacity

Confirm initial standard and compact validated Product-grid capacities after the real AMOW
proof. Maximum selected Project Products remains a separate C1 configuration at or below
that validated capacity, as controlled by the linked **FUND Project Product Selection Limits
And Template Capacity Change Request**.

### 27.14 Unpublished Store Destination

What exact public experience should the QR destination show before publication and before
the Project opens: coming soon, not yet available, Project dates, organiser guidance, or
another controlled message?

### 27.15 Retention And Historic Access

Define retention for:

- historic Application Template Versions;
- historic Artwork Template Versions;
- failed generation diagnostics;
- secure share grants; and
- download/email audit evidence.

### 27.16 Physical Distribution Evidence

Does C2 need a later optional action to record that an Artwork Template Version has been
printed/distributed and approximately how many copies were produced? Such evidence may be
important when deciding whether unlock is still safe, but it need not be part of the first
generation implementation unless the business requires it.

### 27.17 Order Code Authority And Matching Scope

Confirm the authoritative five-digit Order Code contract before Store/Order implementation:

- numeric-only format and whether leading zeroes are permitted;
- whether uniqueness is global, tenant-scoped, Project-scoped or dependent on the printed
  Project number;
- whether the code is issued at checkout creation, successful payment or another Order
  transition;
- whether one Order containing several children's artworks has one Order Code or a separate
  code per artwork/Order line;
- how the code appears in the emailed Order confirmation; and
- which C1 production screen validates the handwritten code against the paid online Order.

The Application Template component assumes exactly five handwritten digit boxes but must
not invent the code-generation or matching authority.
