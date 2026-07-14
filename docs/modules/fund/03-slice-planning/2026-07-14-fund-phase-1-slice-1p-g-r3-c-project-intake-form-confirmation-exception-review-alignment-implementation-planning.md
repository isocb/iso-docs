# FUND Phase 1 Slice 1P-G-R3-C - Project Intake Form, Confirmation And Exception-Review Alignment Implementation Planning

Date: 2026-07-14

Status: Implemented and reviewed as passed / application committed and promoted to `origin/dev` at `234f115` / shared databases undeployed

Parent alignment:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1p-g-r3-project-intake-automated-provisioning-alignment-planning.md`

Completed foundations:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1p-g-r3-a-project-intake-automation-schema-form-policy-foundation-implementation-planning.md`

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1p-g-r3-b-project-intake-automated-provisioning-and-protection-services-implementation-planning.md`

Parent controls:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

`docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 1. Goal

Connect the completed but dormant R3-B engine to the existing Project Intake workflow in a
bounded, explicit and reviewable way:

```text
C1 configures and activates one aligned Event or standalone form offer
-> public or authenticated C2 organiser submits typed evidence
-> IsoStack sends and verifies the existing bounded confirmation email/token
-> confirmation atomically invokes the R3-B engine
-> eligible submission creates Client/member/User/Project/delivery evidence
-> intentional manual form or bounded exception enters C1 review
-> C1 may complete an explicit reviewed resolution through the same R3-B engine
```

R3-B is not connected today. R3-C is the first and only child authorised, after an explicit
future implementation instruction and the baseline gate below, to add its
route/procedure/form/UI callers.

Review accepted this plan on 2026-07-14. Implementation and independent review/test then
completed the bounded contract without a Prisma schema or migration change. The lifecycle
evidence is recorded in the linked `04-implementation-confirmations` and
`05-review-and-test` folders. No real form was activated and no shared environment was
changed.

## 2. Entry Gate And Baseline

R3-C implementation may begin only when:

- the current R3-B application implementation, implementation confirmation, review/test
  record and roadmap state are committed as separate, unambiguous baselines;
- the application begins from the complete 134-migration R3-A schema plus the accepted R3-B
  service implementation;
- `TEST_DATABASE_URL` is proven distinct from `DATABASE_URL` before any write test;
- this accepted plan is followed by an explicit bounded implementation instruction;
- no Store `1R-D`, `1R-C6`, `COMMERCE-A2`, generic Project Creation Contract Alignment or
  another slice is mixed into the implementation.

R3-C adds no Prisma model, enum, field, constraint or migration. If implementation finds a
missing persistence invariant, stop and return to planning rather than silently widening
the accepted R3-A schema.

## 3. Current Implementation Reconciliation

The existing implementation already provides useful live behavior:

- C1 DRAFT/ACTIVE/PAUSED/ARCHIVED form management;
- tenant-owned Event selection, public form windows and a submission limit;
- stable public form, confirmation, submitted and expired route families;
- branded multi-step public capture;
- hash-only confirmation tokens, expiry and token clearing;
- one bounded transactional confirmation email;
- C1 submission list/detail/status management and legacy approval pages;
- middleware-public access and branded unavailable states.

It does not yet carry the R3-A/R3-B contract:

- C1 form procedures/UI do not set aligned scope, contract version, policy revision or
  fixed/selectable Project-type policy;
- the public form always offers every Project type instead of the saved form policy;
- organisation address is one free-text field and is not copied into typed R3-A fields;
- public submit does not snapshot form contract/revision or create the server fingerprint;
- existing-Client authority is not captured from an authenticated eligible membership;
- the submission-limit check is a non-locking count and can overbook concurrently;
- confirmation only changes the submission to `SUBMITTED`; it does not invoke R3-B;
- confirmation success copy always says the request was sent for review;
- aligned exceptions cannot be explicitly resolved through an R3-B-backed C1 procedure/UI;
- the old approval page can create a clientless standalone Project and is therefore valid
  only for historic null-contract submissions;
