# LMSPro CR-Fix F3 — Uploaded-File-Only Acknowledgement Planning Refinement

Date: 2026-08-05

Planning status: **IMMEDIATE FOLLOW-ON PLANNING INPUT AFTER F2.2 LIVE CONFIRMATION; REQUIRES
FORMAL TRIAGE AND AN EXPLICITLY ACCEPTED BOUNDED PLAN; NOT IMPLEMENTATION AUTHORITY**

Source request:

> Commence the F3 triage and planning process after the final minimum F2.1 production
> smoke is defined.

Parent CR-Fix:

`docs/modules/lmspro/01-cr-inputs/CR-Fix-2026-08-05-lmspro-cohort-email-draft-persistence-and-audience-selection.md`

Existing accepted triage:

`docs/modules/lmspro/02-triage/2026-08-05-lmspro-cr-fix-f1-f2-cohort-email-draft-persistence-and-audience-selection-triage.md`

Existing inclusion decision:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f1-f2-cohort-email-draft-persistence-and-audience-selection-planning.md`

Relevant prior attachment policy:

`docs/modules/lmspro/03-slice-planning/2026-07-21-lmspro-remediation-slice-r8-a2r-bounded-unscanned-attachment-policy-correction-planning.md`

Authoritative LMSPro roadmap:

`docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`

Parent portfolio control:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

## 1. Authority And Handoff Boundary

This document refines the already accepted F3 outcome and supplies evidence for formal
control-window triage and planning. It is subordinate to the parent CR-Fix, accepted
triage, LMSPro roadmap and root roadmap.

It does not:

- create a second CR;
- allocate an executable slice identifier;
- alter portfolio `Now` or `Next`;
- authorise application, schema, migration, data or deployment work;
- create implementation confirmation or test evidence; or
- claim that the production prerequisite or F3 has passed.

The control window must reconcile this refinement into the formal triage and planning
lifecycle before implementation begins.

## 2. Settled Product Decision

The control owner's settled policy is:

```text
uploaded file present
-> explicit C1 responsibility acknowledgement required before Send

no uploaded file
-> no acknowledgement checkbox or acknowledgement gate

