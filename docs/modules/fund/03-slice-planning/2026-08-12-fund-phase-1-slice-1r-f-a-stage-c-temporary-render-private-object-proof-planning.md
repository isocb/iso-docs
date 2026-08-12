# FUND Phase 1 Slice 1R-F-A Stage C — Temporary Render And Private-Object Proof Planning

Date: 2026-08-12

Status: **ACCEPTED AND AUTHORISED — CONTROL OWNER AUTHORISED BOUNDED IMPLEMENTATION,
EXACT-COMMIT DEV ALIGNMENT AND THE ONE-OFF EXTERNAL RENDER/R2 EXECUTION ON 2026-08-12;
NO STAGE C RESULT YET**

Owning lane: FUND

Existing identifier: `1R-F-A Stage C` — this document expands the Stage C already named by
the accepted parent; it does not invent or select a new slice.

Parent planning authority:

[`1R-F-A Real AMOW Template, Pricing And Deployed Renderer Proof`](2026-08-11-fund-phase-1-slice-1r-f-a-real-amow-template-pricing-and-deployed-renderer-proof-planning.md)

Authoritative controls:

- [`root portfolio roadmap`](../../../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md)
- [`FUND roadmap`](../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md)

Accepted evidence foundation:

- [`Stage B Linux container parity gate`](../05-review-and-test/2026-08-12-fund-phase-1-slice-1r-f-a-stage-b-linux-container-parity-gate.md)
- [`R1B source-fidelity and folding local gate`](../05-review-and-test/2026-08-11-fund-phase-1-slice-1r-f-a-r1b-source-fidelity-and-folding-local-gate.md)
- [`1R-F-A implementation confirmation`](../04-implementation-confirmations/2026-08-11-fund-phase-1-slice-1r-f-a-local-template-renderer-proof-implementation-confirmation.md)

External platform references used to validate this plan:

- [Render one-off jobs](https://render.com/docs/one-off-jobs)
- [Render Blueprint specification](https://render.com/docs/blueprint-spec)
- [Render exact-commit deployment](https://render.com/docs/deploys)
- [Render default runtime identity variables](https://render.com/docs/environment-variables)
- [Cloudflare R2 S3 credentials and bucket scoping](https://developers.cloudflare.com/r2/get-started/s3/)
- [Cloudflare R2 temporary credentials](https://developers.cloudflare.com/r2/api/s3/temporary-credentials/)
- [Cloudflare R2 public-access controls](https://developers.cloudflare.com/r2/buckets/public-buckets/)

## 1. Accepted Authority Boundary

This document began as a subordinate planning handoff produced under the Parallel Planning
Persona. On 2026-08-12 the control owner accepted the recommended contract and instructed
the control window to execute it. That instruction authorises:

- the bounded Stage C runner, tests and evidence implementation;
- exact candidate commit, local/Linux/security gates and `dev` alignment;
- creation and later exact deletion of the temporary Render/R2 resources described here;
- creation, use and revocation of the dedicated credentials described here; and
- one external execution followed by evidence capture and complete teardown.

It does not authorise:

- schema, migrations, application routes, production services or shared storage changes;
- modification of existing Render staging/production services or their auto-deploy setting;
- staging/main promotion, shared database action or customer data access; or
- begin `1R-F-B`, `1R-G` or parked `1R-H-A`.

The control owner noted that Render is generally set to auto-deploy. This does not relax the
isolation contract: the newly created temporary Stage C worker must have auto-deploy disabled
from creation and must deploy only the recorded exact candidate commit. Existing auto-deploy
services remain untouched.

## 2. Purpose And Strategic Decision

Stage C answers one remaining feasibility question:

> Can the exact accepted FUND artwork proof run once in an isolated Render Linux runtime,
> generate the same six controlled PDFs, perform a private checksum-protected object
> write/read/delete round trip, and leave no service, credential or object residue?

The proof is not a production renderer pilot. It does not prove multi-tenant operation,
production retention, public download, organiser access, Store ordering, artwork upload,
Order correlation or production throughput.

The recommended execution shape is:

```text
accepted Stage C candidate commit
-> temporary no-route Render worker builds the exact Docker artifact
-> worker remains inert; it does not execute the proof
-> one Render one-off job snapshots that exact build and bounded environment
-> job runs one controlled batch and exits
-> exact prefix is proved empty
-> R2 and Render credentials are revoked
-> dedicated bucket and temporary Render service are deleted
-> zero-residue evidence is recorded by the control window
```

This refines the parent's original `worker runs once then idles` concept. Render documents
background workers as continuous processes, whereas a one-off job exits and is automatically
deprovisioned. Using the worker only as an inert build base removes automatic process-restart
and accidental proof-replay risk.

## 3. Existing Accepted Foundation

The following evidence is accepted and must not be silently rerun or reinterpreted as open:

- source-faithful portrait and fold-aware landscape compositions pass 12/12 physical/human
  review;
- six accepted fixtures and six deliberate refusals pass locally and in the pinned Linux
  container;
- portrait artwork is approximately `200 × 192 mm`; landscape artwork is approximately
  `171 × 180 mm`;
- exact normalised business/layout equality passes across Mac and Linux;
- QR, A4, one-page, font, Product order, capacity, retry, sanitisation and monochrome gates
  pass;
- Stage B application `139d09c4` is aligned to local/remote `dev`;
- Linux parity run `31595635243` and exact Security Scan `31595635276` pass; and
- `staging` and `main` remain unchanged at `cde4eaff`.

Stage C may add only the minimum isolated runner, object-round-trip adapter, mock tests,
machine-evidence fields and temporary deployment description needed for this proof.

## 4. Settled Boundaries Preserved From The Parent

1. Use checked-in synthetic fixtures only.
2. Use no application, customer, child, purchaser, Order, payment or tenant data.
3. Configure no `DATABASE_URL`, authentication secret, email key, public media URL,
   production/staging secret or shared environment group.
4. Use the pinned proof Dockerfile and its immutable Playwright, Node, Chromium and font
   identities.
5. Use no public web route, custom domain, `onrender.com` endpoint, persistent disk,
   Render database, Key Value instance or queue.
6. Use a dedicated private proof bucket; do not reuse the public media bucket or private
   email-attachment bucket.
7. Enable neither an `r2.dev` development URL nor a custom domain on the proof bucket.
8. Upload no object unless rendering and local checksum creation have passed.
9. Retain no generated PDF in object storage after the run.
10. Do not change the repository root `render.yaml`; existing application services and
    their environment must remain untouched.
11. Do not promote `staging` or `main` merely to perform Stage C.
12. Stop after Stage C evidence and teardown; do not flow into another FUND child.

## 5. Exact Candidate And Pre-Execution Gates

Stage C must not deploy bare `139d09c4` if implementation work is required. The accepted
Stage B commit is the immutable baseline. A later Stage C candidate commit may contain only
the bounded proof-runner changes described in this plan.

Before creating any external resource, the control window must record one full candidate
SHA and prove:

| Candidate gate | Required result |
| --- | --- |
| Diff from `139d09c4` | Only bounded Stage C proof files/package scripts and documentation |
| Prisma schema/migrations | No change |
| Application routes/services | No production integration |
| Existing local proof | 3/3 PASS; six accepted and six refused fixtures retained |
| Stage B Linux parity | PASS again for the exact Stage C candidate |
| Application TypeScript | PASS |
| Stage C mock/unit tests | PASS, including cleanup and failure paths |
| Exact dev Security Scan | PASS |
| Secret scan | No credential, token, bucket secret or Render API key in Git/log fixtures |
| Branch alignment | Local `dev` equals `origin/dev` at the exact candidate |

If the candidate cannot pass these gates without changing production application code,
shared R2 utilities, root Render configuration or schema, Stage C stops for replanning.

## 6. Recommended Render Topology

### 6.1 Temporary base service

Create one temporary service only after explicit external-action authority:

| Field | Required candidate value |
| --- | --- |
| Service type | Background worker — no inbound URL or hostname |
| Name | `isostack-fund-1r-f-a-stage-c-<run-suffix>` |
| Repository | `isocb/isostack-bedrock` |
| Source branch | `dev`, used only to locate the repository |
| Deployed revision | The full accepted Stage C candidate SHA, selected manually |
| Auto-deploy | Off before and after the exact-commit deployment |
| Runtime | Docker |
| Dockerfile | `scripts/proofs/fund-1r-f-a/Dockerfile` |
| Docker command | An inert, separately proven Node wait command; never the proof runner |
| Region | Frankfurt, matching the current operational region |
| Instance | Starter, one instance only; no autoscaling |
| Disk | None |
| Health check | None |
| Environment group | None |
| Database/service links | None |

The base worker exists only to build and expose one exact immutable artifact to a Render
one-off job. It must not render, upload, poll a queue or listen on a port.

Render supports deploying a specific commit and provides `RENDER_GIT_COMMIT` at runtime.
The Stage C runner must fail before browser launch or object access unless:

```text
RENDER=true
RENDER_GIT_COMMIT=<full accepted Stage C candidate SHA>
FUND_STAGE_C_EXPECTED_COMMIT=<same full SHA>
FUND_STAGE_C_ENABLED=true
```

### 6.2 Single one-off job

Create exactly one one-off job from the base worker's latest successful build. Render states
that a one-off job snapshots the base service's build artifact and configured environment,
terminates when its start command exits and is then automatically deprovisioned.

Required shape:

- start command: the dedicated Stage C package command introduced by the accepted candidate;
- plan: Starter unless pre-execution evidence proves that 512 MB cannot safely contain the
  pinned renderer;
- application deadline: 15 minutes, enforced by the runner rather than relying on Render's
  much larger platform maximum;
- concurrency: one job, one browser, sequential fixtures;
- rerun: prohibited under the same run ID; a new run requires a new authority decision,
  new run ID and new empty prefix; and
- cancellation: available to the operator through the Render API if the application
  deadline or safety gate fails.

The one-off job must not be created until the base worker's exact deployed commit and
inert state are recorded.

## 7. Credential And Trust Model

Stage C has two separate administrative trust domains. Their credentials must never be
shared with each other or installed in the proof container unless explicitly listed below.

### 7.1 Render administration

Creating the one-off job requires the Render API. The recommended control is:

1. create a dedicated short-lived Render API key for Stage C;
2. retain it only in the operator's local credential store/session;
3. never add it to Render service environment, Git, shell history, logs or documentation;
4. use it only for the exact base service/job inspection, job creation/cancellation and
   final service verification/deletion workflow; and
5. revoke it immediately after the service has been deleted and absence verified.

If the control owner elects to use an existing Render API key, that is a material risk
acceptance and must be recorded. The key must still remain outside the service.

### 7.2 Cloudflare R2 administration and runtime access

Preferred credential chain:

```text
dedicated Stage C parent R2 API token
  scoped Object Read & Write to one dedicated proof bucket only
  retained outside Render
    -> mint one temporary S3 credential
       bucket = exact proof bucket
       prefix = exact run prefix
       permission = object-read-write
       TTL = 60 minutes
         -> inject only temporary access key, secret and session token into Render
```

Cloudflare documents that temporary R2 credentials are bound to one bucket, can be further
restricted to prefixes, expire automatically and stop working immediately if the parent
token is revoked. The parent token must never enter Render.

The one-hour TTL provides a bounded margin around a 15-minute job and cleanup. If cleanup
cannot be proved before expiry, mint a new cleanup-only temporary credential from the same
parent, restricted to the same bucket/prefix. Never widen scope to recover a failed run.

### 7.3 Runtime environment contract

Only these Stage C variables may be configured on the temporary base service:

| Variable | Secret | Purpose |
| --- | --- | --- |
| `FUND_STAGE_C_ENABLED` | No | Exact fail-closed feature gate; literal `true` |
| `FUND_STAGE_C_EXPECTED_COMMIT` | No | Full accepted candidate SHA |
| `FUND_STAGE_C_RUN_ID` | No | Random non-customer UUID |
| `FUND_STAGE_C_MAX_RUNTIME_SECONDS` | No | `900` |
| `FUND_STAGE_C_R2_ACCOUNT_ID` | No | R2 S3 endpoint identity |
| `FUND_STAGE_C_R2_BUCKET` | No | Dedicated proof bucket name |
| `FUND_STAGE_C_R2_PREFIX` | No | Exact `fund/1r-f-a/stage-c/<run-id>/` prefix |
| `FUND_STAGE_C_R2_CREDENTIAL_EXPIRES_AT` | No | UTC expiry used by preflight |
| `FUND_STAGE_C_FORBIDDEN_BUCKETS` | No | Comma-separated shared/production bucket denylist |
| `FUND_STAGE_C_R2_ACCESS_KEY_ID` | Yes | Temporary credential access key |
| `FUND_STAGE_C_R2_SECRET_ACCESS_KEY` | Yes | Temporary credential secret |
| `FUND_STAGE_C_R2_SESSION_TOKEN` | Yes | Temporary credential session token |

The runner derives the S3 endpoint from the account ID and uses region `auto`. It must not
read the application's generic `R2_*` variables, `R2_BUCKET_NAME`,
`R2_EMAIL_ATTACHMENT_BUCKET_NAME` or `R2_PUBLIC_URL`.

Secret values are added only after the base image has built successfully and immediately
before the one-off job is created. The Dockerfile must not declare or reference them as
build arguments. Logs may report presence, scope identifiers and expiry, never values.

## 8. Private Bucket And Object Isolation

### 8.1 Dedicated bucket

The proof bucket must:

- be newly created for this Stage C run in the authorised Cloudflare account;
- use a non-customer name such as `isostack-fund-1r-f-a-stage-c-<run-suffix>`;
- have no `r2.dev` public development URL;
- have no custom domain, public Worker binding or public media contract;
- have no CORS policy because the proof is server-to-server;
- contain no pre-existing object; and
- be deleted after zero-residue and credential-revocation evidence is complete.

Cloudflare documents R2 buckets as private by default, but the operator must record the
actual public-development-URL and custom-domain settings before running. A default is not
accepted as evidence.

### 8.2 Exact prefix and keys

One random run prefix is fixed before credential minting:

```text
fund/1r-f-a/stage-c/<run-id>/
```

Each accepted fixture has exactly one deterministic key:

```text
<prefix><fixture-id>.pdf
```

No timestamp, tenant ID, organisation ID, child name, email, Project record ID or other
business identifier is permitted in the bucket name, prefix, key or metadata.

### 8.3 Per-object round trip

For each of the six controlled PDFs, sequentially:

1. calculate local byte length and SHA-256 before upload;
2. `PUT` with `Content-Type: application/pdf`, `Cache-Control: no-store` and metadata for
   checksum, fixture ID, contract version and random run ID;
3. `HEAD` and compare content type, byte length and checksum metadata;
4. `GET` through the authenticated S3 client and compare byte length and SHA-256;
5. `DELETE` the exact key;
6. `HEAD` the exact key and require the documented not-found outcome; and
7. list the exact prefix and require zero returned objects.

No presigned URL or public URL is created. An unauthenticated request to the object endpoint
must not return a success response. The temporary credential must also fail to access an
object outside its authorised prefix.

The final prefix-list zero check is repeated after all six fixtures. Bucket deletion is not
a substitute for proving zero objects first.

## 9. Stage C Runner Boundary

The later implementation candidate may add only a proof-specific runner and mock evidence.
It must:

- call the existing validated six-fixture renderer rather than create another composition;
- retain the existing six refusal fixtures and deterministic repeat evidence;
- validate every Stage C environment field before browser launch;
- compare `RENDER_GIT_COMMIT` with the accepted full candidate SHA;
- refuse missing, expired or more-than-60-minute runtime credentials;
- refuse an empty, malformed or non-run-specific prefix;
- refuse the public media or email-attachment bucket names if they are visible in the
  operator-supplied denylist test fixture;
- use an S3 client that includes the temporary session token;
- track every attempted/created key in memory for `finally` cleanup;
- emit bounded structured evidence without secrets; and
- exit non-zero on any render, checksum, isolation, cleanup or evidence failure.

The runner must measure and record:

- exact commit, container, Node, Playwright, Chromium and font identities;
- Render service ID, instance ID and one-off job ID;
- cold first-fixture and warm repeat-fixture render duration;
- complete six-fixture batch duration;
- per-PDF byte length and checksum;
- peak container memory using the Linux cgroup peak where available, with the measurement
  method stated and a process-tree fallback;
- each PUT/HEAD/GET/DELETE/not-found/list result with request identifiers where safely
  available;
- bounded retry count and reason; and
- final object count, credential expiry and cleanup status.

The evidence JSON must use a versioned Stage C contract and include a top-level status of
`PASS` only after the exact prefix is empty.

## 10. Execution Sequence And Stop Gates

### Phase 0 — Control acceptance — COMPLETE

- control owner accepted the recommended plan on 2026-08-12;
- external resource creation, credential creation and eventual exact deletion are
  explicitly authorised;
- one Starter worker/job with a 15-minute application deadline and 80% memory ceiling is
  accepted; and
- bounded redacted machine evidence and provider identifiers/log excerpts will be retained
  in the version-controlled Stage C lifecycle record; secret values and raw credential
  responses are excluded.

The control window may progress through the later phases without another discretionary
pause, but every objective stop gate still applies.

### Phase 1 — Bounded implementation candidate

- add the Stage C proof runner, tests and package command locally;
- prove failure/cleanup paths with mocked S3 responses;
- rerun local Stage A/R1B and Linux Stage B on the exact candidate;
- require the exact Security Scan to pass; and
- stop for control-window review before any Render or R2 action.

### Phase 2 — Provision private boundary

- create the dedicated empty R2 bucket;
- prove no public development URL/custom domain and zero initial objects;
- create the dedicated bucket-scoped parent token outside Render; and
- record identifiers and scope without recording secret values.

**Stop:** any pre-existing object, public access, wrong scope or uncertain bucket identity.

### Phase 3 — Build exact Render artifact

- create the temporary background worker with the configuration in section 6;
- leave secrets unset;
- deploy the exact full candidate SHA with auto-deploy off;
- record the build/deploy/service identifiers and exact commit; and
- verify the worker is inert and has no inbound URL, database, disk or shared environment.

**Stop:** branch drift, unexpected environment, public route, non-inert command or build
identity mismatch.

### Phase 4 — Mint runtime credentials

- fix one run ID and exact prefix;
- mint one 60-minute temporary R2 credential for that bucket/prefix;
- add only the section 7.3 environment to the temporary service;
- verify secret values do not appear in build or service logs; and
- create exactly one one-off job with the Stage C start command.

### Phase 5 — Execute once

- runner passes all identity/configuration preflight checks;
- six fixtures render sequentially;
- cold/warm, PDF, memory and retry evidence is recorded;
- six object round trips complete sequentially;
- the final prefix list returns zero objects; and
- the job exits with a terminal success status.

**Stop:** do not rerun automatically after any failure.

### Phase 6 — Capture evidence

- capture job/deploy/service identity and terminal status;
- export the bounded structured evidence and relevant redacted logs before Render retention
  can expire;
- verify that no log contains a secret value; and
- record any raw Mac/Linux/Render raster differences without changing the accepted
  normalised comparison policy.

### Phase 7 — Teardown and revoke

Execute the ordered teardown in section 13. Do not mark Stage C complete until every
zero-residue and revocation check passes.

### Phase 8 — Control-window conclusion

The control window creates the implementation and review/test evidence, classifies the
complete Stage C outcome, reconciles source inputs and roadmaps, and stops. This planning
document does not perform that lifecycle work.

## 11. Retry And Idempotency Contract

- Renderer retry remains bounded at two attempts and may retry only its existing classified
  transient failure path.
- Each S3 operation may attempt at most twice, with short bounded backoff, and only for
  classified timeout, connection, throttling or provider 5xx responses.
- Authentication, authorisation, checksum, metadata, public-access, prefix, validation and
  not-found mismatches are never retried as transient success candidates.
- Object keys are deterministic inside one run, so retry cannot create a second key.
- Before retrying `PUT`, `HEAD` the deterministic key. If it exists, verify exact checksum;
  delete and fail on any mismatch.
- `DELETE` is followed by not-found and exact-prefix-list checks regardless of response.
- No job-level automatic rerun exists. A second job is a new controlled execution requiring
  a new run ID, new prefix and explicit authority.

## 12. Failure Recovery Matrix

| Failure point | Mandatory response | Rerun rule |
| --- | --- | --- |
| Candidate build/security/Linux gate | Create no external resources | Fix/review a new exact candidate |
| Bucket public/not empty/wrong account | Create no runtime credential or Render job | Correct or replace bucket, then re-authorise |
| Render build/commit mismatch | Keep secrets unset; delete temporary service/bucket/token | New exact deployment only after review |
| Credential preflight/expiry/scope failure | Do not launch browser or upload | Revoke/replace credential within same exact scope |
| Render failure before first PUT | Run zero-prefix verification and teardown | New job requires new authority/run ID |
| Failure after one or more PUTs | `finally` deletes every known exact key and lists prefix | No rerun until zero residue is independently proved |
| HEAD/GET checksum mismatch | Delete exact key, fail run and retain evidence | New run ID only after cause review |
| DELETE/not-found/list failure | Mark cleanup **BLOCKED**; retain/re-mint same-scope cleanup credential | No rerun and no bucket deletion |
| Job timeout/cancel/SIGTERM | Operator lists exact prefix and deletes only enumerated run keys | New run only after zero proof and review |
| Credential expires before cleanup | Mint cleanup-only temporary credential from same parent and same prefix | Scope must not widen |
| Render logs/evidence unavailable | Treat runtime result as unproved even if objects are zero | New controlled run required |
| Service or credential deletion cannot be verified | Mark teardown **BLOCKED** and stop | No Stage C closure |

Recovery must never use a broad recursive delete, a production/shared credential, the
email-attachment bucket or the public media bucket. If exact targets cannot be enumerated
and validated, stop for control-owner intervention.

## 13. Ordered Teardown And Revocation

After the one-off job is terminal:

1. confirm no Stage C job remains running; cancel the exact job if necessary;
2. list the exact run prefix using the temporary credential;
3. if objects remain, enumerate and delete only those exact run keys;
4. repeat exact-prefix listing and record zero objects;
5. revoke the dedicated parent R2 token, immediately invalidating derived credentials;
6. prove the temporary credential can no longer list the exact prefix;
7. remove all Stage C variables from the temporary Render base service;
8. delete the temporary Render service by exact service ID;
9. verify the service ID/name no longer appears in the authorised Render workspace;
10. revoke the dedicated Stage C Render API key and prove it no longer authenticates;
11. delete the now-empty dedicated R2 bucket through the operator control plane; and
12. verify the bucket name no longer exists and no Blueprint/environment group was created.

If any step fails, stop. Do not retry with broader authority or delete the bucket while its
contents are unknown. Stage C remains incomplete until the same control window records the
resolved teardown evidence.

## 14. Machine Evidence Contract

The later runner should emit one bounded JSON object with at least:

```text
contractVersion
status
runId
startedAt / finishedAt
expectedCommit / renderGitCommit
renderServiceId / renderInstanceId / renderJobId
runtimeIdentity
fixtureCount / refusalCount
determinismEvidence
coldRenderMs / warmRenderMs / batchRenderMs
peakMemoryBytes / memoryMeasurementMethod
pdfEvidence[]
  fixtureId / byteLength / sha256
  put / head / get / delete / notFound / prefixEmpty
retryEvidence[]
credentialScope
  bucket / prefix / expiresAt / sessionCredentialUsed
publicAccessEvidence
finalPrefixObjectCount
cleanupStatus
```

It must never include:

- access key IDs, secret keys, session tokens or Render API keys;
- full environment dumps or request headers;
- customer, child, user, organisation or real Project data;
- public/presigned object URLs; or
- raw provider responses that may echo credentials.

## 15. Acceptance Principles

Stage C may be classified **PASS** only when all of these are true:

1. exact candidate local, Linux and Security gates pass before provisioning;
2. Render builds and runs the exact full candidate SHA;
3. runtime Node, Playwright, Chromium, font and container identities match the accepted
   candidate contract;
4. all six accepted fixtures and six refusals retain their accepted outcomes;
5. cold/warm duration, six-PDF sizes and peak memory are truthfully measured;
6. peak memory remains below 80% of the selected instance memory, leaving a recorded safety
   margin; this is proof capacity evidence, not a production sizing decision;
7. all six PDF object round trips pass exact byte/checksum/metadata comparison;
8. unauthenticated and out-of-prefix access do not succeed;
9. every object is deleted and the final exact-prefix count is zero;
10. the parent R2 token and Render API key are revoked and refusal is proved;
11. the temporary Render service and dedicated R2 bucket are deleted and absence is proved;
12. no secret appears in Git, build output, logs or retained evidence; and
13. no production/staging application, database, shared bucket or later FUND slice changes.

`PARTIAL` is not an acceptable release state for cleanup, credential revocation or resource
deletion. A technically successful render with unproved teardown is **BLOCKED**, not PASS.

## 16. Risk Assessment

| Risk | Likelihood | Impact | Planned control |
| --- | --- | --- | --- |
| Exact-commit drift | Medium | High | Auto-deploy off; manual full SHA; runtime `RENDER_GIT_COMMIT` equality gate |
| Worker restarts/replays proof | Medium | High | Inert base worker plus exactly one one-off job; no run-at-worker-start |
| Credential exposure | Low/Medium | Critical | Parent credentials remain outside Render; temporary session credential; no env/log dumps; secret scan |
| Credential has excessive scope | Medium | High | Dedicated bucket, bucket-scoped parent, prefix-scoped temporary credential, one-hour TTL |
| Public object exposure | Low | Critical | Dedicated private bucket; no `r2.dev`, custom domain, CORS or presigned URL; negative access proof |
| Partial upload residue | Medium | High | Deterministic keys, in-memory key ledger, `finally` cleanup, exact-prefix zero proof |
| Cleanup credential expires | Low/Medium | High | 60-minute TTL around 15-minute job; same-prefix cleanup-only remint path |
| Broad destructive cleanup | Low | Critical | Delete enumerated exact run keys only; stop when target identity/count is uncertain |
| Render API key blast radius | Medium | High | Dedicated short-lived operator-only key; never injected; revoke and prove refusal |
| Secret becomes Docker build input | Low | High | Build before secret injection; Dockerfile must not declare credential ARGs |
| Memory exhaustion on Starter | Medium | Medium/High | Sequential browser; 15-minute bound; cgroup peak evidence; require less than 80% memory |
| Raw raster differs by platform | High | Low/Medium | Exact normalised business/layout comparison remains authoritative; raw hashes diagnostic |
| Provider/log retention loses evidence | Low/Medium | High | Export bounded redacted evidence before teardown/retention expiry |
| External deletion fails | Low | High | Mark BLOCKED; retain exact identifiers; no broader retry or false closure |
| Cost/resource left running | Low/Medium | Medium | One job, Starter, no disk; ordered service/job deletion and absence proof |

## 17. Explicitly Excluded Scope

- production renderer service or queue;
- public or authenticated artwork download;
- production bucket selection, retention, lifecycle or legal policy;
- tenant, C1/C2, Project, Store, child, purchaser or Order persistence;
- schema, migration, API route, UI or shared service changes;
- email attachment or public media storage changes;
- customer-supplied template content or real logos/data;
- multi-process, concurrency, load, scale, failover or production SLO testing;
- `1R-F-B`, collective/Standard template work, `1R-G` or `1R-H-A`;
- staging/main promotion; and
- any claim that proof capacity values are production policy.

## 18. Authorised Bounded Implementation Workstreams

The accepted minimum candidate work comprises:

1. a proof-specific Stage C runner under `scripts/proofs/fund-1r-f-a/`;
2. a versioned machine-evidence type and redaction boundary;
3. an isolated temporary-session R2 client using the existing AWS SDK dependency;
4. mock tests for preflight, success, transient retry, checksum mismatch, partial upload,
   expired credentials and failed cleanup;
5. one package command for the one-off job;
6. Docker proof-directory inclusion only if the existing copy boundary does not already
   include the new runner; and
7. later control-window implementation/review/teardown documentation.

Do not modify `src/lib/r2.ts` merely for the proof. Its public-media and email-attachment
contracts are production application code and use different environment/ownership
boundaries.

## 19. Dependencies And Retroactive Implications

- Stage C depends on the accepted `139d09c4` Stage B baseline but must deploy the later exact
  candidate containing the bounded Stage C runner.
- A Stage C failure does not invalidate accepted R1B source/physical evidence or Stage B
  Linux parity unless it identifies a reproducible renderer defect.
- Stage C private-object success proves only S3-compatible feasibility. It does not select
  the future production artwork bucket or settle retention/access policy.
- Candidate Render timing/memory/PDF-size evidence may inform later production planning but
  cannot itself authorise a production plan, plan tier or capacity.
- Any discovered need for shared application R2 changes, database access or persistent
  service infrastructure is a planning failure and must return to the control window.

## 20. Recorded Control-Owner Decisions

The 2026-08-12 execution instruction records these answers:

1. use the inert temporary worker plus one-off-job topology;
2. use one Starter instance, a hard 15-minute runner deadline and an 80% peak-memory ceiling;
3. create one dedicated private R2 bucket and delete it after zero-residue evidence;
4. use a one-hour prefix-scoped temporary credential derived from a dedicated bucket-scoped
   parent token, then revoke the parent;
5. use a dedicated operator-only Render API key and revoke it after teardown;
6. retain the redacted machine evidence and provider identity/log excerpts in the
   version-controlled lifecycle record, while retaining no secret values; and
7. treat implementation, exact-commit gates, external execution and teardown as one
   controlled window, subject to every stop gate in this plan.

These decisions authorise execution but do not pre-judge its result. Stage C becomes PASS
only after the exact run, zero-object proof, resource absence and credential-revocation
evidence are all recorded.