- slug-only form lookup currently uses `findFirst` without a trusted tenant discriminator,
  although form slugs are unique only inside a tenant.

R3-C evolves these surfaces in place. It does not create a parallel Intake framework.

## 4. Controlling Authority Rules

1. The C1-saved `FundProjectIntakeForm` is the only Event/standalone, Project-type,
   Client-type, date-window, submission-limit and moderation authority.
2. `formContractVersion = 1` is an explicit opt-in. Null-contract forms remain legacy and
   review-only.
3. Public page context, query parameters, hidden fields, raw payload, names and emails never
   establish tenant, Event, Client or membership authority.
4. An existing-Client path exists only when the current authenticated effective User is
   revalidated as an active eligible member of that exact same-tenant Client.
5. Anonymous or unauthenticated respondents always use the new-Client evidence path. If
   their identity conflicts with an existing account, R3-B routes the submission to C1
   review without disclosing account existence publicly.
6. Confirmation compares the saved submission contract/revision to the current form. C1
   must not rewrite a changed policy snapshot merely to force provisioning.
7. Event scope and fixed/allowed Project type cannot be changed by C1 exception review.
8. A version-1 result is complete only through R3-B; aligned routes never call the three
   legacy approval writers.

## 5. C1 Form Configuration Alignment

### 5.1 Explicit modes

The C1 form UI must distinguish:

```text
LEGACY MANUAL
  existing null-contract forms only; preserved for historic compatibility

ALIGNED AUTOMATIC
  contract version 1; requiresModeration = false

ALIGNED REVIEW-FIRST
  contract version 1; requiresModeration = true
```

New forms must explicitly choose Event or standalone aligned scope. The creation UI must
not offer a new legacy contract. Existing legacy forms remain unchanged until C1 deliberately
aligns them.

Alignment is an explicit, warned action available only while a form is DRAFT or PAUSED.
Once a form has a versioned contract it cannot be reverted to null/legacy. Scope or other
authority changes remain possible while paused, create a new policy revision and warn that
pending confirmations will be routed safely rather than accepted under changed terms.

### 5.2 Event and standalone shape

Event form:

```text
alignedScope = EVENT
defaultEventId = required same-tenant Event
allowStandaloneProjects = false
```

Standalone form:

```text
alignedScope = STANDALONE
defaultEventId = null
allowStandaloneProjects = true
```

The UI uses “standalone Project offer”, not the obsolete “clientless standalone approval”
language. Every resulting Project still has a Client and organiser.

### 5.3 Project and Client type policy

C1 chooses either:

```text
FIXED PROJECT TYPE
  one required defaultProjectTypeCode; public form displays it as read-only context

SELECTABLE PROJECT TYPES
  one or more allowedProjectTypeCodes; optional default must be in that set
```

Allowed Project and Client types use the shared R3-B normalization vocabulary. The server,
not UI labels, writes canonical codes.

`allowExistingClientSelection` means an eligible authenticated C2 member may choose one of
their own server-returned Clients. It never exposes a general Client search publicly.

### 5.4 Revision authority

Create an aligned form with:

```text
formContractVersion = 1
formPolicyRevision = 1
```

On update, use the R3-B canonical equality/revision helper. Only these authority fields
increment the revision:

```text
alignedScope
defaultEventId
allowStandaloneProjects
defaultProjectTypeCode
allowProjectTypeSelection
normalized allowedProjectTypeCodes
normalized allowedClientTypes
allowExistingClientSelection
requiresModeration
startsAt
endsAt
submissionLimit
```

Name, description, instructions, source label, success message, branding, ordinary metadata
and status do not increment the revision.

Activation validates a complete supported policy. Saving or activating never provisions a
submission.

## 6. Trusted Public Tenant And URL Resolution

The public service must stop resolving a form by unscoped `slug` plus `findFirst`.

Accepted route behavior:

- the existing `/fund/project-initiation/[formSlug]` family remains valid on a host/domain
  for which middleware supplies one trusted `organisationId`;
