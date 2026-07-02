# FUND Roadmap And Slice Control

Date: 2026-06-25

Status: Active control document

Purpose:

```text
Provide one current roadmap and slice-control view so future FUND work does not depend on reconstructing context from many individual slice documents.
```

This document is planning/documentation only. It does not implement code, change Prisma schema, create migrations, run deployment commands or start new feature work.

## 1. Current Released Baseline

The FUND Phase 1 baseline has moved beyond 1P-G-C-R1. The current released/live baseline is through the 1P-K2 Client dashboard route fix.

Current released app baseline:

```text
bb50bc6 fix(fund): allow c2 client dashboard route
```

Current remote branch alignment after 1P-K2 live promotion:

```text
main    = bb50bc6 accepted FUND Phase 1 baseline through 1P-K2 route fix
dev     = bb50bc6 accepted FUND Phase 1 baseline through 1P-K2 route fix
staging = bb50bc6 accepted FUND Phase 1 baseline through 1P-K2 route fix
```

Release result:

- FUND Phase 1 baseline through 1P-K2 is aligned to `main`.
- SeasonPro/LMSPro export hotfix is included in the released baseline.
- Staging browser testing found no blocking C1 admin foundation issues before release alignment.
- FUND remains expected to need refinement; the baseline is accepted as the foundation, not as final product polish.
- 1P-R1/1P-R1A remediation, 1P-B schema work and 1P-C read-only organiser Project API/services were aligned to `staging` at `69a9632`.
- 1P-D read-only organiser dashboard UI has been implemented on `feature/fund-phase-1-c2-project-access` at `f43d63b`, reviewed with caveats and aligned to `dev` and `staging`.
- 1P-D staging alignment was pushed by operator request; Render deployment and migration confirmation remain post-deploy checks.
- A post-1P-D C2 organisation/account scope clarification has been raised. The current participant-scoped dashboard remains safe but should be treated as an interim bridge until this is decided.
- Additional correction: C2 is the Project management node, not a passive/read-only recipient of Project information. Future C2 dashboard work must be Client/account scoped, not merely participant scoped.
- AMOW founding-tenant priority has been re-centred on the C1 organisational dashboard: C1 Client management, Products, Events, Projects and the operational framework for managing fundraising Clients and their Projects.
- 1P-D remains technically safe but is not the immediate AMOW product priority.
- 1P-F-C C1 Client Management schema has been implemented and aligned to `dev`/`staging` as part of `da6fd0f`.
- 1P-F-D C1 Client Management API/services has been implemented and aligned to `dev`/`staging` as part of `da6fd0f`.
- 1P-F-E C1 Client Management UI has been implemented, reviewed with caveats and aligned to `dev`/`staging` as part of `da6fd0f`.
- Client is the C2 organisation/account concept. Primary contact fields on `FundClient` are C1 operational contact snapshots only, not the final Client user/member model.
- Client users/members, roles, invitations and notification boundaries require a future planning slice before implementation.
- Client organisation details, structured physical addresses, delivery/fulfilment defaults and Project-level delivery snapshots/overrides require future planning before Store, Orders, Production or Dispatch.
- Existing Client dashboard Project initiation must use trusted Client route, token or authenticated context and should auto-scope requests or Projects to the authenticated Client/account. It must not infer Client ownership from organiser snapshot fields, respondent email alone, proposed Client contact fields alone or user-editable hidden fields.
- 1P-H Project Client selector/linkage planning is complete. 1P-H-A API/services and 1P-H-B UI are committed on `feature/fund-phase-1-c2-project-access` at `536c947` and aligned to `dev`/`staging`.
- 1P-H-C static/code review and authenticated staging browser smoke testing passed. No remedial work is required at this stage.
- 1P-G-A Project Intake Schema And Moderation Model planning is complete. Project Intake remains moderation-first: submissions must not directly create Clients, Client users, Projects, Event links, notifications or invitations.
- 1P-G-B Project Intake Schema Options planning is complete and has led into 1P-G-C schema-only implementation.
- 1P-G-C Project Intake schema-only implementation and 1P-G-C-R1 schema review are complete. Staging deployment/smoke testing passed; pre-existing data loads correctly and no remedial work is required at this stage.
- 1P-G-D0 Client-Scoped Project Initiation And Idempotency planning is complete. Unknown/public intake and new Client onboarding remain moderation-first. Existing authenticated C2 Client users with the correct future Client role/permission create Client-owned Projects directly under `FundProject.clientId` from trusted Client/account context. C1 is the FUND producer tenant/supplier/fulfilment operator, not the default approver of Project existence. Later activation, Store, Commerce, production, dispatch and notification gates may still require C1 approval or separate policy.
- Implementation priority after 1P-G-D0 is the moderated Project initiation form and C1 approval services. Authenticated Client dashboard direct Project creation remains a later Client dashboard / role-permission lane.
- 1P-G-D Project Intake Moderation API/Services planning is complete. The recommended implementation split starts with C1 Project Intake Form API/services, then C1 submission review services, then explicit approval-action planning.
- 1P-G-D1 C1 Project Intake Form API/Services has been implemented. It adds C1 admin form list/get/create/update/activate/pause/archive/restore only.
- 1P-G-D2 C1 Project Intake Submission Review API/Services has been implemented. It adds confirmed-submission queue/detail/review/status services only.
- 1P-G-D3 Project Intake Approval Action Planning is complete. It defines explicit C1 approval actions and records the future C1 approval summary card with row click-through to a dedicated approval page.
- 1P-G-D3-A Project Intake Approval API/Services has been implemented. It adds explicit C1 approval procedures for creating/linking C2 Client organisations and Projects from reviewed submissions.
- 1P-G-D3-A-R1 Project Intake Approval API/Services Review is complete. Verdict: proceed with caveats; no blocking defects were found, but return-to-review status policy and authenticated API smoke testing remain follow-ups before approval UI implementation.
- 1P-G-E C1 Project Intake Moderation And Approval UI has been implemented. It adds the C1 Project Intake dashboard action card, moderation landing page, form admin pages, submission detail/review page and explicit approval page.
- 1P-G-E-R1 C1 Project Intake Moderation And Approval UI Review is complete. Verdict: proceed; authenticated browser smoke testing on dev passed with no remedial work requested before staging promotion.
- 1P-G-F Public Project Initiation Form UI Planning is initiated. It plans the public/client-facing multi-step Project initiation form UI and preserves the moderation-first boundary.
- General email content, trigger behaviour, default recipients and pause/resume controls for FUND must be handled through a dedicated communications/notifications UI, following the SeasonPro/LMSPro communications Notifications tab precedent. Project Intake implementation slices should use placeholder trigger annotations, except that email required for authentication or confirmation steps may use bounded hard-coded transactional copy until the notification lane exists.
- The first visible Project initiation form should use trusted branding/letterhead/footer fallback: trusted Client/tenant branding, then FUND module branding, then IsoStack/platform branding. It should use client-facing sections for Project basics, organisation details and main organiser details. It should include "What kind of fundraising project would you like to run?" with options for artwork fundraising, group personalised products, bulk order / club-funded projects and "not sure yet". It should not ask whether a Store is required.
- Project Intake forms may be general or Event-scoped. Event-scoped forms use the trusted C1 form definition `FundProjectIntakeForm.defaultEventId`; public respondents must not choose or spoof internal Event linkage through editable fields. Approved Projects remain C2 Client-owned through `FundProject.clientId` and may link to the scoped C1 Event.
- C1 Project Intake form admin must expose Default Event selection for Event-scoped forms and provide a clear copy/open public link affordance for `/fund/project-initiation/[formSlug]` to support testing and tenant operation.
- 1P-G-F-A-R1 staging security/pre-live review found staging healthy and C1 Project Intake admin protected, but the intended public Project initiation route `/fund/project-initiation/*` currently redirects unauthenticated users to sign-in. This is safe but blocks the intended public workflow.
- 1P-G-F-A-R2 planning records the required remediation before live promotion: public route allowlisting, vanilla public page without IsoStack marketing navigation, Event-scoped form constraints from trusted `FundProjectIntakeForm.defaultEventId`, Project start/closing date fields and validation, aligned date/time picker usage, bounded allowed Client/organisation type selection and form-field helper text alignment.
- 1P-G-F-A-R2-A implemented the public route and Event-scoped form remediation: `/fund/project-initiation/*` is intentionally public, public pages no longer inherit the generic IsoStack marketing navigation, Event-scoped forms default/constrain Project dates from the linked Event, general forms require Project start/closing dates, and allowed organisation types are bounded in C1 form create/edit and public submission validation.
- 1P-G-F-A-R2-B staging smoke/security review passed with no major blockers. Remaining remedial observations should be captured through a CR and planned as a batch remediation slice rather than blocking live promotion.
- 1P-G-F-A-R2 live promotion target is `b1ee0fd`, aligning `main`, `dev` and `staging` to the public Project initiation remediation.
- Phase 2 refinement wishlist control has been created at `00-roadmap-control/2026-06-30-fund-phase-2-refinement-wishlist-and-slice-control.md`. Use it to park desirable but non-blocking refinements such as Event media/branding, Event type option sets, Client organisation type option sets, embed route/CSP planning, action-widget polish and communications defaults without interrupting Phase 1 structural momentum.
- 1P-K0 Client Dashboard And Client-Owned Project Lifecycle Planning is initiated as the next core planning lane after public Project initiation remediation review. The Client dashboard should allow authenticated C2 Client users to monitor their Projects, create directly Client-owned Projects from trusted Client context, select available live Events or standalone Project creation where allowed, and download Project templates/resources. Sales monitoring is a future dashboard purpose but depends on Store/Orders/Commerce. Communications/announcements and commission payment management are wishlist/future surfaces, not first implementation scope.
- 1P-K1 Client User/Member Access Model And C1 Management Planning is initiated as the practical bridge before the C2 Client dashboard. C1 Client detail should evolve into top-level tabs for Client Details, Projects and Users. The Projects tab should show linked Projects with search/filter/sort and row click to Project detail. The Users tab should allow C1 to manage Client users/members who may later access FUND as C2 users, but onboarding/access email remains a manual operational step until the dedicated 1P-N0 notification/email lane is accepted.
- 1P-K1-A Client User/Member Schema Options Planning recommends a small FUND-specific `FundClientMember` model rather than reusing Project participants or platform Users alone. The model should be tenant-scoped, Client-scoped, optionally linked to a platform `User`, and should separate role labels from access permissions. Schema implementation is the next bounded step, with no automatic email, invitations, C2 dashboard UI or Client-owned Project creation.
- 1P-K1-E Client User/Member Management review confirms the C1 Client detail tabs and member creation/editing work in browser smoke testing after the dev database migration was applied. Client member login/onboarding is not implemented yet; attempted login currently reaches an auth configuration error rather than a C2 Client dashboard, which is expected for K1-B/C/D but must be planned before K2.
- 1P-K1-F Client Member Login/Onboarding And Auth Routing Planning is required before K2. It must define platform User link/create policy, magic-link/manual onboarding boundary, post-auth routing, safe unavailable states and the rule that C2 Client users must not be routed to `/platform`, P1 or C1 dashboards by default.
- 1P-K2 C2 Client Dashboard And Client-Owned Project Management Planning is initiated. K2 should replace the temporary Client unavailable state with the first authenticated C2 dashboard: Client context, Projects list, Client-owned Project create/edit basics, row click to Project detail and Details/Products/Orders tabs. Client-created Projects should capture the same Project type / fundraising format option used by the public Project initiation form so later Product/Catalogue suitability can constrain selectable Products. Products and Orders are placeholders only until Product availability and Store/Orders/Commerce planning is accepted.
- 1P-K2-B C2 Client Dashboard UI is implemented on top of K2-A services. It adds `/app/fund/client`, `/app/fund/client/projects` and `/app/fund/client/projects/[id]`, replaces the temporary C2 unavailable redirect, hides the C1 tenant admin sidebar on FUND Client routes, and keeps Products/Orders as placeholders only pending later Product and Commerce planning.
- 1P-K2 live promotion completed at `bb50bc6`. K2-C review records successful C2 dashboard smoke testing after the middleware route-loop fix. Live smoke should confirm C2 access to `/app/fund/client`, Project create/edit, Project detail row click and C2 denial from C1 admin routes.
- 1Q-A Product/Catalogue Suitability Schema Options Planning is complete.
- 1Q-B Event/Catalogue Availability Schema Implementation is complete as schema foundation.
- 1Q-C C1 Event Catalogue Availability API/Services is implemented in app commit `2bb8db3`.
- 1Q-D C1 Event Catalogue Availability UI is implemented in app commit `28662af` and documented in `04-implementation-confirmations` and `05-review-and-test`.
- 1Q-D-R1 review/test is accepted as passed: static checks, targeted ESLint, `git diff --check`, `npm run type-check`, `npm run verify`, route smoke and operator-confirmed authenticated C1 browser smoke are accepted. Detailed UI/UX revisions are deferred to refinement.
- 1Q-E Project Product Eligibility API/Services planning is created at `03-slice-planning/2026-07-01-fund-phase-1-slice-1q-e-project-product-eligibility-api-services-planning.md`.
- 1Q-E Project Product Eligibility API/Services is implemented and promoted to `origin/dev` / `origin/staging` at app commit `7a7354a`; implementation confirmation is created at `04-implementation-confirmations/2026-07-01-phase-1-slice-1q-e-project-product-eligibility-api-services-confirmation.md`.
- 1Q-E-R1 Project Product Eligibility API/Services Review And Smoke Test is accepted as passed: static checks, type-check, targeted ESLint, `npm run verify`, `git diff --check` and transaction-scoped API/service smoke are documented in `05-review-and-test/2026-07-01-phase-1-slice-1q-e-r1-project-product-eligibility-api-services-review-and-smoke-test.md`.
- 1Q-F Catalogue-Centric Project Product Picker UI planning is created at `03-slice-planning/2026-07-01-fund-phase-1-slice-1q-f-catalogue-centric-project-product-picker-ui-planning.md`.
- Current Product/Catalogue suitability stage is ready for 1Q-F Catalogue-Centric Project Product Picker UI Remediation.
- Recommended major core sequence after K2 remains: Product/Catalogue suitability, then Store/Orders/Commerce core planning, then C1 production/dispatch/commission implementation planning.
- 1P-G-C2-A Project Intake Email Confirmation Schema Addendum is implemented as schema-only work. It adds `CONFIRMATION_PENDING`, confirmation token/hash expiry fields, confirmation/submitted timestamps and idempotency/fingerprint fields so future public form services can separate unconfirmed records from actionable C1 moderation submissions.
- 1P-K2 live/main alignment target was `bb50bc6`; K2 live promotion is confirmed in `05-review-and-test/2026-06-30-phase-1-slice-1p-k2-live-promotion-confirmation.md`.
- Future Client dashboard is not merely passive Project display. It is expected to become the Client Project initiation, engagement, announcements, special offers/campaign prompts, 1:1 communication and dashboard-visible communications surface.
- C1 dashboard is the Project administration, artwork checking, production grouping, dispatch/fulfilment and commission workflow surface.
- Store, Orders and Commerce must align with the future Client dashboard and C1 production/admin workflow surfaces rather than proceeding as isolated features.
- 1P-I C1 Production, Dispatch And Commission Workflow planning note is created to protect production/admin design before Store/Commerce implementation.
- 1P-J SeasonPro Club to FUND Project Initiation planning placeholder is created to preserve the future Club-originated intake path without implementing SeasonPro integration.
- Project Intake and Commerce must not proceed as isolated features without preserving the future Client dashboard engagement surface and C1 production/admin workflow surface.
- Project Intake / Project Request forms are a future critical lane. C1-created forms may eventually collect external or Client-originated Project requests and, after C1 moderation, create or link Client/account, C2 user/member, Project and Event records.
- SeasonPro Club-originated Project initiation is a future intake path. It depends on SeasonPro League FUND/Fundraising module entitlement, League configuration of approved FUND producer tenant(s), catalogue availability to Clubs, sale method planning and explicit Club-to-FUND Client/account mapping.
- Notification management remains deferred. Project intake, Client creation, C2 user creation and Project approval must not accidentally send notifications until controlled communications are explicitly planned.
- Staging `/api/health` returned HTTP 200 after alignment.
- Current app refs after 1Q-E promotion for staging test: local `dev`, `origin/dev`, local `staging` and `origin/staging` are aligned at `7a7354a`.
- Docs repo local `main` includes the Finder metadata cleanup commit `76841d1`, 1Q planning/refinement commit `ab15470` and 1Q-E implementation confirmation commit `f582c3e`; this roadmap update, 1Q-E confirmation clarification and 1Q-E-R1 review document should be committed with the next docs checkpoint.

