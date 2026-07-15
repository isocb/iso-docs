# IsoStack Commerce Core Slice COMMERCE-A7 — FUND Consumer Integration Implementation Planning

Date: 2026-07-15

Status: Implemented and reviewed as passed; dormant internal boundary only

Root control:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

Commerce control:

`docs/core/commerce/00-roadmap-control/2026-07-13-commerce-core-roadmap-and-slice-control.md`

FUND control:

`docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

Strategic completion view:

`docs/modules/fund/00-roadmap-control/2026-07-15-fund-store-artwork-orders-and-production-strategic-completion-roadmap.md`

## 1. Goal

Implement the first thin, transactional consumer boundary between an authoritative ready
FUND Project Store offer and generic Commerce Order/payment infrastructure.

The bounded outcome is:

```text
validated published/open FUND Store submission
-> one immutable Commerce Checkout/Order/line/STRIPE_ONLINE Payment aggregate
-> exact typed FUND Order/line/input/asset context in the same local transaction
-> existing A6-C connected-account Checkout invocation after commit
-> existing A6-D verified webhook/refund authority remains unchanged
```

A7 must prove that FUND can consume generic Commerce without moving FUND Store,
personalisation, artwork, production, fulfilment or commission behavior into Commerce.

## 2. Entry Baseline

Planning is based on:

- application `dev` at local commit `fa670e3c`;
- Commerce A1-A5 and A6-A through A6-D implemented/reviewed;
- FUND C1-C6 and Store 1R-D implemented/reviewed;
- the complete unchanged 140-migration Prisma/PostgreSQL baseline;
- no shared Stripe Connect secret/Event destination or real provider action;
- no staging/production deployment claimed; and
- IsoDocs control commit `f67e4f0` registering the strategic completion view and three
  governed CR inputs.

The current schema already contains Checkout, Order, line, Payment, A4 idempotency/audit
and typed FUND context/snapshot models. A7 should add no Prisma model, field, enum, index,
constraint or migration. If review discovers that the accepted transaction cannot be made
safe with the current persistence contract, stop and return to schema planning.

## 3. Ownership Boundary

### 3.1 Generic Commerce owns

- Checkout submission lifecycle;
- legal seller and purchaser/contact snapshots;
- Order number, Order and Order lines;
- net/tax/gross arithmetic in integer minor units;
- `STRIPE_ONLINE` Payment evidence;
- A4 idempotency and append-only Commerce audit;
- the A6-C provider Checkout invocation; and
- A6-D Payment/refund reconciliation.

The generic Commerce submission helper accepts an immutable consumer contract. It imports
no FUND model, enum, service or vocabulary.

### 3.2 FUND owns

- public Store/Project/Store Product authority;
- exact current configuration-version validation;
- Product/workflow/input/asset interpretation;
- typed `FundOrderContext`, `FundOrderLineContext`, input and asset snapshots;
- Project-organiser delivery evidence;
- provisional commission-assignment observation; and
- later production/fulfilment behavior.

The FUND adapter may call generic Commerce services. Generic Commerce must never call into
FUND or create FUND records by opaque ID inference.

## 4. Bounded Delivery Scope

Implement only dormant internal services and tests for:

1. canonical FUND online-order submission normalization and hashing;
2. same-tenant Store/Project/Store Product/configuration locking and revalidation;
3. generic Commerce atomic Checkout/Order/line/PENDING Payment creation;
4. typed FUND Order/line/input/asset snapshots in that same transaction;
5. local submission idempotency and concurrent convergence;
6. post-commit A6-C Checkout creation/replay through injected fakeable providers;
7. safe replay/status outcomes when provider payment evidence has advanced; and
8. explicit creation of a later online Payment attempt against the same immutable Order
   after a failed/cancelled attempt, while the local Checkout capability remains valid.

The existing user-facing Product-eligibility service accepts a `FundActor`. A7 must not
invent a C1/C2 User for a guest. Extract or reuse a read-only tenant-scoped internal
eligibility evaluator whose authority is the already resolved Store/Project tenant. The
existing authenticated service continues to apply its actor boundary around that shared
evaluator.

A7 adds no public or C1 router, Store page, basket UI, return/cancel page, email,
notification or real provider configuration. Later public Store/consumer slices invoke the
reviewed internal boundary.

## 5. Internal Submission Contract

The trusted later public Store route should eventually call A7 with a bounded contract
equivalent to:

```text
storePublicId
submissionToken
purchaserName
purchaserEmail
purchaserPhone?
lines[]:
  clientLineKey
  storeProductId
  quantity
  inputValues keyed by definition code
  selectedChoiceCodes keyed by definition code
  uploadedAssetVersionIds[]
