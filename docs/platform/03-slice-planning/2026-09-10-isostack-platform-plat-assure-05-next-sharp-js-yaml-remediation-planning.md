# PLAT-ASSURE-05 — Next.js, Sharp And js-yaml Security Remediation

Date: 2026-09-10

Status: **Exact `0397bba9` aligned through dev/staging; all three scans and Linux parity PASS; paused before main/live.**

Control depth: **High** — production image decoding and the shared request-body correction.
Work type: **Production build**. Durable dependency/backport changes; temporary isolated
local proof uses synthetic configuration, no service credentials and no database access.

Authority: [CR](../01-cr-inputs/CR-Fix-2026-09-10-isostack-platform-next-sharp-js-yaml-security-advisories.md)
-> [triage](../02-triage/2026-09-10-isostack-platform-next-sharp-js-yaml-security-advisories-triage.md)
-> [Platform roadmap](../00-roadmap-control/2026-07-22-isostack-platform-roadmap-and-slice-control.md).
Chris accepted the proposed correction with “please implement and document accordingly”.
Root Now is this correction; Next is resumption of FUND B1/B1-R2. Chris can continue human
smoke on the unchanged FUND candidate while this isolated correction is prepared.

## Restart Checkpoint

```text
Current state: 0397bba9 aligned through dev/staging; work/dev/staging Security Scans and Linux renderer parity PASS; main/live explicitly paused; Chris reports staging entry/login/logout PASS on 2026-09-10; independent review and remaining staging acceptance open
Last proven commit: 0397bba958862f1f61c16d405fdfe60ae7c13f50; scans 34463542270/34463792299/34464073290 and Linux parity 34463792371 PASS; public staging health/access/image probes PASS, exact Render identity not proven
Current environment: isolated security checkout retained; local/remote dev and staging at 0397bba9, main at 14077382; original FUND checkout remains 29104b55 with unchanged dependencies/DevData; no manual database operation
Next human decision/test: staging entry/login/logout reported PASS; complete ordinary save/readback, representative image display and dashboard-context/protected-page checks; verify Render Live at 0397bba9 and remaining native-runtime/independent review evidence before specific main/live approval
Safe resumption point: continue remaining staging/review gates only; do not push application main or integrate into the active FUND smoke checkout without the relevant next instruction
```

## Implementation Boundary

- package.json/package-lock.json: Next 15.5.25, Sharp override 0.35.4, js-yaml override 4.3.2.
  Native Next/Sharp packages and required dependency metadata changes are included.
- scripts/next-node-middleware-body-finalize-patch.mjs: preserve missing-await correction
  while updating the exact supported version after inspecting the distributed runtime.
- Existing backport tests: retain context/idempotence refusal tests; reject the former
  version and assert manifest/guard agreement.
- Add a bounded benign image proof if required to demonstrate the patched Next/Sharp
  optimiser, supported JPEG/PNG/AVIF paths and remote-source refusal.

Maintain the existing audit validator and security workflow. Do not use audit fix --force,
change auth/editor major versions, modify FUND functionality or fold in unrelated source.
No schema, migration, database, credential or provider change. Do not share node_modules,
generated Prisma files or .next output with the FUND checkout. No restart of its server.

## Verification

1. Node 22 clean install in the isolated checkout, with lifecycle scripts and generated
   Prisma client; no copied environment files. Inspect the distributed backport context.
2. Compare lock records against baseline; explain every package version change. Verify
   actual Next, Sharp, libheif and js-yaml versions. Current advisory metadata is rechecked
   by the fresh npm audit. The old report must fail the unchanged validator and the new
   report must have zero High/Critical; record residual Moderate/Low counts.
3. Full unit regression, backport negative/idempotence tests, type check, focused lint,
   critical-file verification and standalone production build. Database tests remain
   opt-in; no connected data proof is relevant to this dependency-only change.
4. Run the existing isolated production request-body test and benign image proof. Use
   random loopback ports and always stop child servers. Do not use exploit fixtures or
   send test traffic to staging/live during local proof.
5. Review the complete diff, scan for credentials and commit only the bounded candidate.
   Verify the private remote identity before publishing and request an exact work-branch
   Security Scan. Record independent review truthfully; do not relabel self-review as it.

## Staging And Release

Chris subsequently instructed: “please commit and push to dev and staging - and pause for
specific approval before promoting to main/live”. This explicit staging authority supersedes
the earlier publication hold and pre-staging stopping point. Complete the technical scans
and controlled dev -> staging merges now; record independent review as pending at the main
hold point rather than claiming it has occurred. Obtain deployment/health readback. Staging human
checks: sign-in, authorised dashboard, one bounded save, representative image display,
sign-out and unauthenticated denial. Linux proof verifies packaged native libraries and
image handling. Main requires separate human staging acceptance and promotion authority.
Integrate the accepted security fix into FUND separately after its current smoke stopping
point; retain original findings and perform representative combined-candidate regression.

## Failure, Recovery And Cleanup

Stop for unexplained dependency churn, absent body-finalisation correction, blocking audit
findings or failed source/runtime checks. A revert/rebuild recovers application behaviour
but restores known vulnerability exposure; assess image-path containment if needed.
No data rollback. Remove temporary fixture/server output after proof, retain redacted
results in 04/05, and keep the isolated checkout available until review/integration.

## Required Completion Records

Create 04 confirmation and 05 review/test with exact candidate, checks, evidence limits,
remaining human/independent/environment gates and the safe next action. Update CR, triage,
Platform and root state; no security closure or FUND acceptance is inferred from local PASS.
