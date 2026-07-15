Library
/
AMOW
/
template_roadmap.md


# FUND Project Template and PDF Generation Roadmap

## Purpose

This brief adds project-specific A4 template and PDF generation to the FUND roadmap.

The capability will replace the relevant parts of the current AMOW workflow that rely on a form tool, Zapier, WordPress and CraftMyPDF. FUND already owns, or is planned to own, Project creation, Project Catalogues, Products, Store creation, production control and dispatch. It should therefore also create and retain the printable Project template used by the C2 organiser.

This document is an implementation-planning brief. Before implementation, review the current FUND roadmap, schema, asset handling, Catalogue/Product model, Event and Project lifecycle, C1/C2 permissions, Store planning and background-job facilities. Reuse established IsoStack patterns and record any material conflicts or missing dependencies.

## Business outcome

For each eligible Project, FUND must generate a customised, print-ready PDF which:

- uses a C1-approved A4 template;
- supports portrait or landscape orientation;
- displays Project and organisation-specific variables;
- contains a product grid derived from the Products and prices applicable to the Project;
- contains a QR code and printed Store URL for the Project Store;
- provides a space in which a teacher or organiser can write the child's name;
- preserves a protected white exclusion zone for the child's artwork;
- is stored as a versioned asset linked to the Project;
- is downloadable from the C2 dashboard; and
- can be shared through a secure emailed link.

## Current AMOW process being replaced

The existing process broadly works as follows:

1. A Project is submitted through an external form tool.
2. Zapier creates or configures the Project Store and its closing date through WordPress and a plugin.
3. Zapier creates a WordPress post containing the embedded Store.
4. The Store URL is passed with Project information to CraftMyPDF.
5. CraftMyPDF generates a customised Project template containing:
   - the organisation name;
   - a product and price grid with spaces for purchase quantities;
   - a QR code linked to the WordPress Store page;
   - space for the child's name; and
   - a white artwork exclusion zone.
6. The completed template is distributed for printing and use.

FUND should internalise this workflow without reproducing unnecessary WordPress, Zapier or CraftMyPDF dependencies.

## Recommended technical direction

Use a controlled template system rather than a general-purpose page designer.

The recommended composition pipeline is:

1. Store a reusable C1 template definition as structured configuration.
2. Build a dedicated A4 HTML/React print view from that definition.
3. Resolve approved variables from the Project, organisation, Event, Store, Catalogue and Products.
4. Render the final document server-side to PDF using Playwright/headless Chromium or the existing equivalent if IsoStack already has an approved PDF renderer.
5. Store the resulting PDF as a versioned Project asset.

`pdf-lib` may be considered for later stamping, merging or modification operations, but direct coordinate-based PDF drawing is not the preferred primary renderer for the variable product grid and C1 preview experience.

## Core design principles

### Reusable template versus Project PDF

The reusable C1 template and generated Project PDF must be separate records with separate lifecycles.

The **template definition** contains reusable layout, background, component and styling configuration.

The **Project PDF** is an immutable generated snapshot containing the effective Project data, Product selection, prices, Store destination and template version used at the time of generation.

Changing a template, Catalogue, Product, price or Project value must not silently alter a PDF that has already been generated or distributed. A relevant change should mark the existing PDF as outdated and require regeneration into a new version.

### Controlled editor

The C1 UI should provide constrained, understandable controls. It must not initially expose arbitrary HTML, CSS, scripting, unrestricted layering or a general-purpose desktop-publishing interface.

### Physical dimensions

Persist page and component measurements in millimetres rather than pixels. This provides predictable A4 output and makes the configuration understandable to C1 users.

## Template model

Each C1 template should support at least:

- tenant ownership;
- name and optional description;
- A4 page size, fixed for this capability;
- orientation input: `PORTRAIT` or `LANDSCAPE`;
- uploaded background asset;
- background fitting rules;
- variable/component layout configuration;
- product-grid configuration;
- artwork exclusion-zone configuration;
- font, colour and alignment settings;
- draft, active and archived status;
- version number;
- created, updated and activated audit information.

