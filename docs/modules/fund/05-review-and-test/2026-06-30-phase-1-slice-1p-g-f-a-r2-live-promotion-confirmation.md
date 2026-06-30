# FUND Phase 1 Slice 1P-G-F-A-R2 - Live Promotion Confirmation

Date: 2026-06-30

## Promotion Scope

Promote the public Project initiation remediation from staging to live.

App commit:

```text
b1ee0fd fix(fund): remediate public project initiation form
```

Included scope:

- public `/fund/project-initiation/*` route access;
- standalone public Project initiation route outside the generic IsoStack marketing shell;
- Event-scoped Project Start and Project Closing Date defaults/constraints;
- standalone Project Start and Project Closing Date requirement;
- bounded allowed organisation type selection in C1 form create/edit;
- server-side validation for Event-scoped dates and allowed organisation type;
- preservation of moderation-first public intake behaviour.

## Smoke Test Result

Local browser smoke testing and staging browser smoke testing were completed by the product owner.

Result:

```text
No major blockers found.
```

Remaining remedial observations are suitable for a batched CR and should not block this live promotion.

## Branch Alignment Target

After promotion:

```text
main    = b1ee0fd
dev     = b1ee0fd
staging = b1ee0fd
```

## Explicit Out Of Scope Confirmation

This promotion does not include:

- schema changes;
- migrations;
- public embed route or iframe allowlist;
- Event media/image schema;
- Event type/category option-set implementation;
- Client organisation type option-set implementation beyond the bounded current choices;
- Client users/members;
- invitations;
- editable notification defaults;
- broader workflow notifications;
- Store, Orders, Commerce, Sales/Reporting;
- production, dispatch or fulfilment;
- SeasonPro integration.

## Post-Live Smoke Checklist

After live deployment, confirm:

- live `/fund/project-initiation/[formSlug]` loads unauthenticated;
- public page has no generic IsoStack marketing navigation;
- missing/inactive public form slug returns a safe unavailable state;
- Event-scoped form displays Event context and date defaults;
- C1 `/app/fund/project-intake` remains authenticated/admin-only;
- C1 Project Intake form create/edit remains usable;
- no unexpected workflow email is sent beyond the bounded confirmation/authentication exception;
- no Store, Orders, Commerce, Client user/member, invitation or broader notification surface appears.

## Follow-Up

Capture non-blocking remedial observations through a CR and convert them into a batch remediation planning slice.

Likely follow-up areas:

- public form polish;
- Event media and branding refinement;
- Event type/category option-set planning;
- Client organisation type option-set planning;
- public embed route/CSP planning;
- notification/default email management planning.
