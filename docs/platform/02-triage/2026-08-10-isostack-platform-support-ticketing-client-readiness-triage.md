# IsoStack Platform Support Ticketing Client Readiness Triage

Date: 2026-08-10

Status: **TRIAGE COMPLETE; ORIGINAL P1 GAP CORRECTED BY 03A/03B; PROJECT COMPLETE AND
CLOSED AT EXACT PRODUCTION `cde4eaff` WITH ALL GATES PASSING**

Source CR:

[`2026-08-05-isostack-core-platform-support-ticketing-client-readiness-and-communications-cr.md`](../01-cr-inputs/2026-08-05-isostack-core-platform-support-ticketing-client-readiness-and-communications-cr.md)

Application source rechecked:

```text
60ac76c17dea54db77097a4c3232f4874f9abe3f
```

## 1. Triage Decision

Accept Support Ticketing as one self-contained Platform client-readiness project, delivered
through three bounded slices rather than one large implementation:

1. `PLAT-SUPPORT-01` — client privacy and lifecycle-authority gate;
2. `PLAT-SUPPORT-02` — deterministic notification routing and missing event coverage; and
3. `PLAT-SUPPORT-03` — P1 operational dashboard, lifecycle balance, aging and filters.

Classification:

```text
Type       Existing capability client-readiness remediation and operational completion
Priority   Current Platform project before FUND resumes
Severity   High; internal-note disclosure and client lifecycle mutation block enablement
Owner      IsoStack Platform
Data       Existing tickets retained; read-only inventory precedes any migration
Release    Three independently reviewable slices with separate human gates
Notice     Platform Notice/ALL-client announcements excluded and deferred
```

## 2. Notification Finding Refinement

The application does not require a new email transport before Support Ticketing can proceed.
The current Resend path already attempts:

- a new-ticket email to a database-configured `PlatformEmail` destination;
- a status-change email to the ticket creator when P1 changes status; and
- a public-reply email to the ticket creator when P1 replies.

Observed delivery is credible evidence that the provider key, verified sender and basic
transport operate in at least the tested environment. The immediate report that mail reaches
an unmonitored address is therefore primarily a configuration and routing-contract problem.

It is not solely configuration because the source also confirms:

- C1 sends lower-case category values while the routing query expects the upper-case
  `SupportCategory` enum;
- the ticket form persists a module slug while `PlatformEmail.moduleId` is a catalogue ID;
- the creation path duplicates rather than consumes the nominal routing resolver;
- broad `findFirst` ordering does not prove deterministic precedence;
- a client reply does not notify the support-operation mailbox;
- ticket creation does not acknowledge the requester; and
- P1-created tickets without an explicit requester conflate the P1 actor with the client
  notification recipient.

`PLAT-SUPPORT-02` must therefore retain the working transport and correct routing and event
coverage. It must not rebuild the general email-delivery system.

Durable queue/retry infrastructure is not part of the minimum routing slice. The slice must
still retain visible provider success/failure evidence using an existing audit or operational
record. A separate hardening candidate opens only if provider failures, retry obligations,
multiple escalation recipients or regulated delivery evidence are proved requirements.

## 3. Settled Operating Contract

### Client visibility and lifecycle

- a P1 support operator has explicit cross-tenant support authority;
- a tenant `OWNER` or `ADMIN` may see the tenant's support cases;
- an ordinary tenant `MEMBER` may see only a ticket for which that user is the requester;
- C1 users cannot select arbitrary lifecycle status, priority, severity or impact;
- accepted client actions are reply, Close and Reopen through separately bounded server
  transitions; and
- internal notes are P1-only and must not cross a client response boundary.

### Initial support routing

- one active monitored platform-wide default support mailbox is mandatory;
- P1 may configure an email address belonging to P1 or an external support company;
- optional category-specific overrides may route to monitored mailboxes;
- exact category override then mandatory platform default is the initial precedence;
- module and tenant are retained as ticket classification/filtering facts, not routing keys
  in the initial release; and
- any discovered deployed dependency on organisation/module-scoped `PlatformEmail` records
  stops `PLAT-SUPPORT-02` for explicit compatibility planning.

### P1 operational classification

- Severity describes technical/service degradation;
- Impact describes affected breadth;
- Priority remains P1's operational scheduling decision and is not automatically derived;
- clients may supply the existing request description/category but do not author the final
  Severity, Impact or Priority; and
