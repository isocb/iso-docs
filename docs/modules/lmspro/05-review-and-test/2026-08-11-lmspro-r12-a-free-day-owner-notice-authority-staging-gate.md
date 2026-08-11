# LMSPro R12-A Free Day Owner Notice Authority — Staging Promotion And Smoke

Date: 2026-08-11

Status: **EXACT `39a25d99` PROMOTED TO STAGING; EXACT STAGING SECURITY SCAN AND PUBLIC
HEALTH PASS; RENDER IDENTITY AND HUMAN STAGING SMOKE PENDING**

## 1. Promotion Identity

```text
R12-A application commit = 39a25d996da2ce24d717d11a754636c31435d517
origin/dev               = 39a25d99
origin/staging           = 39a25d99
origin/main              = 60ac76c1 (unchanged)
```

The exact dev Security Scan passed as run `31488395920` before staging promotion. The
release contains only R12-A; the uncommitted Support Ticketing candidate and its migrations
remain local and are not present on staging.

Exact staging Security Scan run `31488601726` passed. Public
`https://staging.seasonpro.co.uk/api/health` returned HTTP 200 with database connected and
RLS 11/11. Render's exact `Live at` identity still requires confirmation after deployment.

## 2. Minimum Staging Smoke

Use a controlled current season and restore its intended operational value afterwards:

1. set notice to **14**, save and confirm the standard Free Day calendar immediately makes
   exactly day 14 selectable while day 13 is unavailable;
2. reopen the season and confirm 14 persisted;
3. set notice to **28**, save and confirm exactly day 28 is the first permitted date;
4. confirm the displayed notice message equals the saved value;
5. confirm Special Free Days, Team eligibility and quota presentation remain unchanged; and
6. restore the intended notice value and confirm immediate calendar refresh.

Do not promote to main until Render identity and this human staging smoke are recorded as
green.

## 3. Subsequent Staging Head

After the original R12-A-only promotion evidence above was recorded, exact Support commit
`cde4eaff1e14b2f02ba0953fe8693e7feb02bb61` was fast-forwarded through dev/staging. R12-A
`39a25d99` remains in its ancestry. Run this unchanged six-item R12-A smoke against the
current exact `cde4eaff` staging deployment; do not infer its result from the later Support
scan or health check.

The control owner subsequently fully accepted the exact `cde4eaff` staging head and
authorised its main promotion. This records acceptance of the combined deployment boundary;
it does not manufacture separate item-by-item R12-A annotations that were not added here.
Exact `cde4eaff` is now aligned through main and its main Security Scan/public health pass;
production Render identity remains controlled by the combined release closure record.
