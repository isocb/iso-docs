# FUND Phase 1 Slice 1R-F-A — Real AMOW Template, Pricing And Deployed Renderer Proof

Date: 2026-08-11

Status: **PLAN ACCEPTED; INFERRED R1/R1A COMPOSITIONS SUPERSEDED; R1B SOURCE-FAITHFUL
AUTOMATION AND HUMAN/PHYSICAL REVIEW PASS; STAGE B LINUX PARITY AND EXACT SECURITY SCAN PASS
AT DEV `139d09c4`; STAGE C ACCEPTED, IMPLEMENTED AND EXACT `328aadf0` LOCAL/LINUX/SECURITY
GATES PASS; EXTERNAL RUN/TEARDOWN PENDING; NO LATER SLICE AUTHORISED**

Owning lane: FUND

Parent:

[`1R-F Project Offer And Artwork Readiness Reconciliation`](2026-07-15-fund-phase-1-slice-1r-f-project-offer-artwork-readiness-reconciliation-planning.md)

Authoritative controls:

- [`root portfolio roadmap`](../../../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md)
- [`FUND roadmap`](../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md)
- [`FUND strategic completion roadmap`](../00-roadmap-control/2026-07-15-fund-store-artwork-orders-and-production-strategic-completion-roadmap.md)
- [`FUND refinement register`](../00-roadmap-control/2026-07-20-fund-refinement-wishlist-and-slice-control.md)

Governed inputs:

- [`FUND open questions`](../05-fund-open-questions.md)
- [`Application Artwork Template refinement`](../01-cr-inputs/2026-07-15-fund-application-artwork-template-refinement.md)
- [`Project Product selection limits and template capacity`](../01-cr-inputs/2026-07-15-fund-project-product-selection-limits-and-template-capacity-cr.md)
- [`Collective artwork and workflow-aware instructions boundary`](../01-cr-inputs/2026-07-15-fund-collective-project-artwork-composition-approval-and-workflow-aware-product-instructions-remedial-clarification.md)
- [`Template Manager source brief`](../01-cr-inputs/2026-07-15-fund-template-manager-brief.md)

## 1. Accepted Planning Decision

The control owner accepted `1R-F-A` on 2026-08-11 as one isolated proof lifecycle. It answers
one question before FUND creates
Application Template, Artwork Template, offer-lock, generation-job or secure-delivery
production contracts:

> Can the genuine AMOW Individual Artwork template family be composed from controlled
> resolved Project/Store data and rendered reproducibly as a legible, exact one-page A4 PDF
> in portrait or landscape, with C1 tenant branding, in a deployment-equivalent
> Render browser runtime?

The proof must produce measured evidence and schema inputs. It must not become a thinly
disguised first production implementation.

## 2. Exact Outcome

If this plan is accepted and proof implementation is then separately authorised, the proof
must:

1. reproduce the supplied portrait and landscape examples as two orientations of one
   genuine AMOW A1 Individual Artwork compositional contract using controlled HTML/React
   and print CSS;
2. render short, long, maximum-capacity and deliberate-overflow fixtures;
3. prove exact one-page A4 portrait and landscape dimensions, bounded content, bundled
   fonts, the accepted empty Order Code writing area, protected artwork area,
   Product/price/quantity/total grid, canonical URL and matching QR;
4. demonstrate browser-preview/PDF parity and actual-size physical print usability;
5. run the same pinned renderer in an isolated Docker-based Render worker proof;
6. round-trip the generated PDF through a dedicated private proof-object boundary and remove
   the object afterward;
7. record resource, retry, deterministic-layout and failure envelopes;
8. establish initial standard and compact Product-grid capacities from evidence; and
9. return explicit inputs for `1R-F-B` planning without creating its schema.

Success selects a renderer/runtime direction and measured layout envelope. It does not make
the renderer, template or Store offer production-ready.

## 3. Current Baseline Findings

Application baseline at planning is exact production `cde4eaff` on dev, staging and main.

The repository already contains:

- Node.js 22 ownership through `.nvmrc` and `package.json`;
- `pdf-lib` for PDF inspection and `qrcode` for deterministic QR generation;
- `FundProjectProduct`, `FundProjectStore`, `FundProjectStoreProduct` and immutable
  `FundStoreProductConfigurationVersion` evidence;
