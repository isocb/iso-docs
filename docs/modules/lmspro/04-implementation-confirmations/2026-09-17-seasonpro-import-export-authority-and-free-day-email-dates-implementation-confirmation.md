# SeasonPro Import/Export Authority And Free Day Email Dates — Implementation Confirmation

Date: 2026-09-17 · Control depth: **High**

- Exact commit: `c3998084` on local `dev` (parent `d13ecb39`); not pushed.
- Files/change boundary: Core Import router and narrow access helper; Import, Export and job pages; two dashboard component filters; Free Day template presentation and focused tests.
- Automated checks: 79 focused/related tests PASS; TypeScript, critical-file verification and changed-file ESLint PASS (zero errors, 36 existing warnings; test files linted with `project: null` because the application tsconfig excludes tests). Isolated production build PASS (workspace removed; running dev server untouched).
- Human evidence: Chris reports L1–L5 PASS and an actual email send PASS on 17 September; see the 05 acceptance record.
- Environment proven: local automated checks and user-reported authenticated smoke. Read-only connected access-helper checks PASS for 12 local development actors (endpoint fingerprint `8708763642d9`), including invalid effective-tenant refusal. No staging/live changes or database mutation.
- Known residual risk: staging-specific authentication/RLS proof remains pending; no new role grants are assigned automatically. Existing rollback removes mappings, not imported entities.
- Next action: staging-authorisation decision following accepted local smoke in the [05 review](../05-review-and-test/2026-09-17-seasonpro-import-export-authority-and-free-day-email-dates-review-and-test.md); stop before online promotion.

[Plan](../03-slice-planning/2026-09-17-seasonpro-import-export-authority-and-free-day-email-dates-planning.md)

## Delivered behaviour

Normal Import and Export require the corresponding explicit grant from an active applicable
SeasonPro role for a core C1 OWNER or ADMIN. The effective actor must be active and belong to
the effective tenant. Foreign and Club-only roles do not grant league-wide access; module-global
roles remain supported. Disabled component overrides, current-season timing rules and revoked
grants are enforced server-side. Read-only roles cannot grant Import writes. P1 status alone
is not an Import/Export grant.

The pages check this same access result before showing operations or fetching supporting lists;
the dashboard filters these two cards through it. Job-history rollback/delete controls are
hidden from delegated users; destructive and internal status procedures still require OWNER.
Supplied export filters, job cursors and imported job season references are tenant-checked.
Handler contexts and audit records use the effective actor/tenant consistently. No global
permission helper or existing handler behaviour was redesigned.

Default and custom Free Day requested/approved/rejected/cancelled templates render requestedDate
as DD/MM/YYYY using the existing date-only utility. Custom subject, HTML and text use a copied
presentation object; default templates format their raw input once. Invalid/missing dates become
blank and intentional editing shortcodes remain visible. Stored dates/templates/sent messages
are untouched; disabled notification semantics are preserved.

## Verification and recovery

Tests exercise real tRPC procedure middleware with synthetic Prisma boundaries: OWNER/ADMIN
independent grants and revocation, non-C1 refusal, inactive/foreign/Club/read-only roles,
component disable/timing, signed-out/invalid identity, effective-actor audit attribution,
all seven normal Import procedures, CSV/JSON export, foreign filters/jobs/cursors, and delegated
destructive refusal plus Owner tenant/state checks. Existing parser, registry, Club handler and
participation-template regressions pass. These are not a claim of connected database/RLS proof.

Self-review only; no independent human/code reviewer claimed. Reviewed the three registered
SeasonPro handlers (Club, Age Group Group and Team), registry initialisation, page callers,
shared RLS context and template settings caller. The shared authorization helper and RLS
implementation remain unchanged. No schema, migration, secret, provider or runtime setting changes.

`npm run verify` encountered sandbox IPC restrictions in tsx; running the same verification
script with `node --import tsx scripts/verify-critical-files.ts` passed, including TypeScript.

Recovery is a compatible code revert, restoring the former Owner-only normal-operation checks.
Never use rollback/delete as recovery for this code change: legitimate imports, mappings and sent
evidence must remain. Staging/environment proof, staging human acceptance and any online promotion are pending.