## 2. Current Branch Landscape

### Release Branches

```text
main
dev
staging
```

Current state:

```text
origin/main    live baseline at bb50bc6
origin/staging 1Q-E Project Product Eligibility API/Services at 7a7354a
origin/dev     aligned with local dev at 7a7354a
local dev      aligned with origin/dev at 7a7354a
```

Use:

- `main` is the live/release baseline through accepted 1P-K2 work.
- `staging` carries the 1Q-E Project Product Eligibility API/Services at `7a7354a` for staging test.
- local `dev` is aligned with `origin/dev` at `7a7354a`.
- If the app checkout is on `staging`, switch to `dev` before implementing 1Q-F.

### Active FUND Working Branch

```text
dev
```

Purpose:

- FUND Product/Catalogue suitability 1Q work.
- Local implementation and verification before staging/live promotion.
- Current next slice: 1Q-F Catalogue-Centric Project Product Picker UI Remediation.
- Follow-on readiness slice after 1Q-F passes: 1Q-G Availability Review And Store/Commerce Readiness Check.

### Historical FUND Feature Branch

```text
feature/fund-phase-1-c2-project-access
```

Purpose:

- Historical FUND C2 organiser/client access and Project Intake work.
- No longer the current Product/Catalogue suitability working lane.

This branch should not absorb unrelated SeasonPro remediation unless intentionally cherry-picked.