- a shared-host canonical route includes the tenant slug as well as form slug, for example
  `/fund/project-initiation/[organizationSlug]/[formSlug]`;
- every query resolves one Organization first, then queries the exact
  `(organizationId, formSlug)` pair;
- the slug-only route returns a generic unavailable response when no trusted tenant context
  exists; it must never select the first matching form across tenants;
- generated C1 copy/link controls use the tenant-domain route when known, otherwise the
  canonical shared-host tenant/form route;
- already-issued tenant-domain URLs remain stable.

The tenant slug is a routing discriminator, not permission by itself. Database queries
remain exact-tenant.

The current middleware deliberately returns early for `/api/*`, so a public tRPC request
must not assume that `ctx.organisationId` was injected from its browser hostname. R3-C uses
this explicit bridge instead:

- the server-rendered slug-only page accepts the route only when middleware supplied a
  trusted tenant-domain `organisationId`, resolves that Organization and passes its public
  slug into the rendered form client;
- the canonical shared-host page already has the Organization slug in its route;
- public `getForm`, submit, resend and confirm inputs therefore carry both Organization slug
  and form slug, and every service resolves the exact Organization/form pair again;
- changing that public routing discriminator can at most select another deliberately public
  active form; it never grants C1, Client/member or Event authority and never causes a
  cross-tenant write;
- no global `/api` middleware or authentication behavior is widened merely to obtain a
  tenant header.

## 7. Public And Authenticated C2 Form Capture

### 7.1 Typed fields

Aligned forms capture and validate:

```text
Project
  name
  fixed or allowed Project type
  opensAt
  closesAt
  optional description

Client organisation/project-owning body
  name
  allowed Client type
  addressLine1
  optional addressLine2/addressLine3
  locality/town/city
  optional region/county
  postalCode
  ISO alpha-2 countryCode

main organiser
  firstName
  lastName
  confirmed email
  phone
  role label
```

Do not retain the single free-text address as the version-1 production input. It may remain
inside historic raw payloads. The public UI may default country from the offer/tenant
context but keeps an explicit canonical country code.

The server writes the R3-A typed columns directly and may retain a bounded presentation
snapshot in `rawPayload`. It never parses typed values back out of raw JSON.

### 7.2 Authenticated existing-Client choice

For an authenticated session, add a safe optional-session query that returns only the
current effective User's eligible same-tenant Client memberships for this form. It must:

- apply K1-F session revocation/effective-identity policy;
- require active User, Client and member, no archive, dashboard access and
  `PROJECT_MANAGER` or `ADMIN` access;
- return only bounded Client/member display data owned by that User;
- return no membership data to anonymous, stale, cross-tenant or ineligible sessions.

If C2 selects one of these Clients, the submit service calls the R3-B trusted-membership
capture/revalidation helper and stores the exact trusted Client/member pair. The public
payload cannot supply a trusted member ID.

The form continues to allow a new-Client path. Public copy must not reveal that a matching
Client/User already exists.

### 7.3 Form-dependent UX

- Event forms display the trusted Event and bound Project dates to its window.
- Standalone forms clearly state that no Event is linked.
- Fixed Project type is contextual/read-only; selectable type renders only allowed codes.
- Existing-Client choice appears only when both form policy and eligible session evidence
  permit it.
- Instructions explain that the first confirmed Project establishes or reuses the organiser
  account and initial delivery details.
- Branding and existing stable public shells remain.

Managed Event media may be displayed only through existing `FundEventMedia`/MediaFile
contracts. R3-C does not add external banner URLs or upload behavior.

### 7.4 Submission acknowledgement

The aligned submit action includes one required acknowledgement of the displayed Project
offer, privacy notice and accuracy statement. R3-C does not create an editable legal-terms
registry. The server records a bounded version identifier and accepted timestamp in
server-written submission context/raw evidence; it does not trust a client-supplied
timestamp or wording.

Missing acknowledgement rejects the request before a submission is created. This evidence
is not tenant, Event, Client, Project-type or provisioning authority and does not increment
the form-policy revision. If per-form editable legal wording or independent legal-version
governance becomes required, stop and create a separate plan rather than hiding it in form
metadata.

