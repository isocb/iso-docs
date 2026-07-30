# LMSPro R9-B To R9-D Live Promotion Confirmation

Date: 2026-07-30

Record status: COMPLETE — EXACT LIVE PROMOTION, MIGRATION AND NON-MUTATING SMOKE PASS

## 1. Application And Recovery

```text
previous main/live:
  15559f1275d7f8ae3990cc6a9dcda5f35748e570
tested and promoted commit:
  fbab1862fa8124ae5f1d64df1b2741fdb19761fc
promotion shape:
  guarded fast-forward only
local/remote dev:
  fbab1862fa8124ae5f1d64df1b2741fdb19761fc
local/remote staging:
  fbab1862fa8124ae5f1d64df1b2741fdb19761fc
local/remote main:
  fbab1862fa8124ae5f1d64df1b2741fdb19761fc
```

The control owner confirmed the dormant seven-day production recovery snapshot:

```text
snapshot name: Main - snaphot before fbab1862fa8124ae5f1d64df1b2741fdb19761fc
branch ID: br-mute-paper-abuiyyj1
created: 2026-07-30 07:13:14 +01:00
```

The active production database remained the target. No database URL changed.

## 2. Production Preflight

The configured `PRODUCTION_DATABASE_URL` selected active endpoint
`ep-autumn-silence-abep1qat`, credential-safe fingerprint `fc6d0a8f1bc7`.
An explicitly read-only transaction recorded 147 successful migrations, zero unfinished
migrations, no R9-B candidate ledger row and neither candidate table, then rolled back.

This was the expected pre-promotion state.

## 3. Source And Automated Gate

Remote refs were refreshed immediately before promotion. `main` remained the direct ancestor of
the exact tested candidate. `main` fast-forwarded from `15559f12` to `fbab1862` without merge,
rebase or force push.

Exact main Security Scan run `30519008355` passed:

- dependency vulnerability scan;
- database-schema security check;
- secret detection;
- TypeScript type safety; and
- security report generation.

## 4. Migration And Machine Verification

Render's normal deployment step applied only:

`20260729170000_lmspro_r9_b_email_club_visibility`

Independent read-only production verification recorded:

```text
successful migrations:              148
unfinished migrations:              0
R9-B migration:                     finished; not rolled back
email_club_visibilities:            present
email_club_visibility_recipients:   present
historic visibility rows:          0
visibility-recipient rows:          0
transaction end:                    ROLLBACK
```

The empty additive tables prove that no historic Email reconciliation ran. No existing Email,
recipient, attachment or delivery evidence was rewritten.

The public production health endpoint returned HTTP 200 with its database connected and RLS
enabled on 11/11 expected tables. The control owner independently confirmed Render web:

```text
Live at fbab1862
```

## 5. Non-Mutating Live Smoke

| Check | Result |
| --- | --- |
| Existing authorised C1 login | PASS |
| Club Management | PASS |
| Team Management | PASS |
| Communications | PASS |
| Friendly Team statuses | PASS |
| Club Waiting List selectors | PASS |
| Existing authorised C2 login | PASS |
| Correct C2 Club | PASS |
| Historic C2 Email absence | PASS — expected prospective-only contract |
| Email or notification sent | NO |
| Production record created or changed | NO |

## 6. Disposition

R9-B prospective Club Email history, R9-C responsive Team status and R9-D attachment
click-to-browse are live at exact `fbab1862`. Source alignment, main Security Scan, additive
migration, no-reconciliation evidence, health and non-mutating C1/C2 smoke pass.

The known STAGING cron was not repointed. No separate production-cron build or tick was supplied
as part of this web-promotion confirmation; this record does not invent that evidence.

