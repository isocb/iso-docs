# IsoStack Working Method Specification

Purpose: define the durable human-and-AI method for turning an idea, fault or obligation
into a controlled IsoStack release without allowing the portfolio to become an unranked
list of competing work.

Version: 4.1

Last updated: 2026-08-05

Status: Authoritative working-method protocol. Product and Platform roadmap authority is
held by the root and child roadmap files named below, not by this method document.

## 1. Core Principle

IsoStack uses one portfolio with three operational product/Platform lanes:

1. Platform;
2. LMSPro / SeasonPro; and
3. FUND.

Commerce Core is a separately controlled shared dependency lane. It enters the same serial
portfolio queue when selected, but it is not a fourth product backlog requiring daily
attention.

The method separates four things that must never be confused:

- capture records a need;
- triage decides its treatment;
- roadmap selection decides when it may proceed; and
- lifecycle evidence proves what was planned, built, tested and released.

A document existing is not evidence that its proposed work was accepted or completed.

## 2. Authority And Mandatory Reading Order

Before selecting or resuming substantive work, a human or AI assistant must read:

1. the current section of the root roadmap:
   `docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`;
2. Section 0/current-control material in the owning child roadmap;
3. the exact accepted triage, slice plan, confirmation and review records for the selected
   slice; and
4. the current repository state and relevant source files.

The authoritative child roadmaps are:

- Platform:
  `docs/platform/00-roadmap-control/2026-07-22-isostack-platform-roadmap-and-slice-control.md`;
- LMSPro / SeasonPro:
  `docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`;
- FUND:
  `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`.

Authority order is:

```text
root roadmap for cross-lane Now/Next
-> owning child roadmap for lane inventory and disposition
-> accepted bounded slice plan for implementation scope
-> implementation confirmation for what changed
-> review/test record for what was proved
```

Historic plans, CR wording, chat summaries and printable summaries are context only when
they conflict with a current authoritative control.

## 3. Portfolio Attention Limits

The default solo-developer limit is:

```text
NOW  = one active portfolio outcome
NEXT = one named candidate
```

No child lane may create a second portfolio `Now` or independently promote itself to
`Next`. The root roadmap owns that decision.

New ideas and defects are captured without interrupting `Now`. They displace `Now` only
when the control owner explicitly accepts an expedite proposal, normally for a live
security, privacy, tenancy, data-integrity or severe operational failure.

Everything else receives a disposition and stops consuming active attention until it is
selected.

### 3.1 CR-Fix Remedial Control

`CR-Fix` is the mandatory prefix for a CR whose primary purpose is to correct a defect,
regression or unsafe operational behaviour. It is a treatment within the owning Platform,
LMSPro / SeasonPro or FUND lane, not a fourth roadmap, a permanent fast lane or authority
to bypass triage.

Use the prefix in the document title and filename, for example:

```text
CR-Fix-YYYY-MM-DD-<lane>-<bounded-remedial-outcome>.md
```

Every `CR-Fix` records:

- the affected environment and whether the behaviour is a regression;
- severity, user and tenant impact, time sensitivity and available workaround;
- containment already applied;
- reproducible evidence and the last known good boundary where available;
- security, privacy, tenancy, data-integrity, delivery and rollback risks;
- whether an expedite is proposed, accepted or rejected; and
- the safe resumption point for any work it may displace.

`CR-Fix` does not mean `Now`. It becomes `Now` only through an explicit root-roadmap
expedite or ordinary selection decision.

## 4. Change-Request Capture Contract

A CR is a structured input, not an instruction to code. It should contain enough evidence
for another person or AI session to understand:

- the problem or opportunity;
- the affected users, tenants, roles and module;
- observed and desired behaviour;
- evidence, examples and known scale;
- risk, especially security, privacy, tenancy and data integrity;
- decisions already made;
- unresolved questions and assumptions; and
- explicit non-goals.

Whenever a new CR is created:

1. place it in the owning lane's `01-cr-inputs` folder;
2. add a direct source link to the owning authoritative child roadmap in the same
   documentation change;
3. give it an explicit disposition, usually `captured; awaiting triage`;
4. update the root roadmap only if ownership/dependency, expedite status or portfolio
   `Now`/`Next` changes; and
5. do not start implementation merely because the CR has been registered.

For a remedial input, apply the same contract using the `CR-Fix` prefix and include the
risk/containment fields in Section 3.1. Cross-link, but do not overwrite, an older feature
or capacity CR when a live regression reveals a different problem from the intended
enhancement.