### Active SeasonPro Remediation Branch

```text
feature/seasonpro-remediation
```

Purpose:

- SeasonPro/LMSPro fixes that should be testable/promotable without carrying unfinished FUND work.

This branch exists so SeasonPro remediation can move independently of future FUND C2 development.

### Retired / Historical FUND Feature Branch

```text
feature/fund-phase-1-products-catalogues
```

Purpose:

- Historical branch used for the C1 admin foundation.
- It has been promoted into the release baseline.

Recommendation:

```text
Do not continue new work on this branch.
```

## 3. Completed C1 Admin Foundation Slices

The completed C1 foundation is documented across planning and implementation confirmation files in:

```text
isodocs/docs/modules/fund/Planning/
isodocs/docs/modules/fund/implementation/
```

### Completed Slice Summary

| Slice | Area | Status |
| --- | --- | --- |
| 1C | Product Workflow Classes | Complete |
| 1D | Products/Catalogues schema | Complete |
| 1E | Products/Catalogues API/services | Complete |
| 1F-A | Products/Catalogues core admin UI | Complete |
| 1F-B | Catalogue Product membership manager | Complete |
| 1G | Products/Catalogues review/remediation | Complete |
| 1H | Project schema | Complete |
| 1I | Project API/services | Complete |
| 1J-A | Project list and child management shell | Complete |
| 1J-B | Project Product membership manager | Complete |
| 1K | Project admin UI review/manual testing | Complete |
| 1L-A | FundEvent schema | Complete |
| 1L-B | FundEvent API/services | Complete |
| 1L-C | FundEvent API/manual review | Complete |
| 1M-A | FundEvent admin UI | Complete |
| 1M-B | Project Event selector/linkage UI | Complete |
| 1M-C | Project/Event linkage UI review | Complete |
| 1N | C1 admin foundation authenticated review | Complete |
| 1O | C1 admin foundation staging readiness/release alignment | Complete |
| 1P-A | C2 Project Access Model Planning | Complete |
| 1P-B | C2 Project Participant Schema | Complete / aligned to dev+staging |
| 1P-C | C2 Read-Only Project API/Services | Complete / reviewed / aligned to dev+staging |
| 1P-C-R1 | C2 Read-Only Project API/Services Review | Complete / proceed with caveats |
| 1P-D | C2 Read-Only Organiser Dashboard UI | Implemented / reviewed with caveats |
| 1P-D-R1 | C2 Dashboard UI Review And C2 Organisation Scope Note | Complete / proceed with caveats |
| 1P-D0 | C2 Organisation Scope Clarification | Active planning clarification |
| 1P-F | C2 Client/Account Organisation Model Planning | Active architecture planning |
| 1P-F-CORR | C2 Client/Account As Project Management Node Planning | Active architecture correction |
| 1P-F-A | C1 Client Management Foundation For AMOW | Planning complete |
| 1P-F-B | C1 Client Management Schema Options | Planning complete |
| 1P-F-C | C1 Client Management Schema | Implemented / aligned to dev+staging |
| 1P-F-D | C1 Client Management API/Services | Implemented / aligned to dev+staging |
| 1P-F-E | C1 Client Management UI | Implemented / reviewed with caveats / aligned to dev+staging |
| 1P-F-F | Client Organisation Details, Users, Roles And Notification Planning | Future planning note created |
| 1P-H | Project Client Selector And Linkage Planning | Planning complete |
| 1P-H-A | Project Client Linkage API/Services | Implemented / aligned to dev+staging |
| 1P-H-B | Project Client Selector UI | Implemented / aligned to dev+staging |
| 1P-H-C | Project Client Linkage UI Review | Complete / accepted |
| 1P-G-A | Project Intake Schema And Moderation Model Planning | Planning complete |
| 1P-G-B | Project Intake Schema Options Planning | Planning complete |
| 1P-G-C | Project Intake Schema | Implemented / reviewed / accepted |
| 1P-G-C2-A | Project Intake Email Confirmation Schema Addendum | Implemented schema-only |
| 1P-G-D0 | Client-Scoped Project Initiation And Idempotency Planning | Planning complete |
| 1P-G-D | Project Intake Moderation API/Services Planning | Planning complete |
| 1P-G-D1 | C1 Project Intake Form API/Services | Implemented |
| 1P-G-D2 | C1 Project Intake Submission Review API/Services | Implemented |
| 1P-G-D3 | Project Intake Approval Action Planning | Planning complete |
| 1P-G-D3-A | Project Intake Approval API/Services | Implemented |
| 1P-G-D3-A-R1 | Project Intake Approval API/Services Review | Complete / proceed with caveats |
| 1P-G-E | C1 Project Intake Moderation And Approval UI | Implemented / reviewed / staging candidate |
| 1P-G-E-R1 | C1 Project Intake Moderation And Approval UI Review | Complete / proceed |
| 1P-G-F | Public Project Initiation Form UI Planning | Planning initiated |
| 1P-N0 | FUND System Notifications And Editable Email Defaults Planning | Future planning lane |
| 1P-I | C1 Production, Dispatch And Commission Workflow Planning | Planning note created |
| 1P-J | SeasonPro Club To FUND Project Initiation Planning | Future planning placeholder created |

### C1 Admin Surfaces Released

Released C1/admin routes include:

```text
/app/fund
/app/fund/products
/app/fund/projects
/app/fund/projects/[id]
/app/fund/events
/app/fund/events/[id]
```

Released C1/admin domains include:

- Products.
- Catalogues.
- Catalogue Product membership.
- Projects.
- Project Product membership.
- Events.
- Project/Event linkage.
- Activation readiness basics.
- FUND module/product allocation foundation.

## 4. Current Remediation Lane

Source triage document:

```text
isodocs/docs/modules/fund/02-triage/2026-06-25-fund-c1-admin-remediation-and-architecture-triage.md
```

Source issue export:

```text
isodocs/docs/modules/fund/01-cr-inputs/change-request-cmqt61xmf000612xt5ifl1mdn-2026-06-25.md
```

### Immediate Remediation

These have been handled at code/static-check level and should receive an authenticated browser spot-check before staging promotion:

1. Issue #46 - Project close date after linked Event close date accepted.
2. Issue #50 - Issue Manager module filtering/server render error.

### Near-Term UI/UX Remediation

These were included because scope remained small:

1. Issue #47 - Adding a Project Product is an activation gate but not intuitive.
2. Issue #44 - Product breadcrumb navigation.
3. Issue #45 - Sidebar icons repeated; update UI guidance.

