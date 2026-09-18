# FUND — C1 Proxy Authority And Project Artwork & Files

Date: 2026-09-18

Disposition: Owner-confirmed requirements; reconcile in the next B1 planning cycle for
Individual authority and in the existing collective Group/Logo-Bulk planning for files and
approval. Bounded technical planning and implementation remain outstanding. No expedite,
new portfolio selection, code, migration or deployment is authorised by this input.

## Need And Owner Decisions

C1 provides white-glove service and practical support for Clients who may not use computers
or be able to approve online. C1 must directly create, read, update and delete/archive Clients
and their Projects, with all applicable preparation inputs available in C1 modals/screens.
Projects remain owned by their Client. Use C1's own identity and authority: no HatSwap,
impersonation, fabricated Client membership or requirement to sign in as C2.

Chris explicitly corrects the exact-C2-only finalisation restriction. The normal authorised
C2 route remains; authorised C1 can also finalise the Client's Individual offer directly.
For Collective Project Artwork, C1 can record proxy approval after the Client accepts, for
example verbally. Record it visibly as proxy approval, never as the Client's own online action.
This amendment supersedes contrary organiser-only business rules in earlier plans; it does
not claim existing application behaviour has changed.

Chris also accepts one **Artwork & Files** tab on Group Artwork and Logo/Bulk Projects,
available to authorised C1 and C2, reusing planned production-file capabilities with
workflow-specific instructions. The tab must have a stable, shareable Project URL.

## Required Planning Outcomes

- Audit existing C1 Client/Project create/edit/detail and Product-selection inputs against
  the C2 journey. Identify omissions; do not make the operator role-switch to supply inputs.
- Permit C1 finalisation through a server-checked C1 action using the same readiness,
  preview, stale-input, locking and duplicate-request protections as C2.
- Distinguish direct C2 action from C1 action on behalf of the Client. Preserve actual
  authenticated actor, Client/Project, exact offer/artwork version, action and timestamp.
  For proxy approval retain a concise record of whose acceptance was conveyed, how/when
  (such as verbal acceptance), and C1's confirmation. Do not require that person to have
  a login or store unnecessary personal details. Exact fields belong in bounded planning.
- Display “Approved by [C1 operator] on behalf of [Client]” for proxy approval and equivalent
  attribution for finalisation. Keep the C1 supplier's production review/release distinct
  from Client approval, even where the same operator records both actions.
- Preserve locked offers, approved versions and financial evidence. CRUD does not grant
  destructive deletion of referenced history, implicit unlock or permission to skip readiness.
- Support multiple source artwork and supporting files, including the already planned
  image/PDF/Office formats, subject to the existing permitted-type, count/size, scanning,
  private-storage and version-evidence requirements. Reuse the production asset foundation;
  do not substitute public Product presentation media for private source uploads.
- A copied URL must open the correct Project's Artwork & Files tab on direct navigation,
  refresh and return after sign-in. Tab navigation and browser back/forward must preserve
  the selected view. Provide a simple copy-link action; choose path versus query parameter
  during implementation planning using existing routing conventions.
- Shared navigation links grant no additional access. Resolve authorised C1 and C2 views
  for the same Project destination, verify tenant/Client/Project permissions server-side,
  and show a clear access result to unauthorised users without exposing files. Anonymous or
  token-based guest upload is not requested or inferred from a shareable URL.

## Existing Work Requiring Reconciliation

Read-only source review at application dev `c3998084` shows:

| Existing boundary | Correction to plan |
| --- | --- |
| `services/individual-offer.service.ts`: C1 finalisation refused; finalise service hardcodes C2 access | Add explicit authorised C1 path and truthful actor attribution; retain normal C2 checks |
| `components/individual-offer/IndividualOfferPanel.tsx`: finalise mutation/button only for C2 | Make the C1 action available directly with appropriate confirmation and attribution |
| `routers/client-dashboard.router.ts`: existing finalisation entry | Plan corresponding C1 API access without weakening other Client routes |
| `FundIndividualOffer.finaliserMemberId` is required and links to a Client member | Plan compatible evidence/schema handling for actual C1 actor versus represented Client; do not fake membership or rewrite old offers |
| C1 `ProjectDetailPage.tsx` has Overview/Products tabs, no Artwork & Files | Define shared workflow-aware file surface and direct URL contract for both actor views |

The accepted-PDF candidate `e8a3c900` reuses the existing finalisation flow; its PDF acceptance
is not evidence of C1 finalisation or proxy approval. Completed automation that correctly
proved the old organiser-only restriction remains historical evidence, not acceptance of
the revised rule. Inspect schema constraints, snapshots, services, routes, UI and tests
on the candidate before implementing; changing a label or enabling a button is insufficient.

## Risk, Validation And Boundaries

Proposed control depth for the next bounded correction: **High**, because actor authority,
tenant/Client scope, immutable approval evidence and private files are involved. Record it
in the existing B1/collective slice plan, not a separate risk document.

Plan positive C1/C2 proof and negative wrong-tenant/Client, insufficient-role and impersonation
checks; exact-version proxy evidence; stale preview and duplicate action handling; preservation
of existing direct-C2 evidence; shared-link sign-in/refresh/history and unauthorised access;
and the existing managed-upload validation. Repeat only tests affected by these changes.

There is no claim of an observed unauthorised-write incident. The present gap prevents
legitimate C1 assistance. Keep it visible as an unresolved acceptance gap, not a live hotfix.
No code, database/provider changes, uploads, messages, promotion or expanded Store/financial
approvals are authorised here. No public upload portal or new document-management product.

Use the existing B1 plan/checkpoint and collective parent; no new planning layer or parallel
workstream. B1 remains Now; 1R-G planning remains Next. Existing PDF checks 1/2 PASS stand,
and the separate C1 instruction-editor-to-PDF human check remains pending.
