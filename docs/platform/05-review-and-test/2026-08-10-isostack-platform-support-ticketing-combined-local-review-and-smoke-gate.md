# Platform Support Ticketing Combined Local Review And Smoke Gate

Date: 2026-08-10

Status: **HISTORICAL INITIAL PARTIAL GATE; VALID PRIVACY/ROUTING EVIDENCE RETAINED; P1 GAP
CORRECTED BY 03A/03B AND SUCCESSOR LOCAL GATE PASSED 24/24; EXACT `cde4eaff` NOW ALIGNED
THROUGH MAIN; USE THE 2026-08-11 PRODUCTION CLOSURE RECORD FOR CURRENT STATE**

Slices:

- [`PLAT-SUPPORT-01 implementation`](../04-implementation-confirmations/2026-08-10-isostack-platform-plat-support-01-client-privacy-and-lifecycle-authority-implementation.md)
- [`PLAT-SUPPORT-02 implementation`](../04-implementation-confirmations/2026-08-10-isostack-platform-plat-support-02-notification-routing-and-event-coverage-implementation.md)
- [`PLAT-SUPPORT-03 implementation`](../04-implementation-confirmations/2026-08-10-isostack-platform-plat-support-03-p1-operational-dashboard-and-classification-implementation.md)

## 1. Review Conclusion

Static review confirms that the three slices form one coherent local candidate without
expanding into Platform Notices, generic email infrastructure or a support-role redesign.
Privacy and mutation authority are server-enforced; support routing is P1-only and
deterministic; notification failure cannot roll back a saved ticket; and the dashboard uses
the same filter population for rows, lifecycle balances and aging.

The principal remaining evidence requires people and mailboxes: authenticated C1/C2/P1 UI
behaviour, controlled provider receipt, responsive presentation and reconciliation of cards
against known local tickets. This document is the single combined human gate. A pass does
not itself authorise a commit or staging promotion.

The accepted LMSPro R12-A micro-expedite temporarily displaced this gate on 2026-08-11.
No Support scope or evidence was discarded: this exact 30-item gate is portfolio `Next` and
resumes immediately after R12-A receives its local disposition.

## 1A. Post-Test Route Reconciliation — 2026-08-11

The control owner's recorded screen behaviour identifies the client support surface:

```text
/support
```

That surface intentionally has the C1/Member detail modal, public reply and bounded client
Close/Reopen controls. It does not contain P1 classification, internal notes or the P1
operational filter set.

The implemented P1 workbench is:

```text
/platform?tab=support&subtab=tickets
```

Source review confirms that workbench contains Client, Status, Severity, Impact, Module,
Category and review-state filters; server-side search; Status/Priority/Severity/Impact/
Category editing; first-review aging; and the P1 internal-note switch. Therefore recorded
items 6, 8, 15, 17 and 21–30 are not valid failures of those implemented controls until
rerun on the canonical P1 route.

The route mistake is nevertheless a real product defect: the P1 sidebar item labelled
`Support Tickets` currently links to `/support`, not the P1 workbench. This gate also failed
to state the canonical route explicitly. Both must be corrected before the combined gate is
reissued.

Two distinct concerns remain after that correction:

1. the PLAT-SUPPORT-03 plan refers to table rows, while the implemented P1 queue uses cards;
   the control owner's requested expandable/accordion row presentation requires a bounded
   presentation correction; and
2. P1-set next-action/response-due dates and a lifecycle activity chronology were not in
   the accepted PLAT-SUPPORT-03 data contract. Only creation age and first-review age were
   planned. Those are new operational requirements requiring explicit field semantics,
   migration and filters rather than an ad hoc UI addition.

The valid privacy and routing PASS evidence already recorded below is retained. Further P1
testing is paused pending the route-aware rerun/corrective disposition; no Support staging
promotion is authorised.

## 2. Automated And Environment Evidence

Application working tree: local `dev` based on exact `60ac76c1`; implementation uncommitted.