## 8. Submission Reservation, Idempotency And Abuse Protection

Aligned submit must run a bounded transaction that:

1. resolves and locks the exact tenant/form row;
2. confirms ACTIVE, unarchived, in-window and structurally valid form policy;
3. applies honeypot, realistic-fill-time and IP/request protection before creating review
   work;
4. requires the UI's cryptographically random idempotency key;
5. takes an advisory lock for tenant/form/idempotency and binds that key to the canonical
   request fingerprint; an exact retry returns the existing bounded result, while reuse of
   the key for different evidence returns a generic conflict and changes nothing;
6. counts occupied submissions while the form lock is held and reserves one place before
   releasing the transaction;
7. normalizes/validates all typed fields against current policy;
8. writes `submittedFormContractVersion` and `submittedFormPolicyRevision` from the saved
   form, plus trusted membership evidence when present;
9. creates a versioned server-owned fingerprint from canonical tenant/form/organiser/
   Client/Project/Event/date evidence using HMAC-SHA-256 and a domain-separated key derived
   from the validated server secret; it never trusts a browser fingerprint or stores a
   plain hash of PII;
10. stores only hash/expiry for the confirmation token.

The fingerprint uses an explicit `v1` representation, is stable for equivalent evidence,
excludes the idempotency key and avoids raw PII in logs. No secret or digest input is
returned to the client.

Submission-limit occupancy is explicit:

- an unconfirmed `CONFIRMATION_PENDING` row occupies a place only while its confirmation
  token is unexpired;
- a confirmed non-terminal aligned or legacy row continues to occupy a place;
- `REJECTED`, `CANCELLED`, `SPAM` and `ARCHIVED` rows do not occupy a place;
- an expired unconfirmed row is retained as evidence but no longer consumes capacity;
- reducing a limit below current occupancy blocks new submissions but does not displace an
  already reserved submission.

The existing bounded confirmation email remains the only R3-C email. It is sent after the
submission transaction commits. An email failure leaves a valid pending submission and a
generic retry option; it does not provision or queue an exception.

R3-C must add a bounded, rate-limited explicit resend action so a committed submission whose
email failed is recoverable. Resend locks the exact tenant/form/submission, permits only an
unconfirmed pending row and sends the same confirmation email after commit. If the old token
is already expired, resend also locks the form and must re-reserve capacity under the same
occupancy rule before rotating hash/expiry; a now-full form changes nothing and returns a
generic unavailable result. Normal idempotent submit retries must not silently rotate a
token and invalidate an already-sent email.

Obvious honeypot/timing/rate abuse returns a generic `TOO_MANY_REQUESTS`/unavailable result
and creates no submission or C1 review item. Reuse the platform's generic spam/rate-limit
capability with a FUND-specific key namespace; do not import LMSPro router logic.

## 9. Atomic Confirmation And Engine Invocation

Confirmation is one serializable transaction using the R3-B in-transaction entry point:

```text
lock exact tenant/form/submission
-> validate hash, expiry and CONFIRMATION_PENDING status
-> validate current form is active/in-window and canonical
-> compare current contract/revision with submitted snapshot
-> set confirmedAt/submittedAt and clear confirmationTokenHash
-> set status SUBMITTED
-> invoke R3-B in the same transaction
-> commit completion, intentional manual result or bounded exception together
```

The above is the aligned-contract branch. A historic null-contract submission retains the
existing token/expiry confirmation transition to `SUBMITTED`, remains review-only and does
not acquire aligned current-policy requirements. It cannot provision through a legacy
approval writer once its form/submission carries version-1 evidence.

Do not re-count the submission limit at confirmation. The place was reserved at submit and
the unchanged limit configuration is represented by the policy revision.

If R3-B returns or writes:

```text
COMPLETED / ALREADY_COMPLETED -> APPROVED, public copy says the Project was created
MANUAL_REVIEW                 -> SUBMITTED, public copy says confirmed and awaiting review
EXCEPTION_REVIEW              -> IN_REVIEW, public copy says confirmed and awaiting review
RETRIABLE/INFRASTRUCTURE ERROR -> whole transaction rolls back; token remains usable
```

