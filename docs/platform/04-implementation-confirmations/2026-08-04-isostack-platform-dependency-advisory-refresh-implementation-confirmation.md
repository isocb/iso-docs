# IsoStack Platform Dependency Advisory Refresh Implementation Confirmation

Date: 2026-08-04

Status: COMPLETE THROUGH LIVE — exact commit `7154937c` is aligned across dev, staging and main;
local automated, AI/runtime, exact dev/staging/main Security Scans, deployed-build, health and
authorised local/staging human smoke evidence pass

Review and human test control:

`docs/platform/05-review-and-test/2026-08-04-isostack-platform-dependency-advisory-refresh-review-and-test.md`

## 1. Exact Implementation Boundary

Application repository:

`isocb/isostack-bedrock`

Application branch and starting commit:

- branch: `dev`;
- local and `origin/dev` baseline when work began: `cc4b4dc8332f0bdc994c7c2609d2ece873a74087`;
- implementation commit: `7154937cb620232b457b19d09c5dc97ae0417a73`;
- local/remote `dev`, `staging` and `main` aligned at the implementation commit after controlled
  fast-forward promotions; and
- changed files: `package.json` and `package-lock.json` only.

No application source, Prisma schema, migration, database state, environment value, provider
credential, GitHub workflow or deployment setting changed. The only live action was the
authorised source promotion recorded in Section 8.

This is a bounded dependency-advisory maintenance record. It does not allocate a new roadmap
slice ID or authorise broader Platform work.

## 2. Trigger And Root Cause

Scheduled Security Scan run `30889543264` failed on 2026-08-04 for `main`, `staging` and
`dev`. Each protected branch reported:

- `0` critical;
- `4` high;
- `0` moderate;
- `0` low; and
- `0` informational vulnerability nodes.

The same application commit passed scheduled run `30796238846` on 2026-08-03. The three
underlying advisories were published later on 2026-08-03, after that successful scan. The
failure was therefore advisory-database drift against an unchanged lockfile, not an application
source regression.

The four reported high nodes represent three underlying advisories because npm propagates the
`brace-expansion` result through `minimatch`:

| Advisory                                 | Affected resolution      | Security effect                                                                                                            |
| ---------------------------------------- | ------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| `GHSA-rgw5-rvv9-x895` / `CVE-2026-69152` | `brace-expansion@5.0.8`  | Unbounded intermediate expansion can exhaust memory or block the event loop when an attacker controls a brace/glob pattern |
| `GHSA-7p8r-x3mc-p8w7` / `CVE-2026-18446` | `fast-uri@3.1.4`         | Backslash authority parsing can cause host-policy and URL-consumer disagreement                                            |
| `GHSA-2m8v-j782-fhvr` / `CVE-2026-69185` | `socket.io-parser@4.2.6` | A crafted packet can cause an active Socket.IO endpoint to retain attachments until memory exhaustion                      |

Static review found no application import or public production entry point for the affected
React Email CLI preview server, Socket.IO server, `fast-uri` policy validation or attacker-
controlled glob/brace expansion. The deployed application risk was assessed as low, while the
known-high dependency and promotion-gate risk required prompt remediation.

## 3. Implemented Dependency Correction

The existing npm override block now fixes the affected transitive resolutions exactly:

| Package            | Previous | Corrected | First patched version for the resolved major |
| ------------------ | -------: | --------: | -------------------------------------------: |
| `brace-expansion`  |  `5.0.8` |   `5.0.9` |                                      `5.0.9` |
| `fast-uri`         |  `3.1.4` |   `3.1.5` |                                      `3.1.5` |
| `socket.io-parser` |  `4.2.6` |   `4.2.7` |                                      `4.2.7` |

The lockfile was regenerated with npm `10.9.8`, matching the npm major and exact npm version
reported by the failed GitHub runner. The lockfile diff changes only the version, resolved
tarball and integrity records for these three packages.

No forced framework downgrade, `npm audit fix --force`, audit suppression, severity reduction,
direct framework upgrade or unrelated transitive refresh was used.

## 4. Automated Verification Evidence

The local host provided Node `24.9.0`, while the application declares Node `22.x`. All dependency
resolution and clean-install operations were deliberately executed with npm `10.9.8`; GitHub
remains the authoritative Node 22 environment gate after publication.

Completed evidence:

| Check                                              | Result                                                                                      |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| npm 10 lockfile-only resolution                    | PASS — reported `found 0 vulnerabilities`                                                   |
| npm 10 clean install with advisory upload disabled | PASS                                                                                        |
| npm 10 resolved-tree inspection                    | PASS — exact corrected versions on all affected paths                                       |
| Safe patched-package runtime probes                | PASS — representative brace expansion, URI resolution and Socket.IO packet encoding         |
| TypeScript `tsc --noEmit`                          | PASS                                                                                        |
| Full Vitest suite                                  | PASS — 44 files passed, 1 intentionally skipped; 270 tests passed, 12 intentionally skipped |
| Critical-file verification                         | PASS                                                                                        |
| Next.js `15.5.21` production build                 | PASS — 131 static pages generated                                                           |
| `git diff --check`                                 | PASS                                                                                        |
| Final changed-file review                          | PASS — only `package.json` and `package-lock.json`                                          |