```

Rules:

- no purchaser IsoStack account is required;
- the public Store identity determines tenant/Project scope; the caller supplies no trusted
  `organizationId`, Project ID, Product ID, price, tax, configuration hash or total;
- `submissionToken` is a cryptographically random high-entropy capability generated by the
  future consumer surface;
- two separately domain-separated SHA-256 values are derived server-side: one persisted as
  the A4 submission key and one as `CommerceCheckoutSession.publicTokenHash`; the raw token
  is never an A4 key or database value;
- raw submission tokens never enter logs, audit metadata or persisted response bodies;
- `clientLineKey` distinguishes separately personalised lines using the same Store Product;
- identical units with identical inputs may use quantity greater than one;
- differently personalised units require separate lines;
- duplicate line keys, unknown input codes, unknown choices, unsupported values and
  unreferenced asset versions are rejected;
- the proposed technical ceiling for review is 100 lines and 10,000 units per line, subject
  to the existing Commerce minor-unit maximum and total reconciliation; this is an abuse
  ceiling, not stock policy; and
- purchaser billing/delivery addresses are not collected in A7 because first-pass
  fulfilment is Project bulk delivery to the Project organiser.

## 6. Store And Offer Authority

Inside one SERIALIZABLE transaction, acquire locks in stable order over:

1. tenant plus submission-token hash;
2. Store and Project;
3. selected Store Products ordered by ID;
4. current configuration versions ordered by ID;
5. Seller Profile, Project delivery and accepted commission assignment; and
6. any submitted/linked Production Asset versions ordered by ID.

At the one server evaluation instant require:

- non-enumerable `FundProjectStore.publicId` resolves one tenant and Store;
- Store is exactly `PUBLISHED`, unarchived and not manually closed/paused;
- Project is ACTIVE, unarchived and `opensAt <= now < closesAt` under its accepted timezone
  contract;
- every submitted Store Product belongs to that exact Store/Project, is visible, eligible,
  unarchived and `READY` with no readiness reasons;
- every Store Product has the exact current immutable configuration version supplied only
  by the database;
- configuration source Product revision, Project Product timestamp, workflow identity and
  configuration hash remain coherent with current source evidence;
- current Product/Project Product/Workflow records have not become inactive or ineligible;
- required linked Project/presentation assets remain available, unrestricted, undeleted,
  clean and on the approved/not-required reviewed version;
- Project delivery profile remains complete and same-tenant;
- one current accepted commission assignment belongs to the exact Project/Store and still
  snapshots the current Project close; and
- the Commerce Seller Profile is ACTIVE, complete and uses the Store currency.

A7 must not refresh/reconfigure the Store or create a new configuration version during
guest submission. Stale authority returns a stable non-public diagnostic code for the
later Store surface; it never silently reprices or heals the offer.

The current configuration hash pins logical required/presentation asset IDs, not their
later mutable `currentVersionId` pointers. A7 therefore loads, validates and snapshots the
exact current clean/reviewed asset version at the submission instant. It must not claim
that the existing configuration hash pins an asset version. Workflows that require an
offer-level immutable artwork-version release remain dormant until their later governed
Template/collective-artwork slice extends the Store release contract.

## 7. Input And Asset Resolution

Parse only schema-version-1 `inputContractSnapshot` from the exact Store Product
configuration version.

For each resolved definition:

- accept only the control's canonical value shape;
- enforce customer visibility, required/default state, validation configuration and active
  choice membership from the immutable snapshot;
- support short/long text, number, date, yes/no, email, phone, single-select,
  multi-select, colour-swatch and file-upload contracts already represented by C1/C6;
- retain every selected choice for `MULTI_SELECT` in deterministic snapshot order;
- sum signed selected-choice price modifiers exactly once per unit;
- snapshot omitted optional definitions explicitly;
- reject missing customer-visible required definitions by default; and
- do not implement dependent-option graphs or infer values from Product names/free text.

Every snapshot must also resolve the exact same-tenant live
`FundOrderInputDefinition` required by the existing C6 foreign key and verify that its
owner, code, kind, control, revision and configuration evidence match the immutable
contract. Customer-hidden required definitions are never requested from a purchaser: they
must resolve from an authoritative accepted default or Project-level value, otherwise the
offer is internally stale and submission blocks.

`ALLOW_WITH_DISCLAIMER` remains unavailable until its C1 setting, wording and purchaser
acknowledgement evidence have an accepted persistence/service contract. A7 therefore uses
the already accepted safe default: missing required purchaser input or upload blocks
submission.

A7 creates no upload or scanning behavior. When a later upload service supplies existing
asset-version IDs, A7 must require exact tenant/asset/version ownership and reject infected,
restricted or deleted evidence. Public artwork-backup evidence must use purpose
`ORDER_LINE_ARTWORK_BACKUP` and uploader type `PUBLIC_PURCHASER`; it is snapshotted as
`PURCHASER_ARTWORK_BACKUP`. The photograph is a conditional production backstop, not proof
of physical-original receipt or production authorisation.

For a `FILE_UPLOAD` input, `submittedValueSnapshot` records the ordered accepted asset-
version IDs and the matching C6 asset snapshot rows carry immutable file evidence. This
explicit association prevents an uploaded file from satisfying an unrelated file input.

Required Project and Store Product production/presentation versions used by the accepted
configuration are snapshotted with their exact immutable versions and appropriate C6
roles. Multiple files create multiple snapshot rows.

## 8. Price, Tax And Order Arithmetic

`FundProduct.unitPriceNet` and every C1-C3 snapshot remain normalized tax-exclusive Decimal
amounts regardless of `priceEntryBasis`; C1-C1 established that semantic explicitly.

A7 converts authoritative Decimal net values to currency minor units without floating-
point arithmetic and requires no fractional minor-unit residue. For each line:

```text
unitBaseNetMinor     = normalized configuration net price
unitModifierNetMinor = sum of selected signed choice modifiers
unitNetMinor          = unitBaseNetMinor + unitModifierNetMinor
lineNetMinor          = unitNetMinor * quantity - lineDiscountMinor
lineTaxMinor          = HALF_UP(lineNetMinor * appliedTaxRateBps / 10,000)
lineGrossMinor        = lineNetMinor + lineTaxMinor
```

First-pass discount and delivery amounts are zero. Unit display gross is calculated for
display evidence; line-level HALF_UP tax remains the accounting authority.

Tax mapping is exact:

- `STANDARD` uses the active Seller Profile standard rate;
- `REDUCED` uses the active Seller Profile reduced rate;
- `ZERO_RATED` and `EXEMPT` use zero; and
- `UNCLASSIFIED`, missing rates, Store/Seller currency mismatch or Store VAT evidence that
  disagrees with the applicable Seller rate blocks submission.

Map FUND tax treatment and price-entry-basis enums explicitly to Commerce equivalents.
Do not rely on matching enum ordinals or unchecked string casts.

Order totals are the checked sum of persisted line calculations. A7 calls A5 arithmetic
validation before any write and relies on existing PostgreSQL checks as a second boundary.
Negative unit/line amounts, fractional minor-unit residue, integer overflow and totals
outside the existing Commerce bounds block submission.

## 9. Generic Commerce Atomic Submission

Add a consumer-neutral helper under the Commerce module that accepts a transaction client
and one already validated immutable submission. Within the caller's transaction it:

1. receives an already claimed generic A4 operation context and an opaque generic source
   contract from the FUND adapter;
2. creates one `CommerceCheckoutSession`, initially OPEN;
3. creates one `CommerceOrder` and ordered lines using only supplied immutable snapshots;
4. creates one `STRIPE_ONLINE` PENDING `CommercePayment` with provider code `STRIPE`;
5. changes the Checkout to SUBMITTED with the same submission timestamp; and
6. emits a redacted generic Commerce audit event linked to the supplied operation.

The FUND adapter—not generic Commerce—claims/replays `FUND.ORDER.SUBMIT`, owns its
canonical request hash and supplies the resulting operation context. Generic Commerce must
not hard-code a FUND scope or import FUND vocabulary. The caller completes that A4 record
only after both Commerce and FUND evidence have been written successfully.

The proposed first-pass local Checkout lifetime is 60 minutes from accepted Order
submission. Order creation must occur before Project close, but a provider payment already
initiated for that accepted Order may complete after Project close; the close boundary
prevents new Orders rather than rewriting an existing payment attempt. The 60-minute
capability supplies A6-C's minimum provider window without extending Store trading.

Use exact generic source vocabulary:

```text
Checkout/Order:
  sourceModuleCode = FUND
  sourceEntityType = PROJECT_STORE
  sourceEntityId   = FundProjectStore.id

