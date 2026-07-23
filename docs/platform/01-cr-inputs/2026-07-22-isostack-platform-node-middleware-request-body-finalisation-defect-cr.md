# IsoStack Platform Node Middleware Request-Body Finalisation Defect Change Request

Date: 2026-07-22

Status: Accepted technical defect input; implementation authority belongs to the bounded
Platform slice plan

Discovered through:

`docs/modules/lmspro/05-review-and-test/2026-07-22-lmspro-remediation-slice-r8-a3-durable-attachment-delivery-job-rate-limiter-and-retry-review-and-test.md`

## 1. Reported Failure

Staging returned an HTML HTTP 500 while an authenticated C1 user attempted to save/send an
Email draft containing a PDF. The UI correctly refused to claim success because it could not
parse a structured JSON response:

```text
The email draft service returned an unexpected non-JSON response (HTTP 500).
No draft changes were saved.
```

The web runtime recorded:

```text
TypeError: Response body object should not be disturbed or locked
at fromNodeNextRequest
at app/api/trpc/[trpc]/route
```

The attachment-delivery cron subsequently processed zero jobs because the request failed
before the draft mutation could persist the draft and queue its delivery job.

## 2. Confirmed Platform Cause

The application resolves `next@15.5.21`. Its installed Node middleware runtime calls the
asynchronous `requestData.body.finalize()` operation without `await`. All `/api/` requests,
including tRPC mutations, currently traverse shared Node middleware before the route handler.

This matches upstream Next.js issue `vercel/next.js#85416` and merged correction
`vercel/next.js#85418`. The race is more readily exposed by larger request bodies, but its
technical boundary is every body-bearing request that traverses Node middleware.

## 3. Affected Scope

The defect is owned by Platform because it sits in the shared HTTP/middleware runtime. LMSPro
R8-A3 is the discovering consumer and was blocked until the Platform correction passed staging.

Potentially affected requests are POST, PUT, PATCH and DELETE requests with bodies that pass
through Node middleware. No evidence currently identifies a module business-rule, database
schema, Prisma service, R2, Resend or cron implementation defect as the cause.

Repeated PostgreSQL `Closed` messages observed around deployment are retained as a separate
assurance observation. A later staging health request returned HTTP 200 with the database
connected and all expected RLS checks passing.

## 4. Requested Outcome

IsoStack should apply the exact upstream request-body finalisation correction in a controlled,
reproducible and fail-closed form, then prove the built production/standalone runtime before
LMSPro R8-A3 attachment testing resumes.

The change must:

- preserve the exact controlled Next.js dependency version while the backport applies;
- fail installation or verification if the expected upstream source boundary changes;
- add deterministic patch-presence evidence;
- add production-runtime request-body regression coverage, including repeated payloads;
- exercise small, representative and accepted maximum attachment envelopes;
- cover representative shared/module body-bearing API behaviour;
- introduce no schema, migration, environment or business-rule change; and
- retain a simple rollback boundary.

## 5. Settled Decisions

1. This is a first-class Platform corrective lifecycle, not an expansion of LMSPro R8-A3.
2. R8-A3 was blocked until this platform slice passed its automated and staging gates; those
   gates passed on 2026-07-22 and control returned to the module checklist.
3. The exact upstream missing-`await` correction is the bounded implementation direction.
4. Database behaviour is within regression/observation scope but not correction scope unless a
   separate reproducible defect emerges.
5. Existing rate limiting must not be bypassed.
6. No direct edit to an installed `node_modules` file may be relied upon; installation must
   reproduce and verify the correction.
7. Staging and live promotion remain separately controlled.

## 6. Non-Goals

This change request does not authorise:

- a major Next.js upgrade;
- an attachment-only middleware bypass;
- changes to authentication, rate limits or module permissions;
- schema, migration or database remediation;
- R2, Resend, cron or Email lifecycle redesign;
- live deployment; or
- the wider replacement of Base64-in-tRPC transport.

## 7. Deferred Refinement

A dedicated authenticated private upload path that stores accepted binary content directly in
private object storage and leaves tRPC to carry durable metadata should be appraised separately.
It is a worthwhile resilience and efficiency refinement, but is not required to obscure or
expand this confirmed one-line runtime correction.
