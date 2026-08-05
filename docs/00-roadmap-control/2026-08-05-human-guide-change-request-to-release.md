# Human Guide: From Change Request To Released Change

Date: 2026-08-05

Purpose: explain, in plain English, how a new idea, defect or improvement enters the
IsoStack development process without taking over the current work.

This guide explains the method. It does not choose work or replace the authoritative root
and child roadmaps.

## The Short Version

```text
Write it down
-> register it
-> decide what it is
-> choose when to do it
-> plan a small slice
-> build only that slice
-> record what changed
-> review and test it
-> promote it safely
-> update the roadmaps and close or re-dispose it
```

The important distinction is simple: **a recorded CR is safely remembered, not
automatically scheduled**.

For remedial work, use the prefix `CR-Fix`. It means “this CR corrects a fault or
regression”; it does not by itself mean “start immediately”.

## Adding A CR

Put the CR in the `01-cr-inputs` folder for the capability that owns the change:

- Platform for shared tenancy, authentication, organisation administration, shared
  services and Platform UI;
- LMSPro / SeasonPro for league, Club, season, participation and module communications;
- FUND for fundraising Project, Store, artwork, production and commission behaviour; or
- Commerce Core for generic checkout, Order, money and payment contracts.

Ownership follows the capability, not just the screen or file where the issue appeared.

A useful CR answers:

1. What happened, or what outcome is wanted?
2. Who is affected: P1, C1, C2, another role or all tenants?
3. What should happen instead?
4. What evidence or examples are available?
5. Is tenancy, permission, privacy, security, data integrity or live operation involved?
6. What decisions are already settled?
7. What remains unknown?
8. What is explicitly outside this request?

Unresolved numbers or decisions may remain marked as unresolved. Do not invent certainty
to make the CR appear complete.

### Adding A CR-Fix

Name a remedial CR:

```text
CR-Fix-YYYY-MM-DD-<lane>-<short-remedial-outcome>.md
```

In addition to the ordinary CR questions, record:

1. Is this live, staging or development only?
2. Is it a regression and what is the last known good evidence?
3. What operation is unavailable or unsafe?
4. Is there a complete and safe workaround?
5. What has been stopped or contained?
6. What could be harmed by the correction itself?
7. Is an expedite proposed, accepted or rejected?
8. If it interrupts current work, where will that work safely resume?

Keep the `CR-Fix` in the normal owning lane. Do not create a separate remedial roadmap.

## Registering It

In the same documentation change, add a direct link to the CR in its authoritative child
roadmap and give it a current disposition. The normal starting disposition is:

```text
Captured; awaiting triage. No implementation authority.
```

This removes the need to remember the CR personally. It is now in the portfolio inventory,
but it has not displaced current work.

Update the root roadmap only if the CR changes cross-lane ownership or dependencies,
creates an expedite proposal, or changes the one portfolio `Now` and `Next`.

If the new record is a `CR-Fix`, the child inventory row must say whether it is routine,
an expedite candidate or an accepted expedite. `Urgent` without an explicit root decision
does not authorise implementation.

## Deciding What Happens To It

Triage gives the CR one explicit treatment, for example:

- accepted for bounded planning;
- split into smaller CRs or slices;
- awaiting evidence or a human decision;
- parked for later;
- rejected with a reason;
- completed by existing work; or
- proposed as an expedite because a severe live risk justifies interruption.

`Parked` is a valid managed state. It means the item remains findable without consuming
daily attention.

## When A Remedial Fault Needs Immediate Attention

Use this decision:

| Situation | What to do |
| --- | --- |
| The fault is already inside the accepted active outcome | Correct it within that slice and record it |
| A safe workaround exists and no severe harm is continuing | Register `CR-Fix`; triage it normally |
| A live core operation is reproducibly blocked and the workaround omits users, duplicates actions or weakens safety | Register `CR-Fix` and propose an urgent operational expedite |
| Security, privacy, tenancy or data integrity is actively exposed | Contain first, then complete expedited `CR-Fix` control |
| The live service is down and cannot wait for the normal corridor | Use an explicitly approved hotfix, then immediately back-merge, review and reconcile |

