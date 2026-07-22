# IsoStack Platform Node Middleware Request-Body Finalisation Defect Triage

Date: 2026-07-22

Status: Triaged and promoted to bounded Platform slice `PLAT-RUNTIME-01`

Source CR:

`docs/platform/01-cr-inputs/2026-07-22-isostack-platform-node-middleware-request-body-finalisation-defect-cr.md`

## 1. Ownership And Classification

- Owner: IsoStack Platform.
- Classification: shared runtime defect and release-assurance correction.
- Severity: high for body-bearing requests; blocking for LMSPro R8-A3 staging acceptance.
- Discovering consumer: LMSPro ad-hoc Email attachment draft/save/send.
- Repositories: application implementation in `isostack-bedrock`; lifecycle evidence in
  `isodocs`.

The defect is not assigned to LMSPro merely because an LMSPro workflow exposed it. The failing
boundary is shared Next.js Node middleware before tRPC/domain execution.

## 2. Evidence Decision

The following are confirmed:

- installed `next@15.5.21` contains the unawaited finalisation call;
- every `/api/` route currently traverses shared Node middleware;
- the observed stack is the documented upstream race signature;
- the failed browser request returned HTML HTTP 500 before persistence/queue creation; and
- a later staging health probe reported the database connected.

The repeated PostgreSQL connection-close messages are correlated operational evidence only.
They do not currently justify database code, configuration or migration changes.

## 3. Disposition

Promote immediately as `PLAT-RUNTIME-01 - Node Middleware Request-Body Finalisation Backport
And Production-Runtime Assurance`.

This corrective slice temporarily displaces continuation of LMSPro R8-A3 human attachment
testing. It does not reopen R8-A3's accepted business or delivery contracts.

## 4. Smallest Safe Boundary

The slice should:

1. pin and patch the exact installed Next.js version using a repository-controlled,
   install-time mechanism;
2. fail closed if version or patch context differs;
3. verify the built runtime contains the awaited operation;
4. exercise body-bearing requests through a production/standalone Next server;
5. run existing attachment, shared API, type, verification and build regressions; and
6. stop for staging human/operational smoke before R8-A3 resumes.

Bypassing middleware for tRPC is rejected because it would alter the established rate-limit
boundary. A major framework upgrade is rejected within this urgent correction because its
compatibility surface is materially larger.

## 5. Dependencies And Blocks

- `PLAT-RUNTIME-01` depends on the exact current dev/staging application baseline
  `90974123`.
- LMSPro R8-A3 remains explicitly blocked by `PLAT-RUNTIME-01`.
- No database migration or environment-variable change is required.
- Staging promotion remains unavailable until the slice's automated review is green.

## 6. Deferred Candidate

Register a separate Platform refinement for moving binary uploads away from Base64-in-tRPC to
an authenticated private object-upload path. It is not implementation-authorised here.
