# LMSPro CR-Fix F1/F2 Cohort Email Draft Persistence And Audience Selection Triage

Date: 2026-08-05

Module: LMSPro / SeasonPro communications using shared IsoStack communications
infrastructure

Status: **ACCEPTED EXPEDITE; F1 HUMAN STAGING PASS; F2 SUPERSEDED; F2.1 FINAL STAGING
HUMAN PASS; `9974eed5` ALIGNED ACROSS DEV/STAGING/MAIN; LIVE EVIDENCE AND F3 FOLLOW-ON OPEN**

Source CR-Fix:

`docs/modules/lmspro/01-cr-inputs/CR-Fix-2026-08-05-lmspro-cohort-email-draft-persistence-and-audience-selection.md`

Related capacity CR:

`docs/modules/lmspro/01-cr-inputs/2026-08-05-lmspro-500-recipient-email-operating-envelope-refinement.md`

Accepted slice plan:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f1-f2-cohort-email-draft-persistence-and-audience-selection-planning.md`

Replacement F2.1 plan:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f2-1-cohort-taxonomy-and-picker-correction-planning.md`

## 0. Post-Implementation Triage Amendment

The control owner's staging review changes the F1/F2 disposition:

```text
F1 = human staging PASS
F2 = FAIL; original independent-BOTH-role acceptance model rejected
F2.1 = local and final staging human PASS; exact dev/staging/main alignment complete;
       live exact-build and controlled Save Draft evidence pending
```

F2's automated tests proved the code implemented its accepted contract. Human review
proved that contract conflated C1/C2/hat-swap access state with functional SeasonPro roles.
The correct response is a replacement product boundary, not more tests for the rejected
independent-checkbox behaviour.

## 1. Control-Owner Decision

The control owner explicitly accepts:

```text
Accept the CR-Fix expedite.
Include F1 and F2 in the urgent remedial release.
Retain F3 as an immediate follow-on under the same CR-Fix unless planning proves it is
safe and trivial to include without delaying F1.
```

This decision changes the root portfolio control. It authorises bounded F1/F2 planning and,
once the accepted plan's preconditions are met, implementation/review/promotion through the
normal controlled corridor. It does not authorise work outside the accepted CR-Fix.

## 2. Accepted Classification

```text
Type       CR-Fix live regression
Priority   Urgent operational expedite
Severity   High operational; Critical tenant/Club-visibility implementation sensitivity
Owner      LMSPro / SeasonPro communications
Now        CR-Fix production verification, then immediate F3 follow-on
Next       FUND 1R-F-A bounded planning candidate; implementation unauthorised
```

The control owner subsequently completed the R10-A production smoke as totally green. R10-A
is closed and FUND `1R-F-A` is restored as formal planning-only root `Next`.

## 3. Evidence Supporting Expedite

The decision is supported by:

- controlled live Save Draft failures before provider send;
- a 411-recipient `communications.emails.create` HTTP 500 after 5.92 seconds;
- passing smaller cases and failing larger combined manager/Club-secretary graphs;
- successful read-only cohort resolution and Club-audience planning with no unresolved
  tenant, Team, Club, age-group or season context;
- sequential Email-to-Club visibility persistence inside an interactive transaction;
- repeated RLS context setup around ORM operations, magnifying sequential round trips;
- a five-second default interactive-transaction deadline;
- update behaviour that deletes and rebuilds recipients/visibilities;
- a catch-all which reports database failures as file-retention failures; and
- a confirmed checkbox-identity collision for a role appearing in both League and Club
  trees.

The exact Render/Prisma error for request `1fbd4e83-3ce1-4dd2` remains a required Phase 0
evidence item. Its absence does not prevent the expedite decision, but contrary evidence
must revise the implementation diagnosis before code changes proceed.

## 4. Workaround Decision

No proposed workaround is accepted as a complete safe substitute:

- manager-only sends omit intended Club Secretaries;
- separate age-group sends can duplicate messages to shared recipients;
- UI role collisions can obscure the actual selected source filters; and
- a direct Send test could deliver real email if draft persistence happens to succeed.

Containment therefore remains controlled Save Draft reproduction only, without provider
send.

## 5. Accepted F1 Boundary

F1 is the minimum incident-ending release and may:

- add credential-safe persistence-phase diagnostics;
- replace sequential Club visibility and junction writes with bounded bulk operations;
- remove redundant visibility deletion while preserving update order and referential
  integrity;
- retain one atomic Email/recipient/Club-audience transaction;
- set an explicitly reviewed transaction `maxWait`/`timeout` only after bulk work is
  measured;
