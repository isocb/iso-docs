# FUND B1-R2 — Event Catalogue Workflow Scope And Lifecycle Integrity Review And Test

Date: 2026-09-10

Status: **Correction `3379c4e9` committed/promoted to dev and staging; exact Render staging deployment, health, protected-branch security and connected proof PASS. Corrected Product-setup/finalisation/download human smoke pending; approved DRAFT staging test Seller prepared. Earlier aggregate PASS retained as history; FUND main/live not promoted.**

Current candidate: application `3379c4e9` on local/online dev and staging; see the corrected
smoke schedule and deployment evidence below. Earlier `133a4638` proof remains historical. Original
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

The historical automated/connected results and local human PASS below remain recorded.
On 2026-09-12 Chris reported staging step 4 FAIL because C1 template review/assignment UI
could not be found. That failure was resolved after the staging configuration/redeployment correction: Chris
subsequently reported “PASS - all green” for the retry. Independent source review remains open.

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

### Focused staging human acceptance — PASS (2026-09-12)

Chris initially reported setting the two staging-only artwork variables. On 2026-09-12,
after the disabled-mode failure, he authenticated the local Render CLI and redeployed the
same candidate. The provider settings and completed redeployment are now independently
verified below. Chris then reported “PASS - all green”, accepting the focused staging
checklist including the step 4 retry. This is owner-reported human evidence, not an
agent-observed browser session.

Record exact deployed commit, C1/C2 roles, tenant and PASS/FAIL for:

1. Confirm Render is Live/green at the final staging commit. Log in and out of the existing
   IsoStack/LMSPro account; confirm the correct client/dashboard and an existing image.
   **Chris: Pass - live for 133a463: test(fund): align B1 connected proof with migration 156 **
2. Create a small new FUND setup through normal C1/public Intake/C2 flows. Confirm Product
   creation has no workflow field, Catalogue channel and workflow multiselect save, Event
   Products assigns only compatible Catalogues, and C2 sees active eligible Products.
**Chris: PASS **

3. Check one Event-linked Project inherits workflow and one standalone Project chooses it.
   Exercise C2 subset Save/refresh and one incompatible Catalogue exclusion. Confirm active
   linked Projects prevent Event closure and active Events cannot archive.

**Chris: PASS **

4. As C1 assign the Individual template; as the exact organiser refresh, review and finalise
   an offer. Generate/download its labelled development PDF, confirm refresh/re-download and
   the finalised selection lock. Confirm this does not publish the Store or enable purchases.
   **PASS - Template  selection enabled **

This proves the new staging configuration and migrated environment. Preserve the broader
local PASS rather than repeat the entire local matrix. A failure pauses staging acceptance;
report the screen, role and error without credentials. B1 closure, separate review, remaining
R1 negative proof and FUND main/live promotion are not inferred from deployment.


### C1 template assignment investigation — 2026-09-12

Chris's initial report was steps 1–3 PASS, including Render Live at `133a463`, and step 4
FAIL: no UI found for C1 to review or allocate templates. At that point the remaining
actions in step 4 were blocked. The investigation below preserves that history; the later
retry PASS supersedes the failure.

Read-only source inspection at local candidate `133a4638` finds `IndividualOfferPanel`
mounted with `administration` on `/app/fund/projects/[id]`, above Overview/Products.
For an unfinalised Individual Artwork Project with emulation enabled, it contains a
Template selector and Save assignment action; for an Event-linked Project that action
assigns the Event template. No equivalent assignment control is mounted on Event detail.
Non-Individual Projects hide the panel; disabled emulation shows an explanatory alert,
and query errors show an error alert.

Chris subsequently confirmed the visible message: “Individual artwork is not enabled in
this environment.” The application reaches the panel but its server-side feature gate
returns disabled, hiding assignment controls. This establishes the immediate runtime gate,
not a missing Project-page component. The specific configuration cause remains unverified:
the same message covers disabled/missing mode and refused target/production signals because
`getIndividualJourney` deliberately catches configuration errors.

The accepted staging settings are `FUND_INDIVIDUAL_ARTWORK_MODE=emulated` and
`FUND_INDIVIDUAL_ARTWORK_TARGET=staging` on the staging web service only. Mode/target must
match exactly. A `main` branch signal or a production Vercel signal also refuses emulation;
those signals must not be falsified to bypass the guard. Chris previously reported setting
these variables, so verify the active service/deployment configuration rather than assume
that action was omitted. No authenticated Render connector, CLI or API credential was
available at that point. Chris subsequently enabled authenticated Render CLI access and
redeployed staging; direct provider readback and the successful retry are recorded below. Main/live and shared environment groups are outside this correction.

Disposition: the C1 visibility failure is resolved by the staging runtime correction and
owner-reported retry PASS. Retain B1 as Now for outstanding technical review/proof; this
human result does not authorise 1R-G implementation or FUND live promotion. No application
code or database change was needed to resolve this staging visibility failure.


### Authenticated staging configuration and redeployment readback — 2026-09-12

Chris authorised local Render authentication and completed browser-based CLI login. The
agent selected the sole workspace locally and performed read-only provider inspection.
Authentication remains outside the repositories; no token or credential content is recorded.

- Service: `Staging-IsoStack`, `srv-d4miroogjchc73balrvg`, branch `staging`.
- Provider readback confirms the exact service-level artwork mode/target values accepted
  above. Neither `RENDER_GIT_BRANCH` nor `VERCEL_ENV` has a service-level override; this
  does not claim a full inspection of inherited or process environment values.
