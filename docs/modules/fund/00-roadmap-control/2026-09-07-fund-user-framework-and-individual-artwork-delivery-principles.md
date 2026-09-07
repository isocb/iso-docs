# FUND User Framework And Individual Artwork Delivery Principles — 1R-F-B

Origin: 2026-09-01; reclassified: 2026-09-07

Status: **Subordinate roadmap augmentation and continuing business framework; non-executable**

The owner identified that the former 1R-F-B planning file had become a lasting business
framework, and requested that development planning now proceed. Its substantive material
is retained here, including the unaccepted technical appendix. This is a relocation and
role clarification, not a second portfolio roadmap or approval of every proposed rule.

Authority order:

1. [Root portfolio control](../../../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md) selects portfolio Now/Next.
2. [FUND roadmap](2026-06-25-fund-roadmap-and-slice-control.md) owns FUND disposition and delivery scope.
3. This augmentation explains the enduring business framework; accepted rules constrain later plans, while labelled proposals remain open.
4. [B1 development plan](../03-slice-planning/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md) defines the selected planning outcome and its eventual implementation gate.

The [business situation report](2026-08-25-fund-complete-module-smoke-readiness-business-overview.md)
is the short plain-English progress view. The [1R-F parent](../03-slice-planning/2026-07-15-fund-phase-1-slice-1r-f-project-offer-artwork-readiness-reconciliation-planning.md)
preserves accepted cross-CR ownership. Neither summary duplicates the B1 restart checkpoint.

The [former planning path](../03-slice-planning/2026-09-01-fund-phase-1-slice-1r-f-b-individual-artwork-template-offer-lock-schema-foundation-planning.md)
is retained only as a redirect for existing links. High-control evidence remains required
where a later implementation touches authority, schema, immutable offers or service access;
that does not prescribe the size of its data model.

## 1. Business Direction And Scope Authority

Re-establish FUND's visible business and user journey before selecting more technical
construction:

```text
C1 configures Events, Products, commercial rules and availability
-> C2 creates or manages a Project
-> suitable Products are selected
-> workflow-specific preparation and review/approval take place
-> Individual Artwork: ready to finalise -> C2 finalises -> matching document generated
-> each branch satisfies its publication-readiness requirements
-> Store becomes publishable
-> purchaser browses, Orders and pays
-> C1 operates and reconciles Orders
-> artwork/production requirements are matched
-> production is authorised and fulfilled
-> dispatch occurs
-> commission is calculated, reported and later settled
```

This framework supplies the business context that:

- shows what C1, C2 and the purchaser see and do;
- shows how a Project progresses and where readiness branches diverge;
- distinguishes foundations that exist from user journeys that remain absent;
- preserves the important offer-lock questions as product rules first;
- determines whether each part of the former ten-record option is required now or only for
  later operational hardening; and
- identifies the smallest coherent Individual Artwork vertical outcome that could be
  separately planned next.

This framework does not itself authorise application, database, provider or deployment
changes. On 2026-09-07 the owner endorsed its continuing role as a subordinate roadmap
augmentation and requested development planning. The root/FUND roadmaps now select
`1R-F-B1` development planning; the former C-through-I allocation and ten-model option are
not automatically selected.

### 1.1 Confirmed Phase 1 Smoke Scope And Business Report

The owner answered the smoke-scope questions in the existing [business situation report](2026-08-25-fund-complete-module-smoke-readiness-business-overview.md).
The following are now accepted planning inputs:

- the first connected smoke covers one AMOW Individual Artwork journey only; collective,
  Group/Bulk and Standard workflows follow later;
- Phase 1 ends with calculated and finalised commission statement evidence; exercising
  settlement is not required;
- before FUND deployment, simulated/emulated external services are satisfactory for
  development staging; after deployment, staging must be augmented to reflect the actual
  live services; and
- delivery, actual Products/options, media, Project setup and messages remain open. The
  report breaks the former combined question into concrete options, without choosing them
  on the owner's behalf.

This is the longer Phase 1 test destination, not acceptance of the proposed next Pass 2
implementation boundary. Section 8's offer/finalisation proposals remain distinct and are
carried into the B1 draft as explicit assumptions for review. The
business report is maintained alongside the existing lifecycle as its plain-English view;
it owns neither a competing selection nor a second restart checkpoint.

## 2. Business Concepts Preserved For Review

The strategic review does not reject the distinction between:

| Concept | Business meaning |
| --- | --- |
| Application Template | Reusable C1-controlled design and validated layout/capacity |
| Project Offer | Exact Products, prices, content and presentation accepted for one Project |
| Artwork Template | Generated Project-specific document used by the Individual Artwork workflow |

The requirement also remains valid that a finalised historical offer must not silently
change when Products, prices, branding or reusable templates later change. The review must
determine which facts must be immutable at each business milestone and what evidence the
next vertical journey genuinely needs.

Existing architecture remains protected:

- C2 Client/account is the Project-management node;
- C1 is producer/operator/supplier;
- the Project belongs to the C2 Client;
- FUND owns Project, Store, Product, readiness, artwork, production and commission context;
- Commerce Core owns generic Order, Payment and Refund evidence;
- typed FUND context links to Commerce evidence; and
- no duplicate generic FUND Order or payment model is introduced.

