# IsoStack Core Platform Support Ticketing Client Readiness And Communications CR

Date: 2026-08-05

Owning lane: IsoStack Platform

Status: CR INPUT CAPTURED — AWAITING TRIAGE; NO IMPLEMENTATION AUTHORITY

Source: Client-readiness testing and requested code/document review of the shared Support
Centre and P1 Support Tickets dashboard

Application source reviewed:

```text
7154937cb620232b457b19d09c5dc97ae0417a73
```

IsoDocs parent reviewed:

```text
1a49081
```

Controlling documents:

- `docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`
- `docs/platform/00-roadmap-control/2026-07-22-isostack-platform-roadmap-and-slice-control.md`
- `docs/platform/01-cr-inputs/README.md`

## 1. Purpose And Authority Boundary

This CR consolidates the support-ticketing findings discovered while testing the capability
before it is enabled for clients. It covers tenant isolation, role authority, internal-note
privacy, notification routing and evidence, requester communications, P1 operational
reporting, lifecycle aging, classification filters and the proposed use of support-facing
communications for cross-tenant product announcements.

The concerns share the same Platform support capability and may be triaged and planned as one
coordinated change cycle. This does not mean they should be implemented as one indivisible
code change. Security and client-readiness corrections should be independently reviewable
from the proposed outbound-announcement capability.

This is a planning input only. It does not:

- authorise application, schema, migration, infrastructure or deployment changes;
- assign an executable slice identifier;
- change an authoritative roadmap or registered-work status;
- claim live-database row-level-security verification;
- record implementation or test evidence; or
- approve client enablement.

## 2. Executive Assessment

The static application review supports the following conclusions.

1. **Ordinary support-ticket reads and writes are tenant-filtered at the support router.** A
   non-P1 session is forced to its own `organizationId` for list access, and detail, update
   and comment operations reject a ticket whose organisation differs from the session.
   Therefore a C1 tenant Owner/Admin should not be able to read or change another tenant's
   ticket through the reviewed procedures.
2. **That confirmation is qualified.** The reviewed checks are application-router checks,
   not live database/RLS evidence. Within one tenant, access is not restricted to C1
   Owner/Admin or to the requester: every authenticated same-organisation user admitted to
   the procedure appears able to list, read, update and comment on every tenant ticket.
3. **The editable C1 lifecycle status is a server-authorisation defect as well as a UI
   defect.** Hiding the dropdown is insufficient because the shared update procedure allows
   any same-tenant authenticated user to submit any supported status and change priority.
   Client-facing close/reopen actions need their own explicitly permitted transition
   contract; P1 retains the full lifecycle-control contract.
4. **Internal notes are not presently a reliable privacy boundary.** The API returns the
   complete JSON discussion to same-tenant clients and the C1 page removes internal comments
   only in browser code. The comment procedure also accepts caller-supplied `isInternal`
   without requiring P1. A client capable of calling or inspecting the API may therefore see
   internal content or submit an internal-labelled comment. This is a serious pre-enablement
   finding.
5. **The notification model is incomplete and its routing is fragile.** New-ticket email is
   intended for a configured support destination, not as an acknowledgment to the requester.
   Requester notifications cover only a subset of P1 status changes and public P1 replies.
   Failures are logged but are not represented as durable delivery evidence or retryable
   work. Several identifier and category inconsistencies may also prevent the intended
   support destination from resolving.
6. **The P1 dashboard counts are not platform-wide live lifecycle counts.** The statistics
   query is always scoped to the P1 user's own organisation, omits `waiting-response`, and
   derives `closed` as a remainder. It can therefore report the wrong population and
   misclassify waiting tickets as closed.
7. **Severity and Impact do not yet exist in the ticket data model.** Category and Module
   exist, but the current P1 list accepts only Status, Module and Client. The visible ticket
   search control is not connected to query state.
