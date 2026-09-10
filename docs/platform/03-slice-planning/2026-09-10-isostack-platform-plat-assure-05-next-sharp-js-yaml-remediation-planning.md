# PLAT-ASSURE-05 — Next.js, Sharp And js-yaml Security Remediation

Date: 2026-09-10

Status: **Implemented locally at `0397bba9`; technical proof PASS; publication approval and independent review pending.**

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
Current state: 0397bba9 implemented; 0 Critical/High audit, 512 tests, type/build and request-body/image proof PASS; automatic review blocked push; independent review pending
Last proven commit: local candidate 0397bba9 on protected 14077382; failing scan 34448484097 retained; no remote candidate scan yet
Current environment: /private/tmp/isostack-security-2026-09-10 on work/platform-security-2026-09-10, isolated dependencies and synthetic proof config; protected refs unchanged at last verified 14077382; FUND stays at 29104b55
Next human decision/test: explicit approval to publish 0397bba9 on work/platform-security-2026-09-10 to private isocb/isostack-bedrock, then independent review and staging H1-H6
Safe resumption point: after publication approval push exact candidate and run existing Security Scan; do not change FUND test checkout or promote protected branches before the remaining gates
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

Independent review precedes protected promotion. After that gate, use the established
dev -> staging corridor with exact scans and deployment/health readback. Staging human
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
