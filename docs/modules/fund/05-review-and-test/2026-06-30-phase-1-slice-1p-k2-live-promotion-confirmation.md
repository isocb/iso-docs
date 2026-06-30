# FUND Phase 1 Slice 1P-K2 - Live Promotion Confirmation

## 1. Promotion

K2 Client dashboard work was promoted from staging to live/main.

Promoted app commit:

```text
bb50bc6 fix(fund): allow c2 client dashboard route
```

Promotion path:

```text
dev
-> origin/dev
-> staging
-> origin/staging
-> main
-> origin/main
```

## 2. Included Work

The promoted live build includes:

- Client member schema foundation;
- C1 Client member management and platform User link/create service;
- C2 Client member auth routing/access policy;
- C2 Client dashboard API/services;
- C2 Client dashboard UI;
- C2 Projects page;
- C2 Project create/edit UI;
- C2 Project detail page with Details, Products and Orders tabs;
- Products and Orders placeholder-only boundaries;
- middleware fix allowing `/app/fund/client` and child routes for C2 Client members.

## 3. Staging / Pre-Live Review Basis

Pre-live review basis:

- K2-C review documented localhost/browser smoke test success after routing-loop remediation;
- dashboard access confirmed for a C2 user;
- planned Client dashboard functions confirmed working as expected;
- route loop between `/app/fund/client` and `/app/fund/client-unavailable` was fixed before live promotion;
- staging and dev were aligned at the promoted commit before main/live promotion.

## 4. Boundaries Confirmed

The promoted work does not implement:

- Store;
- Orders;
- Commerce;
- Product membership selection in the C2 dashboard;
- Product/Catalogue suitability implementation;
- notifications;
- invitations;
- email sending;
- production/dispatch;
- commission.

Products and Orders tabs remain placeholders only.

## 5. Live Smoke Checklist

Recommended live smoke checks:

- sign in as a C2 Client member;
- confirm post-login routing reaches `/app/fund/client`;
- confirm `/app/fund/client-unavailable` redirects to `/app/fund/client`;
- confirm Client dashboard renders;
- confirm Projects page renders;
- create a draft Client-owned Project;
- edit safe Project basics;
- row click to Project detail;
- confirm Details tab renders;
- confirm Products tab is placeholder only;
- confirm Orders tab is placeholder only;
- confirm C2 user cannot access C1 admin routes such as `/app/fund/clients` or `/app/fund/projects`.

## 6. Result

Live/main promotion completed.

Further remediation, if found in live smoke testing, should be recorded as a focused K2 remediation slice.

## 7. Next Core Planning Phase

Proceed to:

```text
1Q-A - Product/Catalogue Suitability Schema Options Planning
```

This is the next core Product Manager planning phase before Store/Orders/Commerce and production workflows.
