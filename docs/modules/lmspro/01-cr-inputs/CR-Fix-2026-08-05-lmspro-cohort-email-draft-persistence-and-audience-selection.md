# CR-Fix — LMSPro Cohort Email Draft Persistence And Audience Selection

Date: 2026-08-05

Type: `CR-Fix` — remedial regression and operational correction input

Owning lane: LMSPro / SeasonPro communications using shared IsoStack communications
infrastructure

Environment: Live production observation, supported by read-only production diagnosis and
application-source review

Current disposition: **F1 human staging smoke passes. F2 is superseded. F2.1 local and
final staging human smoke pass entirely green. Exact commit `9974eed5` is aligned across
dev, staging and main after explicit control-owner promotion authority. Production review
then identified that current-season Team/Club statuses do not constrain applicable
audience sources and instead add recipients as independent cohorts. Urgent F2.2 triage is
accepted; its corrected additive-source/restrictive-eligibility plan was authorised and
implemented at `ec7e0cc4`, now exact on dev/staging with human smoke pending. Existing
saved drafts remain outside scope. The
uploaded-file-only acknowledgement correction retains identifier F3 and follows F2.2.**

Application baseline reviewed: `7154937c`

Authoritative child roadmap:

`docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`

Related capacity CR:

`docs/modules/lmspro/01-cr-inputs/2026-08-05-lmspro-500-recipient-email-operating-envelope-refinement.md`

Accepted triage:

`docs/modules/lmspro/02-triage/2026-08-05-lmspro-cr-fix-f1-f2-cohort-email-draft-persistence-and-audience-selection-triage.md`

Accepted F1/F2 slice plan:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f1-f2-cohort-email-draft-persistence-and-audience-selection-planning.md`

Local F1/F2 implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-05-lmspro-cr-fix-f1-f2-cohort-email-draft-persistence-and-audience-selection-local-confirmation.md`

Replacement F2.1 plan:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f2-1-cohort-taxonomy-and-picker-correction-planning.md`

F2.1 local implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-05-lmspro-cr-fix-f2-1-cohort-taxonomy-and-picker-correction-local-confirmation.md`

Urgent F2.2 triage:

`docs/modules/lmspro/02-triage/2026-08-05-lmspro-cr-fix-f2-2-current-season-eligibility-and-count-integrity-triage.md`

Bounded F2.2 plan:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f2-2-current-season-eligibility-and-count-integrity-planning.md`

F2.2 implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-05-lmspro-cr-fix-f2-2-current-season-eligibility-and-count-integrity-confirmation.md`

F3 attachment-policy planning refinement:

`docs/modules/lmspro/01-cr-inputs/2026-08-05-lmspro-cr-fix-f3-uploaded-file-only-acknowledgement-planning-refinement.md`

## 0. Latest Control-Owner Review

```text
F1 broad-cohort Save Draft persistence = human staging PASS
F2 independent BOTH-role selection     = FAIL; requirement itself rejected
Combined F1/F2 release                 = not eligible for live promotion
Next corrective boundary               = F2.1 cohort taxonomy and picker correction
```

F1 should be retained. F2.1 must replace the failed F2 behaviour before the combined
candidate returns to staging. The failure does not reopen the F1 persistence diagnosis.

F2.1 completed that replacement at exact commit `9974eed5`. Local and final staging human
smoke pass all ten checks; the dev and staging Security Scans and public staging health
pass. The control owner then authorised main promotion, and main was fast-forwarded and
pushed to the same commit. Exact Render live confirmation and controlled production Save
Draft evidence remain to be recorded before the incident-ending milestone closes.

### F2.2 Production Audience-Scope Finding

Production review of the promoted picker exposed a separate high-severity authority defect:

- Age Group and Division resolution does not explicitly constrain Team or Club status;
- Team Status and Club Status are independent recipient-producing cohorts rather than
  constraints;
- status filters are concatenated as recipient-producing cohorts before address
  deduplication;
- a selected Club Role is tenant-wide and is not restricted through authoritative
  status-eligible Club membership; and
- the `Club histories` badge counts distinct Club-dashboard visibility records, not people.

The observed `62 Club histories` when only 53 Clubs are considered Current is consistent
with this source defect. Exact production identities remain unqueried and unresolved.

