# LMSPro Remediation Slice R5-C - Tenant-Scoped Role Catalogue Polish Review And Smoke Test

Date: 2026-07-07
Module: LMSPro / SeasonPro
Related implementation: `docs/modules/lmspro/04-implementation-confirmations/2026-07-07-lmspro-remediation-slice-r5-c-tenant-scoped-role-catalogue-polish-confirmation.md`
Status: Ready for browser smoke

## Developer Checks

Completed:

```text
npm run type-check
```

Result: pass.

## Browser Smoke

Role Management:

- open C1 Role Management;
- confirm the page shows active tenant-created LMSPro roles only;
- confirm platform templates do not appear as normal editable roles;
- confirm Age Group / Division responsibility-shaped roles do not appear in the normal role
  list;
- attempt to create a role such as `U10 Manager` or `Division Manager`;
- confirm creation is rejected with guidance to use Age Group / Division manager assignment.

User Management:

- open C1 User Management;
- edit a league user;
- confirm League Roles offers only active tenant `LEAGUE` / `BOTH` roles;
- confirm platform templates are not offered as normal League Roles;
- edit a club user;
- confirm Club Role offers only active tenant `CLUB` roles;
- open bulk add role;
- confirm only active tenant roles are offered;
- open bulk remove role;
- confirm any legacy/template roles are clearly labelled as remove-only.

Platform Organisation User Editor:

- as P1, open an organisation user editor;
- confirm LMSPro role assignment offers active tenant roles only;
- confirm platform templates are not offered as normal assignment choices.

Notification Manager:

- open LMSPro Notification Manager;
- open an event setting with role override support;
- confirm role override choices show broad active tenant roles only;
- confirm Age Group / Division responsibility-shaped roles are not offered;
- save a setting with a valid tenant role override;
- confirm the setting saves and reloads.

Communications And Key Date Role Selectors:

- open LMSPro Communications compose recipient role selection;
- confirm cohort role choices are broad active tenant roles only;
- open a Key Date email/custom cohort role selector;
- confirm role choices do not include platform templates or Age Group / Division
  responsibility-shaped roles;
- open Component Definitions / visibility-rule exempt-role selection;
- confirm exempt roles are active tenant roles only.

Regression Smoke:

- C1 dashboard loads;
- C2 club dashboard loads;
- Age Group manager multi-select still persists manager assignments;
- Division / AGG manager multi-select still persists manager assignments;
- R5-B scoped notification routing remains available.

## Expected Result

R5-C passes when the operator-facing role catalogue reads as a clean live tenant catalogue,
legacy/template roles are not offered for ordinary assignment, and intentional cleanup of
historic template assignments remains possible through the labelled bulk-remove path.
