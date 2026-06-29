# FUND Resume Context After SeasonPro Remediation

Date: 2026-06-29

Status: Resume prompt / planning context

## Purpose

Use this prompt when returning to FUND after SeasonPro or authentication remediation work.

The immediate FUND lane is Project Intake. The next implementation slice is:

```text
1P-G-D1 - C1 Project Intake Form API/Services
```

## Resume Prompt

```text
We are resuming IsoStack FUND work.

Work on:
feature/fund-phase-1-c2-project-access

Read first:
- isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md
- isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d1-c1-project-intake-form-api-services-planning.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-c2-a-project-intake-email-confirmation-schema-addendum-confirmation.md
- isodocs/docs/modules/fund/05-review-and-test/2026-06-29-phase-1-slice-1p-g-c2-a-r1-project-intake-email-confirmation-schema-addendum-review.md
- isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d-project-intake-moderation-api-services-planning.md
- current FUND router/service/Zod conventions

Current accepted FUND context:
- FUND Phase 1 through 1P-G-C-R1 was aligned to main/dev/staging at `aac38c1`.
- SVG branding upload fix and 1P-G-C2-A Project Intake email confirmation schema addendum are committed on `feature/fund-phase-1-c2-project-access`.
- 1P-G-C2-A is schema-only and reviewed as safe to commit.
- 1P-G-D1 planning is complete.

Next implementation:
Proceed with FUND Phase 1 Slice 1P-G-D1 implementation: C1 Project Intake Form API/Services.

Implement only:
- project intake validation schemas;
- project intake form service functions;
- project intake router mounted under `fund.projectIntake.forms`;
- C1 admin procedures for list, get, create, update, activate, pause, archive and restore.

Use:
- `withFeature('fund')`;
- `assertFundAdmin`;
- actor/effective tenant organizationId;
- same-tenant default Event validation;
- soft archive only;
- existing FUND audit conventions where straightforward.

Do not implement:
- public form rendering;
- public submission endpoints;
- submission review services;
- email confirmation endpoint;
- email sending;
- token generation;
- public link issuing;
- Client users/members;
- invitations;
- notifications;
- approval automation;
- Project creation from submissions;
- C2 Client dashboard Project creation;
- Store, Orders, Commerce, Sales/Reporting, production/dispatch or SeasonPro integration;
- schema changes or migrations unless a blocker is identified and explained first.

Do not run:
- db:push;
- seed commands;
- reset commands.

Run:
- npx prisma validate
- npm run db:generate
- npm run type-check
- npm run verify
- git diff --check

Create implementation confirmation documentation.
Do not promote to main after implementation.
```

## Branch Boundary Reminder

SeasonPro remediation should happen on a separate remediation branch from the current accepted release baseline unless explicitly cherry-picking a safe shared fix.

FUND work should resume on:

```text
feature/fund-phase-1-c2-project-access
```

Authentication/user-onboarding emergency remediation currently has a branch placeholder:

```text
emergency-auth-new-user-magic-link-routing
```

That branch was created from `dev` at `aac38c1` and should remain separate from active FUND Project Intake work unless an agreed shared auth fix needs promotion across branches.