The corrected F2.2 objective is current-season scope; Team/Club status defaults of Current;
additive union of selected Age Group, Division, explicit Club, League Role, Club Role and
other recipient-producing sources; source-specific restrictive status eligibility;
status-only selection producing no recipients; exact C1-defined role IDs; primary-contact
Club Secretaries for eligible Clubs; and one resolver contract for preview/persistence
counts.

### Send Confidence Boundary

F2.1 does not change delivery. Draft creation persists the resolved/deduplicated audience
as `EmailRecipient` rows. Send reloads those same rows and passes them into the established
no-attachment batch route or attachment job route.

The successful real 414-recipient no-attachment send, F1 broad-draft evidence and F2.1
audience/draft PASS provide high confidence that a correct no-attachment draft will reach
the established sender as expected. They do not constitute a fresh provider-delivery test
of exact build `9974eed5`; provider availability, address validity and runtime rate/quota
remain operational dependencies.

## 1. Executive Remedial Statement

LMSPro Save Draft fails for sufficiently large or complex cohort audiences before any
provider delivery is invoked. Controlled tests show smaller age-group audiences saving
successfully while larger combined Team Manager and Club Secretary audiences return HTTP
500 with the misleading message:

```text
The email operation could not be completed; no new files were retained
```

A controlled 411-recipient Save Draft used
`communications.emails.create`, returned HTTP 500 and waited 5.92 seconds for the server.
The current Prisma interactive transaction uses the default five-second execution deadline,
and the current Email-to-Club writer creates Club visibility rows sequentially. This is
strong evidence of transaction expiry, but the exact Prisma/Render exception remains an
explicit unresolved evidence item until the corresponding service log is captured.

This is not an attachment-upload failure, acknowledgement failure, Resend failure or email
delivery failure. It is a draft-persistence regression in the Email/recipient/Club-audience
transaction.

The fault is an appropriate urgent operational expedite candidate because the apparent
workarounds are incomplete:

- excluding Club Secretaries omits intended recipients;
- splitting by age group can send duplicate messages to overlapping Club Secretaries or
  other shared addresses; and
- proceeding directly to Send is not a safe diagnostic because successful draft creation
  would then invoke provider delivery.

## 2. Control And Non-Authorising Boundary

This `CR-Fix`:

- captures the incident, evidence, risks, containment and proposed resolution;
- registers the fault in the authoritative LMSPro child roadmap;
- records the control owner's accepted urgent operational expedite;
- links the accepted F1/F2 triage and bounded slice plan; and
- cross-links the separate 500-recipient operating-envelope refinement.

By itself, this source CR does not:

- authorise application code, schema, migration, production-data or infrastructure change;
- claim the exact Prisma error without Render evidence;
- declare 411 or 500 provider delivery supported;
- require a real recipient send for reproduction or acceptance;
- reopen or rewrite completed R8/R9 evidence;
- permit weakened Club visibility or tenant scoping to improve performance; or
- extend the accepted F1/F2/F3 boundaries or replace their lifecycle evidence.

Bounded implementation authority is supplied by the accepted triage and slice plan linked
above, not by the source CR alone.

## 3. Observed Behaviour And Reproduction Evidence

### 3.1 Save Draft Behaviour

Controlled live tests established:

- Save Draft is enabled only when subject and body content exist; recipient selection is
  not required.
- A draft with no selected recipients saved successfully.
- Adding U8 with Team Managers and Club Secretaries saved successfully.
- Adding U8 and U13 with Team Managers and Club Secretaries saved successfully.
- Adding U11 to U8 and U13 failed Save Draft.
- U8 and U9 with Team Managers and Club Secretaries failed Save Draft.
- U8 and U9 with Team Managers only saved successfully.
- Single age groups, including U12, saved with Team Managers and Club Secretaries.
- Various combinations failed when Club Secretary audiences increased the combined
  recipient/Club-link workload.

The reported failing update response identified:

```text
path = communications.emails.update
httpStatus = 500
code = INTERNAL_SERVER_ERROR
```

This proves that changing the audience on an already created draft can fail before Send.

### 3.2 Controlled 411-Recipient Create Evidence

A separate controlled Save Draft with the intended broad cohort produced:

```text
procedure                 communications.emails.create
HTTP status               500 Internal Server Error
response completed        2026-08-05 11:49:53 UTC
waiting for server        5.92 seconds
Render request ID         1fbd4e83-3ce1-4dd2
attachments               0
external document links   0
provider Send procedure   not invoked
```

