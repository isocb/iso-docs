# SeasonPro — Import/Export Authority And Free Day Email Dates: Single Slice Plan

Date: 2026-09-17
Status: **COMPLETE AND CLOSED — exact `c3998084` production technical proof and Chris’s live acceptance PASS; see the 05 review.**
Control depth: **High** for import/export authority; date-format proof remains focused.
Work type: bounded production correction, not an infrastructure experiment.
Baseline reviewed: application `d13ecb39`; recheck current branch/ancestry before implementation.
[CR-Fix](../01-cr-inputs/CR-Fix-2026-09-17-seasonpro-import-export-authority-and-free-day-email-dates.md) · [Triage](../02-triage/2026-09-17-seasonpro-import-export-authority-and-free-day-email-dates-triage.md)

## Outcome And Boundaries

A C1 with an assigned Import or Export component can complete that operation without being
made an Owner. A C1 without that grant cannot invoke it through a direct API call. Free Day
emails display `18/10/2026` for `2026-10-18T00:00:00.000Z`, without changing the stored date.
Deliver these two outcomes together, with one 04 confirmation and one 05 review/smoke record.

No migration, automatic role assignment, new permission UI or service configuration is
planned. Preserve existing imports, mappings, audit evidence, sent emails and source dates.

## 1. Import/Export Implementation Contract

Primary files: `src/server/core/routers/import.router.ts`, existing import/export pages and
job-history UI, plus a narrowly scoped authority helper/test. Review dashboard card wiring
in `src/modules/lmspro/components/dashboard/DashboardActionCards.tsx` and existing effective
identity/RLS handling before changing it. Reuse existing definitions and role data.

| Procedures | Required authority |
| --- | --- |
| createJob, listJobs, getJob, getMapping, getJobMappings, validateData, executeImport | C1 plus explicit `data.import` grant |
| export | C1 plus explicit `data.export` grant |
| deleteJob, rollback | Existing core OWNER restriction and tenant/state guards |
| updateJobStatus | Retain existing OWNER restriction; not a delegated wizard operation |

C1 means the existing OWNER/ADMIN organisation authority. Treat both equally for normal
operations: an explicit component grant is still required. Do not replace OWNER with a
blanket OWNER/ADMIN allowlist, and do not use `hasComponentAccess` unchanged because it
bypasses grants for those roles. No new global P1/Owner bypass is part of this slice.

The predicate must read the effective actor and tenant from the established context,
verify their valid relationship, and resolve active applicable SeasonPro role grants plus
the enabled component definition. Respect tenant overrides and legitimate module-global
roles; reject another tenant's role IDs or Club-only role grants for these league-wide
operations. Follow existing enabled/timing visibility semantics where applicable so a
visible-but-unusable card or a hidden-but-authorised direct route is not the intended outcome.
Do not redesign the shared role resolver: if a general defect is unavoidable, stop and
report the smallest additional boundary with its value and alternative.

Use the same authority result for the Import/Export pages and card eligibility. Show a
clear access message before upload/validation or export work begins. On the jobs screen,
show rollback/delete controls only when the existing destructive-operation permission holds.
Server enforcement remains authoritative even with a stale page or revoked grant.

Resolve target organisation consistently for queries, handler context and audit entries;
do not combine effective-user authorisation with another user's session organisation.
Validate supplied season/Club/age-group identifiers and existing job/mapping ownership
before expensive work. Preserve the existing handler's entity validation, audit and dry-run
behaviour; no new entity types or widening of Club-level access. Review every registered
handler touched by the shared router and its actual UI consumers before editing.

Failure behaviour: absent/disabled/revoked grants and invalid effective context refuse before
writes or export serialization. Foreign identifiers yield no data or side effects. A
forbidden destructive action leaves the job and mappings unchanged. Ordinary import errors
retain current reporting; do not expand this into an import-engine redesign.

Known adjacent limitation: current rollback deletes mappings and marks the job rolled back;
it does not implement generic imported-entity deletion despite its broad success wording.
Do not extend or rely on it as recovery for this slice. Preserve its Owner-only boundary;
flag any necessary truthful wording correction during implementation review.

## 2. Free Day Date Presentation Contract

Primary files: `src/modules/lmspro/communications/notification-templates.ts`, existing Free
Day template tests, notification preview caller and the date-only helper in `src/lib/timezone.ts`.

For Free Day requested/approved/rejected/cancelled notifications, prepare a presentation
copy of template data with `requestedDate` formatted through the existing date-only utility
using `dd/MM/yyyy`. Apply it consistently to default and custom subject, HTML and plain-text
outputs, and to preview where that variable is rendered. Avoid double formatting: default
and custom paths should share one clearly defined formatting boundary, not parse an already
formatted DD/MM/YYYY string back into Date.

