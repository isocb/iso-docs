# IsoStack Platform Dependency Advisory Refresh Review And Test

Date: 2026-08-04

Status: COMPLETE THROUGH LIVE — exact commit `7154937c` is aligned across dev, staging and main;
automated, AI, online, deployed-build, health and authorised local/staging human evidence pass

Implementation confirmation:

`docs/platform/04-implementation-confirmations/2026-08-04-isostack-platform-dependency-advisory-refresh-implementation-confirmation.md`

## 1. Purpose And Test Boundary

Confirm that the targeted corrections for `brace-expansion`, `fast-uri` and
`socket.io-parser`:

- clear the authoritative high/critical dependency gate;
- preserve clean installation and application startup;
- do not regress authentication, protected navigation, email rendering/sending or the
  configured read-only Google Sheets integration; and
- deploy through staging and live as the exact reviewed application commit.

This schedule originally covered local `dev` and staging. After the staging human PASS, the
authorised user explicitly requested the normal `main` promotion and live alignment on
2026-08-04. That authority did not include or require database, migration, credential or
environment changes.

Do not record passwords, tokens, cookies, email magic links, service-account JSON, recipient
addresses or other secrets in this document. Record only result, tester, date/time, exact commit,
run/deployment identifiers and redacted observations.

## 2. Current Automated Review Disposition

Exact dev commit `7154937cb620232b457b19d09c5dc97ae0417a73` passes technical review for
its bounded dependency scope:

- only `package.json` and `package-lock.json` changed;
- the lockfile resolves `brace-expansion@5.0.9`, `fast-uri@3.1.5` and
  `socket.io-parser@4.2.7`;
- npm 10 lock resolution reported zero vulnerabilities;
- TypeScript passed;
- 44 Vitest files passed and 1 was intentionally skipped; 270 tests passed and 12 were
  intentionally skipped;
- critical-file verification passed;
- the complete production build passed; and
- no schema, migration, application source or environment setting changed.

