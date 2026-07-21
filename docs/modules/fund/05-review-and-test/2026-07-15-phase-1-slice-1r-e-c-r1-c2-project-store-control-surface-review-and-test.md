# FUND Phase 1 Slice 1R-E-C R1 - C2 Project Store Control Surface Review And Test

Date: 2026-07-15
Automated review result: PASS
Human UI result: BLOCKED - Project workflow does not yet instantiate the mandatory Store/default Product set
Migration inventory: 141 applied / 0 failed on retained disposable PostgreSQL after full replay

Roadmap renumbering notice: this historical record's `1R-F` public Store reference now
means `1R-G`; current `1R-F` is Project Offer And Artwork Readiness.

## Review Conclusion

The E-C implementation conforms to the accepted plan and parent authority contract.

C2 now has the normal Project Store control surface. C1 remains the supplier/oversight actor and
retains exceptional pause/release and closure/reopen through E-B. The UI does not create a second
state machine: server E-A evidence controls every displayed blocker and allowed Store action.

No blocker remains in automated implementation review. Post-promotion preparation found a
separate workflow blocker: the Project creation/intake paths do not create the Store that this
surface controls. Human interaction and visual proof remains required after E-D closes that
testability gap.

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

The earlier fixture-led schedule is superseded. Human testing is suspended until accepted
E-D implementation is promoted. A hand-created Store fixture cannot prove the missing
business workflow.

After E-D, the consolidated schedule must:

1. create one standalone and one Event-linked Project through real retained creation paths;
2. prove each transaction immediately creates one DRAFT Store and all canonically eligible
   Products without a separate `Prepare Store` action;
3. prove C1 immediately sees both Stores in `/app/fund/stores` without gaining routine create
   or publication authority;
4. prove C2 `PROJECT_MANAGER`/`ADMIN` sees the default Product set, can deselect/restore and
   cannot edit commercial/readiness authority;
5. refresh eligibility and prove explicit deselections persist while newly eligible Products
   with no history are selected by default;
6. accept commission and activate the Project, then prove SCHEDULED before `opensAt` and OPEN
   only inside the Project window while every gate passes;
7. repeat read paths as `VIEWER`, cross-Client refusal, desktop/mobile, keyboard, focus,
   loading, empty and error states;
8. apply C1 exceptional pause/release and closure/reopen, proving C2 cannot bypass or see C1
   notes; and
9. make no real Stripe charge or public checkout activation.

Capture environment/commit/migration evidence, tester roles, test identifiers, screenshots,
exact pass/fail notes and safe error references. Stop if Store/default Product creation is not
atomic, a deselection is silently reversed, tenant/role isolation fails, date/readiness gates
are bypassed or C2 sees C1/private commercial evidence.

## Remaining Manual Status

E-B/E-C are promoted at application `e3f44b4b`; their automated gates, online health,
database connectivity, RLS and unauthenticated route protection passed. Human acceptance is
blocked, not failed, by the missing mandatory Project-to-Store/default-Product workflow.
`1R-E-D` is the single corrective next candidate before `1R-F-A`.

## Final Boundary

E-C is complete locally through automated implementation/review and documentation. `1R-F` and all
later public Store, checkout, artwork/template, Order, production and commission work remain
unstarted.
