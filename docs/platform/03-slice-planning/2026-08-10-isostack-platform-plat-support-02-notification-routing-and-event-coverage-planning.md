# PLAT-SUPPORT-02 Notification Routing And Event Coverage Planning

Date: 2026-08-10

Status: **IMPLEMENTED IN EXACT `cde4eaff`; CONTROLLED LOCAL ROUTING EVIDENCE PASS;
DEV/STAGING ALIGNED AND EXACT SECURITY SCANS PASS; CONTROLLED STAGING MAIL CHECK PENDING**

Accepted triage:

[`Support Ticketing client-readiness triage`](../02-triage/2026-08-10-isostack-platform-support-ticketing-client-readiness-triage.md)

Dependency:

`PLAT-SUPPORT-01` must pass its local/review gate before this slice is implemented or
promoted.

## 1. Objective

Retain the already functioning Resend transport while making the P1 support destination
monitored, deterministic and testable and completing the essential requester/support event
coverage.

This is routing and notification completion, not an email-platform rebuild.

## 2. Confirmed Existing Foundation

The current application already:

- stores P1-managed `PlatformEmail` destinations;
- provides a P1 Email & Notifications management panel;
- sends a new-ticket notification through Resend when resolution succeeds;
- sends P1 public-reply and P1 status-change emails to the ticket creator; and
- treats immediate provider failure as non-fatal to ticket persistence.

Observed receipt supports transport viability. The slice must preserve that working path.

## 3. Initial Routing Contract

The initial client-ready contract is deliberately simple:

```text
canonical exact category override, when active
-> mandatory active platform-wide default support mailbox
-> visible configuration failure; never silent success
```

Requirements:

- one monitored default support-operation mailbox is mandatory;
- its address may belong to P1 or an external support company;
- every active category override must also be monitored;
- category keys are canonical `TECHNICAL`, `BILLING`, `FEATURE_REQUEST`, `OTHER` from UI
  input through persistence, lookup and reporting;
- module remains a canonical ticket classification slug in this slice and is not compared
  to a `ModuleCatalogue.id` routing foreign key;
- organisation/module-scoped email routing is not activated by this release;
- all deployed `PlatformEmail` records are inventoried read-only before mutation; and
- discovery of a relied-upon scoped record stops implementation for an explicit
  compatibility amendment.

The duplicated ticket-creation lookup and public `getForTicket` path must become one
server-only resolver. Resolver results should identify which rule selected the mailbox so
P1 can understand and test configuration.

## 4. Required Event Matrix

| Event | Support-operation mailbox | Requester/contact |
| --- | --- | --- |
| Client creates ticket | New ticket | Creation acknowledgement |
| Client adds public reply | New client reply | No echo required |
| P1 adds public reply | No duplicate required | New support reply |
| P1 adds internal note | No external delivery | No delivery |
| P1 changes applicable lifecycle state | Optional internal UI activity only | Status update |
| P1 closes ticket | Optional internal UI activity only | Explicit closure message |
| Client Close/Reopen | Client lifecycle request/update | Confirmation only if accepted during implementation review |

P1-created tickets must separate the real P1 actor from the client requester/contact. If a
P1-created tenant ticket has no explicit requester/contact, client delivery is suppressed
with a visible P1 warning; the P1 actor must not silently become the client recipient.

## 5. P1 Configuration Surface

Update the existing Email & Notifications panel rather than creating another settings area.
P1 must be able to:

- see the default and every category override with its effective monitored address;
- edit the destination without changing a P1 account email;
- identify invalid, duplicate or missing default configuration;
- see which address will receive a chosen category through a non-sending preview; and
- issue a deliberate test notification with an explicit confirmation and visible result.

Changing the deployed address is an environment operation and must be recorded without
printing provider credentials or unrelated personal data.

## 6. Delivery And Safety Boundary

- reuse the current Resend sender and verified-from configuration;
- use safe React email templates or equivalent escaping for ticket title, description,
  commenter name and reply content;
- use the environment-aware `/support` route, not the nonexistent ticket-detail route;
- use target-tenant branding while retaining the real P1 actor in audit;
- await/capture the provider result sufficiently to create visible success/failure evidence;
- never roll back ticket/comment/lifecycle persistence solely because mail fails; and
- never send an internal note externally.

The minimum slice may record provider outcome through the existing audit/operational model.
It does not add a generic queue, automatic retry worker or general communications migration.
Those open only under the triggers in the accepted triage.

## 7. Automated Acceptance

Prove:

1. each canonical category resolves its exact override or the mandatory default;
2. lower-case/legacy client values are normalised or rejected before persistence/lookup;
3. a module slug is never compared to `PlatformEmail.moduleId`;
4. no non-P1 caller can read or test routing configuration;
5. missing/ambiguous default configuration is visible to P1 without blocking ticket save;
6. every event in the matrix targets only its accepted participant;
7. internal notes never generate external mail;
8. P1 on-behalf-of actor, tenant and requester/contact remain distinct;
9. untrusted content is escaped in delivered HTML;
10. provider rejection leaves the ticket operation successful and visible failure evidence;
11. the valid application URL is used; and
12. no provider call is made by preview or ordinary Save/update actions unrelated to an
    accepted notification event.

Run focused resolver/event/template tests, full relevant tests, type-check, changed lint,
verification, production build and Security Scan.

## 8. Controlled Human Mail Gate

With non-sensitive content and controlled mailboxes:

1. configure one monitored default and inspect every category override;
2. use routing preview for all categories and confirm the effective address;
3. send the explicit P1 test notification and confirm receipt;
4. create a ticket as C1 and confirm support receipt plus requester acknowledgement;
5. reply as C1 and confirm support receipt;
6. add an internal note as P1 and confirm no client mail;
7. add a public reply as P1 and confirm requester receipt;
8. move through an applicable lifecycle state and Close, confirming requester messages;
9. force a safe provider rejection and confirm visible failure without lost ticket data; and
10. confirm all delivered links open the appropriate Support Centre.

## 9. Estimate, Recovery And Stop

Focused estimate: **2–4 development days**, including tests and documentation but excluding
human waiting time for provider delivery.

Application/configuration revert is the recovery boundary. No ticket data rewrite is
authorised. Stop for active scoped-routing dependencies, a required multi-recipient
escalation model, generic delivery-job migration or any attempt to make provider acceptance
transactional with ticket persistence.

## 10. Implementation Disposition — 2026-08-10

Local implementation is recorded at the
[`PLAT-SUPPORT-02 implementation confirmation`](../04-implementation-confirmations/2026-08-10-isostack-platform-plat-support-02-notification-routing-and-event-coverage-implementation.md).
The local inventory found only unscoped destinations, so the stop condition did not fire.
No destination was guessed or changed: monitored-mailbox configuration, explicit provider
test, receipt and controlled rejection remain human evidence in the
[`combined local smoke gate`](../05-review-and-test/2026-08-10-isostack-platform-support-ticketing-combined-local-review-and-smoke-gate.md).