Do not mutate the incoming event object or persisted date, change scheduling/eligibility,
or edit stored custom templates and historical sent messages. Preserve disabled-notification
behaviour, existing recipient routing and every other shortcode.

Use blank for missing/invalid real values; never emit Invalid Date or the raw ISO value as
an error fallback. Preserve the literal `{{requestedDate}}` in the template-editing preview
when it deliberately represents an unresolved placeholder. Test valid calendar dates and
avoid timezone conversion that changes the requested day. No global locale redesign.

## 3. Focused Proof

Automated authority matrix, using existing test conventions and synthetic tenant fixtures:

- OWNER and ADMIN with import-only, export-only, both and neither grant; revoked/disabled
  role/component; applicable tenant/module-global versus foreign/Club-only roles.
- C2/member cannot gain league-wide access by a stray grant; signed-out requests refuse.
  Effective-user/tenant impersonation follows existing rules, with no platform-only bypass.
- Direct API calls respect exactly the same authority; both export formats are covered.
- Own-tenant job/season/Club identifiers succeed; foreign job/mapping/filter identifiers
  refuse without write/export side effects. Trace each normal/helper procedure in the table.
- ADMIN cannot rollback/delete or directly mutate job status. Retained Owner paths preserve
  current tenant/state guards. Use disposable fixtures only for destructive-path tests.

Date proof: all four Free Day events, default/custom subject/HTML/text, supplied ISO example,
zero-padding, representative DST/timezone boundaries, missing/invalid values and intentional
preview placeholders. Assert input unchanged and disabled notifications remain disabled.

Run focused tests, TypeScript, critical-file verification and changed-file lint. Run the
relevant existing import-handler and notification regressions; build the combined candidate
before promotion. Use isolated/disposable data for connected authority proof where mocks
cannot establish RLS/context behaviour. Do not import, export personal data or send mail on
live merely to test this change. Record exact evidence and any unrun check honestly.

Short staging human smoke after automated proof:

1. Delegated C1 with the relevant grant completes one tiny synthetic import and one export;
   removal of each grant removes access. Import/export-only grants remain independent.
2. Delegated C1 has no rollback/delete controls and direct calls refuse; approved Owner
   controls remain available. Confirm a second tenant cannot access the fixture.
3. Preview default and customised Free Day emails: Requested Date is DD/MM/YYYY in applicable
   subject/body outputs. Confirm original requested day and stored value are unchanged.

Do not repeat the entire role/platform smoke matrix. Live proof is limited to normal
login and authorised page loading, with Chris’s acceptance of date presentation based on live
evidence; no bulk live mutation. Closure correction: notification emails have no user-facing
preview. The earlier proposed preview smoke was incorrect and is not claimed as performed.

## 4. Delivery And Recovery

Implementation approval also requires reconciling the single root Now/Next selection with
this SeasonPro resumption and preserving FUND's existing checkpoint. The 05 review records closure; FUND’s existing B1 plan resumes the active restart checkpoint and preserves the previous release evidence. The production OOM investigation is not included
or claimed resolved by this work.

After implementation, complete one 04 confirmation and one 05 review/test record, retaining
High-control authority negatives and the short human checks. Review must explicitly consider
effective identity, grant revocation, cross-tenant filters and destructive actions. Do not
claim an independent reviewer if only self-review occurred.

Promote the exact accepted candidate through dev and staging; main requires human staging
acceptance and explicit live approval. No schema migration or environment toggle is expected.
A compatible code rollback can restore the old Owner-only behaviour if necessary, but must
not delete legitimate imported rows, replace mapping evidence, or rewrite sent emails.

Stop only for material scope expansion: unavoidable shared-role policy change, ambiguity
about tenant/impersonation authority, schema/data repair, wider handler consumers, or an
unresolved destructive-operation consequence. Explain the client value and simpler choice.
No new dashboards, permission framework, provider calls, OOM fix or bulk cleanup belongs here.

## Implementation handoff

[04 confirmation](../04-implementation-confirmations/2026-09-17-seasonpro-import-export-authority-and-free-day-email-dates-implementation-confirmation.md) and [05 local smoke/review](../05-review-and-test/2026-09-17-seasonpro-import-export-authority-and-free-day-email-dates-review-and-test.md) record delivered behaviour and outstanding evidence. Subsequent staging acceptance and live authority supersede the original local-only boundary; the 05 review records exact production proof and Chris’s live acceptance and closure. Rollback wording is corrected to describe mapping removal truthfully; the destructive engine is unchanged.
