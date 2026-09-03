# Platform Slice PLAT-ASSURE-04 — Fast-URI Dependency Advisory Remediation Staging Gate

Date: 2026-09-03

Status: **TECHNICAL STAGING PASS; EXACT RENDER IDENTITY AND HUMAN SMOKE PENDING; MAIN
BLOCKED**

Implementation:

[`PLAT-ASSURE-04 implementation`](../04-implementation-confirmations/2026-09-03-isostack-platform-plat-assure-04-fast-uri-dependency-advisory-remediation-implementation.md)

## Evidence Summary

```text
Exact commit: 14077382b7d397528e96fb6f7bdea978236a4713
Files/change boundary: exact fast-uri override/lock record only in the implementation commit
Automated checks: all local checks and work/dev/staging Security Scans PASS; staging audit 0 High/0 Critical; public health PASS
Human evidence: pending H1-H4 below
Environment proven: exact origin/dev and origin/staging refs; public staging database/RLS health; exact Render build identity pending dashboard readback
Known residual risk: 28 Moderate/1 Low retained for follow-up; no direct source reachability found for corrected CLI path; main remains unmodified
Next authorised action: complete H1-H4 and report only the four outcomes; then make a separate main-promotion decision
```

## 1. Review Conclusion

The implementation matches the accepted minimum incident-ending scope. The exact lockfile
now resolves `fast-uri@3.1.7`, the old protected baseline supplies a real fail-closed
negative result, and the unchanged repository validator accepts the corrected staging
artifact with zero High/Critical findings. The source/lock diff contains no unrelated
package or behaviour change.

Technical staging disposition: **PASS**.

Release disposition: **HOLD BEFORE MAIN** until the human gate below passes and main is
separately authorised.

## 2. Human Staging Gate

Use `https://staging.seasonpro.co.uk`. This is intentionally small because the correction
changes dependency resolution, not a feature or authentication contract.

1. **H1 — Render identity:** in the staging Render service, confirm status is Live/green
   and displayed commit begins `14077382`.
2. **H2 — Signed-out entry:** in a private/incognito browser window, open the staging
   sign-in page and confirm it renders normally with no application error.
3. **H3 — Authenticated shell:** sign in with one existing authorised staging account;
   confirm its ordinary landing page/dashboard and navigation shell load normally.
4. **H4 — Sign-out:** sign out and confirm the browser returns to a signed-out sign-in
   surface without an application error.

Do not create users, change roles, send an email, edit FUND data or exercise production.
A useful result report is simply:

```text
H1 Render exact 14077382 and Live: PASS/FAIL
H2 signed-out sign-in surface: PASS/FAIL
H3 existing-user dashboard/app shell: PASS/FAIL
H4 sign-out return: PASS/FAIL
```

Any failure keeps main blocked and should include only the visible error/route, not
credentials or personal data.

## 3. Recovery And Main Boundary

If a staging regression is confirmed, revert isolated dependency commit `14077382` through
the protected branch corridor and repeat the scan/health gate. Do not lower the audit
threshold. A passing H1-H4 result does not itself promote main; it makes a later explicit
main-promotion decision safe to consider.

