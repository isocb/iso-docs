# FUND Phase 1 Main Live Alignment Confirmation And Smoke Checklist

Date: 2026-06-29

Status: Live alignment checklist

## Summary

FUND Phase 1 work through 1P-G-C-R1 is a suitable live-alignment candidate.

Staging has been deployed and smoke tested successfully. Pre-existing staging data loads correctly and no remedial work is required at this stage.

## App Alignment

Previous main baseline:

```text
62b727e chore(release): promote FUND C1 admin foundation
```

Live alignment target:

```text
aac38c1 fix(fund): polish c1 dashboard cards
```

Included app commits since the previous main baseline:

```text
90325c1 fix(fund): close c1 admin remediation review fixes
298c22a feat(fund): add c2 project participant schema
ce65830 fix(platform): consolidate issue module field
69a9632 feat(fund): add c2 organiser project reads
f43d63b feat(fund): add c2 organiser dashboard
da6fd0f feat(fund): add c1 client management
536c947 feat(fund): add project client linkage
59d3010 feat(fund): add project intake schema foundation
aac38c1 fix(fund): polish c1 dashboard cards
```

## Migration Note

The live deployment should run Prisma migrations through the established Render deployment workflow.

Confirm in Render logs that:

```text
prisma migrate deploy
```

completed successfully, including:

```text
20260629120000_add_fund_project_intake
```

No local `db:push`, seed or reset commands should be used for this release confirmation.

## Live Smoke Checklist

After Render deploys `main`, confirm:

1. Render live deployment completes successfully for `aac38c1`.
2. Render logs show Prisma migrations completed successfully.
3. Live `/api/health` returns 200.
4. Login works for a C1/FUND admin user.
5. `/app/fund` loads.
6. FUND dashboard cards read `Clients`, `Events`, `Projects` and `Products`.
7. FUND dashboard card icons sit before their titles and hover feedback is subtle.
8. `/app/fund/clients` loads and existing Client data is visible.
9. `/app/fund/clients/[id]` loads for a representative Client.
10. `/app/fund/projects` loads and existing Projects are visible.
11. `/app/fund/projects/[id]` loads for a representative Project.
12. Project Client linkage displays correctly where data exists.
13. `/app/fund/events` and `/app/fund/events/[id]` load.
14. `/app/fund/products` loads.
15. Product/Catalogue admin remains usable.
16. Project Product membership remains usable.
17. Project/Event linkage remains usable.
18. Pre-existing data loads correctly.
19. No public Project Intake form UI is visible.
20. No Store, Orders, Commerce, notifications, Client users, invitations or SeasonPro integration surfaces appear.
21. SeasonPro/LMSPro critical routes still load.
22. Issue Manager still loads.
23. Render logs show no new server errors after smoke testing.

## Hold / Rollback Criteria

Hold or roll back if any of the following occur:

- Render build or deploy fails.
- Prisma migration fails.
- Login fails.
- `/app/fund` or core FUND C1 routes fail.
- Existing Clients, Projects, Events or Products fail to load.
- Critical SeasonPro/LMSPro routes fail.
- Unexpected public intake, commerce, notifications, invitation or user-provisioning UI appears.

## Out Of Scope

This alignment does not implement:

- Project Intake routers, services or public forms.
- Client users or invitations.
- Notification sending.
- Store, Orders or Commerce.
- SeasonPro integration.
- Public Project Request flows.

## Recommendation

Proceed with main alignment to `aac38c1`, then complete the live smoke checklist above.

If the live smoke checklist passes, treat `main`, `dev`, `staging` and `feature/fund-phase-1-c2-project-access` as aligned at the accepted Phase 1 baseline through 1P-G-C-R1.
