# FUND Phase 1 Slice 1P-G-R3 - Project Intake Automated Provisioning Alignment Planning

Date: 2026-07-14

Status: Parent alignment accepted / no implementation authorised / 1P-G-R3-A planning created

Parent controls:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

`docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

Preceding completed foundation:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1r-c2-client-branding-project-delivery-event-media-schema-implementation-planning.md`

Implemented workflow inputs reviewed for this alignment:

- the complete available `1P-G` Project Intake planning, implementation-confirmation,
  review/remediation and live-promotion record, including its documented review gaps;
- `1P-K1-F - Client Member Login/Onboarding And Auth Routing Planning`;
- `1P-K1-F-A - Client Member Auth Routing And Access Policy` implementation;
- `1P-K1-F-B - Client Member User Link/Create Service` implementation;
- the complete `1P-K2` C2 Client Dashboard And Client-Owned Project Management planning,
  API/UI implementation and review/smoke-test lifecycle;
- the current Prisma schema and Project Intake/Client-member application services and UI.

## 1. Goal

Align the implemented C1-built public Project Intake workflow with the accepted C2 Client,
organiser-account and Project-delivery contract, and replace mandatory per-submission C1
moderation with safe straight-through provisioning plus exception review.

Activating a form is C1's approval of the bounded Project offer represented by that form.
After respondent email confirmation, an eligible submission that passes the automated
protections must establish in one transaction:

```text
C2 Client organisation/project-owning body
-> login-capable primary FundClientMember/User organiser
-> Client-owned FundProject
-> initial FundProjectDeliveryProfile
-> completed intake provisioning evidence
```

The same form workflow may create a first Project for a new Client or another Project for
an existing Client. Each active form has one trusted scope:

```text
EVENT -> every resulting Project is linked to the form's C1-selected Event
STANDALONE -> every resulting Project is Client-owned and has no Event
```

The surrounding Father's Day, Christmas, Team Products or other webpage explains the offer
to the visitor, but the page URL, embed context and public payload are not authority. The
active same-tenant form record determines the Event or standalone scope.

This document begins planning only. It does not authorise Prisma, migration, service, API,
route, UI, email, deployment or database changes.

Review outcome on 2026-07-14:

- accepted as the controlling parent alignment family;
- complete implemented 1P-G, K1-F, K2 and 1R-C2 traceability is sufficient for child
  planning, while the recorded historic evidence gaps remain honest prospective regression
  obligations;
- an explicit aligned-form contract/version marker is required so no legacy form can become
  automatic merely because of an old Boolean value;
- each aligned submission must snapshot the form contract and policy revision so confirmation
  can detect a changed offer deterministically;
- the provisioning path distinguishes automatic provisioning from C1 review, while the
  exception reason separately distinguishes an automated exception from an intentionally
  manual form;
- the first bounded child plan is `1P-G-R3-A - Project Intake Automation Schema And Form
  Policy Foundation`; it remains awaiting separate review/acceptance and authorises no
  implementation.

## 2. Slice Name And Lifecycle

The controlling slice identifier and name are:

```text
1P-G-R3 - Project Intake Automated Provisioning Alignment
```

This is the third remediation/alignment family for the implemented `1P-G` Project Intake
lane, informed by the later `1R-C2` delivery foundation and K1-F identity work. It does not
consume the accepted Store identifier `1R-D`, and it is not `1R-C6`, which remains reserved
for typed FUND Commerce Order context and is blocked by Commerce Order/line foundations.

The clarification that normal submissions provision automatically makes this a parent
alignment family rather than one safe implementation unit. Each child must follow the full
lifecycle independently:

```text
1P-G-R3 parent review and explicit acceptance
-> 1P-G-R3-A plan / acceptance / implementation / confirmation / review-test / roadmap update
-> stop and explicitly authorise 1P-G-R3-B
-> 1P-G-R3-B plan / acceptance / implementation / confirmation / review-test / roadmap update
-> stop and explicitly authorise 1P-G-R3-C
-> 1P-G-R3-C plan / acceptance / implementation / confirmation / review-test / roadmap update
-> stop
```

Required child boundaries are:

```text
1P-G-R3-A - Project Intake Automation Schema And Form Policy Foundation
  schema/enums/exact keys/form-scope/default-type/decision evidence only

1P-G-R3-B - Project Intake Automated Provisioning And Protection Services
  form-policy evaluation, new/existing Client identity, atomic provisioning and exception
  classification services only; no public or C1 UI changes

1P-G-R3-C - Project Intake Form, Confirmation And Exception-Review Alignment
  C1 form configuration, public/authenticated form flow, confirmation trigger, exception
  review UI and end-to-end regression only
```

Each child receives its own future implementation-confirmation and review/test filenames
only when that child plan is created and accepted. No parent implementation-confirmation or
predictive evidence file should be created.

## 3. Terminology And Authority

- `Organization` is the C1 IsoStack tenant, producer and supplier.
- `FundClient` is the C2 Client organisation/project-owning body. It may be a school, club,
  Scout or Guide group, team, league, PTA, charity, community group or another body.
- `FundClientMember` is a person associated with that C2 Client.
- `User` is the login-capable platform identity linked to a Client member.
- **main organiser** is the person identified during onboarding and accepted through the
  confirmed automatic contract or a C1 exception decision.
- **standalone Project** in the current commercial language means a Client-owned Project
  without an Event, not a `FundProject` with `clientId = null`.
- **straight-through provisioning** means automatic Project provisioning after confirmation
  when every accepted protection passes.
