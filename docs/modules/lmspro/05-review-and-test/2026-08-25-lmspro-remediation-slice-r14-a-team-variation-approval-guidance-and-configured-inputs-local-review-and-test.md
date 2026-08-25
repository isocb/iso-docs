# LMSPro Remediation Slice R14-A — Team Variation Approval Guidance And Configured Inputs Local Review And Test

Date: 2026-08-25

Review status: **EXACT `D78935D4` IS PROMOTED THROUGH STAGING; LOCAL, SECURITY AND
PUBLIC-HEALTH GATES PASS; EXACT RENDER IDENTITY AND S1-S4 STAGING SMOKE PENDING**

Exact candidate: `d78935d407ace7ebe796a31a13adf3e17dafa758`; Free Day presentation implementation
parent `06966d49106f30f7724d6293ac3c31da33de693a`; Variation Request width parent
`b6c35992959bb2cbdc4c212291fd5be834959e7f`; wrong-target modal candidate
`7fb6ad792f28d19b2a346b70ee93311b0a6b08e7` is superseded; role-name parent
`66104e3576b06c0a532557e44e9b983921dbd5ac`; behaviour-smoke candidate
`0a6376a235dbb97109d894af574d9ef0546ead00` and initial failed candidate
`0700993b16fa83902327eb9e91aa5889e968a383` are superseded.

Files/change boundary: the shared Team Variation policy, configured target input/resolution,
C1-only operational guidance, C2 selectors, numeric Age Group sorting, Age-Group-scoped AGG list,
responsive 660px row-click Variation Request and Free Day detail modals, demoted Free Day Save
Changes placement and focused tests recorded in the implementation confirmation. No schema,
migration, authority, notification, automatic allocation or environment change.

Automated checks: **PASS** — exact candidate focused Free Day surface 2/2, promotion-time
safe-commit, TypeScript, verifier and whitespace; implementation parent `06966d49` passed combined
focused 8/8 and production-file lint with zero errors. Earlier parents retain their recorded
focused/full/build evidence. Exact work-branch/dev/staging Security Scans
`32835754829`/`32835986995`/`32836190860` pass in full, including generated reports.

Human evidence: **PASS R1-R9** — direct control-owner observation, recorded row by row below. The
only R1-R6 finding was that internal shorthand `C1` was rendered to users; exact `66104e35`
replaced it with `League Admin` and R7 passed. Exact `b6c35992` widens the row-click Variation
Request detail modal by 50% on desktop while retaining Mantine's viewport cap; R8 passes. Exact
`06966d49` gives the Free Day row-click modal the same width and moves its single link-style Save
Changes control beneath League Notes, outside the workflow-action footer; R9 passes.

Environment proven: corrected source and automation locally; exact local/remote work branch, dev
and staging refs align at `d78935d4`. Public `https://staging.seasonpro.co.uk/api/health` returned
HTTP 200 with database connected and RLS enabled on 11/11 tables. Main remains exact `06811784`.
No migration or runtime-configuration action was required.

Known residual risk: no local blocker or Security finding remains. C1/C2 remain valid only in
internal control evidence, where C1 means League Admin and C2 means Club Secretary. Exact Render
build identity and the representative authenticated S1-S4 staging path remain human gates and are
not inferred from Git refs, automation or public health.

Next authorised action: confirm exact Render `d78935d4` identity and run S1-S4 below using
controlled staging personas and disposable non-sensitive requests. Do not promote live.

Implementation confirmation:

- [R14-A implementation confirmation](../04-implementation-confirmations/2026-08-25-lmspro-remediation-slice-r14-a-team-variation-approval-guidance-and-configured-inputs-confirmation.md)

Accepted plan:

- [R14-A planning](../03-slice-planning/2026-08-25-lmspro-remediation-slice-r14-a-team-variation-approval-guidance-and-configured-inputs-planning.md)

## 1. Review Verdict