### 1P-R1A UI Consistency Addendum

An iterative UI consistency addendum was documented retrospectively as:

```text
03-slice-planning/2026-06-25-fund-phase-1-slice-1p-r1a-c1-admin-ui-consistency-remediation.md
04-implementation-confirmations/2026-06-25-phase-1-slice-1p-r1a-c1-admin-ui-consistency-remediation-confirmation.md
```

It covers:

- whole-card FUND dashboard navigation;
- brand/semantic colour use instead of decorative peer-card colours;
- column-header sort/reverse-sort;
- consistent breadcrumbs;
- destination-specific navigation icons;
- Issue Manager `Modules` CRUD field consolidation to match filtering, badges and CR exports.

Historical branch used for this remediation:

```text
feature/fund-phase-1-c2-project-access
```

Recommended remediation principle:

```text
Fix the C1 foundation in place before exposing dependent behaviour to C2 organisers.
```

### C2 Access Lane Status

Current branch state is controlled by section 2. Historical branch state at the earlier C2 planning point was:

```text
feature/fund-phase-1-c2-project-access = historical C2/Project Intake branch
```

Current C2 lane status through K2:

- 1P-A access model planning is complete.
- 1P-B participant schema is implemented.
- 1P-C read-only organiser Project API/services are implemented and reviewed.
- 1P-D read-only organiser dashboard UI is implemented and statically reviewed with caveats.
- 1P-D0 C2 organisation/account scope clarification has been raised and must be decided before C2 expansion.
- 1P-H-A Project Client linkage API/services are implemented, static-check passed and committed.
- 1P-H-B Project Client selector UI is implemented, static-check passed and committed.
- 1P-H-C review and authenticated staging smoke testing are complete and accepted.
- 1P-H alignment status: feature branch, `dev` and `staging` are aligned at `536c947`.
- 1P-G-A Project Intake schema/moderation model planning is complete.
- 1P-G-B Project Intake schema options planning is complete.
- 1P-G-C Project Intake schema-only implementation and 1P-G-C-R1 schema review are complete and accepted.
- 1P-G-D0 Client-scoped Project initiation and idempotency planning is complete.

Staging migration note:

- Render build runs `prisma migrate deploy` through `scripts/render-build.sh`.
- Neon Prisma migrations are expected to happen automatically during Render deployment because the Render build executes `prisma migrate deploy`.
- Direct staging `_prisma_migrations` inspection was not available from the local shell.
- Local shell checks found no Render CLI, no Neon CLI and no exposed staging database environment variable.
- Migration `20260625143000_add_fund_project_participants` exists locally.
- 1P-D staging alignment has been pushed; confirm in Render/Neon that deployment completed and `20260625143000_add_fund_project_participants` has applied before authenticated smoke testing.
- Lightweight staging health check after alignment returned HTTP 200 for `/api/health`.

### Live Issue Status Register

This table is the current compact issue-status view for planning. It should be updated after remediation, review or architecture-planning slices so future planning does not require rereading every triage note.

| Issue | Current Status | Category | Next Action | Blocks C2? | Blocks Store/Commerce? | Current / Suggested Slice |
| --- | --- | --- | --- | --- | --- | --- |
| #46 Project/Event close-date constraint | Remediated in 1P-R1; 1P-R2 static/check review passed | Immediate remediation | Authenticated browser spot-check before staging promotion | No for planning; spot-check before promotion | No, but must remain clean before Store date generation | Browser spot-check / next promotion gate |
| #50 Issue Manager module filtering/server render error | Remediated in 1P-R1; module-field confusion corrected in `ce65830` | Immediate platform remediation | Smoke-test Issue Manager module filter and modal field behaviour on staging | No | No | Staging smoke test |
| #47 Product activation gate visibility | Small UX remediation included in 1P-R1; 1P-R2 static/check review passed | UI/UX polish | Browser spot-check Project Overview affordance | No | No | Browser spot-check / next promotion gate |
| #44 Product breadcrumb navigation | Small UI polish included in 1P-R1/1P-R1A; 1P-R2 static/check review passed | UI polish | Browser spot-check Products, Projects and Events breadcrumbs | No | No | Browser spot-check / next promotion gate |
| #45 Sidebar icons repeated | Small UI polish included in 1P-R1/1P-R1A; 1P-R2 static/check review passed | UI polish | Browser spot-check FUND navigation icons | No | No | Browser spot-check / next promotion gate |
| #48 Events should link to one or more Product Catalogues | Implemented/reviewed through 1Q-E-R1; 1Q-F UI pending | Core architecture implementation | 1Q-B added Event/Catalogue schema, 1Q-C added C1 services, 1Q-D added C1 UI and 1Q-E exposes reviewed Project Product eligibility services. Next: make eligibility visible in the Catalogue-centric Project Product picker. | Yes for Client dashboard Project creation where Event/product selection is exposed until 1Q-F is complete | Yes until 1Q-G readiness review | 1Q-F Catalogue-centric picker UI |
| #49 Product Workflow Class suitability | Implemented/reviewed through 1Q-E-R1; 1Q-F UI pending | Core architecture implementation | 1Q-B added Product suitability schema, 1Q-C added C1 services, 1Q-D added C1 UI and 1Q-E implements the accepted eligibility behaviour, including the locked no-suitability-rows policy. Next: consume eligibility in the Project Product picker. | Yes for Project creation/product selection where Project type constrains Products until 1Q-F is complete | Yes until 1Q-G readiness review | 1Q-F Catalogue-centric picker UI |

Planning rule:

```text
For every new FUND planning slice, read this status register first. Use the detailed triage documents only when the register points to an issue or decision needing background evidence.
```

### CR Handling Rule

Change requests are treated as development inputs, not direct implementation instructions.

Every CR must pass through triage before implementation. If accepted, it receives the same slice planning, implementation confirmation, review/test confirmation and roadmap update sequence as new feature work.

Current CR workflow:

```text
CR input
  -> triage decision
  -> slice planning
  -> implementation confirmation
  -> review/test confirmation
  -> roadmap/control update
```

For the current CR batch:

```text
01-cr-inputs/change-request-cmqt61xmf000612xt5ifl1mdn-2026-06-25.md
  -> 02-triage/2026-06-25-fund-c1-admin-remediation-and-architecture-triage.md
  -> 03-slice-planning/2026-06-25-fund-phase-1-slice-1p-r1-c1-admin-immediate-remediation.md
```

## 5. Current C2 Access-Model Planning Lane

Current C2 planning documents:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-24-fund-phase-1-slice-1p-c2-organiser-dashboard-proposal.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-24-fund-phase-1-slice-1p-a-c2-project-access-model-proposal.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-d0-c2-organisation-scope-clarification.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-c2-client-account-organisation-model-planning.md
```

Recommended model:

```text
IsoStack User for authentication
+ FundProjectParticipant for Project access
+ optional future FundOrganiserProfile for reusable organiser identity/contact history
```

Key decision:

```text
C2 Project access must not derive from organiserName/organiserEmail/organiserPhone snapshot fields.
```

Current C2 recommendation:

- Treat the implemented 1P-D read-only dashboard as a safe participant-scoped interim bridge.
- Treat 1P-D smoke testing as technical validation only, not decisive product validation.
- Decide the C2 organisation/account scope before adding C2 mutations, participant management UI, C2 client/account management UI, C1 Client view, invitations, Project Request/onboarding, sales/order/reporting views, Store or Commerce coupling.
- Do not assume direct `FundProjectParticipant` access is the final C2 operating model.
- Likely long-term direction to evaluate: C2 Client/account owns Projects, C2 users belong to that Client/account, and `FundProjectParticipant` remains for named contacts, overrides, exceptions and transition access.
- 1P-F is the active architecture planning slice for the C2 Client/account organisation model.

### C2 Organisation / Account Scope Clarification

Post-1P-D clarification:

```text
Current interim model:
User -> FundProjectParticipant -> FundProject