- **exception review** means C1 intervention only for a submission that cannot be linked or
  provisioned safely and deterministically.

Trusted Event/standalone scope comes from the active C1-built form. Trusted existing-Client
ownership comes from an authenticated same-tenant Client-member relationship with adequate
Project-management access, or from a later explicit C1 exception decision. Public email,
organisation name, hidden IDs and raw payload values are evidence only and never establish
existing-Client ownership by themselves.

## 4. Accepted Business Contract To Preserve

The planning baseline already establishes:

1. C1 builds, configures and activates each Project Intake form for a defined offer.
2. A form is either Event-scoped or standalone. An Event form is bound to its C1-selected
   Event; a standalone form creates no Event link.
3. The form may be linked or safely embedded in a contextual C1 webpage. That webpage does
   not supply or override trusted Project scope.
4. A confirmed submission normally provisions automatically. C1 does not moderate every
   incoming Project.
5. Automated checks must send ambiguous, conflicting or unsafe cases to exception review
   without creating partial operational records.
6. A new Client/first-Project outcome requires a real organiser profile and login-capable
   account, not only `FundProject.organiserName` text.
7. An existing Client may be selected automatically only through an authenticated,
   authorised Client-member context; public identity claims never silently link a Client.
8. Every resulting Project is owned by its resolved `FundClient`.
9. The organisation address and organiser details accepted from the confirmed submission
   are copied once into the initial Project delivery profile.
10. The resulting delivery profile is Project-owned and later editable; it does not remain
   live-linked to intake JSON, Client contact snapshots or organiser account details.
11. First-pass fulfilment is Project bulk delivery to this confirmed organiser destination.
12. No Store is published and no Commerce, payment, production or commission workflow is
   triggered merely because Project provisioning succeeds.

## 5. Reconciled Implemented Baseline And Gaps

### 5.1 The Project Intake lifecycle already exists

The full `1P-G` record confirms that Project Intake is an implemented and live workflow,
not a future form-building task. The current application already has:

- `FundProjectIntakeForm`, `FundProjectIntakeSubmission`, confirmation states and tokens;
- C1 form-definition API/services and form-management UI;
- C1 submission review API/services and moderation UI;
- explicit C1 approval API/services and approval UI;
- live public `/fund/project-initiation/[formSlug]` routes;
- general and trusted Event-scoped forms;
- required Project start/close dates and Event-bound validation;
- bounded organisation-type selection;
- `CONFIRMATION_PENDING -> SUBMITTED` email-confirmation behaviour;
- the narrow, branded transactional confirmation email exception;
- approval transactions and basic retry idempotency through approved record IDs;
- `FundClient`, `FundClientMember`, `User` and Client-member dashboard access;
- a service that creates or links a same-tenant platform `User` for a Client member without
  sending email;
- auth routing that recognises only active, non-archived, dashboard-enabled Client members
  with access above `NONE` and an active Client;
- `FundProjectDeliveryProfile` from `1R-C2`;
- same-tenant Client, Event and Project relations.

The 1P-G public remediation passed local/staging review and was promoted live at the
recorded `b1ee0fd` baseline. That implementation is the operational starting point, not a
constraint that can overrule the later and more complete business model. `1P-G-R3` should
reuse its proven route, confirmation, moderation and approval infrastructure where it
still fits, while reworking the form structure, typed data contract and approval outcome
where the accepted Client/organiser/Project/delivery contract now requires it. It must not
create a duplicate intake framework or claim that the existing capabilities are new.

### 5.2 Gaps this slice must resolve

The public form currently collects the organisation address as one free-text value in the
payload. The typed submission record has no structured organisation-address columns and no
reliable split organiser name.

The current approval actions create/link a Client and create a Project, but do not:

- create or match the organiser `FundClientMember`;
- create or link the organiser's platform `User`;
- create the initial `FundProjectDeliveryProfile`;
- record the approved member or delivery-profile identity on the submission;
- prove that the whole provisioning outcome completed atomically.

The current approval UI also offers `CREATE_PROJECT_STANDALONE`, meaning a Project with no
Client. That meaning conflicts with the accepted first-Project contract and with the later
use of “standalone” to mean not Event-linked.

Although `FundProjectIntakeForm.requiresModeration` already exists, the current C1 UI forces
it to `true` and the confirmation path stops at `SUBMITTED`. The application therefore has
no implemented straight-through provisioning path, no recorded automated-decision evidence
and no bounded exception reason that explains why a confirmed submission needs C1 review.

The form also allows Event/standalone flags to be combined more loosely than the revised
contract. Activation must instead validate exactly one trusted scope. Contextual webpages
may describe Father's Day, Christmas, Logo Drinks Bottles or another offer, but only the
stored form configuration may determine the Project's Event and other locked defaults.

### 5.3 Historical-document reading rule

Earlier 1P-G planning correctly described Client members, public forms, confirmation and
approval as future work at the time each document was written. Later 1P-G and K1-F
implementation confirmations supersede those time-bound status statements.

The historical documents remain evidence and must not be rewritten to pretend the later
implementation already existed. This `1P-G-R3` plan is the current reconciliation layer.

### 5.4 Decision precedence for this alignment

Where the earlier 1P-G/K1-F implementation and the later accepted 1R-C/1P-G-R3 understanding
conflict, the contract that best supports the current Project lifecycle wins. In
particular, the current rules that every new Project has a C2 Client owner, a real organiser
account and an initial Project delivery profile take precedence over preserving the exact
shape of the earlier intake form.

The existing implementation should be retained selectively:

- preserve tenant isolation, trusted Event scoping, exception-review authority, confirmation
  security, audit history and historic submission readability;
- preserve stable public URLs where feasible so issued links and QR codes continue to work;
- reuse tested services and UI components where their contracts remain correct;
- rework steps, labels, field shapes, validation, payloads and approval controls whenever
  that produces the clearer and safer current workflow;
- migrate compatibly rather than forcing the new model to imitate obsolete form choices.

This is deliberate evolution of the live intake workflow, not a requirement to preserve
its current screen design or payload shape unchanged.

### 5.5 Complete 1P-G traceability and residual contracts

The whole 1P-G lifecycle is normative implementation evidence. `1P-G-R3` must trace every
implemented surface or explicitly record why the later contract supersedes it:

| 1P-G evidence | Implemented contract to preserve or deliberately replace in 1P-G-R3 |
| --- | --- |
| C / C2 schema | Tenant-scoped form/submission identities, source vocabulary, hash-only confirmation fields, expiry/idempotency indexes and archive-safe history remain additive migration inputs. |
| D0 trusted-scope planning | Existing Client ownership never comes from public email/name/hidden IDs. Authenticated Client-dashboard direct Project creation remains a separate valid lane; a form is an additional offer-driven lane, not its replacement. |
| D1 form API/services | DRAFT/ACTIVE/PAUSED/ARCHIVED lifecycle, same-tenant Event validation, active windows, submission limits, safe archiving and non-exposure of token internals remain authoritative. |
| D2 submission review API/services | Tenant-scoped search/status/detail, raw/source evidence and secret-field stripping are reused for the exception queue. |
| D3-A approval API/services | Existing transactional/idempotent Client/Project creation is refactored into the common provisioning transaction; clientless creation is retired for new writes. |
| E C1 admin UI | Existing form administration, submission tables and protected C1 routes are evolved into form-policy management and exception review rather than duplicated. |
| F-A public form | Public slug routes, branded form, server-side token generation, hash-only storage, expiry, hash clearing, `confirmedAt`/`submittedAt`, safe status pages and the bounded confirmation email are preserved. |
| F-A-R2 remediation | Public middleware access, plain branded shell, trusted Event/date rules, bounded organisation types and safe unavailable states remain regression requirements. |
| R2 review/live promotion | The `b1ee0fd` live baseline and its local/staging smoke evidence are the minimum regression baseline, not merely historical planning. |
| K1-F-A/B | Same-tenant User/member state, access routing and link/create security are reused; automatic existing-Client linkage adds the stronger `PROJECT_MANAGER`/`ADMIN` requirement. |
| K2-A/B/C | Authenticated `PROJECT_MANAGER`/`ADMIN` direct Project creation is implemented and reviewed. The form-driven existing-Client lane complements it, reuses its trusted membership/Event/date/project-type/idempotency rules and must not replace or weaken it. |

The audit also preserves these previously deferred or caveated facts:

- `publicTokenHash` on the form remains dormant schema support; the implemented public
  route is slug-based and `1P-G-R3` does not silently invent a form-token issuing system;
- `PUBLIC_EMBED` is currently source vocabulary, not proof of implemented iframe support;
  the live route can be linked from contextual pages, but real third-party embedding still
  requires route-specific CSP/frame policy and an origin allowlist in a separate accepted
  slice;
- `SEASONPRO_CLUB` and `CLIENT_DASHBOARD` source values do not by themselves mean those
  Intake integrations exist;
- the historic `returnToReview` service permits a broader set of source statuses than the
  UI exposes; `1P-G-R3-C` must define an explicit exception retry/resolve state machine rather
  than enabling that action unchanged;
- confirmation token hashes, idempotency keys and fingerprints remain excluded from C1 and
  public payloads;
- existing branding fallback and branded confirmation-email wrapper must regress cleanly;
- Event media now exists through `1R-C2`, but optional display of trusted Event media does
  not permit external URLs or make media a provisioning authority;
- notification-template management, invitation sending, real iframe embedding, SeasonPro
  integration and broader communications remain separate work.

The audit found a related downstream inconsistency outside the Intake boundary: implemented
K2 direct C2 Project creation and the generic C1 Project create service both predate
`FundProjectDeliveryProfile` and currently create a Project without creating that profile;
the C1 service also still permits clientless Projects and organiser snapshots without a
typed organiser member. `1P-G-R3` must not silently broaden itself to repair those paths.
A separately named Project Creation Contract Alignment plan is required before Projects
from every creation source can be treated uniformly delivery-ready or Store-ready.

Documentation-evidence debt identified by the retrospective audit:

- `1P-G-D1` and `1P-G-D2` have implementation confirmations but no separate slice-specific
  `05-review-and-test` records;
- `1P-K1-F-A` and `1P-K1-F-B`, now critical dependencies, likewise have implementation
  confirmations but no separate review/test records in this documentation tree;
- the D3-A review explicitly recorded that representative authenticated API smoke evidence
  was still missing at that point;
- the E review deliberately left `returnToReview` unexposed because its source-status policy
  was unresolved;
- the R2 review requested a later batched remediation CR, but no matching completed CR or
  batch-remediation lifecycle record was found in the FUND documentation tree.

These absences do not prove that the implemented code is defective, and later UI/staging/live
reviews exercise parts of D1/D2 indirectly. They do mean `1P-G-R3` must not cite a complete
slice-by-slice review chain that does not exist. The R3-A/R3-B/R3-C child reviews must explicitly
regress the inherited form, review, auth-routing and User/member behaviours and close the
evidence gap prospectively; no backdated review records should be invented.