Push-triggered Security Scan
[`30897204038`](https://github.com/isocb/isostack-bedrock/actions/runs/30897204038) passes for the
exact commit. Its retained npm audit v2 artifact records exit code `0` and zero vulnerabilities
at every severity across 1,127 dependency nodes. Dependency, Prisma/schema, secret detection,
TypeScript and final-report jobs all pass.

The AI/static and safe runtime review also passes:

- the commit changes only `package.json` and `package-lock.json`;
- every affected lockfile path resolves to the corrected version;
- representative non-adversarial brace expansion, URI resolution and Socket.IO packet encoding
  succeed;
- the application does not expose the affected React Email preview Socket.IO server,
  attacker-controlled glob expansion or `fast-uri` host-policy path; and
- no audit-gate weakening, forced downgrade or unrelated dependency refresh is present.

Review disposition: **PASS FOR THE BOUNDED DEPENDENCY REMEDIATION THROUGH LIVE**.

## 3. Evidence Header

| Evidence item                     | Required value                                             | Result                                                                                     |
| --------------------------------- | ---------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| Application implementation commit | Exact 40-character SHA on `dev`                            | PASS — `7154937cb620232b457b19d09c5dc97ae0417a73`                                          |
| Exact dev Security Scan           | GitHub Actions run ID and URL for that SHA                 | PASS — [`30897204038`](https://github.com/isocb/isostack-bedrock/actions/runs/30897204038) |
| Local tester                      | Name/initials and date/time                                | PASS — authorised user confirmation on 2026-08-04; name/time not separately supplied       |
| Staging promotion commit          | Exact SHA; must contain the reviewed dependency change     | PASS — `7154937cb620232b457b19d09c5dc97ae0417a73`                                          |
| Exact staging Security Scan       | GitHub Actions run ID and URL for the staging SHA          | PASS — [`30899399417`](https://github.com/isocb/isostack-bedrock/actions/runs/30899399417) |
| Staging deployment                | Provider deployment ID/time and deployed SHA               | PASS — public build `7154937` observed from 2026-08-04T10:15:22Z                           |
| Staging health                    | HTTP status, database connectivity and reported RLS status | PASS — HTTP 200, database connected, RLS 11/11 at 2026-08-04T10:16:00Z                     |
| Staging tester/browser            | Name/initials, date/time, browser and viewport             | PASS — authorised user confirmation on 2026-08-04; details not separately supplied         |
| Main promotion commit             | Exact SHA; must equal the staging-tested commit            | PASS — `7154937cb620232b457b19d09c5dc97ae0417a73`                                          |
| Exact main Security Scan          | GitHub Actions run ID and URL for the main SHA             | PASS — [`30900633169`](https://github.com/isocb/isostack-bedrock/actions/runs/30900633169) |
| Live deployment                   | Public deployed-build evidence for the main SHA            | PASS — public build `7154937` observed on 2026-08-04                                       |
| Live health                       | HTTP status, database connectivity and reported RLS status | PASS — HTTP 200, database connected, RLS 11/11 at 2026-08-04T10:32:13Z                     |

If the staging SHA differs from the reviewed dev SHA because of a merge commit, record both and
prove that the package and lockfile records are byte-equivalent to the reviewed change.

## 4. Local Dev Preconditions

Complete these before human browser testing:

| Precondition      | Expected result                                                                  | Actual result                                       |
| ----------------- | -------------------------------------------------------------------------------- | --------------------------------------------------- |
| Working branch    | `dev` at the recorded implementation commit                                      | PASS — local and `origin/dev` aligned at `7154937c` |
| Working tree      | No unexpected changes beyond the committed remediation                           | PASS — clean after push                             |
| Runtime           | Node 22 and npm 10                                                               | PASS — exact GitHub run used Node 22/npm 10         |
| Clean install     | `npm ci` succeeds without lockfile changes                                       | PASS — local npm 10 and exact GitHub job            |
| Resolved versions | `brace-expansion@5.0.9`, `fast-uri@3.1.5`, `socket.io-parser@4.2.7`              | PASS                                                |
| Audit gate        | Zero high and zero critical; audit output is complete and trusted                | PASS — zero at every severity, exit code `0`        |
| Application start | Local dev server starts without dependency/module-resolution failure             | PASS — authorised user attestation                  |
| Test data         | Non-production organisation/accounts and disposable email/Google Sheet test data | PASS — authorised user attestation; details omitted |

Recommended dependency evidence commands:

```bash
npm ci
npm ls brace-expansion fast-uri socket.io-parser --all
npm audit --audit-level=moderate
```

Use the repository's Node 22/npm 10 baseline. Do not use `npm audit fix --force`. If `npm ci` or
the audit changes the lockfile, stop and review the new diff before testing.

## 5. Local Dev Human Smoke

Start the application using the normal approved local-development environment. Do not add or
replace shared credentials solely for this test.

| Scenario                         | Expected result                                                                                                                     | Actual result | Evidence/notes                                  |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- | ------------- | ----------------------------------------------- |
| Public entry                     | Public root loads without HTTP 500, blank page or module-resolution error                                                           | PASS          | Authorised user attestation                     |
| Signed-out protection            | A protected shared route redirects to the correct sign-in surface without rendering private content                                 | PASS          | Authorised user attestation                     |
| Normal sign-in                   | A disposable authorised account signs in and reaches its expected application entry                                                 | PASS          | Authorised user attestation                     |
| Protected navigation             | Open one representative authorised module page and refresh it directly                                                              | PASS          | Authorised user attestation                     |
| Email rendering                  | Trigger a non-production magic-link, password-reset or other safe email-rendering flow; no render/import error occurs               | PASS          | Authorised user attestation; no link retained   |
| Email provider boundary          | If local sending is enabled, one disposable message is accepted; otherwise the established fail-closed/no-provider behaviour occurs | PASS          | Authorised user attestation                     |
| Google Sheets read-only boundary | If the integration is configured locally, list tabs for an approved disposable/test sheet                                           | PASS          | Authorised user attestation; no secret recorded |
| Sign-out                         | Sign-out clears access and the next protected request requires authentication                                                       | PASS          | Authorised user attestation                     |
| Browser console/server log       | No new dependency, parser, glob, URI, Socket.IO or module-resolution error attributable to the remediation                          | PASS          | Authorised user attestation                     |

The application does not start the React Email CLI preview Socket.IO server in ordinary runtime.
Do not expose `email dev` or any local preview server to an untrusted network for this test.

Local dev disposition: **PASS**.

Tester/date:

`Authorised user confirmation, 2026-08-04; browser/viewport and exact execution time not separately supplied.`

## 6. Dev Publication Gate

After committing and pushing the exact reviewed implementation:

1. record the exact `dev` commit SHA;
2. open the Security Scan for that push;
3. confirm dependency installation succeeds;
4. confirm the dependency gate reports zero high and zero critical findings;
5. confirm Prisma/schema, secret detection and TypeScript jobs pass; and
6. retain the run ID/URL in Section 3.

Do not promote to staging if the audit report is invalid, missing, inconsistent, unavailable or
contains a new high/critical advisory. The fail-closed gate must remain unchanged.

Dev publication disposition: **PASS**.

Exact evidence:

- commit: `7154937cb620232b457b19d09c5dc97ae0417a73`;
- Security Scan: [`30897204038`](https://github.com/isocb/isostack-bedrock/actions/runs/30897204038);
- dependency gate: zero vulnerabilities, exit code `0`;
- Prisma/schema: pass;
- secret detection: pass; and
- TypeScript: pass.

## 7. Staging Preconditions After Publishing

| Precondition         | Expected result                                                                          | Actual result                                |
| -------------------- | ---------------------------------------------------------------------------------------- | -------------------------------------------- |
| Dev gate             | Sections 4–6 pass                                                                        | PASS                                         |
| Promotion            | Reviewed dependency change promoted through the normal dev-to-staging path               | PASS — controlled fast-forward to `7154937c` |
| Exact staging scan   | All Security Scan jobs pass for the staging commit                                       | PASS — `30899399417`                         |
| Deployment           | Staging reports the expected commit/deployment                                           | PASS — public build `7154937`                |
| Health               | Staging `/api/health` returns HTTP 200 with database connected and expected RLS coverage | PASS — database connected, RLS 11/11         |
| Browser context      | Normal and private/signed-out contexts available                                         | PASS — authorised user attestation           |
| Test identities      | Approved non-production representative account(s) available                              | PASS — authorised user attestation           |
| Production exclusion | No production environment, data or credential is in use                                  | PASS                                         |

## 8. Staging Human Smoke

| Scenario                            | Expected result                                                                                                     | Actual result                               | Evidence/notes                 |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- | ------------------------------ |
| Public and health entry             | Public root and `/api/health` load successfully                                                                     | PASS                                        |                                |
| Signed-out protected route          | Correct sign-in redirect; no private content, loop or HTTP 500                                                      | PASS                                        |                                |
| Authenticated shared entry          | Normal sign-in reaches the expected shared/module entry                                                             | PASS                                        |                                |
| Representative module page          | One authorised LMSPro, FUND, Bedrock or Pulse page loads and refreshes normally                                     | PASS                                        | Record selected boundary       |
| Email rendering/sending             | One approved non-production email flow renders and, where configured, sends successfully                            | PASS                                        | Do not retain magic link/token |
| Google Sheets read-only integration | If configured on staging, an approved test sheet's tabs can be listed without write access or host-validation error | NOT TESTED NOT A PROMOTION BLOCK NOT IN USE |                                |
| Sign-out and revisit                | A protected URL requires authentication after sign-out                                                              | PASS                                        |                                |
| Browser console/server observation  | No new error attributable to the corrected dependency graph                                                         | PASS                                        | Redact sensitive data          |

Staging human disposition: **PASS**.

Tester/date/browser:

`Authorised user confirmation, 2026-08-04; browser/viewport and exact execution time not separately supplied.`

## 9. Main Promotion And Live Online Verification

The authorised staging human PASS was recorded before promotion. Immediately refreshed remote
refs proved that `origin/main` was a strict ancestor of staging and that the candidate delta was
limited to `package.json` and `package-lock.json`, with zero schema or migration changes.

| Check                    | Expected result                                                            | Actual result                                                                              |
| ------------------------ | -------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| Promotion method         | Normal controlled staging-to-main path; fast-forward only                  | PASS — `cc4b4dc8` to `7154937c`; no merge commit, rebase or force push                     |
| Branch alignment         | Local/remote dev, staging and main resolve to the exact reviewed commit    | PASS — all six refs at `7154937cb620232b457b19d09c5dc97ae0417a73`                          |
| Exact main Security Scan | Dependency, schema, secret, TypeScript and final-report jobs pass          | PASS — [`30900633169`](https://github.com/isocb/isostack-bedrock/actions/runs/30900633169) |
| Main npm audit artifact  | Valid audit, exit code `0`, zero high/critical findings                    | PASS — zero findings at every severity across 1,127 dependency nodes                       |
| Public deployed build    | Production layout bundle identifies the promoted commit                    | PASS — `7154937`                                                                           |
| Production health        | `/api/health` returns HTTP 200, database connected and expected RLS status | PASS — database connected and RLS 11/11 at 2026-08-04T10:32:13Z                            |
| Signed-out entry         | Root redirects to the expected login without application error             | PASS — HTTP 307 to `/auth/lmspro/login` at 2026-08-04T10:32:19Z                            |
| Database/environment     | No dependency-only promotion side effect or manual mutation                | PASS — no database command, migration, seed, credential or environment change performed    |

These were non-mutating public online checks. No separate authenticated live human smoke was
requested or performed, and this record does not invent one.

## 10. Pass, Fail And Stop Rules

PASS through live requires:

- exact dev, staging and main Security Scans pass with zero high and zero critical findings;
- clean installation and deployment use the reviewed lockfile;
- local and staging human smoke tables contain no remediation-attributable failure;
- authentication, email rendering and any available Google Sheets test remain within their
  established access boundaries; and
- the live public build marker, health endpoint and signed-out route prove the promoted commit is
  online without a new error; and
- no new secret, schema, migration, database or environment change is introduced.

STOP and mark FAIL if any of the following occurs:

- npm resolves an affected package below `5.0.9`, `3.1.5` or `4.2.7` respectively;
- audit evidence is unavailable, malformed, inconsistent or reports high/critical findings;
- the Security Scan gate is weakened, bypassed or allowed to continue on untrusted evidence;
- local or staging startup produces a dependency/module-resolution failure;
- an auth, email or Google Sheets regression is reproducible on the reviewed commit; or
- staging or production is not demonstrably running the reviewed change.

Record any unrelated or pre-existing observation separately. Do not relabel it as a pass, and do
not expand this dependency remediation to fix it without separate authority.

## 11. Final Disposition

Current disposition: **PASS FOR THE BOUNDED DEPENDENCY REMEDIATION THROUGH LIVE**.

The authorised staging human smoke passed before promotion. The exact reviewed commit is aligned
across local and remote dev, staging and main; all three exact branch Security Scans pass; the
production bundle identifies `7154937`; and the public health and signed-out routing checks pass.
No database, migration, seed, credential or environment action was performed.
