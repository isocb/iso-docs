# LMSPro CR-Fix F1/F2 — Staging Readiness And Human Smoke Schedule

Date: 2026-08-05

Status: **F1 HUMAN STAGING SMOKE PASS; F2 HUMAN STAGING SMOKE FAIL; LIVE PROMOTION
BLOCKED; F2.1 REPLACEMENT PLANNING COMPLETE AND AWAITING ACCEPTANCE**

Implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-05-lmspro-cr-fix-f1-f2-cohort-email-draft-persistence-and-audience-selection-local-confirmation.md`

Accepted plan:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f1-f2-cohort-email-draft-persistence-and-audience-selection-planning.md`

Replacement F2.1 plan:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f2-1-cohort-taxonomy-and-picker-correction-planning.md`

## 1. Exact Promotion Boundary

```text
recovery baseline: 7154937cb620232b457b19d09c5dc97ae0417a73
F1/F2 implementation commit: 07a719061358a1706ad8f5fcc7bfd5b9a4d9d32c
commit subject: fix(communications): harden bulk cohort draft persistence
origin/dev: 07a719061358a1706ad8f5fcc7bfd5b9a4d9d32c
local staging: 07a719061358a1706ad8f5fcc7bfd5b9a4d9d32c
origin/staging: 07a719061358a1706ad8f5fcc7bfd5b9a4d9d32c
origin/main/live: 7154937cb620232b457b19d09c5dc97ae0417a73
schema/migration delta: none
database action: none beyond Render's normal idempotent migration-ledger path
F3 included: no
```

The staging promotion was an exact fast-forward from `7154937` to `07a71906`. The commit
contains only the six reviewed F1/F2 application/test files. The user's pre-existing local
elective-mail documentation edit was not staged, committed or promoted.

## 2. Automated And Platform Gates


| Gate | Result |
| --- | --- |
| Focused F1/F2 tests | PASS — 15 |
| Communications/LMSPro communications tests | PASS — 83 |
| Full Vitest suite | PASS — 279; 12 intentionally skipped |
| Type check | PASS |
| Repository verification | PASS |
| Supported Node 22 production build | PASS — 131/131 static pages |
| Changed production-file ESLint | PASS — zero errors; five pre-existing router warnings |
| Diff check | PASS |
| Exact dev Security Scan | PASS — run `31008244442` |
| Exact staging Security Scan | PASS — run `31008469488` |
| Public staging health | PASS — healthy; database connected; RLS 11/11 |

Public health was confirmed at `2026-08-05T13:06:52.393Z` from
`https://staging.seasonpro.co.uk/api/health`.

Render's exact displayed commit was not available through the public health response. Confirm
`Live at 07a7190` in Render before beginning the mutation smoke.

## 3. F3 Inclusion Decision

F3 was deliberately excluded. Source review confirms it is not a trivial one-condition UI
change: it affects compose-time gating, create/update acknowledgement persistence,
duplicate-to-draft state, send-time readiness and the standalone delivery path. Focused
readiness coverage must be added before changing that policy.

The cost of another Render build is lower than the risk of coupling an unproved attachment/
link policy change to the urgent persistence correction. F3 remains the immediate follow-on
under the same open CR-Fix.

## 4. Human Staging Smoke — Safety Preconditions

| Precondition | Result |
| --- | --- |
| Render staging displays exact `Live at 07a7190` | PASS |
| Chrome DevTools Network used with controlled content | PASS |
| Save Draft used without provider Send as acceptance | PASS |

No provider-delivery claim is made by this review.

## 5. Human Staging Smoke — F1 Draft Persistence

| Boundary | Result |
| --- | --- |
| No-recipient draft | PASS |
| Single age-group Team Managers + Club Secretaries | PASS |
| Smaller passing-shape equivalents | PASS at 86 and 134 recipients |
| Former failing-shape equivalent | PASS at 195 recipients |
| Broad business-shape equivalent | PASS at 425 recipients |
| Maximum staging audience available | PASS at 440 recipients |
| Create and update | PASS |
| Reopen with stable displayed count | PASS |
| No visible partial or duplicate draft/history evidence | PASS |
| Broad-case server wait | PASS — 341 ms against the 30-second ceiling |

The staging dataset contains a maximum of 440 applicable recipients, so a literal 500-row
human case was unavailable. The 440 result is draft-persistence evidence only and does not
establish 440 or 500 provider-delivery support.

### F1 Human Verdict

**PASS.** The control owner reports all F1 human staging checks green. The former
broad-cohort Save Draft failure was not reproduced, and the measured 341 ms server wait
retains substantial transaction headroom.

This is the human staging verdict for F1. It does not convert any separately pending
database fault-injection or authenticated isolation evidence into a human pass unless that
evidence is recorded in its own technical review.

## 6. Human Staging Smoke — F2 Typed Role Selection

### Observed Result

**FAIL.** The application behaved according to F2's automated contract, but that contract
was based on a fundamental product-model misunderstanding:

- `BOTH` was treated as one SeasonPro role rendered independently under League Roles and
  Club Roles;
- the two misleading representations could be checked separately;
- the tested entries did not add the expected recipients;
- category/role indentation and missing-checkbox presentation were confusing; and
- the picker conflated C1/C2/hat-swap access context with functional League and Club roles.

The control owner clarified that C1, C2 and C1+C2 hat-swap are dashboard/access states.
The hat-swap state exists so an authorised League administrator/owner can enter the Club
view to support a Club. It is not two independent recipient roles.

The original F2 acceptance test is therefore rejected, not merely failed by the code. The
replacement F2.1 plan removes access-mode entries from functional role cohorts and gives
the recipient-type modifier its true Division/Age Group scope.

## 7. Additional UX Finding — Recipient-Type Placement

`Include recipient types` currently appears to govern the whole cohort picker. Source
review confirms that it is submitted only with Division and Age Group filters. It does not
affect Clubs, League Roles, Club Roles or the other cohort types.

Disposition: accepted into F2.1. The control must be visually aligned with the Division/Age
Group cohort selection it modifies and must not imply a global effect.

## 8. Combined Review Verdict And Promotion Decision

```text
F1 broad-cohort draft persistence: PASS
F2 typed BOTH-role independence: FAIL — acceptance model rejected
Combined F1/F2 release: FAIL
Main/live promotion: BLOCKED
Replacement action: F2.1 local implementation/technical gates PASS; commit/push to hosted
dev only when authorised, then repeat role/recipient-type smoke
F3: remains a separate immediate follow-on
```

Commit `07a71906` must not be promoted to main/live in its current form. F1 should be
retained; F2.1 should replace the rejected F2 behaviour in a bounded follow-up commit on
`dev`, then the combined candidate must return to staging for focused human review.

## 9. Successor Reconciliation

F2.1 subsequently passed all ten control-owner local human checks, was committed as
`9974eed5` and was fast-forwarded exactly to dev/staging. Both exact Security Scans and
public staging health pass. The active gate is now:

`docs/modules/lmspro/05-review-and-test/2026-08-05-lmspro-cr-fix-f2-1-staging-final-human-smoke.md`

This successor does not rewrite the truthful F2 FAIL verdict above.
