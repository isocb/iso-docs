# LMSPro Remediation Slice R4-B - Communications Email And Announcements Workflow Review And Smoke Test

Date: 2026-07-06
Module: LMSPro / SeasonPro
Status: Browser smoke PASS on local app `dev`
Implementation confirmation: `docs/modules/lmspro/04-implementation-confirmations/2026-07-06-lmspro-remediation-slice-r4-b-communications-email-announcements-workflow-confirmation.md`

## Verdict

R4-B passes local browser smoke.

Initial operator smoke found one issue in the edit-draft path: Recipients and Preview tabs
appeared inoperative. The cause was a modal reset loop from an unstable empty
`initialFilters` default. That has been fixed and the operator confirmed the tabs now work.

Final operator verdict:

```text
Browser testing - Huge PASS
```

## Developer Checks

Commands run from the app repo:

```text
npx tsc --noEmit --incremental false
npx eslint src/modules/lmspro/components/communications/AnnouncementModal.tsx src/modules/lmspro/routers/announcements.router.ts src/core/services/communications/components/ComposeEmailModal.tsx src/core/services/communications/components/CohortPicker.tsx src/core/services/communications/routers/emails.router.ts src/app/(app)/app/lmspro/communications/page.tsx
git diff --check
```

Results:

- TypeScript: pass.
- Targeted ESLint: pass with warnings only.
- Whitespace/diff check: pass.

Known warning caveat: existing communications compose/router files still contain legacy
warnings for unused variables and `any` types. No blocking lint errors remain in the
targeted R4-B surface.

## Browser Smoke Checklist

Smoke route:

```text
http://localhost:3000/app/lmspro/communications
```

Confirmed:

- create Announcement with rich text content;
- edit Announcement and confirm content remains rendered safely;
- publish Announcement without email;
- publish Announcement with email to a small test Club cohort;
- generated email appears in communications history where expected;
- C2 Club dashboard still displays targeted Announcement;
- compose email opens with Club Roles and League Roles initially open;
- other recipient accordions are initially closed;
- recipient role options reflect live tenant roles rather than static template roles;
- save a new draft;
- edit draft email opens;
- Recipients tab in edit draft works;
- Preview tab in edit draft works.
- reopen/edit/send draft;
- duplicate sent email to draft;
- original sent email remains unchanged.

## Defect Found And Fixed During Smoke

Issue:

```text
Edit draft email - Recipients tab and Preview tab are inoperative.
```

Cause:

`ComposeEmailModal` defaulted `initialFilters` to a fresh empty array. The draft-loading
effect depended on that value, so each parent render caused the modal to reload the draft
and return to the Compose tab.

Fix:

The modal now uses a stable empty default for missing `initialFilters`, so tab changes are
not overwritten by draft reloads.

## Promotion Recommendation

R4-B is suitable to commit with the R4-A/R4-B communications remediation batch on local
`dev`, align to `origin/dev`, then promote to staging for online operator testing.