Public responses never disclose exception reason, existing-account state, Client/member
IDs, internal audit or security details.

Once the hash is cleared, the server can no longer prove that a presented token was the
consumed token. Therefore a replayed, wrong or unknown link receives one indistinguishable
generic “invalid, expired or already processed” result with no PII, existence signal or
operational ID. The browser may show `ALREADY_PROCESSED` only from its own immediately
completed mutation state; the public server response must not turn submission UUID probing
into an existence oracle.

## 10. Confirmation And Status UX

The confirmation page must distinguish public-safe outcomes:

```text
PROJECT_CREATED
  “Your Project has been created.”
  Explain that organiser access uses the normal IsoStack sign-in flow.

REVIEW_REQUIRED
  “Your details are confirmed and the fundraising team will review the request.”
  Do not show the exception reason.

ALREADY_PROCESSED
  Client-local immediate retry state only; no server-side UUID existence disclosure.

INVALID_EXPIRED_OR_ALREADY_PROCESSED
  One indistinguishable server response with generic start-again/status guidance.

RETRIABLE_FAILURE
  Generic temporary failure and a safe retry of the same link.
```

Do not promise an invitation or notification email. R3-C sends only confirmation/resend
mail already within scope.

## 11. C1 Exception Review And Explicit Resolution

### 11.1 Queue and detail

Evolve the existing submission dashboard/detail page rather than creating a second queue.
Aligned rows display:

- contract/revision and automatic versus reviewed state;
- bounded exception reason translated into clear C1 guidance;
- typed Project, Client, address and organiser evidence;
- trusted existing-Client/member evidence when present;
- completed Client/member/Project/delivery links when approved;
- audit-safe status and moderation history.

Legacy null-contract rows retain the old approval UI. Aligned rows must not show or call the
legacy clientless/standalone approval procedures.

### 11.2 Reviewed resolution procedure

Add one protected C1 `OWNER`/`ADMIN` procedure that validates an explicit resolution and
calls R3-B with `C1_REVIEW`. It supports only:

```text
NEW CLIENT
  create/reuse safe User and create primary Project Manager/Admin member

EXISTING CLIENT
  select exact same-tenant Client and eligible member
  or explicitly create a member linked through the reviewed safe-User policy
  optional explicit primary-member replacement
```

Pending User activation is a separate explicit checkbox and is permitted only for the
R3-B accepted pending states. Suspended, deactivated and deletion-requested accounts must
be corrected in their owning User-management workflow.

The procedure uses effective tenant context, audits the actor and never accepts tenant IDs,
Event scope or trusted ownership from client payload.

### 11.3 Correctable and non-correctable exceptions

R3-C may permit audited correction of typed evidence only after C1 has verified it through
the established offline/needs-information process:

- Client name and one Client type still allowed by the unchanged form policy;
- organiser first/last names, phone and role label;
- structured address fields;
- Project name/description;
- Project dates within the unchanged form/Event policy;
- one Project type still allowed by the unchanged form policy.

Raw submitted payload remains unchanged as original evidence. Corrections write typed
columns and one bounded audit describing changed field names, not full address/PII values.
The original server fingerprint also remains immutable submission evidence; it is not
recomputed to disguise a reviewed correction. The reviewed path revalidates and locks the
corrected exact Client/Project/date identity independently before provisioning.

The confirmed organiser email and matching proposed contact email are not correctable by
C1 in R3-C. A different email requires a new submission and confirmation because C1 review
cannot manufacture proof of control of another address. R3-C also does not change a
completed or pending User's login email.

These authorities cannot be overridden:

- tenant and form;
- Event versus standalone scope or Event ID;
- form contract version/revision;
- allowed Client/Project type sets;
- trusted member/Client ownership without server revalidation.