No authentication cookie, request body, recipient address or message content is retained in
this lifecycle record.

Because `communications.emails.create` failed, the compose UI could not proceed to the
separate `communications.emails.send` mutation. This was a Save Draft test, not an email
send, and Resend was outside the execution path.

### 3.3 Live Cohort Shape And Passing/Failing Boundary

Read-only production resolution using the application resolver and audience planner
returned:

| Controlled audience | Deduplicated recipients | Club visibilities | Visibility-recipient links | Observed Save Draft |
| --- | ---: | ---: | ---: | --- |
| U8, Team Managers + Club Secretaries | 85 | 35 | 86 | PASS |
| U8 + U13, both recipient types | 136 | 40 | 137 | PASS |
| U8 + U9, Team Managers only | 119 | 43 | 121 | PASS |
| U8 + U9, both recipient types | 157 | 45 | 159 | FAIL |
| U8 + U13 + U11, both recipient types | 209 | 48 | 210 | FAIL |

The current broad all-type operating estimate remains:

```text
411 deduplicated recipients
63 Club contexts
459 recipient-to-Club links
```

The live resolver found no unresolved tenant, Club, Team, age-group or season context for
the tested U8 audience. The planner completed successfully for the passing and failing
combinations. Failure therefore occurs after resolution/planning, inside or immediately
after persistence.

## 4. Confirmed Technical Findings

### 4.1 Create And Update Share The Club-Audience Transaction Boundary

Both Save Draft paths persist the Email, recipients, Club visibilities and visibility links
as one atomic operation. Send first requires successful draft creation/update, so this
fault precedes provider delivery.

The update route is heavier than initial creation because it:

1. deletes existing Club visibility rows;
2. deletes and recreates all Email recipients when cohort filters change;
3. recreates Club visibility rows;
4. recreates visibility-recipient links; and
5. writes an audit record.

### 4.2 Club Visibilities Are Written Sequentially

`replaceEmailClubAudience` loops over every planned Club visibility and awaits an individual
nested create. Recipient links are nested below each Club row. The update caller also
deletes existing visibilities before invoking a helper which performs another delete for the
same Email.

This work occurs inside an interactive transaction with no route-specific `maxWait` or
`timeout` override. Prisma documents five seconds as the default interactive-transaction
execution timeout.

The 5.92-second browser timing is strongly consistent with pre-transaction request work
followed by a five-second transaction expiry. Exact `P2028` or other Prisma error evidence
is still required from Render before implementation confirmation may call the error proved.

### 4.3 Deduplication Is Not The Primary Failure Mechanism

Recipient resolution deduplicates trimmed, lowercased addresses and unions exact Club IDs.
The global merge repeats that normalisation, and Club recipient plans use sets to prevent a
recipient ID being linked twice to the same Club visibility.

Club Secretaries make failure more likely because they increase the deduplicated recipient
and visibility-link graph. The measured pass/fail boundary follows persisted graph size more
closely than it follows the mere presence of a duplicate address.

Deduplication semantics still require regression tests because the first matching entity
context is retained while Club IDs are merged. Correct performance work must not lose
multi-Club audience evidence or alter shortcode identity silently.

### 4.4 Role Selection Has A Separate Taxonomy Collision

The original diagnosis assumed that a `BOTH`-scope database role was legitimately one
League recipient role and one Club recipient role. F2 therefore gave the two presentations
independent selection state. Human staging review proved that diagnosis wrong.

The product distinction is:

- C1, C2 and C1+C2 hat-swap describe access/dashboard context;
- League Roles and Club Roles are functional role cohorts; and
- access context must not be duplicated into functional role lists.

The current provider nevertheless includes `BOTH` in both role trees and both server
resolvers. This is a taxonomy and authority defect, not merely a checkbox-key collision.
F2.1 must remove the duplication at the provider/resolver boundary and handle affected
saved filters explicitly.

### 4.4A Recipient-Type Placement Is Misleading

`Include recipient types` appears globally above the entire cohort picker, but source
review confirms it is attached only to `divisions` and `ageGroups` filters. It does not
affect role, Club, contact, referee, venue or status cohorts.

F2.1 must align this control visually with Divisions/Age Groups and make its limited scope
explicit.

### 4.5 Attachment And Link Gating Are Not The Draft Failure

The failing tests contained no attachments and no dedicated external document links.
Attachment preparation returns immediately for an empty attachment set, and the current
acknowledgement check does not block a genuinely resource-free email.

