# LMSPro Remediation Slice R8-A1 - Provider Contract And Sender Dispatcher Implementation Confirmation

Date: 2026-07-21
Module: LMSPro / SeasonPro shared communications
Status: Implemented on dedicated remediation branch; not merged or promoted

Planning source:

`docs/modules/lmspro/03-slice-planning/2026-07-21-lmspro-remediation-slice-r8-a1-provider-contract-and-sender-dispatcher-planning.md`

Controlling parent:

`docs/modules/lmspro/03-slice-planning/2026-07-20-lmspro-remediation-slice-r8-a-attachment-aware-email-delivery-route-and-fail-closed-evidence-planning.md`

## Repository And Commit Evidence

```text
repository: isostack-bedrock
branch: fix/lmspro-r8-a-attachment-delivery
base: origin/dev at e3f44b4b786c74dfcb177f01b3b00a09acf6bbb8
implementation commits:
- 5ca66f28 fix(communications): enforce attachment delivery contract
- 135f6c79 test(communications): harden attachment adapter bounds
```

Both commits were pushed to:

```text
origin/fix/lmspro-r8-a-attachment-delivery
```

## Implemented Outcome

R8-A1 now supplies one shared, provider-aware delivery contract:

```text
0 durable attachments
-> BATCH

1 to 3 durable attachments
-> ATTACHMENT_JOB

invalid, negative, fractional or above-3 count
-> fail closed
```

The implementation also provides an ordinary single-recipient attachment adapter that:

- posts only to Resend `/emails`;
- accepts one to three filename/short-lived-path pairs;
- resolves recipient shortcodes;
- applies shared organisation/module letterhead;
- preserves CC/BCC and reply-to inputs;
- includes safe tenant/module headers;
- returns provider acceptance ID or failure evidence; and
- honours a numeric `retry-after` header before exponential fallback.

## Batch Protection

`sendBatchEmails` now validates that the attachment count is zero before reading provider
configuration or making a provider request.

The unsupported attachment construction/property was removed from batch payloads. Existing
no-attachment behaviour remains:

- one recipient still uses the batch endpoint;
- chunks remain limited to 100 provider payloads; and
- recipient-specific content, branding and result accounting remain intact.

## Transitional Ad-Hoc Guard

The current ad-hoc `send` and `resendFailed` procedures inspect the persisted
`EmailAttachment` count before changing delivery state.

Until R8-A3 connects the durable job path:

```text
no attachments
-> existing batch send

attachments present
-> explicit PRECONDITION_FAILED
-> body is not sent without its attachment
```

This deliberately replaces silent partial communication with a temporary fail-closed
refusal. R8-A2 owns the durable attachment/UI correction and R8-A3 owns queued delivery.

## Files Added

```text
src/core/services/communications/lib/email-delivery-contract.ts
src/core/services/communications/lib/email-delivery-contract.test.ts
src/core/services/communications/lib/send-email.test.ts
```

## Files Updated

```text
src/core/services/communications/lib/send-email.ts
src/core/services/communications/lib/index.ts
src/core/services/communications/index.ts
src/core/services/communications/routers/emails.router.ts
```

## Schema And Infrastructure

- no Prisma schema change;
- no migration;
- no environment-variable addition;
- no Render service change;
- no R2 object change; and
- no deployment or production-data change.

## Automated Evidence

Focused provider-contract tests:

```text
npx vitest run \
  src/core/services/communications/lib/email-delivery-contract.test.ts \
  src/core/services/communications/lib/send-email.test.ts

Test Files  2 passed (2)
Tests       15 passed (15)
```

Static verification:

```text
npm run type-check
PASS

npx tsx scripts/verify-critical-files.ts
ALL VERIFICATIONS PASSED
```

Broader regression evidence:

```text
npx vitest run --exclude src/modules/fund/lib/client-project-store.test.ts

Test Files  15 passed | 1 skipped (16)
Tests       105 passed | 12 skipped (117)
```

The unfiltered repository command reports one failed suite because the unchanged
`src/modules/fund/lib/client-project-store.test.ts` executes assertions at module load but
defines no Vitest suite. The file is byte-for-branch unchanged from `origin/dev`; it is not an
R8-A1 regression.

## Result

R8-A1 implementation is complete on the dedicated branch. It is ready for the recorded
technical review/test outcome and then R8-A2 planning. It is not a complete attachment-email
release and must not be promoted independently as such.
