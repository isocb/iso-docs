# CR-Fix — Fast-URI Dependency Advisory Remediation

Date: 2026-09-03

Identifier: `CR-Fix-PLAT-ASSURE-04`

Owning lane: IsoStack Platform assurance

Status: **EXPEDITE ACCEPTED; BOUNDED IMPLEMENTATION AND PROMOTION THROUGH STAGING
AUTHORISED; MAIN NOT AUTHORISED**

Triage:

[`2026-09-03 fast-uri dependency advisory remediation triage`](../02-triage/2026-09-03-isostack-platform-fast-uri-dependency-advisory-remediation-triage.md)

Plan:

[`PLAT-ASSURE-04 bounded remediation plan`](../03-slice-planning/2026-09-03-isostack-platform-plat-assure-04-fast-uri-dependency-advisory-remediation-planning.md)

## 1. Reported Problem

Scheduled GitHub Security Scan run
[`33726655633`](https://github.com/isocb/isostack-bedrock/actions/runs/33726655633)
failed on 2026-09-03 against unchanged protected-branch application commit
`d78935d407ace7ebe796a31a13adf3e17dafa758`. The same commit passed the preceding day's
scan. This is advisory-database drift against a previously accepted lockfile, not evidence
that the paused FUND planning introduced a source defect.

The exact report contains `0` critical, `2` high, `28` moderate and `1` low dependency
findings. Secret Detection, Database Schema Security Check and TypeScript Type Safety pass.

## 2. Incident-Ending Finding

The two High npm counts share one vulnerable dependency root:

```text
react-email 5.2.8
-> conf 15.1.0
-> ajv / ajv-formats
-> fast-uri 3.1.5
```

Four High advisories published on 2026-09-02 affect the locked `fast-uri@3.1.5` host,
scheme and IPv6 interpretation boundary. The first patched 3.x release is `3.1.6`; current
compatible patch `3.1.7` adds the complete available hardening set.

No application source import of the `react-email` CLI package or direct `fast-uri` call was
found. The package is nevertheless in the production dependency graph and the accepted
fail-closed gate is correctly blocking promotion. There is no evidence of exploitation or
of a confidentiality, tenancy or data-integrity incident.

## 3. Accepted Outcome

Replace only the exact root override `fast-uri: 3.1.5` with `fast-uri: 3.1.7`, regenerate
the matching lock record and prove the corrected graph locally and on the protected `dev`
and `staging` branches.

This is a **production build** because it changes the persistent dependency graph used by
application images. The persistent boundary is only `package.json` and `package-lock.json`.
Platform engineering owns that dependency boundary. No credential, external service,
schema, database or new operational component is introduced. Recovery is a normal revert
of the isolated dependency commit followed by the protected promotion corridor.

## 4. Do Not Build

This correction does not authorise:

- lowering, suppressing or bypassing the High/Critical audit threshold;
- `npm audit fix --force`, framework downgrades or unrelated dependency churn;
- application source, schema, migration, database, provider or runtime-configuration work;
- the TipTap 3 major-version migration or merging Dependabot proposals that remain below
  its fixed `3.30.4` boundary;
- unrelated Moderate/Low remediation; or
- promotion to `main`.

## 5. Non-Blocking Findings Retained For Follow-Up

The same report identifies Moderate findings in TipTap 2.27.2, `qs@6.15.2`, development-only
`@humanfs/node@0.16.7` and the already recorded `sanitize-html` chain, plus the existing Low
PostCSS selector-parser finding. These do not weaken the incident-ending High correction.
They remain a separate `PLAT-ASSURE-04-R1` assessment/refinement boundary because TipTap's
supported fix requires a major application-editor migration and must not be concealed in a
transitive patch.

## 6. Completion Boundary

The authorised staging boundary requires:

1. minimal manifest/lockfile diff and exact `fast-uri@3.1.7` resolution;
2. negative proof that the old graph fails and the new graph has zero High/Critical;
3. clean install, focused audit-validator test, full tests, type-check, verification and
   production build;
4. passing exact-commit work-branch, dev and staging Security Scans;
5. staging health and exact deployed-commit evidence; and
6. a short human staging smoke before any later request to promote to `main`.