## 6. Bounded Scope

The `1P-G-R3` family may plan only the following alignment of the existing workflow. The
parent document authorises no direct implementation, and each item must be allocated to
the accepted R3-A/R3-B/R3-C child boundary before work begins:

- explicit Event-versus-standalone form activation rules and trusted C1 form defaults;
- straight-through provisioning after confirmation when automated protections pass;
- retained C1 review only for bounded exceptions or an explicitly manual legacy form;
- typed first-Project organisation-address and organiser-name intake fields;
- minimal supporting identity keys and approval-result evidence;
- public form step, field, copy, payload and submission-validation rework needed to capture
  and explain those fields clearly;
- C1 exception-review fields needed to confirm or correct them;
- atomic create/link Client, create/link organiser User/member, create Client-owned
  Project and create initial delivery-profile behaviour;
- retirement of clientless Project approval from this intake route;
- idempotency, tenant isolation, audit and rollback protection for that outcome;
- bounded automated abuse, duplicate, identity, form/Event/date and account-access checks;
- focused automated and disposable-database verification.

It must not implement:

- authenticated C2 dashboard creation of additional Projects;
- generic C1 Project creation and the separately required all-source Project Creation
  Contract Alignment;
- a Client address book or live Client default-address model;
- invitations, onboarding email, automatic magic-link delivery or notifications;
- an unrelated replacement intake framework, avoidable public-URL breakage, a new
  confirmation-token system or expansion of the bounded transactional confirmation email;
- Store creation, configuration, readiness, commission acceptance or publication;
- Commerce checkout, Orders, Order lines, payments, refunds or pro-forma invoices;
- Product selection, artwork upload, production, dispatch or commission calculation;
- `1R-C6`, `COMMERCE-A2` or another slice.

## 7. Proposed Schema Alignment

### 7.1 Form authority and automation policy

Retain the existing C1-owned `FundProjectIntakeForm` and give its current fields explicit
operational meaning:

```text
defaultEventId present + allowStandaloneProjects false -> EVENT form
defaultEventId null + allowStandaloneProjects true     -> STANDALONE form
requiresModeration false                               -> automatic with exception review
requiresModeration true                                -> explicit manual-review form
```

No other Event/standalone combination may be newly activated. Existing records are not
silently rewritten; a C1 user must review and save a legacy form into a valid shape before
enabling automatic provisioning.

Add a nullable `defaultProjectTypeCode` and a bounded
`allowProjectTypeSelection` form flag plus a bounded `allowedProjectTypeCodes` configuration.
This allows C1 to build a form for a fixed offer such
as Logo Drinks Bottles or a wider Event campaign:

- when a default type exists and selection is disabled, the trusted form type is copied to
  the Project and the public user cannot change it;
- when selection is enabled, the public form presents only the non-empty, C1-configured
  subset of accepted bounded Project types;
- surrounding-page text may explain the offer but cannot provide or override the type.

New forms should default in the C1 UI to automatic-with-exception-review. The existing
database default and existing forms must remain behaviourally safe through deployment;
automatic provisioning begins only after C1 explicitly saves/activates the aligned form.

Add nullable aligned-form contract evidence equivalent to:

```text
alignedScope
formContractVersion
formPolicyRevision
```

`alignedScope` is a bounded `EVENT` or `STANDALONE` value. Version `1` requires revision
`1` or greater and an exact match between the scope, `defaultEventId` and the retained
`allowStandaloneProjects` compatibility field. Legacy rows keep all three fields null and
remain manual. Saving `requiresModeration = false` by itself never opts a form into automatic
provisioning. The C1 service increments `formPolicyRevision` whenever Event/standalone scope,
Project-type policy or another provisioning-authority field changes.

`allowExistingClientSelection` means that the form can offer an **existing Client sign-in**
path. It must never expose a public Client picker.

### 7.2 Typed submission capture

Add nullable typed fields to `FundProjectIntakeSubmission` for evidence submitted or
confirmed during review:

```text
respondentFirstName
respondentLastName
proposedClientAddressLine1
proposedClientAddressLine2
proposedClientAddressLine3
proposedClientLocality
proposedClientRegion
proposedClientPostalCode
proposedClientCountryCode
```

Keep the existing `respondentName`, proposed Client contact fields and `rawPayload` for
compatibility and source evidence. New services must not parse historic free-text address
or split historic names to invent typed values.

For new public submissions, first name, last name, address line 1, locality, postal code and
two-letter uppercase country code are required. Optional address lines and region remain
nullable.

### 7.3 Provisioning and automated-decision evidence

Add nullable fields to `FundProjectIntakeSubmission`:

```text
approvedClientMemberId
approvedProjectDeliveryProfileId
trustedInitiatingClientId
trustedInitiatingClientMemberId
provisioningContractVersion
provisioningCompletedAt
provisioningPath
automationPolicyVersion
automationEvaluatedAt
exceptionReason
submittedFormContractVersion
submittedFormPolicyRevision
```

Add bounded Fund-prefixed enums equivalent to:

```text
FundProjectIntakeProvisioningPath
  AUTOMATED
  C1_REVIEW

FundProjectIntakeExceptionReason
  EXISTING_CLIENT_AUTH_REQUIRED
  INSUFFICIENT_CLIENT_ACCESS
  AMBIGUOUS_CLIENT_MATCH
  IDENTITY_CONFLICT
  INACTIVE_OR_ARCHIVED_ACCOUNT
  POSSIBLE_DUPLICATE
  FORM_POLICY_CHANGED
  EVENT_OR_DATE_INVALID
  RATE_OR_ABUSE_LIMIT
  AUTOMATED_POLICY_FAILURE
```

