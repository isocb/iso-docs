# FUND B1-R2 — Event Catalogue Workflow Scope And Lifecycle Integrity Review And Test

Date: 2026-09-10

Status: **Combined candidate pushed to dev/staging at `133a4638`; staging migration 156 PASS; local human smoke PASS retained; staging deployment/business acceptance and remaining review proof open.**

Current candidate: application `133a4638` on local work branch, dev and staging. Original
local behavioural candidate `29104b55` and DevData migration 156 evidence below remain valid;
see the promotion section for the security integration, test-only follow-up and staging proof.

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

No blocking automated or connected defect is known. Chris reports the local human smoke green;
independent source review remains open.

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
| Independent review | PENDING | Separate review not obtained; owner-authorised dev/staging promotion does not claim this evidence |
| Human C1/C2 smoke | PASS — owner reported, 2026-09-10 | Aggregate report below; not agent-observed or staging evidence |

## Human Result — 2026-09-10

Chris confirmed: “Fund testing all green”. This records acceptance of the local smoke
against the current B1-R2 candidate `29104b55` and existing local Neon DevData test bed
(migration 156, recorded target fingerprint `257f63f2e2c2`). His edits to the
[B1-R1 schedule](2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-review-and-test.md)
record PASS for all 13 steps, including retests of the earlier blocked/failed steps.

The B1-R2 result is an aggregate owner report for the schedule below. No separate per-step
times, role/tenant readback or new agent-observed browser/database evidence was supplied in
this report. Existing automated/connected evidence retains its original scope. Independent
review, outstanding B1-R1 connected proof, security-fix integration and combined-candidate
checks were open at the time of that report; the promotion update below records subsequent
proof. This does not accept the separate Platform staging security checks or
complete the full FUND Phase 1 purchase/production journey.

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

## Authorised Dev/Staging Promotion — 2026-09-10

