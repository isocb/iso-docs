# CR Input - FUND C2 Organisation Scope Clarification

Date: 2026-06-25

Status: CR input / architecture clarification

## Source Context

This clarification was raised after Slice 1P-D had already implemented the first read-only C2 organiser dashboard UI.

Current implemented C2 model:

```text
User -> FundProjectParticipant -> FundProject
```

This model safely provides participant-scoped Project visibility.

## Observation

The participant-scoped implementation is safe as an interim dashboard, but it may be too narrow if treated as the final FUND C2 operating model.

The wider IsoStack / SeasonPro-aligned model likely needs an explicit C2 operating organisation/account layer.

Examples:

```text
SeasonPro:
C1 League Tenant
-> C2 Club
-> Teams
-> Club users

FUND:
C1 Producer/Admin Tenant
-> C2 Fundraising Organisation / School / Club / PTA / Customer Account
-> Projects
-> C2 users
-> future Project sales/orders/reporting

Integrated SeasonPro + FUND:
C1 League Tenant
-> C2 Club
-> Teams
-> Club users
-> Fundraising Projects
-> future Project sales/orders/reporting
```

In integrated SeasonPro + FUND, the fundraising Project creator/node will often be the Club. In standalone FUND, the equivalent C2 organisation may be a School, PTA, charity branch, sports club or fundraising customer account.

## Architecture Question

Should FUND continue with direct `FundProjectParticipant` access as the main C2 access model, or should the next C2 slices introduce a C2 organisation/account layer before dashboard expansion?

Options to triage:

- Option A: Continue with direct `FundProjectParticipant` access as the MVP model.
- Option B: Introduce a FUND-specific C2 organisation/account model.
- Option C: Plan a reusable IsoStack C2 organisation/account model that SeasonPro and FUND can both use.
- Option D: Use a hybrid model where C2 organisation owns Projects and `FundProjectParticipant` remains for named contacts, overrides, temporary access bridging or finer-grained exceptions.

## Immediate Recommendation

Do not revert 1P-D automatically.

Treat 1P-D as a safe read-only participant-scoped interim dashboard unless review finds a concrete defect.

Pause further C2 dashboard expansion before adding:

- C2 mutations;
- participant management UI;
- invitations;
- Project Request/onboarding;
- sales/reporting;
- Stores;
- Orders;
- Commerce Core;
- organiser/customer account write flows.

## Follow-Up Documents

Decision planning:

```text
03-slice-planning/2026-06-25-fund-phase-1-slice-1p-d0-c2-organisation-scope-clarification.md
```

Review/scope note:

```text
05-review-and-test/2026-06-25-phase-1-slice-1p-d-r1-c2-dashboard-ui-review-and-c2-organisation-scope-note.md
```