- first review is the first deliberate P1 detail review, recorded once through an idempotent
  server operation rather than inferred from `updatedAt`.

## 4. Bounded Sequence And Working Estimate

| Order | Slice | Purpose | Focused estimate | Entry/exit boundary |
| --- | --- | --- | ---: | --- |
| 1 | [`PLAT-SUPPORT-01`](../03-slice-planning/2026-08-10-isostack-platform-plat-support-01-client-privacy-and-lifecycle-authority-gate-planning.md) | Server-enforced visibility, internal-note privacy and lifecycle authority | 3–4 days | Must pass before client enablement or later Support promotion |
| 2 | [`PLAT-SUPPORT-02`](../03-slice-planning/2026-08-10-isostack-platform-plat-support-02-notification-routing-and-event-coverage-planning.md) | Monitored mailbox configuration, canonical deterministic routing and complete essential notification events | 2–4 days | Retains existing Resend transport; controlled real-mail gate required |
| 3 | [`PLAT-SUPPORT-03`](../03-slice-planning/2026-08-10-isostack-platform-plat-support-03-p1-operational-dashboard-and-classification-planning.md) | Filter-consistent P1 counts, review aging, classification, search and usability | 4–6 days | Schema/migration and P1 human operations gate required |

The project is therefore approximately **9–14 focused development days**, normally two to
three calendar weeks for one developer including documentation and human staging gates.

## 5. Deferred Or Separate Work

The following does not block these three slices:

- Platform Notice/ALL-client announcements;
- inbound email-to-ticket processing;
- attachments, live chat, telephony, AI triage or customer-satisfaction surveys;
- contractual SLA commitments or staffing rules;
- general-purpose email infrastructure replacement; and
- typed comment-table migration unless `PLAT-SUPPORT-01` proves server-safe JSON response
  shaping and mutation cannot meet the accepted privacy boundary.

Durable retry/outbox work becomes a candidate only on one of these triggers:

1. a controlled provider-rejection test cannot leave visible actionable failure evidence;
2. support operations require automatic retry rather than manual recovery;
3. more than one support recipient/escalation route is accepted; or
4. legal, contractual or audit policy requires durable delivery history.

## 6. Global Stop Conditions

Stop and return to triage if implementation requires:

- weakening the current cross-tenant organisation guard;
- exposing internal notes or routing configuration to a client procedure;
- treating a browser-hidden field as an authorisation boundary;
- making ticket persistence depend on immediate provider delivery;
- rewriting historic discussion data without a migration/backfill plan;
- using a pseudo `ALL` organisation or cross-tenant shared ticket;
- silently activating organisation/module-scoped routing; or
- combining all three slices into one unreviewable release.

## 7. Local Delivery Checkpoint — 2026-08-10

The user subsequently authorised all three bounded slices for local implementation. They
remain independently documented, but share one combined authenticated local smoke because
privacy, routing/events and P1 management must operate together before Support can be
enabled.

- [`PLAT-SUPPORT-01 implementation`](../04-implementation-confirmations/2026-08-10-isostack-platform-plat-support-01-client-privacy-and-lifecycle-authority-implementation.md)
- [`PLAT-SUPPORT-02 implementation`](../04-implementation-confirmations/2026-08-10-isostack-platform-plat-support-02-notification-routing-and-event-coverage-implementation.md)
- [`PLAT-SUPPORT-03 implementation`](../04-implementation-confirmations/2026-08-10-isostack-platform-plat-support-03-p1-operational-dashboard-and-classification-implementation.md)
- [`Combined local review and smoke gate`](../05-review-and-test/2026-08-10-isostack-platform-support-ticketing-combined-local-review-and-smoke-gate.md)

Technical gates pass on local `dev` based on `60ac76c1`. The additive migrations were
applied only to a database proven distinct from the shared `.env` target. No code commit,
push, staging, main, deployed database or client-enablement action occurred. The portfolio
position was subsequently displaced by the accepted LMSPro R12-A micro-expedite. The
30-item combined human local gate is retained intact as portfolio `Next` and resumes after
R12-A local disposition; an exact-SHA Security Scan becomes mandatory only after that gate
passes and a commit is authorised.
