# LMSPro CR-Fix F1/F2 Cohort Email Draft Persistence And Audience Selection Planning

Date: 2026-08-05

Module: LMSPro / SeasonPro communications using shared IsoStack communications
infrastructure

Status: **IMPLEMENTED AT `07a71906`; F1 HUMAN STAGING PASS; F2 HUMAN STAGING FAIL AND
SUPERSEDED BY F2.1; LIVE PROMOTION BLOCKED**

No application implementation was performed while creating this plan.

CR-Fix:

`docs/modules/lmspro/01-cr-inputs/CR-Fix-2026-08-05-lmspro-cohort-email-draft-persistence-and-audience-selection.md`

Accepted triage:

`docs/modules/lmspro/02-triage/2026-08-05-lmspro-cr-fix-f1-f2-cohort-email-draft-persistence-and-audience-selection-triage.md`

Local implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-05-lmspro-cr-fix-f1-f2-cohort-email-draft-persistence-and-audience-selection-local-confirmation.md`

Staging human-smoke schedule:

`docs/modules/lmspro/05-review-and-test/2026-08-05-lmspro-cr-fix-f1-f2-staging-readiness-and-human-smoke-schedule.md`

Replacement F2.1 plan:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f2-1-cohort-taxonomy-and-picker-correction-planning.md`

## 0. Supersession Notice

The F1 contract in this document remains valid and passed control-owner human staging
smoke. The F2 contract did not: it incorrectly required independent League/Club selection
of a duplicated `BOTH` access-mode role.

Every F2 requirement below is retained as historical evidence of what commit `07a71906`
implemented, but is superseded for future work and acceptance by F2.1. No F2 independent
`BOTH`-checkbox test may be used as a release gate.

Exact application recovery baseline:

```text
7154937cb620232b457b19d09c5dc97ae0417a73
```

## 1. Accepted Outcome

Deliver an urgent application-only correction which:

1. saves and updates broad mixed LMSPro cohort drafts atomically without exceeding the
   transaction envelope;
2. preserves every exact tenant/season/Club audience link for each deduplicated provider
   recipient;
3. historically attempted independent `BOTH`-scope League/Club checkbox identity; this
   outcome is now rejected and replaced by F2.1;
4. emits safe, phase-accurate persistence diagnostics and operator feedback; and
5. proves the real-shape 411-recipient case plus a safe candidate-500 fixture without
   sending provider email.

F1 and F2 form the urgent release. F3 remains an immediate follow-on within the same
CR-Fix. It may join the release only when the bounded inclusion check in Section 10 proves
that it is small, safe and cannot delay F1.

## 2. Confirmed Source Boundary

### 2.1 Draft Persistence

`src/core/services/communications/routers/emails.router.ts` owns create, update,
duplicate-to-draft and update-recipient transactions.

Create/update currently:

- resolve and deduplicate recipients before the transaction;
- plan exact Club audiences before the transaction;
- create or replace the Email recipients;
- call the Club-audience persistence helper;
- write one audit record; and
- catch otherwise unclassified errors through a file-oriented resource wrapper.

The update and update-recipient routes must delete Club visibility before deleting old
Email recipients because visibility-recipient rows have a restrictive composite recipient
foreign key. The current update path deletes visibility once directly and then the helper
deletes it a second time.

### 2.2 Email-To-Club Persistence

`src/core/services/communications/lib/email-club-audience.ts` currently awaits one nested
`emailClubVisibility.create` for every Club. Each parent then creates its recipient links.

The schema already has pre-generatable IDs and the required composite keys. Direct bulk
junction insertion must explicitly include:

```text
id
visibilityId
emailId
emailRecipientId
```

No schema migration is required for bulk parent and junction `createMany` operations.

The Prisma/RLS middleware applies session context before ORM queries. Sequential Club
creates therefore multiply database/context round trips inside the transaction. The
implementation must reduce ORM statement count rather than merely extend the deadline.

### 2.3 Cohort Selection

`src/core/services/communications/components/CohortPicker.tsx` currently builds one global
`Set` of selected IDs. The same `BOTH` role ID appears under both League and Club role
trees, so visual selection does not distinguish source type.

Server recipient merging already normalises trimmed, lowercase addresses and unions Club
IDs. This authority remains server-side.

### 2.4 Current Tests

The focused Club-audience test proves deduplication and one visibility/link writer case. It
does not prove bulk persistence, replacement ordering, hundreds of recipients, rollback or
role-tree identity. No focused CohortPicker selection test currently exists.

## 3. F1 Implementation Contract

### 3.1 Separate Delete And Bulk Insert Responsibilities

Refactor the audience writer into explicit operations with one owner each, for example:

```text
deleteEmailClubAudience(transaction, emailId)
insertEmailClubAudience(transaction, emailId, organizationId, plan, finalizedAt?)
```

The exact names may differ, but the contract must be clear:

- delete existing visibility exactly once where replacement is required;
- create all visibility parents with one bounded `createMany` when the plan is non-empty;
- flatten all visibility-recipient links and create them with one bounded `createMany`;
- generate explicit junction IDs and include the composite parent/recipient Email ID;
- do not use `skipDuplicates`, because an unexpected duplicate must fail and roll back;
- do nothing safely for an empty plan; and
- preserve input plan ordering only where externally meaningful; database row order is not
  an authority.

Required transaction ordering:

```text
CREATE
Email + EmailRecipients
-> bulk visibility parents
-> bulk visibility-recipient links
-> audit

UPDATE / UPDATE RECIPIENTS
delete visibility graph once
-> replace EmailRecipients and Email data
-> bulk visibility parents
-> bulk visibility-recipient links
-> audit where the existing route already audits
```

Duplicate-to-draft and every other current helper caller must use the same bounded insertion
contract. No caller may retain the old sequential loop accidentally.

### 3.2 Transaction Envelope

After bulk persistence is implemented and measured, use explicit transaction options for
the bounded draft graph operation:

```text
maxWait = 10 seconds
timeout = 30 seconds
```

These values match established long-running transaction conventions elsewhere in the
application and provide operational headroom. They are accepted only with the bulk
correction; a timeout-only change is outside scope.

Tests and staging evidence must record actual elapsed time. Normal 411/500 fixture work
should remain materially below the 30-second ceiling. If it approaches that ceiling, stop
instead of increasing it again.

### 3.3 Safe Diagnostics And Error Feedback

Add one credential-safe persistence error reporter at the create/update boundary. It may
record:

- procedure (`create`, `update`, `duplicateToDraft`, `updateRecipients`);
- phase (`resolve`, `plan`, `resource-prepare`, `transaction`, `post-commit-read`);
- aggregate recipient, Club visibility and link counts;
- attachment and dedicated-link counts;
- elapsed milliseconds;
- safe error class/name and Prisma code; and
- an available request/correlation identifier already provided by the runtime.

It must not record:

- recipient addresses or names;
- subject/body content;
- Club, Team, user, Email or attachment IDs;
- attachment names, private object keys or URLs;
- cookies, session values or tokens; or
- raw request payloads.

Keep policy/readiness errors actionable. Replace the generic database catch with a neutral
operator message which states that the draft was not saved and no email was sent. Do not
mention retained files when no file operation failed.

### 3.4 Atomicity And Post-Commit Boundary

`databaseCommitted` handling must continue to distinguish transaction failure from a later
canonical-read failure. Resource compensation remains best effort only for private objects
uploaded before a failed transaction.

The implementation must not report a committed draft as absent merely because the
post-commit read failed. If this distinction requires separate catch boundaries, add them
within F1 and test them.

## 4. F2 Implementation Contract — Superseded

**Do not implement or accept further work from this section. See the linked F2.1 plan.**

### 4.1 Type-Aware Selection Identity

Represent selection identity as:

```text
<cohort type>:<node ID>
```

The League and Club representations of the same `BOTH` role must therefore have independent
checked state and independent toggle behaviour.

Selection identity is UI state only. Submitted filters remain the current typed structure:

```text
{ type, ids[] }
```

Do not change role database IDs or role scope.

### 4.2 Deduplicated Audience Authority

Retain server-side case-insensitive trimmed email deduplication. When the same address is
resolved from multiple source filters:

- produce one `EmailRecipient`;
- union every exact authorised Club ID;
- produce at most one visibility-recipient link for each Club/recipient pair; and
- preserve an explicitly tested representative entity context for shortcode resolution.

This slice must document/test the current first-source-wins entity rule. It must not invent
multi-entity shortcode rendering without a separate accepted design.

### 4.3 Operator Count Consistency

The preview response, successful Save Draft response, reopened draft count and planned Club
audience count must agree for the same filters. F2 does not require a new recipient-preview
interface, but any existing count labels must remain truthful.

## 5. Expected Application Files

Primary F1:

- `src/core/services/communications/lib/email-club-audience.ts`;
- `src/core/services/communications/lib/email-club-audience.test.ts`;
- `src/core/services/communications/routers/emails.router.ts`; and
- focused router/persistence tests in the nearest established communications test location.

Primary F2:

- `src/core/services/communications/components/CohortPicker.tsx`;
- a focused CohortPicker or extracted pure selection-helper test; and
- cohort/audience resolver tests where overlapping source semantics require coverage.