Wider likely model:
C1 Producer/Admin Tenant
-> C2 Client / Account / Fundraising Organisation / School / Club / PTA / Customer Account
-> C2 users
-> Projects
-> future Project sales/orders/reporting
```

Important correction:

```text
C2 is the Project management node.
C2 Clients/accounts own and manage Projects.
C2 users operate within the Client/account organisation.
FundProjectParticipant is not the strategic Project ownership model.
```

Client organisation / user clarification:

```text
FundClient = organisation/account.
Client user/member = future login-capable person linked to Client.
User = authenticated platform identity.
Client role = future role label or access role within the Client/account.
```

Primary contact fields on `FundClient` are C1 operational contact snapshots only. They are not full user accounts, login identity, invitation state, role membership, notification consent, access control or the final C2 user model.

Future Client organisation details need structured physical address and delivery/fulfilment support. Projects should be able to default or inherit delivery address from the linked Client where appropriate, but Project-level delivery snapshots and overrides require separate planning before Store, Orders, Production or Dispatch.

SeasonPro precedent:

```text
C1 League Tenant
-> C2 Club
-> Teams
-> Club users
```

Integrated SeasonPro + FUND may use the SeasonPro Club as the fundraising Project creator/account.

Terminology note:

```text
Client may be the user-facing/admin term for the C2 organisation/account.
In SeasonPro, Client is synonymous with Club.
In FUND, Client may be a school, club, PTA, charity branch, fundraising organisation or customer account.
```

C1 Client view note:

```text
C1 should eventually be able to enter a managed Client/account view for support, preview or administration.
This must be distinct from hat-swapping and must not rely on unsafe impersonation.
```

Open decision:

```text
Should FUND create a FUND-specific C2 organisation/account model, a reusable IsoStack C2 organisation/account model, or a hybrid that retains FundProjectParticipant for Project-level exceptions?
```

Control rule:

```text
Further C2 dashboard expansion must pause before write-capable or commercially meaningful surfaces until this is resolved.
```

### AMOW Founding-Tenant Priority

The immediate AMOW presentation priority is the C1 organisational dashboard, not expansion of the interim C2 read-only dashboard.

AMOW needs to be able to explain and demonstrate the operating model:

```text
AMOW manages Clients, Products, Events and Projects.
Clients are fundraising organisations such as schools, clubs or PTAs.
Projects belong to Clients.
Future Store, Orders, Sales, Communications and Reporting sit naturally under the Client and Project structure.
```

Current priority slice:

```text
1P-F-A - C1 Client Management Foundation
```

Control decision:

- 1P-D remains technically safe as a read-only participant-scoped interim dashboard.
- 1P-D is not the immediate AMOW product priority.
- Further C2 dashboard expansion remains paused.
- C2 mutations, invitations, Project Request/onboarding, Store, Orders, Commerce, Sales/Reporting and Communications remain deferred.
- C1 Client management is the next priority planning lane.
- C1 Client management UI can proceed without Client user provisioning because organisation/account management and user/member management are separate concerns.
- A future planning slice is required for Client organisation details, Client users/members, roles and notification boundaries.

### Project Intake / Client Onboarding Clarification

Future FUND Project creation has three important lanes:

```text
Unknown / public intake:
external or unknown respondent -> C1 Project Intake form -> C1 moderation -> Client/account + C2 user/member + Project

New Client / first Project:
new organisation / first Project -> intake/onboarding submission -> C1 moderation -> Client/account + first user + Project

Existing Client / additional Project:
authenticated C2 Client user -> Client dashboard -> New Project -> direct Client-owned FundProject creation under authenticated Client/account context