## 3. Existing Foundation And Demonstrated Gap

Substantial internal foundations already exist for C1 Client/Event/Product/Project
administration, C2 Client/Project management, Project Product eligibility/selection,
Project Store configuration and generic Commerce checkout/Order/payment machinery. The
corrected `1R-F-A` assumption test at exact application `0c7e4848` also proved that the
candidate Individual Artwork rendering and private-object approach can work within its
tested envelope, then removed all temporary resources.

Those foundations do not yet form an end-to-end fundraising operation. In particular:

- workflow-specific artwork readiness is only partially proved;
- the public purchaser Store is not built;
- the public FUND checkout/Order journey is not complete;
- physical artwork/Order matching is not operational;
- production, dispatch and fulfilment are not operational;
- commission calculation/statements/settlement are not complete; and
- no `1R-F-B` application, Prisma, migration or database implementation exists.

## 4. Project Workflow Branches Around The Common Spine

The principal variation occurs around Project/Product readiness, after Product selection
and before Store publication:

```text
                             -> Individual Artwork readiness
                            /
Client -> Project -> Products -> Readiness -> Store -> Order -> Fulfilment -> Commission
                            \
                             -> Collective / Bulk / Standard readiness
```

- **Individual Artwork** requires the Project-specific artwork-sheet/document process.
- **Group Personalised Product** requires collective artwork composition, organiser
  approval and supplier-side Product-presentation approval.
- **Bulk Order / Club-Funded** may use collective-artwork handling or ordinary Product
  readiness according to accepted Project/Product policy.
- **Standard / Unmodified Product** remains a Product path, not a separate Project type,
  and is ready through ordinary Store/commercial/presentation requirements.
- **Not Sure Yet** remains intake/configuration only and must resolve to an operational
  Project type before Product/readiness/Store progression.

This review describes how the branches fit one FUND architecture. It does not claim
implementation or behavioural proof for the unbuilt branches.

### 4.1 Ready To Finalise And Ready To Publish

For Individual Artwork these are separate gates, in this order:

```text
Project and template configured -> eligible Products selected -> offer preview
-> ready to finalise -> authorised C2 finalisation -> matching document generated
-> artwork readiness satisfied -> all remaining Store gates pass -> ready to publish
-> separate authorised publication
```

**Ready to finalise** means the Project has an operational type, a valid assigned template,
a selection within its validated capacity, resolved required content/prices and an
authorised finaliser. It does not require an already finalised offer or generated document.
The server must recheck these facts when finalisation is requested.

**Ready to publish** additionally requires the current finalised offer, its successful
matching Artwork Template and all existing Store/commercial/presentation gates. A failed
or pending generation leaves that readiness incomplete. Finalisation, generation and
download do not publish the Store or authorise checkout or production.

Collective readiness instead requires approved composition and separately released Product
presentation. Standard Products use ordinary Store readiness; mixed Bulk Projects apply
the appropriate branch per Product. Neither path inherits the Individual document gate.

### 4.2 Proposed User Walkthrough

This is a proposed target journey for business review, not a claim that the screens or
behaviour already exist. Section 5 records current delivery progress. The first five steps
describe the candidate Pass 2; later steps show its intended business hand-off only.

| Step / actor | What they see and do | What blocks progression | Result / next action |
| --- | --- | --- | --- |
| 1. C1 prepares the offer | In Event or standalone Project configuration, select a validated Application Template and eligible Products with prices and required content | No valid template assignment, missing offer content or unresolved commercial configuration | C2 can review the prepared Project; an eligible pool above template capacity shows a warning rather than silently removing Products |
| 2. Authorised C2 member selects Products | In the Project, see all eligible Products selected initially, the selection count/capacity and the resulting offer preview; deselect as needed | No selected Product, capacity exceeded, unresolved Project type or missing required content | Offer is ready for the authorised finaliser to review; a successful document is not required yet |
| 3. Proposed exact C2 organiser finalises | Review the Products, order, prices, Project content and template, then confirm the exact offer | Wrong/inactive finaliser or any relevant selection, price, template or authority change since preview | Preserve the confirmed offer; show document generation pending; Store is not yet artwork-ready |
| 4. System generates; C2 views status | Project shows generation pending, failed or available for that exact offer | Failed/incomplete generation, stale input or another offer becoming current | Failure remains visible with controlled retry; only a complete matching document becomes current |
| 5. Authorised C2 member downloads | See the matching document and Store preview using the same Products/prices; download through Project access | Wrong Client/Project authority, missing file or document/offer mismatch | Candidate Pass 2 ends with a usable document and explicit remaining publication blockers; no public trading or distribution is inferred |
| 6. C2 publishes; purchaser shops — later | C2 sees remaining publication blockers; after a separate publication action, purchaser sees only released ready Products and proceeds through checkout | Unmet Store/commercial/payment gates, unready Product or unavailable public journey | Commerce records Order/payment evidence; payment status comes from verified provider processing |
| 7. C1 operates Orders — later | See Orders, payment status, physical artwork receipt/matching and production holds | Unpaid/unconfirmed Order, unmatched artwork or unmet production requirements | Explicit production authorisation, then fulfilment and dispatch; payment alone never authorises production |
| 8. C1/C2 review commission — later | See Project sales/refund evidence, applicable accepted terms and the resulting statement | Incomplete reconciliation or unresolved adjustments | Calculate and report commission, then separately record settlement |

