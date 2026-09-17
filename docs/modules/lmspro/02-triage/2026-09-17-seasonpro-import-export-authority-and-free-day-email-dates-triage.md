# SeasonPro — Import/Export Authority And Free Day Email Dates: Triage

Date: 2026-09-17
Status: **COMPLETE AND CLOSED — exact `c3998084` production technical proof and Chris’s live acceptance PASS; see the 05 review.**
Control depth: **High** because delegated bulk import/export changes authority and data access.
Owner: SeasonPro, with bounded Core Import/Export and Communications changes.
[CR-Fix](../01-cr-inputs/CR-Fix-2026-09-17-seasonpro-import-export-authority-and-free-day-email-dates.md) · [Single plan](../03-slice-planning/2026-09-17-seasonpro-import-export-authority-and-free-day-email-dates-planning.md)

## Decision

Keep both accepted corrections in one slice: they are small, demonstrable changes with no
proposed schema, role-catalogue migration or provider change. Apply full relevant permission
negative tests to Import/Export and focused presentation tests to the date change. Do not
create two plans or a new permission framework.

A is a confirmed source-level inconsistency: component grants expose cards, but every Core
Import/Export procedure requires OWNER. B has a concrete source explanation: custom Free Day
email content interpolates raw data, while default templates format dates as `d MMMM yyyy`.
Both must display DD/MM/YYYY. Exact tenant reproduction remains for implementation evidence;
neither issue is established as a new regression from the FUND release.

**Correction to the earlier comparison:** Communications calls `hasComponentAccess`, but
that helper currently bypasses component grants for OWNER/ADMIN/platformAdmin. Copying it
unchanged would violate Chris's accepted decision. This slice needs a narrow explicit-grant
check; it must not change the shared helper or other modules' authority.

## Bounded Authority Decisions

- Normal Import/Export is available to C1 OWNER and delegated C1 ADMIN only when their
  active, applicable SeasonPro module role grants the corresponding component. Neither
  core role alone is sufficient. Existing C2/Club authority is not widened to league data.
- No automatic P1 bypass is added. Use the effective tenant/user context and the existing
  permitted impersonation rules; a P1 badge is not a component grant.
- Keep rollback and job deletion Owner-only with current tenant and in-progress guards.
  This preserves existing protection rather than inventing a new approval process.
- Keep `updateJobStatus` Owner-only: it is labelled internal and no source UI caller was
  found. Import validation/execution already update their own status internally. Do not
  delegate arbitrary status mutation merely to make the normal wizard work.
- Grant checking and tenant/entity scoping must precede handler execution or data exposure.
  If other shared-handler consumers require a different policy, stop that expansion and
  report it rather than opening access broadly.

Cost/value: a focused permission predicate plus reuse in API/page eligibility resolves the
visible contradiction. Destructive actions remain unavailable to delegated users. No extra
user setup beyond existing role/component assignment is introduced. Date formatting adds
no new control or setting.

## Disposition And Safety

Operational severity: delegated administrative work is blocked; date presentation is wrong.
Workarounds remain an already authorised Owner and manual date interpretation. No production
containment, data repair or schema work is needed for this plan. This is ordinary remediation,
not an accepted emergency expedite; the OOM investigation stays separate.

CR disposition: **triaged, implementation authorised and delivered locally at `c3998084`; local/staging human smoke and production technical promotion PASS; live human acceptance PASS; complete and closed**. Chris’s subsequent local implementation instruction selects this SeasonPro correction as root Now and preserves FUND B1 as Next at its accepted release boundary. The 04 confirmation and 05 review record actual evidence; Chris subsequently authorised staging promotion; deployment/security/health PASS. Staging acceptance and live approval were subsequently obtained; exact production deployment/security/health PASS. The 05 review records Chris’s live acceptance and closure; the previously selected FUND B1 / 1R-G planning sequence is restored.