The submitted form contract/revision is server-written at submission and compared with the
current aligned form at confirmation. A mismatch cannot provision automatically and records
`FORM_POLICY_CHANGED` for bounded C1 review. Historic submissions keep both values null.

The exception reason is operational evidence, not a public diagnostic. Public responses
must remain generic and must not disclose whether a Client, member or User exists.

`provisioningContractVersion = 1` means the aligned outcome completed and requires:

- approved Client;
- approved organiser Client member;
- approved Project;
- approved Project delivery profile;
- provisioning completion timestamp;
- the automated or C1-review path that created or linked a Client and created a
  Project;
- automation version/evaluation evidence for an automated result.

The linked `FundClientMember.userId` proves the login-capable User relation; the submission
does not need a duplicate `approvedUserId`.

The trusted initiating identities are written only by the server when an authenticated
existing Client member submits. They are not accepted from a public payload. This lets the
email confirmation link work in another browser while the confirmation service still
revalidates the exact member's current Client, status, access and dashboard eligibility
before provisioning.

Historic approved submissions retain null provisioning fields and remain readable. They
must not be labelled aligned or Store-ready by inference.

For a submission sent to exception review, `provisioningCompletedAt` remains null,
`exceptionReason` is required and no Client, User, member, Project or delivery profile is
created. A later C1 decision records `C1_REVIEW` and retains the original exception reason
as historic evidence. An intentionally manual aligned form may also complete through
`C1_REVIEW`, but has no exception reason unless an exception actually occurred.

### 7.4 Exact composite identity

Add only the supporting keys required to prove exact approved ownership:

```text
FundClientMember(organizationId, id, clientId)
FundProjectDeliveryProfile(organizationId, id, projectId)
```

Use them for exact same-tenant relations:

```text
submission approved member
  -> belongs to submission.approvedClientId

submission approved delivery profile
  -> belongs to submission.approvedProjectId

submission trusted initiating member
  -> belongs to submission.trustedInitiatingClientId
```

Database checks should enforce the provisioning-version/completion shape and uppercase
country-code shape when typed country data exists. Application validation remains
responsible for complete address and email/phone semantics.

No new Client-address model is included. The typed intake address is approval evidence and
the delivery profile is the mutable live Project destination.

## 8. Public Intake Rework On The Existing Workflow

The existing live route, submission lifecycle and exception-review boundary remain the foundation,
but the multi-step form itself may be reworked to express the accepted onboarding contract
cleanly. At minimum, replace the single organisation-address textarea with structured
fields using ordinary public language:

```text
Address line 1
Address line 2
Address line 3
Town or city
County or region
Postcode
Country
```

Retain the Main organiser concept, but its placement, copy and field grouping may change.
Persist first and last name separately as well as the existing display-name snapshot.
The form should read as one coherent first-Project onboarding journey, not as old fields
with corrective fields appended later.

Rules:

- public payloads never supply trusted Client, Event, member, User or Project IDs;
- Event scope continues to come from the server-resolved active form/default Event;
- standalone scope comes from the active form with no Event, never from a clientless mode;
- trusted fixed Project type comes from the form when configured;
- Event and standalone forms retain their accepted Project-date requirements;
- an existing-Client option routes through authentication and server-derived eligible
  Client memberships; it is not a public Client-name search;
- input normalization occurs before fingerprint/idempotency calculation so a retry with
  equivalent normalized data returns the same pending submission;
- `rawPayload` remains evidence, not the source used to provision operational records;
- confirmation security and C1 exception-review authority remain unchanged, although the
  review presentation and approval inputs may be reorganised around the aligned contract.

The existing narrow transactional confirmation email remains operational. Confirmation is
the trigger for automated evaluation: a valid automatic form either provisions atomically
and reaches `APPROVED`, or remains unprovisioned and enters the exception queue. `1P-G-R3`
must not turn this into a general workflow email or add approval/onboarding messages.

The initial UI may use a bounded country selector producing an uppercase two-letter code.
No external address lookup or geocoding is required.

## 9. Automated Protection And C1 Exception Contract

### 9.1 Straight-through protection gates

Automatic provisioning is allowed only when every gate passes in the same current request:

1. the form is active, inside its start/end window and below its submission limit;
2. its Event-versus-standalone shape and Project-type policy are valid;
3. any Event is active, same-tenant and the submitted Project dates remain within its
   accepted bounds;
4. the confirmation token is valid, single-use and matches the normalized submission;
5. form/source rate limits, replay/idempotency and bounded abuse checks pass;
6. required terms/consents and structured organiser/delivery fields are present;
7. no conflicting completed result or probable duplicate Project exists;
8. the Client/organiser identity can be resolved by one of the safe paths below;
9. every same-tenant key and K1-F User/member state is valid;
10. the whole provisioning transaction can commit atomically.

Failure of a business/identity gate creates no operational records and records one bounded
exception reason for C1. Invalid tokens, rate limits and obvious abuse may fail safely
without entering a human queue where doing so would amplify abuse.

### 9.2 New Client path

For a respondent creating a new Client, successful email confirmation proves control of
the submitted email for this transaction. Automatic creation is allowed only when there is
no conflicting same-tenant Client membership, inactive/archived identity, cross-tenant User
ownership problem or strong duplicate-Client signal.

Organisation-name similarity alone must neither link an existing Client nor reject a valid
new one. A possible duplicate or identity conflict enters exception review.

### 9.3 Existing Client path