Order line:
  sourceItemType = FUND_PROJECT_STORE_PRODUCT
  sourceItemId   = FundProjectStoreProduct.id
```

The Checkout source configuration fingerprint is a versioned SHA-256 digest over the exact
Store, publication evidence, Project trading window and ordered configuration-version IDs
and hashes. Each Order line stores the exact configuration version ID/version and existing
configuration hash.

`configurationSnapshot` contains only safe resolved commercial/choice evidence needed to
explain price. Sensitive purchaser text and file identities remain typed FUND snapshots.
`displaySnapshot` contains immutable receipt-safe Product/Store display evidence.

The generic internal Order number is deterministic from the Checkout identity and is not
the future purchaser-facing five-digit FUND Order Code. A7 must not decide or generate that
later Order Code.

## 10. FUND Context In The Same Transaction

Before committing local submission, create exactly:

- one `FundOrderContext` for the new Commerce Order;
- one `FundOrderLineContext` per Commerce line;
- one `FundOrderLineInputSnapshot` per resolved definition; and
- zero or more `FundOrderLineAssetSnapshot` rows per line.

Populate C6 evidence from exact locked authority:

- Project, Store, Client, Event and Project type/name/number snapshots;
- current Project-organiser delivery profile and structured address/contact snapshots;
- current accepted commission assignment as provisional observation only;
- Store Product, Project Product, Product, workflow and configuration version/hash;
- typed input definition/value/choice/modifier evidence;
- immutable asset/version/scan/review/availability evidence;
- initial production `NOT_READY`, fulfilment `PENDING` and appropriate line artwork
  readiness/projection states.

The commission observation does not lock a rate or calculate commission. Payment remains
separate from physical artwork, production and fulfilment authority.

Any failure creating Commerce or FUND evidence rolls back Checkout, Order, lines, Payment,
contexts, snapshots, A4 state and audit together.

After the last FUND context/audit write, the FUND adapter completes the already claimed A4
record in the same transaction with stable Checkout, Order and Payment identifiers only.
Exact completed replay is resolved by the FUND adapter without re-entering row creation.

## 11. Provider Invocation And Retry

After the local transaction commits, call the existing A6-C
`createOrReplayConnectedAccountCheckout` with actor type `GUEST` and injected Account and
Checkout providers.

- never hold a database transaction across a provider call;
- pass only the new Payment ID and exact tenant resolved internally;
- return the transient hosted HTTPS URL only to the trusted immediate caller;
- never persist/audit/log the hosted URL, purchaser email, submission token, provider body,
  secret, client secret, payment method or card data;
- provider unavailability leaves one durable PENDING Order/Payment/FUND context that exact
  replay may safely resume;
- A6-C/A4 Payment-key idempotency prevents duplicate Stripe Sessions;
- browser return remains advisory and A6-D verified events alone advance Payment/refund
  money state; and
- paid/refunded state does not mutate FUND production/fulfilment/artwork state.

For a failed or cancelled online attempt, a separate high-entropy `paymentAttemptToken`
may create one new PENDING Stripe Payment on the same immutable Order only while the local
Checkout capability remains unexpired and Store/Project still permit a new attempt. The
FUND adapter owns the separate attempt A4 scope/hash, lock and audit event. Retry validates
the same tenant, Checkout capability, published/unpaused Store, open Project window,
immutable Order/FUND context integrity, Seller and connected-account readiness. It does
not reprice or compare the immutable Order against later mutable Product/configuration
content. It never changes Order lines, FUND snapshots, amount or currency.

Payment replay behavior is monotonic:

- PENDING invokes/replays A6-C;
- PAID/PARTIALLY_REFUNDED/REFUNDED returns a safe current-status result with no provider
  creation;
- FAILED/CANCELLED requires an explicit new attempt token;
- conflicting provider references or arithmetic quarantine the operation; and
- an expired local Checkout accepts no new attempt.

## 12. Public Surface Boundary

A7 is an internal integration slice. It adds no public Store, basket, submission route,
authenticated C2 route, C1 route or purchaser UI.

The A6-C fixed return/cancel paths remain reserved. A later consumer-order surface must add
capability-protected, data-minimised advisory pages that query only server-side state and
never treat the browser or `stripe_session_id` as payment authority. That later route must
use the hashed Checkout capability established by A7 rather than exposing status by raw
Order/Payment IDs.

This refinement preserves the newer strategic sequence: A7 proves the internal transaction
spine; 1R-E and 1R-F build C1/public Store surfaces; the later consumer-completion slice
adds Order Code, status pages and communications.

## 13. Security, Privacy And Audit

- Resolve tenant from the Store public ID; never trust tenant input from a guest.
- Return indistinguishable not-found/unavailable results at a future public boundary.
- Normalize and length-limit purchaser fields; store only accepted Order evidence.
- Do not place purchaser identity, submitted input values, asset IDs or raw capability
  tokens in Commerce/FUND audit metadata.
- Hash purchaser email only where needed for idempotency comparison; do not log the hash as
  an identifier.
- Keep sensitive typed input and file evidence out of generic Commerce snapshots where it
  is not required for receipt/arithmetic meaning.
- Use stable advisory-lock ordering to avoid deadlocks and same-token/different-token
  duplicate races.
- Emit generic Commerce submission/payment-attempt events and one FUND context-creation
  audit event in the same transaction as their owned evidence.
- Preserve restrictive deletion and immutable historical evidence from A1-C6.

## 14. Explicit Exclusions

A7 adds no:

- Prisma schema or migration;
- public Store browsing, basket, checkout route or Store UI;
- C1 Store-management or C2 dashboard UI;
- Product, Catalogue, Store or configuration editing;
- Application/Artwork Template manager, renderer or PDF generation;
- collective Project artwork composition, approval or Product-release behavior;
- upload/download/storage/malware-scanning service;
- Order Code, receipt/confirmation email or refund communication;
- pro-forma/manual-payment route, invoice issue/settlement or bulk-order policy;
- refund initiation, dispute, saved card, Customer, delayed payment method;
- application fee, transfer, destination charge, payout or commission split;
- production authorization/projection, physical-artwork receipt, dispatch or fulfilment
  transition;
- commission calculation, accrual, statement or settlement;
- real Stripe call, real payment/refund, shared secret/Event destination or deployment; or
- unrelated LMSPro behavior.

The three governed 2026-07-15 CRs inform exact immutable offer/workflow evidence only. A7
does not implement their Template, selection-capacity or collective-artwork capabilities
and does not silently answer their unrelated open questions.

## 15. Expected Application Files

Only after review and acceptance, an implementation should be bounded approximately to:

```text
src/modules/commerce/services/commerce-order-submission.service.ts
src/modules/commerce/services/commerce-order-submission.service.test.ts
src/modules/fund/lib/fund-commerce-submission.ts
src/modules/fund/lib/fund-commerce-submission.test.ts
src/modules/fund/lib/validation/store-checkout.ts
src/modules/fund/services/store-checkout.service.ts
src/modules/fund/services/store-checkout.service.test.ts
scripts/verify-commerce-a7-fund-consumer-integration.ts
scripts/run-commerce-a7-fund-consumer-integration-tests.ts
```

Small focused amendments to A5/A6-C helpers are permitted only if review demonstrates they
are required to expose the already accepted internal transaction/replay contract without
changing provider behavior. No router, route, page, Prisma or migration file is planned.

## 16. Disposable Validation Plan

Use only `TEST_DATABASE_URL` after proving it differs from `DATABASE_URL` without printing
credentials.

Static and pure validation:

- unchanged 140-migration inventory and no Commerce/FUND Prisma drift;
- Prisma validate/generate, type-check, focused lint and production build;
- canonical submission/offer hashes and token-domain separation;
- Decimal-to-minor conversion without floating point;
- explicit enum mapping, HALF_UP tax and signed choice-modifier arithmetic;
- canonical value validation for every accepted input control;
- safe snapshot/redaction rules and stable error vocabulary.

Disposable service/integration validation:

- Event and standalone published/open Stores;
- Store public-ID tenant resolution and cross-tenant indistinguishability;
- unpublished/paused/closed/outside-window/archived Project and Store refusal;
- stale/hidden/ineligible/unready Store Product/configuration/source refusal;
- Seller Profile status, address, currency, tax-rate and Store VAT reconciliation;
- exact delivery and current accepted commission evidence;
- mixed-product and repeated separately personalised Store Product lines;
- text/select/multi-select/colour/modifier/optional/missing-required inputs;
- multiple exact asset versions and purchaser-backup purpose/uploader validation;
- Commerce Checkout/Order/line/Payment and all FUND context rows created atomically;
- exact source tuples, display/configuration snapshots and arithmetic;
- same-token replay, hash conflict, in-progress lease and concurrent convergence;
- different-token concurrency against the same Store without duplicate submission
  corruption;
- injected rollback after every Commerce and FUND write stage;
- fake A6-C provider success, unavailable, replay, nullable/later PaymentIntent and
  permanent authority-loss behavior;
- fake signed A6-D success/failure/expiry/refund convergence without FUND state mutation;
- explicit failed/cancelled Payment retry and terminal/expired refusal;
- A1-A6-D, C1-C6, 1R-D, subscription billing and LMSPro static regressions;
- zero prefixed Commerce/FUND/A4/audit/provider fixture residue; and
- `git diff --check` plus critical-file verification.

No shared development, staging or production database, Stripe account, secret or Event
destination may be contacted or modified.

## 17. Rollback And Retention

A7 has no database rollback. Before activation, application rollback removes only the
dormant services/tests.

After any real Order exists, rollback must preserve every Checkout, Order, line, Payment,
FUND context/snapshot, A4 and audit row. A forward repair or feature disablement may stop
new submissions but must not delete or reinterpret commercial evidence or provider
objects.

## 18. Accepted Review Decisions

Review accepts:

1. A7 supports `STRIPE_ONLINE` only; pro-forma/manual ordering remains a separate later
   consumer lifecycle.
2. A7 is internal/dormant and adds no route/UI; later 1R-F and consumer-completion work own
   public invocation and advisory pages.
3. `submissionToken` is both the high-entropy guest idempotency capability and the source
   of the persisted Checkout token hash.
4. Local Order submission is final before provider Checkout creation; provider failure
   leaves one retryable PENDING Order rather than rolling back commercial evidence.
5. A failed/cancelled provider attempt may create a new Payment on the same immutable Order
   only through an explicit new attempt token and while source authority permits.
6. Required purchaser input/upload uses safe blocking behavior until the accepted C1
   allow-with-disclaimer policy gains a persistence/service contract.
7. Internal Commerce order number remains distinct from the later five-digit FUND Order
   Code.
8. The technical abuse ceiling is 100 lines and 10,000 units per line; this does not create
   Product/stock policy.
9. The first-pass local Checkout capability lasts 60 minutes; Project close blocks new
   Order submission but does not invalidate an already accepted provider payment attempt.

These are bounded technical/contract decisions, not new Store or production behavior.

## 19. Review And Acceptance Outcome

Review verified:

1. generic Commerce imports no FUND dependency;
2. FUND revalidates the exact current offer and never trusts caller money/source IDs;
3. Checkout/Order/Payment and typed FUND contexts are one atomic local boundary;
4. provider calls occur only after commit through unchanged A6-C authority;
5. A6-D remains the only paid/refund mutation authority;
6. tax, rounding, modifiers and total arithmetic preserve C1/A2 contracts;
7. input and asset snapshots are complete, immutable and privacy-minimised;
8. idempotency, concurrent replay and failed-attempt behavior cannot duplicate paid Orders
   or provider Sessions;
9. no public Store, Template/artwork workflow, upload, Order Code/email, pro-forma,
   production, fulfilment or commission behavior enters A7;
10. no schema/migration is required; and
11. the validation plan is sufficient to claim internal transactional integration only,
    not Store/consumer/production completion.

The plan is accepted for bounded implementation. No Prisma, migration, service, router,
route, provider, storage or UI change was made during review.

Resolved refinements are binding:

- FUND owns the `FUND.ORDER.SUBMIT` and payment-attempt idempotency scopes; generic Commerce
  receives only an already claimed operation context;
- guest eligibility uses a tenant-scoped internal evaluator and never a fabricated User;
- configuration locking pins Product/media/input commercial evidence, while exact current
  production-asset versions are independently validated and snapshotted at submission;
- file-input snapshots explicitly identify the asset versions that satisfied them;
- a new payment attempt preserves the immutable Order and does not reprice against later
  mutable configuration; and
- only a provider attempt already created before Project close may complete afterward.

## 20. Single Bounded Implementation Prompt

```text
Continue only accepted IsoStack Commerce Core Slice COMMERCE-A7. Do not begin FUND 1R-E,
1R-F, Template/artwork work, production, commission or another slice.