ordinary body link, template/footer link or dedicated external document link
-> never treated as an uploaded file
-> never creates an acknowledgement requirement
```

Dedicated external document links remain managed resources for validation and safe
rendering. They must continue to use HTTPS, reject embedded credentials, observe existing
label/URL/count limits and be included in current resource-integrity evidence. Removing the
acknowledgement gate does not remove those controls.

This settled decision supersedes the narrower R8-A2R statement that required one combined
file-and-link acknowledgement. It does not reopen R8's private-storage, attachment
validation, attachment delivery or external-link validation decisions.

## 3. Controlling Terminology

The F3 implementation plan should use separate concepts consistently:

| Concept | Meaning | Governs acknowledgement? |
| --- | --- | --- |
| Uploaded attachment | File bytes selected through the upload control and persisted privately | Yes |
| Dedicated external document link | Labelled HTTPS URL entered through the separate link editor | No |
| Body/template/footer link | Hyperlink already present in rendered HTML | No |
| Validated resource set | Uploaded attachments plus dedicated external document links used for validation/fingerprint integrity | No, not by itself |
| Attachment acknowledgement requirement | Whether at least one uploaded attachment is present | Yes |

The current database field `attachmentSetFingerprint` is a legacy name for evidence that
currently covers attachments and dedicated links. F3 should not infer from that name that
links are attachments or require acknowledgement.

## 4. Existing Accepted Foundation

F3 must preserve:

- a maximum of three uploaded attachments and 10 MB cumulative file content;
- the current narrow file allowlist and actual-byte/type validation;
- private R2 storage, checksum, metadata and readback verification;
- a maximum of three labelled dedicated external document links;
- HTTPS-only URLs with no embedded username or password;
- deterministic fingerprinting of attachments and dedicated links;
- fail-closed detection when a persisted resource set changes or is unavailable;
- the links-only/no-attachment batch delivery route;
- the separate durable attachment-job route when one or more attachments exist;
- tenant, C1 communications authority and audit boundaries; and
- body/footer HTML rendering and sanitisation boundaries.

No evidence was found that body or template/footer hyperlinks are parsed as uploaded files.
The current defect concerns the dedicated external-link control and the shared
acknowledgement semantics applied to it.

## 5. Read-Only Source Findings

Current application source at `9974eed5` couples links to acknowledgement in four places:

1. `ComposeEmailModal.tsx` displays the responsibility checkbox when either an attachment
   or dedicated external link exists and blocks Send when either exists without acceptance.
2. `emails.router.ts` computes `hasResources` as attachments **or** links for create and
   update, then uses that combined condition to persist acknowledgement fields.
3. `email-resource-readiness.ts` requires acknowledgement fields whenever attachments
   **or** links exist, affecting initial Send, resend and the standalone attachment worker.
4. duplicate-to-draft deliberately does not copy acknowledgement evidence, but its audit
   metadata currently says any resource requires acknowledgement.

The same combined `hasResources` concept is also correctly used for resource fingerprint
and validation timestamps. F3 must therefore split meanings rather than globally redefine
`hasResources` as attachments only.

Current focused test coverage validates resource policy and draft reconciliation but no
direct unit test was located for the real `assertStoredEmailResourcesReady` matrix. Formal
planning should require that missing matrix rather than relying only on router or browser
smoke.

## 6. Triage Recommendation

Recommended classification for formal control-window triage:

```text
Type       CR-Fix F3 policy/behaviour correction under the existing parent CR-Fix
Priority   Immediate follow-on already accepted by the control owner
Severity   Medium operational friction; High correction sensitivity at attachment safety gate
Owner      Shared communications UI/router/readiness, expressed through LMSPro/SeasonPro
Data       No schema migration or backfill expected
Release    Separate bounded release after F2.1 production verification
```

Reasoning:

- links-only communications are unnecessarily blocked by a file-responsibility gate;
- weakening the wrong shared condition could accidentally remove the mandatory attachment
  gate or resource fingerprint checks;
- UI-only correction would leave server Send/resend readiness inconsistent;
- server-only correction would leave a false browser gate and misleading wording; and
- the existing cross-cutting coupling justifies the earlier decision to exclude F3 from
  the urgent F1/F2.1 release.

## 7. Candidate Bounded Workstreams

These are planning workstreams, not executable slice identifiers.

### A. Separate Policy Predicates

Define and use distinct meanings equivalent to:

```text
hasValidatedResources = attachmentCount > 0 OR dedicatedLinkCount > 0
requiresAttachmentAcknowledgement = attachmentCount > 0
```

Use the first for validation, fingerprint and resource-set readiness. Use the second only
for acknowledgement display, persistence and pre-send enforcement.

### B. Composer Behaviour And Wording

- show the acknowledgement checkbox only while one or more uploaded attachments exist;
- make the acknowledgement wording file-specific;
- retain a non-blocking explanation that SeasonPro does not fetch, scan, permission-test
  or guarantee dedicated external links;
- do not inspect ordinary body/template/footer links for this gate;
- reset acknowledgement when an attachment is added, removed or replaced so acceptance
  applies to the current uploaded-file set; and
- do not reset or require acknowledgement merely because a dedicated link changes.

### C. Create And Update Persistence

- continue validating and fingerprinting attachments plus dedicated links;
- persist notice version/time/user only when attachments exist and the current file notice
  is accepted;
- clear or ignore acknowledgement input for a links-only or resource-free draft;
- retain current atomic Save Draft behaviour and attachment cleanup guarantees; and
- do not mutate historic sent-email records or introduce a data backfill.

The file-only notice wording changes materially, so formal planning should use a new notice
version. Existing attachment drafts acknowledged under the combined notice should require
fresh acceptance before Send. Links-only drafts should not be blocked by old or absent
acknowledgement evidence.

### D. Send, Retry And Worker Readiness

- always validate dedicated links and the complete resource fingerprint;
- require valid acknowledgement evidence only when attachments exist;
- preserve attachment checksum/readback and durable-job gates unchanged;
- permit a valid links-only draft to use the established no-attachment batch route without
  acknowledgement; and
- apply identical semantics to Send, resend and standalone delivery processing.

### E. Duplicate And Reopen Semantics

- a duplicated draft containing attachments starts unacknowledged;
- a duplicated links-only draft requires no acknowledgement;
- reopening an attachment draft reflects only valid current-version acknowledgement;
- reopening a links-only draft does not show a checked/required file acknowledgement; and
- next save may canonicalise links-only acknowledgement fields to null without bulk
  rewriting old records.

### F. Focused Evidence Matrix

Formal planning should require automated cases for:

1. no attachment and no dedicated link — no acknowledgement required;
2. body hyperlink only — no acknowledgement required;
3. template/footer hyperlink only — no acknowledgement required;
4. one valid dedicated HTTPS link only — no acknowledgement required;
5. invalid/HTTP/credential-bearing dedicated link — rejected independently;
6. one attachment only — acknowledgement required;
7. attachment plus dedicated link — acknowledgement required because of the attachment;
8. final attachment removed while a link remains — acknowledgement no longer required;
9. attachment added/replaced after acceptance — acceptance resets;
10. links-only resource fingerprint mismatch — fail closed without inventing an
    acknowledgement requirement;
11. duplicate-to-draft and reopen behaviour for attachment and links-only cases;
12. Send and resend readiness using the same matrix; and
13. unchanged no-attachment batch selection and attachment-job selection.

## 8. Candidate File Boundary

Read-only review indicates a likely bounded application surface:

- `src/core/services/communications/components/ComposeEmailModal.tsx`;
- `src/core/services/communications/lib/email-resource-readiness.ts`;
- `src/core/services/communications/lib/email-resource-policy.ts` for a new notice version
  or narrowly extracted policy predicate only;
- `src/core/services/communications/routers/emails.router.ts`;
- focused resource-readiness/policy/component tests; and
- attachment-worker regression tests where readiness is consumed.

Formal source review may reduce this list. Expansion into Prisma schema, migrations,
provider delivery, recipient resolution, cohort selection, Club visibility or template
sanitisation should stop the work and return it to triage.

## 9. Risk Assessment

| Risk | Impact | Likelihood without controls | Required planning control |
| --- | --- | --- | --- |
| Attachment Send becomes possible without acknowledgement | High | Medium | Server-side attachment-only readiness tests across Send/resend/worker |
| Link validation or fingerprint evidence is removed with the gate | High | Medium | Keep `hasValidatedResources` separate and test links-only mismatch fail-closed |
| UI and server disagree | Medium | High | One explicit policy matrix applied at both boundaries |
| Old combined acknowledgement is silently treated as new file-only consent | Medium | Medium | New notice version; require fresh acceptance for attachment drafts |
| Changing a file retains stale checked state | High | Medium | Reset acceptance on every attachment-set edit |
| Dedicated link changes unnecessarily reset or block file acknowledgement | Low | Medium | Link changes affect fingerprint, not attachment acknowledgement predicate |
| Duplicate/reopened drafts misrepresent responsibility state | Medium | Medium | Dedicated duplicate/reopen tests and canonical server response checks |
| Scope expands into schema or delivery redesign | Medium | Low | Explicit no-schema/no-provider/no-cohort boundary and stop condition |

## 10. Acceptance Principles For Formal Planning

F3 should be accepted only if the eventual bounded plan proves all of the following:

- uploaded attachments remain impossible to Send without current explicit C1 acceptance;
- no kind of link creates an attachment acknowledgement requirement;
- dedicated links remain validated, safely rendered and fingerprinted;
- body and template/footer links remain outside managed-file semantics;
- links-only messages remain on the proven no-attachment batch route;
- attachment messages remain on the durable attachment-job route;
- create, update, reopen, duplicate, Send, resend and worker semantics agree;
- no schema migration, data backfill or production-data mutation is required;
- no recipient, cohort, Club-visibility or provider-batching behaviour changes; and
- rollback is a bounded application revert through the normal corridor.

## 11. Dependencies And Ordering

1. Record Render live at exact `ec7e0cc4` to close F2.2 production evidence. F2.2 already
   has automated/build PASS, a 15/15 staging human-smoke PASS and exact main promotion.
2. Reconcile this planning input into a formal F3 triage amendment or dedicated triage
   record under the existing CR-Fix.
3. Create and explicitly accept a bounded F3 slice plan.
4. Only then begin application implementation and focused verification.
5. Keep FUND `1R-F-A` as formal portfolio `Next` unless the authoritative root control is
   deliberately changed.

## 12. Settled Decisions Captured

- F3 remains inside the existing email CR-Fix.
- It is the policy follow-on after the more urgent F2.2 audience-authority correction.
- Only actual uploaded attachments require acknowledgement.
- Body links, template/footer links and dedicated external links do not require it.
- Dedicated links retain validation, safe rendering and fingerprint controls.
- F3 is cross-cutting and must not be implemented as a UI-only toggle.
- No schema migration or historic-record rewrite is expected.

## 13. Open Business And Planning Questions

1. Should the non-blocking dedicated-link notice remain in the same orange responsibility
   panel without a checkbox, or move to neutral informational text beside the link editor?
   Planning recommendation: neutral informational text beside the link editor.
2. Should removing the final attachment immediately clear the in-memory acknowledgement,
   or merely make it irrelevant until Save? Planning recommendation: clear it immediately
   so adding a later attachment always requires a fresh deliberate action.
3. Is one controlled links-only provider Send required in staging, or is Save/reopen plus
   automated Send-readiness and existing links-only delivery evidence sufficient?
   Planning recommendation: one controlled single-recipient staging Send, with no broad
   audience and no production provider test required.

These questions affect presentation and evidence depth, not the settled file-only gating
decision.

## 14. Control-Window Handoff

The formal control window should:

- record F2.2's Render live exact-build confirmation;
- accept or amend the triage recommendation in Section 6;
- settle the three questions in Section 13;
- create the bounded F3 slice plan from Sections 7–10; and
- leave implementation blocked until that plan is explicitly accepted.
