# LMSPro CR-Fix F3 Uploaded-File-Only Acknowledgement Local Confirmation

Date: 2026-08-06

Status: **COMPLETE AT EXACT APPLICATION `72c02d92`; AUTOMATED GATES AND STAGING SMOKE PASS;
DEV, STAGING AND MAIN ALIGNED; PUBLIC PRODUCTION HEALTH PASS**

Accepted plan:

`docs/modules/lmspro/03-slice-planning/2026-08-06-lmspro-cr-fix-f3-uploaded-file-only-acknowledgement-planning.md`

Review/test record:

`docs/modules/lmspro/05-review-and-test/2026-08-06-lmspro-cr-fix-f3-review-staging-readiness-and-human-smoke.md`

## 1. Implemented Outcome

The application now separates validated-resource integrity from uploaded-file
acknowledgement:

```text
attachments OR dedicated links -> validation, persistence fingerprint and readiness
attachments only              -> C1 responsibility acknowledgement
```

Ordinary body/template/footer hyperlinks remain outside managed-resource handling.
Dedicated links remain HTTPS/credential/limit validated, safely appended and included in
the resource fingerprint, but no longer display or trigger the uploaded-file checkbox.

## 2. Implementation Detail

- added browser/server-safe shared predicates for validated resources, attachment-only
  acknowledgement and update-time acknowledgement retention;
- introduced notice version
  `lmspro-unscanned-attachment-integrity-2026-08-06-v2`;
- changed create/update persistence to store acknowledgement evidence only when an uploaded
  attachment exists and acceptance is current;
- made a changed attachment set invalidate implicit earlier acceptance;
- made links-only and resource-free saves clear legacy acknowledgement evidence;
- retained combined attachment/link fingerprint creation and fail-closed comparison;
- changed readiness so links-only messages do not require acknowledgement while uploaded
  attachments still do;
- made the composer checkbox and blocking message file-specific;
- clear in-memory acceptance when an attachment is added or removed;
- require exact current notice version when hydrating/reopening a draft; and
- corrected duplicate-to-draft audit metadata so links-only duplicates are not reported as
  requiring acknowledgement.

No schema, migration, backfill, cohort, Club-visibility, provider adapter, batching or
delivery-mode change was made.

## 3. Changed Application Boundary

- `src/app/(app)/app/lmspro/communications/page.tsx`;
- `src/core/services/communications/components/ComposeEmailModal.tsx`;
- `src/core/services/communications/lib/email-resource-contract.ts`;
- `src/core/services/communications/lib/email-resource-policy.ts`;
- `src/core/services/communications/lib/email-resource-readiness.ts`;
- `src/core/services/communications/routers/emails.router.ts`; and
- two focused resource contract/readiness test files.

## 4. Automated Evidence

```text
focused resource/delivery tests  PASS — 5 files, 46 tests
full Vitest suite               PASS — 50 files / 317 tests; 1 file / 12 tests skipped
TypeScript type-check           PASS
critical-file verification      PASS
changed production ESLint       PASS with pre-existing warnings only; no errors
Next production build           PASS — 131 pages
git diff --check                PASS
```

The first in-sandbox `npm run verify` attempt could not create the `tsx` IPC socket. The
same repository verification was rerun through the approved `npx tsx` execution boundary
and passed, including its nested type check. This is an execution-environment limitation,
not an application failure.

## 5. Data And Recovery

Existing attachment drafts carrying the superseded combined notice intentionally reopen as
unacknowledged and require fresh acceptance before Send. Existing links-only drafts do not
require acceptance and continue to be protected by their stored validation/fingerprint
evidence. No historic sent record or stored resource is rewritten by deployment.

Rollback is a bounded application revert. There is no migration or data rollback.

## 6. Completed Promotion

Exact application `72c02d92` is aligned across local dev, `origin/dev`, local staging and
`origin/staging`. GitHub Security Scan runs `31093600886` (dev) and `31093614885` (staging)
passed. At 2026-08-06 10:32:11 UTC, the public staging health endpoint returned HTTP 200,
database connected and RLS enabled on 11/11 expected tables.

The control-owner human staging smoke subsequently passed 13/13 and explicitly authorised
promotion. Local `main` was fast-forwarded from `83356030` and pushed to `origin/main` at
exact `72c02d92`. Exact main Security Scan run `31095151929` passed. Public production
health is HTTP 200 with database connected and RLS enabled on 11/11 expected tables. No
migration, environment or data action was required.

Exact application commit:

```text
72c02d92bf7222793f70b24a1d13e541eb215efa
```
