# LMSPro CR-Fix F3 Review, Staging Readiness And Human Smoke

Date: 2026-08-06

Status: **AUTOMATED REVIEW PASS; READY FOR EXACT-BUILD STAGING HUMAN SMOKE; PRODUCTION
PROMOTION BLOCKED**

Reviewed application commit:

`72c02d92bf7222793f70b24a1d13e541eb215efa`

Accepted plan:

`docs/modules/lmspro/03-slice-planning/2026-08-06-lmspro-cr-fix-f3-uploaded-file-only-acknowledgement-planning.md`

Implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-06-lmspro-cr-fix-f3-uploaded-file-only-acknowledgement-local-confirmation.md`

## 1. Review Conclusion

No blocking defect was found in the bounded diff.

The review confirms:

- attachment acknowledgement remains a server-side Send/readiness precondition;
- dedicated-link validation and fingerprint evidence remain fail closed;
- create/update/readiness/composer semantics use the same attachment-only rule;
- old combined notice evidence cannot masquerade as current file-only acceptance;
- attachment changes reset or invalidate earlier acceptance;
- links-only drafts retain the no-attachment delivery route;
- attachment drafts retain the durable attachment-job route; and
- the diff introduces no schema, recipient, cohort, Club, provider or deployment-contract
  expansion.

## 2. Automated Review Evidence

```text
focused tests                   PASS — 46/46
full Vitest suite               PASS — 317/317 executed; expected skips retained
type-check                      PASS
critical-file verification     PASS
changed production ESLint      PASS — no errors
production build               PASS — 131 pages
whitespace/error-marker check  PASS
```

Direct ESLint invocation against the two new test files reports the repository's existing
test-file `parserOptions.project` exclusion. Vitest compiles and executes those tests, the
full suite passes, and changed production files have no lint errors. No test configuration
change was introduced into this bounded product slice.

## 3. Human Staging Smoke

Use controlled non-sensitive content and a controlled mailbox. Save Draft unless a step
explicitly says Send.

1. Fresh email with no files or dedicated links: confirm no responsibility panel appears.
2. Add a normal hyperlink in the body: confirm no responsibility panel appears.
3. Apply a template/footer containing a hyperlink: confirm no responsibility panel appears.
4. Add one valid dedicated HTTPS document link: confirm neutral external-link guidance
   remains, no responsibility checkbox appears, and Save Draft/reopen succeeds.
5. With a controlled single recipient, Send that links-only draft; confirm successful
   no-attachment delivery.
6. Add one uploaded file: confirm the file-specific responsibility checkbox appears and
   Send is blocked until it is accepted.
7. Add a dedicated link while retaining the file: confirm acknowledgement remains required
   because the uploaded file exists.
8. Accept the checkbox, remove the final uploaded file while retaining the link: confirm
   the responsibility panel disappears.
9. Add a new uploaded file: confirm fresh acceptance is required.
10. Save/reopen an accepted attachment draft: confirm the current acknowledgement is
    represented accurately.
11. If an older attachment draft is available, reopen it and confirm the superseded
    combined notice does not appear accepted; re-accept and Save.
12. Duplicate a links-only email and an attachment email: confirm only the attachment
    duplicate requires fresh acknowledgement.
13. Confirm Save Draft steps create no provider Send event.

## 4. Required Evidence

Record:

- Render staging exact commit;
- staging public health;
- PASS/FAIL for steps 1–13;
- controlled provider receipt for step 5 only; and
- any browser/server disagreement or unexpected resource error.

Do not include real recipient addresses, message content, private object keys, session
tokens or uploaded filenames in the evidence record.

## 5. Promotion Decision

All staging steps must pass before production promotion. A failure involving missing
attachment acknowledgement, lost link validation/fingerprint protection, unexpected
provider Send, or links-only blockage stops promotion and returns F3 to implementation.
