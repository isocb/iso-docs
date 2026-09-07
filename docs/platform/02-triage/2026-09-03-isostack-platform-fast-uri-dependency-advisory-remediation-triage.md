# Fast-URI Dependency Advisory Remediation Triage

Date: 2026-09-03

Identifier: `CR-Fix-PLAT-ASSURE-04`

Status: **HIGH-CONTROL EXPEDITE ACCEPTED THROUGH STAGING**

Source:

[`CR-Fix — Fast-URI Dependency Advisory Remediation`](../01-cr-inputs/CR-Fix-2026-09-03-isostack-platform-fast-uri-dependency-advisory-remediation.md)

## 1. Decision

```text
Owner          Platform assurance
Control depth  High — a blocking security advisory and production dependency are involved
Urgency        Restore the protected release gate before other application promotion
Work type      Production build; persistent package manifest and lockfile only
Data           No schema, migration, database or live-data work
Release        Isolated correction through dev and staging; stop before main
```

The control owner accepted the recommended expedite on 2026-09-03. Under the portfolio
interrupt rule it displaces, but does not cancel or alter, the selected FUND `1R-F-B`
planning review.

## 2. Risk And Root Cause

| Risk | Assessment | Treatment |
| --- | --- | --- |
| Vulnerable URI interpretation | High advisory severity; low reviewed reachability because application source does not invoke the transitive CLI path | Patch to exact compatible `3.1.7`; do not suppress |
| Release-gate failure | Certain on all unchanged protected branches | Stop promotion until the exact corrected scans pass |
| Unrelated dependency churn | Medium | Accept only the `fast-uri` override and corresponding lock record |
| Product regression from install graph | Low but non-zero | Clean install, full regression/type/verify/build, staging health and representative human smoke |
| Incomplete Moderate remediation | Known and separate | Retain `PLAT-ASSURE-04-R1`; do not represent the whole audit as clean |

The old lockfile is the required failure case: the repository validator correctly refuses
its High findings. The new candidate must prove zero High/Critical while the same validator
and workflow remain unchanged.

## 3. Failure, Rollback And Stop Boundaries

- Stop if lock regeneration changes any package other than `fast-uri` or its direct lock
  metadata without an explained deterministic requirement.
- Stop if `npm ls` does not resolve exactly `fast-uri@3.1.7` or if High/Critical findings
  remain.
- Stop before staging if any local gate or exact work/dev Security Scan fails.
- Stop after staging if health, exact deployment identity or human smoke does not pass.
- Roll back by reverting the isolated application dependency commit; do not weaken the
  audit gate to preserve a promotion.

## 4. Proportionate Human Evidence

No feature, authentication contract, schema or user interface changes. The human gate is
therefore a small staging regression check, not a broad FUND or email campaign test:

1. confirm the staging service is Live at the exact corrected commit;
2. open the staging sign-in surface;
3. authenticate as one existing authorised staging user and load the main dashboard/app
   shell; and
4. sign out and confirm return to the sign-in surface.

A real email send is not required: the corrected path is transitive CLI tooling, not the
runtime `@react-email/components` rendering path used by application source.