Automatic linkage to an existing Client requires an authenticated active, non-archived
member of that exact Client with dashboard access and `PROJECT_MANAGER` or `ADMIN` access.
At submission, the server derives and records the exact trusted Client/member identities
from the authenticated session. At email confirmation, it revalidates those recorded
identities and their current access; the confirmation request does not depend on retaining
the original browser session.

A public email match, organisation name, hidden input or confirmation token is never enough
to claim an existing Client. An unauthenticated respondent who appears to match an existing
member is directed to sign in without revealing account existence; an unresolved submitted
case enters exception review and creates no duplicate Client or Project.

### 9.4 Exception review

The retained C1 exception page must display and allow explicit confirmation/correction of:

- C2 Client organisation identity;
- structured organisation/delivery address;
- main organiser first name, last name, email, phone and role;
- Project identity, dates and the form-authoritative Event or standalone scope;
- create-new versus link-existing Client choice;
- for an existing Client, whether the matching/new organiser member should become the
  Client's primary member when another primary member already exists.

For a newly created Client, the confirmed organiser becomes its primary active member with
`PROJECT_MANAGER` access and dashboard access. For an existing Client, the authenticated
submitting member is the organiser for straight-through provisioning. Selecting or creating
a different organiser requires C1 exception review; existing primary-member status must not
be silently reassigned.

The current clientless `CREATE_PROJECT_STANDALONE` approval action must not remain available
for newly aligned approvals. A Project without an Event is represented by leaving `eventId`
empty while still selecting or creating its owning Client.

The existing `FundProjectIntakeForm.allowStandaloneProjects` field remains for compatibility
but its current meaning is clarified as **allow a Project without an Event**. It must not
authorise a Project without a Client. The historical
`FundProjectIntakeModerationDecision.CREATE_PROJECT_STANDALONE` value remains readable for
old evidence but is not written by the aligned service.

Historic clientless Projects and historic approval evidence are preserved unchanged.

## 10. Atomic Provisioning Contract

One top-level server-side transaction must:

1. load and lock, or conditionally claim, the same-tenant submission;
2. return the existing complete result for a previously aligned approved submission;
3. reject a partial/inconsistent prior result for controlled remediation rather than
   creating replacements silently;
4. revalidate the current form, confirmation, Event/standalone/type/date, automation and
   identity/access gates, including the submitted form contract/revision and any trusted
   initiating Client/member snapshot;
5. create a new C2 Client or select the exact authenticated authorised C2 Client;
6. create or match the organiser's same-tenant platform `User` using the established
   Client-member policy;
7. create or match the organiser `FundClientMember` for that Client;
8. create the DRAFT Client-owned Project with the Event or standalone scope fixed by the
   form and the accepted Project type copied into Project metadata;
9. create its initial `FundProjectDeliveryProfile` from the confirmed structured values;
10. update the submission to `APPROVED` with every operational identity, provisioning path,
    automation version and completion timestamp;
11. write the meaningful automated or exception-review provisioning audit evidence;
12. commit all records together.

Any failure must roll back Client, User, member, Project, delivery profile, submission and
in-transaction audit mutations together.

The existing Client-member user-link/create policy should be refactored into an internal
transaction-capable helper and reused. The Project Intake service must not copy a second,
divergent User security policy.

That reuse does not authorise silent mutation of an existing User. If a same-tenant User
already exists, Intake must preserve established identity/security state and route a
conflicting name, status, membership or tenant condition to review. A confirmation may
support verified-email evidence for this Intake transaction, but it must not reactivate a
suspended/deletion-requested User or overwrite unrelated profile data merely to provision.

Likewise, K2's accepted Project-number/slug creation, Project-type vocabulary,
same-tenant Event/date checks and `PROJECT_MANAGER`/`ADMIN` permission rules should be
factored or reused where compatible. `1P-G-R3` must not create a third divergent set of
Project creation rules, but it must add its own form authority and atomic delivery-profile
outcome.

No email, invitation or notification is sent by the transaction.

### 10.1 K1-F access-state compatibility

K1-F deliberately separates:

```text
Client member/contact
-> linked platform User
-> active member/access level
-> dashboard access enabled
-> authentication routing
```

`1P-G-R3` must preserve that separation. For the new-Client/first-Project organiser, the
confirmed automatic form contract creates/links the User plus an `ACTIVE`, non-archived
Client member with `PROJECT_MANAGER` access and dashboard access enabled. This is the
minimum role consistent with the organiser later managing the Project and its delivery
details. An exception-reviewed outcome must create the same safe access shape unless C1
expressly selects a stronger accepted role.

Creating or linking the User does not send a magic link, invitation or onboarding email.
The organiser uses the existing authentication flow after the sign-in route is communicated
separately. Existing K1-F auth routing and access guards remain authoritative and must pass
regression testing.

## 11. Matching And Idempotency

### 11.1 Client

The automatic new-Client path creates a Client only when identity and duplicate gates pass.
The automatic existing-Client path uses only an authenticated eligible membership. C1
explicitly chooses create-new or link-existing only in the exception path. Name, email and
duplicate hints are advisory and never establish existing-Client ownership. Cross-tenant
Client IDs are rejected safely.

### 11.2 User and Client member

Normalize organiser email before lookup.

- reuse a valid same-tenant User with that email according to the established service;
- reject a User owned by another tenant;
- reject suspended or deletion-requested Users;
- reuse an existing member with the normalized email inside the selected Client;
- otherwise create one member linked to the selected/created User;
- do not silently reactivate an archived/inactive member; send the submission to exception
  review and require a separately managed member correction before provisioning;