- net price, VAT, currency, tax treatment and price-entry-basis snapshots; and
- Cloudflare R2 clients, including public general media storage and a private bucket contract
  dedicated specifically to email attachments.

The repository does not yet own:

- a direct Playwright/Chromium dependency and matching installed browser binary;
- a browser-capable Render worker or Dockerfile;
- a production consumer-price resolver accepted for Artwork Template use;
- a final canonical public FUND Store URL resolver;
- a private generated-document storage contract; or
- any Application Template, Artwork Template, offer-lock or generation-job aggregate.

Current `render.yaml` defines one native Node web service and a one-minute cron only. The
proof must not add Chromium to the production web service or overload the shared cron.

Current external guidance also supports an isolated runtime decision: Playwright requires a
browser binary matching its package version and Linux dependencies, while Render recommends
Docker when OS-level packages or guaranteed reproducibility are required. Render background
workers are intended for long-running report-generation work. The proof therefore prefers a
temporary Docker-based Render worker with an exact Playwright/browser image tag and digest,
rather than changing the existing native web runtime.

## 4. Control-Owner Design Evidence And Remaining Confirmation

The control owner supplied and confirmed two current AMOW composite examples on 2026-08-11:

- [current portrait artwork, Project 2541](https://drive.google.com/file/d/11JtpEq2aO6yC2PAikOa03-gdSQZm67ez/view?usp=drivesdk); and
- [current landscape artwork with C1 tenant logo](https://drive.google.com/file/d/1qDHo_2sKX4s3ZipdGyk1QrQONJ7D73jU/view).

Together they establish one template family with:

- portrait and occasional landscape orientation;
- a Product table containing every Product selected for the Project exactly once, in the
  configured display order, with the exact gross purchaser price used by the Store;
- data-driven School/Organisation name, Project name, Project number, Store closing date and
  Store URL;
- a QR code that must encode that same Store URL;
- the C1 tenant logo where the selected composition includes it; and
- deliberately blank labelled writing spaces for Child First Name, Child Surname and
  Class/Group, completed by the purchaser or school after the child finishes the artwork;
- six empty purchaser-write-in Store Order Code boxes, distinct from the automatically
  printed Project number; and
- two independently data-driven sanitised rich-text instruction blocks;
- a fold-aware landscape composition with all control/order content in the left panel and
  Project/date/logo plus artwork in the right panel;
- a portrait composition with the same control hierarchy in a compact top band and a large
  lower artwork area; and
- composition-specific movement/resizing rather than a simple orientation rotation.

The proof is therefore component composition, not text placed over one immutable PDF
background. The source PDFs remain design evidence; they do not become executable or
arbitrary template content.

Control-owner decisions on 2026-08-11 also confirm:

- both orientations print at actual A4 size without fit-to-page scaling;
- AMOW/C1 explicitly selects portrait or landscape rather than automatic inference;
- the apparent logo is the C1 tenant logo, not a Client logo;
- Store closing date is the Project closing date; and
- the current Product/How Many/Price/Total/Grand Total structure remains authoritative.

No further design-data business confirmation blocks proof fixture finalisation.

The Order Code contract is now confirmed at proof level: the artwork always presents six
empty boxes. An ordinary post-sale Store Order number begins as four significant digits and
is left-padded with zeroes to six display digits, for example `004271`. The same format
naturally accommodates five significant digits with one leading zero and later six digits
where Event volume requires them. The purchaser copies the displayed value from the
confirmation/receipt so the returned artwork can be cross-referenced through the school and
into AMOW production.

The short number may be reused in another Event/Project namespace. Its human reconciliation
identity is the C1 tenant context plus printed Project number plus six-digit displayed Store
Order Code. This is composite business uniqueness/correlation, not technical idempotency.
The machine Commerce Order identifier, payment transaction reference and idempotency key
remain separate authorities and provide the diagnostic fallback. None is preprinted in the
six boxes.

This is one bounded design input, not a request for customer, child, Order or payment data.
Names, Products, prices, URLs and dates used by the proof remain synthetic but
operationally representative and non-sensitive.

### 4.1 Business Decision Register

| Question | Current decision | Effect on `1R-F-A` |
| --- | --- | --- |
| Physical page | Portrait and landscape are actual-size A4 without fit-to-page | Accepted proof input |
| Orientation authority | AMOW/C1 explicitly selects orientation | Accepted fixture input; no automatic inference |
| Logo identity | Logo is the C1 tenant logo | Accepted fixture input |
| Closing date | Printed Store closing date is Project closing date | Accepted fixture input |
| Product table | Every selected Product once in configured display order, exact gross Store price, current quantity/total/grand-total structure | Accepted fixture input |
| Child fields | Child First Name, Child Surname and Class/Group remain separate and blank for handwriting | Accepted source-derived fixture input |
| Instruction regions | Artwork guidance and ordering/return guidance are separate sanitised data inputs | Accepted source-derived fixture input |
| Physical composition | Landscape preserves its folding left-control/right-artwork panels; portrait preserves a compact top control band | Accepted source-derived fixture input |
| Store Order Code | Six physical boxes; 4-digit ordinary number left-zero-padded to six, naturally growing to 5/6 significant digits; reusable across Event/Project namespaces | Display contract accepted; allocation/issuance is parked in [`1R-H-A`](2026-08-11-fund-phase-1-slice-1r-h-a-store-order-short-code-and-single-artwork-correlation-planning.md) and remains separate from machine identifiers/idempotency |
| Multiple artworks | Each different child's artwork requires a separate Store Order | Accepted later Store/Order boundary; no proof implementation |
| Product options/modifiers | Options will exist and may alter price | TBA in later Product/Store planning; base-row proof remains valid |
| Pre-opening QR destination | Stable branded non-purchasable `Store not open yet` page recommended | Awaiting control-owner acceptance; does not block renderer proof |
| Lock after use | Recorded physical printing/distribution or first completed sale hard-locks ordinary revision | Accepted later lifecycle rule; explicit distribution confirmation required |
| Email, secure links and retention | TBA | Later `1R-F-E` concern; no proof blocker |

## 5. Controlled Proof Data Contract

The proof uses a versioned, checked-in fixture contract. It does not read a live database,
navigate an authenticated page or resolve mutable Catalogue/Product rows.

Minimum fixture fields are:

```text
contractVersion
orientation: PORTRAIT or LANDSCAPE
AMOW/C1 tenant brand assets and colour tokens
C1 tenant logo presence/absence
Client/School display name
Project name and Project number
Store closing date
blank Child First Name label/writing-area configuration
blank Child Surname label/writing-area configuration
blank Class/Group label/writing-area configuration
printed title
sanitised bounded artwork-guidance rich text
sanitised bounded ordering/return-guidance rich text
canonical Store URL string and matching QR payload
ordered Project-selected Product rows:
  code, display title, formatted unit gross price, currency
six empty purchaser-write-in Store Order Code boxes
protected artwork-area dimensions
layout style: STANDARD or COMPACT
```

The price strings are controlled representative gross purchaser-price outputs shaped like a
future resolved consumer-price service. They are not recalculated from
`unitPriceNetSnapshot` and do not settle the later net/VAT/gross/rounding implementation.

Required fixtures:

1. portrait ordinary content without a displayed C1 tenant logo;
2. landscape ordinary content with the allowlisted C1 tenant logo;
3. long Client/Project/title/instruction/Product content in each orientation;
4. standard layout at its measured maximum;
5. compact layout at its measured maximum;
6. one item beyond each measured maximum, which must fail closed; and
7. unsafe rich text, invalid tenant-logo input, missing required values and unresolved-token cases,
   which must be refused before rendering or object write.

Orientation and Product-grid density are separate inputs: landscape must not silently mean
compact, and portrait must not silently mean standard.

## 6. Proof Architecture

```text
versioned controlled fixture
-> schema validation and sanitisation
-> pure Artwork Template view model
-> React static markup + local print CSS/fonts/assets
-> pinned Playwright Chromium page.setContent
-> browser preview screenshot + PDF
-> pdf-lib structural inspection + QR decode + layout telemetry
-> optional dedicated private proof-object PUT/HEAD/GET/checksum/DELETE
-> machine-readable evidence report
```

Rules:

- no renderer request may navigate the live application or an arbitrary URL;
- all fonts, CSS, logos and background assets are local and allowlisted;
- the C1 tenant logo is absent cleanly when the selected composition omits it and is fitted
  inside an explicit non-distorting, non-overlapping bound when present;
- the Product table preserves the controlled Project-selection order and includes no
  unselected Product;
- the generated template contains separate labels and empty writable areas for Child First
  Name, Child Surname and Class/Group but no resolved or fixture child identity;
- the visible Store URL and QR payload must be exactly equal after canonicalisation;
- outbound requests are refused except the explicitly configured private R2 endpoint during
  the object round-trip phase;
- JavaScript supplied by fixture content is impossible;
- rich text uses the accepted formatting allowlist and sanitisation boundary;
- CSS uses physical units and an explicit `@page` A4 contract;
- `page.pdf` uses print backgrounds and the pinned orientation;
- browser-preview and PDF composition consume the same view model and stylesheet;
- the deliberate-overflow fixture must fail before upload rather than shrink, truncate,
  paginate or hide content; and
- proof artefacts carry no production/customer classification and are never publicly
  addressable.

## 7. Runtime And Dependency Decision Gate

The proof implementation must pin one mutually compatible set of:

- Node 22;
- Playwright library/test package;
- Chromium binary;
- Docker base or Playwright image by immutable tag and digest;
- bundled fonts with recorded licence/redistribution status;
- PDF raster/inspection tooling; and
- one test-only QR decoder.

Only Chromium is installed. CI runs sequentially with one browser worker to prioritise
reproducibility and bounded memory.

The preferred deployed proof is a temporary Render `worker` using `runtime: docker`, with:

- no public route;
- no production/staging database or application secrets;
- no auto-deploy;
- one controlled fixture-batch trigger at startup;
- machine-readable results written to logs and the bounded proof output;
- an idle state after the single run so Render does not restart a successful short-lived
  process; and
- immediate suspension/deletion after evidence capture.

Creating this temporary Render service is an external infrastructure action and requires
separate explicit control-owner authorisation during the executable proof cycle. Planning
does not create it.

Stages A/B implementation does not include a Render Blueprint. The Studio Mac has no Docker,
Podman or equivalent runtime, so Stage B was executed in the isolated dev-only GitHub Actions
Linux-container workflow. Exact run `31595635243` passes against accepted Mac evidence at
application `139d09c4`. No deployment or Stage C claim is inferred from that result.

## 8. Private Proof-Object Boundary

The storage phase uses a dedicated private proof bucket or exact isolated prefix with no
public development URL. It must not repurpose the email-attachment bucket or claim the
general public media bucket as the future Artwork Template store.

For each controlled PDF:

1. generate a random proof key under an exact run prefix;
2. PUT with PDF content type and checksum metadata;
3. HEAD and verify length/content type/checksum;
4. GET and verify byte checksum;
5. DELETE;
6. prove HEAD/GET refusal after deletion; and
7. list the exact prefix at teardown and prove zero retained objects.

Storage success demonstrates S3-compatible private-object feasibility only. Retention,
historic access, secure organiser grants and production bucket ownership remain `1R-F-B/E`
decisions.

## 9. Execution Stages And Stops

### Stage A — Local composition

- build the pure fixture/view-model/composition harness;
- generate preview, PDF and evidence report;
- refuse invalid and overflow fixtures; and
- stop if the genuine design cannot be represented without arbitrary HTML/CSS/script or a
  general visual editor.

### Stage B — Container and CI equivalence

- execute the same fixtures in the pinned Linux container;
- compare layout telemetry and raster output with the accepted local result;
- record browser/font/tool identities; and
- stop if platform output is not reproducible.

Outcome: **PASS** at exact application `139d09c4`; see the
[`Stage B Linux container parity gate`](../05-review-and-test/2026-08-12-fund-phase-1-slice-1r-f-a-stage-b-linux-container-parity-gate.md).

### Stage C — Explicitly authorised temporary Render proof

The dedicated accepted execution contract is:

[`1R-F-A Stage C temporary Render/private-object proof`](2026-08-12-fund-phase-1-slice-1r-f-a-stage-c-temporary-render-private-object-proof-planning.md)

- deploy the exact proof commit to the temporary isolated worker;
- run the same fixture batch once;
- record build/runtime identity, cold/warm generation time, peak RSS, PDF size and bounded
  retry behaviour;
- perform private-object round-trip and zero-residue teardown; and
- suspend/delete the worker after evidence is captured.

Candidate outcome: exact application `328aadf0` is dev-aligned; local gates, Linux parity
run `31599134487` and Security Scan `31599134488` pass. External execution and teardown
remain pending and no Stage C PASS is yet claimed.

### Stage D — Human physical gate

- print at actual size without browser/printer fit-to-page;
- compare both genuine AMOW orientation references with preview and PDF;
- measure safe inset, protected artwork area, Order Code boxes and writable grid cells;
- verify legibility and handwriting space for standard and compact maximum fixtures;
- scan the printed QR using at least two representative devices; and
- where practical, print through two ordinary office-printer paths. A one-printer result is
  recorded as partial rather than silently generalised.

The executable proof stops at this human gate. It does not proceed into `1R-F-B`.

## 10. Automated Acceptance

All must pass:

1. fixture schema/sanitisation refuses unknown or unsafe content;
2. no remote application/resource request occurs;
3. every valid result contains exactly one PDF page;
4. page dimensions equal A4 portrait or landscape within the recorded point tolerance;
5. every measured component remains inside its applicable safe-print/content boundary;
6. the protected artwork area is unobstructed;
7. exactly six equal, individually outlined empty Store Order Code boxes render;
8. separate labelled Child First Name, Child Surname and Class/Group writing areas render
   empty, remain writable and contain no resolved child data;
9. ordered Product title, formatted price, blank quantity and blank total render once per
   selected row;
10. generated QR decodes to the exact fixture URL, including after PDF rasterisation;
11. the visible canonical URL exactly matches the QR payload;
12. C1 tenant-logo absence and bounded non-distorting presence both pass;
13. required bundled fonts finish loading and no unexpected fallback is reported;
14. preview/PDF raster and layout telemetry remain within documented tolerances;
15. standard and compact at-maximum fixtures pass;
16. one-over-maximum and geometric overflow fixtures fail before object write;
17. repeat runs retain the same business/layout evidence after volatile PDF metadata is
    excluded;
18. a simulated transient generation failure retries only within the bounded proof policy;
19. private object PUT/HEAD/GET checksum succeeds, DELETE succeeds and teardown proves zero
    retained objects; and
20. local container and Render evidence identify the exact same Node, Playwright, Chromium,
    font and proof-contract versions.

## 11. Human Acceptance Schedule

The review record must provide a concise matrix covering:

- visual fidelity to the supplied AMOW A1 reference;
- portrait/no-logo and landscape/C1-logo composition fidelity;
- short/long/standard-max/compact-max output;
- printed-title and instruction readability;
- Product-name wrapping and unambiguous prices;
- separate, clearly labelled and writable Child First Name, Child Surname, Class/Group, quantity/total and
  Store Order Code spaces;
- safe-print margins with no clipping;
- preview/PDF parity;
- physical QR scans from the recorded printer/device combinations; and
- deliberate overflow refusal rather than malformed output.

The control owner records PASS/PARTIAL/FAIL. A partial physical-printer matrix may inform
another proof iteration but cannot establish the final validated capacity.

## 12. Measured Decision Outputs

The proof review must record, not guess:

- accepted orientation(s) for the genuine A1 design;
- C1 tenant-logo fit, absence and source constraints;
- six-box Store Order Code writing-area dimensions and separation from the printed Project
  number;
- Child First Name, Child Surname and Class/Group writing-area dimensions and empty-state evidence;
- exact safe-print inset by component class;
- font family/weights and minimum accepted print sizes;
- standard and compact Product-grid capacity;
- row height and long-title wrapping envelope;
- protected artwork, Order Code, quantity and total physical dimensions;
- preview/PDF comparison tolerance;
- cold/warm generation time, peak RSS, PDF size and retry recommendation;
- private-object round-trip/teardown evidence;
- selected runtime/container/browser lock; and
- unresolved production consumer-price resolver implementation, canonical-URL service and
  production-storage inputs for `1R-F-B/E`.

These outputs are schema/planning evidence. They do not create configured production values.

## 13. Risk Assessment

| Risk | Impact | Control |
| --- | --- | --- |
| Local PDF passes but Render output differs | High | Same immutable container, versions, fixtures and layout telemetry locally/CI/Render |
| Chromium/system dependencies destabilise the web service | High | Isolated temporary Docker worker; no production web/cron modification |
| Attractive fixture masks missing price or URL authority | High | Label values representative; carry explicit unresolved production inputs forward |
| Overflow creates unusable physical forms | High | Hard geometric refusal; no silent shrink, truncation or pagination |
| Landscape is treated as a rotated portrait | High | Separate component geometry and fidelity gate for each supplied orientation |
| C1 tenant logo distorts, overlaps or loads remotely | High | Allowlisted local fixture, bounded contain-fit and explicit absent state |
| Table includes Products not selected for the Project | High | Ordered Project-selection fixture contract and exact membership assertions |
| Fonts change dimensions or breach licensing | High | Bundle/pin only approved fonts; record licence and fallback refusal |
| QR works on screen but not on paper | High | Raster decode plus multiple physical devices/printer evidence |
| Existing R2 bucket leaks proof PDFs | High | Dedicated private proof boundary, no public URL, checksum/delete/zero-residue proof |
| Real AMOW evidence contains personal data | High | Use blank design only; synthetic controlled names, prices and URLs |
| Generated sheets accidentally prefill child identity | High | The three child/class fields are label/geometry components only and must remain empty |
| Proof grows into editor/schema/job implementation | High | Explicit non-goals, no Prisma/API/UI/production service, stop after human gate |
| Temporary worker creates cost or persistent attack surface | Medium | Explicit creation authority, no public route/secrets, one run, suspend/delete and record teardown |
| Pixel determinism is overstated | Medium | Compare normalised raster/layout/business evidence; exclude volatile PDF metadata |

## 14. Explicit Non-Goals

This slice does not add or change:

- Prisma schema, migration or shared database data;
- Application Template, Artwork Template, offer-lock, job, grant or retention aggregates;
- production web, cron, public Store, C1, C2 or P1 routes/UI;
- general visual editor or arbitrary HTML/CSS/script;
- live Catalogue/Project/Store queries;
- resolved, stored or synthetic child identity values; only blank handwriting fields are
  rendered;
- consumer-price calculation, Store publication or checkout;
- real Order/Order Code issuance or matching;
- production Artwork Template storage, email or secure organiser delivery;
- collective artwork, Standard Product or `1R-F-B` through `1R-F-I` behaviour;
- Stripe, payment, production, fulfilment or commission behaviour; or
- staging/main application promotion.

## 15. Recovery And Teardown

The proof has no database rollback. Recovery is:

- disable/delete the temporary Render worker;
- delete the dedicated proof prefix/bucket objects and prove zero residue;
- revoke proof-only credentials;
- retain only non-sensitive fixtures, generated comparison artefacts and evidence reports
  approved for the repository; and
- remove the proof dependency/runtime changes if review rejects the direction.

No cleanup command may target a shared bucket, broad prefix or production service.

## 16. Review Decision And Next Authority

Plan acceptance and local Stages A/B implementation authority were given explicitly on
2026-08-11. A separate approval remains required before creating temporary Render
infrastructure or proof credentials. Acceptance does not pre-authorise external
infrastructure creation, shared storage access, deployment or any later child slice.

After execution:

- **PASS** — accept measured renderer/layout/capacity inputs and begin bounded `1R-F-B`
  planning only;
- **PARTIAL** — repeat only the failed proof dimension; or
- **FAIL** — reject/revise the renderer or layout direction without creating production
  template schema.

Bounded control-owner review prompt:

```text
Review only FUND 1R-F-A planning. Confirm the proof is correctly limited to one genuine
AMOW A1 portrait/landscape template family, C1 tenant logo, controlled representative
Project-selected Product and Store/commercial fixtures, isolated pinned
Chromium rendering, temporary Render-worker evidence, private proof-object round-trip and
automated/visual/physical print evidence. Confirm that no production schema, UI, job,
storage, email, Store, Order or later 1R-F child is authorised. If accepted, record the plan
as ready for a separately instructed proof implementation cycle, while retaining separate
approval for temporary Render infrastructure and proof credentials.
```

## 17. Technical Planning References

- [Playwright browser installation and version matching](https://playwright.dev/docs/browsers)
- [Playwright CI guidance](https://playwright.dev/docs/ci)
- [Render Docker services](https://render.com/docs/docker)
- [Render background workers](https://render.com/docs/background-workers)
- [Render Blueprint specification](https://render.com/docs/blueprint-spec)

## 18. Likely Implementation Boundary And Effort

The separately authorised proof should remain visibly isolated from production FUND code.
The expected application-repository change surface is:

```text
package.json / package-lock.json
  exact proof-only renderer and inspection development dependencies

scripts/proofs/fund-1r-f-a/
  README and controlled entry point
  contract/view-model validation
  React/HTML composition and print stylesheet
  local fonts and genuine blank-design assets
  short/long/max/overflow/unsafe fixtures
  structural, raster, QR and determinism checks
  private proof-object round-trip adapter
  Dockerfile and non-authoritative temporary Render Blueprint
  ignored local output directory
```

The executable cycle must also create:

- one implementation-confirmation document in `04-implementation-confirmations`;
- one combined automated, deployed-runtime and human physical gate in
  `05-review-and-test`; and
- the resulting roadmap disposition, without automatically selecting `1R-F-B`.

No file under Prisma schema/migrations, application routes, production FUND services or the
authoritative root `render.yaml` is expected to change. Discovery of a need to change one is
a stop-and-replan condition.

Indicative solo-development effort after the genuine AMOW pack is available:

| Work | Indicative focused effort |
| --- | --- |
| Controlled composition, fixtures and automated geometry/QR checks | 1–2 days |
| Pinned container, deterministic comparison and failure tests | 0.5–1 day |
| Separately approved Render/private-object run and teardown | 0.5 day |
| Physical print/QR gate, evidence and lifecycle reconciliation | 0.5 day |
| **Likely total** | **2.5–4 focused days plus review/deployment waiting time** |

This is a planning range, not a promise. A complex source PDF, missing font rights or
material local/Render layout divergence triggers a review rather than an unbounded extension.

## 19. Control-Owner Implementation Sequence And Prompts

The lifecycle is deliberately incremental. The control owner can use these prompts in
order; each step updates the implementation confirmation, review/test evidence and
authoritative roadmaps before the next step.

### Step 1 — Accept and implement locally only

```text
Accept the bounded FUND 1R-F-A plan. Implement Stages A and B locally only, including the
controlled portrait/landscape fixtures, pinned container and automated evidence. Create and
maintain the implementation-confirmation and local review/test documents as work proceeds.
Do not commit, create Render infrastructure, use shared data or begin 1R-F-B/1R-G/1R-H-A.
Stop for local human review.
```

### Step 2 — Record local/physical evidence

```text
Review the completed local 1R-F-A evidence and give me the exact human actual-size print,
visual fidelity and QR smoke schedule. Record my results in the review/test document. Do not
commit or create shared infrastructure unless I separately authorise it.
```

### Step 3 — Commit and align dev after a green local gate

```text
The 1R-F-A local and physical gate is accepted. Complete the lifecycle documentation,
commit the exact proof code and documents, align dev with origin/dev and require the exact
Security Scan to pass. Do not promote the application or create a Render worker yet.
```

### Step 4 — Authorise the temporary deployed-runtime proof

```text
Authorise only the documented temporary 1R-F-A Docker Render worker and private proof-object
credentials. Run the exact accepted commit once, capture runtime/checksum/zero-residue
evidence, then suspend/delete the worker and revoke proof credentials. Do not alter the
production web/cron service or promote staging/main.
```

### Step 5 — Conclude the proof

```text
Review the complete local, container, Render and physical 1R-F-A evidence. Reconcile the
implementation confirmation, review/test record, source CRs and authoritative root/FUND
roadmaps. Classify PASS/PARTIAL/FAIL and stop. Do not begin 1R-F-B, 1R-G or parked 1R-H-A
without a new explicit instruction.
```
