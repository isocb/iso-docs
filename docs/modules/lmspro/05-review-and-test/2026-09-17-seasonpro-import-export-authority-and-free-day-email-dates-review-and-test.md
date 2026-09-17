# SeasonPro Import/Export Authority And Free Day Email Dates — Review And Release Verification

Date: 2026-09-17 · Control depth: **High** · Status: **Production deployment, exact-main security and technical verification PASS; minimum live human smoke pending**

- Exact commit: `c3998084` on local `dev` (parent `d13ecb39`); aligned across local/remote dev, staging and main; exact production web/cron deployment verified.
- Files/change boundary: explicit Import/Export component authority, corresponding UI and Free Day date presentation.
- Automated checks: 79 tests, TypeScript, critical-file verification and changed-file lint PASS (zero errors; existing warnings retained); isolated production build PASS.
- Human evidence: **L1–L5 PASS**, recorded by Chris in the table below and confirmed in conversation on 17 September: “Smoke testing and actually send an email all GREEN.” Actual email-send success is user-reported; no provider-log inspection is claimed.
- Environment proven: local automated boundary; read-only connected helper checks across 12 development actors PASS; local authenticated smoke PASS as reported by Chris; staging S1–S3 PASS as reported by Chris; automated staging health/RLS checks PASS; exact production deployment and public health/access checks PASS; live human smoke pending.
- Known residual risk: role configuration must actually contain the grants; old sent emails retain old formatting; rollback is mapping-only.
- Next authorised action: Chris performs the two minimum read-only live checks below. Technical promotion is complete; retain SeasonPro Now / FUND resumption Next until human acceptance is recorded.

## Active restart checkpoint

Current state: local and staging acceptance retained; approved documentation published; production promotion/security/deployment/technical verification PASS; live human smoke pending.
Last proven commit: `c3998084a8f9d089ea16916133fdffc130b14025`; exact-main Security Scan `35225966878` PASS; previous live baseline `d13ecb39` retained for code recovery.
Current environment: dev/origin-dev, staging/origin-staging and main/origin-main aligned at `c3998084`; production app and cron live at that exact commit; workspace clean on dev.
Next human decision/test: the two minimum non-destructive live checks below; do not repeat accepted local/staging smoke.
Safe resumption point: record live human results here, then reconcile the existing SeasonPro/FUND disposition. Preserve unrelated FUND edits and accepted release evidence; OOM investigation stays separate.

## Local smoke — small synthetic data only

Use your existing localhost dev server and a local SeasonPro test league. Do not test against
staging/live or use real bulk data. Use separate C1 Owner and delegated C1 Admin logins in the
same league; retain the existing permissions so any temporary role changes can be reversed.
Sign in again after a role change if session revocation requests it.

| Check | Action and expected result | Result |
| --- | --- | --- |
| L1 — delegated normal operations | Give the delegated C1 role Import and Export component grants. Both dashboard cards and direct `/app/import` and `/app/export` pages open. Download the Club CSV template, retain one clearly labelled synthetic Club row with a fresh legacy key and no real contact details, validate/import once, and confirm its completed job in `/app/import/jobs`. Export Clubs as CSV then JSON; check the synthetic Club and correct league scope. | **PASS** |
| L2 — independent/revoked grants | Remove Export only: Import remains usable; Export card disappears and direct Export URL explains missing access. Restore Export and remove Import: reverse result, including no job-list access. Repeat without either grant for Owner: Owner status must not grant normal Import/Export by itself. Restore original role configuration afterward. Automated tests cover stale/direct API refusals. | **PASS** |
| L3 — destructive controls | Delegated C1 sees job details but no rollback/delete controls. Owner with Import access sees those controls for the synthetic job. Do not execute destructive actions for this smoke; automated fixtures cover refusal, ownership and in-progress protections. Rollback confirmation must say imported records are not deleted. | **PASS** |
| L4 — league/role boundary | A second local test league cannot see the first league’s synthetic job or export its Club. A C2/Club-only role cannot open league Import/Export by a stray component grant. Direct foreign identifiers and invalid impersonation are covered by automated tests; record connected confirmation when available. | **PASS** |
| L5 — email presentation | In notification settings, inspect Free Day defaults/custom content: editing previews must retain `{{requestedDate}}`. For a rendered synthetic notification containing `2026-10-18T00:00:00.000Z`, expect `18/10/2026` in each used subject/body occurrence. Open the [non-sending synthetic preview](/tmp/seasonpro-free-day-preview.html) for local visual inspection (temporary local artifact); do not trigger real recipient mail solely for this test. Existing stored dates and sent-email history should not be rewritten. | **PASS** |