Later lifecycle decisions update that same inventory row. A CR must not remain mentally
"open" merely because an old document exists.

## 5. Controlled Delivery Lifecycle

Non-trivial features, faults and refinements use:

```text
observation or obligation
-> 01 CR input and child-roadmap registration
-> 02 triage and ownership decision
-> root roadmap selection
-> 03 bounded slice planning
-> implementation in the owning repository
-> 04 implementation confirmation
-> 05 independent review and test
-> required human or operational gate
-> child/root roadmap reconciliation
-> controlled dev, staging and live promotion
```

An accepted urgent remedial interrupt uses the same evidence lifecycle in compressed
form:

```text
contain unsafe operation
-> CR-Fix capture and child-roadmap registration
-> explicit expedite triage and root decision
-> bounded remedial slice plan
-> implementation and proportionate automated review
-> controlled staging reproduction and correction proof
-> live promotion and non-destructive operational verification
-> child/root reconciliation and displaced-work resumption
```

Urgency may shorten documents and decision latency. It does not remove tenant-safety,
rollback, review, staging or operational-evidence gates. Direct production hotfixes remain
exceptional live-down/security containment actions governed by the branch and promotion
rules; most `CR-Fix` work still travels through `dev -> staging -> live`.

Each stage has one job:

- CR: preserve need and evidence.
- Triage: accept, reject, defer, split, classify or move the work.
- Root selection: decide whether it is `Now`, `Next` or parked.
- Slice plan: define exact goal, boundaries, risks, tests, data/permission impact and
  `Do Not Build` constraints.
- Implementation: change only the accepted boundary.
- Confirmation: record the actual files, behaviour and checks; do not repeat aspirations.
- Review/test: independently assess behaviour and state PASS, FAIL or a precise pending
  gate.
- Reconciliation: update the CR disposition, slice state, environment state and portfolio
  handoff before selecting more work.

Trivial corrections may use a proportionate abbreviated record only when the owning
roadmap already authorises them and no tenancy, permission, schema, security, privacy or
deployment risk is involved.

## 6. Defects Discovered During Active Work

When a defect is found while completing `Now`:

- If it is inside the accepted outcome and bounded acceptance criteria, correct it within
  that slice and record the evidence.
- If it is a severe live security, privacy, tenancy, data-integrity or time-critical
  operational issue, contain it, create/register a `CR-Fix` and present an explicit
  expedite proposal to root control.
- Otherwise, create/register a CR, give it a disposition and return to `Now`.

This rule prevents every discovery from becoming an unscheduled context switch while
still allowing genuine incidents to interrupt deliberately.

### 6.1 Remedial Severity And Treatment

| Condition | Treatment |
| --- | --- |
| Inside the accepted active-slice outcome | Correct within that slice and record it; create a separate `CR-Fix` only if scope, risk or ownership expands materially |
| Fault with a safe, acceptable workaround and no immediate severe harm | Register `CR-Fix`; triage and park/select through the ordinary queue |
| Reproducible live regression blocking a time-critical/core operation, with no safe complete workaround | Register `CR-Fix` and propose an urgent operational expedite |
| Active security, privacy, tenancy or data-integrity exposure | Contain immediately and propose an expedite; do not wait for a full document before stopping unsafe operation |
| Live-down condition requiring direct production correction | Use the exceptional hotfix authority only when explicitly accepted, then back-merge, review and reconcile immediately |

A workaround is not safe merely because it avoids the error. Excluding intended recipients,
creating duplicate communications, weakening tenant boundaries, bypassing evidence or
requiring manual data repair counts as residual operational risk.

### 6.2 Root Portfolio Interrupt And Resumption

When root control accepts an expedite, do not run two active outcomes. Reconcile the root
pair as:

```text
NOW  = accepted CR-Fix remedial outcome
NEXT = resume the displaced former Now from its recorded safe point
```

The former `Next` remains registered in its child roadmap but temporarily ceases to be the
formal portfolio `Next`. When the `CR-Fix` closes or is safely re-disposed, resume the
displaced outcome and restore/reconsider the prior sequence explicitly. Record this both
when the interrupt begins and when it ends.

### 6.3 CR-Fix Scope Discipline

One `CR-Fix` may collect closely related evidence, but triage must distinguish:

- the minimum incident-ending slice;
- coupled correctness work required for safe operation; and
- non-blocking refinements that must not enlarge or delay the expedite.

Do not attach unrelated improvements to an urgent correction. Link them as follow-on
dispositions or separate CRs.

### 6.4 Worked Method Example — Cohort Email Draft Persistence

