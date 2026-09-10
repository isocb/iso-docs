# PLAT-ASSURE-05 — Next.js, Sharp And js-yaml Security Remediation

Date: 2026-09-10

Status: **Exact `0397bba9` promoted through main; local/remote dev, staging and main aligned; main Security Scan and public production probes PASS; exact Render/runtime and separate-review evidence remain unproven.**

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
Current state: security 0397bba9 promoted by local main fast-forward and ordinary push under Chris's reaffirmed instruction; all three local/remote branches align; accepted staging UI PASS; main scan 34481778012 PASS; public production probes PASS
Last proven commit: 0397bba958862f1f61c16d405fdfe60ae7c13f50; work/dev/staging scans and Linux parity PASS; fresh local backport/image proofs and five backport tests PASS; remote three-branch readback matches; production app.seasonpro.co.uk health/access/image probes PASS at 13:18 UTC
Current environment: isolated security checkout now on main at 0397bba9; dev/staging/main and origins match; original FUND checkout remains 29104b55 with unchanged dependencies/DevData; no manual database/configuration operation
Next human decision/test: no further promotion approval or repeat staging UI test needed; confirm production Render Live/green at 0397bba9 through provider access unavailable to this session; separate source review and native-runtime identity remain unproven observations, not claimed PASS
Safe resumption point: finish main scan monitoring and minimal production verification, retain exact deployment evidence limits and owner-authorised promotion disposition; resume FUND B1 reconciliation and existing 1R-G planning without treating Git alignment as FUND promotion
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

## Main/Live Authority — 2026-09-10

After reporting IsoStack/LMSPro staging UI PASS, Chris instructed: “please promote the
security patch and commit the files in the normal way”, then requested smoke documentation
and the next planning slice. This is the required explicit main/live authority. It replaces
the approval hold; it does not fabricate independent review or deployment/runtime evidence.
The intended main bundle remains exact `0397bba9`, five security files, with no schema,
migration, configuration or FUND change. Main is still `14077382` at this preflight.

GitHub readback confirms all four existing work/dev/staging scan/parity jobs pass and no
additional branch divergence. No PR review or GitHub deployment identity is available.
Render CLI, authenticated provider tools and Render environment credentials are unavailable;
the outstanding provider readback was requested, along with permission for a separate
review agent. Perform all accessible work without requesting main approval again.

## Reaffirmed Controlled Promotion — 2026-09-10

After the assistant explicitly reported that main was still `14077382` and explained the
unproven independent review and Render evidence, Chris directed: “please promote in a safe
way so main/live, staging and dev are aligned”. This is a renewed instruction to execute
the exact tested security promotion, superseding this plan's earlier pre-push hold.

Proceed with the controlled local main fast-forward and ordinary push of `0397bba9` after
fresh ancestry, scope, credential and runtime checks. Retain the accepted LMSPro staging
human PASS and exact work/dev/staging automated evidence. Monitor the new main scan and
minimum non-destructive live probes. No force push, new source, migration, configuration
change or FUND integration is included.

Control depth remains High. The release record must still state that source review is by
the implementing assistant, not a separate reviewer, and that exact Render deployment and
native-runtime readback are unavailable until supplied or independently obtained. The
owner's instruction authorises promotion; it does not turn those missing observations into
PASS. Do not claim complete live verification from Git alignment or health alone.

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
