# FUND Phase 1 Slice 1R-E-C R1 - C2 Project Store Control Surface Review And Test

Date: 2026-07-15
Automated review result: PASS
Human UI result: NOT YET RUN - scheduled below
Migration inventory: 141 applied / 0 failed on retained disposable PostgreSQL after full replay

Roadmap renumbering notice: this historical record's `1R-F` public Store reference now
means `1R-G`; current `1R-F` is Project Offer And Artwork Readiness.

## Review Conclusion

The E-C implementation conforms to the accepted plan and parent authority contract.

C2 now has the normal Project Store control surface. C1 remains the supplier/oversight actor and
retains exceptional pause/release and closure/reopen through E-B. The UI does not create a second
state machine: server E-A evidence controls every displayed blocker and allowed Store action.

No blocker remains in automated implementation review. Human interaction and visual proof is
still required before staging acceptance or public Store work.

## Automated Evidence

### Schema and migration

- Prisma schema validation: PASS.
- Prisma client generation: PASS.
- Migration inventory unchanged at 141: PASS.
- No E-C migration or model added: PASS.
- Retained R3-D full fresh 141-migration replay: PASS after aligning its obsolete 135-count
  assertion and bounding child-process output.

### Static and type/build

- `client-project-store.test.ts`: PASS.
- `verify-fund-1r-e-c-client-store-surface.ts`: PASS.
- retained E-B static verifier: PASS.
- retained 1R-D static verifier: PASS after recognising the accepted E-A C1/C2 authority split.
- retained A7 and R3-D static verifiers: PASS.
- `tsc --noEmit`: PASS.
- production `next build`: PASS, 131/131 static pages generated.

### Disposable PostgreSQL

Safety proof compared parsed database identity and confirmed `TEST_DATABASE_URL` differs from
`DATABASE_URL` before every database-writing suite.

E-C passed:

- active C2 manager read and mutation;
- C2 viewer read-only response and mutation refusal;
- cross-Client refusal;
- bounded Store response without configuration hash or C1 notes;
- C2 Store-copy mutation and viewer refusal;
- atomic Store Product reorder, viewer refusal and duplicate-order rejection;
- exact proposed commission summary;
- C2 acceptance, stable replay and transactional audit;
- viewer acceptance refusal;
- retrospective replacement with atomic predecessor supersession;
- stale Project-close snapshot refusal; and
- zero E-C fixture residue.

Retained E-A, E-B, 1R-D and A7 disposable suites also passed. No shared development, staging or
production database was modified.

## Privacy And Authority Review

PASS:

- browser input has no `organizationId`, actor or evaluation-time authority;
- C2 response has no raw configuration JSON, full hash, C1 operator note or resolution note;
- C2 Store Product controls cannot write price, tax, source media, Catalogue eligibility or
  readiness evidence;
- C2 viewer receives no Store action;
- C1-only identity does not grant C2 authority;
- C1 exceptional intervention blocks C2 normal lifecycle actions;
- commission acceptance uses exact active member evidence and server time; and
- public Store/checkout and real provider behavior remain absent.

## Functional Review

Implemented and automated/static verified:

- Store tab in C2 Project detail;
- Project and Event boundary explanation;
- Store absent/prepare state;
- Store copy editor;
- selected Product readiness, visibility and ordering controls;
- eligible Product selection/removal followed by server refresh;
- commission offer summary and explicit acceptance confirmation;
- Project lifecycle buttons;
- E-A-authorised Store publish/pause/resume buttons;
- responsible-party blocker display;
- viewer/read-only, loading and error states; and
- Orders retained as a later-work placeholder.

Detailed artwork approval/upload, Order operations and public Store behavior remain correctly
deferred.

## Human UI Testing Schedule

The following is the required human schedule. A stage is not passed until its evidence is recorded
in this document or a labelled follow-up review record.

### Prerequisites