Orientation must be a first-class template input. Changing it must update:

- the C1 editor canvas;
- usable page dimensions;
- background aspect-ratio and resolution validation;
- component boundary validation;
- PDF renderer options; and
- preview/test output.

Templates must be versioned. Editing an active template should create a new draft version or follow another explicit versioning process; it must not rewrite the definition used by historical Project PDFs.

## Background image

C1 must be able to upload an A4 background PNG for each template.

The upload flow should:

- validate MIME type and actual file type;
- validate the aspect ratio against the selected orientation;
- report inadequate print resolution;
- recommend approximately 2480 × 3508 pixels for 300 dpi portrait, or 3508 × 2480 pixels for landscape;
- show whether the image will fit, crop or fail validation;
- provide a replace/remove action; and
- use the existing IsoStack asset-storage pattern where appropriate.

The artwork exclusion zone should be stored independently from the background image. During rendering, FUND should be able to place an enforced white rectangle over the background. This prevents a deficient uploaded background from compromising the artwork area.

## Approved variables and C1 variables UI

FUND requires an explicit template-variable registry. C1 users may configure approved variables through the UI, but must not enter executable expressions or arbitrary database field paths.

The initial registry should assess and, where supported by existing models, include:

- organisation name;
- Project name;
- Project number/reference;
- Event name;
- Project closing date;
- Event closing date;
- Store URL;
- QR code generated from the canonical Store URL;
- child-name label and writable blank area;
- instructional text;
- product grid;
- currency;
- C1 tenant name or branding, if required.

Codex should verify the authoritative source and null behaviour for every proposed variable rather than assuming field names.

The C1 variables UI should provide:

- an **Add variable** control listing only approved variables;
- a clear display label and variable type;
- drag-and-drop positioning within the A4 canvas;
- numeric position and size inputs in millimetres for precise adjustment;
- width and height controls where applicable;
- font family from an approved set;
- font size, weight, colour and alignment where applicable;
- editable static labels, such as `Child's name:`;
- show/hide controls;
- sample-value preview;
- boundary and overlap warnings;
- deletion from the layout without deleting the underlying registry definition; and
- prevention of duplicate singleton variables such as the product grid or QR code.

Variable types may require different controls. For example:

- text variables use typography and alignment controls;
- the QR code uses position, physical size and quiet-zone controls;
- the product grid uses column and row-style controls;
- the artwork zone uses position, size, protection and fill controls;
- the child-name area may combine a static label, border/line style and blank writing space.

The editor should provide representative sample data so that a C1 administrator can design and preview a template without selecting a live Project. It should also allow a test preview against a selected existing Project where permissions permit.

## Product-grid component

The product grid must be derived from the effective Products and prices already linked to the Project through its Catalogue and Project Product configuration.

The implementation must establish authoritative rules for:

- which Project Products appear;
- Product ordering;
- Product and option/variant labels;
- effective price resolution;
- currency and VAT display;
- quantity-entry boxes;
- optional Product codes;
- optional Product images;
- long labels;
- row height and font-size minimums;
- maximum printable rows; and
- empty and invalid Catalogue states.

Initial configurable columns should be assessed from:

- Product;
- option or variant;
- price;
- quantity; and
- optional Product code.

The C1 product-grid UI should allow the administrator to:

- enable supported columns;
- arrange configurable columns where safe;
- set grid position and size;
- select an approved compact or standard row style;
- configure header labels;
- configure colours, borders and typography within safe limits; and
- preview short, long and maximum-size sample Catalogues.

Because the document is intentionally a single A4 page, FUND must not silently add another page or shrink content below an agreed legibility threshold. Template activation and Project generation must fail with a clear validation message when the effective product grid cannot fit. A compact layout or a different approved template may be required.

## QR code and Store URL

