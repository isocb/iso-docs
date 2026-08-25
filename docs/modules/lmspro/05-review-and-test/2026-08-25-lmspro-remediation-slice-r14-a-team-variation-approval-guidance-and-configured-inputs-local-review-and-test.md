# LMSPro Remediation Slice R14-A — Team Variation Approval Guidance And Configured Inputs Local Review And Test

Date: 2026-08-25

Review status: **R1-R6 CONTROL-OWNER RETEST PASS AT `0A6376A2`; PUBLIC ROLE-NAME CORRECTION
`66104E35` PASSES FOCUSED AUTOMATION; R7 WORDING CHECK NOT RUN; NOT READY FOR PUSH OR
PROMOTION DECISION**

Exact candidate: `66104e3576b06c0a532557e44e9b983921dbd5ac`; behaviour-smoke candidate
`0a6376a235dbb97109d894af574d9ef0546ead00` and initial failed candidate
`0700993b16fa83902327eb9e91aa5889e968a383` are superseded.

Files/change boundary: the shared Team Variation policy, configured target input/resolution,
C1-only operational guidance, C2 selectors, numeric Age Group sorting, Age-Group-scoped AGG list
and focused tests recorded in the implementation confirmation. No schema, migration, authority,
notification, automatic allocation or environment change.

Automated checks: **PASS** — exact wording candidate focused 36/36, TypeScript, verifier,
production-file lint with zero errors and whitespace. Its exact parent `0a6376a2` passed full 509
pass/12 skip and the 131-route build before the presentation-only role-name correction.

Human evidence: **PASS R1-R6 on `0a6376a2`** — direct control-owner observation, recorded row by
row below. The only resulting finding was that internal shorthand `C1` was rendered to users. Exact
`66104e35` replaces it with `League Admin`; R7 remains **NOT RUN** and is not inferred from
automation.

Environment proven: corrected source and automation on local branch
`fix/lmspro-variation-approval-guidance-inputs`. The control owner manages the browser-facing local
DevData server. No remote environment contains R14-A.

Known residual risk: the presentation-only replacement of internal `C1` shorthand with the public
role name `League Admin` requires one direct UI check. C1/C2 remain valid only in internal control
evidence, where C1 means League Admin and C2 means Club Secretary.

Next authorised action: refresh the control-owner-managed local application and run R7 only. Stop
on failure and return the wording delta to implementation. Do not push or promote without a later
explicit instruction.

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
messages to `League Admin` without changing behaviour.

The slice is not locally accepted until R7 directly confirms the public role name.

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
| R7 | User-facing guidance in both League Admin approval surfaces and the mixed-selection summary says `League Admin`, never the internal shorthand `C1` or `C2`. | NOT RUN |

## 5. Automated Evidence Detail

| Gate | Result |
| --- | --- |
| Policy matrix and bulk summary | PASS — all six types classified exactly once |
| Configured create/negative router checks | PASS — resolved snapshots and no-side-effect refusals |
| Single and mixed-bulk approval effects | PASS — two automatic, four non-mutating |
| Guidance surfaces, numeric order and scoped AGG options | PASS |
| Exact `66104e35` focused suite | PASS — 36/36, including a policy assertion that public follow-up text contains no C1/C2 shorthand |
| Exact `66104e35` TypeScript / verifier / whitespace | PASS |
| Exact `66104e35` production-file ESLint | PASS — zero errors; six pre-existing warnings |
| Parent `0a6376a2` full suite | PASS — 509 passed; 12 intentionally skipped |
| Parent `0a6376a2` production build | PASS — 131 routes; not repeated for the wording-only child while the control owner runs the local server |

## 6. Stop Rules

Any misleading automatic/manual wording, current/retired/out-of-scope option, mismatched stored
label, manual Team mutation, missing automatic mutation, lost selection, stale UI after action,
cross-tenant/season acceptance or unexpected notification is a blocker. Record the row `FAIL` and
return R14-A to implementation.