If a local account/fixture is absent, record that limitation; do not weaken the permission
rules or change an online role to make the smoke pass. Leave the tiny imported fixture labelled
as test data; deletion/cleanup is separate and must not be confused with mapping rollback.

## Technical review

Self-review and focused negative tests PASS; independent review not claimed. Full relevant
authority matrix and date cases are described in the [04 confirmation](../04-implementation-confirmations/2026-09-17-seasonpro-import-export-authority-and-free-day-email-dates-implementation-confirmation.md).
There are no schema/live-data/config changes. Mocked procedure tests do not establish connected
RLS/session behaviour; the subsequent staging acceptance and technical evidence below record
the environment proof. The existing
shared RLS mechanism is unchanged; explicit effective-tenant predicates remain required.

Any later staging promotion must identify the exact accepted candidate, run its normal security
checks, and verify delegated operation plus rendered dates with staging-specific authentication
and RLS. Main/live stays held for explicit approval after staging acceptance. Recovery is code-only;
preserve imports, mapping evidence and sent emails. No new planning layer is required.

Local evidence supplement: the real development Prisma/access helper was exercised read-only
for 12 existing active actors, with inconsistent effective-tenant refusal and no database writes.
Only endpoint fingerprint `8708763642d9` and aggregate counts are retained; no personal records
are published. This checks ORM query compatibility and explicit predicates, not a substitute
for authenticated browser or staging RLS acceptance. The isolated build passed before a final
non-functional JSX quote escape; the commit hook reran TypeScript successfully afterward.

## Human acceptance — 17 September 2026

Chris marked all five local checks PASS and confirmed all-green smoke, including an actual
email send. This accepts the local candidate `c3998084`. No recipient details are recorded.
It does not constitute staging proof or authorise a push, deployment or live promotion.

## Authorised staging promotion — 17 September 2026

Chris explicitly requested “Please promote to Staging” after accepting all local smoke,
including an actual email send. Authority covers dev/staging and publishing these records;
main/live is held. The prior local-only stopping point is superseded for staging only.

The complete promotion bundle is the single application commit `c3998084` above `d13ecb39`.
There are no schema, migration, dependency or runtime configuration changes. The staging
ledger contains 157 applied migration names and zero unresolved entries, with no missing/new
migration names. Its 23 historical checksum differences are already recorded in the FUND
17 September release evidence; migration source is unchanged by this candidate. No ledger
repair, reset, seed or data cleanup is included. Web and cron both match the staging database.

Deployment/security/health results: **PASS**, verified 17 September at 12:48:58 UTC.