Ordinary hyperlinks inside body HTML and links introduced by the template footer are not
parsed as uploaded files. The separate External Document Links control is currently counted
as a gated resource. The control owner has clarified the desired policy:

```text
only actually uploaded files require responsibility acknowledgement;
ordinary and dedicated external links do not
```

URL validation and safe rendering should remain, independently of attachment
acknowledgement.

### 4.6 Error Classification Conceals The Root Cause

The create/update resource wrapper catches otherwise unclassified exceptions and returns a
file-retention message. Database, transaction, audit or Club-visibility errors can therefore
be presented as attachment failures even when no file exists.

The route does not currently guarantee a credential-safe log of the underlying phase,
Prisma code and aggregate workload. This delays diagnosis and encourages incorrect operator
action.

## 5. Incident Containment

Until a correction is accepted and verified:

1. do not use a live 411-recipient Send as a diagnostic;
2. use Save Draft only for controlled reproduction, with DevTools open and no provider send;
3. do not claim that splitting age groups is a safe equivalent because shared recipients
   may receive duplicates across separate sends;
4. do not omit Club Secretaries where they are part of the intended business audience;
5. preserve exact request time, response path, duration and Render request ID for failures;
6. never retain authentication cookies or full personal recipient payloads in evidence; and
7. obtain the matching Render exception before finalising root-cause language.

## 6. Risk Assessment

Scale: Likelihood and impact are assessed as Low, Medium, High or Critical for current live
operation and for the proposed correction.

| Risk | Current likelihood | Current impact | Correction risk | Required control |
| --- | --- | --- | --- | --- |
| Core bulk communication cannot be drafted for the intended audience | High | High | Low | Expedite decision; reproduce with Save Draft only; prove 411 and candidate 500 draft cases |
| Separate smaller sends duplicate messages to shared Club Secretaries/managers | Medium/High | High | Low | Do not accept split-send workaround as equivalent; retain global dedup proof |
| Removing Club Secretaries omits intended recipients | High if used as workaround | High | Low | Acceptance must include mixed manager/secretary cohorts |
| Incorrect bulk visibility construction exposes one Club's Email to another | Low currently | Critical | High | Preserve exact tenant/season/Club foreign keys; cross-Club authenticated negative tests; fail closed atomically |
| Bulk optimisation loses multi-Club context for one deduplicated address | Medium | High | High | Assert one provider recipient with every exact authorised Club link retained |
| Transaction expires and rolls back legitimate draft work | High above observed boundary | High | Medium | Bulk writes first; justified explicit timeout only as headroom; rollback/fault-injection tests |
| Partial Email/recipient/visibility graph survives failure | Low under current transaction | High | Medium | Preserve one atomic transaction; verify no orphan/partial rows after forced failure |
| C1/C2/hat-swap access context is presented as duplicate functional roles | High when role cohorts are used | High | Medium | F2.1 exact-scope role lists and server validation; no duplicated `BOTH` entries |
| Recipient-type modifier appears to affect unrelated cohorts | High | Medium | Low/Medium | Place it with Divisions/Age Groups and test that other cohorts are unchanged |
| Existing draft contains a now-invalid BOTH role filter | Unknown | High | Medium | Aggregate inventory; warn and block Send until explicit operator review; no silent rewrite |
| Generic file error causes incorrect diagnosis and unsafe retries | High | Medium/High | Low | Phase-aware safe server logging and neutral actionable UI errors; no addresses/content/secrets |
| Increasing timeout alone creates longer locks and hides inefficient writes | High if used as sole fix | Medium/High | High | Treat bulk persistence as primary correction; measure transaction; bound timeout and lock exposure |
| Attachment delivery or resource integrity regresses during shared-router change | Low | High | Medium | Existing attachment/no-attachment tests plus controlled staging regression; keep provider route unchanged |
| Links remain unnecessarily blocked by attachment acknowledgement | High under current dedicated-link UI | Medium | Medium | Separate URL validation from uploaded-file acknowledgement; explicit UI/server/readiness tests |
| A diagnostic action accidentally sends live email | Medium | High | Low | Use Save Draft acceptance; assert no `.send` request/provider event; controlled content remains secondary protection |

Overall current risk: **High operational**, with **Critical implementation sensitivity** at
the tenant/Club visibility boundary. The correction is suitable for expedited planning but
not for an unreviewed timeout-only hotfix.