SeasonPro Club:
SeasonPro Club user -> Club view -> Project request/create flow -> C1 moderation or trusted direct creation only if policy allows
```

Project Intake / Project Request forms may later be:

- embedded on websites;
- linked from emails;
- linked from campaign pages;
- linked from SeasonPro Club views;
- used from future Client dashboards only where a deliberate request/intake path is needed instead of direct Client-owned Project creation.

Control rules:

- C1 users may create/manage Project Intake forms in a future slice.
- Unknown/public and new Client form submissions must be moderated before operational records are created or linked.
- The moderated initiation form is the next implementation priority and remains moderated for both new and existing Client respondents.
- If an existing Client/contact uses the initiation form, email/Client matching may flag likely linkage or an additional Project, but it must not bypass C1 approval.
- The initiation form should follow the proven SeasonPro-style pattern: multi-step form -> email confirmation midpoint -> confirmed submission -> C1 moderation -> create/link Client, Client user/member and Project.
- Approval may create/link Client/account, C2 user/member, Project and Event linkage for moderated intake.
- Existing authenticated Client dashboard Project initiation is not an intake submission by default.
- Existing authenticated C2 Client users should be able to create Client-owned Projects directly once the Client user/member and role/permission model exists.
- Direct Client-created Projects should start in a safe pre-operational state and remain subject to later gates before activation, Store launch, public ordering, production batching, dispatch/fulfilment, notification sending or commerce/payment activity.
- Client-scoped Project initiation must use trusted Client route, token or authenticated Client context. Existing Client dashboard initiation should auto-scope the Project to the authenticated Client/account.
- Client ownership must not be inferred from organiser snapshot fields, respondent email alone, proposed Client contact fields alone or user-editable hidden fields.
- New Client / first Project intake may create or match Client/account, create or link a primary Client login user/member and create a Project linked through `FundProject.clientId` only after explicit C1 moderation/approval or a separately planned trusted direct-creation policy.
- The C2 Client user is the Project manager and may later plan, update, cancel, archive or manage the Project within operational rules.
- C1 is the FUND producer tenant/supplier/fulfilment operator. C1 manages Products/Catalogues, Event/Product availability, artwork checking, production, dispatch, commission, order/commerce oversight and supplier-side exceptions rather than approving every authenticated C2 Project by default.
- Future direct Client Project creation idempotency must account for double-click/retry protection and authenticated Client user/member audit. Future moderation approval idempotency must account for initiator email matching and/or future Client user/member matching.
- The future Client dashboard is also the intended Client engagement surface for C1 announcements, special offers/campaign prompts, dashboard-visible messages and 1:1 communication.
- Client dashboard communications must follow a controlled SeasonPro-style communications pattern and must not be implied by Project Intake schema alone.
- Projects may be linked to a C1 Event or may be standalone depending on campaign/form policy.
- Existing SeasonPro Clubs may later act as the FUND Client/account and Project creator.
- SeasonPro Club-originated Project initiation depends on the League tenant having the FUND / Fundraising module enabled through subscription, League configuration of approved FUND producer tenant(s), catalogue availability to Clubs, sale method planning and explicit Club-to-FUND Client/account mapping.
- Club-facing product options should be presented as fundraising products available through the SeasonPro/League context, not as supplier-management records or producer internals.
- Until trusted direct creation is deliberately planned, SeasonPro Club-originated Project initiation should create or route through a moderated Project Intake submission with source `SEASONPRO_CLUB`.
- Notification/invitation sending is deferred and must follow a controlled SeasonPro-style communications pattern.
- 1P-F-E Client UI remains C1 admin only and does not implement Project Intake forms, Client users, invitations or automatic Project creation.

## 6. Architecture Planning Required Before Store / Commerce

The first remediation CR surfaced two architecture questions that should be resolved before Store, Order, Commerce or production workflow work.

### Event / Catalogue / Product Availability

Source issue:

```text
Issue #48 - Events should link to one or more Product Catalogues
```

Design question:

```text
How should Event-linked Projects and standalone Projects determine eligible Products?
```

Planning needed:

- Event-to-Catalogue links.
- Optional Event-to-ad-hoc Product links where a Product should be available for one Event without first creating a broader Catalogue.
- Standalone Project Catalogues.
- Catalogue type/scope.
- Whether Events can use multiple Catalogues.
- Whether Catalogues can serve multiple Events.
- Project Product picker eligibility.
- Project inheritance from linked Event availability.
- Project ability to select or deselect Products from inherited Event/standalone availability.
- Project type and workflow suitability constraints that limit the eligible Product list.
- Future Store generation eligibility.

Accepted conceptual direction:

- Event-linked Projects should normally inherit eligible Products from the Event's linked Catalogue(s).
- Standalone Projects should choose from tenant-approved standalone/default Catalogue(s) or explicitly configured Products.
- Events may need ad-hoc Product availability where a Product is specific to a campaign/Event.
- Product selection and deselection should happen at the Project level, because individual Projects may not use every Product available from the Event or Catalogue.
- Store/Orders/Commerce must not be implemented until Product eligibility for a Project is explicit and auditable.
- Rich Product media, image galleries, option definitions and option-image mapping are important but belong to Product/Catalogue refinement planning unless they become Store MVP blockers.

### Product Workflow Suitability

Source issue:

```text
Issue #49 - Product Workflow Class suitability
```

Design question:

```text
Is a Product's workflow class a default, a suitability set, or a Project-specific operational choice?
```

Current stabilising interpretation:

- `FundProduct.workflowClassId` is the Product default/initial classification.
- `FundProjectProduct.workflowClassId` is the operational Project Product workflow snapshot.
- A future suitability/availability layer may allow one Product to support multiple workflow classes.

Planning needed before Store/Commerce/production:

- Whether suitability belongs on Product.
- Whether suitability belongs on Catalogue membership.
- Whether Event constraints limit permitted workflow classes.
- Whether Project Product chooses final workflow.
- How suitability affects production export and lifecycle.

### C1 Production / Dispatch / Commission Workflow

Source clarification:

```text
C1 dashboard is the Project administration and production workflow surface.
```

Planning needed before Store/Commerce implementation:

- Project artwork checking and approval.
- Project-level production status.
- Grouping similar Products across Projects for production efficiency.
- Maintaining Project context while batching production across Projects.
- Dispatch/fulfilment by Project and Client.
- Commission model under the Client/Project/Order/Commerce structure.
- Relationship between Project Product membership, Orders and production outputs.

Control rule:

```text
Store, Orders and Commerce must preserve the C1 production/admin workflow and future Client dashboard engagement surface. They must not be designed as isolated checkout/order features.
```

## 7. Commerce Core As Separate Future IsoStack Lane

Commerce Core should be treated as a reusable IsoStack platform lane, not a FUND-only implementation detail.

Future Commerce Core lane should cover:

- provider-neutral Products/Prices/Orders/Payments/Subscriptions where appropriate;
- payment providers such as Stripe and GoCardless;
- VAT/tax model;
- checkout/session lifecycle;
- payment status and webhooks;
- subscription and usage billing options;
- audit and tenant safety.

FUND Store planning should depend on, or at least align with, this future platform lane.

## 8. SeasonPro Remediation As Separate Branch / Lane

SeasonPro/LMSPro fixes should use:

```text
feature/seasonpro-remediation
```

Purpose:

- keep SeasonPro remediation testable and promotable without unfinished FUND C2 work;
- cherry-pick specific fixes into FUND branches only when needed;
- avoid using FUND feature branches as a holding area for unrelated SeasonPro fixes.

Recent example:

- `fix(lmspro): support team data export` was first isolated as a SeasonPro-only hotfix, then absorbed into FUND before release.

Recommended rule:

```text
SeasonPro fixes start in the SeasonPro remediation lane unless the fix is genuinely FUND-dependent.
```

## 9. Deferred Items

Deferred until explicitly planned:

- C2 organiser dashboard mutations or expansion beyond the implemented read-only interim participant-scoped view.
- C2 organisation/account model implementation beyond controlled Client-management planning.
- Client users/members, Client roles, invitation state and notification consent.
- C2 organiser invitations.
- Project Intake / Project Request / onboarding forms.
- Organiser account provisioning.
- FundOrganiserProfile.
- Store schema.
- Order schema.
- Commerce Core implementation.
- Payments.
- Subscriptions.
- Commissions.
- Production batching.
- C1 artwork checking and production workflow implementation.
- C1 dispatch/fulfilment workflow implementation.
- Fulfilment/distribution workflows.
- Client dashboard announcements, special offers/campaign prompts and 1:1 communications.
- Artwork/data/template submission workflows.
- Media/asset library.
- Marketplace / AMOW product sharing.
- SeasonPro integration/distribution channel.
- SeasonPro Club-to-FUND Project initiation implementation.
- SeasonPro League approved FUND producer/catalogue configuration UI.
- SeasonPro Club sale method workflows.
- AI workflows.
- Lifecycle transition engine.
- Lifecycle tables/templates.

## 10. Current Do Not Build Yet List

Until explicit future slices are accepted, do not build:

- Project Product eligibility services beyond the accepted 1Q-E scope.
- C2 Product picker UI before 1Q-F.
- Store generation.
- Order management.
- Commerce checkout.
- Payment webhooks.
- Production export/batching.
- C2 dashboard mutation/management expansion.
- Client dashboard communications, announcements, special offers or 1:1 messaging.
- C2 organisation/account schema before the Client/account schema-options slice is accepted.
- C2 invitation/onboarding flow.
- new Project Intake / Project Request / onboarding flows beyond the current public Project initiation implementation.
- SeasonPro Club-to-FUND Project initiation flow.
- SeasonPro League producer/catalogue availability configuration.
- Sale method selection workflows.
- Organiser dashboard actions.
- C1 production batching/artwork checking/dispatch/commission workflow.
- Product marketplace/sharing.
- Any schema migration for the above without a planning slice first.

## 11. Recommended Next 3-5 Slices

### Next 1 - C1 Admin Immediate Remediation

Suggested slice:

```text
Slice 1P-R1 - C1 Admin Immediate Remediation
Slice 1P-R1A - C1 Admin UI Consistency Remediation
```

Status:

```text
Implemented and check-passed.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-r1-c1-admin-immediate-remediation.md
```

Scope:

- Issue #46 Project/Event date constraint fix.
- Issue #50 Issue Manager module filtering/server render fix.
- Issue #47 Project Product activation gate visibility.
- Issue #44 breadcrumbs.
- Issue #45 sidebar icon specificity.
- Dashboard card interaction/colour consistency.
- Column-header sort alignment.
- Issue Manager module field consolidation.

Branch:

```text
feature/fund-phase-1-c2-project-access
```

### Next 2 - C2 Read-Only Organiser Dashboard UI

Suggested slice:

```text
Slice 1P-D - C2 Read-Only Organiser Dashboard UI
```

Status:

```text
1P-A planning complete.
1P-B participant schema implemented and aligned to dev/staging.
1P-C read-only organiser Project API/services implemented, reviewed and aligned to dev/staging.
1P-D implemented on feature/fund-phase-1-c2-project-access.
1P-D-R1 review complete with caveats.
```

Scope:

- implement C2 read-only organiser landing page;
- implement C2 read-only assigned Project detail page;
- consume only `fund.organiser.projects.list/get`;
- include C1/C2 context navigation for dual-role users;
- no C2 mutations, invitations, participant management, Store, Orders or Commerce.

Pre-implementation note:

```text
Confirm staging has applied 20260625143000_add_fund_project_participants before authenticated staging testing.
```

### Next 3 - C1 Client Management Foundation For AMOW

Suggested slice:

```text
Slice 1P-F-A - C1 Client Management Foundation
```

Scope:

- plan the AMOW-facing C1 Client management foundation;
- decide how `Client` should be presented as the C2 organisation/account concept;
- define the minimal Client record needed for AMOW explanation and near-term implementation;
- define Client to Project relationship expectations;
- document how future Orders, Sales, Reporting, Communications and key-date automation sit under Client and Project;
- defer schema implementation until schema-options planning is accepted.

Status:

```text
Active priority planning.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-a-c1-client-management-foundation-planning.md
```

### Next 4 - C1 Client / Account Schema Options

Suggested slice:

```text
Slice 1P-F-B - C1 Client Management Schema Options
```

Scope:

- decide whether Client/account should be FUND-specific, reusable IsoStack core, or hybrid;
- define tenant scoping and same-tenant Project linkage;
- decide Project `clientId` / `clientAccountId` direction;
- define migration/backfill approach for existing Projects;
- define SeasonPro Club mapping guardrails;
- define C1 Client list/detail UI implications.

Status:

```text
Implemented, reviewed with caveats and aligned to dev/staging as da6fd0f.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-b-c1-client-management-schema-options.md
```

Recommended next implementation slice:

```text
Slice 1P-F-C - C1 Client Management Schema
```

Status:

```text
Implemented locally as schema-only work.
```

Confirmation document:

```text
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-f-c-c1-client-management-schema-confirmation.md
```

### Next 5 - C1 Client Management API/Services

Suggested slice:

```text
Slice 1P-F-D - C1 Client Management API/Services
```

Scope:

- plan C1 tenant-scoped Client list/get/create/update/archive/restore services;
- plan Client search/filter/sort behaviour;
- plan Client detail payload with linked Project summaries;
- plan same-tenant enforcement and archived Client behaviour;
- plan audit events and error handling;
- keep UI, Project Client selector, Client users, invitations, Store, Orders, Commerce, Sales/Reporting, Communications and SeasonPro mapping out of scope.

Status:

```text
Implemented locally as API-services only.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-d-c1-client-management-api-services-planning.md
```

Confirmation document:

```text
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-f-d-c1-client-management-api-services-confirmation.md
```

### Next 6 - C1 Client Management UI

Suggested slice:

```text
Slice 1P-F-E - C1 Client Management UI
```

Scope:

- build C1 Client list;
- build C1 Client detail;
- consume `fund.clients.*` only;
- show linked Project summaries;
- support create/update/archive/restore;
- keep Client users, invitations, Project Request/onboarding, Store, Orders, Commerce, Sales/Reporting, Communications and SeasonPro mapping out of scope.

Status:

```text
Planning document created.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-e-c1-client-management-ui-planning.md
```

Confirmation document:

```text
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-f-e-c1-client-management-ui-confirmation.md
```

Review document:

```text
isodocs/docs/modules/fund/05-review-and-test/2026-06-25-phase-1-slice-1p-f-e-r1-c1-client-management-ui-review.md
```

### Next 7 - Project Client Selector And Linkage

Suggested slice:

```text
Slice 1P-H - Project Client Selector And Linkage
```

Scope:

- plan how C1 admins link Projects to Clients;
- plan Project create/update API/service changes for `clientId`;
- plan DRAFT-only link/change/unlink rule;
- plan read-only historical display for non-DRAFT and archived linked Clients;
- plan Project create/detail Client selector UI;
- keep Client users, invitations, notification sending, Project Intake forms, Store, Orders, Commerce, Sales/Reporting and Communications out of scope.

Status:

```text
1P-H planning complete.
1P-H-A API/services implemented and static-check passed.
1P-H-B UI implemented and static-check passed.
1P-H-C review and authenticated staging smoke testing complete.
Accepted with no remedial work required at this stage.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-h-project-client-selector-linkage-planning.md
```

Confirmation documents:

```text
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-h-a-project-client-linkage-api-services-confirmation.md
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-h-b-project-client-selector-ui-confirmation.md
```

Review document:

```text
isodocs/docs/modules/fund/05-review-and-test/2026-06-25-phase-1-slice-1p-h-c-project-client-linkage-ui-review.md
```

Alignment recommendation:

```text
1P-H-A/1P-H-B are committed and aligned to dev/staging at `536c947`. Authenticated staging smoke testing passed.
```

### Next 8 - Project Intake / Client Onboarding Planning

Suggested slice:

```text
Slice 1P-G - Project Intake, Client Onboarding And Moderation Planning
```

Scope:

- plan C1-created Project Intake forms;
- plan embedded public forms and email/campaign links;
- plan SeasonPro Club-view Project creation entry points;
- plan future Client-dashboard additional Project initiation;
- plan unknown respondent and existing C2 user flows;
- plan C1 moderation before creating/linking operational records;
- plan approval creating/linking Client/account, C2 user/member, Project and Event linkage;
- define notification/invitation boundary;
- treat email trigger points as placeholders until the dedicated editable notifications lane is implemented;
- defer Store, Orders, Commerce, Sales/Reporting and Communications implementation.

Status:

```text
1P-G future lane documented.
1P-G-A schema and moderation model planning complete.
1P-G-B schema options planning complete.
1P-G-C schema implementation and 1P-G-C-R1 review complete.
1P-G-C2-A email confirmation schema addendum implemented as schema-only work.
1P-G-D0 client-scoped initiation/idempotency planning complete.
1P-G-D Project Intake Moderation API/Services planning complete.
1P-G-D1 C1 Project Intake Form API/Services implemented.
1P-G-D2 C1 Project Intake Submission Review API/Services implemented.
1P-G-D3 Project Intake Approval Action Planning complete.
1P-G-D3-A Project Intake Approval API/Services implemented.
1P-G-D3-A-R1 Project Intake Approval API/Services Review complete with caveats.
1P-G-E C1 Project Intake Moderation And Approval UI implemented.
1P-G-E-R1 C1 Project Intake Moderation And Approval UI Review complete with a proceed verdict.
1P-G-F Public Project Initiation Form UI Planning initiated.
1P-N0 FUND System Notifications And Editable Email Defaults Planning added as a future communications lane.
Resume context after SeasonPro/auth remediation is documented.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-g-project-intake-client-onboarding-and-moderation-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-g-a-project-intake-schema-and-moderation-model-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-b-project-intake-schema-options-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d-project-intake-moderation-api-services-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d1-c1-project-intake-form-api-services-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d2-c1-project-intake-submission-review-api-services-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d3-project-intake-approval-action-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-e-c1-project-intake-moderation-and-approval-ui-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-f-public-project-initiation-form-ui-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-resume-context-after-seasonpro-remediation.md
```

Recommended next implementation slice:

```text
1P-G-F-A - Public Project Initiation Form UI Implementation
```

Implementation goal:

```text
Build the public multi-step Project initiation form UI using the approved client-facing field set, trusted branding fallback and confirmation-state screens. Use email trigger placeholders, with a narrow permitted hard-coded transactional exception for required confirmation/authentication email.
```

Required parallel/follow-up planning lane:

```text
1P-N0 - FUND System Notifications And Editable Email Defaults Planning
```

Communications goal:

```text
Plan FUND notification trigger keys, editable default email content, recipient rules, pause/resume controls and audit/test behaviour using the SeasonPro/LMSPro communications Notifications tab as the precedent.
```

Deferred later lane:

```text
1P-K0 - Client-Owned Project Lifecycle And Dashboard Management Planning
```

### Next 9 - SeasonPro Club To FUND Project Initiation Planning

Suggested slice:

```text
Slice 1P-J - SeasonPro Club To FUND Project Initiation Planning
```

Scope:

- preserve the future SeasonPro Club-originated fundraising Project initiation path;
- record dependency on SeasonPro League FUND/Fundraising module entitlement;
- record League configuration of approved FUND producer tenant(s), such as AMOW;
- record catalogue/product availability to Clubs;
- protect the supplier/producer visibility boundary;
- require explicit SeasonPro Club to FUND Client/account mapping;
- preserve `SEASONPRO_CLUB` as a Project Intake submission source;
- preserve sale method options for later Store/Orders/Commerce planning;
- keep implementation deferred.

Status:

```text
Planning placeholder created. Do not implement yet.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-j-seasonpro-club-to-fund-project-initiation-planning.md
```

### Next 10 - C1 Production / Dispatch / Commission Workflow Planning

Suggested slice:

```text
Slice 1P-I - C1 Production, Dispatch And Commission Workflow Planning
```

Scope:

- record C1 Project administration and production workflow expectations;
- plan artwork checking as Project-linked;
- plan grouping similar Products across Projects for production efficiency;
- plan Project-level production status;
- plan dispatch/fulfilment as Project/client-linked;
- plan commission under the Client/Project/Order/Commerce structure;
- keep implementation deferred until Store, Orders and Commerce planning can align to the production surface.

Status:

```text
Planning note created. Do not implement yet.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-i-c1-production-dispatch-commission-workflow-planning.md
```

### Next 11 - Event / Catalogue / Product Availability Planning

Suggested slice:

```text
Slice 1Q-F - Catalogue-Centric Project Product Picker UI Remediation
```

Current 1Q status:

- 1Q-A Product/Catalogue Suitability Schema Options Planning is complete.
- 1Q-B Event/Catalogue Availability Schema Implementation is complete.
- 1Q-C C1 Event Catalogue Availability API/Services is complete in app commit `2bb8db3`.
- 1Q-D C1 Event Catalogue Availability UI is complete in app commit `28662af`.
- 1Q-D implementation confirmation and R1 review/test documents are created.
- 1Q-D static/type/verify checks passed.
- 1Q-D authenticated C1 browser smoke is accepted as passed by operator confirmation; detailed UI/UX revisions are deferred to refinement.
- 1Q-E planning is created and locks the no-suitability-rows policy and service contract.
- 1Q-E is implemented and promoted to `origin/dev` / `origin/staging` at `7a7354a`, with implementation confirmation created.
- 1Q-E-R1 developer API/service review/test is accepted as passed and documented in `05-review-and-test/2026-07-01-phase-1-slice-1q-e-r1-project-product-eligibility-api-services-review-and-smoke-test.md`.
- 1Q-E has no operator-visible browser UI; operator/browser Product picker testing resumes in 1Q-F.

Accepted implementation sequence:

```text
1Q-A - Event/Catalogue/Product Availability Schema Options
1Q-B - Event/Catalogue Availability Schema Implementation
1Q-C - C1 Event Catalogue Availability API/Services
1Q-D - C1 Event Catalogue Availability UI
1Q-E - Project Product Eligibility API/Services
1Q-F - Catalogue-Centric Project Product Picker UI Remediation
1Q-G - Availability Review And Store/Commerce Readiness Check
```

1Q-E scope:

- derive eligible Products for a Project from linked Event Catalogue availability or standalone/default Catalogue availability;
- apply Product Project type suitability;
- apply Product organisation type suitability where Client organisation type is available;
- treat missing active suitability rows for a Product as unrestricted for that suitability dimension, after source availability passes;
- deduplicate eligible Products by Product while retaining all source Catalogue context;
- preserve same-tenant checks;
- exclude archived/inactive Events, Catalogues, Catalogue memberships and Products;
- return eligibility data only;
- do not create Project Product memberships;
- do not implement C2 Product picker UI, Store, Orders or Commerce.

1Q-E-R1 review/test result:

- operator-visible browser smoke was confirmed not applicable to the new 1Q-E behaviour;
- browser scope is limited to negative/regression confirmation because 1Q-E intentionally adds no visible browser surface;
- `fund.productEligibility.listForProject` is read-only;
- source availability is mandatory;
- no-suitability-rows means unrestricted for that suitability dimension after source availability passes;
- active suitability rows narrow eligibility;
- Products available through multiple source Catalogues appear once with all source Catalogue references;
- same-tenant checks and archived/inactive exclusions are covered;
- no C2 Product picker UI, Store, Orders or Commerce behaviour was added.

1Q-F direction:

- consume the 1Q-E eligible Product response rather than `fund.products.list`;
- group eligible Products by source Catalogue for discovery and explanation;
- share selection state by `productId` across Catalogue groups;
- create/reactivate at most one `FundProjectProduct` row per selected Product;
- display a Product-side Catalogue memberships view in Product Manager, or explicitly defer full bidirectional management with a follow-up;
- preserve the rule that Store pages should eventually display each selected Product once.

Duplication/copy boundary:

- referenced Products shared across multiple Catalogues remain one Product identity and should collapse to one selection/store row;
- copied Products are distinct Product records and may drift in pricing, commission, copy, options, media or fulfilment behaviour;
- Product/Catalogue duplication policy belongs to refinement planning unless Store readiness makes it a blocker.

### Next 12 - C2 Dashboard Foundation Expansion

Suggested slice:

```text
Slice 1R - C2 Dashboard Foundation Expansion
```

Only start after:

- C1 immediate remediation is complete;
- 1P-D read-only dashboard review is complete;
- C2 organisation/account scope is accepted;
- C1 Client/account schema direction is accepted;
- C2 read-only visibility rules are clear.

## 12. Prompt To Use In A Fresh Chat

```text
We are working on IsoStack FUND.