An accepted expedite temporarily becomes the only `Now`:

```text
NOW  = accepted CR-Fix
NEXT = resume the work that the CR-Fix interrupted
```

The old `Next` remains recorded but waits. When the correction closes, resume the
interrupted work and deliberately restore or reconsider the previous order.

The fast remedial lifecycle is:

```text
contain
-> CR-Fix and roadmap registration
-> explicit expedite decision
-> small correction plan
-> build and review
-> staging proof
-> live verification
-> close CR-Fix and resume displaced work
```

This is faster because scope and decisions are concentrated, not because evidence is
skipped.

## Choosing It

The root roadmap holds only:

```text
NOW  = the one outcome currently being finished
NEXT = the one candidate prepared to follow it
```

A child roadmap cannot independently start work. The control owner selects or changes
`Now` and `Next` explicitly.

## Planning A Buildable Slice

Before non-trivial implementation, create an accepted `03-slice-planning` document. It
should define:

- one clear outcome;
- scope and `Do Not Build` boundaries;
- affected roles, tenants and permissions;
- schema, migration, privacy and security impact;
- implementation split;
- automated and human test expectations; and
- stop conditions and dependencies.

Large CRs may produce several slices. Only the selected slice is active.

## Building, Proving And Releasing

Implementation changes only the accepted slice. Then:

1. `04-implementation-confirmations` records what was actually changed and checked.
2. `05-review-and-test` independently records PASS, FAIL or an exact pending gate.
3. Required authenticated, tenant-isolation, browser, data or operational tests are
   completed by the appropriate human or environment.
4. Work moves through the plain-language corridor:

   ```text
   local work branch -> dev -> origin/dev -> staging -> live
   ```

5. Promotion and live operation are not claimed without evidence.

## Closing The Loop

At the end of a cycle:

- update the CR inventory row with its real disposition;
- update the slice and environment state in the child roadmap;
- record any remaining human gate as pending rather than complete;
- update the root if `Now` or `Next` changed;
- refresh the relevant printable summary; and
- choose new work only after the previous control state is clear.

## When Another Fault Appears Mid-Work

- Inside the accepted outcome: correct it within the active slice and record it.
- Severe live security, privacy, tenancy, data-integrity or time-critical operational risk:
  contain it, create/register a `CR-Fix` and propose an explicit expedite.
- Everything else: register a CR, give it a disposition and return to `Now`.

This is the protection against being swamped: **capture broadly, work narrowly**.

## Worked Example: SeasonPro Cohort Email Draft Failure

On 5 August 2026, controlled Save Draft testing established that small SeasonPro cohorts
could be persisted while larger combined manager/Club-secretary cohorts failed before any
provider send. A 411-recipient Save Draft returned HTTP 500 after 5.92 seconds. The draft
transaction uses a five-second default deadline and sequentially materialises the new
Email-to-Club audience, while the UI reports an unrelated file-retention message.

This was accepted as an urgent operational `CR-Fix` expedite because:

- it is a reproducible live regression in a core communication operation;
- splitting cohorts risks duplicate messages to overlapping Club secretaries;
- removing Club secretaries omits intended recipients;
- no provider send is necessary to reproduce the fault safely; and
- bulk/transaction changes must preserve exact tenant and Club visibility boundaries.

The accepted urgent release is scalable atomic draft persistence, accurate safe error
evidence and regression proof at the real 411-recipient case plus the proposed 500-recipient
draft fixture (F1), together with the coupled role-selector/audience-correctness work (F2).
The clarified rule that only uploaded files require responsibility acknowledgement is the
immediate F3 follow-on unless it can be included safely without delaying F1.

## Where To Start

- Full working method: `../modules/<module>/work-method.md`
- Root portfolio control: `2026-07-13-isostack-platform-and-module-roadmap-control.md`
- Printable management summaries: `printable-summaries/`