## 7. Accepted Expedite Decision

Accepted child disposition:

```text
Urgent operational CR-Fix expedite accepted.
F1 and F2 are the urgent remedial release.
F3 is the immediate follow-on unless the accepted inclusion check proves it safe, trivial
and non-delaying, in which case it may share the urgent release.
```

Later amendment: F3 failed that inclusion check and remained separate. Production review
then accepted the more serious F2.2 audience-authority triage ahead of F3. The historic
decision above remains provenance, not the current execution order.

The root portfolio is reconciled as:

```text
NOW  = LMSPro CR-Fix — cohort email draft persistence and safe audience selection
NEXT = FUND 1R-F-A bounded planning candidate
```

The control owner completed the R10-A production smoke as totally green. R10-A is closed and
FUND `1R-F-A` is restored as formal planning-only `Next` without gaining implementation
authority.

## 8. Accepted Resolution Structure

One `CR-Fix` holds the related evidence, but implementation planning should preserve four
bounded sub-slices.

### CR-Fix F1 — Scalable Atomic Draft Persistence And Observability

Priority: Minimum incident-ending expedite slice.

Accepted outcome:

- persist Email-to-Club visibility parents and recipient links using bounded bulk
  operations rather than one awaited Club create per loop;
- remove redundant visibility deletion where caller/helper responsibilities overlap;
- retain pre-generated IDs and exact composite tenant/season/Email/Club relationships;
- preserve a single atomic transaction and fail-closed rollback;
- measure the optimised transaction before choosing an explicit timeout;
- if still justified, apply a bounded route/global transaction deadline as safety headroom,
  not as the primary performance correction;
- emit credential-safe phase evidence containing procedure, aggregate counts, elapsed time,
  Prisma code/category and request correlation, but no address, content, attachment name,
  URL, cookie or token; and
- replace the file-oriented catch-all with neutral errors that distinguish resource policy,
  transaction/persistence and provider delivery phases.

### CR-Fix F2 — Cohort Role Selection And Deduplicated Audience Correctness — Failed

Priority: Historical coupled slice included in commit `07a71906`; rejected by human
staging review.

Historical implemented outcome, no longer accepted:

- key role checkbox state by cohort type plus role ID;
- allow the League and Club representation of a `BOTH` role to be independently selected
  and unselected;
- show exact selected filters and deduplicated provider-recipient/Club-audience counts;
- retain one provider recipient per normalised address;
- merge every exact authorised Club context across Team, Club and User evidence; and
- define/test which entity supplies shortcode context when one address occurs through
  several cohort sources.

Replacement: F2.1 defines access context separately from functional roles, restricts role
cohorts to exact scope and contextualises the Division/Age Group recipient-type modifier.

### CR-Fix F2.2 — Current-Season Eligibility And Count Integrity

Priority: Urgent audience-authority correction before the attachment-policy F3.

Accepted planning outcome:

- server-resolve the exact current season;
- default Team and Club status constraints to Current while allowing deliberate
  multi-status selection;
- union independently eligible Age Group, Division, explicit Club, League Role, Club Role
  and other selected audience sources before global address deduplication;
- treat Team/Club statuses only as restrictive filters on sources with the relevant
  authoritative relationship, never as recipient-producing cohorts;
- return zero recipients when only status controls are selected;
- retain primary-contact Club Secretary semantics for qualifying structural Clubs;
- resolve exact C1-defined Club Roles as an additive source through active User role plus
  authoritative status-eligible Club membership, independently of selected structural
  sources and without hard-coded names;
- derive provider-recipient and Club-history counts from the same plan used by Save Draft;
- make the Recipients-tab badge display the complete resolved count;
- clear the stale Draft list filter after a successful Send while retaining deliberate
  status filtering; and
- preserve F1 atomic persistence, F2.1 taxonomy and provider/attachment behaviour.

Implementation is complete at `ec7e0cc4`, exact on dev/staging with automated and build
gates green. Staging human smoke is required before any main/live promotion.

### CR-Fix F3 — Uploaded-File-Only Acknowledgement Policy

Priority: Bounded policy follow-on after the more serious F2.2 audience-authority
correction.

Accepted conditional outcome:

- require responsibility acknowledgement only when uploaded files exist;
- do not gate body links, template/footer links or dedicated external document links;
- retain HTTPS/credential/length validation and safe rendering for dedicated links;
- keep attachment fingerprints, validation and send readiness fail closed; and
- update UI wording, server persistence/readiness semantics and tests consistently.

## 9. Accepted Technical And Review Plan Summary

The accepted detailed implementation contract is the linked F1/F2 slice plan. This section
retains the CR-level phase summary and must not be used to weaken that plan's gates.

### Phase 0 — Close Diagnosis Evidence

1. Retrieve Render logs for request `1fbd4e83-3ce1-4dd2` around
   `2026-08-05 11:49:47–11:49:53 UTC`.
2. Record the exact Prisma code/message and transaction metadata if present, without
   personal data; otherwise record the observability gap explicitly.
3. Confirm failed Save Draft created no committed partial Email/recipient/visibility graph.
4. Confirm no `communications.emails.send` call or Resend provider event occurred.

Stop condition: if the Render error is not transaction expiry, revise F1 root-cause language
before implementation.

### Phase 1 — Accept Bounded Remedial Design

1. Map the exact create and update queries and expected row cardinality at 85, 136, 157,
   209, 411 and candidate 500 recipients.
2. Choose the bulk-parent/bulk-link persistence strategy supported by the current Prisma and
   PostgreSQL constraints.
3. Define atomic rollback, duplicate-key and tenant-boundary invariants.
4. Set an explicit target transaction envelope and only then decide timeout headroom.
5. Preserve F1 and F2 as the urgent release boundary and leave F3 explicitly follow-on if
   it could delay or destabilise that boundary.

### Phase 2 — Implement F1 In The Application Repository

1. Add safe failure-phase observability first so local/staging failures retain their cause.
2. Bulk-persist visibility parents and recipient junctions.
3. Remove redundant delete/rebuild work where correctness permits.
4. Preserve create/update parity and exact audit evidence.
5. Add the bounded timeout only after the bulk path is measured and reviewed.

No schema migration is currently expected. Any discovered schema need stops the slice for
fresh migration/risk review.

### Phase 3 — Replace Failed F2 Through F2.1

F2 was implemented but failed human staging because its product contract was wrong. Retain
the green F1 boundary and implement F2.1 only after explicit acceptance of its replacement
plan. F3 remains a later, separate milestone under the still-open CR-Fix.

### Phase 4 — Automated Verification

Required tests include:

1. create draft with zero recipients;
2. create and update mixed manager/secretary cohorts at the observed passing/failing
   boundaries;
3. create and update the real-shape 411-recipient/63-Club/459-link case using safe fixtures;
4. candidate 500 unique recipients with overlapping cohort sources;
5. one normalised provider recipient retaining multiple exact Club contexts;
6. duplicate source filters producing no duplicate provider recipient or Club link;
7. forced failure proving complete rollback and no orphan graph;
8. wrong-tenant Team/Club context failing closed;
9. no provider dispatcher invocation during Save Draft;
10. F2.1 exact-scope League/Club role presentation, exclusion of duplicated `BOTH` access
    state and contextual Division/Age Group recipient-type behaviour;
11. uploaded file requiring acknowledgement; and
12. body/footer/dedicated external links not requiring acknowledgement if F3 is accepted,
    while URL validation continues to reject unsafe links.

Tests must exercise more than the existing one-visibility/one-link fixture.

### Phase 5 — Controlled Staging Human Proof

1. Deploy the exact reviewed candidate to staging.
2. Use controlled non-sensitive subject/body content and no uploaded file.
3. Save—not Send—the exact mixed cohort corresponding to the 411-recipient live shape.
4. Record displayed deduplicated recipient and Club-audience counts.
5. Confirm draft success, reopen the draft and verify the counts remain exact.
6. Confirm the browser network contains create/update only and no Send mutation.
7. Confirm no Resend provider event occurred.
8. Exercise the accepted F2 `BOTH` role select/unselect boundary.
9. Complete authenticated cross-Club visibility negative tests using controlled data.
10. Run focused attachment/no-attachment regression without a broad live delivery.

### Phase 6 — Promotion And Live Verification

1. Promote through the ordinary `dev -> staging -> live` corridor after PASS evidence.
2. Perform a controlled live Save Draft at the business-required cohort, without Send.
3. Reopen and verify exact counts and absence of partial/duplicate Club visibility.
4. Confirm safe logs and request duration remain within the accepted envelope.
5. Do not declare the separate 500-recipient provider-send envelope accepted from this
   draft-only correction.

