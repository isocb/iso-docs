# LMSPro CR-Fix F3 Uploaded-File-Only Acknowledgement Triage

Date: 2026-08-06

Status: **ACCEPTED REQUIRED FOLLOW-ON; SELECTED AS PORTFOLIO NOW; BOUNDED PLANNING AND
IMPLEMENTATION AUTHORISED THROUGH THE NORMAL CONTROLLED CORRIDOR**

Parent CR-Fix:

`docs/modules/lmspro/01-cr-inputs/CR-Fix-2026-08-05-lmspro-cohort-email-draft-persistence-and-audience-selection.md`

Planning refinement:

`docs/modules/lmspro/01-cr-inputs/2026-08-05-lmspro-cr-fix-f3-uploaded-file-only-acknowledgement-planning-refinement.md`

Accepted bounded plan:

`docs/modules/lmspro/03-slice-planning/2026-08-06-lmspro-cr-fix-f3-uploaded-file-only-acknowledgement-planning.md`

## 1. Control-Owner Decision

The control owner has selected F3 for immediate completion before the separately bounded
Role Authority and Support Ticketing projects. FUND development is deliberately parked
until all three housekeeping outcomes are finished.

This decision authorises F3 planning, implementation, automated review and promotion
through dev and staging. Production promotion remains gated on exact-build staging health,
focused human smoke evidence and an explicit promotion decision.

## 2. Accepted Classification

```text
Type       Required CR-Fix policy correction under the existing Email CR-Fix
Priority   Current portfolio NOW
Severity   Medium operational friction; High attachment-safety correction sensitivity
Owner      Shared communications UI/router/readiness, consumed by LMSPro / SeasonPro
Data       Application-only; no schema migration, backfill or historic mutation
Next       Role Authority bounded project
Queued     Support Ticketing client-readiness project, then FUND 1R-F-A resumption
```

## 3. Settled Product Contract

```text
one or more uploaded files
-> current explicit C1 attachment-responsibility acknowledgement required before Send

no uploaded files
-> no acknowledgement checkbox and no acknowledgement gate

ordinary body link, template/footer link or dedicated external document link
-> never treated as an uploaded file
-> never creates the attachment acknowledgement requirement
```

Dedicated external links remain validated, safely rendered and included in the persisted
resource fingerprint. F3 separates acknowledgement from resource integrity; it does not
weaken either link or file controls.

## 4. Accepted Refinement Decisions

1. Dedicated-link guidance remains neutral informational text beside the link editor.
2. Removing the final attachment clears the in-memory acknowledgement immediately.
3. Staging acceptance includes one controlled single-recipient links-only Send.
4. The attachment notice uses a new version, so an attachment draft accepted under the old
   combined file/link notice requires fresh acceptance before Send.

## 5. Scope And Stop Conditions

Included:

- distinct validated-resource and attachment-acknowledgement predicates;
- composer display, reset and pre-Send behaviour;
- create/update acknowledgement persistence;
- Send/resend/worker-compatible readiness semantics;
- duplicate-to-draft audit semantics; and
- focused policy/readiness regression evidence.

Excluded:

- schema or migration changes;
- recipient/cohort, Club-visibility, provider batching or template-sanitisation changes;
- historic sent-record rewrites; and
- changes to file validation, private storage or attachment delivery mode.

Discovery of a required excluded change stops implementation and returns F3 to triage.

## 6. Risk Decision

The highest risk is accidentally allowing an uploaded attachment to Send without current
acceptance. Server-side readiness remains authoritative and must be proved for initial
Send and resend consumers. Links-only fingerprint mismatch must continue to fail closed,
proving that removal of the acknowledgement gate did not remove link integrity.

Recovery is an application revert through the ordinary dev/staging/main corridor. No data
rollback is expected because F3 introduces no schema or bulk data mutation.

## 7. Exit

F3 exits only after automated review, exact staging deployment, controlled human smoke and
the subsequent production gate. Its completion makes Role Authority the next portfolio
project; it does not automatically authorise that project's application implementation.