`FORM_POLICY_CHANGED` cannot be “fixed” by replacing the submitted revision. C1 must ask
the organiser to use the current form/confirmation contract. The old submission may be
cancelled or rejected with a note.

An exact duplicate Project conflict must be corrected to a genuinely distinct Project or
left unprovisioned; C1 cannot force two identical Project identities.

### 11.4 State machine

Aligned incomplete rows use:

```text
SUBMITTED   intentional aligned review-first result
IN_REVIEW   automated exception or C1 actively reviewing
NEEDS_INFO  C1 is resolving evidence outside the platform
REJECTED    terminal C1 rejection
CANCELLED   withdrawn/replaced request
SPAM        terminal abuse classification
APPROVED    complete R3-B result only
```

Retry/review completion is allowed only from `SUBMITTED`, `IN_REVIEW` or `NEEDS_INFO`.
Approved rows cannot be reopened or have operational IDs replaced. The broad historic
`returnToReview` function remains legacy-only; R3-C adds an explicit aligned transition
contract instead of exposing it unchanged.

## 12. Public And C1 Data Minimisation

- Continue stripping token hashes, idempotency keys and fingerprints from every public/C1
  serialized response unless a bounded diagnostic specifically needs only their presence.
- Public results contain no exception reason, matching hint, Client/member ID or account
  existence signal.
- C1 may see typed business evidence and bounded identity resolution choices inside its own
  tenant, but not secrets.
- Audit metadata records IDs, reason codes, changed field names and bounded outcomes; it
  avoids address, phone, email and raw payload duplication.
- No server secret, digest input or token plaintext enters logs.

## 13. Expected Application Areas

Likely bounded implementation files are:

```text
src/modules/fund/lib/validation/project-intake.ts
src/modules/fund/lib/project-intake-policy.ts
src/modules/fund/services/project-intake.service.ts
src/modules/fund/services/project-intake-provisioning.service.ts   only if an integration-safe defect is proven
src/modules/fund/routers/project-intake.router.ts
src/modules/fund/components/project-intake/types.ts
src/modules/fund/components/project-intake/ProjectIntakeFormsPage.tsx
src/modules/fund/components/project-intake/ProjectIntakeFormDetailPage.tsx
src/modules/fund/components/project-intake/ProjectIntakeDashboardPage.tsx
src/modules/fund/components/project-intake/ProjectIntakeSubmissionDetailPage.tsx
src/modules/fund/components/project-intake/ProjectIntakeApprovalPage.tsx
src/modules/fund/components/project-intake-public/PublicProjectInitiationForm.tsx
src/modules/fund/components/project-intake-public/PublicProjectInitiationConfirmPage.tsx
src/modules/fund/components/project-intake-public/PublicProjectInitiationStatusPage.tsx
src/app/fund/project-initiation/... public route pages
src/lib/spam-protection.ts or a bounded shared/FUND wrapper
focused route/service/component/static verifier files
```

No Prisma schema or migration file is expected. Do not edit unrelated LMSPro callers when
adding a scoped spam-protection wrapper.

## 14. Explicit Exclusions

R3-C must not add:

- Store creation, configuration, readiness, commission acceptance or publication;
- Commerce checkout, Orders, payments, refunds or pro-forma invoices;
- Product selection, artwork/media upload, production, dispatch or commission calculation;
- invitation, onboarding, magic-link or exception-notification email beyond the existing
  confirmation and explicit resend;
- iframe embedding/CSP/origin allowlist behavior;
- SeasonPro/LMSPro Project initiation integration;
- authenticated C2 dashboard direct-Project changes;
- generic C1/K2 Project Creation Contract Alignment;
- Client address-book/default-address behavior;
- automatic correction of suspended/deactivated Users;
- a new database migration or parallel Intake framework.

## 15. Validation Plan

### 15.1 Static and pure behavior

- TypeScript type-check, focused lint, critical-file checks and both-repository
  `git diff --check`;
- R3-A schema verifier and 134-migration inventory unchanged;
- R3-B policy/service tests and A1/C1/C2/C3/C4/C5 regressions unchanged;
- canonical form create/update/revision tests, including non-authority copy edits;
- form-scope, fixed/selectable type and activation validation;
- static proof that no Prisma migration, Store, Commerce, upload or unrelated route was
  added.