### Phase 7 — Reconcile And Resume

1. Create the implementation confirmation and independent review/test record.
2. Update this `CR-Fix` inventory row with exact implementation, evidence and live state.
3. Reconcile the LMSPro child roadmap and root `Now`/`Next`.
4. Retain the recorded R10-A totally-green closure; no resumption remains.
5. Retain or deliberately reconsider FUND `1R-F-A` as the formal planning-only portfolio
   candidate.
6. Refresh the SeasonPro printable summary.

## 10. Acceptance Criteria

The incident-ending slice is acceptable only when:

1. the exact underlying failure has been recorded or the diagnosis explicitly revised;
2. broad mixed-cohort Save Draft succeeds atomically at the real 411-recipient shape;
3. the safe candidate-500 draft fixture passes without implying provider-delivery support;
4. create and update both pass; success of one route does not substitute for the other;
5. transaction work is bulk/bounded and measured; timeout extension alone is insufficient;
6. provider delivery is not invoked during Save Draft testing;
7. deduplication produces one provider recipient per normalised address while retaining all
   authorised Club contexts;
8. cross-tenant/cross-Club visibility tests pass negatively and positively;
9. forced errors roll back the whole graph;
10. the UI no longer presents a database failure as a file-retention problem;
11. selector state represents `type:id` correctly for the accepted F2 release boundary;
12. attachment-only acknowledgement semantics pass if F3 is in the release;
13. existing attachment and no-attachment delivery regressions remain green; and
14. exact staging and live evidence is recorded without personal data or credentials.

## 11. Do Not Build / Explicit Exclusions

- Do not send a real 411- or 500-recipient email merely to prove draft persistence.
- Do not declare 500 provider delivery supported or impose a new hard maximum here.
- Do not remove Club visibility, recipient evidence or tenant foreign keys for speed.
- Do not persist visibility after the Email transaction as an eventually consistent
  best-effort side effect.
- Do not use email-address inference for Club history.
- Do not increase the transaction timeout as the only correction.
- Do not introduce retrospective Email-to-Club history backfill.
- Do not change the attachment delivery worker, provider rate or retry contract unless a
  separately accepted finding proves it necessary.
- Do not include unrelated communications redesign or template-editor work.
- Do not record recipient addresses, message content, authentication cookies or private URLs
  in lifecycle evidence.

## 12. Rollback And Recovery

The preferred correction is application-only and should require no migration or production
data change.

Rollback must:

- revert the bounded application change through the normal release corridor;
- preserve the last known safe schema and prospective Club-visibility records;
- leave failed drafts atomically absent rather than partially materialised;
- restore the prior error path only if necessary while retaining enough safe diagnostics to
  understand the rollback cause; and
- reapply incident containment and re-dispose this `CR-Fix` rather than claiming closure.

If implementation discovers that a schema change is required, stop and create an additive,
reviewed migration plan with explicit rollback and production compatibility evidence.

## 13. Open Decisions And Evidence Gaps

1. Exact Render/Prisma exception for the 411-recipient request.
2. Measured confirmation that the accepted 10-second `maxWait` and 30-second transaction
   timeout provide material headroom after the bulk correction.
3. F3 did not pass the inclusion check; it remains separate and is now sequenced after the
   urgent F2.2 audience-authority correction.
4. Whether 500 remains an evidence target, becomes a supported envelope or later becomes a
   server hard maximum; this remains owned by the separate capacity CR.
5. Exact live operational date by which the intended communication must be available.

Unresolved items remain explicitly unresolved; they do not prevent registration or an
expedite decision based on the confirmed operational evidence.

## 14. Recorded Control-Owner Decisions

The control owner has decided:

1. accept the urgent operational expedite;
2. keep this `CR-Fix` as portfolio `Now`, close R10-A on its totally-green production smoke
   and restore FUND `1R-F-A` as formal planning-only `Next`;
3. include F1 and F2 in the urgent remedial release under the accepted slice plan; and
4. retain F3 as the immediate follow-on within this CR-Fix; the pre-promotion review found
   it cross-cutting rather than safe/trivial, so it was excluded from `07a71906`; and
5. accept urgent F2.2 triage for current-season eligibility, additive audience sources and
   truthful counts,
   preserving F3's existing identifier and sequencing F2.2 before it.