The consolidated E-B/E-C/E-D human acceptance gate remains relevant to steps 1–2 and 6;
this proposed walkthrough does not mark it passed. Printable use or physical distribution
also requires the applicable print/QR proof and distribution rules before that use begins.

## 5. Business-Journey Progress View

| Business capability | Current position |
| --- | --- |
| C1 Client/Event/Product/Project foundations | Substantial foundation exists |
| C2 Client/Project management foundation | Exists |
| Project Product selection/eligibility | Exists |
| Project Store/configuration foundations | Exists; consolidated human acceptance remains relevant |
| Workflow-specific artwork readiness | Partial; Individual technical proof only |
| Public purchaser Store | Not built |
| Consumer checkout/Order journey | Backend Commerce machinery exists; public FUND journey is incomplete |
| Physical artwork/Order matching | Not operationally built |
| Production workflow | Not operationally built |
| Dispatch/fulfilment | Not operationally built |
| Commission calculation/statements/settlement | Not operationally complete |
| End-to-end fundraising journey | Not yet reached |

## 6. Revised Three-Pass Sequence

### Pass 1 — User And Workflow Framework

The `1R-F-B` reconciliation now serves as this enduring framework for C1, C2 and purchaser
surfaces, Project progression, readiness branches and downstream convergence. It is not
an active executable slice. Open detailed business proposals remain visible in Section 8;
they do not prevent drafting the selected B1 plan with clearly stated assumptions.

### Pass 2 — Minimum Individual Artwork Vertical Journey

The owner has selected development planning for `1R-F-B1`, the first bounded proposal
for this path. Its draft must separate the emulated development result from eventual real
service operation and obtain acceptance of the business choices its implementation needs:

```text
C1 selects/configures a validated reusable template
-> C2 selects eligible Products
-> C2 previews the resulting Project offer
-> ready-to-finalise checks pass
-> C2 finalises the offer
-> the same exact Products/prices appear in the Store preview
-> the matching Project-specific artwork sheet is generated
-> C2 can access/download it
-> artwork readiness passes; other Store publication blockers remain explicit
```

The implementation boundary may cross schema, service and UI concerns when that is the
smallest safe recognisable journey, but each exact implementation decision still requires
a separately accepted plan. Public Store publication/trading, payment and physical
distribution remain outside this candidate unless later explicitly selected.

#### Essential Controls In The First Usable Journey

The later Pass 2 plan must include the minimum controls needed by the behaviour it enables:

- server-checked tenant, Client, Project and actor authority for selection, finalisation,
  generation and download;
- one consistent finalised offer and matching document, retaining the exact Products,
  order, resolved prices/content, template and Store URL/QR evidence so later edits cannot
  silently change what C2 confirmed;
- atomic finalisation with stale-input checks, protection against duplicate/concurrent
  requests and a defined pending/failure/retry outcome; no partial or mismatched file may
  be presented as current or satisfy publication readiness;
- secure managed storage and authorised access for generated documents, with a named
  operating owner and a proportionate retention/deletion and recovery boundary before
  persistent files are delivered; an expiring external grant/email is optional if the
  first journey uses authenticated Project download only;
- relevant failure, negative authority and version-consistency tests, direct C1/C2 proof,
  and document/price/layout/QR checks; physical-print acceptance is required before actual
  printable use or distribution; and
- explicit refusal of unsupported revision/unlock actions and a safe failure/rollback
  path that preserves existing confirmed offers and documents.

These are behavioural requirements, not a mandate for ten tables, a particular provider,
an elaborate job framework or a second authority model. Reuse existing capabilities where
they meet the selected boundary. A necessary control moves with the first behaviour that
depends on it; it cannot be deferred merely because Pass 3 has a hardening label.

#### Development Simulation And Later Live-Service Parity

The owner permits Phase 1 development staging to emulate payment, rendering, private
storage, scanning and email services as required by the chosen test. The later bounded
plan may use simulated providers to prove the application journey without provisioning
real services. Tests must still exercise the selected tenant/actor, offer/version,
concurrency and failure contracts; record which service responses were simulated and
which document, physical or provider behaviours were actually proved. Simulated success
is not evidence of real provider delivery or physical-print acceptance.

The essential controls above attach to the behaviour and environment enabled. Real managed
storage/recovery and real provider configuration are not prerequisites for an explicitly
emulated development run. Before enabling actual service use, its deployment plan must
define and prove the corresponding operating/access/recovery contract. Once FUND is
deployed, augment staging to match the services used by live FUND. No provider change or
deployment is authorised by these planning inputs, and the completed 1R-F-A proof is not
reopened.

