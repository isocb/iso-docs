# LMSPro R1-A And Branding Live Promotion Confirmation

Date: 2026-06-29  
Promotion: `staging` -> `main`  
Target app commit: `682ddb4 feat(lmspro): add playing season date boundaries`  
Status: Promotion approved; live alignment in progress

## Promotion Reason

Staging has been reviewed and accepted for the LMSPro / SeasonPro remediation work.

This promotion also carries the previously staged SVG branding upload fix to live.

## App Commit Stack Promoted

Live `main` before promotion:

```text
aac38c1 fix(fund): polish c1 dashboard cards
```

Target live commit:

```text
682ddb4 feat(lmspro): add playing season date boundaries
```

Included commits:

```text
85fb499 fix(branding): allow svg branding asset uploads
04b5d84 feat(fund): add project intake confirmation schema
a8efc72 fix(lmspro): improve email compose editor
d2414bd fix(lmspro): enrich variation request notifications
682ddb4 feat(lmspro): add playing season date boundaries
```

## Key Included Changes

Branding:

- SVG branding/logo/favicons upload support is included in the promoted stack.

FUND:

- Project Intake schema foundation.
- Project Intake email-confirmation schema addendum.

LMSPro / SeasonPro:

- Improved LMSPro email compose editor.
- Enriched team variation request notification emails.
- Playing Season Start and Playing Season End boundaries.
- Playing-season progress display based on playing-season dates, not admin season dates.

## Migration Notes

The promoted stack includes migrations:

```text
20260629120000_add_fund_project_intake
20260629133000_add_project_intake_confirmation
20260629160000_add_lmspro_playing_season_dates
```

Render deployment should run Prisma migrations automatically.

## Explicit Non-Goals

This promotion does not introduce:

- LMSPro dashboard announcement automation;
- LMSPro notification sending changes beyond existing communication flows;
- C2 Club dashboard countdown widgets;
- broader key-date architecture changes;
- season rollover changes;
- Store, Orders or Commerce implementation.

## Live Smoke Checklist

After Render live deploy completes, confirm:

- `/app/lmspro/seasons` loads.
- Existing seasons display.
- Season detail page loads.
- Playing Season Start and Playing Season End can be viewed/edited.
- Saved playing-season dates display as the exact selected calendar dates.
- LMSPro dashboard loads.
- LMSPro email compose editor opens with the larger rich-text editor.
- Team variation request notification email includes current team context.
- Branding upload accepts SVG for tenant/app branding where expected.
- `/app/fund` loads.
- Existing FUND C1 admin pages load.

## Recommendation

Proceed with live promotion to:

```text
main = dev = staging = 682ddb4
```

Record live smoke-test results after deployment.