- never create two members for the same Client/email or two members for the same
  Client/User;
- never silently link the respondent to a different Client merely because an email matches.

### 11.3 Provisioning retries and concurrency

- a retry after successful provisioning returns the recorded Client/member/Project/delivery
  result;
- two concurrent confirmation/provisioning attempts cannot create two operational outcomes;
- a failed transaction leaves the submission eligible for a clean retry;
- the existing submission idempotency/fingerprint contract remains responsible for public
  submission retries, while the provisioning claim/result fields protect operational
  ownership.

## 12. Migration And Existing-Data Policy

`1P-G-R3-A` may use one bounded additive migration after the accepted C5 baseline.
`1P-G-R3-B` and `1P-G-R3-C` must use that accepted schema and add no further migration
unless review finds a genuine missing invariant and creates a separately accepted schema
amendment.

Because active forms and historic submissions already exist, rollout order is part of the
contract:

1. add nullable form/submission fields, enums and exact keys without changing existing rows;
2. deploy compatible readers and C1 form/exception inputs that can display legacy records;
3. switch the existing public form to write the structured fields for every new request;
4. require C1 to review/save a valid form scope before it can opt into automation;
5. enable automatic provisioning only for aligned forms and require version-1 evidence for
   every new automated or exception-reviewed completion;
6. leave historic and already-approved submissions on the legacy contract unless a later
   explicit operator remediation is performed.

Migration rules:

- add nullable submission fields first;
- add the bounded Fund-prefixed decision/exception enums and form default-type fields;
- add the nullable aligned-form scope/contract/revision and submission contract/revision
  snapshot fields;
- add exact supporting composite keys;
- add same-tenant relations, checks and indexes with explicit bounded names;
- create no Client, User, member, Project or delivery-profile row;
- perform no raw JSON parsing, address splitting, name splitting or approval inference;
- preserve every existing submission and operational record exactly;
- leave all historic `provisioningContractVersion` and `provisioningCompletedAt` values null;
- retain all existing forms as manual-review behaviour until C1 explicitly validates and
  opts each form into automatic provisioning;
- do not modify shared development, staging or production databases during review.

Rollback before shared deployment is migration/code reversion on the disposable database.
After shared writes exist, rollback must preserve approved operational evidence and requires
a separately reviewed forward-remediation plan.

## 13. Expected Child Application Areas

Likely implementation areas are divided as follows:

```text
1P-G-R3-A
prisma/schema.prisma
prisma/migrations/<one 1P-G-R3-A migration>/migration.sql
schema migration/constraint verifier

1P-G-R3-B
src/modules/fund/lib/validation/project-intake.ts
src/modules/fund/services/project-intake.service.ts
src/modules/fund/services/client-members.service.ts
src/modules/fund/routers/project-intake.router.ts
focused service/transaction verifier files

1P-G-R3-C
src/modules/fund/components/project-intake-public/PublicProjectInitiationForm.tsx
src/modules/fund/components/project-intake/ProjectIntakeApprovalPage.tsx
src/modules/fund/components/project-intake/ProjectIntakeSubmissionDetailPage.tsx
public confirmation/status route components
focused UI/route/end-to-end verifier files
```

Stable public and C1 route families should be retained wherever feasible, particularly for
already-issued public links. Internal procedures and component composition may be revised
when the existing contracts cannot carry the aligned model clearly. Do not create an
unrelated parallel Intake framework.

## 14. Validation Plan

### 14.1 Static and generated-client checks

- Prisma format/validate/generate;
- migration/schema contract verifier;
- TypeScript type-check;
- focused lint;
- critical-file and repository checks;
- `git diff --check` in application and documentation repositories.

### 14.2 Disposable PostgreSQL migration checks

Using only `TEST_DATABASE_URL`, after proving it differs from `DATABASE_URL`:

- representative existing-data migration from the complete preceding migration set;
- fresh replay of the complete migration history;
- exact preservation of historic pending, reviewed and approved submissions;
- zero inferred provisioning versions or approved member/delivery IDs;
- valid aligned evidence creation;
- rejection of an aligned automatic form without explicit contract/scope/revision evidence;
- rejection of invalid Event/standalone/type-policy shapes and safe handling of a changed
  form revision between submission and confirmation;
- rejection of wrong-tenant/wrong-Client member and wrong-Project delivery-profile links;
- rejection of a trusted initiating member that does not belong to the recorded trusted
  initiating Client;
- provisioning shape, country-code and supporting-key checks;
- restrictive deletion evidence where an approval record references operational output;
- zero test residue.

### 14.3 Service and transaction checks

- automatic new Client/first Project confirmation creates exactly one Client, User, primary
  `PROJECT_MANAGER` member, Project, delivery profile and completed submission result;
- automatic existing Client confirmation requires an authenticated `PROJECT_MANAGER` or
  `ADMIN` at submission, records the exact Client/member, revalidates current access at
  confirmation, reuses that member and does not change another primary member;
- existing Client email confirmation succeeds safely without the original browser session
  when the recorded member remains eligible;
- Event form creates only the form-linked Event Project; standalone form creates only a
  Client-owned Project with no Event;
- fixed form Project type cannot be overridden by the public payload;
- selectable Project type accepts only the bounded configured values;
- clientless intake approval is rejected/removed;
- cross-tenant Client, Event, User and relation attempts fail safely;
- duplicate Client/member/User/Project identifiers fail without partial writes;
- ambiguous Client, inactive membership, identity collision, possible duplicate, stale
  form/Event/date and safe policy failures create no operational rows and enter the bounded
  exception path;