The QR code must be generated from the Project Store's canonical FUND URL. The printed Store URL should also be available as an approved variable so that access does not depend entirely on scanning the code.

The QR implementation should enforce:

- a minimum physical size;
- a suitable white quiet zone;
- high contrast;
- no decorative logo in the initial implementation;
- SVG or another print-sharp source where supported; and
- generation-time validation or automated decode testing where practical.

The roadmap must identify the Store/canonical URL dependency. PDF generation cannot be considered ready until the Project has a stable destination URL.

## Project PDF model and lifecycle

Each generated Project PDF should record at least:

- tenant and Project ownership;
- template identity and template version;
- generated asset identity;
- orientation;
- generation status;
- generation timestamp;
- generated-by user or system actor;
- Project PDF version;
- effective data or input snapshot/fingerprint;
- Catalogue/Product/price snapshot or traceable version references;
- Store URL and QR value used;
- current, superseded and outdated state; and
- failure information suitable for operational diagnosis.

Suggested generation statuses should be assessed from:

- `NOT_GENERATED`;
- `QUEUED`;
- `GENERATING`;
- `READY`;
- `FAILED`;
- `OUTDATED`; and
- `SUPERSEDED`.

Avoid duplicating state if these are better represented through separate generation and document lifecycle fields.

## Generation workflow

PDF generation should run as a background job rather than holding open an ordinary application request.

The intended flow is:

1. Confirm that the Project satisfies generation-readiness rules.
2. Resolve the applicable active template and exact version.
3. Resolve Project, organisation, Event, Catalogue, Product, price and Store values.
4. Create an immutable generation input snapshot or fingerprint.
5. Generate and validate the QR code.
6. compose the A4 HTML/React print view using the template orientation and configuration.
7. Render the document to PDF.
8. Validate that the output is a single A4 page in the required orientation.
9. Store the PDF through the approved asset-storage mechanism.
10. Create the Project PDF/version record.
11. Expose the completed document in the C2 dashboard.
12. Optionally trigger the approved email notification flow.

The workflow must be idempotent and safe to retry. Failed jobs must not create multiple apparently current PDFs.

## C1 experience

C1 should be able to:

- list templates;
- create a draft template;
- select portrait or landscape orientation;
- upload or replace the background PNG;
- add and configure approved variables;
- configure the product grid;
- position and size the artwork exclusion zone;
- preview with sample data;
- preview using an eligible Project;
- generate and download a test PDF;
- see validation failures before activation;
- activate a valid template version;
- archive a template without breaking existing Project PDFs; and
- inspect which template/version was used for a Project PDF.

Follow the IsoStack Table CRUD Pattern for template lists. Where the visual editor needs more space, use a dedicated child page rather than attempting to fit it into a CRUD modal.

## C2 dashboard experience

Within an authorised Project, C2 should see a Project Template/PDF panel containing:

- status;
- template name where appropriate;
- generated date;
- current version;
- thumbnail or preview;
- Download PDF;
- Copy secure link, where permitted;
- Email link, where permitted;
- an outdated warning; and
- regeneration/request-regeneration action according to the agreed C1/C2 permission model.

C2 must not be able to edit the C1-owned template definition. A later enhancement may allow C2 to select from templates explicitly approved by C1 for the relevant Event or Catalogue.

Authenticated dashboard downloads should use existing C2 Project access controls. Emailed downloads should use a revocable, expiring and non-guessable token or the established secure-file-link pattern. Avoid exposing raw storage URLs.

## Readiness and invalidation rules

Before generation, validate at least:

- an active template/version is applicable;
- orientation and background are valid;
- required variables resolve;
- the organisation name is present;
- the Project's effective Catalogue and Products are valid;
- all required prices resolve;
- the product grid fits;
- a stable canonical Store URL exists;
- the QR code is valid;
- dynamic elements remain within page boundaries;
- protected elements do not overlap the artwork zone; and
- the result can be rendered as one A4 page.

