# FUND B1-R2 — Event Catalogue Workflow Scope And Lifecycle Integrity Review And Test

Date: 2026-09-10

Status: **Exact-candidate automated, migration and connected proof PASS; independent review and human acceptance pending.**

Candidate: application `29104b55` on `work/fund-b1-r1-catalogue-workflow`; DevData migration 156,
target fingerprint `257f63f2e2c2`.

## Review Result

The candidate implements the confirmed two-dimensional Catalogue rule:

```text
Catalogue channel includes Event or Standalone
AND Catalogue workflows include the effective Event/Project workflow
```

Product identity remains workflow-neutral. Event assignment, standalone automatic sourcing and
C2 Product selection retain their separate authority. Event Products and Product/Catalogue
Availability use the same Event-Catalogue records.

Source review confirms that the canonical Event and standalone eligibility queries filter the
Catalogue itself. Event assignment validates the locked Event workflow and Catalogue scope.
Catalogue workflow contraction uses the availability lock already consumed by Project selection,
offer finalisation, Store refresh and checkout. No browser-only eligibility decision was added.

Event close and Project creation/activation share an Event lifecycle lock. Event status
transition is checked after the lock is acquired; close counts active linked Projects inside the
same serializable transaction. Project activation rechecks linked Event status under that lock.
The connected race test proves that either close wins and activation refuses, or activation wins
and close refuses; the invalid closed-Event/active-Project pair did not commit.

No blocking automated or connected defect is known. Independent source review and the human
screen/wording judgement below remain open.

## Automated And Connected Evidence

| Check | Result | Evidence limit |
| --- | --- | --- |
| TypeScript | PASS | Full repository type check |
| Production build | PASS | Exact feature source; 131 static pages |
| FUND unit tests | PASS | 8 files, 30 tests; workflow multiselect and strict Event transitions included |
| Prisma schema | PASS | Format, validation and generated client |
| Migration | PASS | Guarded local DevData 155-to-156 and exact ledger/schema/constraint readback |
| Connected eligibility | PASS | Event/standalone positive and negative Catalogue workflow filtering |
| Connected lifecycle | PASS | archive/close negatives, valid close/archive and close/activation race |
| Connected cleanup | PASS | Original bounded row counts restored; no synthetic proof rows retained |
| Critical-file verification | PASS | Intentional schema modification reviewed |
| Whitespace/credential scan | PASS | No environment file, credential assignment, database URL, token or private key staged |
| Independent review | PENDING | Must assess exact candidate before promotion |
| Human C1/C2 smoke | PENDING | Schedule below |

## Human Smoke Requirements

Use the existing local C1 and C2 test identities and DevData test bed. Record candidate, role,
tenant, time and PASS/FAIL. A failed step stops acceptance but does not erase earlier passes.

### A. Catalogue channel and workflow scope

1. Open Products -> Catalogues. Edit one Catalogue and confirm **Supported workflows** is a
   multiselect containing Individual Artwork, Group Artwork, Logo/Bulk Personalisation and
   Standard. Confirm the existing Catalogue initially has all four selected.
2. In Availability, confirm each Catalogue separately shows **Channel availability** and
   **Supported workflows**. Set one Catalogue to `Events and standalone Projects` with only
   Standard; set a second Event-capable Catalogue to Individual Artwork.
3. Confirm an empty workflow selection is refused. Restore the intended selections after the
   negative check.

### B. Event-context Product planning

4. Open a Standard Event and its **Products** tab. Confirm the Standard Catalogue is offered and
   the Individual-only Catalogue is absent. Assign the Standard Catalogue and Save.
5. Return to Products -> Availability and confirm the same Event/Catalogue assignment is shown.
   Change it there, return to the Event Products tab and confirm both screens remain aligned.
6. Confirm the Event tab shows contributed Product code, name and Product status. Confirm its
   link opens Product/Catalogue management and that Event detail does not edit Catalogue scope,
   Product membership or C2 Product selection.
7. Repeat with an Individual Artwork Event and confirm only workflow-compatible, Event-capable
   Catalogues are offered.

### C. Standalone Project enforcement

8. As C2, create/open one Standard standalone Project. Confirm its Products tab offers Products
   only through active Catalogues whose channel includes standalone and whose workflows include
   Standard.
9. Create/open an Individual Artwork standalone Project and confirm the Standard-only Catalogue
   contributes nothing. Change the Catalogue to include Individual Artwork as C1, refresh, and
   confirm it becomes available without automatically overriding a previously curated C2 subset.
10. Remove a workflow that supplies a selected Product's last Catalogue source. Confirm the
    Product remains visibly selected but unavailable and finalisation/trading refuses until the
    source or selection is resolved. Restore the workflow and confirm a prior C2 exclusion is not
    reversed.

### D. Product and membership status clarity

11. In an active Catalogue, choose a draft Product in **Find Product**. Confirm the option says
    `DRAFT` and the screen explains that Catalogue preparation does not make it Project-eligible.
12. Add it. Confirm **Product status** shows DRAFT while **Membership** separately shows Active.
    Confirm the C2 Project Products view does not offer it. Activate the Product as C1 and confirm
    it then becomes eligible through a compatible Catalogue.

### E. Event lifecycle integrity

13. Open a DRAFT Event. Confirm no Archive action is offered and a direct/stale archive attempt is
    refused by the server.
14. Activate the Event. Confirm no Archive action is offered.
15. With an ACTIVE linked Project, confirm Event Close is disabled with an explanation. Attempt a
    stale/direct close and confirm the server refuses it without changing either record.
16. Pause, close or complete the linked Project as appropriate. Close the Event, then confirm
    Archive becomes available and succeeds. Confirm closed/archived Events cannot receive new
    Project links or Catalogue changes.

### F. Resume B1-R1

17. Resume the [B1-R1 human schedule](2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-review-and-test.md)
    from its revised step 5. Continue multi-source removal, offer finalisation, immutable document
    evidence and later Catalogue withdrawal checks.
18. Treat full Store activation/payment/media/tax readiness separately from the bounded B1
    Individual offer/artwork acceptance, while recording every concrete server blocker.

## Promotion Gate

Human PASS does not itself promote the candidate. After independent review and recorded human
acceptance, reconcile B1/B1-R1/B1-R2 evidence and prepare controlled dev -> staging -> main
promotion. Staging must apply the versioned migration through `prisma migrate deploy` with target,
ledger and smoke readback. Live remains a later separately controlled gate.
