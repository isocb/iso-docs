# Platform Next.js, Sharp And js-yaml Security Advisory Triage

Date: 2026-09-10

Status: **PLAT-ASSURE-05 implemented locally at `0397bba9`; publication approval and independent review pending.**

Control depth: **High** — production image processing, security advisories and the shared
request-body runtime correction are affected. Work type: proposed production build.

Source: [CR-Fix](../01-cr-inputs/CR-Fix-2026-09-10-isostack-platform-next-sharp-js-yaml-security-advisories.md).
Owning lane: Platform assurance. Chris subsequently authorised implementation.
The [bounded plan](../03-slice-planning/2026-09-10-isostack-platform-plat-assure-05-next-sharp-js-yaml-remediation-planning.md) now owns execution and its stopping point.
The assessment below is retained as the rationale; root Now is PLAT-ASSURE-05 and Next is FUND resumption.

## Recommendation

Select a short Platform security correction promptly, ahead of further application
promotion. The unchanged protected baseline now fails a mandatory gate and the image
advisory has plausible production exposure. The evidence warrants priority without claiming
confirmed exploitation. Chris accepted the expedite after this review; root control now selects PLAT-ASSURE-05
and preserves FUND B1/B1-R2 resumption as Next.

Chris can continue private local smoke with trusted assets on the unchanged FUND candidate.
Implementation should use a separate checkout and separate dependency directory based on
the accepted protected baseline, so the user's server and generated Prisma client are not
changed during testing. The security release must exclude unaccepted FUND work.

## Minimum Correction Proposed For Bounded Planning

1. Pin Next.js 15.5.25 and move the existing Sharp/js-yaml overrides to 0.35.4/4.3.2.
   Confirm published package metadata and recheck advisories at implementation entry.
2. Inspect the distributed Next runtime and retain the awaited body-finalisation backport.
   Review its exact-version guard and tests for the new version. Upstream source still
   needs the correction; do not remove it on the assumption that a patch release fixed it.
3. Regenerate and review only the necessary dependency records and backport/tests. Account
   for required Next native packages and Sharp native/library packages in the lock diff.
4. Keep the current audit validator and threshold. Broad npm audit fix --force is outside
   the boundary; its suggested auth downgrade and major editor upgrades need separate work.

No database, migration, credential, environment-variable or provider change is required by
the proposed durable fix. The current review has made none of those changes.

## Required Evidence And Failure Boundaries

- Preserve the downloaded failing report and exact run links as negative evidence.
- Clean isolated install using the repository Node 22 boundary; resolve the intended Next,
  Sharp and js-yaml versions and verify the native image libraries actually packaged.
- Fresh audit and unchanged validator must report zero High/Critical. Record remaining
  Moderate/Low counts honestly and retain their separate assessment.
- Test the backport's refusal cases and request-body behaviour, full automated regression,
  TypeScript, critical-file checks and production build. Do not share generated Prisma
  output with the user's smoke checkout.
- Use benign image fixtures for JPEG/PNG and supported AVIF handling. Check that the fixed
  optimiser/version checks and configured remote-source restrictions behave as intended.
  No malicious payload or destructive request is authorised against staging/live.
- Require independent review and scans of the exact candidate and each promoted protected
  ref. Staging proves Linux/native-package behaviour, deployment identity, public health,
  sign-in/out, authorised dashboard access, one bounded save and representative image
  display. Keep a denied unauthenticated request as a negative authority check.
- Stop on unexplained lock churn, missing request-body correction, remaining blocking
  advisories, failed runtime/image evidence or failed security scan.
- Recovery is an isolated code/dependency revert and rebuild; reverting also restores known
  vulnerabilities. If recovery is needed, contain the affected image path rather than
  treating the old build as secure. No data rollback is expected.

## Human And Promotion Boundary

The accepted correction is now committed locally at `0397bba9`; the 03/04/05 records own
its delivery evidence. Automatic approval review blocked branch publication for lack of
explicit payload/destination approval. That approval and independent review precede remote
scan/protected promotion. No database operation or restart of the FUND server occurred.

After acceptance and local proof, use the existing dev -> staging -> main corridor with
human staging acceptance and explicit main promotion authority. Integrate the accepted fix
into FUND separately; retain current smoke findings at `29104b55` and obtain representative
proof on the combined candidate. Do not silently mark B1 complete.

## Evidence Limits

Read-only GitHub run/job metadata, three downloaded npm reports, current protected refs,
local source/lock comparison and upstream advisory/source review were completed. The
existing validator reproduced the failure. These are the initial review limits; the subsequent
04/05 records add the corrected install, audit and runtime proof at `0397bba9`.
Protected Git refs were freshly verified at `14077382`; current Render runtime identity,
native binary conditions and active exploitation remain unverified.
