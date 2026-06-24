# FUND Phase 1 Slice 1K - Project Admin UI Review Closeout

## Slice Name

Phase 1 Slice 1K - Project Admin UI Review and Manual Testing.

## Date

2026-06-24

## Review Scope

Reviewed the Project Admin UI foundation delivered through:

- Slice 1J-A - Project list and child management shell;
- Slice 1J-B - Project Product membership manager.

The review focused on:

- Project list/create/child-page flow;
- Project overview and status actions;
- activation-readiness interaction;
- Project Product add/deactivate/reactivate/reorder behaviour;
- snapshot-vs-live Product wording;
- locked status behaviour;
- table/action pattern compliance;
- branch readiness before Event API/service work.

## Findings By Severity

### Critical

No Critical findings identified.

### High

No High findings identified.

### Medium

No Medium findings requiring a hold were identified.

Browser testing with real tenant data remains required in a migrated target environment. This is a validation limitation, not a known code defect.

### Low

The Project Products manager intentionally keeps inactive memberships visible by default. If real Project membership lists become long, a future refinement may add a `show inactive` toggle.

## Manual / Functional Review Completed

Completed by code and behaviour review:

- Project Products tab replaces the 1J-A placeholder.
- Product picker uses live Product data only for eligibility.
- Membership list displays Project Product snapshot values as the Project record.
- Active and inactive memberships remain visible.
- Archived source Products remain visible as historical/snapshot rows.
- Add/deactivate/reactivate/reorder use existing Slice 1I endpoints only.
- Move Up / Move Down sends the displayed full membership id list.
- Mutation controls are disabled after `CLOSED`, `COMPLETED` and `ARCHIVED`.
- Project detail/list invalidation is triggered after membership mutations.
- No Product editor UI is introduced inside the Project page.

Manual browser testing still required:

- create realistic C1 tenant data;
- add/deactivate/reactivate/reorder Products in the browser;
- verify activation-readiness state changes visually;
- verify locked-state UX after close/complete/archive;
- verify entitlement behaviour for tenant with/without FUND access.

## Checks Run

Completed during Slice 1J-B / 1L-A work:

- `npx prisma validate` - passed.
- `npm run db:generate` - passed.
- `npm run type-check` - passed.
- `npm run verify` - passed after rerunning outside the sandbox because the initial sandboxed run blocked `tsx` IPC pipe creation with `EPERM`.

## Known Limitations

- Full browser/manual data testing was not performed in this local pass.
- 1L-A schema work was completed before this closeout was written; 1K therefore closes the Project Admin UI review from code/check perspective and still recommends target-environment browser validation.
- Event-linked Project effective close-date behaviour is not part of 1J and remains for 1L-B API/service work.

## Branch / Commit Readiness

Recommendation:

```text
Proceed
```

Rationale:

- no blocking Project Admin UI issues were identified;
- type and verification checks passed;
- Project UI/service boundaries remain clean;
- Event work can proceed after committing 1J-B and 1L-A in separate scoped commits.

## Exact Fix Scope

No required fixes before proceeding to 1L-B.

## Recommended Next Slice

Phase 1 Slice 1L-B - FundEvent API and Services.
