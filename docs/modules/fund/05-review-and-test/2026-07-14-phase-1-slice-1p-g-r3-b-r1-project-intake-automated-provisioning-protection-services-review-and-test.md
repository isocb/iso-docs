# FUND Phase 1 Slice 1P-G-R3-B-R1 - Project Intake Automated Provisioning And Protection Services Review And Test

Date: 2026-07-14

Status: Passed / dormant service and disposable PostgreSQL transaction lifecycle complete

Implementation confirmation:

`docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1p-g-r3-b-project-intake-automated-provisioning-protection-services-implementation-confirmation.md`

## 1. Review Scope

Reviewed the bounded R3-B implementation for canonical form policy, live authority,
identity protection, exact tenant ownership, atomic provisioning, advisory-lock ordering,
idempotency, audit, rollback and legacy-path exclusion. The review also verified that the
engine remains dormant pending R3-C.

## 2. Static And Pure-Policy Evidence

Passed:

```text
npm run type-check
npx vitest run src/modules/fund/lib/project-intake-policy.test.ts
npx tsx scripts/verify-fund-1p-g-r3-b-services.ts
npx eslint --no-ignore <all changed production and script files>
npx tsx scripts/verify-critical-files.ts
git diff --check
```

The five policy tests cover stable canonical ordering, revision equality/increment,
partial/invalid/unsupported contracts, legacy detection, allowed Project-type resolution
and active form windows.

The static verifier proves row/advisory locks, serializable retry, all rollback stages,
transactional evidence vocabulary, all three legacy guards and exclusion of router, email,
Store and Commerce integration.

## 3. Schema And Prior-Slice Regressions

Passed unchanged:

```text
scripts/verify-commerce-a1-schema.ts
scripts/verify-fund-1r-c1-schema.ts
scripts/verify-fund-1r-c2-schema.ts
scripts/verify-fund-1r-c3-schema.ts
scripts/verify-fund-1r-c4-schema.ts
scripts/verify-fund-1r-c5-schema.ts
scripts/verify-fund-1p-g-r3-a-schema.ts
```

Git inspection confirmed no Prisma schema or migration diff and no router, route, component
or email diff. The disposable target remained at exactly 134 applied migrations with zero
failed migrations.

## 4. Automatic Provisioning Evidence

The disposable service suite proved:

- a confirmed aligned submission creates exactly one Client, active primary Project
  Manager member, User, draft Client-owned Project and delivery profile;
- completion records exact Client/member/Project/Event/delivery IDs and version-1 evidence;
- a repeated call returns `ALREADY_COMPLETED` with the recorded identities;
- authenticated existing-Client evidence reuses the exact Client/member/User, creates only
  Project/delivery and preserves member/profile authority;
- a safe active same-tenant User is reused without changing name, display name, phone, role,
  status or preferences; missing email verification alone is filled from confirmation;
- cross-tenant User, suspended User, deletion-requested User and conflicting membership
  cases create no operational outcome and record bounded identity/account exceptions;
- reviewed provisioning rejects missing and non-admin actor authority, permits an explicit
  pending-invite activation, preserves the existing User profile and retains original
  exception history on successful reviewed completion;
- changed form policy, duplicate evidence and legacy form contracts route to their bounded
  exception or manual result.

## 5. Concurrency, Audit And Rollback

Passed:

- two concurrent calls for one submission serialize into one completion and one exact
  already-completed result;
- two active submissions sharing a fingerprint cannot both create operational outcomes;
  conservative duplicate detection may route both to review rather than arbitrarily choose
  a winner;
- injected failures immediately after Client, User, member, Project and delivery creation
  roll back every operational write and leave the submission incomplete;
- successful completion has one matching transactional provisioning audit;
- exception evidence and its audit commit without partial operational rows;
- final cleanup leaves zero test Organizations and zero `@r3b.test` Users.

The initial advisory-lock implementation used a query call. PostgreSQL correctly exposed
that `pg_advisory_xact_lock` returns `void`, which Prisma cannot deserialize. The final
implementation uses an execution call. Remote Neon round trips also justified an explicit
bounded 20-second interactive transaction timeout instead of Prisma's five-second default.
Both refinements passed the complete rerun.

## 6. Legacy And Existing-Service Safety

The existing three legacy approval functions now reject a submission when either its saved
form contract or submitted contract snapshot is aligned. Historic null/null contracts keep
their former procedure path.

The shared member resolver retains its original C1-managed mode while adding strict
automatic and explicit reviewed modes. The C2 Project service imports shared Project-type
and identifier helpers rather than maintaining a diverging vocabulary. No existing router
was connected to the new engine.

## 7. Database Target And Residue

The runner proved `TEST_DATABASE_URL` differed from `DATABASE_URL` before connecting. Only
the redacted disposable target fingerprint was emitted.

Final evidence:

```text
applied migrations: 134
failed migrations: 0
R3-B Organization residue: 0
R3-B User residue: 0
```

No shared development, staging or production database was contacted.

## 8. Scope Verdict

R3-B is a dormant internal engine. It adds no migration, public/C1 procedure, confirmation
trigger, rate-limit middleware, form/exception UI, email, Store, Commerce, production or
commission behavior. R3-C remains the only slice permitted to integrate capture,
confirmation invocation and UI.

## 9. Review Result

`1P-G-R3-B-R1` passes. R3-B is complete locally through implementation confirmation and
review/test. Its application is committed at `04da074`, its documentation lifecycle is
included in the current IsoDocs baseline, and it remains dormant and undeployed.

Stop here. Do not begin R3-C or another slice without a new explicit control decision.