| Gate | Result |
| --- | --- |
| Prisma generate and schema validate | PASS |
| Validated local-development migration deploy | PASS — 150 migrations applied |
| Support schema/enum/index verification | PASS on distinct local identity `f6a66d727ced` |
| Focused support policy/router/routing/notification tests | PASS — 17/17 |
| Full Vitest regression | PASS — 389 passed, 12 skipped |
| TypeScript | PASS |
| Critical-file repository verification | PASS |
| Production build | PASS — 131 routes/static pages generated |
| Changed production-file ESLint | PASS — zero errors, 13 non-blocking type-cast warnings |
| Diff whitespace check | PASS |
| Local unauthenticated `/support` boundary | PASS — 307 to sign-in with callback |

The repository ESLint TypeScript project excludes `*.test.ts`, so direct ESLint invocation
cannot parse the three new test files. This is an existing lint-configuration boundary; the
same files compile and pass under Vitest. No dependency was added. The last committed exact
baseline Security Scan is green, but the new uncommitted candidate has no exact GitHub SHA;
an exact-candidate Security Scan remains mandatory before any staging promotion.

Local build warnings for absent/malformed Upstash configuration are the established local
environment limitation. They did not prevent compilation or route generation.

## 3. Preconditions For Human Smoke

Use `http://localhost:3000`. For every P1 management item, use the explicit canonical route
`http://localhost:3000/platform?tab=support&subtab=tickets`; `/support` is the client-facing
ticket surface even when opened by a P1 account. The existing local dev process is rooted in
`/Volumes/isostack/Git/isostack-bedrock`; if it has been restarted, run the ordinary dev
command on port 3000 after confirming that port is free.

Prepare only disposable, non-sensitive records:

1. one P1 Platform owner/manager account;
2. one C1 tenant Owner or Admin;
3. two ordinary Members in that same tenant, each able to create a distinct ticket;
4. at least one second tenant ticket for P1 count/filter reconciliation; and
5. one controlled requester mailbox and one monitored support-operation mailbox.

In P1 Email & Notifications, review the seeded `support@isostack.dev`, `tech@isostack.dev`
and `billing@isostack.dev` records. Do not assume they are monitored. Configure the chosen
controlled local-test destination, then use the deliberate Test action. Never paste provider
credentials or real client content into the evidence.

## 4. Combined Human Local Smoke

Record `PASS`, `FAIL` or `BLOCKED` beside every item and retain ticket numbers plus provider
message/audit IDs where useful. Do not copy authentication cookies or provider credentials.

### A. Client privacy and lifecycle authority

1. **[PASS]** As C1 Owner/Admin, open Support and confirm the heading is `Organisation Tickets`,
   all and only that tenant's tickets are present, and status is read-only.
2. **[PASS]** Open a tenant ticket, add a public reply, refresh/reopen it and confirm persistence.
3. **[PASS]** Close that ticket, confirm exact `closed`, then Reopen and confirm exact `open`.
   Confirm no arbitrary lifecycle or priority/classification input is offered.
4. **[PASS]** As Member A, create a ticket and confirm the list is `My Tickets` and contains the
   Member A request.
5. **[PASS]** As Member B in the same tenant, confirm Member A's ticket is absent and a direct
   identifier/navigation probe is refused without leaking ticket content.
6. **[PASS]** As P1, open Member A's ticket, add one internal note and one public reply. - No input for internal note.  Public reply generates email - and saves and is visible by Member B - PASS
7. **[]** As C1 and then Member A, refresh and inspect the ticket: the public reply is visible
   and the internal note is absent from both rendered UI and the ticket-detail network body.
8. **[ ]** Confirm P1 still sees both entries plus full status, Priority, Severity, Impact and
   Category controls.

   FIXED Note:  There are no filters in the P1 dashboard - there should be impace, subject and client filters in addition to the existing lifecycle stage and free text search.
   Note 2. Content visibility: The row should be an accordion that opens to reveal more details - response date Status - there is no input for the P1 to update next action date, see previous activity etc etc.  The crud modal is the same as the Memebr/C1 who created the ticket.

### B. Routing and complete event coverage