### 15.2 Disposable PostgreSQL service/route evidence

Use only `TEST_DATABASE_URL` after proving it differs from `DATABASE_URL`:

- exact tenant/form lookup and rejection of ambiguous slug-only shared-host requests;
- concurrent submission-limit reservation cannot exceed the saved limit;
- repeated idempotency key creates one pending submission;
- reuse of one idempotency key with different canonical evidence is rejected without
  mutation;
- expired unconfirmed reservations stop consuming capacity while confirmed and approved
  rows continue to count;
- resend of an expired pending row must re-reserve capacity and cannot overbook the form;
- typed capture, canonical code normalization, policy snapshots and server fingerprint;
- HMAC domain separation, deterministic `v1` fingerprint and no raw PII in logs;
- required acknowledgement evidence is server-timestamped and absent acknowledgement
  creates no row;
- anonymous new-Client and authenticated eligible existing-Client evidence;
- stale, revoked, cross-tenant, inactive and insufficient membership cannot become trusted;
- fixed/selectable Project type, Event/standalone and date authority rejection;
- honeypot/timing/rate denial creates no submission or review residue;
- successful confirmation consumes one token and atomically completes automatic
  provisioning;
- manual aligned confirmation commits `SUBMITTED` without an exception;
- stable exception confirmation commits `IN_REVIEW` with no partial operational rows;
- injected R3-B/database failure rolls back confirmation and leaves the token usable;
- concurrent/double confirmation creates one exact outcome;
- wrong, unknown and consumed confirmation links are publicly indistinguishable;
- changed policy becomes `FORM_POLICY_CHANGED` and cannot be approved by snapshot rewrite;
- explicit C1 reviewed new/existing Client/member paths and pending-User activation;
- reviewed corrections preserve the original raw payload/fingerprint and cannot replace the
  confirmed email;
- aligned legacy-procedure rejection and historic null-contract approval regression;
- approved identity links and deletion protection remain exact;
- zero R3-C Organization/User/submission/audit residue.

Stub or capture email delivery in tests. Do not send external email from disposable route
tests.

### 15.3 UI and route evidence

- existing tenant-domain public URLs remain valid;
- canonical shared-host tenant/form URL renders the same branded form;
- public API calls resolve the exact Organization/form pair and do not depend on an absent
  `/api` hostname header;
- legacy form rendering/confirmation continues review-only;
- aligned Event and standalone form creation/edit/activation;
- fixed and selectable Project-type rendering;
- granular address validation and accessible mobile step flow;
- authenticated eligible Client selector is private to the current session;
- public confirmation copy for created/review/already-processed/error outcomes;
- C1 queue reason guidance, typed evidence, reviewed resolution and terminal states;
- no aligned clientless approval option;
- no secret fields or account-existence detail appears in browser payloads.

The review/test record must explicitly close prospective D1/D2 and K1-F integration
coverage without inventing backdated historic review records.

## 16. Rollback And Deployment Safety

Before shared activation, rollback is code reversion because R3-C adds no migration.

Existing legacy forms remain null-contract and review-only. No existing form is opted in by
deployment. C1 must deliberately align, validate and activate each form after release.

Once an aligned form creates real operational records, rollback must preserve submissions,
Clients, Users, members, Projects, delivery profiles and audit history. Any correction is a
forward, reviewed remediation; never delete business evidence as code rollback.

Promotion and enabling a real C1 form are separate explicit actions. A passing local R3-C
review does not authorise shared deployment or form activation.

## 17. Lifecycle Deliverables After Future Implementation

Only after explicit review/acceptance and a separately committed R3-B baseline:

- implement the bounded R3-C integration with no migration;
- create one R3-C implementation-confirmation record;
- create one independent R3-C review/test record;
- update the FUND roadmap first, then root roadmap and planning README;
- record branch, commit, push, deployment and form-activation state honestly;
- stop without beginning Store `1R-D`, `1R-C6`, `COMMERCE-A2` or another slice.

