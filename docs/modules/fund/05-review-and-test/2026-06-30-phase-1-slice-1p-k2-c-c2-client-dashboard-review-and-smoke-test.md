# FUND Phase 1 Slice 1P-K2-C - C2 Client Dashboard Review And Smoke Test

## 1. Slice

```text
1P-K2-C - C2 Client Dashboard Review And Smoke Testing
```

## 2. Review Scope

Reviewed the K2-A/K2-B Client dashboard work:

- C2 Client member authentication routing;
- C2 dashboard accessibility;
- C2/C1 route separation;
- Projects page;
- Project create/edit UI;
- row click to Project detail;
- Project detail tabs;
- Products and Orders placeholder boundaries.

## 3. Smoke Test Result

Browser smoke testing on localhost confirmed:

- C2 user can log in;
- `/app/fund/client` is accessible;
- Client dashboard loads as expected;
- planned Client dashboard functions are visible and working as expected;
- Project create/edit surfaces are present;
- Project detail tabs are present;
- Products and Orders remain placeholders;
- the UI presentation is suitable for the current Client dashboard slice.

User smoke-test note:

```text
The dashboard is accessible and planned functions are working as expected and looking great.
```

## 4. Routing Issue Found

Initial smoke testing found a redirect loop:

```text
/app/fund/client
-> middleware classified the route as unavailable for C2
-> /app/fund/client-unavailable
-> compatibility redirect back to /app/fund/client
-> loop
```

Root cause:

```text
src/middleware.ts still allowed only the old /app/fund/client-unavailable C2 placeholder route.
```

## 5. Routing Fix Applied

The fix:

- allows `/app/fund/client`;
- allows `/app/fund/client/...`;
- keeps `/app/fund/client-unavailable` as a compatibility redirect;
- redirects recognised C2 Client members from `/app/fund/client-unavailable` to `/app/fund/client`;
- continues to block C2 Client members from C1 admin routes:
  - `/app/fund`;
  - `/app/fund/projects`;
  - `/app/fund/clients`;
  - other C1 FUND admin surfaces.

Files changed for the fix:

- `src/middleware.ts`;
- `src/app/(app)/app/fund/client-unavailable/page.tsx`.

## 6. Boundary Confirmation

Confirmed still out of scope:

- Store;
- Orders;
- Commerce;
- Product membership;
- Product/Catalogue suitability;
- notifications;
- invitations;
- email sending;
- C1 admin UI changes;
- schema changes;
- migrations.

Products and Orders tabs remain placeholder-only surfaces.

## 7. Checks

Checks run after the routing fix:

```text
npm run type-check
git diff --check
```

Result:

```text
Passed.
```

## 8. Review Outcome

K2-C review outcome:

```text
Pass after routing-loop remediation.
```

The Client dashboard is suitable for continued staging smoke testing.

## 9. Recommended Next Step

Continue staging smoke testing of:

- C2 login to `/app/fund/client`;
- C2 Projects list;
- Project create;
- Project edit;
- row click to Project detail;
- Products/Orders placeholder boundaries;
- C2 denial from C1 admin FUND routes.