Starting from committed A6-D application baseline `fa670e3c` and the complete unchanged
140-migration history, implement only the dormant internal STRIPE_ONLINE FUND consumer
integration exactly as accepted. Add no Prisma schema or migration.

Add a consumer-neutral Commerce atomic submission helper that accepts an already claimed
A4 operation and immutable source contract without importing or hard-coding FUND. Add the
FUND adapter that resolves tenant from Store public ID, claims/replays `FUND.ORDER.SUBMIT`,
uses a tenant-scoped internal eligibility evaluator without a fabricated User, locks and
revalidates the published/open Store offer, Seller Profile, delivery, commission and exact
configuration/input/asset evidence, and atomically creates Checkout, Order, lines, one
PENDING STRIPE_ONLINE Payment and every C6 FUND context/snapshot. Complete A4 only after
all Commerce and FUND writes/audits succeed.

Implement exact Decimal-to-minor, HALF_UP tax and signed modifier arithmetic; explicit enum
mapping; safe blocking input validation; exact live-definition matching; ordered
multi-select/file evidence; and exact current clean/reviewed asset-version snapshots. Do
not claim the Store configuration hash pins mutable production-asset versions.

After commit invoke existing A6-C through injected fake providers only. Keep A6-D as sole
Payment/refund authority. Implement exact replay and explicit new failed/cancelled payment-
attempt behavior on the same immutable Order while its capability and Store/Project window
remain valid; never reprice or rewrite Order/FUND evidence.

Add no public/C1/C2 router, route, page or UI; no pro-forma, upload/scanning, Order Code or
email; no Template/collective-artwork, production/fulfilment authorization or commission;
and no real Stripe call, secret, Event destination or shared deployment.

Use only TEST_DATABASE_URL after proving it differs from DATABASE_URL. Verify the unchanged
140-migration inventory, pure normalization/hash/arithmetic tests, tenant/Store/eligibility/
configuration/input/asset/Seller authority, atomic creation and rollback at every stage,
same-token and concurrent replay, A4 ownership separation, fake A6-C success/replay/failure,
fake A6-D convergence, immutable failed-attempt retry, privacy/redaction, A1-A6-D/C1-C6/
1R-D/subscription/LMSPro regressions, production build and zero residue.

After successful validation, create separate A7 implementation-confirmation and review/test
records, update Commerce, FUND, strategic and root roadmaps and the Commerce planning
README, and stop. Do not start another slice.
```