- provide accurate neutral Save Draft failure feedback; and
- add create/update regression evidence at observed boundaries, real-shape 411 and safe
  candidate-500 fixtures.

F1 may not weaken tenant/season/Club keys, move visibility persistence outside the atomic
transaction, infer Club context from addresses, send provider email during acceptance or
declare the separate 500-recipient delivery envelope supported.

## 6. Accepted F2 Boundary

**Superseded on 2026-08-05 by the F2.1 plan. Retained below as decision history only.**

F2 is coupled to the urgent release because unclear cohort selection can alter or obscure
the intended audience. It may:

- key checkbox state by cohort type plus entity ID;
- independently select/unselect one `BOTH` role under League and Club role trees;
- retain exact server-side address deduplication and multi-Club context union;
- define/test retained entity/shortcode context for overlapping source types; and
- prove preview, saved draft and reopened draft counts agree.

F2 may not redesign the cohort tree, change role scope/assignment authority, add new cohort
types or replace current server-side deduplication with browser authority.

## 6A. Proposed F2.1 Replacement Boundary

F2.1 may:

- define C1, C2 and C1+C2 hat-swap as access/dashboard context rather than functional
  recipient roles;
- expose only exact `LEAGUE` roles under League Roles and exact `CLUB` roles under Club
  Roles;
- exclude `BOTH` access-mode records from both browser trees and both server resolvers;
- reject newly submitted cross-scope or `BOTH` role IDs at the server resolver boundary;
- make cohort headings and selectable child rows visually unambiguous;
- reconcile truthful recipient counts/zero-recipient presentation; and
- position `Include recipient types` beside Divisions/Age Groups, the only cohort types it
  currently affects.

F2.1 may not add a new access-type email cohort, redesign dashboard hat swapping, mutate
role data, silently rewrite saved drafts, change deduplication or include F3.

This replacement boundary is accepted for implementation. Existing saved-draft inventory,
migration, warnings and compatibility are excluded; the sole user will delete test drafts.

## 7. F3 Follow-On Disposition

F3 remains accepted as a required follow-on under this same CR-Fix:

```text
Uploaded files require responsibility acknowledgement.
Body links, template/footer links and dedicated external document links do not.
URL validation and safe rendering remain mandatory.
```

Planning must perform a bounded inclusion check:

- if F3 is demonstrably small, independently testable and cannot delay or destabilise F1,
  it may share the urgent release as a separate commit/change group;
- otherwise F1/F2 must be reviewed and promoted first, then F3 proceeds immediately as a
  second release milestone under the still-open CR-Fix; and
- FUND `1R-F-A` remains formal planning-only `Next`; R10-A is closed.

Later root reconciliation on 2026-08-06 supersedes that original immediate ordering:
FUND `1R-F-A` is now portfolio `Now` for bounded planning and its conditional proof is
`Next`. F3 remains required and parked under this CR-Fix; it has not been cancelled,
completed or authorised for implementation.

## 8. Risk And Recovery Decision

The accepted technical strategy is bulk-first and atomic. A timeout-only fix is rejected.

Required controls:

- no schema or migration unless a new review stops and re-plans the work;
- complete rollback on injected failure;
- exact composite tenant/season/Email/Club and recipient/Email constraints retained;
- negative cross-tenant and cross-Club tests;
- no personal addresses, content, cookies, attachment names or URLs in logs/evidence;
- bounded per-transaction timeout with measured headroom;
- unchanged provider sender/attachment-job contract; and
- application rollback by reverting the bounded commits if any gate fails.

## 9. Promotion Decision

Authorised corridor:

```text
bounded implementation from exact current dev baseline
-> focused and full technical gates
-> exact dev integration and verification
-> exact staging promotion
-> controlled Save Draft human proof with no Send mutation/provider event
-> independent review and explicit live-promotion gate
-> controlled live Save Draft verification
-> roadmap reconciliation
```

The accepted expedite shortens decision latency but does not authorise a direct-production
hotfix or bypass staging.

## 10. Exit And Resumption

The urgent incident-ending milestone is complete only when F1/F2 acceptance and controlled
live Save Draft evidence pass. F3 then completes in the same release if safely included or
as the immediate second CR-Fix milestone.

Current root disposition:

```text
NOW  -> FUND 1R-F-A bounded planning
NEXT -> conditional FUND 1R-F-A executable proof candidate
PARKED REQUIRED -> Email CR-Fix F3 formal triage and bounded planning
```

The roadmap must record that transition rather than relying on chat memory.
