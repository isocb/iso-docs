# FUND Phase 1 Slice 1P-G-F-A-R1 - Public Project Initiation Staging Security And Pre-Live Review

Date: 2026-06-30

## 1. Review Scope

Review the staging deployment immediately after promoting:

```text
da023d5 feat(fund): add public project initiation form
```

Staging target:

```text
https://staging.isostack.app
```

Review focus:

- branch alignment after promotion;
- local repo verification checks;
- staging health endpoint;
- staging security response headers;
- authentication boundary for C1 Project Intake admin routes;
- public Project initiation route availability;
- dependency audit summary;
- readiness for live promotion.

This was a non-destructive review. No application code, schema, migration, database, seed/reset, notification, Store, Orders, Commerce or SeasonPro integration work was performed.

## 2. Verdict

```text
Proceed with caveats / do not promote to live until the public-route gating caveat is resolved or explicitly accepted.
```

The staging deployment is healthy and the C1 admin route remains protected.

However, the new public Project initiation route currently redirects unauthenticated users to sign-in:

```text
/fund/project-initiation/non-existent-security-check-slug
-> 307 /auth/signin?callbackUrl=%2Ffund%2Fproject-initiation%2Fnon-existent-security-check-slug
```

That is safe from a security perspective, but it blocks the intended public/client-facing initiation workflow. Before live promotion, either:

- add the intended middleware/public-route exception for `/fund/project-initiation/*`; or
- explicitly defer public availability and promote only the C1/admin preparation work.

## 3. Branch Alignment

App repo status after promotion:

```text
dev     = da023d5
staging = da023d5
origin/dev = da023d5
origin/staging = da023d5
feature/fund-phase-1-c2-project-access = da023d5
```

Local active branch during review:

```text
dev...origin/dev
```

Working tree:

```text
clean
```

Docs repo note:

```text
isodocs main is ahead of origin/main with local documentation commits.
```

Docs were not pushed as part of this review.

## 4. Local Checks Run

Checks:

```text
npm run type-check
npm run verify
git diff --check
```

Results:

- `npm run type-check` passed.
- `npm run verify` initially hit the known sandbox `tsx` IPC pipe permission issue, then passed when rerun with the approved escalation path.
- `git diff --check` passed.

`npm run verify` confirmed:

- LMSPro Seasons critical page check passed;
- Organizations router critical file check passed;
- Prisma schema critical file check passed;
- TypeScript type check passed.

## 5. Dependency Audit

Command:

```text
npm audit --audit-level=high
```

Result:

```text
No high or critical vulnerabilities reported.
```

Audit output did report lower-severity advisories:

- `esbuild` low severity advisory under `tsx` dependency tree;
- `postcss` moderate severity advisory through `next`;
- total reported: 3 vulnerabilities, 1 low and 2 moderate.

No dependency changes were made during this review.

Follow-up:

- assess whether `npm audit fix` is safe in a separate maintenance slice;
- do not use `npm audit fix --force` without planning because the audit output proposes a breaking Next.js downgrade path.

## 6. Staging Health Check

Endpoint:

```text
https://staging.isostack.app/api/health
```

Result:

```json
{
  "status": "healthy",
  "checks": {
    "database": "connected",
    "rls": {
      "enabled": true,
      "tables": "11/11"
    }
  }
}
```

Assessment:

```text
Pass
```

The staging app is serving, database connectivity is healthy and RLS check reports enabled across 11/11 tables.

## 7. Security Header Check

Endpoint:

```text
https://staging.isostack.app/
```

Observed positive headers:

```text
strict-transport-security: max-age=31536000; includeSubDomains; preload
content-security-policy: present
permissions-policy: geolocation=(), camera=(), microphone=(), payment=()
referrer-policy: strict-origin-when-cross-origin
x-content-type-options: nosniff
x-frame-options: DENY
x-dns-prefetch-control: off
x-download-options: noopen
x-permitted-cross-domain-policies: none
cache-control: private, no-cache, no-store, max-age=0, must-revalidate
```

Assessment:

```text
Pass with caveats
```

