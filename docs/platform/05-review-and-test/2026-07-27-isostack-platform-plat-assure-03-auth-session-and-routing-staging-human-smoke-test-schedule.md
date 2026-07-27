# IsoStack Platform PLAT-ASSURE-03 Auth Session And Routing Staging Human Smoke-Test Schedule

Date: 2026-07-27

Status: COMPLETE — exact staging commit `df40f45c`; bounded Auth.js/session/routing
remediation scenarios PASS; two pre-existing findings registered separately

Planning control:

`docs/platform/03-slice-planning/2026-07-27-isostack-platform-plat-assure-03-auth-dependency-and-audit-gate-security-remediation-planning.md`

## 1. Purpose

Prove that the Auth.js/NextAuth dependency correction and stricter `session.user` guards
preserve real browser authentication, module routing and authorisation. Automated tests and
a production build do not close this gate.

## 2. Preconditions

| Precondition | Result |
| --- | --- |
| Exact staging application commit | PASS — `df40f45c` |
| Matching passing Security Scan | PASS — staging run `30260218731` |
| Staging health | PASS — HTTP 200, database connected, RLS enabled on 11/11 tables |
| Browser/viewport | Desktop Vivaldi, Chrome and Safari |
| Representative roles | P1 Platform administrator, ordinary tenant owner/admin, LMSPro C1, LMSPro C2 and relevant FUND account condition |
| Separate signed-out/private context | PASS |
| Production excluded | PASS — no production environment tested or changed |

No credentials, session cookies, tokens, email links, passwords or environment values were
recorded in this evidence.

## 3. Signed-Out Routing

| Scenario | Result | Evidence |
| --- | --- | --- |
| Public root remains public without a redirect loop | PASS | HTTP 200 and browser confirmation |
| `/welcome` and a protected shared `/app/...` route use the correct sign-in surface | PASS | `/welcome` returned HTTP 307 with encoded callback; browser confirmed |
| SeasonPro root and protected LMSPro route use the LMSPro login/callback path | PASS | HTTP 307 responses and browser confirmation |
| Platform login remains reachable | PASS | HTTP 200 with Platform Administration sign-in content |
| Protected pages do not briefly render private content | PASS | Protected HTTP responses redirect without private page content; browser confirmed |

## 4. Authenticated Shared And Module Entry

The authorised tester completed these scenarios for the applicable representative accounts.

| Scenario | Result |
| --- | --- |
| Ordinary staging sign-in completes | PASS |
| Authenticated root resolves through `/welcome` | PASS |
| Shared application shell loads without blank state, HTTP 500 or redirect loop | PASS |
| Account reaches its authorised Product/module entry | PASS, subject to supplemental finding `PLAT-REFINE-03` below |
| Opening an auth page while signed in returns to the accepted authenticated entry | PASS |
| Sign-out makes the next protected request require authentication | PASS |

## 5. LMSPro And FUND Regression

| Scenario | Result | Evidence |
| --- | --- | --- |
| LMSPro C1 League dashboard summary and authorised component panels load | PASS | Browser confirmation |
| LMSPro C2 accepted Club entry works without gaining C1 dashboard access | PASS | Browser confirmation |
| A session without an authorised LMSPro role cannot gain LMSPro content by direct navigation | PASS | Browser confirmation |
| FUND client-unavailable route behaves according to its intended account condition | PASS | Representative FUND condition confirmed |
| Tested accounts cannot cross into another organisation through copied URLs | PASS | Browser confirmation |

### Supplemental Finding A — Unentitled FUND Shell

An LMSPro-only C1 or C2 session can navigate directly to `/app/fund` and render the static
FUND dashboard shell and CRUD affordances. Attempted mutations return `FORBIDDEN`, and no
cross-tenant access was observed.

This is not accepted as security by URL obscurity. Static review and application history
show that the route-level entitlement gap predates the current Auth.js remediation. It is
registered without reopening this bounded remediation under:

- Platform parent `PLAT-REFINE-03` in
  `docs/platform/00-roadmap-control/2026-07-22-isostack-platform-assurance-security-review-and-refinement-roadmap.md`;
- FUND consumer `2R-ACCESS-01` in
  `docs/modules/fund/00-roadmap-control/2026-07-20-fund-refinement-wishlist-and-slice-control.md`;
- the Platform child roadmap; and
- the root roadmap.

The registered item requires a read-only route/API inventory and mandatory priority
elevation if tenant data disclosure or a broader authorization bypass is found.

## 6. Expiry, Revocation And Impersonation

| Scenario | Result | Evidence |
| --- | --- | --- |
| Revisit a protected URL after sign-out | PASS | Clean sign-in redirect; no private content or loop |
| Normal staging expiry/revocation handling | PASS | Protected request failed closed |
| End/sign out of an available impersonation session | PASS | Impersonation context cleared and the correct login surface reached |

### Supplemental Finding B — Impersonation Tenant-View Fidelity

Starting P1 impersonation reaches the expected C1 dashboard, but the dashboard presents an
effectively new or empty tenant rather than the selected tenant's established data.
Stop/sign-out behaviour itself passes.

Static review found mixed identity propagation: shared tRPC context resolves an effective
user and organisation, while many LMSPro dashboard/data procedures still use the real P1
session identity and shared RLS retains the real Platform-administrator bypass. The
relevant Auth.js remediation changed only defensive `session.user` presence checks, so the
evidence supports a pre-existing impersonation-fidelity defect rather than a regression.

This is registered as `PLAT-REFINE-04 — Impersonation Effective-Principal And Tenant-View
Contract` in the Platform assurance/refinement roadmap, Platform child roadmap and root
roadmap. It requires a read-only identity/RLS consumer inventory and mandatory priority
elevation if cross-tenant disclosure, unauthorised mutation or another security-boundary
failure is found.

Do not fabricate or inject production cookies. Any low-level malformed bearer-header proof
belongs to automated/operational evidence, not this browser schedule.

## 7. Pass/Fail And Evidence Rule

PASS for the bounded `PLAT-ASSURE-03` remediation requires every applicable scheduled
scenario to succeed with:

- no unexpected HTTP 500 response, blank shell or redirect loop attributable to the
  remediation;
- no private content shown to a signed-out user;
- no new role, module or tenant-access expansion attributable to the remediation;
- successful ordinary sign-in/sign-out for the tested roles; and
- no new browser-console error attributable to the remediation.

The authorised tester confirmed that everything worked except the two noted supplemental
findings. No remediation-attributable browser-console error was reported during testing in
Vivaldi, Chrome or Safari; no separate console export was retained.

A pre-existing observation may be separated from the bounded remediation result only when
the evidence establishes that it predates the change, records the actual security boundary
observed and registers controlled follow-up without claiming that the underlying behaviour
is acceptable.

This schedule does not authorise production promotion.

## 8. 2026-07-27 Execution Record

Exact evidence:

- application `dev`, `origin/dev`, `staging` and `origin/staging`: `df40f45c`;
- exact dev Security Scan `30260022945`: PASS;
- exact staging Security Scan `30260218731`: PASS;
- no Prisma/schema/migration delta;
- Render-served staging assets reported `Last-Modified: Mon, 27 Jul 2026 11:02:22 GMT`;
- staging health: HTTP 200, database connected and RLS enabled on 11 of 11 tables; and
- no production environment tested or changed.

Disposition: **PASS FOR THE BOUNDED PLAT-ASSURE-03 STAGING HUMAN GATE**.

Signed-out, authenticated P1/tenant/LMSPro/FUND, expiry/revocation and impersonation
stop/sign-out scenarios pass on exact staging commit `df40f45c`. The two supplemental
pre-existing findings remain open under `PLAT-REFINE-03` / `2R-ACCESS-01` and
`PLAT-REFINE-04`; their registration does not authorise implementation or data change and
does not constitute production-promotion authority.
