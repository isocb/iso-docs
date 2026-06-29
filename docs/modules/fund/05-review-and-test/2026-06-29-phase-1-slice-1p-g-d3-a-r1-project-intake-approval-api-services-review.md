# FUND Phase 1 Slice 1P-G-D3-A-R1 - Project Intake Approval API/Services Review

Date: 2026-06-29

## 1. Review Verdict

Proceed with caveats.

The 1P-G-D3-A approval API/services implementation is consistent with the approved Project Intake approval-action plan and is safe to keep as the next API foundation for C1 Project Intake moderation. No blocker was found in the implemented service/router/validation shape.

The caveats are policy and product-readiness caveats, not immediate code blockers:

- `returnToReview` currently permits most non-approved, non-confirmation-pending submissions to move back to `IN_REVIEW`; before approval UI is exposed, the allowed source statuses should be made explicit.
- No authenticated API smoke test with real Project Intake submission data has been recorded yet.
- The C1 approval summary card, row-click approval page and operator-facing approval workflow remain UI planning/implementation work.
- Client users/members, invitations and notifications remain unimplemented, so approval can create/link the C2 Client organisation/account and Project only.

## 2. Files Reviewed

Application files:

```text
src/modules/fund/lib/validation/project-intake.ts
src/modules/fund/routers/project-intake.router.ts
src/modules/fund/services/project-intake.service.ts
```

Documentation files:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d3-project-intake-approval-action-planning.md
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-d3-a-project-intake-approval-api-services-confirmation.md
isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md
```

## 3. Procedures Reviewed

The implementation adds the expected C1 approval namespace under:

```text
fund.projectIntake.approvals
```

Reviewed procedures:

```text
fund.projectIntake.approvals.getContext
fund.projectIntake.approvals.approveCreateClientAndProject
fund.projectIntake.approvals.approveLinkClientCreateProject
fund.projectIntake.approvals.approveStandaloneProject
fund.projectIntake.approvals.returnToReview
```

## 4. Endpoint Usage And Boundary Proof

The approval procedures are mounted under the existing FUND Project Intake router and use the current tRPC/FUND admin conventions:

- `withFeature('fund')` is used for each approval procedure.
- `getFundActor(ctx)` derives the actor/effective tenant context.
- `assertFundAdmin(actor)` gates the procedures to C1 FUND admins.
- `organizationId` is not accepted from client input.
- Reads and writes are scoped through `actor.organizationId`.

No public form routes, email confirmation endpoints, public token handlers or Client dashboard Project creation procedures were introduced in this slice.

## 5. Tenant Scoping Assessment

Tenant scoping is acceptable.

Approval actions look up submissions using the current tenant and validate same-tenant linkage for Clients and Events used during approval. Cross-tenant Client/Event/Project linkage is not exposed by the approval inputs.

The approval path creates Projects under the current FUND tenant and uses explicit `FundProject.clientId` for Client-linked approvals. It does not infer Client ownership from respondent email, organiser snapshot fields, proposed contact fields or hidden public form fields.

## 6. Approval Behaviour Assessment

### Create Client And Project

`approveCreateClientAndProject` creates a C2 `FundClient` organisation/account and a linked `FundProject`, then marks the submission `APPROVED`.

This is correctly scoped to C2 Client/account creation only. It does not create a C1 tenant, a login-capable Client user/member, an invitation or a notification.

### Link Client And Create Project

`approveLinkClientCreateProject` links the submission to an existing active same-tenant `FundClient`, creates a linked `FundProject`, then marks the submission `APPROVED`.

Archived or inactive Clients are blocked by the approval service.

### Standalone Project

`approveStandaloneProject` creates a Project without a Client only when the intake form allows standalone Projects.

This preserves the intended exception path while keeping Client-linked Project creation as the normal operating model.

### Return To Review

`returnToReview` lets C1 move an eligible submission back to `IN_REVIEW`.

Caveat: the implementation blocks `APPROVED` and `CONFIRMATION_PENDING`, but otherwise allows several terminal or exceptional statuses to return to review. This should be made explicit before UI work so the approval page does not expose an overly broad action.

## 7. Idempotency And Transaction Assessment

Approval actions run inside Prisma transactions.

If a submission is already `APPROVED`, the approval service returns the existing approved result rather than creating duplicate Clients or Projects. Duplicate Client or Project identifiers are converted into conflict-style errors.

This is suitable for the first approval API slice. A future public/client-facing creation path may still need request-level idempotency keys, but that is outside 1P-G-D3-A.

## 8. Payload Safety Assessment

Approval context uses the existing safe submission detail payload and does not expose confirmation token hashes.

Approval result payloads expose the approved submission and linked Client/Project/Event summaries needed by C1 admin workflows. No participant lists, Client users, invitations, Store, Orders, Commerce, Sales/Reporting or communications data is exposed.

## 9. Audit Assessment

The approval service writes audit records where the current FUND conventions make that straightforward:

- Project Intake approval action;
- Client created from Project Intake;
- Project created from Project Intake;
- return-to-review action.

This is acceptable for the current API slice.

## 10. Explicit Out-Of-Scope Confirmation

The review confirmed that 1P-G-D3-A does not implement:

- public form rendering;
- public submission endpoints;
- email confirmation endpoints;
- email sending;
- token generation;
- public link issuing;
- approval UI;
- Client users/members;
- invitations;
- notifications;
- C2 Client dashboard Project creation;
- Store;
- Orders;
- Commerce;
- Sales/Reporting;
- production/dispatch workflow;
- SeasonPro integration;
- schema changes or migrations.

## 11. Checks

Confirmed from the 1P-G-D3-A implementation confirmation:

```text
npx prisma validate - passed
npm run db:generate - passed
npm run type-check - passed
npm run verify - passed after known sandbox rerun
git diff --check - passed
docs git diff --check - passed
```

This review added documentation only.

## 12. Defects And Follow-Ups

No blocking defects found.

Follow-ups:

- Tighten or explicitly document allowed source statuses for `returnToReview` before approval UI implementation.
- Add an authenticated API smoke test once realistic intake submission data exists.
- Plan and implement the C1 approval summary card and row-click approval page.
- Keep Client user/member provisioning separate from this approval slice.
- Keep Store, Orders, Commerce, production, dispatch and notification gates out of the approval API until separately planned.

## 13. Recommendation

1P-G-D3-A is safe to commit after this review.

Recommended next slice:

```text
1P-G-E - C1 Project Intake Moderation And Approval UI Planning
```

The UI planning should include the C1 approval summary card, row-click approval page, status/action visibility rules, and the return-to-review status policy before implementation.