Conditional F3 only if Section 10 permits inclusion:

- `src/core/services/communications/components/ComposeEmailModal.tsx`;
- `src/core/services/communications/routers/emails.router.ts`;
- `src/core/services/communications/lib/email-resource-readiness.ts`;
- `src/core/services/communications/lib/email-resource-policy.ts` only if naming/separation
  is required; and
- their focused tests.

Documentation after implementation:

- one `04-implementation-confirmations` record;
- one independent `05-review-and-test` record with staging/live Save Draft evidence; and
- child/root/printable reconciliation.

## 6. Automated Evidence

### 6.1 Bulk Writer Unit Contract

Prove:

- zero visibilities performs no create;
- one and many visibilities use one parent bulk call and one link bulk call;
- every parent carries exact organization, season, Email, Club, source and finalisation
  fields;
- every junction carries explicit ID, visibility ID, Email ID and recipient ID;
- duplicate visibility/recipient input is not silently skipped;
- replacement deletes once and in the required pre-recipient order; and
- injected parent, link or audit failure rolls back the complete draft graph.

### 6.2 Scale Fixtures

Use deterministic non-personal fixtures for:

| Case | Purpose |
| --- | --- |
| 0 recipients | Empty draft regression |
| 85 / 35 / 86 | Known live passing-shape baseline |
| 136 / 40 / 137 | Upper observed passing case |
| 157 / 45 / 159 | First observed failing combination |
| 209 / 48 / 210 | Larger observed failing combination |
| 411 / 63 / 459 | Exact broad live-shape draft case |
| 500 unique recipients with overlapping sources | Candidate capacity and deduplication fixture, draft only |

Both create and update must be exercised. A create pass does not substitute for update.

### 6.3 Tenant And Club Isolation

Prove:

- a Club/Team outside the organization still fails closed before persistence;
- composite Email/organization and Club/season/organization evidence is preserved;
- a recipient shared by two authorised Clubs creates exactly two authorised links;
- no unrepresented Club receives visibility;
- C2 Club A cannot list or open Club B evidence; and
- forced transaction failure leaves no partial Email, recipient, visibility or junction row.

### 6.4 F2 Selection And Deduplication — Historical Rejected Gate

The following checks describe the rejected F2 contract and are not current acceptance
criteria:

Prove:

- selecting the League representation does not visually select the Club representation;
- each representation can be independently checked and unchecked;
- selecting both produces two typed filters but one deduplicated provider recipient where
  their users overlap;
- Club IDs from all exact sources are retained;
- filter removal removes the correct typed filter; and
- preview/saved/reopened counts remain consistent.

### 6.5 Existing Regression Gates

Run at minimum:

1. changed-source focused tests;
2. communications cohort, audience, resource policy/readiness and sender tests;
3. changed-file lint;
4. `npm run type-check`;
5. `npm test -- --run`;
6. `npm run verify`;
7. `npm run build`;
8. `git diff --check`; and
9. exact-commit repository Security Scan at the required dev/staging gates.

If the full test command differs in the current repository, use the current package scripts
as authority and record the exact command/result.

## 7. Phase 0 Diagnostic Closure

Before or as the first bounded implementation action:

1. search Render production logs for request `1fbd4e83-3ce1-4dd2` around
   `2026-08-05 11:49:47–11:49:53 UTC`;
2. record the Prisma code/message if present, without payload data;
3. if the caught cause was not logged, record that observability gap rather than inventing
   `P2028` certainty;
4. implement safe diagnostics first;
5. reproduce the pre-correction case against safe local/staging fixtures; and
6. stop/revise the plan if the captured exception contradicts transaction-expiry diagnosis.

## 8. Controlled Human Staging Schedule

Precondition: staging runs the exact reviewed candidate and contains safe controlled
fixture/business-equivalent cohorts.

1. Open a fresh Chrome session with DevTools Network, Preserve log and Disable cache.
2. Create subject/body content containing no personal data.
3. Select no recipients and Save Draft; confirm success.
4. Update through 85, 136, 157, 209 and 411-equivalent mixed audience shapes; confirm each
   Save Draft succeeds.
5. Reopen the draft after each selected boundary and confirm exact provider-recipient and
   Club-audience counts.
6. Do not execute the former independent `BOTH`-role toggle check; it is superseded.
7. Execute the replacement role-taxonomy and contextual recipient-type smoke in the F2.1
   plan after its implementation is accepted.
8. Confirm Network contains `.create`/`.update` but no `.send` mutation.
9. Confirm Resend contains no provider event for these Save Draft operations.
10. Record server wait and safe persistence timing for the 411 and candidate-500 cases.
11. Inject/trigger the accepted safe failure fixture and confirm the UI reports draft
    persistence failure without referring to files or claiming an email was sent.