8. **A single cross-tenant “ALL clients” record should not be modelled as a support ticket.**
   It has a different audience, privacy, lifecycle, read/dismissal and reply contract. The
   recommended design is a distinct P1 Platform Notice/Announcement capability that may be
   surfaced in the Support Centre and optionally delivered by email.

The internal-note boundary, server-side lifecycle permissions, tenant/requester access
contract and notification operability should be treated as client-enablement gates. The
Platform Notice design is useful but must not delay correction and validation of the core
support case flow.

## 3. Working Terminology

| Term | Meaning in this CR |
| --- | --- |
| P1 | Authorised Platform owner, manager or support operator with controlled cross-tenant support authority |
| C1 Tenant Owner/Admin | A client organisation's Core `OWNER` or `ADMIN`, operating inside that tenant |
| Client requester | The user for whom a support ticket was created and who receives the public case conversation |
| Support-operation recipient | The P1-configured mailbox that receives and operates support work; it may belong to an external support company and need not be a P1 user's address |
| Public reply | A ticket message visible to the client requester/authorised tenant viewer |
| Internal note | A P1-only support-operation note which must never be returned to a client procedure or accepted from a client actor |
| Ticket status | Platform-controlled case lifecycle state: open, in progress, waiting for response, resolved or closed |
| Client close/reopen action | A deliberately bounded client request/transition, not general permission to select any lifecycle state |
| Priority | Operational ordering or urgency; currently stored as low, medium, high or urgent |
| Severity | Degree of product/service degradation |
| Impact | Breadth and business consequence for affected users, organisations or workflows |
| Platform Notice | A separately governed one-to-many P1 communication with an audience and publication lifecycle; not a support case |

## 4. Affected Roles, Tenants And Ownership

| Actor or lane | Required boundary |
| --- | --- |
| P1 Platform support operator | Cross-tenant queue under explicit P1 authority; may triage lifecycle, priority, severity, impact, assignment and internal notes; real actor retained in audit |
| C1 Tenant Owner/Admin | Tenant-only support visibility under the accepted tenant policy; may create and reply and may use explicit client close/reopen actions; cannot set arbitrary support lifecycle state, priority, severity, internal notes or support routing |
| C2 / Core Member | No cross-tenant access. Same-tenant organisation-wide versus requester-only visibility requires an explicit policy rather than inheriting the current broad same-org behaviour |
| Public/unauthenticated user | No access to tenant support cases, discussions, contact details or configured support recipients |
| LMSPro / SeasonPro | Consumer and discovery surface only; support infrastructure remains Platform-owned. Module classification may reference LMSPro without moving ownership |
| FUND | Consumer only when FUND is selected as ticket module; no FUND business-logic change is implied |
| Commerce Core | Consumer only when Commerce is selected as ticket module; no Order, payment or money-lifecycle change is implied |

Support infrastructure, shared communication routing, tenancy, permissions, audit and P1
administration are all within the Platform ownership boundary established by the controlling
Platform roadmap.

## 5. Confirmed Current Implementation

### 5.1 Tenant filtering exists at the application router

`src/server/core/routers/support.router.ts` currently applies these checks:

- `list` forces `organizationId` to the session organisation for a non-P1 user;
- `getById` rejects a non-P1 user when the selected ticket belongs to another organisation;
- `update` applies the same cross-organisation rejection; and
- `addComment` applies the same cross-organisation rejection.

This is affirmative code-level evidence for tenant scoping of the reviewed support
procedures. It is not evidence of live database RLS, direct database-client isolation,
unreviewed endpoints or deployed-environment parity.

The current label `My Tickets` is misleading because the query returns the tenant's tickets,
not necessarily only tickets created by the signed-in user.

### 5.2 Same-tenant authority is broader than the requested C1 contract

