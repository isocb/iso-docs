# LMSPro Remediation Slice R8-A1 - Provider Contract And Sender Dispatcher Review And Test

Date: 2026-07-21
Module: LMSPro / SeasonPro shared communications
Review status: PASS for the bounded R8-A1 outcome
Promotion status: Not recommended independently; continue on the R8-A branch

Planning source:

`docs/modules/lmspro/03-slice-planning/2026-07-21-lmspro-remediation-slice-r8-a1-provider-contract-and-sender-dispatcher-planning.md`

Implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-07-21-lmspro-remediation-slice-r8-a1-provider-contract-and-sender-dispatcher-confirmation.md`

## Review Scope

The review assessed whether R8-A1:

- makes delivery mode deterministic from durable attachment count;
- prevents attachment payloads reaching Resend batch;
- preserves zero-attachment batch sending;
- supplies a bounded ordinary remote-path adapter;
- fails closed while the attachment job path is not connected; and
- remains inside the accepted R8-A1 boundary.

## Code Review Findings

### Delivery Contract

PASS.

- zero selects `BATCH`;
- one through three select `ATTACHMENT_JOB`;
- invalid and above-limit counts reject;
- the contract lives in shared communications, not LMSPro-only code.

### Batch Endpoint Safety

PASS.

- a non-empty attachment set is rejected before provider access;
- batch payloads no longer contain the unsupported attachment property;
- one no-attachment recipient remains on batch;
- 101 recipients are split into 100 and 1.

### Ordinary Adapter

PASS for the R8-A1 provider boundary.

- the adapter accepts one recipient and one to three remote paths;
- it calls `/emails`, not `/emails/batch`;
- it retains shortcode and letterhead composition;
- it rejects empty and over-limit attachment sets before provider access;
- it returns acceptance ID/failure evidence.

Signed-path creation, private-object validation and deployed provider fetching are correctly
deferred to R8-A2/R8-A3/R8-A5.

### Transitional Safety

PASS.

Current ad-hoc attachment sends now stop before status mutation and provider send. This is
safer than sending the body while silently dropping the attachment. The temporary message is
explicit that no email was sent.

### Scope Control

PASS.

- no schema or migration;
- no job/worker implementation;
- no key-date sequence expansion;
- no recipient/cohort change;
- no FUND logic change; and
- no deployment.

## Automated Test Evidence

| Check | Result |
| --- | --- |
| R8-A1 focused Vitest suite | PASS - 15 tests |
| TypeScript `tsc --noEmit` | PASS |
| Critical-file verification | PASS |
| Broader suite excluding unchanged suite-less FUND file | PASS - 105 tests, 12 skipped |
| Unfiltered full Vitest suite | Baseline harness issue - one unchanged file contains no suite |

The baseline harness issue is evidenced by no diff between the current branch and
`origin/dev` for `src/modules/fund/lib/client-project-store.test.ts`.

## Human UI Smoke Decision

No standalone human UI smoke test is required for R8-A1 because it does not introduce a new
supported user workflow. It establishes a backend contract and temporary safety refusal.

R8-A2 will change attachment persistence, draft hydration/editing, validation and visible
error behaviour. R8-A2 therefore requires a documented human UI smoke test and explicit
reported confirmation before R8-A3 planning begins.

## Residual Risks Carried Forward

- attachment upload can still be silently skipped during create;
- reopened draft attachment changes are not yet persisted;
- durable attachment count/size/readability is not yet preflighted;
- short-lived signed URLs are not yet minted;
- attachment delivery jobs do not yet exist; and
- progress/retry UI does not yet exist.

These are accepted carry-forwards because they are explicit R8-A2 through R8-A4 scope. The
R8-A1 guard prevents the known silent provider mismatch in the interim.

## Review Conclusion

R8-A1 meets its bounded exit gate and may be closed on the remediation branch.

The next permitted action is to create R8-A2 planning for attachment persistence, drafts and
fail-closed preflight. R8-A3 planning must not be created until R8-A2 implementation,
technical evidence and required human UI smoke results are confirmed.
