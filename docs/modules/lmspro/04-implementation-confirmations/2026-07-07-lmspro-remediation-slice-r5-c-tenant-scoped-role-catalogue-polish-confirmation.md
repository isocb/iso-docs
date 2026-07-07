# LMSPro Remediation Slice R5-C - Tenant-Scoped Role Catalogue Polish Confirmation

Date: 2026-07-07
Module: LMSPro / SeasonPro
Related CR: `docs/modules/lmspro/01-cr-inputs/2026-07-07-lmspro-cr-tenant-scoped-role-catalogue-legacy-template-pruning-input.md`
Related plan: `docs/modules/lmspro/03-slice-planning/2026-07-07-lmspro-remediation-slice-r5-c-tenant-scoped-role-catalogue-polish-planning.md`
Status: Implemented locally on app `dev`; browser smoke pending

## Summary

R5-C tightens LMSPro role catalogue behaviour so normal C1/P1 role assignment surfaces are
driven by active tenant `ModuleRole` records rather than a mix of tenant roles, platform
templates and legacy operational responsibility roles.

The implementation is deliberately non-destructive. It hides or blocks confusing role
choices in normal operator workflows, while preserving a labelled bulk-remove path for
legacy/template role IDs that may still exist on imported or historic users.

## Implemented Changes

- Added shared role catalogue helpers in `src/modules/lmspro/lib/role-classification.ts`
  for active tenant role detection and assignable tenant role filtering.
- Changed `lmspro.roles.list` so it defaults to active tenant roles only; platform templates
  are now opt-in for audit or cleanup.
- Added a read-only `lmspro.roles.inventory` endpoint to report tenant roles, templates,
  user assignment counts and notification setting references without exposing templates as
  normal selectable roles.
- Updated C1 Role Management to show active assignable tenant roles by default and display
  an advisory if hidden legacy/template inventory exists.
- Updated C1 User Management so League and Club role assignment controls offer tenant roles
  only.
- Preserved the User Management bulk-remove path for legacy/template roles, labelled as
  `Legacy/template roles (remove only)`.
- Updated the P1 organisation user editor so platform admins also assign only active tenant
  LMSPro roles.
- Updated the Component Definitions audit page so component-role references show current
  tenant roles rather than retired platform templates.
- Updated visibility-rule exempt role selection to use the same assignable tenant role
  filter.
- Updated Notification Manager role override validation so the server rejects template,
  inactive or operational-responsibility-shaped roles.

## Boundaries

- No platform/auth roles were removed.
- No `ModuleRole` data was deleted.
- Existing user role enrichment still shows assigned legacy role names where present, so old
  assignments remain visible until deliberately removed.
- Age Group and Division manager assignment remains in the R5-A manager UIs.
- R5-B notification routing semantics are unchanged.

## Verification

Developer verification completed:

```text
npm run type-check
```

Result: pass.

Browser smoke is documented separately in the R5-C review/test document.
