# LMSPro CR-Fix F3 Uploaded-File-Only Acknowledgement Planning

Date: 2026-08-06

Status: **COMPLETE — IMPLEMENTED, REVIEWED, STAGING-SMOKED 13/13 AND PROMOTED TO MAIN AT
EXACT APPLICATION `72c02d92`**

Accepted triage:

`docs/modules/lmspro/02-triage/2026-08-06-lmspro-cr-fix-f3-uploaded-file-only-acknowledgement-triage.md`

## 1. Outcome

Apply one consistent policy across the composer, persistence and delivery-readiness
boundaries:

```text
hasValidatedResources = uploaded attachment exists OR dedicated external link exists
requiresAttachmentAcknowledgement = uploaded attachment exists
```

The first predicate governs validation, fingerprint and resource-set readiness. Only the
second governs acknowledgement display, persistence and Send enforcement.

## 2. Application Contract

### 2.1 Shared policy

- introduce an explicit attachment-only acknowledgement predicate;
- issue a new file-only notice version;
- retain the existing validation-policy version and resource fingerprint format; and
- keep body/template/footer hyperlinks outside managed-resource inspection.

### 2.2 Composer

- display the responsibility alert and checkbox only while an uploaded attachment exists;
- make its wording file-specific;
- retain neutral dedicated-link guidance beside the link editor;
- block Send only when an attachment exists without acknowledgement;
- reset acknowledgement whenever the uploaded attachment set changes, including removal
  of the final attachment;
- do not reset acknowledgement when only a dedicated link changes; and
- reopening a draft reflects only persisted current-version acknowledgement evidence.

### 2.3 Create and update

- fingerprint and timestamp attachments plus dedicated links exactly as before;
- persist acknowledgement evidence only when at least one attachment exists and the input
  is accepted;
- clear acknowledgement evidence for links-only and resource-free drafts;
- on update, preserve existing acknowledgement only when it is current-version and the
  attachment set has not changed; and
- attachment additions, removals or replacements require fresh acceptance.

### 2.4 Send, resend and delivery processing

- validate every dedicated link and the complete resource fingerprint;
- require current acknowledgement evidence only when attachments exist;
- retain private attachment readback/checksum verification;
- keep links-only email on the no-attachment batch route; and
- keep attachment email on the durable attachment-job route.

### 2.5 Duplicate and reopen

- duplicated attachment drafts start unacknowledged;
- duplicated links-only drafts require no acknowledgement; and
- audit metadata reports attachment acknowledgement requirement truthfully.

## 3. Expected File Boundary

- `src/core/services/communications/components/ComposeEmailModal.tsx`;
- `src/core/services/communications/lib/email-resource-policy.ts`;
- `src/core/services/communications/lib/email-resource-readiness.ts`;
- `src/core/services/communications/routers/emails.router.ts`;
- focused resource policy/readiness and pure composer-policy tests; and
- no Prisma schema, migration or provider adapter changes.

## 4. Automated Acceptance Matrix

Prove at minimum:

1. no resource, body-link-only and template/footer-link-only states require no managed
   acknowledgement;
2. valid dedicated-link-only state requires no acknowledgement but retains validation and
   fingerprint enforcement;
3. invalid HTTP or credential-bearing dedicated links remain rejected;
4. attachment-only and attachment-plus-link states require current acknowledgement;
5. final attachment removal clears the requirement while a retained link remains valid;
6. attachment addition/removal/replacement invalidates earlier acceptance;
7. links-only fingerprint mismatch still fails closed;
8. duplicate attachment draft is unacknowledged and duplicate links-only draft is not
   reported as requiring acknowledgement;
9. Send and resend consume the same readiness policy; and
10. delivery-mode tests continue to select batch for zero attachments and the attachment
    job for one or more attachments.

## 5. Technical Gates

Run:

1. changed-source focused tests;
2. the communications resource/delivery test set;
3. changed-file lint;
4. `npm run type-check`;
5. `npm test -- --run`;
6. `npm run verify`;
7. `npm run build`;
8. `git diff --check`; and
9. independent diff review against this plan.

## 6. Human Staging Smoke

Use controlled non-sensitive content and a controlled mailbox:

1. fresh email with no files or dedicated links: no acknowledgement panel;
2. body and template/footer hyperlinks: no acknowledgement panel;
3. valid dedicated HTTPS link only: informational guidance remains, no checkbox, Save
   Draft/reopen succeeds;
4. controlled one-recipient links-only Send succeeds through the no-attachment route;
5. one uploaded file: file-specific checkbox appears and Send is blocked until accepted;
6. file plus dedicated link: acknowledgement remains required because of the file;
7. remove the final file while retaining the link: checkbox disappears and any checked
   state is cleared;
8. add a new file: fresh acceptance is required;
9. Save/reopen an accepted attachment draft: current evidence is represented accurately;
10. duplicate attachment and links-only emails: only the attachment duplicate requires
    fresh acknowledgement; and
11. no provider Send occurs during Save Draft cases.

## 7. Promotion And Rollback

```text
accepted plan
-> local implementation and automated review
-> dev/origin-dev alignment
-> staging exact-build health
-> human staging smoke
-> explicit production promotion decision
-> main/live promotion and final reconciliation
```

Rollback is a bounded application revert. No schema or data rollback is required.
