# CR-Fix — Protected-Branch Security Scan Advisory Refresh

Date: 2026-08-09

Owning lane: IsoStack Platform assurance

Status: **EXPEDITE COMPLETE AS SEPARATE DEPENDENCY CHILD `60ac76c1` IN THE COMBINED
ROLE RELEASE; DEV/STAGING/MAIN EXACT SECURITY SCANS, STAGING 8/8,
STAGING/PRODUCTION HEALTH AND PRODUCTION RENDER/C1/C2 EVIDENCE PASS; CLOSED**

Triage and remediation advice:

[`2026-08-09 protected-branch Security Scan triage`](../02-triage/2026-08-09-isostack-platform-protected-branch-security-scan-advisory-refresh-triage.md)

Accepted delivery records:

- [`bounded planning`](../03-slice-planning/2026-08-10-isostack-platform-protected-branch-security-scan-advisory-refresh-planning.md);
- [`local implementation`](../04-implementation-confirmations/2026-08-10-isostack-platform-protected-branch-security-scan-advisory-refresh-implementation.md); and
- [`local review gate`](../05-review-and-test/2026-08-10-isostack-platform-protected-branch-security-scan-advisory-refresh-local-gate.md).

## 1. Reported Problem

GitHub Security Scan runs are failing while the control owner is conducting local
`PLAT-ROLE-02` smoke testing. A failed protected-branch security gate must be investigated
before another application promotion is attempted.

This CR-Fix is a new advisory-database event. It does not reopen the completed 2026-08-04
dependency refresh, whose exact evidence remains valid for the advisories known at that
time.

## 2. Confirmed Reproduction

At 2026-08-09:

- `origin/dev`, `origin/staging` and `origin/main` all resolve remotely to exact application
  `72c02d92bf7222793f70b24a1d13e541eb215efa`;
- the package manifests, lockfile, Security Scan workflow and audit-gate script are unchanged
  between that protected-branch commit and local `7e453665`;
- the workflow-equivalent `npm audit --audit-level=moderate --json` reports `0` critical,
  `2` high, `0` moderate, `0` low and `0` informational vulnerabilities across 1,127
  dependency nodes; and
- `scripts/security/check-npm-audit-report.mjs` correctly refuses that report with
  `Dependency security gate failed`.

The earlier GitHub CLI credential limitation is now resolved. Exact Actions review confirms
four consecutive scheduled failures against unchanged `72c02d92` from 2026-08-07 through
2026-08-10. Latest run
[`31366209496`](https://github.com/isocb/isostack-bedrock/actions/runs/31366209496)
shows only the scheduled dev, staging and main dependency validators failing. TypeScript,
Secret Detection, Database Schema Security Check and final report generation pass. This
confirms the two-advisory lockfile diagnosis and excludes a concurrent source/schema/secret
gate failure at that exact run.

## 3. Confirmed Advisories

| Package and path | Locked | First patched | Finding | Reviewed exposure |
| --- | ---: | ---: | --- | --- |
| `js-yaml`, via development-only `@eslint/eslintrc` | `4.3.0` | `4.3.1` | [`GHSA-5p4m-2wfm-xmqj`](https://github.com/advisories/GHSA-5p4m-2wfm-xmqj): quadratic CPU use when parsing attacker-influenced `!!omap` YAML | No application import or production runtime path found; development/tooling exposure only at the reviewed source boundary |
| `nanoid`, via root `postcss@8.5.23` | `3.3.16` | `3.3.17`; current compatible patch `3.3.18` | [`GHSA-2v37-7h3g-55p8`](https://github.com/advisories/GHSA-2v37-7h3g-55p8) / `CVE-2026-67213`: custom generators can loop indefinitely for a size of zero | Installed in the production dependency tree because PostCSS is a root dependency, but no application import or call to `customAlphabet`/`customRandom` was found; reviewed use is build tooling |

Both are availability/denial-of-service findings. Neither advisory reports confidentiality
or integrity impact. Presence in the lockfile is sufficient to fail the accepted gate even
where the reviewed application does not expose the vulnerable call pattern.

## 4. Requested Outcome

Restore a trustworthy zero-High/zero-Critical protected-branch security result without:

- suppressing either advisory;
- weakening the severity threshold or fail-closed report validator;
- using `npm audit fix --force`;
- introducing unrelated package, framework or workflow upgrades;
- changing application source, schema, migrations, database state or environment values; or
- obscuring the exact dependency and Security Scan evidence behind a combined feature diff.

## 5. Remedial Boundary Proposed For Acceptance

Use the established bounded dependency-maintenance method:

1. resolve `js-yaml` to `4.3.1` and `nanoid` to the compatible patched `3.3.18` using Node
   22 and npm `10.9.8`, matching the previously accepted lockfile toolchain;
2. prefer explicit exact npm overrides plus the corresponding lockfile records if a targeted
   npm 10 resolution cannot produce an equally narrow, deterministic lockfile-only diff;
3. inspect the resulting diff and reject unrelated transitive or optional-platform churn;
4. prove the clean installed tree resolves only patched versions;
5. run the audit validator, full tests, type-check, critical-file verification and production
   build;
6. retain the npm audit v2 report and real exit code as evidence;
7. obtain a passing exact-commit GitHub Security Scan before staging; and
8. promote through dev, staging and main only under the normal exact-commit and human-control
   process.

## 6. Portfolio And Expedite Decision

The urgent remedial expedite is **accepted as the immediate pre-promotion dependency
child**. Local `PLAT-ROLE-02` human smoke is complete and independent of its dependency
behaviour. The Role child and this dependency child form one release candidate while
remaining separate commits. The next staging promotion cannot proceed until the combined
exact dev SHA passes the mandatory Security Scan.

Recommended control decision:

- retain the completed local Role human evidence;
- keep this bounded dependency correction as the immediate pre-promotion prerequisite;
- keep it as a separate application commit so dependency evidence remains reviewable; and
- if Role Authority testing becomes prolonged or fails again, prepare the dependency commit
  independently from protected baseline `72c02d92` rather than leaving known High findings
  live while unrelated work continues.

## 7. Completion Evidence Required

Closure requires:

- exact before/after package paths and versions;
- minimal `package.json`/`package-lock.json` diff evidence;
- npm 10 clean install and resolved-tree PASS;
- zero High/Critical npm audit and validator PASS;
- full tests, type-check, verification and production-build PASS;
- exact dev, staging and main Security Scan run IDs and job results;
- explicit branch/promotion hashes; and
- public health plus proportionate staging/live smoke evidence.

Local implementation update: the exact two-package override/lockfile correction, isolated
Node 22/npm 10 clean install, zero-finding audit validator, 372-test regression, TypeScript,
critical verification and 131-page production build all pass. The Role human matrix and
focused exact-Club retest also pass. The work is packaged as two separately reviewable child
commits in one release candidate.

The protected-branch incident is not yet closed: no Security Scan failure may be described
as cleared until the combined exact dev SHA passes every online Security Scan job and the
later branch evidence is recorded.