The first sandboxed critical-file verification attempt could not create the local `tsx` IPC
socket. The unchanged command passed when rerun with permission for that local socket. This was
an execution-environment restriction, not an application or dependency failure.

The production build repeated the established warnings for intentionally absent local Upstash
Redis/session-revocation configuration. It completed successfully. No environment value was
added, changed or recorded.

## 5. AI And Online Dev Evidence

Final AI/static review passed for the bounded change:

- the implementation commit contains only `package.json` and `package-lock.json`;
- each affected lockfile path resolves to its first patched version or later;
- benign runtime probes confirmed the corrected packages import and perform representative
  expansion, URI resolution and packet encoding successfully;
- no application source, workflow, schema, migration or environment surface changed;
- the affected production exploit preconditions remain unreachable through reviewed application
  imports; and
- the change neither weakens the audit gate nor introduces a forced framework/dependency
  downgrade.

Push-triggered dev Security Scan
[`30897204038`](https://github.com/isocb/isostack-bedrock/actions/runs/30897204038) passed for exact commit
`7154937cb620232b457b19d09c5dc97ae0417a73`. Its jobs passed for:

- dependency installation, npm audit, retained artifact and high/critical gate;
- Prisma/schema validation and migration credential check;
- ordinary Gitleaks secret detection;
- TypeScript compilation and advisory `any` count; and
- final security report generation.

The retained npm audit v2 artifact records exit code `0` and zero informational, low, moderate,
high or critical vulnerability nodes across 1,127 dependency nodes.

## 6. Staging Promotion And Online Evidence

After the authorised local human PASS, the promotion followed the canonical controlled branch
method:

- the complete `origin/staging..dev` delta contained only `package.json` and
  `package-lock.json`;
- schema and migration delta count was zero;
- local `staging` was updated from `cc4b4dc8` to `7154937c` using `git merge --ff-only dev`;
- no merge commit or additional change was introduced;
- `origin/staging` was pushed to the exact reviewed commit; and
- the working tree returned to clean `dev` after promotion.

Push-triggered staging Security Scan
[`30899399417`](https://github.com/isocb/isostack-bedrock/actions/runs/30899399417) passed for exact
commit `7154937cb620232b457b19d09c5dc97ae0417a73`. Dependency, Prisma/schema, Gitleaks,
TypeScript and final-report jobs all passed. The retained npm audit v2 artifact records exit code
`0` and zero vulnerabilities at every severity across 1,127 dependency nodes.

Render subsequently served public build identifier `7154937` from the staging layout bundle. At
2026-08-04T10:16:00Z, `https://staging.seasonpro.co.uk/api/health` returned HTTP 200 with database
connected and RLS enabled on 11 of 11 expected tables. The signed-out staging root returned HTTP
307 to `/auth/lmspro/login` without an application error.

No database command, migration, environment change or credential action was required or
performed.

## 7. Human Evidence

The authorised user confirmed the bounded local and staging human smoke schedules as PASS on
2026-08-04, with the staging PASS supplied before live promotion. The staging record marks the
Google Sheets integration as not in use and therefore not tested or treated as a promotion
blocker. Browser/viewport details, exact execution times and a separate console export were not
supplied. This record retains the user attestation without inventing additional evidence.

## 8. Main Promotion And Live Online Evidence

The staging human PASS supplied explicit authority to align the tested bundle to `main`. Remote
refs were refreshed immediately before promotion and `origin/main` remained the strict ancestor
of the exact staging commit. The complete delta contained only `package.json` and
`package-lock.json`, with zero Prisma schema or migration changes.

The canonical controlled promotion then completed as follows:

- local `main` was refreshed from `origin/main` with `git pull --ff-only`;
- local `main` fast-forwarded from `cc4b4dc8` to `7154937c` using
  `git merge --ff-only staging`;
- `origin/main` was pushed without a merge commit, rebase or force push;
- the worktree returned to clean `dev`; and
- local and remote `dev`, `staging` and `main` all resolved to
  `7154937cb620232b457b19d09c5dc97ae0417a73` after promotion.

Push-triggered main Security Scan
[`30900633169`](https://github.com/isocb/isostack-bedrock/actions/runs/30900633169) passed for the
exact commit. Dependency, Prisma/schema, Gitleaks, TypeScript and final-report jobs all passed.
The retained npm audit v2 artifact records exit code `0` and zero vulnerabilities at every
severity across 1,127 dependency nodes.

Render subsequently served public build identifier `7154937` from the production layout bundle.
At 2026-08-04T10:32:13Z, `https://app.seasonpro.co.uk/api/health` returned HTTP 200 with database
connected and RLS enabled on 11 of 11 expected tables. At 2026-08-04T10:32:19Z, the signed-out
production root returned HTTP 307 to `/auth/lmspro/login` without an application error.

No database command, migration, seed, environment change or credential action was required or
performed. The production evidence is limited to the non-mutating public build, health and
signed-out routing checks above; it does not claim a separate authenticated live human smoke.

The linked review-and-test record contains the complete automated, AI, human, promotion and
online evidence. The bounded remediation is complete through live at the exact reviewed commit.