Codex should propose an explicit invalidation matrix. At minimum, assess whether these changes mark the current PDF outdated:

- template version;
- orientation;
- background;
- variable layout or style;
- Project name/reference;
- organisation name;
- Project or Event closing date where printed;
- Store URL;
- Project Product membership;
- Product name or printable option label;
- effective price; and
- Catalogue ordering.

Historical PDFs must remain available to authorised C1 users for audit and support even after being superseded, subject to the eventual retention policy.

## Roadmap slices

### T1 — Template foundation

#### T1-a — Template schema and lifecycle planning

Define the schema and service contract for:

- C1-owned A4 templates;
- portrait/landscape orientation;
- structured layout configuration;
- approved variable registry references;
- background assets;
- artwork exclusion zone;
- template status and versioning;
- activation validation; and
- audit events.

Deliver planning documentation and schema proposal first. Do not add UI or PDF rendering in this sub-slice.

#### T1-b — Template schema implementation

Implement the approved schema and migration only, following the established FUND schema-first process.

Do not add template CRUD routes, visual editor, Project PDFs, rendering jobs, Store changes or email delivery in this sub-slice.

#### T1-c — Template services and C1 CRUD API

Implement tenant-scoped template services and API contracts for:

- list/get;
- create draft;
- update draft;
- create/version from active template;
- validate;
- activate; and
- archive.

Enforce C1 ownership, status transitions, immutable historical versions and asset-reference rules.

#### T1-d — C1 template list and basic configuration UI

Implement:

- template list using the Table CRUD Pattern;
- draft creation;
- name and description;
- portrait/landscape input;
- background PNG upload/replacement;
- basic status/version information; and
- navigation to a dedicated template editor child page.

This sub-slice should not yet implement the full visual variables editor unless its dependencies are already complete and the boundary remains safe.

### T2 — Variables and visual template editor

#### T2-a — Approved variable registry and resolution service

Define and implement the safe registry of supported variables, their types, authoritative data sources, formatting rules, null behaviour, sample values and singleton/repeatable rules.

Implement Project-aware resolution without permitting arbitrary expressions or field paths.

#### T2-b — C1 A4 visual editor

Implement the dedicated portrait/landscape A4 editor with:

- accurate page canvas;
- background preview;
- Add variable UI;
- drag, resize and numeric millimetre controls;
- type-specific styling controls;
- sample data;
- artwork-zone protection;
- page-boundary and overlap validation;
- save draft; and
- responsive administration behaviour without pretending that the physical page itself is responsive.

#### T2-c — Product-grid component and editor controls

Implement the reusable dynamic product-grid component, effective Project Product/price resolution and C1-safe grid controls.

Include deterministic overflow and activation-validation rules. Do not silently generate multiple pages.

#### T2-d — Template preview and test document

Implement browser preview plus test-PDF generation using sample data and, where permitted, a selected existing Project.

Confirm that preview and final rendering share the same composition components sufficiently to avoid layout drift.

### T3 — PDF composition and Project document lifecycle

#### T3-a — Project PDF schema and input snapshot

Define and implement the Project PDF/version model, generation states, template version linkage, input snapshot/fingerprint, current/outdated/superseded behaviour and audit events.

#### T3-b — PDF generation service

Implement:

- readiness validation;
- HTML/React print composition;
- orientation-aware A4 rendering;
- QR generation;
- background and font loading;
- server-side PDF rendering;
- single-page validation;
- asset storage;
- idempotency; and
- safe failure reporting.

#### T3-c — Background job integration

Connect generation to the approved IsoStack job/queue mechanism. Implement retries, concurrency limits, operational logging and protection from duplicate current versions.

#### T3-d — Invalidation and regeneration

Implement the approved invalidation matrix, outdated signalling and explicit regeneration into a new immutable Project PDF version.

### T4 — C2 delivery and communication

#### T4-a — C2 Project PDF panel

Add the authorised C2 Project panel with status, preview/thumbnail where practical, version, generated date and download action.