Current app branch:
dev

Current released baseline:
bb50bc6 fix(fund): allow c2 client dashboard route

Current local app state:
- local dev is aligned with origin/dev at 7a7354a feat(fund): add project product eligibility services;
- local staging is aligned with origin/staging at 7a7354a feat(fund): add project product eligibility services;
- 1Q-C C1 Event Catalogue Availability API/Services is implemented at 2bb8db3;
- 1Q-D C1 Event Catalogue Availability UI is implemented at 28662af;
- 1Q-E Project Product Eligibility API/Services is implemented, committed, promoted to origin/dev and origin/staging, and reviewed at 7a7354a;
- unrelated untracked local files may exist and must not be reverted unless explicitly requested.

Read first:
- isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md
- isodocs/docs/modules/fund/00-roadmap-control/README.md
- isodocs/docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1q-event-catalogue-product-availability-and-workflow-suitability-planning.md
- isodocs/docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1q-a-product-catalogue-suitability-schema-options-planning.md
- isodocs/docs/modules/fund/03-slice-planning/2026-07-01-fund-phase-1-slice-1q-e-project-product-eligibility-api-services-planning.md
- isodocs/docs/modules/fund/03-slice-planning/2026-07-01-fund-phase-1-slice-1q-f-catalogue-centric-project-product-picker-ui-planning.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1q-b-event-catalogue-availability-schema-implementation-confirmation.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1q-c-c1-event-catalogue-availability-api-services-confirmation.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-07-01-phase-1-slice-1q-d-c1-event-catalogue-availability-ui-confirmation.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-07-01-phase-1-slice-1q-e-project-product-eligibility-api-services-confirmation.md
- isodocs/docs/modules/fund/05-review-and-test/2026-07-01-phase-1-slice-1q-d-r1-c1-event-catalogue-availability-ui-review-and-smoke-test.md
- isodocs/docs/modules/fund/05-review-and-test/2026-07-01-phase-1-slice-1q-e-r1-project-product-eligibility-api-services-review-and-smoke-test.md