The router distinguishes P1 from non-P1 but does not distinguish Core `OWNER`, `ADMIN` and
`MEMBER` for ticket list, detail, update or comment access. It also does not require a
non-P1 caller to be the ticket creator. Consequently, tenant isolation and same-tenant
least-privilege are separate questions: the first is implemented in the reviewed router,
while the second is not yet expressed.

### 5.3 C1 status editing is implemented in both browser and server

`src/app/(app)/support/page.tsx` displays:

- a client-relevant Close Ticket/Reopen action;
- a full status dropdown containing every lifecycle status; and
- an Add Reply action.

`support.update` accepts both `status` and `priority` for any same-organisation caller. It has
no role-specific transition matrix. The correction must therefore remove or replace the C1
dropdown and enforce the same boundary at the server. P1's platform detail modal may retain
full lifecycle editing.

### 5.4 Internal comments are filtered only after disclosure

The ticket discussion is stored as an untyped JSON array. `getById` returns the entire ticket
record, including the complete discussion. The C1 page then performs
`comment.isInternal === false` filtering in the browser. This means the private content has
already crossed the server/client boundary.

In the other direction, `addComment` accepts `isInternal` directly from any authenticated
same-tenant caller. The P1 UI currently sends `false`, but UI behaviour is not an
authorisation boundary.

Internal/private comments require server-side write authority and response shaping. A later
slice should also assess replacing the JSON discussion with typed comment records so that
visibility, author, timestamps, audit and notification state are enforceable and queryable.

### 5.5 Current notification behaviour is asymmetric

On ticket creation, the router attempts to resolve a `PlatformEmail` and sends a “New Support
Ticket” message to that configured support-operation recipient. It does not send a creation
acknowledgment to the client requester.

The reviewed update logic sends to the ticket creator only when:

- the actor is P1;
- the status actually changes;
- the updater is not the creator; and
- the creator has an email address.

The reviewed comment logic sends to the ticket creator only when:

- the actor is P1;
- the comment is non-internal;
- the commenter is not the creator; and
- the creator has an email address.

Consequences include:

- no client acknowledgment when a normal client creates a ticket;
- no explicit notification event for closure beyond the generic status-change branch;
- no support-operation notification when a client adds a reply;
- no recipient when P1 creates a ticket for an organisation without selecting an
  `onBehalfOfUserId`, because the P1 actor becomes the creator;
- no separation between initiator, requester, affected user and notification contact; and
- no delivery-state record, retry queue or operator-visible failure state.

The sender functions return without sending when `RESEND_API_KEY` is absent. Creation catches
provider errors and still succeeds; update/reply sends are fire-and-forget and log a rejected
promise. This is an appropriate reason not to roll back ticket creation, but console output
alone is not an adequate operational notification contract.

### 5.6 Configurable P1 support routing partly exists

`PlatformEmail` already models a named email destination, optional support category,
signature, default flag and optional organisation/module scope. P1-only create/update/delete
procedures also exist. This is a useful basis for directing new work to a mailbox owned by
P1 or an external support company.

The reviewed implementation nevertheless has material gaps:

- the visible email-management form does not expose the model's organisation and module
  scopes;
- the update procedure cannot change those scopes;
- the support-creation path duplicates the resolver rather than using one deterministic
  routing service;
- the C1 create form uses lower-case category values while `SupportCategory` and the P1 form
  use upper-case enum values;
- ticket `module` is a slug, but the resolver compares it with `PlatformEmail.moduleId`, a
  `ModuleCatalogue` foreign-key identifier;
- a multi-branch `findFirst` plus field ordering does not clearly implement the documented
  module/category/organisation/default precedence;
- no resolved destination results in silent non-delivery rather than a visible
  configuration failure;
- the creation email builds `/support/tickets/{id}`, while the reviewed Support Centre uses
  `/support` and a modal rather than a matching detail route; and
- P1 on-behalf-of creation uses the actor's organisation in parts of branding/audit context
  rather than consistently separating the real actor organisation from the target ticket
  organisation.