#### T4-b — Secure share link

Implement revocable, expiring, non-guessable Project PDF links without exposing raw object-storage locations.

#### T4-c — Email delivery

Integrate Project PDF availability with the approved FUND/IsoStack email mechanism. Prefer a secure download link over a large attachment unless a confirmed business requirement says otherwise.

#### T4-d — C1 operational support view

Allow authorised C1 users to inspect current and historical Project PDF versions, generation failures, outdated reasons and delivery information.

### T5 — Review, testing and release readiness

#### T5-a — Automated tests

Cover:

- tenant and role isolation;
- orientation;
- template version immutability;
- variable resolution and null handling;
- product ordering and pricing;
- grid overflow;
- QR destination;
- generation idempotency;
- invalidation/regeneration;
- secure-link expiry/revocation; and
- historical version access.

#### T5-b — Visual regression and print QA

Create representative portrait and landscape fixtures and verify:

- A4 dimensions;
- background placement;
- text and font output;
- long organisation and Product names;
- minimum and maximum product grids;
- artwork-zone protection;
- QR scanning from printed output;
- quantity-writing areas; and
- browser preview versus generated PDF.

#### T5-c — Operational and roadmap documentation

Update the FUND roadmap/control document, READMEs, schema documentation, permissions guidance, asset/job operational guidance and user-facing support notes.

## Dependencies and sequencing

The roadmap review should explicitly map dependencies on:

- C1 tenant permissions;
- C2 Project access;
- Project-to-organisation linkage;
- Events and Project closing dates;
- Catalogues, Products and Project Product membership;
- effective pricing and eventual commerce rules;
- stable Project Store URLs;
- asset upload and object storage;
- background jobs/queues;
- email delivery;
- audit logging; and
- retention policy.

Schema and template work can begin before full Store implementation, but production Project PDFs containing QR codes must not be declared complete until a stable Store URL contract exists.

## MVP boundary

The first usable release should include:

- reusable C1 A4 templates;
- portrait and landscape orientation;
- one background PNG per template version;
- approved variables UI;
- organisation name;
- Product/price/quantity grid;
- QR code and printed Store URL;
- child-name writing area;
- protected artwork exclusion zone;
- preview and test PDF;
- Project-specific PDF generation;
- versioned storage;
- C2 dashboard download; and
- secure emailed link.

Defer unless evidence shows they are immediately required:

- arbitrary HTML/CSS;
- arbitrary database expressions;
- multi-page templates;
- non-A4 sizes;
- unrestricted layering;
- rich desktop-publishing tools;
- decorative QR codes;
- C2 layout editing;
- PDF annotations or form fields; and
- automatic background design generation.

## Required planning output from Codex

Before starting implementation, Codex should:

1. Inspect the current FUND roadmap and relevant repository evidence.
2. Reconcile these `T` slices with existing roadmap numbering and dependencies without renaming unrelated slices.
3. Identify existing asset, job, email, audit and PDF-generation patterns that should be reused.
4. Confirm the authoritative data source for every proposed variable.
5. Propose the template, layout configuration and Project PDF schemas.
6. Propose template and Project PDF state transitions.
7. Produce the PDF invalidation matrix.
8. Document Store URL and commerce dependencies.
9. Record unresolved decisions and blockers explicitly.
10. Stop for review after the planning/schema proposal; do not implement across all slices in one change.

## Acceptance principles

The capability is successful when:

- C1 can configure and validate a branded A4 template without technical knowledge;
- C1 can choose portrait or landscape and see an accurate preview;
- C1 can position and style approved variables through a safe UI;
- the product grid is generated from authoritative Project Catalogue data;
- every Project PDF is reproducible and traceable to its inputs and template version;
- historical PDFs do not change retrospectively;
- C2 can reliably obtain the correct current PDF;
- emailed access is secure;
- artwork space remains protected; and
- the finished printed sheet provides a dependable route to the correct Project Store.