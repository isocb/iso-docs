# Protected-Branch Security Scan Advisory Refresh Local Gate

Date: 2026-08-10

Status: **LOCAL REVIEW PASS; COMBINED EXACT `60ac76c1` TECHNICALLY GREEN WITH SEPARATE ROLE
`b1ede26f` AND DEPENDENCY CHILD COMMITS; EXACT DEV SECURITY SCAN/PROMOTION EVIDENCE PENDING**

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

## 3. Online Stop Gate

Local audit success does not clear the protected-branch incident. Completion still requires:

1. explicit authority to push exact combined `60ac76c1` to dev;
2. every exact dev Security Scan job passing, with run ID and audit artifact reviewed;
3. explicit staging authority followed by exact staging scan/health and proportionate Role
   smoke; and
4. the separately authorised main scan, health and smoke lifecycle.

Current decision: **LOCAL COMBINED CANDIDATE PASS; DO NOT PROMOTE TO STAGING UNTIL THE
EXACT COMBINED DEV SHA PASSES THE ONLINE SECURITY SCAN**.