Chris explicitly requested alignment of online dev with the tested local code and promotion
to staging. The combined merge is `b3059b307a29d539ca09b2ea6d1fc2d8a7297c9d`:
FUND `29104b55` plus the isolated security correction `0397bba9`. Main/live stays at
`0397bba9`; separate FUND live approval has not been given. The combined application build
passes (131 pages), as does the full unit suite (527 PASS, 12 opt-in database tests skipped).
The exact [dev Security Scan](https://github.com/isocb/isostack-bedrock/actions/runs/34483281209)
passes. No actual environment file or credential is included in the application change.

The connected rehearsal found a stale test-only ledger expectation (154 rather than 156).
It is corrected in `133a4638` without changing application behaviour or migration SQL. The
connected B1 rerun passes and pre-commit TypeScript/critical-file checks pass. Separate source review remains
unproven; publication is owner-authorised and does not convert this evidence gap into PASS.

### Migration boundary and recovery

Staging target fingerprint `3c30b31a7cb5` is distinct from local DevData and production.
Preflight found 153 applied migrations and three pending FUND migrations, 38 FUND tables
with 28 rows, one Event, three Projects and no FUND Order contexts. Migration 155 deliberately
refuses existing unclassified Events. Chris explicitly approved backing up and clearing
only staging FUND test data before applying migrations 154–156. No shared-user, organisation,
LMSPro or other-module reset is authorised. No local test data is copied to staging.

The private FUND archive was decoded successfully: 305,050 bytes, SHA-256
`9337c44020157eae8ca8dcc9532c8b88d716e0f17a9918e0c23164e5b7f5a121`.
Archive contents and connection details are excluded from Git. Retain the private archive
through staging acceptance. The reset uses all FUND tables together without CASCADE, with
locked count checks; preservation proof compares all 125 non-FUND table counts.

Twenty-three older applied checksums differ from current migration files, but every checksum
matches a historical committed migration blob. None is changed by this release. Do not
rewrite migration history or resolve these as newly applied migrations. September migration
checksums and schema must independently match after deploy.

On reset precondition failure, stop before deletion. On migration failure, keep FUND testing
paused, inspect the migration ledger and use a reviewed forward correction; do not blindly
rerun a partial reset or rewrite ledger checksums. A return to old application code alone is
unsafe after the schema contraction. Recovery of the removed test setup requires a compatible
pre-change FUND schema and the private archive, while preserving shared schemas; any such
recovery needs a separately reviewed operation. Main/live and local DevData stay untouched.

### Disposable connected proof and cleanup

PASS on a dedicated test endpoint, independently distinguished from local DevData, staging
and production: fresh 154 baseline replay; existing Event migration refusal with no partial
schema application; 154-to-156 upgrade preserving an unrelated organisation sentinel; B1
service authority/offer/document suite; separate fresh replay of all 156 migrations. Both
uniquely created proof databases were dropped and their absence independently read back.
Temporary migration workspaces were removed; redacted logs remain private. No synthetic
rows entered application databases.
This is temporary test evidence, not a new production database/recovery arrangement.

### Staging execution result

Final application commit `133a4638e2590a8405d3ce52d6d8c8a7c0336b5a` is pushed to both dev
and staging by ordinary fast-forward. Main remains `0397bba9`. The local FUND work branch is
fast-forwarded to the same final commit; environment files and local DevData were not edited. A clean Node 22 dependency install,
request-body backport and Prisma client generation pass locally. Installed Next 15.5.25,
Sharp 0.35.4 and js-yaml 4.3.2 retain the security correction; npm reports zero High/Critical
findings (30 Moderate/5 Low remain under the separate assurance follow-up).
The approved staging reset and Prisma deploy completed: all 156 migrations applied, zero
failed ledger entries, new migration checksums and Event/Catalogue columns verified.
All 125 non-FUND table counts match the pre-reset snapshot. No FUND Orders were removed.

Exact final scans: [dev 34484492277](https://github.com/isocb/isostack-bedrock/actions/runs/34484492277)
and [staging 34484545160](https://github.com/isocb/isostack-bedrock/actions/runs/34484545160)
both PASS (secret, dependency, schema, TypeScript and summary jobs). Public staging probes at 13:45 UTC pass on both staging.isostack.app and staging.seasonpro.co.uk:
health HTTP 200/database connected/RLS 11/11, expected unauthenticated login redirects,
local PNG-to-WebP response and disallowed remote-image refusal. These do not identify the
deployed source commit. Render confirmation and the
representative authenticated workflow below remain pending.

### Focused staging human acceptance — PENDING

Chris confirmed the two requested staging-only artwork emulation settings and reported a
Render deployment starting. This is owner-reported configuration, not independent provider
readback. No authenticated Render access is available to this session.

Record exact deployed commit, C1/C2 roles, tenant and PASS/FAIL for:

1. Confirm Render is Live/green at the final staging commit. Log in and out of the existing
   IsoStack/LMSPro account; confirm the correct client/dashboard and an existing image.
2. Create a small new FUND setup through normal C1/public Intake/C2 flows. Confirm Product
   creation has no workflow field, Catalogue channel and workflow multiselect save, Event
   Products assigns only compatible Catalogues, and C2 sees active eligible Products.
3. Check one Event-linked Project inherits workflow and one standalone Project chooses it.
   Exercise C2 subset Save/refresh and one incompatible Catalogue exclusion. Confirm active
   linked Projects prevent Event closure and active Events cannot archive.
4. As C1 assign the Individual template; as the exact organiser refresh, review and finalise
   an offer. Generate/download its labelled development PDF, confirm refresh/re-download and
   the finalised selection lock. Confirm this does not publish the Store or enable purchases.

This proves the new staging configuration and migrated environment. Preserve the broader
local PASS rather than repeat the entire local matrix. A failure pauses staging acceptance;
report the screen, role and error without credentials. B1 closure, separate review, remaining
R1 negative proof and FUND main/live promotion are not inferred from deployment.
