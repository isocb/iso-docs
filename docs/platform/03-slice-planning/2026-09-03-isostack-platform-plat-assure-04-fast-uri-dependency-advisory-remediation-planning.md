# Platform Slice PLAT-ASSURE-04 — Fast-URI Dependency Advisory Remediation Planning

Date: 2026-09-03

Status: **ACCEPTED FOR IMPLEMENTATION AND PROMOTION THROUGH STAGING; MAIN NOT AUTHORISED**

Control depth: `High` — the work corrects a security advisory in the production dependency
graph and restores a mandatory protected-branch release gate.

Work type: **Production build**. It changes only the package manifest/lockfile used to
build recoverable application images. It creates no service, credential, database state or
provider configuration.

Source and triage:

- [`CR-Fix`](../01-cr-inputs/CR-Fix-2026-09-03-isostack-platform-fast-uri-dependency-advisory-remediation.md)
- [`triage`](../02-triage/2026-09-03-isostack-platform-fast-uri-dependency-advisory-remediation-triage.md)

## Restart Checkpoint

```text
Current state: accepted High-control Platform security expedite; bounded implementation on a dedicated application branch is next
Last proven commit: application dev/origin-dev 0c7e48489aef697c6f39faf1a081456f9f3858a4; scheduled protected baseline d78935d407ace7ebe796a31a13adf3e17dafa758 fails Security Scan 33726655633 on the new fast-uri advisories
Current environment: local work branch fix/platform-fast-uri-advisory-20260903; no application, schema, database, provider, credential or deployment mutation yet
Next human decision/test: after exact staging deployment and automated gates pass, complete the four-check staging smoke recorded in triage before any main-promotion decision
Safe resumption point: inspect package.json/package-lock.json and this plan; change only fast-uri 3.1.5 to exact 3.1.7; stop on diff, audit, test, scan, health or deployment-identity mismatch
```

## 1. Authorised Outcome

1. change the existing exact `fast-uri` override from `3.1.5` to `3.1.7`;
2. regenerate and inspect the lockfile using the repository Node/npm boundary;
3. prove the failure and corrected dependency/audit boundaries;
4. run focused and full regression gates;
5. commit the isolated correction and obtain an exact work-branch Security Scan;
6. consolidate the exact commit into `dev`, require its protected scan, then promote that
   same ancestry to `staging` and require the staging scan; and
7. verify staging health/deployment identity, document the human gate and stop before
   `main`.

## 2. Expected Durable Diff

```text
package.json       one override version
package-lock.json  the corresponding fast-uri version/resolved/integrity record
```

No source, workflow, validator, schema, migration or environment file is authorised.

## 3. Required Gates

- old-lockfile validator refusal retained as negative evidence;
- `npm ci` from the corrected lockfile;
- `npm ls fast-uri --all` resolves `3.1.7` only;
- fresh npm audit report plus unchanged repository validator: zero High/Critical;
- focused audit-validator tests;
- full test suite, TypeScript, repository verification and production build;
- complete diff/whitespace review;
- exact work-branch, dev and staging Security Scans; and
- staging public health, exact build identity and the four human checks in triage.

Moderate/Low findings remain truthfully reported; this slice does not claim a zero-total
audit.

## 4. Recovery

The dependency change is one isolated commit. Before main, recovery is to revert that
commit and rebuild the affected branch. No data rollback, credential rotation or provider
cleanup exists. A failed gate stops forward promotion.

## 5. Stopping Point

Stop with the corrected exact commit promoted no farther than `staging`. `main` remains
unchanged until the control owner reports the human staging smoke and gives a separate
promotion instruction.