- Chris's manual redeployment `dep-daihc30ae00c73eh9b50` is **Live**, at exact commit
  `133a4638e2590a8405d3ce52d6d8c8a7c0336b5a`, completed `2026-09-12T09:12:40.409088Z`.
  Startup log markers confirm Next ready and Render service live; raw logs were withheld.
- At approximately `09:13:03 UTC`, `/api/health` returns HTTP 200/healthy on both
  `sating-isostack.onrender.com` and `staging.isostack.app`: database connected and RLS 11/11.

The previous instance remained live while the replacement started. The saved settings and
completed replacement are now proved; authenticated C1 panel visibility and the complete
offer/PDF journey have not been observed by the agent. Chris subsequently reported the
step 4 retry PASS and “all green”; the focused staging human gate is now satisfied.
No application code, database, provider setting or deployment was changed by the agent;
Chris performed the redeployment. No FUND main/live promotion occurred.


### Final focused staging human result — 2026-09-12

Chris confirmed “PASS - all green” after the verified redeployment and invitation to repeat
step 4. His document edit also records “PASS - Template selection enabled”. Record the
focused steps 1–4 as PASS, including the Individual assignment/finalisation/development PDF,
refresh/re-download, locked selection and no-public-purchasing checks specified in step 4.
This is an aggregate owner report; no separate screenshots or agent-observed substep evidence
are claimed. It supersedes the initial disabled-mode failure, not the original failure history.

The aggregate staging acceptance was recorded at `133a4638`. The subsequent C2 finding below
qualifies finalisation/download acceptance. The requested technical review has since corrected
readiness responsibility, Project context transaction protection and the stale proof runner.
The listed R1 contraction guards, ten-case availability race matrix, fresh replay and cleanup
now pass locally; the B1 technical review records precise scope and candidate identity.
Corrections remain uncommitted/unpromoted, with independent reviewer attestation unclaimed.
B1 full closure and FUND main/live promotion remain open.


### Subsequent C2 finalisation finding — 2026-09-12

After the aggregate green report, Chris clarified that C2 sees the assigned template as
text, not a visual preview or download. He then confirmed that the review checkbox is
visible and ticked but “Finalise offer and generate artwork” remains disabled. This
qualifies the earlier aggregate acceptance: C1 template visibility is resolved, while the
reported C2 finalisation/download path requires diagnosis and a specific retry result.
No earlier owner result is erased or replaced with invented substep evidence.

B1 shows an offer-content/Product/price summary when readiness passes and provides its
labelled development PDF after finalisation and successful generation. Assignment text is
not a pre-finalisation visual artwork preview. Source inspection shows that the visible
checkbox establishes exact-organiser permission; the disabled action after acknowledgement
means unresolved reasons or a missing valid snapshot. The yellow readiness messages are
awaited. This is current B1 smoke work, not deferred template-editor scope.

The [B1 technical review](2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-review-and-test.md)
records the local corrections and connected proof separately from this staging finding.


### Corrected staging smoke — Product setup to development PDF

Chris requested these corrections be committed and promoted to staging for his test. Direct
read-only diagnosis found missing primary image and tax treatment, plus no Seller profile.
The editor controls and offer feedback have been corrected; the explicitly approved synthetic
DRAFT Seller profile is prepared on staging. This fixture does not enable Stripe or trading.
Run the following after the corrected deployment is confirmed Live:

1. **C1 → FUND → Products → Edit the selected Product** (the current staging selection is
   `Mug 2 Small`). Choose the intended test tax treatment and matching VAT rate, and Save.
   For the approved synthetic Seller fixture the standard/reduced rates are 20%/5%; this is
   test data, not a recommendation about the real Product's tax classification.
2. Reopen the Product. Under **Primary Product image**, choose an image and **Save primary
   image**. If the list is empty, open the linked Media library, upload a JPEG/PNG/WebP/GIF,
   return and **Refresh image list**. Image assignment has its own explicit Save action.
3. **C2 → Project → Store → Refresh Store configuration and offer**. Confirm the offer's
   named requirements disappear once resolved and its Product/price summary is shown.
   C2 should see the assigned template but no template or Product-image administration.
4. Review the summary, tick acknowledgement, then **Finalise offer and generate artwork**.
   Download the labelled development PDF; reload/re-download or retry generation if needed.
   Confirm the selection/content lock and that this does not publish the Store or enable
   purchasing. Unresolved payment/live-service gates remain expected in this development slice.
5. On a separate **unfinalised draft Project**, confirm the readiness owner for organiser
   finalisation is C2 and an allowed workflow/Event edit saves the correct context. Confirm
   the finalised Project from step 4 still refuses protected content/selection edits.

Results: **pending Chris's corrected staging test**. Earlier aggregate green reports remain
history; these specific checks are not inferred from them. Record any displayed requirement
by its text, not its colour. Exact candidate/deployment evidence follows when promotion finishes.


Corrected deployment confirmed: `3379c4e994a225c78238b5aed1d114e94c7dbaf0`, Render
`dep-daii93ss728c73aj7tng`, Live `2026-09-12T10:16:21.50129Z`. Both staging URLs healthy,
DB connected and RLS 11/11 at approximately `10:16:38 UTC`. New image mutation rejects a
signed-out request with 401; Product page redirects to sign-in. Work/dev/staging Security
Scans `34687362802` / `34687637710` / `34687647620` PASS. The five corrected smoke steps
above are now ready for Chris; **their human results remain pending**.