## 18. Review Outcome And Acceptance

Review on 2026-07-14 accepted the bounded R3-C plan after resolving:

- R3-B remains dormant until this accepted plan is explicitly implemented;
- form alignment is explicit and irreversible to legacy/null;
- shared-host public URLs gain a tenant discriminator while tenant-domain URLs remain;
- public API calls do not assume hostname context that middleware does not inject on
  `/api/*`;
- submission limits reserve at submit under a form lock, with explicit expired and terminal
  occupancy rules;
- idempotency keys are bound to the same canonical request evidence;
- typed address and policy evidence are written directly, never parsed from raw JSON;
- acknowledgement is bounded server-written evidence rather than a hidden legal registry;
- confirmation and R3-B invocation are one transaction;
- consumed and invalid links are publicly indistinguishable;
- C1 may correct bounded typed evidence but not confirmed email, tenant/Event/scope/policy
  authority or the original fingerprint;
- changed policy requires the organiser to accept the current form again;
- aligned rows use one reviewed R3-B procedure and never the clientless legacy writer.

The review confirmed that the implemented R3-A schema is sufficient and R3-C needs no
Prisma migration. Store, Commerce, payments, uploads, production, commission, generic
Project-creation remediation, invitation email and real iframe behavior remain excluded.

Implementation is accepted as the next candidate from the separately committed R3-B
application and documentation lifecycle baselines. The application baseline is `04da074`;
the current IsoDocs baseline contains the R3-B lifecycle. The user must still issue the
bounded prompt below.

## 19. Single Bounded Implementation Prompt

```text
Continue only accepted FUND Phase 1 Slice 1P-G-R3-C. Do not begin Store 1R-D, 1R-C6,
COMMERCE-A2, Project Creation Contract Alignment or another slice.

Begin only from separately committed R3-B application and documentation lifecycle
baselines on top of the complete 134-migration R3-A history. If R3-B remains uncommitted,
make no R3-C application edit and tell me that the R3-B baseline must be committed first.

Implement only the accepted Project Intake form, confirmation and exception-review
alignment. Add explicit aligned Event/standalone and fixed/selectable Project-type C1 form
configuration with canonical revision handling; exact tenant-domain and shared-host
Organization/form routing; typed organiser, Client-address and Project capture; bounded
server-written acknowledgement; optional-session trusted existing-Client selection; locked
submission-limit reservation with expiry/terminal occupancy; evidence-bound idempotency;
domain-separated `v1` HMAC fingerprinting; and a bounded rate-limited confirmation resend.

For aligned submissions, consume confirmation and invoke the R3-B in-transaction engine in
one serializable transaction. Preserve historic null-contract confirmation/review behavior,
make invalid/expired/consumed public links indistinguishable, expose only public-safe
created/review/retry outcomes, and add one protected C1 reviewed-resolution path through
R3-B. Permit only the accepted audited typed corrections; preserve original raw evidence
and fingerprint, never replace the confirmed email, and reject aligned use of every legacy
clientless approval writer.

Use the existing R3-A schema without modification. Add no Prisma migration, Store,
Commerce, payment, upload, production, commission, generic Project-creation remediation,
invitation/onboarding email, real iframe/CSP behavior or unrelated LMSPro change.

Use only TEST_DATABASE_URL after proving it differs from DATABASE_URL. Verify the unchanged
134-migration inventory, form policy/revision, tenant-safe routes, optional-session K1-F
authority, typed capture, acknowledgement, reservation/idempotency/fingerprint/resend,
automatic/manual/exception confirmation, reviewed correction and resolution, public data
minimisation, concurrency/rollback, legacy Intake, K1-F/K2 and A1/C1/C2/C3/C4/C5/R3-A/R3-B
regressions, captured email only and zero test residue.

After successful validation, create separate R3-C implementation-confirmation and
review/test records, update the FUND and root roadmaps and planning README, and stop. Do not
start another slice or activate a real form.
```
