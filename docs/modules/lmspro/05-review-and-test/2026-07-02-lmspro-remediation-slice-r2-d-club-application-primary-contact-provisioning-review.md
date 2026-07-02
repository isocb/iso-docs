# LMSPro Remediation Slice R2-D - Club Application Primary Contact Provisioning Review

Date: 2026-07-02
Module: LMSPro / SeasonPro
Status: Reviewed and promoted to staging
Type: Code review and promotion readiness

## Review Question

Could the new Club application approval route recreate the imported-user membership issue?

Answer before R2-D:

```text
Yes, partially.
```

The route created or linked the primary contact user and set `User.lmsproClubId`, but it did
not guarantee `LMSProClubOfficial`. That meant the relationship could look fine in the current
season but become fragile after the next season roll-forward.

## Review Finding

R2-D aligns application approval/waitlist with import provisioning.

The route now calls:

```text
provisionClubUser
```

This means application approval, waitlist, import and backfill now share the same membership
policy for primary Club contacts.

## Operator Testing Relevance

This review follows the R2-B staging evidence:

- Kevin/Spondon proved that C1 membership remove/re-add repaired a stale Club link;
- graph audit showed no Derby team/division/age-group graph issues;
- the remaining concern was future creation of hidden weak links from routes not using the
  strengthened helper.

R2-D closes that route-level prevention gap.

## Review/Test Checklist

Confirm:

- `clubApplications.approve` calls `provisionClubUser`: passed.
- `clubApplications.waitlist` calls `provisionClubUser`: passed.
- local duplicate helper is removed: passed.
- import tests still pass: passed, 16 tests.
- provisioning helper tests still pass: passed, 3 tests.
- type-check passes: passed.
- targeted ESLint has no new errors: passed, with 1 pre-existing console warning.
- no staging/live data was changed by this code slice: confirmed.

## Promotion Recommendation

R2-D has been promoted to staging before live promotion of the LMSPro remediation bundle.

Code reference:

```text
f09000b fix(lmspro): align club application user provisioning
```

Do not rely only on manual live user cleanup. Manual cleanup fixes current records, but R2-D
prevents newly approved Club applications from creating the same kind of future stale-link
problem.
