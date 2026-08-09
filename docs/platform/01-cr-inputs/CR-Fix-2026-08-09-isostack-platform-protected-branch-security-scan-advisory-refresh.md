# CR-Fix — Protected-Branch Security Scan Advisory Refresh

Date: 2026-08-09

Owning lane: IsoStack Platform assurance

Status: **CAPTURED AND TRIAGED AS AN URGENT REMEDIAL EXPEDITE CANDIDATE; NO APPLICATION,
LOCKFILE, WORKFLOW, BRANCH OR ENVIRONMENT CHANGE AUTHORISED**

Triage and remediation advice:

[`2026-08-09 protected-branch Security Scan triage`](../02-triage/2026-08-09-isostack-platform-protected-branch-security-scan-advisory-refresh-triage.md)

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

The configured GitHub CLI credential has expired, and the private Actions API cannot be read
anonymously. Exact run IDs, job timestamps and confirmation that no second job also failed
therefore remain unresolved. That evidence limitation does not invalidate the dependency
diagnosis: the protected branches share the reproduced failing lockfile and the authoritative
gate is designed to fail on either High advisory.

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

## 6. Portfolio And Expedite Request

This is an **urgent remedial expedite candidate**, not a self-authorising emergency release.
Local `PLAT-ROLE-02` human smoke can continue because the finding is independent of its
persona behaviour. The next remote push or staging promotion cannot pass the mandatory
Security Scan until this CR-Fix is resolved.

Recommended control decision:

- finish or reach a safe stopping point in the current local human smoke;
- accept this bounded dependency correction as the immediate pre-promotion prerequisite;
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

Until then, no Security Scan failure may be described as cleared merely because the reviewed
application appears unlikely to expose the vulnerable functions.