### Pass 3 — Operational Hardening

After the minimum journey, evidence may justify richer assignment/version-history views,
detailed generation-attempt diagnostics, automated retry orchestration, external expiring
access, email/resend, advanced retention tooling, monitoring and scale improvements.
Post-publication revision workflows remain later work; unsupported changes must already
be refused. Pass 3 does not defer baseline private access, immutable offer/document
consistency, concurrency protection, failure handling or recovery required in Pass 2.

## 7. Proportionality Rule For Persistence

Appendix A preserves the former detailed proposal as technical design evidence. For every
proposed record, later planning must ask:

> Is this persistence required for the next proven user journey, or does it belong to
> later operational hardening?

This question is explicitly open for generation attempts, access grants,
generated-document history/storage separation, assignment history and offer/version
history. The review must not assume all ten proposed models are created together, but it
must not simplify away legitimate immutable commercial evidence merely to reduce the model
count. The business journey determines the persistence boundary.

## 8. Proposed Business Decisions For Control-Owner Acceptance

B1 acceptance update — 2026-09-07: Chris accepted D1–D4 in the bounded B1 plan.
Fixed templates come first, with the editor in Phase 2. Assignment hierarchy, exact active
organiser finalisation and no ordinary B1 unlock are accepted. B1 ends at the emulated
document/Store preview; purchaser and operational slices remain required within Phase 1.
These accepted B1 decisions take precedence over the earlier proposals below for B1.
Broader refinalisation workflows and the ten-model appendix remain unaccepted options.

The owner authorised the review corrections and documentation commit. The following
specific answers below are recommendations for acceptance, not decisions inferred from that
instruction or from the separate accepted smoke-scope answers in Section 1.1. They draw on
the accepted parent while making the unresolved choices explicit.

| Decision | Proposed answer | Boundary / consequence |
| --- | --- | --- |
| 1. Business concepts | Retain Application Template as reusable C1 design, Project Offer as the exact confirmed commercial/content selection, and Artwork Template as the resulting Project-specific document | Preserve these meanings without prescribing separate tables for every concept |
| 2. Assignment hierarchy | Event-linked Projects follow their Event's template assignment; standalone Projects use an explicit C1 Project assignment, otherwise the tenant standalone default | No Event-Project override in the minimum journey; missing/invalid assignment blocks finalisation rather than silently falling back |
| 3. Lock point | C2 finalisation confirms the exact offer before generation; show the resulting document as pending until successful | Generation failure does not unlock or rewrite the confirmed offer; finalisation does not publish the Store |
| 4. Finaliser | Initially retain the exact active Project organiser as finaliser; authorised same-Client Project members may prepare selection and view/download within existing permissions | Avoid inventing a new permission system for the first journey; broader finaliser authority remains an explicit later choice |
| 5. Revision / unlock | Drafts remain editable. Any supported pre-publication refinalisation requires organiser authority, a reason, audit and a new offer/document version. At publication, first Order, payment, physical distribution or production authorisation, refuse ordinary unlock pending a separately accepted reconciliation workflow | This conservatively extends the parent's paid-Order/distribution boundary to first Order and omits published-Store unlock from the minimum journey; it requires explicit acceptance. If pre-publication refinalisation is deferred, the UI must clearly refuse edits to a finalised offer |
| 6. Immutable milestones | Finalisation preserves actor/time, template/layout, ordered Products, exact commercial/configuration/content and Store URL/QR; generation binds the successful document to that offer. Later publication, Order/payment, distribution and production actions retain their own exact relevant evidence | Reuse existing immutable FUND configuration and Commerce evidence; never substitute a mutable current Product record for a historic confirmed fact. Later milestones are not implemented by Pass 2 |
| 7. Minimum next outcome | Propose the Section 4.2 steps 1–5: C1 configuration through C2 selection/finalisation to a matching authenticated document download and Store preview, with the essential controls in Section 6 | Public Store, trading, payment, physical distribution and downstream operations remain later. Confirm the practical usefulness of this stopping point before selecting its bounded plan |

Decisions needed by the selected behaviour must be resolved before its implementation plan
is accepted. A deliberate deferral must state the blocked action; it cannot leave a newly
enabled workflow without defined authority, evidence or recovery.

## 9. Using This Framework In Delivery

Use this document for the lasting user journey, ownership, accepted Phase 1 scope and
proportionality rules. Use the [B1 development plan](../03-slice-planning/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md)
for the current exact outcome, change boundary, business assumptions and acceptance tests.
Root and FUND roadmaps alone select Now/Next. The active B1 plan holds the single restart
checkpoint; this framework carries no independent delivery status or implementation gate.

Section 8 recommendations remain proposals where not explicitly accepted. Their meaning
must be resolved in the bounded plan that needs them. Appendix A remains unaccepted design
evidence and must never be mistaken for the default implementation specification.

## Appendix A — Unaccepted Detailed Schema Option / Technical Design Evidence

The material below is preserved from the earlier schema-first draft. It has not been
accepted as the current implementation direction. Model names, field sets, constraints,
migration sequencing and validation ideas may inform a later vertical plan only where the
accepted business journey proves them necessary.