12. Complete authenticated Club A/Club B list/detail negative checks against the saved
    controlled evidence.

Do not use a live recipient send as an acceptance test for F1/F2.

## 9. Promotion And Recovery

Promotion corridor:

```text
bounded branch from exact 7154937
-> local technical PASS
-> reviewed implementation confirmation
-> dev integration and exact Security Scan
-> staging promotion and exact Security Scan/health
-> Section 8 human PASS
-> independent review/test acceptance
-> explicit live promotion
-> controlled live Save Draft verification without Send
```

No schema migration or production data mutation is expected. Recovery is a Git revert of
the bounded application commits. Failed Save Draft operations must remain atomically absent.

If a schema need, partial persistence, cross-Club exposure or provider invocation is found,
stop promotion and return to triage.

## 10. F3 Inclusion Check And Immediate Follow-On

Recorded decision on 2026-08-05: **F3 did not pass this inclusion check and was excluded
from F1/F2 commit `07a71906`.** Its UI, persistence, duplicate-draft, send-readiness and
standalone-delivery coupling requires a separate bounded implementation and focused tests.
It remains the immediate follow-on under this CR-Fix.

F3 may join the urgent release only if source review and focused tests establish all of:

- the change is limited to separating `hasStoredResources` from
  `requiresFileAcknowledgement` semantics;
- dedicated links remain validated and fingerprinted where integrity requires it;
- only uploaded attachments control acknowledgement fields/UI/readiness;
- duplicate-to-draft and reopened-draft state remain coherent;
- existing attachment delivery tests remain green;
- the change is independently reviewable in a separate commit/change group; and
- it does not delay F1/F2 staging readiness.

If any condition is not met:

1. release and verify F1/F2 first;
2. keep the CR-Fix and portfolio `Now` open;
3. create the bounded F3 plan/confirmation/review as the immediate second milestone; and
4. retain FUND `1R-F-A` as formal planning-only `Next`; R10-A is already closed.

## 11. Acceptance Gates

The original F1/F2 urgent release cannot be accepted because F2 failed human staging.
F1 remains accepted at its human staging boundary; the replacement combined candidate is
accepted only when F2.1 satisfies its own gates in addition to the applicable F1 gates
below:

1. create and update pass at the real-shape 411 case;
2. the safe candidate-500 draft fixture passes;
3. parent and junction persistence is bounded/bulk and no old sequential caller remains;
4. measured transaction time has material headroom below 30 seconds;
5. a forced failure proves atomic rollback;
6. exact tenant/Club visibility positive and negative tests pass;
7. overlapping sources produce one recipient with every authorised Club link;
8. `BOTH` role representations select/unselect independently;
9. preview, saved and reopened counts agree;
10. Save Draft invokes no provider sender;
11. error/log evidence is phase-accurate and credential/personal-data safe;
12. existing attachment and no-attachment delivery regressions remain green;
13. staging human proof passes; and
14. implementation confirmation and independent review/test records are complete.

## 12. Explicit Exclusions

- No real 411/500 provider send for draft acceptance.
- No declaration or enforcement of a 500-recipient delivery maximum.
- No provider rate, batch, quota or attachment-worker change.
- No schema migration or retrospective Club-history backfill.
- No address-based Club inference.
- No eventual/best-effort visibility persistence outside the Email transaction.
- No timeout-only correction.
- No broad cohort-tree or role-authority redesign.
- No multi-entity shortcode redesign beyond documenting/testing current representative
  context.
- No unrelated template/editor/communications UI work.
- No secrets or personal recipient/content evidence in logs or lifecycle documents.

## 13. Implementation Stop Conditions

Stop and return to control if:

- the exact failure is not transaction-related and requires a materially different design;
- bulk operations cannot preserve the composite foreign-key boundary;
- a schema/migration becomes necessary;
- transaction work remains near the 30-second deadline after bulk correction;
- any cross-tenant or cross-Club test fails;
- Save Draft invokes provider delivery;
- F2 requires role-authority/data-model changes; or
- F3 threatens F1/F2 delivery or attachment integrity.

## 14. Completion And Portfolio Handoff

After F1/F2 and the accepted F3 milestone complete:

1. mark the CR-Fix with exact implementation/review/live evidence;
2. reconcile the LMSPro child roadmap;
3. release root `Now` for the next explicit control decision;
4. retain or deliberately reconsider FUND `1R-F-A` as root `Next`;
5. refresh the SeasonPro printable summary; and
6. keep the separate 500-recipient operating-envelope CR open until provider-delivery
   support is independently triaged and proved.