Context:
- K2 Client dashboard live promotion completed at bb50bc6.
- 1Q-A planning, 1Q-B schema, 1Q-C API/services and 1Q-D C1 UI are complete/documented.
- 1Q-D static/type/verify checks passed; authenticated C1 browser smoke is accepted as passed by operator confirmation.
- Detailed 1Q-D UI/UX revisions are deferred to refinement and should not block 1Q-E.
- 1Q-E planning is accepted and locks the no-suitability-rows policy.
- 1Q-E implementation adds read-only `fund.productEligibility.listForProject` and is promoted to `origin/dev` / `origin/staging` at `7a7354a`.
- 1Q-E-R1 developer/API service review passed with transaction-scoped smoke coverage and no `FundProjectProduct` mutation.
- 1Q-E has no operator-visible browser UI; operator-visible picker testing belongs to 1Q-F.
- 1Q-F planning is accepted as Catalogue-centric: grouped by source Catalogue, deduped by Product identity, one shared selected Product state.
- Availability is the Product source list. Source Catalogues explain eligibility. FundProjectProduct remains the selected Product list.
- Store pages should eventually display each selected Product once, even if it was eligible through multiple Catalogues.
- Future duplication can create referenced Catalogues that share Product records or copied Product records that drift in pricing, commission, copy, options, media or fulfilment behaviour.
- Store, Orders, Commerce, production, dispatch, notifications and SeasonPro integration remain out of scope unless separately planned.

Immediate recommended work:
Proceed with 1Q-F - Catalogue-Centric Project Product Picker UI Remediation.

1Q-F goal:
Make the reviewed 1Q-E eligibility service visible in the Project Product picker while preserving the Catalogue-centric source explanation and one selected Product state.

1Q-F should consume `fund.productEligibility.listForProject` rather than `fund.products.list`.

1Q-F must:
- show eligible Products grouped by source Catalogue;
- deduplicate shared Products by Product identity while showing all source Catalogue references;
- keep one shared selected state per `productId`;
- create/reactivate at most one `FundProjectProduct` row per selected Product;
- avoid duplicating Products merely because they appear in more than one Catalogue;
- keep Store pages out of scope, while preserving the later rule that Store pages should display each selected Product once;
- add or explicitly defer a Product-side Catalogue memberships view so Products do not become an unmanageable flat list.

Do not start:
- Commerce Core;
- Store;
- Order;
- Sales/Reporting implementation;
- Communications implementation;
- Client dashboard announcements, special offers/campaign prompts or 1:1 messaging;
- payments;
- commissions;
- production batching;
- artwork checking/production/dispatch workflow implementation;
- Product media galleries;
- Product option modelling;
- SeasonPro integration;
until their planning slices are accepted.

Process rule:
After implementation, add a labelled implementation confirmation in 04-implementation-confirmations, add a review/test summary in 05-review-and-test, then recursively update the roadmap-control document and README if the process/current status changed.
```