Initial smoke proved that the first surface assumption was incomplete: the C1 Team Approval CRUD
modal also performs variation approval, while C2 does not need operational follow-up guidance. It
also exposed an empty Division option list and legacy null-`ageValue` ordering. Exact `0a6376a2`
corrected all three findings and passed direct R1-R6 retest. That retest exposed one remaining copy
issue: the internal role code `C1` was visible to users. Exact `66104e35` changes those rendered
messages to `League Admin` without changing behaviour, and R7 passes. The first width child
`7fb6ad79` targeted the unrelated Assign Division modal and the control owner correctly reported no
change at the row-click URL. Exact `b6c35992` restores Assign Division and changes only the intended
Variation Request detail modal from Mantine `md` (440px) to 660px. Mantine caps modal content at the
available viewport width, so the wider desktop presentation remains responsive. Exact `06966d49`
then gives the Free Day row-click modal the same width and moves Save Changes beneath League Notes
as a compact subtle control outside the status-action footer.

The control owner reported the complete corrected local presentation all green. R1-R9 pass and the
local gate is accepted.

## 2. Security And Integrity Findings

- Age Group targets are queried by ID plus organisation and Team season, then current/`Retired`
  targets are refused.
- Division targets are queried by ID plus organisation, Team season and current Team Age Group,
  then the current allocation is refused.
- The existing AGG option query is now also filtered server-side by organisation, season and the
  selected Team Age Group before C2 receives its alternatives.
- A raw client label cannot become the stored configured value; the server-resolved code/name wins.
- Invalid configured targets fail before request, audit and email creation; focused negative tests
  verify the no-side-effect boundary.
- Approval authority and existing tenant/Club/Team checks are unchanged.
- Single and bulk approval still mutate only Team name or cancellation status; Age Group, Division,
  Reinstatement and Other remain non-mutating.
- No secret, schema, migration, data-repair or runtime-configuration file changed.

## 3. Initial Human Findings On Superseded `0700993b`

| Ref | Observed result | Status/evidence |
| --- | --- | --- |
| F1 | C1 operational guidance was shown to C2 and absent from the C1 Team Approval CRUD modal. | FAIL — direct control-owner observation during C2 creation and C1 approval |
| F2 | Requested Division / Group was empty for U10 despite two configured U10 divisions. | FAIL — direct control-owner observation; read-only DevData check confirmed two configured divisions and one current allocation |
| F3 | Age Groups with legacy null `ageValue` sorted lexicographically (`U1`, `U11`, `U111`, `U2`) instead of numerically. | FAIL — direct control-owner observation; the create/display portion of the original H2 otherwise passed |

## 4. Corrected Controlled Local Retest

Use only the local application and local DevData, controlled C1/C2 personas, disposable requests
and non-sensitive reasons. Record each row `PASS`, `FAIL` or `NOT RUN`; do not infer a pass from
automation.

| Ref | Check | Status/evidence |
| --- | --- | --- |
| R1 | C2 selects each request type and sees only the relevant request input, with no C1 operational approval/follow-up guidance. | PASS |
| R2 | Age Group uses a numerically ordered current-season selector (`U1`, `U2`, `U11`, `U111`) excluding the Team's current/retired group; the selected label survives create and C1/C2 display. | PASS |
| R3 | Division uses a required non-empty selector limited to the Team's current Age Group and excluding its current AGG; the selected label survives create and display. | PASS |
| R4 | Both C1 Team Approval CRUD modal and Team Variations management detail show the exact effect/task before approval; one automatic disposable request changes the Team and one manual request does not. | PASS |
| R5 | Approved manual management detail retains the named task until C1 completes it and selects `Confirm System Updated`; automatic detail states that the LMSPro change was already applied. | PASS |
| R6 | Mixed bulk selection truthfully reports automatic/manual counts and tasks, preserves selection, and retains existing approval effects. | PASS |
| R7 | User-facing guidance in both League Admin approval surfaces and the mixed-selection summary says `League Admin`, never the internal shorthand `C1` or `C2`. | PASS |
| R8 | From `/app/lmspro/free-days?tab=variations`, row-clicking a Variation Request opens a detail modal about 50% wider on desktop so guidance wraps comfortably; at a narrow/mobile viewport it remains fully inside the viewport with no horizontal clipping and usable controls. | PASS |
| R9 | From `/app/lmspro/free-days`, row-clicking a Free Day opens the same responsive 660px desktop width; Save Changes appears once as a compact link-style control immediately beneath League Notes, saves date/reason/notes without a status action, and is absent from the footer while the applicable Cancel Request, Reject/Approve or Confirm action remains clear and usable. | PASS |