### A.1 Bounded Schema Vocabulary

Add only the following enums:

```text
FundApplicationTemplateVersionStatus
- DRAFT
- ACTIVE
- ARCHIVED

FundApplicationTemplateOrientation
- PORTRAIT
- LANDSCAPE

FundApplicationTemplateRowDensity
- STANDARD
- COMPACT

FundApplicationTemplateAssignmentScope
- EVENT
- STANDALONE_DEFAULT
- STANDALONE_PROJECT

FundArtworkTemplateGenerationAttemptStatus
- REQUESTED
- RUNNING
- SUCCEEDED
- FAILED
- CANCELLED

FundArtworkTemplateGrantIssuerType
- C1_TENANT_USER
- SYSTEM
```

Do not encode Project type, Workflow Class, Store, Order, payment or delivery states again
inside these enums. Those remain owned by their existing aggregates.

### A.2 Planned Models And Contracts

Common rules for every planned table:

- expose a unique `(organizationId, id)` key and include `organizationId` in every domain
  foreign key, including references to public-schema `User`;
- use restrictive deletion for version, assignment, offer, Store/Product, attempt, grant
  and actor evidence; tenant deletion remains governed by the existing Organization
  lifecycle rather than a new FUND shortcut;
- use explicit named foreign keys, checks, unique indexes and operational lookup indexes;
- keep metadata out unless a named bounded contract genuinely requires it; and
- follow the current FUND tenant-security posture without widening database roles or
  bypassing application tenant filters. Any future row-level-security change requires its
  own explicit review rather than being inferred here.

#### A.2.1 `FundApplicationTemplate`

Stable tenant-owned reusable template identity:

```text
id, organizationId, code, name, description?
currentVersionId?
archivedAt?, archivedById?, archivedReason?
createdById, updatedById, createdAt, updatedAt
```

Required constraints:

- unique `(organizationId, id)` and `(organizationId, code)`;
- nonblank code/name and nonblank archive reason when archived;
- current-version pointer may reference only a version of this same tenant and template;
- no hard delete after a version, assignment or offer lock refers to the identity; and
- actor relations use exact `(organizationId, User.id)` ownership.

The stable identity does not contain layout JSON or capacity. Those belong to a version.

#### A.2.2 `FundApplicationTemplateVersion`

Versioned design and validation contract:

```text
id, organizationId, applicationTemplateId, version, status
orientation, rowDensity
pageWidthMm, pageHeightMm
safePrintTopMm, safePrintRightMm, safePrintBottomMm, safePrintLeftMm
validatedGridCapacity, maximumSelectedProjectProducts
definitionSchemaVersion, definitionSnapshot, definitionHash
rendererContractVersion, rendererContractHash, fontPackHash
validatedAt, validationEvidenceId
activatedAt?, activatedById?, archivedAt?, archivedById?, archivedReason?
createdById, createdAt
```

Required constraints:

- unique `(organizationId, applicationTemplateId, version)` with positive version;
- positive A4 dimensions and nonnegative safe-print insets that leave a positive content
  area;
- `validatedGridCapacity >= 1` and
  `1 <= maximumSelectedProjectProducts <= validatedGridCapacity`;
- supported initial proof pairs are `PORTRAIT/STANDARD <= 10` and
  `LANDSCAPE/COMPACT <= 12`; a different pair/capacity requires separately accepted proof,
  not a silent schema entry;
- definition snapshot must be a JSON object governed by a positive schema version;
- definition, renderer and font hashes are lowercase SHA-256 values;
- validation evidence is a bounded internal lifecycle/commit identifier, not a URL,
  filesystem path or provider object key;
- the declarative definition may identify controlled layout elements and stored media
  identities, but never executable HTML/JavaScript, arbitrary CSS, filesystem paths,
  database connection strings, provider credentials or externally fetched runtime assets;
- only one `ACTIVE` version per template, enforced by a partial unique index;
- activation requires validation evidence, timestamps and exact tenant actor;
- substantive fields become immutable on activation; only the accepted archive lifecycle
  fields may then change; and
- current-pointer selection and activation occur in one transaction and must point to the
  same template's `ACTIVE` version.

No migration seeds an AMOW template. Creating and validating a real tenant template is
later C1 lifecycle work under `1R-F-C`.

#### A.2.3 `FundApplicationTemplateAssignment`

Append-only assignment history with one active assignment per applicable scope:

```text
id, organizationId, scope
applicationTemplateId
eventId?, projectId?
assignedAt, assignedById
retiredAt?, retiredById?, retiredReason?
createdAt
```

Required database shape checks:

```text
EVENT              -> eventId present, projectId absent
STANDALONE_DEFAULT -> eventId absent,  projectId absent
STANDALONE_PROJECT -> eventId absent,  projectId present
```

Required constraints and indexes:

- template, Event, Project and actor references are tenant-exact;
- partial unique indexes allow only one unretired Event assignment per Event, one unretired
  standalone default per tenant and one unretired Project assignment per Project;