The separately exposed `platformEmails.getForTicket` procedure performs a sequential lookup
but does not enforce the P1 check used by the other email-management procedures. Because it
accepts an arbitrary organisation ID and returns configuration data, it also requires
permission review or removal from the client-facing router.

### 5.7 Email content requires safe rendering

The generic ticket-update email interpolates ticket and comment content directly into an
HTML string. Untrusted requester or reply content must be escaped or rendered through a safe
template before email delivery. This is required independently of whether the web UI renders
the same content as text.

### 5.8 Current P1 counts are not the required support balance

`support.getStats` always uses `ctx.session.user.organizationId`; it does not switch to the
cross-tenant population when the caller is P1. It counts open, in-progress, resolved and
total, then derives closed by subtraction. Because `waiting-response` is not counted
separately, waiting tickets are included in the derived closed value.

The P1 page displays only Open, In Progress, Resolved and Total and does not pass its active
Client, Module or Status filters into the statistics query. The cards therefore cannot be
trusted as the live balance of the rows the operator is reviewing.

### 5.9 Current filtering and classification are incomplete

The ticket schema currently stores:

- free-form string `status`;
- free-form string `priority`;
- optional free-form string `category`; and
- optional free-form string `module`.

There are no Severity or Impact fields. The list procedure accepts Status, Module and Client
only. The P1 page exposes Client and Status directly; its module filtering is inherited from
the surrounding platform-module selector. Category, Severity and Impact are absent. The
visible support-ticket search input has no bound search value or change handler.

Module identity and category casing should be normalised before they become reporting and
routing keys. Otherwise filters and email routing can disagree about apparently identical
values.

### 5.10 Aging cannot yet represent first review reliably

The model has `createdAt`, `updatedAt`, `resolvedAt` and `closedAt`. It has no
`firstReviewedAt`, assignment, first-P1-action or last-public-activity field. Ticket age can
be calculated from `createdAt`, but “time not reviewed” cannot be defined reliably from the
current data. `updatedAt` changes with any persisted update and is not a stable substitute
for first review.

## 6. Cross-Tenant Product Announcement Research And Advice

The proposed `ALL` value is attractive because it would give P1 one authoring action and one
visible item rather than generating approximately one ticket per organisation. The proposed
object is nevertheless not a normal support ticket:

- it has a many-tenant audience rather than one owning organisation;
- it is P1-originated broadcast content rather than a requester-originated case;
- it needs draft, publish, schedule, expiry, edit/version and withdrawal states rather than
  support resolution states;
- one user's reply must not become every tenant's shared ticket discussion;
- visibility, read, acknowledgment or dismissal state is per tenant or user;
- module targeting may include all clients, all clients entitled to a module or selected
  tenants; and
- notification delivery and engagement reporting differ from support SLA and aging metrics.

External product patterns support that separation:

- Zendesk describes an agent-created public ticket as a case created **for an identified end
  user/requester**, which can trigger that user's notification and appear in that user's
  activity. Its proactive bulk approach creates tickets on behalf of selected users rather
  than making one cross-customer case:
  [Creating a ticket on behalf of the requester](https://support.zendesk.com/hc/en-us/articles/4408882462618-Creating-a-ticket-on-behalf-of-the-requester).
- Intercom separates reactive Inbox/support conversations from outbound in-product messages,
  banners and news, with audience and state filters for proactive communication:
  [Outbound explained](https://www.intercom.com/help/en/articles/3292835-outbound-explained).
- Intercom also distinguishes pull-oriented News from proactively surfaced Posts or Banners,
  demonstrating that channel, audience and delivery semantics are explicit properties of an
  announcement rather than ticket status:
  [Getting started with News](https://www.intercom.com/help/en/articles/6362267-getting-started-with-news).

The application already contains an LMSPro `Announcement` and `AnnouncementDismissal` model
for one league organisation communicating with all or selected Clubs. That is a useful
design pattern for active/expiry and dismissal state, but it is tenant-owned LMSPro business
behaviour. It must not be reused directly as a cross-tenant P1 object or used to bypass the
Platform ownership boundary.

The recommended Platform design is therefore:

```text
P1 Platform Notice
-> audience: all active clients, clients entitled to selected module(s), or selected tenants
-> publication: draft, scheduled/published, withdrawn/expired
-> presentation: Support Centre and/or shared application notice surface
-> delivery: optional email notification through shared communications infrastructure
-> engagement: per-tenant or per-user seen/acknowledged/dismissed evidence
-> replies: disabled, or each reply opens a new tenant-owned support ticket
```

The P1 UI should offer `Create Platform Notice` as a separate action. It should not pin
`ALL` into the ticket Organisation dropdown, create a pseudo-organisation, or make a single
ticket readable across tenant boundaries.

## 7. Requested Outcome

The coordinated Platform change should deliver the following outcomes.

### 7.1 Tenant and role contract

1. Preserve fail-closed cross-tenant list, detail, mutation, comment and attachment access.
2. State the accepted same-tenant visibility policy for C1 Owner/Admin, requester and other
   tenant members.
3. Enforce P1 authority for arbitrary lifecycle, priority, severity, impact, assignment and
   internal-note operations.
4. Replace the C1 status dropdown with read-only lifecycle presentation plus deliberately
   bounded Close/Reopen actions if those actions remain accepted.
5. Enforce every transition and field permission on the server, with audit of actor, prior
   value, new value and target tenant.
6. Ensure internal notes are neither returned to nor writable by a client caller.

### 7.2 Notification participants and routing

1. Define separate participants for real actor, target tenant, requester/affected user and
   support-operation recipient.
2. Let P1 configure at least one active support-operation destination which may be an
   external support-company mailbox and need not equal a P1 account email.
3. Use one deterministic server-side routing service with explicit precedence and a visible
   default/fallback requirement.
4. Normalise Category and Module identifiers before using them for routing or reporting.
5. Notify the support-operation recipient when a client creates or publicly replies to a
   ticket.
6. Notify the requester at ticket creation, each public P1 reply, applicable lifecycle
   changes and final closure.
7. Suppress client delivery of internal notes and internal-only state.
8. Use valid environment-aware links and target-tenant branding.
9. Escape untrusted content in email output.
10. Record durable delivery attempt, provider result/failure and retry/operational state
    without making ticket creation depend on immediate provider success.

### 7.3 Live operational dashboard

1. Count every defined lifecycle state independently, including Open, In Progress, Waiting
   for Response, Resolved and Closed.
2. For P1, use all P1-visible tenants unless Client filters the population.
3. Apply the same active filters to row results, counts and aging summaries.
4. Refresh or invalidate counts immediately after creation, comment or lifecycle mutation so
   the dashboard does not present stale balances as live.
5. Show at minimum:
   - ticket age from `createdAt`;
   - time awaiting first P1 review from an explicit first-review event/timestamp;
   - oldest unreviewed ticket; and
   - unreviewed aging buckets using triage-approved thresholds.
6. Keep SLA policy distinct from descriptive aging. A later SLA commitment must not be
   inferred solely from adding elapsed-time indicators.

### 7.4 Classification, filtering and search

1. Add canonical Severity and Impact values with documented meanings distinct from Priority.
2. Support composable server-side filters for Client, Status, Severity, Impact, Module and
   Category.
3. Make ticket text/number search functional, server-side and pagination-compatible.
4. Preserve filter state while opening/closing a detail modal and after mutations.
5. Use canonical Category and Module keys in creation, persistence, filtering and email
   routing.
6. Define indexes/query strategy during bounded planning against realistic cross-tenant
   volumes.

### 7.5 Platform notices

1. Reject `ALL` as a SupportTicket organisation value.
2. Plan a distinct Platform Notice model and P1 authoring action if product announcements are
   accepted for delivery in this cycle.
3. Support explicit audience, publication and expiry semantics without materialising one
   ticket per tenant.
4. Keep each tenant's read/dismissal/acknowledgment state private from other tenants.
5. If replies are enabled, create a new tenant-owned support case rather than a shared
   cross-tenant discussion.
6. Permit Support Centre presentation without describing the notice as a support request or
   including it in support aging/SLA counts.

## 8. Candidate Workstreams For Triage

The following are planning candidates only and deliberately have no executable identifiers.

### Candidate workstream A — Support privacy and authority gate

- formalise tenant and same-tenant visibility policy;
- split P1 lifecycle/triage mutations from client close/reopen actions;
- make status read-only for C1 except accepted client actions;
- enforce internal-note read/write privacy at the server;
- review every procedure returning ticket, discussion, creator or routing data; and
- add negative cross-tenant, same-tenant-role and direct-API permission tests.

This workstream should be completed and independently reviewed before client enablement.

### Candidate workstream B — Notification routing and delivery contract

- define actor, requester and support-operation recipients;
- consolidate the PlatformEmail resolver and P1 configuration surface;
- correct category/module identity, branding and link handling;
- add creation, public reply, lifecycle and closure events in both directions;
- use safe templates; and
- introduce operator-visible, retryable delivery evidence and human end-to-end mail gates.

### Candidate workstream C — Support lifecycle data and operational reporting

- replace or constrain free-form lifecycle/classification fields;
- record explicit first review and useful last-activity facts;
- return cross-tenant, filter-consistent counts and aging summaries to P1;
- display all lifecycle balances and unreviewed aging; and
- verify pagination and query performance.

### Candidate workstream D — Classification, filters and usability

- define Severity, Impact, Category and Module contracts;
- add composable filters and functional search;
- correct misleading labels such as `My Tickets` if the accepted view is tenant-wide;
- include `waiting-response` consistently in status selectors and colours; and
- remove or complete controls that currently advertise unavailable behaviour.

### Candidate workstream E — Platform Notice architecture and bounded adoption

- decide whether the initial notice audience is all active clients only or also module and
  selected-tenant audiences;
- define publication, expiry, withdrawal and engagement semantics;
- define email opt-in/mandatory operational-notice rules;
- decide the shared surface on which notices appear; and
- use the LMSPro announcement implementation only as non-authoritative pattern evidence.

This workstream is a distinct new capability within the same CR. It must remain separable so
that support client-readiness remediation is not blocked by announcement-product design.

## 9. Data, Migration And Compatibility Implications

A bounded plan is likely to require schema and migration work because the current
`SupportTicket` model has no Severity, Impact, first-review, assignment or notification
evidence, and comments are stored as JSON. Planning must cover:

- canonical enum/value migration for status, priority, category, severity and impact;
- mapping existing lower-case and upper-case category values without losing records;
- validated ModuleCatalogue identity or a canonical module slug contract;
- a typed ticket-comment model or an equally strong server-private representation;
- first-review and last-activity derivation/backfill rules;
- requester/contact representation for P1-created tickets;
- notification outbox/delivery evidence and retention;
- query indexes for P1 cross-tenant filters and aging; and
- recovery/rollback when old rows contain unknown free-form values.

Existing tickets must remain tenant-owned and viewable through a compatibility path during
the transition. No CR text authorises a migration or data rewrite.

If Platform Notice is accepted, it should use a new Platform-owned object and audience
relationship rather than altering `SupportTicket.organizationId` to be null, magic or
many-to-many. Existing LMSPro announcements remain league/Club scoped and compatible.

## 10. Security, Privacy And Operational Risks

| Risk | Assessment and required control |
| --- | --- |
| Cross-tenant ticket disclosure | Reviewed router is fail-closed by organisation for non-P1; retain and test list/detail/mutation/comment/attachment boundaries, including identifier probing |
| Same-tenant over-disclosure | Current access is broader than Owner/Admin and requester; formalise and enforce policy |
| Internal-note disclosure | Serious pre-enablement defect; filter/authorise at server before serialisation and reject client internal-note writes |
| Lifecycle manipulation | Current same-tenant API permits arbitrary status/priority change; use server transition matrix and separate P1/client procedures |
| Routing configuration disclosure | Review or remove non-P1 access to `platformEmails.getForTicket` |
| Lost notification | Persist attempt/result/failure and provide retry/alerting; do not rely only on console logging |
| Incorrect notification recipient | Separate requester from support-operation mailbox and validate deterministic routing before enablement |
| HTML/content injection in email | Escape untrusted values or use safe rendering components/templates |
| Audit ambiguity during P1 on-behalf-of work | Record real P1 actor, target tenant and requester separately; never overwrite one with another |
| Cross-tenant announcement reply leak | Do not share ticket discussion across an `ALL` audience; create tenant-owned reply cases if needed |
| Misleading support reporting | Count explicit statuses and derive aging from explicit events, using the same filters as rows |

## 11. Acceptance Principles And Evidence Expectations

Later bounded planning should translate these principles into exact acceptance tests.

1. Two different tenant sessions cannot discover each other's ticket existence, details,
   discussion, requester data, notification configuration or attachments by list or ID.
2. An unauthorised same-tenant user receives the accepted requester-only or restricted
   outcome consistently in navigation, API reads and mutations.
3. A C1 Owner/Admin sees status as read-only and cannot force an arbitrary lifecycle or
   priority change by direct procedure invocation.
4. Accepted Close/Reopen actions perform only their named transitions and are audited.
5. A client response never contains an internal note, and a client cannot add or relabel one.
6. P1 can configure and test a support-operation mailbox independent of P1 account email.
7. A real email gate demonstrates:
   - support mailbox receipt after client creation;
   - requester acknowledgment after creation;
   - support mailbox receipt after a client public reply;
   - requester receipt after a P1 public reply;
   - requester receipt after applicable status changes and closure;
   - no requester receipt for an internal note; and
   - visible failure/retry evidence when the provider rejects delivery.
8. P1 lifecycle cards equal independently queried counts for every status and change with the
   same active filters as the table.
9. Unreviewed age is based on an explicit review event, not incidental `updatedAt` changes.
10. Client, Status, Severity, Impact, Module, Category and search filters compose correctly
    with pagination and counts.
11. A Platform Notice is stored once, shown only to its target audience, excluded from ticket
    aging/counts and cannot expose one tenant's engagement or reply to another tenant.
12. Human UI review covers direct C1 and P1 logins, keyboard/accessibility behaviour,
    read-only presentation, empty/error states, filtering, aging, delivery links and mobile
    layout.

## 12. Included And Excluded Scope

Included in this CR:

- shared support-ticket tenancy and role permissions;
- C1/P1 lifecycle presentation and server transitions;
- internal/public discussion privacy;
- requester and support-operation email routing;
- notification delivery evidence;
- P1 counts, aging, classification, filters and search;
- P1 on-behalf-of actor/requester/tenant separation;
- support-related audit and safe email rendering; and
- Platform Notice architecture and Support Centre adoption advice.

Explicitly excluded unless separately accepted during triage:

- using support tickets for marketing campaigns;
- a pseudo `ALL` organisation or nullable tenant ownership for support tickets;
- generating one support ticket per client for an announcement;
- replacing an external service desk or providing inbound email-to-ticket processing;
- contractual SLA values, staffing hours or escalation commitments;
- attachment expansion, live chat, telephony, AI triage or customer-satisfaction surveys;
- changes to LMSPro league/Club announcement ownership;
- FUND or Commerce business behaviour; and
- implementation, deployment, data repair or retroactive lifecycle evidence in this CR.

## 13. Dependencies And Retrospective Implications

This input depends on Platform triage establishing urgency, client-enablement gates, exact
same-tenant visibility and the smallest safe implementation boundaries. Any executable plan
must inspect the deployed environment's email provider configuration, sender/domain
verification, application base URLs, current `PlatformEmail` records and historical ticket
values before changing behaviour.

The review found security/privacy concerns adjacent to the reported UI issues. They are
included because correcting only the dropdown would leave the same capability available by
direct API call, and filtering internal notes only in the browser does not protect them.

This CR does not retrospectively classify existing support tickets as tested or secure. It
also does not create implementation confirmation, review/test evidence or roadmap status for
the historic support capability. Existing records should be treated as migration inputs only
after read-only inventory and accepted planning.

## 14. Settled Decisions Recorded By This CR

1. The shared support capability belongs to the IsoStack Platform lane.
2. One coordinated CR may cover the reported client-readiness findings, while later planning
   keeps security, notifications/reporting and Platform Notice work independently reviewable.
3. The reviewed support router contains application-level cross-tenant guards for list,
   detail, update and comment operations.
4. That confirmation is not live RLS evidence and does not approve the current broad
   same-tenant access model.
5. C1 must not receive general lifecycle-status or priority editing authority. Read-only
   status, reply and deliberately bounded Close/Reopen actions are the intended client
   presentation.
6. Internal notes are P1-only and must be protected at the server boundary.
7. The support-operation recipient is configurable independently of the P1 user's account
   email and may be an external support-company mailbox.
8. The requester must receive creation acknowledgment, public-reply, applicable status and
   closure notifications.
9. P1 needs filter-consistent live counts for every lifecycle status plus explicit aging and
   first-review measures.
10. Client, Severity, Impact, Module and Category are essential composable filters; Severity
    and Impact remain distinct from Priority.
11. `ALL` must not be a SupportTicket organisation. Cross-tenant announcements use a distinct
    Platform Notice/Announcement capability if accepted.
12. No code, schema, roadmap, lifecycle, deployment or test-status change is authorised by
    this document.

## 15. Open Questions For Triage And Control-Owner Decision

1. Should a C1 Tenant Owner/Admin see every ticket in its organisation while Core Members see
   only tickets they requested, or should another explicit support-viewer permission govern
   organisation-wide access?
2. May a requester reopen any closed ticket, only a recently closed ticket, or must reopening
   always be a new reply/request reviewed by P1?
3. Which lifecycle changes warrant requester email beyond creation, public reply and closure;
   for example, should `in-progress`, `waiting-response` and `resolved` all notify?
4. Is one support-operation recipient sufficient at each routing scope, or are To/CC and
   escalation recipients required?
5. What is the required deterministic routing precedence: module plus tenant plus category,
   tenant plus category, platform category, then mandatory platform default, or a simpler
   hierarchy?
6. Who may author Impact and Severity initially: client requester, P1 triage, or both with P1
   retaining the authoritative value?
7. What canonical values and definitions should Severity and Impact use, and should Priority
   be manually assigned or derived from them?
8. What event constitutes first review: first P1 opening, assignment, internal note, public
   reply or explicit `Acknowledge/Triage` action?
9. Which unreviewed aging thresholds should the initial dashboard use, and are they purely
   informational or tied to an approved operating SLA?
10. For Platform Notices, is the initial audience limited to all active client organisations,
    or must the first version also support entitled-module and selected-tenant targeting?
11. Should Platform Notices be dismissible, require acknowledgment, or simply record first
    seen, and at tenant or individual-user level?
12. Should a reply to a Platform Notice be disabled or create a new tenant-owned support
    ticket linked back to the notice?
13. Are product announcements optional communications while maintenance/security notices are
    mandatory, and what subscription/legal rules apply to email delivery?
14. Which direct-login P1 and C1 human test accounts and which non-production mailboxes will
    be used for the required end-to-end acceptance gate?
