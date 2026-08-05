# LMSPro CR-Fix F2.1 — Hosted Dev Human Smoke Schedule

Date: 2026-08-05

Status: **LOCAL HUMAN SMOKE PASS; IMPLEMENTATION COMMITTED AS `9974eed5` AND PROMOTED TO
STAGING; SUPERSEDED AS THE ACTIVE GATE BY THE FINAL STAGING SMOKE**

Implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-05-lmspro-cr-fix-f2-1-cohort-taxonomy-and-picker-correction-local-confirmation.md`

Final staging smoke:

`docs/modules/lmspro/05-review-and-test/2026-08-05-lmspro-cr-fix-f2-1-staging-final-human-smoke.md`

## Control-Owner Result

| Check | Result |
| --- | --- |
| League Roles contains exact League roles only | PASS |
| Club Roles contains exact Club roles only | PASS |
| No `League & Club`/`BOTH` entry in either role list | PASS |
| Role rows have checkboxes and truthful counts | PASS |
| Empty/zero-recipient states are clear and cannot add audience | PASS |
| Assigned League role changes preview and survives Save Draft/reopen | PASS |
| Assigned Club role changes preview and survives Save Draft/reopen | PASS |
| Recipient-type panel appears only for Division/Age Group | PASS |
| Recipient types affect the structural cohort only | PASS |
| Save Draft invokes no provider Send | PASS |

The code tested locally was unchanged before it was committed as `9974eed5`.

## Original Safety And Preconditions — Completed

1. Confirm the tested code is the implementation subsequently committed as `9974eed5`.
2. Delete pre-release saved drafts as agreed; legacy-draft compatibility is outside F2.1.
3. Use controlled subject/body content.
4. Use Save Draft only; do not use provider Send as acceptance evidence.
5. Keep DevTools Network open and confirm only preview/create/update procedures are used.

## Role Taxonomy Smoke

1. Expand League Roles.
2. Confirm it contains functional League roles only.
3. Confirm every available role row has one checkbox and a recipient count.
4. Confirm a zero-recipient row, if present, is clearly labelled and disabled.
5. Select one assigned League role and confirm the preview count increases.
6. Save Draft, reopen it and confirm the same role/count.
7. Repeat for one assigned Club role under Club Roles.
8. Confirm no `League & Club`, `BOTH` or hat-swap access entry appears under either role
   category.
9. Combine one League and one Club role and confirm overlapping addresses remain one
   deduplicated recipient.

## Recipient-Type Smoke

1. With no Division/Age Group selected, confirm no recipient-type panel is shown.
2. Select one Division/Age Group.
3. Confirm the panel appears directly beneath the cohort picker and says it applies to
   selected Divisions and Age Groups.
4. Toggle Team Managers, Club Secretaries and Other Club Officials and confirm the preview
   changes only according to that structural cohort.
5. Add a League Role or Club Role and confirm recipient-type toggles do not change that
   role's contribution.
6. Remove the last Division/Age Group and confirm the contextual panel disappears.

## Result Template

```text
Hosted-dev exact commit:
League Roles exact and selectable:
Club Roles exact and selectable:
BOTH/hat-swap absent from role lists:
Role counts truthful:
Zero/empty states clear:
League role preview/save/reopen:
Club role preview/save/reopen:
Recipient-type panel contextual:
Recipient types affect structural cohort only:
No communications.emails.send request:
No provider event:
Unexpected behaviour:
```

## Exit

The complete local PASS supported the explicit staging-promotion decision. Final acceptance
now depends on the separate staging record; no main/live conclusion is inferred.
