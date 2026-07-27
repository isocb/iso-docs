# IsoStack Platform Auth Dependency And Audit-Gate Security Remediation CR Input

Date: 2026-07-27

Status: Captured and accepted for urgent Platform triage

Parent control:

`docs/platform/00-roadmap-control/2026-07-22-isostack-platform-assurance-security-review-and-refinement-roadmap.md`

## 1. Finding

The unchanged application baseline `f2b794da` reports 22 dependency vulnerabilities:

- 2 critical;
- 19 high; and
- 1 moderate.

The affected paths include Auth.js/NextAuth, `brace-expansion` and PostCSS. The Auth.js
advisories include malformed bearer-header handling, Unicode Email normalisation and OAuth
state/nonce/PKCE cookie binding. The existing Security Scan also discards the `npm audit`
exit status with `|| true` and then trusts selected JSON fields without proving that the
report is complete and valid.

## 2. Required Outcome

1. Resolve the current critical/high dependency findings without a forced framework downgrade.
2. Preserve the supported Node 22 and Next.js 15 application baseline.
3. Make the dependency gate fail closed when `npm audit` fails, returns malformed JSON or
   produces inconsistent severity metadata.
4. Retain the policy that high/critical findings block while lower severities remain visible.
5. Preserve authentication, redirect, module-domain, role and tenant behaviour after the
   supported Auth.js/NextAuth update.

## 3. Boundary

This CR permits bounded dependency, audit-workflow, audit-parser/test and directly required
authentication-compatibility changes. It does not authorise schema, migration, database,
environment, provider-secret, deployment, staging or production changes.

The exact implementation must pass automated verification before entering `dev`, then pass
the separately recorded authenticated staging smoke before any production consideration.