- retired evidence is complete and its reason is nonblank;
- history cannot be hard deleted; and
- later `1R-F-C` services must reject a Project assignment unless `eventId IS NULL` and
  must reject standalone resolution for an Event-linked Project. The database cannot infer
  this changing Project fact through a row-local check.

Assignments point to template identity so a Project follows the identity's active version
until finalisation. They never point directly to a draft version.

#### A.2.4 `FundIndividualArtworkOffer`

Stable one-per-Project Individual Artwork offer identity:

```text
id, organizationId, projectId
currentVersionId?
createdById, createdAt
```

Required constraints:

- unique `(organizationId, projectId)`;
- exact tenant Project relation;
- current pointer may select only a version of this same offer and Project; and
- later services create/use it only for `ARTWORK_FUNDRAISING`; schema presence alone does
  not change Project type or make a Project ready.

#### A.2.5 `FundIndividualArtworkOfferVersion`

Append-only finalisation/lock record:

```text
id, organizationId, offerId, projectId, storeId, version
applicationTemplateVersionId
supersedesVersionId?
selectedProductCount
canonicalStoreUrlSnapshot
projectContentSchemaVersion, projectContentSnapshot
brandingSchemaVersion, brandingSnapshot
rendererInputSchemaVersion, rendererInputSnapshot
offerLockHash
finalisedByClientMemberId, clientId, finalisedAt, createdAt
```

Required constraints:

- unique `(organizationId, offerId, version)` with positive version;
- offer, Project and Store form one exact tenant/Project chain;
- finalising member belongs to the Project's exact Client; later `1R-F-D` additionally
  proves that member is the Project's current exact organiser and is active/authorised;
- Application Template Version is the exact active version resolved through accepted
  assignment authority at the start of the finalisation transaction;
- `selectedProductCount >= 1` and does not exceed that template version's configured
  maximum, enforced transactionally by `1R-F-D` because it crosses rows;
- snapshot JSON values are objects with positive schema versions;
- canonical URL is nonblank, normalised and derived from the Store's existing public
  identity by the later service, never accepted as arbitrary user input;
- `offerLockHash` is lowercase SHA-256 over the canonical complete lock payload;
- supersession points only to an older version of the same offer; and
- finalised rows are append-only and cannot be updated or deleted through ordinary
  application authority.

This record pins resolved display/branding/renderer input but does not duplicate mutable
Store or configuration rows. The foreign-keyed Product rows below retain exact source
lineage.

#### A.2.6 `FundIndividualArtworkOfferProduct`

One printable Product row in one exact offer version:

```text
id, organizationId, offerVersionId
storeProductId, projectProductId, productId
configurationVersionId
sortOrder
displayLabelSnapshot
grossUnitPriceSnapshot, currencySnapshot
createdAt
```

Required constraints:

- exact tenant relations prove that Store Product belongs to the offer's Store/Project and
  the immutable configuration version belongs to that exact Store Product;
- unique Product membership and unique `sortOrder` within an offer version;
- nonnegative contiguous ordering is enforced by the finalisation service;
- nonblank label, nonnegative gross price and ISO three-letter uppercase currency;
- row count equals the parent `selectedProductCount` and respects the pinned template
  capacity in the same finalisation transaction; and
- rows are append-only with their parent version.

The gross amount is the exact purchaser-facing printable amount resolved from the pinned
configuration. This does not replace the configuration's net/VAT/basis authority and does
not create Order or payment evidence.

#### A.2.7 `FundArtworkTemplate`

Stable Project-specific generated-document identity:

```text
id, organizationId, offerId, projectId
currentVersionId?
createdAt
```

Required constraints:

- unique `(organizationId, offerId)` and `(organizationId, projectId)`;
- exact tenant offer/Project chain; and
- current pointer may select only a generated version of this same Artwork Template and
  Project.

This aggregate is not `FundProductionAsset` and its presence does not imply that a PDF was
stored or delivered.

#### A.2.8 `FundArtworkTemplateGenerationAttempt`

Append-only request identity with tightly controlled execution-state adjudication:

```text
id, organizationId, artworkTemplateId, offerVersionId, attemptNumber
idempotencyKey, requestHash, status
requestedByClientMemberId, requestedAt
startedAt?, finishedAt?
failureCode?, redactedFailureSummary?
createdAt, adjudicationUpdatedAt
```

Required constraints:

- exact tenant Artwork Template, offer version and requesting Client member lineage;
- unique `(organizationId, artworkTemplateId, attemptNumber)` and tenant-scoped
  `idempotencyKey`;
- positive attempt number, bounded idempotency key and lowercase SHA-256 request hash;
- `REQUESTED`, `RUNNING` and terminal timestamp shapes are database checked;
- `FAILED` requires a bounded nonblank code and redacted summary, while success cannot
  retain failure detail;
- ordinary updates may change only the accepted state/timestamp/failure adjudication
  fields; request identity and hashes are immutable; and
- no Render job, object-store key, provider request, credential or machine identity is
  stored here.

`1R-F-E` later owns the worker, retry policy, concurrency and operational implementation.