- invalid tokens, replay, rate limits and obvious abuse fail without leaking account data;
- injected failure after each provisioning stage rolls back the whole outcome;
- repeated and concurrent confirmation/provisioning returns one stable outcome;
- no email, invitation, Store or downstream workflow is emitted;
- explicitly manual legacy forms retain their existing review workflow;
- existing Project Intake exception review/confirmation and Client-member management
  regressions pass;
- K2 authenticated direct Project create/edit and C1/C2 route-separation regressions pass;
- existing K1-F access routing continues to reject inactive, archived, `NONE` or
  dashboard-disabled membership;
- the existing confirmation email remains the only intake email; confirmation of an aligned
  automatic form either completes one atomic provisioning result or records a safe exception
  without partial operational records.

### 14.4 UI and route checks

- public structured address and organiser fields validate and serialize correctly;
- Event-scoped and standalone forms display their C1-defined context and preserve trusted
  Event/date/type behaviour;
- contextual webpage/embed inputs cannot override Event, standalone or fixed Project type;
- existing-Client selection requires sign-in and shows only server-authorised memberships;
- the existing public route remains unauthenticated and the existing C1 route remains
  authenticated/admin-only;
- the existing check-email, confirm, submitted, expired and safe-unavailable states remain
  functional;
- ordinary safe submissions do not require C1 action;
- C1 exception review shows the structured evidence, bounded reason and explicit
  organiser/member outcome;
- no clientless standalone option remains in the aligned approval UI;
- success state returns the complete approved identities without exposing internal or
  cross-tenant data;
- public route remains public and C1 review/approval/exception routes remain protected.

## 15. Acceptance Criteria For This Plan

The plan is ready for implementation acceptance only when review confirms:

- `1P-G-R3` is the correct parent alignment family and `1P-G-R3-A` through `1P-G-R3-C`
  each require a separate complete planning/implementation-confirmation/review-test
  lifecycle;
- automatic or exception-reviewed provisioning always produces a Client-owned Project and
  login-capable organiser;
- C1 form activation is the offer approval and normal confirmed submissions require no C1
  moderation;
- Event and standalone form scopes are mutually exclusive and form-authoritative;
- existing Client linkage requires authenticated `PROJECT_MANAGER` or `ADMIN` authority;
- failed or ambiguous automated checks produce no partial operational records;
- no-Event and no-Client meanings are no longer conflated;
- structured intake evidence is sufficient to create the initial delivery profile without
  parsing free text or JSON;
- exact approved member/Client and delivery-profile/Project identities are tenant-safe;
- the provisioning result is atomic, idempotent and auditable;
- existing Client-member User policy is reused rather than duplicated;
- the later accepted Client/organiser/Project/delivery contract takes precedence over the
  exact earlier form layout and payload, with bounded form rework permitted;
- historic records receive no inferred data or false Store-ready status;
- Store, Commerce, new email behaviour and direct C2 additional-Project changes remain
  excluded;
- historic review gaps are stated honestly and covered prospectively rather than backfilled
  with invented evidence;
- future implementation confirmation and review/test records are not created prematurely.

## 16. Current Planning Questions

No business question is currently blocking initial review. This revision applies the direct
clarification that C1-built forms may offer Event or standalone Projects to new or existing
Clients and that ordinary submissions are protected automatically rather than moderated
one by one.

The initial safe rule is explicit: a new Client's confirmed organiser becomes its primary
`PROJECT_MANAGER`; an existing Client's straight-through organiser is the authenticated
eligible submitting member and existing primary status is unchanged. Any alternative enters
C1 exception review.

## 17. Single Review Prompt

```text
Review only FUND Phase 1 `1P-G-R3 - Project Intake Automated Provisioning Alignment` parent
planning. Do not implement schema or application code and do not begin 1P-G-R3-B, 1P-G-R3-C,
1R-C6, COMMERCE-A2 or another slice.

Verify its traceability against the complete implemented 1P-G planning, implementation,
review/remediation and live-promotion sequence; D0 trusted Client/idempotency decisions;
K1-F User/member/auth behaviour; implemented K2 authenticated Client Project creation;
implemented 1R-C2 delivery profile; and current Prisma, service, public route and C1 UI
contracts. Confirm the recorded review-evidence gaps and do not infer missing historical
reviews.

Treat the existing live forms and services as the operational starting point, not as an
immutable design. The later accepted Client/organiser/Project/delivery contract wins where
there is a conflict. Permit bounded rework of the existing form steps, copy, fields,
validation and exception presentation while preserving historic data, tenant/Event trust,
confirmation security, existing branding, source evidence and stable issued public URLs.

Confirm that C1 activation pre-authorises one Event or standalone form offer; ordinary
confirmed submissions provision automatically; existing Client linkage requires an
authenticated `PROJECT_MANAGER` or `ADMIN`; and ambiguous/unsafe cases create no operational
rows and enter bounded C1 exception review. Preserve the separate authenticated Client
dashboard direct-Project lane. Exclude real iframe embedding, Client address-book management,
new onboarding/approval email, generic C1/K2 Project-creation remediation, Store, Commerce,
production and commission behaviour. Record the separate all-source Project Creation
Contract Alignment dependency without implementing it here.

If acceptable, mark only the 1P-G-R3 parent accepted and create the bounded 1P-G-R3-A
Project Intake Automation Schema And Form Policy Foundation implementation plan. Leave
R3-A awaiting separate review/acceptance. Make no Prisma, migration, service, API, route or
UI changes.
```
