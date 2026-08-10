# Protected-Branch Security Scan Advisory Refresh Planning

Date: 2026-08-10

Status: **BOUNDED REMEDIAL SLICE COMPLETE AND DELIVERED THROUGH PRODUCTION AS
`60ac76c1` AFTER ROLE CHILD `b1ede26f`; ALL ONLINE GATES PASS; CLOSED**

Source:

[`Protected-Branch Security Scan Advisory Refresh CR-Fix`](../01-cr-inputs/CR-Fix-2026-08-09-isostack-platform-protected-branch-security-scan-advisory-refresh.md)

Triage:

[`Protected-Branch Security Scan Advisory Refresh Triage`](../02-triage/2026-08-09-isostack-platform-protected-branch-security-scan-advisory-refresh-triage.md)

## 1. Decision And Objective

Accept the recommended expedite as the mandatory dependency child immediately after the
locally accepted `PLAT-ROLE-02` child. Restore zero High/Critical dependency findings before
any staging promotion while keeping the Role and dependency diffs separately reviewable.

This is one **release candidate**, not one opaque implementation diff:

```text
child commit 1 -> PLAT-ROLE-02A/02B application and Role documentation boundary
child commit 2 -> exact js-yaml/nanoid dependency resolution and security evidence
combined SHA   -> dev Security Scan gate before any staging decision
```

## 2. Implementation Boundary

- add exact root overrides `js-yaml: 4.3.1` and `nanoid: 3.3.18`;
- regenerate only the corresponding lockfile package records using Node 22/npm 10.9.8;
- retain existing ESLint, PostCSS, Next.js, audit workflow and validator versions;
- make no source, schema, migration, workflow, environment or database change; and
- reject force fixes, threshold suppression and unrelated dependency churn.

Expected durable dependency diff:

```text
package.json      two exact override lines
package-lock.json version/resolved/integrity records for two packages only
```

## 3. Local Gates

1. isolated clean `npm ci --ignore-scripts` under Node 22.18.0/npm 10.9.8;
2. `npm ls js-yaml nanoid --all` resolves patched versions only;
3. npm audit v2 report plus the repository fail-closed validator reports zero blocking
   findings;
4. full Vitest, TypeScript, critical-file verification, body-backport verification and
   production build pass against the combined tree;
5. complete diff and whitespace review pass; and
6. Role human evidence remains the accepted authenticated product gate because the
   dependency child changes no product behaviour.

## 4. Promotion Gates

The two local child commits are formed. Continue only when authorised:

1. align the combined exact SHA to `origin/dev` only when explicitly authorised;
2. require every exact dev Security Scan job to pass and retain its run ID/artifact;
3. verify staging is fast-forwardable from that exact SHA;
4. obtain explicit staging authority;
5. run exact staging Security Scan, public health and proportionate Role smoke; and
6. use the normal separately authorised main lifecycle.

No staging or main promotion is authorised by this plan.

## 5. Recovery

Revert the dependency child commit only. The preceding Role child remains independently
reviewable and testable. Do not lower the audit threshold or remove evidence to make a gate
green.