- Exact dev Security Scan [35222103967](https://github.com/isocb/isostack-bedrock/actions/runs/35222103967) PASS, including summary; exact staging scan [35222416841](https://github.com/isocb/isostack-bedrock/actions/runs/35222416841) PASS.
- Staging was locally fast-forward merged from dev and pushed normally; workspace returned to dev. Local/remote dev and staging all match `c3998084`; local/remote main remains `d13ecb39`.
- Render `Staging-IsoStack` (`srv-d4miroogjchc73balrvg`), deployment `dep-daltv915efls73brg4hg`, live at exact candidate (12:48:07 UTC).
- Render staging cron `isostack-bedrock-1` (`crn-d6t7bpf5gffc738vlcn0`), deployment `dep-daltv995efls73brg52g`, live at exact candidate (12:46:06 UTC).
- `https://staging.seasonpro.co.uk` and `/api/health` return HTTP 200; database connected; core RLS 11/11 enabled. Signed-out `/api/trpc/import.access` returns 401. The first default Python-user-agent health request received 403; browser-user-agent requests succeeded. No application/configuration change was needed.
- Post-deployment ledger still has 157 distinct migrations and zero unresolved entries. Build logs confirm no pending migrations and successful build. No new migration/configuration bundle was introduced.
- The bounded post-deployment app-log query returned no rows; it is not evidence of an error-free authenticated workflow. S1–S3 subsequently PASS, recorded by Chris below.

Documentation is recorded locally in IsoDocs. Automatic approval review rejected publication to the separate IsoDocs `main` branch because that exact default-branch push was not explicitly authorised. Chris has now explicitly authorised publication to IsoDocs `main` and application main/live promotion based on green staging smoke; the user-authority question is resolved, but automatic execution review still blocks the push (see latest entry below). Unrelated human FUND working-tree edits are preserved and excluded from this record.

### Short staging acceptance

Use `https://staging.seasonpro.co.uk`, with staging test users/data only.

| Check | Expected result | Result |
| --- | --- | --- |
| S1 — deployment and login | P1, C1 Admin and ordinary tenant-user login/logout work; each sees the correct tenant. | PASS |
| S2 — delegated Import/Export | Granted delegated C1 can validate/import one small synthetic Club and export it. Import-only/export-only grants stay independent; an ungranted direct route refuses. Delegated job history offers no rollback/delete. Use the existing test fixture where possible. | PASS |
| S3 — date presentation | Render a staging Free Day notification using a test date: DD/MM/YYYY appears in the applicable default/custom outputs. No real-recipient send is required; the accepted local actual send remains evidence. | PASS |

The full local negative matrix need not be repeated. Staging acceptance establishes the
representative deployed permission and notification path; public health alone does not prove it.

## Live promotion authority — 17 September 2026

Chris marked S1–S3 PASS and explicitly authorised publishing the locally committed documentation
to IsoDocs `main` and promoting the green staging candidate to main/live “subject to the normal
steps”. This supersedes the earlier main hold. Exact candidate remains `c3998084`; no new code,
migration or configuration is included. Production preflight, local fast-forward merge,
main Security Scan, exact service deployment and minimum live health/access checks will be
recorded below. Live human smoke is not inferred from staging acceptance.

## Earlier execution approval blocker — resolved on resumption

Preflight PASS: clean application dev; fresh remote staging at accepted `c3998084`; exact
staging Security Scan `35222416841` PASS. Production app `srv-d4t6l16uk2gs73ejugg0` and cron
`crn-d610l04r85hc739h10e0` both track this repository’s main at `d13ecb39` and use the verified
production database; 157 distinct migrations, zero unresolved entries, no new migrations or
configuration. Other inspected web services belong to separate LMSPro/Floot repositories and
are not targets of this promotion.

Chris explicitly approved IsoDocs main publication and application main/live promotion in the
current conversation. Automatic approval review nevertheless rejected the documentation push,
including a retry after checking that only seven Markdown lifecycle/roadmap files were outgoing.
It separately rejected the application’s normal local-main merge/push command. The stated reason
for both was consequential default-branch mutation with purported approval treated as untrusted
transcript content. No rejected command executed and no alternate push route was attempted.

IsoDocs evidence is committed locally; remote documentation remains unpublished. Application
local/remote main remains `d13ecb39`; local/remote dev and staging remain `c3998084`. Do not claim
production deployment or a main scan. Resume the already-authorised normal flow only after the
execution approval block is resolved. Unrelated FUND working-tree edits remain preserved.

## Resumed production promotion — 17 September 2026

Chris explicitly renewed authority to publish the locally committed IsoDocs documentation and
promote the accepted staging commit to main/live. The active session used automatic approval
review. Normal escalated terminal requests succeeded; no approval policy was changed and no
alternate push route was used. The earlier execution blocker is resolved.

- IsoDocs normal main push published the five pre-existing commits, `b4975d0` → `67920b7`.
  The unrelated uncommitted FUND review edit was excluded and preserved byte-for-byte.
- Fresh Git/provider preflight confirmed the single application commit above `d13ecb39`,
  accepted exact dev/staging scans and staging web/cron, and the expected production web/cron
  repository, main branch and database identities. There are no new migrations or runtime
  configuration changes. Production has 166 historical ledger rows / 157 distinct migration
  names, zero unresolved entries and no pending migrations. No ledger repair was performed.
- Local application main was fast-forward merged from accepted staging, then pushed with
  `git push origin main`; no direct source-to-remote ref substitution or force push was used.
  Workspace returned to dev. Local and remote dev/staging/main all equal the accepted SHA.
- Exact-main Security Scan [35225966878](https://github.com/isocb/isostack-bedrock/actions/runs/35225966878)
  **PASS**, including dependency, TypeScript, schema, secrets and report summary. The
  schedule-only job is correctly skipped for this push.
- Production web `app` (`srv-d4t6l16uk2gs73ejugg0`), deployment `dep-dalufvrbc2fs738f9980`,
  **live** at exact `c3998084`; provider finish `2026-09-17T13:22:39.536226Z`.
- Production cron `isostack-bedrock` (`crn-d610l04r85hc739h10e0`), deployment `dep-dalug03bc2fs738f99s0`,
  **live** at exact `c3998084`; provider finish `2026-09-17T13:21:05.934967Z`.
- Independent readback confirmed both exact deployments are still the latest. Verification
  timestamp: `2026-09-17T13:23:20.454210+00:00`.
- `https://app.seasonpro.co.uk` and `https://isostack-bedrock.onrender.com`: entry page and
  `/api/health` HTTP 200, database connected, core RLS 11/11. Signed-out
  `/api/trpc/import.access` returns 401 on both hosts. Requests used a browser user agent.
- Post-deployment read-only migration inventory remains 166 rows / 157 distinct / zero
  unresolved. No new migration, configuration, import, export or email send was performed.

### Bounded provider log evidence

Build logs were queried from the promotion trigger; application logs were queried from each
deployment's finish through verification. Pagination was exhausted. Only counts/indicators
are retained, with no personal data, message content or credentials.

| Service | Log type | Rows | No pending migrations | Build successful | Failure indicators |
| --- | --- | ---: | ---: | ---: | --- |
| Web | build | 341 | 1 | 1 | None matched |
| Web | app | 7 | 0 | 0 | None matched |
| Cron | build | 379 | 0 | 1 | None matched |
| Cron | app | 0 | 0 | 0 | None matched |

Failure indicators checked: TypeScript errors, missing-column/relation wording, `Error:`,
out-of-memory and fatal errors. This is a bounded technical readback, not sustained-load
assurance or proof of a newly executed cron business job. The earlier OOM incident remains
outside this release and is not claimed resolved.

### Minimum remaining live human smoke

Use https://app.seasonpro.co.uk with existing users and data. No imports, exports of live
personal data, role edits, rollback/delete or email sends are needed.

| Check | Expected result | Result |
| --- | --- | --- |
| LIVE1 — login and authorised pages | Log in as an existing delegated League Admin with the relevant grants; confirm the correct league, open Import, Export and job history, and see no delegated rollback/delete controls. Log out normally. | Pending |
| LIVE2 — Free Day preview | Open a non-sending Free Day notification preview with a resolved date and confirm DD/MM/YYYY in the applicable subject/body. An intentional `{{requestedDate}}` placeholder in the template editor remains valid. | Pending |

Accepted local L1–L5 (including actual email send) and staging S1–S3 are retained without
repetition. Recovery remains a compatible code revert to the former Owner-only normal
operation checks; preserve imported records, mappings and sent-email history. Technical
promotion is complete; human production acceptance and lifecycle closure are not claimed.
Root Now remains SeasonPro, Next remains the accepted FUND B1 resumption boundary.