Positive:

- HTTPS/HSTS is enabled.
- Frame embedding is blocked with `DENY` and CSP `frame-ancestors 'none'`.
- Content sniffing is disabled.
- Permissions Policy blocks camera, microphone, geolocation and payment.
- Referrer policy is present.

Caveats:

- `x-powered-by: Next.js` is exposed. This is not a blocking issue, but should be considered for hardening.
- CSP currently includes `unsafe-inline` and `unsafe-eval` in `script-src`. This may be required by the current Next/Mantine stack, but should remain on the security-hardening backlog.
- CSP `object-src` is permissive relative to a stricter modern baseline. It should be reviewed before stronger compliance targets.

## 8. C1 Admin Route Protection

Endpoint:

```text
https://staging.isostack.app/app/fund/project-intake
```

Unauthenticated result:

```text
HTTP 307
location: /auth/signin?callbackUrl=%2Fapp%2Ffund%2Fproject-intake
```

Assessment:

```text
Pass
```

C1 Project Intake admin remains protected for unauthenticated users.

## 9. Public Project Initiation Route Probe

Endpoint:

```text
https://staging.isostack.app/fund/project-initiation/non-existent-security-check-slug
```

Unauthenticated result:

```text
HTTP 307
location: /auth/signin?callbackUrl=%2Ffund%2Fproject-initiation%2Fnon-existent-security-check-slug
```

Assessment:

```text
Functional blocker / safe security posture
```

The route is not leaking data and is safely auth-gated. However, this is not the intended behaviour for the public Project initiation form.

Expected future behaviour:

```text
Unauthenticated public route should load the public form for an active slug,
or show a safe unavailable state for missing/inactive/expired slugs.
```

Recommended remediation:

```text
1P-G-F-A-R2 - Public Project Initiation Security, Event Scope And Form UX Remediation Planning
```

Scope for remediation:

- review middleware/public-route allowlist;
- allow unauthenticated access to `/fund/project-initiation/*`;
- keep `/app/fund/project-intake/*` protected;
- render the public form on a vanilla page without IsoStack marketing/navigation chrome;
- preserve Event-scoped form context from trusted `FundProjectIntakeForm.defaultEventId`;
- add Project start and closing date handling with Event min/max constraints where applicable;
- align date/time picker usage with the existing app pattern;
- replace free-text allowed Client/organisation type input with bounded selection where possible;
- preserve form-field alignment when helper/subtitle text is present;
- confirm inactive/missing public form slugs show safe unavailable UI and do not reveal tenant internals;
- rerun this staging pre-live review.

## 10. Public Workflow Boundary

Confirmed from implementation and review context:

- public submission creates moderation records only;
- no Client user/member provisioning is implemented;
- no invitations are implemented;
- no Store, Orders, Commerce, Sales/Reporting or production workflow is implemented;
- no SeasonPro integration is implemented;
- only the bounded confirmation/authentication email exception is permitted before the future editable notifications lane.

## 11. Live Promotion Recommendation

Recommendation:

```text
Do not promote this slice to live as the public initiation form until the public route access caveat is fixed and smoke tested.
```

Acceptable alternative:

```text
Promote only if the live objective is to deploy the C1/admin form-management groundwork while keeping public initiation inaccessible until the follow-up fix.
```

Before live promotion:

- fix or explicitly accept the public-route auth gating behaviour;
- browser smoke test:
  - C1 `/app/fund/project-intake`;
  - C1 form create/edit with Default Event selector;
  - Copy/Open public link affordance;
  - public form route for active form slug;
  - safe unavailable state for missing slug;
  - confirmation-pending and confirmation states where email/test link allows;
- confirm no unexpected workflow emails are sent beyond the intended confirmation/authentication exception.

## 12. Recommended Next Step

Recommended remedial slice:

```text
1P-G-F-A-R2-A - Public Project Initiation Route And Event-Scoped Form Remediation
```

Then rerun:

```text
1P-G-F-A-R2-R1 - Public Project Initiation Remediation Review And Staging Smoke Test
```