#### A.2.9 `FundArtworkTemplateVersion`

Immutable evidence for one successful generated document:

```text
id, organizationId, artworkTemplateId, offerVersionId, generationAttemptId, version
pdfSha256, byteSize, pageCount
pageWidthMm, pageHeightMm
rendererContractHash, generatedAt, createdAt
```

Required constraints:

- unique `(organizationId, artworkTemplateId, version)` with positive version;
- one generation attempt can create at most one version and must belong to the same
  Artwork Template/offer version;
- later service permits creation only from a `SUCCEEDED` attempt;
- PDF hash and renderer hash are lowercase SHA-256, byte size/page count are positive and
  physical dimensions match the pinned A4 contract; and
- generated version rows are append-only and cannot be hard deleted through ordinary
  application authority.

No provider/object location is included. `1R-F-E` must separately plan private managed
storage, checksum-to-object binding, retention, deletion and recovery before a generated
version can be operationally delivered.

#### A.2.10 `FundArtworkTemplateAccessGrant`

Revocable, expiring evidence that targets one exact generated version and organiser:

```text
id, organizationId, artworkTemplateVersionId
clientId, recipientClientMemberId
tokenDigest
issuerType, issuedByUserId?, issuedAt, expiresAt
revokedAt?, revokedByUserId?, revocationReason?
createdAt, adjudicationUpdatedAt
```

Required constraints:

- exact tenant Artwork Template Version, Client member and optional User actors;
- globally unique lowercase SHA-256 token digest for lookup without tenant ambiguity;
- raw bearer token is never stored, logged, committed or placed in lifecycle evidence;
- `C1_TENANT_USER` requires an exact tenant issuer; `SYSTEM` requires no issuer User;
- expiry is after issue; revocation fields are all absent or complete with a nonblank
  reason; and
- grant identity, recipient, version and digest are immutable; only revocation
  adjudication may change.

This is schema support, not a working link. `1R-F-E` owns token entropy, fixed-time digest
comparison, expiry/reissue policy, authorised download, access logging, email/resend,
retention and rate limiting. No public bucket or permanent object URL is authorised.

### A.3 Transaction, Immutability And Authority Options

Later service implementation must use bounded transactions for:

1. retiring and replacing one active assignment;
2. activating a validated Application Template Version and changing its same-template
   current pointer;
3. resolving Event/standalone assignment, current version, exact organiser, Store,
   selected Product rows and configuration versions, then inserting the complete offer
   version/Product lock and changing its current pointer atomically; and
4. recording a successful attempt, immutable Artwork Template Version and same-template
   current pointer without duplicate output.

Optimistic checks must fail closed when any resolved Project, assignment, template, Store,
Product configuration or organiser authority changes during finalisation. A retry must
re-resolve authority; it must not silently reuse stale input.

Unlock behaviour is deliberately not modelled as a mutable `locked` boolean. `1R-F-D`
must plan the exact append-only unlock decision evidence after it can bind the accepted
rules for Store publication/trading, paid Orders and recorded physical distribution. A
permitted unlock creates a full superseding offer version after refinalisation; it never
edits historic offer/Product/Artwork versions or Commerce Order evidence.

### A.4 Migration Option If Separately Authorised By A Later Vertical Plan

The earlier implementation option was one additive migration after the then-current
153-directory baseline. Any later selected vertical plan must re-inspect the current
baseline, prove that its required persistence belongs in that journey and define its own
migration boundary rather than assuming this option or ordinal 154.

Required sequence under `SAFE_DATABASE_WORKFLOW.md`:

1. identify repository, branch, exact commit and dirty state; preserve unrelated changes;
2. prove `TEST_DATABASE_URL` exists and is not equal to `DATABASE_URL`, and positively
   identify the disposable target before any reset/drop/rollback action;
3. inspect migration ledger and failed-migration state;
4. add Prisma enums/models/reverse relations and one reviewed SQL migration;
5. add named checks, partial unique indexes, exact tenant foreign keys and narrowly scoped
   immutability triggers that Prisma cannot express;
6. run static schema/migration contract verification;
7. run representative existing-data 153-to-candidate migration proof, preserving exact
   pre-existing row counts and values;
8. run a full fresh migration replay and all negative/concurrency/rollback tests;
9. remove test fixtures and prove zero residue; and
10. stop with no shared database migration, deployment or promotion.

The migration must not backfill, reinterpret or update an existing FUND, Commerce, public
or other-module row. New tables begin empty. Reverse relations and supporting composite
keys may be added only where an exact foreign key requires them and may not alter owning
aggregate behaviour.

### A.5 High-Control Validation Option

#### A.5.1 Static and migration checks

- `prisma format`, `prisma validate`, client generation, TypeScript validation and the
  production build pass;
- a dedicated 1R-F-B schema verifier asserts the exact model/table/enum/constraint set and
  rejects forbidden provider, Order/payment, production and public-link fields;
- the migration contains only the reviewed additive FUND scope and necessary reverse
  relations/supporting keys;
- both representative upgrade and full fresh replay finish with a clean migration ledger;
  and
- rollback-before-evidence is proved on a disposable database only.

