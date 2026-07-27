# IsoStack Platform Auth Dependency And Audit-Gate Security Remediation Triage

Date: 2026-07-27

Status: Accepted as urgent bounded Platform assurance remediation

Source CR:

`docs/platform/01-cr-inputs/2026-07-27-isostack-platform-auth-dependency-and-audit-gate-security-remediation-cr-input.md`

## 1. Decision

Accept as `PLAT-ASSURE-03`.

This is a Platform-owned security and assurance correction because it changes the shared
dependency graph, authentication/session contract and repository Security Scan. It is not
LMSPro-, FUND- or Commerce-owned behaviour.

## 2. Severity And Ordering

The 2 critical and 19 high findings justify displacing ordinary feature selection. The current
uncommitted work must be isolated on a dedicated branch, verified, committed and pushed before
`dev` is changed.

The previously requested documentation-only commit `f2b794da` may advance independently to
`dev`. `PLAT-ASSURE-03` must remain a separate reviewable commit and must not be hidden inside
that deletion.

## 3. Required Gates

- bounded plan accepted before implementation commit;
- zero critical/high dependency findings;
- fail-closed audit-parser unit evidence;
- dependency-tree, type-check, critical-file, full-test and production-build evidence;
- exact-commit online Security Scan after promotion to `dev`;
- authenticated staging smoke under the dedicated schedule; and
- separate production authority.

No schema, migration, database or live-data work is required.
