# LMSPro CR-Fix F2.1 — Final Staging Human Smoke

Date: 2026-08-05

Status: **CONTROL-OWNER FINAL STAGING HUMAN SMOKE PASS — ALL TEN F2.1 CHECKS GREEN;
MAIN PROMOTION AUTHORISED AND COMPLETED AT `9974eed5`**

Implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-05-lmspro-cr-fix-f2-1-cohort-taxonomy-and-picker-correction-local-confirmation.md`

Local human PASS:

`docs/modules/lmspro/05-review-and-test/2026-08-05-lmspro-cr-fix-f2-1-dev-human-smoke-schedule.md`

## 1. Exact Promotion Evidence

```text
F2.1 commit: 9974eed5d271783722e685ba3e35ef843d48e30b
dev/origin-dev: 9974eed5d271783722e685ba3e35ef843d48e30b
staging/origin-staging: 9974eed5d271783722e685ba3e35ef843d48e30b
main/origin-main: 9974eed5d271783722e685ba3e35ef843d48e30b
Render live exact-build confirmation: pending after main push
dev Security Scan: PASS — 31013858136
staging Security Scan: PASS — 31013879648
main Security Scan: PASS — 31015039314
public staging health: PASS — database connected; RLS 11/11
schema/migration/data action: none
```

Public staging health passed at `2026-08-05T14:13:32.164Z`. It does not reveal the deployed
commit.

## 2. Mandatory Preconditions

1. Confirm Render staging displays `Live at 9974eed`.
2. Delete the agreed pre-release saved drafts; legacy-draft compatibility is outside F2.1.
3. Use controlled subject/body content.
4. Open Chrome DevTools Network with Preserve log enabled and cache disabled.
5. Repeat the selection and Save Draft checks before any provider Send decision.

## 3. Final Selection And Draft Smoke

Control-owner result on staging: **PASS — entirely green.**

1. League Roles contains exact League roles only — PASS.
2. Club Roles contains exact Club roles only — PASS.
3. No `League & Club`/`BOTH` access entry appears in either role list — PASS.
4. Role rows have checkboxes and truthful counts — PASS.
5. Empty/zero-recipient states are clear and cannot add an audience — PASS.
6. One assigned League role changes preview count and survives Save Draft/reopen — PASS.
7. One assigned Club role changes preview count and survives Save Draft/reopen — PASS.
8. The recipient-type panel appears only after selecting a Division/Age Group — PASS.
9. Recipient-type choices affect that structural cohort only — PASS.
10. Save Draft invokes no `communications.emails.send` mutation or provider event — PASS.

## 4. Send Confidence And Optional Controlled Send Gate

F2.1 does not modify delivery. Save Draft resolves and deduplicates the selected cohorts
into persisted `EmailRecipient` rows. The Send procedure reloads those exact rows and:

- sends no-attachment messages through the established batch route in chunks of at most
  100; or
- queues attachment-bearing messages through the separate established durable job route.

Relevant prior evidence includes a successful real no-attachment send to 414 recipients,
the F1 staging Save Draft pass through the maximum available 440 recipients and this F2.1
local audience/draft PASS. This supports high confidence for the no-attachment send path,
but it is not a fresh provider-delivery proof for this exact build.

If the control owner chooses to perform a provider Send test, use a deliberately controlled
small recipient set first and verify:

1. preview count equals saved/reopened recipient count;
2. Send invokes exactly one `communications.emails.send` mutation;
3. the provider accepts the expected number of separate recipient messages;
4. no duplicate address receives a second message; and
5. the final Email sent/failed counts reconcile.

Do not use a broad real-recipient send merely to prove the UI correction.

## 5. Recorded Result

```text
Render staging Live at 9974eed: PASS
League Roles exact: PASS
Club Roles exact: PASS
BOTH/hat-swap absent: PASS
Checkboxes/counts truthful: PASS
Empty/zero states clear: PASS
League role preview/save/reopen: PASS
Club role preview/save/reopen: PASS
Recipient-type panel contextual: PASS
Recipient types structural-only: PASS
No send mutation/provider event during Save Draft: PASS
Optional controlled Send performed: no
Unexpected behaviour: none reported
```

## 6. Exit

The complete staging PASS was followed by the control owner's explicit main-promotion
instruction. Main was fast-forwarded and pushed at exact commit `9974eed5` on 2026-08-05.
The exact main Security Scan `31015039314` passed.
Render exact-build confirmation and the controlled production Save Draft verification
remain deployment evidence, not staging acceptance blockers. F3 is now the separate
immediate follow-on under the still-open CR-Fix.