#### A.5.2 Candidate positive proofs

- create both proven template-version variants with maximums at their accepted ceilings;
- activate one version and select it through Event, standalone-default and exact
  standalone-Project assignment resolution fixtures;
- create a ten-row portrait and twelve-row landscape offer lock from exact Store Product
  configuration versions;
- create a generation attempt, successful immutable document version and expiring grant
  to the exact organiser; and
- prove historic version and Product lineage remains readable after a new template/offer/
  artwork version becomes current.

#### A.5.3 Candidate negative and failure proofs

- reject cross-tenant template, Event, Project, Store, Product, member and User references;
- reject invalid polymorphic assignment shapes, two active assignments for one scope and a
  direct assignment to a version;
- reject zero capacity, maximum above validated capacity, unsupported unproved variant,
  malformed/non-object JSON and malformed hashes;
- reject a current pointer to another aggregate, simultaneous duplicate version numbers
  and two active versions;
- reject empty offer, over-capacity offer, duplicate/missing Product order, cross-Project
  Store Product and configuration version from another Store Product;
- reject a non-organiser/inactive/wrong-Client finaliser through later service proof;
- reject ordinary update/delete of activated template contract, offer version/Product and
  Artwork Template Version;
- reject duplicate generation idempotency, illegal status/timestamp transitions,
  unredacted or overlong failure evidence and version creation from a non-success attempt;
- reject plaintext/malformed/duplicate grant token material, wrong-member version access,
  expired/revoked grants and incomplete revoke evidence; and
- inject a transaction failure before each current-pointer change and prove no partial
  assignment, offer/Product lock, attempt/version or grant residue.

#### A.5.4 Existing behaviour and human gates

Focused schema tests must be followed by the relevant existing FUND Store, readiness,
Commerce A7, full automated, lint, type, migration-integrity and build gates. The migration
must not change existing Store readiness or Order behaviour.

No end-user UI is authorised by the current strategic `1R-F-B`, so no C1/C2 browser
acceptance is claimed. If a later vertical plan reuses this option, its human gates include:

1. control-owner review/acceptance of that later vertical plan before implementation;
2. later review of the exact Prisma/migration diff, table meanings and rollback report;
   and
3. separate human UI/physical acceptance in the owning C/D/E children when behaviour is
   actually introduced.

### A.6 Recovery, Redundancy And Operational Ownership Option

The future records are ordinary tenant-scoped production database records protected by the
application database backup/recovery model, not by a developer's Mac, Keychain or a
temporary external test resource. Git retains schema/migration/application definitions;
database backups retain production data. Neither is a substitute for the other.

Operational owner: FUND application/C1 domain for template and offer authority. There is
no worker or provider owner in this slice. `1R-F-E` must name the operational owner,
credential custody, private storage, backup/recovery and observability model before any
generated file delivery exists.

Rollback boundary:

- before shared use and while candidate tables are empty, the disposable migration may be
  rolled back and replayed;
- after persistent records exist, do not drop or rewrite the tables as routine rollback;
  stop writes, preserve evidence, restore from verified database backup if required and
  use a reviewed forward correction; and
- no production rollback, restore or provider action is authorised by this plan.

### A.7 Preserved Technical Do Not Build Boundary

This plan and any later narrowly accepted schema implementation exclude:

- C1 template CRUD, activation editor, visual editor or assignment UI (`1R-F-C`);
- C2 selection, preview, finalisation, unlock or readiness behaviour (`1R-F-D`);
- renderer worker, queue/cron, retry runtime, Render service or recurring service cost;
- R2/S3 bucket, object key, credentials, signed URL, public-development URL or production
  storage contract (`1R-F-E`);
- organiser email, resend, download route, link policy, access log, retention/deletion or
  physical distribution confirmation (`1R-F-E`);
- Store publication/trading, checkout, Order, payment, refund, production authority,
  commission or Store Order Code behaviour;
- Product option/price-modifier display policy not yet accepted by its owning later slice;
- collective Group/Bulk artwork, Standard path or `1R-F-F` through `1R-F-I`;
- public Store `1R-G`, production/fulfilment work or any other roadmap outcome; and
- shared development, staging or production migration/deployment/promotion.

### A.8 Historical Technical Option Assessment

If a later selected vertical plan reuses this option, it must reassess whether it
truthfully demonstrates:

1. exact reuse of current tenant/Project/Store/Product configuration authority;
2. separate reusable template, offer lock and generated-document aggregates;
3. exact version/current-pointer, assignment, finaliser and Product lineage;
4. secure-grant evidence without plaintext secret or storage/provider invention;
5. High-depth failure, negative, rollback and concurrency boundaries;
6. a safe 153-to-candidate disposable migration route; and
7. explicit exclusion of all C/D/E behaviour and production infrastructure.

This checklist does not constitute acceptance of the ten-model proposal and does not make
a separate `1R-F-B` schema implementation the default next decision. Root `Next` remains
unselected while the strategic review is open. A later vertical plan may reuse, reduce or
defer these technical ideas only after the business journey and persistence need are
accepted.