## 5. Automated Evidence Detail

| Gate | Result |
| --- | --- |
| Policy matrix and bulk summary | PASS — all six types classified exactly once |
| Configured create/negative router checks | PASS — resolved snapshots and no-side-effect refusals |
| Single and mixed-bulk approval effects | PASS — two automatic, four non-mutating |
| Guidance surfaces, numeric order and scoped AGG options | PASS |
| Exact `d78935d4` focused Free Day surface suite | PASS — 2/2, including width, position, subtle treatment, uniqueness and footer exclusion |
| Exact `d78935d4` TypeScript / verifier / whitespace | PASS |
| Parent `06966d49` combined focused suite | PASS — 8/8 |
| Parent `06966d49` production-file ESLint | PASS — zero errors; four pre-existing warnings |
| Parent `b6c35992` focused Variation surface suite | PASS — 2/2, including the explicit row-click modal 660px contract |
| Parent `66104e35` focused suite | PASS — 36/36, including a policy assertion that public follow-up text contains no C1/C2 shorthand |
| Parent `0a6376a2` full suite | PASS — 509 passed; 12 intentionally skipped |
| Parent `0a6376a2` production build | PASS — 131 routes; not repeated for the presentation-only children while the control owner runs the local server |
| Promotion-time exact `d78935d4` safe-commit | PASS — TypeScript and critical-file verifier |
| Exact Git corridor | PASS — origin work branch, local/remote dev and local/remote staging align at `d78935d407ace7ebe796a31a13adf3e17dafa758`; main remains `06811784` |
| Work-branch Security Scan | PASS — `32835754829` |
| Dev Security Scan | PASS — `32835986995` |
| Staging Security Scan | PASS — `32836190860` |
| Public staging health | PASS — HTTP 200; database connected; RLS enabled 11/11 |

## 6. Focused Staging Smoke

Use controlled staging League Admin/Club Secretary personas, disposable requests and
non-sensitive reasons. Record each row `PASS`, `FAIL` or `NOT RUN`; do not infer a pass from local
testing, automation, Git alignment or public health.

| Ref | Check | Status/evidence |
| --- | --- | --- |
| S1 | Render displays exact commit `d78935d407ace7ebe796a31a13adf3e17dafa758`; the authenticated League Admin Variation route loads without migration/runtime or console error. | NOT RUN — direct control-owner confirmation required |
| S2 | Club Secretary creates one configured manual Age Group or Division request; the selected configured label survives both roles' displays, League Admin guidance names the required follow-up, approval does not mutate the Team, and the approved row retains `Confirm System Updated`. | NOT RUN |
| S3 | On a disposable automatic Name Change or Withdrawal request, League Admin guidance says approval applies the change, approval performs that existing effect, and the detail reports that LMSPro already applied it. | NOT RUN |
| S4 | A mixed automatic/manual selection reports truthful counts and named manual tasks without losing selection; row-click Variation and Free Day modals retain the accepted responsive width and Free Day Save/action hierarchy. | NOT RUN |

## 7. Stop Rules

Any misleading automatic/manual wording, current/retired/out-of-scope option, mismatched stored
label, manual Team mutation, missing automatic mutation, lost selection, stale UI after action,
cross-tenant/season acceptance or unexpected notification is a blocker. Record the row `FAIL` and
return R14-A to implementation.
