# CR-Fix — SeasonPro Import/Export Authority And Free Day Email Dates

Date: 2026-09-17
Owner: LMSPro / SeasonPro; shared Core Import/Export and Communications dependencies.
Status: **Triaged and implementation authorised; delivered on local dev, local human smoke and actual email-send PASS; staging deployed with security/health PASS; staging human acceptance and main/live approval pending.**
Proposed control depth: **High** for the combined request because element A changes bulk-data
and export authority. Element B is presentation-only; keep its proof proportionate.

[Owning roadmap](../00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md)

## A. Align Import/Export Operations With Component Grants

Chris reports that granting Import/Export card access does not enable delegated C1 use.
Source review at application `d13ecb39` confirms:

- Dashboard cards use `data.import` and `data.export` grants from SeasonPro module roles.
- Every operation in `src/server/core/routers/import.router.ts`, including job creation,
  listing, validation, execution and export, uses `requireRole([Role.OWNER])`.
- `requireRole` checks the effective user's core organisation role, not module components.
  A delegated C1 ADMIN with the component remains forbidden; an OWNER is not checked for
  the corresponding component by this API. The API and displayed delegation therefore differ.
- Communications already checks its corresponding SeasonPro component on the server.
  This is a reuse reference, not proof every other component has identical authority.

**Accepted outcome:** authorise normal import operations through `data.import` and normal
export through `data.export`, server-side as well as in the UI. Retain effective-user,
organisation/tenant boundaries and the appropriate league/entity scope. Do not simply add
all ADMIN users to the old allowlist or turn card visibility alone into server authority.

Triage must inventory normal/helper/internal procedures and shared handler consumers, and
make a separate explicit decision for destructive rollback and job deletion: Owner-only
protection is a candidate, not yet a decided removal or retention rule. Confirm any Owner/P1
bypass policy against the existing component model rather than inventing one. Do not permit
Club-scoped users to export league-wide data merely because a component was assigned.

Acceptance examples: a delegated C1 with only the import grant can use normal import but
not export; an export-only grant cannot import; absence/revocation of a grant refuses direct
API access; foreign-tenant jobs/data remain inaccessible. Card and page feedback agree with
server eligibility. Separately test the accepted rollback/deletion boundary and relevant
impersonation rules. These are required future checks, not current PASS claims.

## B. Present Free Day Email Requested Date As DD/MM/YYYY

Chris reports this email output from `{{requestedDate}}`:

| Field | Current reported output | Required output |
| --- | --- | --- |
| Requested Date | `2026-10-18T00:00:00.000Z` | `18/10/2026` |

**Accepted outcome:** retain the stored date/event value and date-only semantics. Format
`requestedDate` for email presentation as DD/MM/YYYY wherever used, including subject,
HTML and plain-text email, for the applicable Free Day notification events. Do not change
database storage, eligibility calculations, date comparisons or historical sent evidence.

Source lead: `src/modules/lmspro/communications/notification-templates.ts` formats Free Day
fallback templates through `formatFreeDayDate` (currently `d MMMM yyyy`), while the custom
subject/body branch interpolates the supplied data directly. Triage must cover both paths,
including existing customised templates and preview/send consistency. The exact tenant
customisation responsible for the reported email has not been inspected or reproduced.
Use the existing date-only presentation utility; do not introduce a new date-setting system.

Acceptance examples: the supplied ISO value renders as `18/10/2026` in default and custom
email outputs; day/month are zero-padded; the intended calendar day survives timezone/DST
boundaries; stored/event dates remain unchanged. Define safe missing/invalid-value behaviour
without leaking an ISO timestamp, producing Invalid Date or corrupting preview placeholders.
No real recipients should be contacted for automated proof.

## Impact, Containment And Risk

Affected environment: reported SeasonPro user/email behaviour in the current live context;
source baseline `d13ecb39`. Exact affected tenant/user scope remains for triage; no tenant-wide
reproduction or newly introduced regression is claimed. Last known good behaviour is unknown.

Severity: A blocks delegated administrative bulk-data work; B exposes a machine timestamp
instead of the intended readable date. Chris requests timely remediation as SeasonPro work
resumes, but no hard deadline or expedite selection is made by this capture.

Available workaround: an already authorised Owner can perform current Import/Export tasks;
do not elevate a delegated user to Owner as a workaround. The date can be read manually;
do not rewrite stored dates or resend historical mail. No containment/configuration change
has been applied.

Risks: widening data export/import across tenants or Club/league scopes, privilege escalation,
destructive rollback, and email date shifts. Preserve audit records, source data, recipient
boundaries and notification enable/disable behaviour. Prefer no schema migration; unexpected
schema or data-repair needs must be raised in planning. A later correction must preserve all
existing records; rollback must not undo legitimate imported data or rewrite sent email.

## Scope And Next Step

Proceed next to triage and a proportionate bounded plan within the existing lifecycle.
Keep these two elements distinct in acceptance and consider separate implementation slices
only where their different authority risks justify it. Simplicity is a requirement: explain
material extra gates or infrastructure to Chris with client value and a simpler alternative.

Do not build a new permission system, redesign the import engine or date storage, add billing
changes, or implement/deploy from this CR. The separate email-duplication/OOM investigation
is not silently included. No database writes, live communications, promotion or new portfolio
selection is authorised here.

Disposition: **captured; awaiting triage**. Expedite: not proposed or accepted by this record.
Root Now/Next remains unchanged; no work is displaced. If later selected, preserve FUND's
sole B1 restart checkpoint and accepted release evidence before changing portfolio control.

17 September follow-up: [triage](../02-triage/2026-09-17-seasonpro-import-export-authority-and-free-day-email-dates-triage.md) and [single plan](../03-slice-planning/2026-09-17-seasonpro-import-export-authority-and-free-day-email-dates-planning.md) now exist. They retain Owner-only destructive/internal operations and correct the earlier Communications comparison: its helper bypasses C1 grants, so it cannot be copied unchanged. Historical capture dispositions above are superseded by this planning state.
