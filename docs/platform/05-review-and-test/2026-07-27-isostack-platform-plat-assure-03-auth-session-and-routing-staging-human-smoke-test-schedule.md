# IsoStack Platform PLAT-ASSURE-03 Auth Session And Routing Staging Human Smoke-Test Schedule

Date: 2026-07-27

Status: Partially executed against exact staging commit `df40f45c`; signed-out and operational
checks PASS; authenticated P1/C1/C2/FUND browser scenarios NOT RUN pending designated staging
accounts and an interactive tester

Planning control:

`docs/platform/03-slice-planning/2026-07-27-isostack-platform-plat-assure-03-auth-dependency-and-audit-gate-security-remediation-planning.md`

## 1. Purpose

Prove that the Auth.js/NextAuth dependency correction and stricter `session.user` guards preserve
real browser authentication, module routing and authorisation. Automated tests and a production
build do not close this gate.

## 2. Preconditions

Record before testing:

- exact staging application commit;
- matching passing Security Scan run;
- staging health is green;
- browser and viewport used;
- tester role/account class without recording credentials; and
- confirmation that no production environment is under test.

Use representative authorised staging accounts for:

- Platform administrator;
- ordinary tenant owner/admin;
- LMSPro C1;
- LMSPro C2; and
- FUND role(s) needed to reach the affected client-unavailable route.

Use a separate signed-out/private browser context. Do not place session cookies, tokens, Email
links, passwords or environment values in screenshots or evidence.

## 3. Signed-Out Routing

1. Open the public root page and confirm it remains public without a redirect loop.
2. Open `/welcome` and a protected shared `/app/...` route and confirm redirection to the correct
   sign-in surface.
3. On the LMSPro module domain, open `/` and a protected LMSPro route and confirm the correct
   LMSPro login/callback path.
4. Open the Platform login route and confirm it remains reachable.
5. Confirm protected pages do not briefly render private application content before redirect.

## 4. Authenticated Shared And Module Entry

For each relevant account:

1. complete the ordinary staging sign-in flow;
2. confirm the authenticated root route resolves through `/welcome`;
3. confirm the shared application shell loads without a blank state, 500 response or redirect
   loop;
4. confirm the account reaches only its authorised Product/module entry;
5. confirm opening an auth page while signed in returns to the accepted authenticated entry; and
6. sign out and confirm the next protected request requires authentication.

## 5. LMSPro And FUND Regression

1. With LMSPro C1, open the League dashboard and confirm its summary and authorised component
   panels load.
2. With LMSPro C2, confirm the accepted Club entry route works and no C1 dashboard access is
   gained.
3. Confirm a session without an authorised LMSPro role cannot gain LMSPro content through direct
   navigation.
4. Exercise the FUND client-unavailable route with its intended account condition and confirm it
   renders or redirects according to the existing contract.
5. Confirm no tested account can cross into another organisation/tenant through copied URLs.

## 6. Expiry And Defensive Session Handling

1. Sign out from an authenticated tab, then revisit a protected URL in that tab and confirm a
   clean sign-in redirect rather than private content or a loop.
2. Where the staging test harness permits normal session expiry/revocation, repeat a protected
   request and confirm the same fail-closed result.
3. If an impersonation session is available to the authorised Platform tester, end/sign out of
   it and confirm stale impersonation context does not preserve access.

Do not fabricate or inject production cookies. Any low-level malformed bearer-header proof
belongs to automated/operational evidence, not this browser schedule.

## 7. Pass/Fail And Evidence

PASS requires every applicable scenario to succeed with:

- no unexpected 500 response, blank shell or redirect loop;
- no private content shown to a signed-out user;
- no role, module or tenant-access expansion;
- successful ordinary sign-in/sign-out for the tested roles; and
- no new browser console error attributable to the remediation.

Record PASS, FAIL or NOT RUN for each numbered scenario. A failure keeps staging/production
promotion on hold and returns the exact observation to the implementation branch. This schedule
does not authorise production promotion.

## 8. 2026-07-27 Execution Record

Preconditions:

- application `dev`, `origin/dev`, `staging` and `origin/staging`: `df40f45c`;
- exact dev Security Scan `30260022945`: PASS;
- exact staging Security Scan `30260218731`: PASS;
- no Prisma/schema/migration delta;
- Render-served staging assets report `Last-Modified: Mon, 27 Jul 2026 11:02:22 GMT`;
- staging health: HTTP 200, database connected and RLS enabled on 11 of 11 tables; and
- no production environment tested or changed.

Signed-out/operational result:

| Scenario | Result | Evidence |
| --- | --- | --- |
| Public IsoStack root | PASS | HTTP 200 |
| `/welcome` while signed out | PASS | HTTP 307 to `/auth/signin?callbackUrl=%2Fwelcome` |
| Shared protected LMSPro route | PASS | HTTP 307 to generic sign-in with encoded callback |
| SeasonPro module root | PASS | HTTP 307 to `/auth/lmspro/login` |
| SeasonPro protected LMSPro route | PASS | HTTP 307 to module login with encoded callback |
| Platform login surface | PASS | HTTP 200 with Platform Administration sign-in content |
| SeasonPro login surface | PASS | HTTP 200 with the expected SeasonPro sign-in content |
| Signed-out session endpoint | PASS | HTTP 200 with `null`; no session data exposed |
| Malformed percent-encoded bearer value | PASS | HTTP 200; no unhandled exception or 500 |
| Private content before redirect | PASS at HTTP boundary | Protected responses redirect without private page content |

Authenticated/browser result:

- section 4: NOT RUN;
- section 5: NOT RUN;
- section 6 items 1 to 3: NOT RUN; and
- browser-console inspection: NOT RUN.

Reason: this execution environment has no designated staging account credentials and no
interactive authenticated browser session. No account was created, password reset, cookie
fabricated or database mutated to manufacture access.

Disposition: **PARTIAL / PRODUCTION HOLD**. The exact staging deployment and signed-out security
boundary pass. The schedule remains open until an authorised tester records the P1, tenant
owner/admin, LMSPro C1, LMSPro C2 and FUND results.