- application changes committed to `dev` and pushed through the controlled promotion process;
- target database confirmed at all 141 migrations before the application bundle is released;
- one C2 `VIEWER`, one `PROJECT_MANAGER` and one `ADMIN` test login for the same Client;
- a second Client membership/Project for isolation checks;
- one standalone Project and one Event-linked Project with narrower explicit dates;
- one prepared Store with eligible Products, one unprepared Project and one Store blocked by C1;
- proposed commission evidence supplied by C1 test setup; and
- no real Stripe charge or public checkout activation.

### Stage 1 - local dev workflow smoke (30-45 minutes)

Run immediately after the 141-migration dev database and dev application baseline are aligned.

1. Sign in as C2 `PROJECT_MANAGER`.
2. Open `/app/fund/client/projects/[id]` and select Store.
3. Prepare an unprepared Store; confirm it remains unpublished.
4. edit and save Store title, introduction and objective;
5. select/remove an eligible Product, toggle visibility and change order;
6. refresh readiness and verify blockers/responsible actor;
7. accept a proposed commission offer once, then refresh/revisit to prove stable state;
8. activate/pause/resume the Project where allowed;
9. publish/pause/resume the Store where allowed; and
10. confirm Orders remains a non-operational placeholder.

Expected: every mutation returns the latest server state, duplicate clicks are contained, no
commercial/readiness field is editable and no public route is activated.

### Stage 2 - role, date and accessibility pass (30 minutes)

1. Repeat read paths as `VIEWER`; verify every mutation control is absent or disabled.
2. Verify `ADMIN` has the same bounded normal authority as Project manager.
3. Attempt a cross-Client Project URL; expect not-found/safe refusal.
4. Check standalone and Event-linked date copy, including narrower Project dates.
5. Check scheduled, open, Project-paused and Project-window-ended states.
6. Test at desktop and mobile widths.
7. Navigate tabs, forms, confirmation and action controls by keyboard only.
8. Check focus return after commission modal, visible labels, loading, empty and error states.

Expected: no horizontal trap, inaccessible unlabeled control, browser-derived date authority or
cross-Client information.

### Stage 3 - cross-role exceptional intervention pass (20 minutes)

Use C1 E-B and C2 E-C in sequence:

1. C1 applies an exceptional pause with an internal note.
2. C2 refreshes the Store and sees only the bounded supplier-pause explanation.
3. Confirm C2 cannot publish/resume or see the C1 note.
4. C1 releases the pause; confirm C2 state recalculates without forced publication.
5. Repeat with exceptional closure and C1 reopen.

Expected: C1 notes stay C1-only and C2 never bypasses exceptional intervention.

### Stage 4 - controlled dev/origin-dev and staging smoke (20-30 minutes each)

After the documented controlled promotion procedure:

- repeat login, Project detail, Store read, one reversible copy edit and one readiness refresh;
- repeat viewer refusal and C1-pause/C2-observation;
- verify no LMSPro navigation or existing UI regression; and
- make no real Stripe charge.

### Evidence to capture

- environment/commit and migration count;
- tester, role and test Client/Project identifiers;
- desktop/mobile screenshots for Store summary, blockers, viewer state and confirmation;
- exact pass/fail notes for each stage;
- any browser console/server error reference without secrets or personal data; and
- final human acceptance date.

### Stop conditions

Stop promotion and record a failure if:

- migration count is not 141;
- a role or Client isolation check fails;
- C2 sees C1 notes, raw snapshot/hash or commercial writers;
- browser time changes authoritative state;
- C2 bypasses an exceptional intervention;
- commission acceptance duplicates or accepts stale terms;
- Project/Event boundary copy or enforcement disagrees with the server; or
- an existing LMSPro path regresses.

## Remaining Manual Status

Human UI stages 1-4 remain pending. E-B/E-C are now committed on local application `dev` at
`e3f44b4b` and promoted through dev/staging. Exact staging automated gates, online health,
database connectivity, RLS and unauthenticated route protection passed. Authenticated
stages 1-4 remain an explicit test obligation, not an implementation failure.

## Final Boundary

E-C is complete locally through automated implementation/review and documentation. `1R-F` and all
later public Store, checkout, artwork/template, Order, production and commission work remain
unstarted.