9. **[PASS]** Before testing, confirm routing health reports each untested/missing/ambiguous
   destination truthfully and does not claim Ready.
10. **[PASS]** Configure one monitored platform default and any intended category overrides.
    Confirm scoped legacy records are absent or explicitly resolved.
11. **[PASS]** Preview Technical, Billing, Feature Request and Other. Confirm each shows the exact
    override or the mandatory default without sending email.
12. **[PASS]** Use the confirmed Test action on every effective destination. Confirm receipt and
    accepted evidence, then confirm overall routing becomes Ready.
13. **[PASS]** As Member/C1, create a controlled ticket. Confirm one support-operation message and
    one requester acknowledgement, correct tenant/ticket identity and working links.
14. **[PASS]** Add a client public reply. Confirm support receives it and requester does not receive
    a redundant echo.
15. **[PASS]** Add a P1 internal note. Confirm no external support or requester message is sent.
16. **[PASS]** Add a P1 public reply. Confirm only the requester receives the support reply.
17. **[PASS]** Apply one non-closure P1 status change and then Close. Confirm the requester receives
    the applicable status message and explicit closure message.
18. **[FAIL - No triage inputs are editable - they appear to be but they dont change and cannot be saved.]** Reopen/Close as the client. Confirm support-operation notification and requester
    confirmation without loss of the ticket change.
19. **[PASS]** As P1, create one tenant ticket with an explicit requester and one without. Confirm
    the first targets that requester; the second displays the no-requester warning and records
    requester delivery as skipped rather than emailing P1 as the client.
20. **[PASS]** Perform a controlled invalid-destination/provider-rejection check. Confirm ticket or
    reply persistence succeeds, failure evidence is visible/actionable, and correction plus a
    new explicit test restores Ready. Do not disturb a real monitored address.

### C. P1 operational dashboard and classification

21. **[Cant edit triage status]** With known tickets across two tenants, reconcile Open, In Progress, Waiting
    Response, Resolved, Closed and Total independently. Confirm Waiting is never counted as
    Closed.
22. **[FAIL]** Apply Client, Status, Severity, Impact, Module, Category and reviewed-state filters
    individually and in representative combinations. Confirm rows, every card, Total,
    unreviewed and aging all describe the same filtered population.
23. **[PASS]** Search by exact ticket number, title text, requester and organisation. Confirm search
    composes with active filters and no unrelated tenant result appears.
24. **[ ]** Open one known unreviewed ticket. Confirm it becomes reviewed once with the current
    P1 actor; reopen/refresh and confirm the original timestamp/actor remains unchanged.
25. **[ ]** Set distinct Severity, Impact, Priority and Category values. Reopen and confirm every
    value persists independently; historic null values remain readable as untriaged.
26. **[ ]** Change status and add a comment while filters are active. Confirm all affected
    summaries refresh and filter state is retained.
27. **[ ]** Reconcile oldest-unreviewed and the `<1 day`, `1–3 days`, `3–7 days`, `>7 days`
    buckets against known creation times.
28. **[ ]** Confirm explicit loading, empty and error presentation and inspect the queue/detail,
    cards and filters at desktop and narrow mobile widths.
29. **[ ]** As C1, directly request the P1 stats, classification and routing procedures through
    the browser session and confirm refusal.
30. **[ ]** Final combined regression: refresh both C1 and P1 Support pages, reopen sampled
    tickets and routing settings, and confirm all saved facts and counts remain stable with no
    provider send caused by a read, preview or unrelated edit.

## 5. Acceptance And Next Decision

Acceptance requires all 30 items to pass, or an explicitly documented bounded exception that
does not weaken privacy, lifecycle authority, routing evidence or count integrity. Any
internal-note disclosure, cross-requester visibility, unauthorised mutation, lost ticket
write, silent routing success or count/population mismatch stops the candidate and opens a
bounded local correction.

After human acceptance, the next formal action is a commit proposal and exact-SHA dev
Security Scan. Staging promotion requires separate user authority and a concise staging
smoke derived from this completed local gate. FUND remains parked until the Support project
is either accepted or explicitly re-dispositioned.
