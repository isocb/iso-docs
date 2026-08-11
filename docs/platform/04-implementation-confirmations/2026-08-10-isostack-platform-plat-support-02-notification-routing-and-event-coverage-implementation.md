# PLAT-SUPPORT-02 Notification Routing And Event Coverage Implementation

Date: 2026-08-10

Status: **DELIVERED AND CLOSED AT EXACT PRODUCTION `cde4eaff`; CONTROLLED MAIL AND ALL
HUMAN, SECURITY, HEALTH AND RENDER IDENTITY GATES PASS**

Plan:

[`PLAT-SUPPORT-02 planning`](../03-slice-planning/2026-08-10-isostack-platform-plat-support-02-notification-routing-and-event-coverage-planning.md)

Combined review/gate:

[`Support Ticketing combined local review and smoke gate`](../05-review-and-test/2026-08-10-isostack-platform-support-ticketing-combined-local-review-and-smoke-gate.md)

## 1. Delivered Outcome

The existing Resend transport is retained. Support routing is now one deterministic,
server-only contract:

```text
one exact configured platform-wide category destination
-> one mandatory platform-wide uncategorised default
-> visible MISSING or AMBIGUOUS result
```

Module and organisation remain ticket classification/context; they are not silently used as
routing keys. Non-P1 callers cannot list, preview, test or edit support routing.
The retained model has no separate enabled flag: an unscoped configured row is effective
until P1 edits or deletes the non-default override.

The existing Platform Email & Notifications panel now provides:

- effective-route health for every canonical category;
- a visible warning for missing, ambiguous or legacy scoped records;
- non-sending preview of the exact effective address and rule;
- deliberate provider test behind browser confirmation;
- persisted `lastTestedAt` and `lastTestResult` evidence; and
- readiness only when every effective route has an accepted test and no scoped legacy record
  remains.

Editing a destination clears its prior accepted test. The mandatory default cannot be
deleted, and the mutation boundary rejects duplicate or invalid routing configuration.

## 2. Delivered Event Contract

| Event | Support operation | Requester |
| --- | --- | --- |
| Client creates | New-ticket notification | Creation acknowledgement |
| Client public reply | Client-reply notification | No echo |
| P1 public reply | No duplicate | Public-reply notification |
| P1 internal note | No external delivery | No external delivery |
| P1 lifecycle change | UI/audit only | Status or explicit closure notification |
| Client Close/Reopen | Client-transition notification | Accepted-transition confirmation |

P1-on-behalf-of creation retains the actual P1 actor and an optional explicit requester. If
no requester is selected, requester delivery is suppressed and audited as skipped rather
than sending to the P1 actor by mistake.

Ticket persistence never depends on provider acceptance. Every attempted, failed or skipped
delivery writes bounded audit evidence when audit storage is available; an audit-write
failure is also non-fatal. Untrusted ticket/comment data is rendered through React email
templates, and links use the valid environment-aware Support Centre/P1 dashboard routes.

## 3. Read-Only Local Inventory

No destination was changed automatically. The validated local-development database contains:

| Record | Destination | Use |
| --- | --- | --- |
| Platform Support | `support@isostack.dev` | platform-wide default |
| Technical Support | `tech@isostack.dev` | technical override |
| Billing Support | `billing@isostack.dev` | billing override |

All are unscoped. None carries current accepted provider-test evidence, so the new readiness
summary correctly remains not ready. The human gate must replace/confirm these with a
monitored controlled destination and perform the explicit test; code must not guess the
operator's mailbox.

## 4. Principal Implementation And Data

- `src/server/core/services/support-email-routing.ts` — deterministic server resolver and
  readiness summary;
- `src/server/core/services/support-notifications.ts` — non-fatal event delivery and evidence;
- `src/server/core/routers/platformEmails.router.ts` — P1-only configuration, preview and
  controlled test procedures;
- `src/lib/email.ts` and `src/server/email/templates/SupportTicketEventEmail.tsx` — bounded
  provider result and safely rendered event messages; and
- `EmailManagementPanel.tsx` — configuration health, preview and test presentation.

Migration `20260810153000_platform_support_routing_test_evidence` adds only nullable test
timestamp/result fields. It does not alter an address or credential.

## 5. Recovery And Gate

Application rollback preserves existing destination rows. The nullable evidence columns are
safe to retain during rollback. No generic queue, retry worker or communications rewrite is
included. Controlled receipt, link and provider-rejection behaviour remain explicit human
items in the combined local smoke gate.

Following the completed corrective cycle, this slice is included in exact Support commit
`cde4eaff1e14b2f02ba0953fe8693e7feb02bb61`, aligned through dev/staging with both exact
Security Scans green. Controlled staging delivery passed in the shared Support staging gate;
no provider behaviour is inferred from branch alignment alone.