The 2026-08-05 LMSPro cohort-email fault is the reference operational example:

- Save Draft succeeds for smaller or simpler cohorts but fails for larger overlapping
  manager/Club-secretary audiences;
- the failing request is `communications.emails.create` or `.update`, before provider send;
- a controlled 411-recipient Save Draft returned HTTP 500 after 5.92 seconds against a
  five-second default interactive-transaction deadline;
- the current Email-to-Club writer creates Club visibility rows sequentially and the update
  path deletes/rebuilds its recipient/visibility graph;
- the generic resource catch conceals the database failure as a file-retention message;
- a `BOTH`-scope role is also represented under League and Club role trees while checkbox
  identity is keyed only by role ID; and
- ordinary body/footer links are not file resources, while the dedicated external-link
  control is currently included in the acknowledgement gate despite the clarified
  attachment-only policy.

The method treats this as a new LMSPro `CR-Fix`, cross-linked to but distinct from the
500-recipient operating-envelope refinement. The minimum expedite candidate is scalable,
atomic draft persistence plus safe error evidence. Selector correctness is coupled when it
can alter the intended audience. Link-gating policy is a bounded follow-on unless accepted
planning proves it safe and inseparable. No provider send is required to reproduce or
accept the draft-persistence correction.

## 7. AI Session Start Contract

At the start of a new AI work session, the assistant must:

1. identify whether the request is capture, assessment, triage, planning, implementation,
   review/test, promotion or reconciliation;
2. read current authoritative files rather than relying on chat memory or cached content;
3. inspect the current repository/worktree and preserve unrelated human changes;
4. state the governing `Now`/`Next` and whether the requested action has authority;
5. follow capability ownership, not merely the UI route or source-file location; and
6. work only within the requested and authorised boundary.

For a `CR-Fix`, the assistant must additionally state whether it is capturing evidence,
proposing/recording an expedite, implementing an already accepted remedial slice or closing
the interrupt. It must not interpret the `CR-Fix` prefix as implementation authority.

When direct workspace access exists, the assistant should inspect the current files
itself. When it does not, it should ask for the relevant current content rather than invent
line numbers or assume an old version.

An AI assistant may recommend a disposition or an expedite proposal. It must not silently
self-authorise implementation, change portfolio `Now`/`Next`, infer missing human evidence
or claim a deployment it has not verified.

## 8. AI Session Completion Contract

Before handing work back, the assistant should record or report:

- the outcome achieved and exact boundary;
- files or records changed;
- checks performed and their results;
- human, environmental or deployment gates still pending;
- the CR's current disposition and slice state;
- whether the owning child roadmap requires reconciliation; and
- whether the root `Now`/`Next` changed.

For an expedited `CR-Fix`, also report containment state, live verification, rollback
readiness and the exact displaced-work resumption point.

If work stops mid-slice, state the safe resumption point. Do not convert incomplete work
into a completion claim.

## 9. Engineering And Safety Rules

- Read the real architecture and current dependency versions; do not rely on version lists
  embedded in old planning notes.
- Preserve tenant scoping and enforce permissions server-side as well as in the UI.
- Treat schema, migration, live data, credentials and destructive actions as explicit
  high-risk boundaries.
- Use the repository's safe database workflow and migration conventions; do not make an
  unrecorded live schema change.
- Keep unrelated work out of a bounded slice and out of its commit.
- Run checks in proportion to risk, including authenticated tenant-isolation and human UI
  evidence where required.
- Never record secrets, access tokens, complete personal data or sensitive database output
  in lifecycle documents.

## 10. Branch And Promotion Language

Use the plain-English corridor:

```text
local work branch -> dev -> origin/dev -> staging -> live
```

Say exactly where work is. Avoid the word `staged` unless referring to the Git index.
Promotion does not prove behaviour by itself; retain the required review, human and
operational evidence.

See `docs/core/how-we-work-addendum.md` and `docs/guides/git-workflow.md`.

## 11. Human Control Cadence

Use a brief portfolio control review to:

1. close or accurately re-dispose finished work;
2. confirm one `Now` and one `Next`;
3. triage only enough captured CRs to protect the next decision;
4. identify blocked human evidence separately from unimplemented work; and
5. refresh the printable summaries when their source roadmap materially changes.

The full portfolio does not need to be held in working memory. The root and child roadmap
inventories are the memory system.

## 12. Companion Plain-English Guide

For the short human version of CR addition and delivery, read:

`docs/00-roadmap-control/2026-08-05-human-guide-change-request-to-release.md`
