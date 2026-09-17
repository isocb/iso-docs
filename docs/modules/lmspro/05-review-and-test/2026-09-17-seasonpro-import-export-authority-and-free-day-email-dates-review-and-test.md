# SeasonPro Import/Export Authority And Free Day Email Dates — Review And Local Smoke

Date: 2026-09-17 · Control depth: **High** · Status: **Local automated and human smoke PASS; staging deployed; staging human acceptance PASS; live promotion authorised**

- Exact commit: `c3998084` on local `dev` (parent `d13ecb39`); aligned across local/remote dev and staging; main/live remains `d13ecb39`.
- Files/change boundary: explicit Import/Export component authority, corresponding UI and Free Day date presentation.
- Automated checks: 79 tests, TypeScript, critical-file verification and changed-file lint PASS (zero errors; existing warnings retained); isolated production build PASS.
- Human evidence: **L1–L5 PASS**, recorded by Chris in the table below and confirmed in conversation on 17 September: “Smoke testing and actually send an email all GREEN.” Actual email-send success is user-reported; no provider-log inspection is claimed.
- Environment proven: local automated boundary; read-only connected helper checks across 12 development actors PASS; local authenticated smoke PASS as reported by Chris; staging S1–S3 PASS as reported by Chris; automated staging health/RLS checks PASS.
- Known residual risk: role configuration must actually contain the grants; old sent emails retain old formatting; rollback is mapping-only.
- Next authorised action: publish IsoDocs main and promote the accepted `c3998084` to application main/live under the normal checks, as explicitly authorised by Chris.

## Active restart checkpoint

Current state: local implementation and L1–L5 human smoke accepted; staging deployment/security/health PASS; staging human acceptance PASS; live promotion authorised.
Last proven commit: `c3998084` passes local automation; local human acceptance PASS (released baseline `d13ecb39`).
Current environment: dev/origin-dev and staging/origin-staging at `c3998084`; exact staging web/cron live; main/live held at `d13ecb39`.
Next human decision/test: minimum non-destructive live smoke after deployment; staging smoke is accepted.
Safe resumption point: use this record and the [single plan](../03-slice-planning/2026-09-17-seasonpro-import-export-authority-and-free-day-email-dates-planning.md); preserve FUND’s accepted release/resumption evidence. Do not rerun unrelated FUND smoke or include the OOM investigation.

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
There are no schema/live-data/config changes. Connected RLS/session behaviour is not established
by mocked procedure tests and remains an environment check before promotion. The existing
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

Documentation is recorded locally in IsoDocs. Automatic approval review rejected publication to the separate IsoDocs `main` branch because that exact default-branch push was not explicitly authorised. Chris has now explicitly authorised publication to IsoDocs `main` and application main/live promotion based on green staging smoke; the earlier publication block is resolved. Unrelated human FUND working-tree edits are preserved and excluded from this record.

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
