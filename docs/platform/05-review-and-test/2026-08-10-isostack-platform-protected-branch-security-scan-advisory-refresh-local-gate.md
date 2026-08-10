# Protected-Branch Security Scan Advisory Refresh Local Gate

Date: 2026-08-10

Status: **COMPLETE LOCAL/STAGING/PRODUCTION PASS; EXACT `60ac76c1` DEV, STAGING AND MAIN
SECURITY SCANS, STAGING 8/8, STAGING/PRODUCTION HEALTH AND PRODUCTION RENDER/C1/C2
EVIDENCE PASS; CLOSED**

Implementation:

[`Protected-Branch Security Scan Advisory Refresh Implementation`](../04-implementation-confirmations/2026-08-10-isostack-platform-protected-branch-security-scan-advisory-refresh-implementation.md)

Role human gate:

[`PLAT-ROLE-02B Local Gate`](2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity-local-gate.md)

## 1. Review Conclusion

The local implementation matches the accepted bounded remediation:

- both affected packages resolve above their first patched versions;
- the fail-closed audit threshold and validator remain unchanged;
- the lockfile contains no unrelated resolution churn;
- the isolated accepted-toolchain clean install is reproducible and audit-clean;
- combined application tests, verification and build pass; and
- the complete Role matrix, focused item-7 retest and read-only Derby exact-junction proof
  all pass.

## 2. Exact Local Evidence

```text
js-yaml                       4.3.1 only
nanoid                        3.3.18 only
npm audit                     0 total vulnerabilities
repository audit validator    PASS
full regression               372 PASS / 12 SKIP
TypeScript                     PASS
critical verification         PASS
body backport verification    PASS
production build              PASS / 131
dependency diff               PASS / minimal
latest old-SHA online review  PASS / dependency jobs only identified
```

Latest old-lockfile evidence is Security Scan
[`31366209496`](https://github.com/isocb/isostack-bedrock/actions/runs/31366209496).
It fails the three scheduled protected-branch dependency validators and passes TypeScript,
secret, schema and final-report jobs. The corrected candidate has not yet been pushed, so it
does not yet have an online PASS claim.

## 3. Online Evidence And Remaining Completion Gate

The combined candidate is aligned across local/remote dev, staging and main with passing
exact scans:

- dev Security Scan [`31384553388`](https://github.com/isocb/isostack-bedrock/actions/runs/31384553388): PASS;
- staging Security Scan [`31384766945`](https://github.com/isocb/isostack-bedrock/actions/runs/31384766945): PASS;
- main Security Scan [`31387014370`](https://github.com/isocb/isostack-bedrock/actions/runs/31387014370): PASS;
- staging indicative human smoke: PASS, 8/8, including exact-current-Club junction proof;
- staging public health: HTTP 200, database connected, RLS 11/11; and
- production public health: HTTP 200, database connected, RLS 11/11.

The dependency remediation and protected-branch scan gates are complete. The combined Role
release still requires Render confirmation that production is Live at exact `60ac76c1`
and the documented non-mutating C1/C2 route smoke; public health alone does not expose SHA.

Current decision: **DEPENDENCY SECURITY CORRECTION IS DELIVERED THROUGH MAIN; RETAIN THE
PRODUCTION EXACT-BUILD/ROUTE CHECK AS COMBINED RELEASE EVIDENCE**.
