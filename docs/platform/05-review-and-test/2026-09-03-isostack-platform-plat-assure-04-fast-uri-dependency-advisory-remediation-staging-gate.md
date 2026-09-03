# Platform Slice PLAT-ASSURE-04 — Fast-URI Dependency Advisory Remediation Staging Gate

Date: 2026-09-03

Status: **COMPLETE STAGING PASS; EXACT RENDER IDENTITY AND H1-H4 PASS; MAIN PROMOTION
SUBSEQUENTLY EXPLICITLY AUTHORISED**

Implementation:

[`PLAT-ASSURE-04 implementation`](../04-implementation-confirmations/2026-09-03-isostack-platform-plat-assure-04-fast-uri-dependency-advisory-remediation-implementation.md)

## Evidence Summary

```text
Exact commit: 14077382b7d397528e96fb6f7bdea978236a4713
Files/change boundary: exact fast-uri override/lock record only in the implementation commit
Automated checks: all local checks and work/dev/staging Security Scans PASS; staging audit 0 High/0 Critical; public health PASS
Human evidence: H1-H4 PASS on 2026-09-03
Environment proven: exact origin/dev and origin/staging refs; public staging database/RLS health; staging Render exact 14077382 Live
Known residual risk: 28 Moderate/1 Low retained for follow-up; no direct source reachability found for corrected CLI path
Next authorised action: completed — control owner separately authorised main promotion after this gate passed
```

## 1. Review Conclusion

The implementation matches the accepted minimum incident-ending scope. The exact lockfile
now resolves `fast-uri@3.1.7`, the old protected baseline supplies a real fail-closed
negative result, and the unchanged repository validator accepts the corrected staging
artifact with zero High/Critical findings. The source/lock diff contains no unrelated
package or behaviour change.

Technical staging disposition: **PASS**.

Release disposition: **PASS**. The control owner subsequently gave the required separate
main-promotion instruction.

## 2. Human Staging Gate — PASS

The control owner completed this intentionally small gate at
`https://staging.seasonpro.co.uk` on 2026-09-03:

```text
H1 Render exact 14077382 and Live: PASS
H2 signed-out sign-in surface: PASS
H3 existing-user dashboard/app shell: PASS
H4 sign-out return: PASS
```

The executed boundary was:

1. **H1 — Render identity:** in the staging Render service, confirm status is Live/green
   and displayed commit begins `14077382`.
2. **H2 — Signed-out entry:** in a private/incognito browser window, open the staging
   sign-in page and confirm it renders normally with no application error.
3. **H3 — Authenticated shell:** sign in with one existing authorised staging account;
   confirm its ordinary landing page/dashboard and navigation shell load normally.
4. **H4 — Sign-out:** sign out and confirm the browser returns to a signed-out sign-in
   surface without an application error.

No user, role, email, FUND data or production mutation was required or reported.

## 3. Recovery And Main Boundary

If a staging regression is confirmed, revert isolated dependency commit `14077382` through
the protected branch corridor and repeat the scan/health gate. Do not lower the audit
threshold. A passing H1-H4 result does not itself promote main; it makes a later explicit
main-promotion decision safe to consider.
