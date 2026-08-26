# FUND Phase 1 Slice 1R-F-A Stage C — Exact Candidate And External Execution Gate

Date: 2026-08-12

Restart checkpoint reconciled: 2026-08-26

Status: **RESUMED AS ROOT NOW — EXACT `328aadf0` LOCAL, LINUX AND SECURITY GATES PASS;
PHASE 3 STOP GATE ACTIVE AFTER WRONG-REVISION RENDER BUILD; RUNTIME CREDENTIAL/JOB NOT
AUTHORISED**

Control depth: **`High`** — dedicated credentials, runtime configuration, a material
external-service contract, private-object handling and exact resource teardown require the
full failure, rollback, negative-access, revocation and absence evidence already defined by
the accepted plan.

Work type: **ASSUMPTION TEST — NOT A PRODUCTION BUILD**

Plain-language boundary: Stage C temporarily tests whether the accepted renderer and
private, scoped R2 access model work together in isolated Render Linux. Every provider
resource, credential and local credential record created for the test must be removed or
revoked and proved absent. Only the proof code and redacted evidence remain. A PASS informs
later production planning; it does not build or authorise the production storage,
credential, backup, recovery, retention or operating model. In this record, `teardown`
means “remove and revoke the temporary test setup and prove nothing remains”.

Planning authority:

[`1R-F-A Stage C temporary Render/private-object proof`](../03-slice-planning/2026-08-12-fund-phase-1-slice-1r-f-a-stage-c-temporary-render-private-object-proof-planning.md)

Implementation confirmation:

[`1R-F-A Stage C implementation confirmation`](../04-implementation-confirmations/2026-08-12-fund-phase-1-slice-1r-f-a-stage-c-isolated-render-private-object-proof-implementation-confirmation.md)

```text
Exact commit: 328aadf0a360b4c65837327060302ddc525f6168
Files/change boundary: bounded proof runner/tests/script/docs only; no schema, route, shared R2 utility or render.yaml change
Automated checks: local proof, Linux parity 31599134487 and Security Scan 31599134488 PASS
Human evidence: accepted R1B source/physical review 12/12 PASS; control-owner 2026-08-26 provider inspections and credential-retention checks recorded; initial wrong-build containment recorded; subsequent exact-deploy log proves full `328aadf0` checkout, pinned image identities and terminal live state
Environment proven: local and pinned Linux candidate; exact dedicated R2 bucket remains empty/private; fresh run `8ef3e1af-12ad-40b1-987a-de9ec0a9f9cd` passes exact-prefix-zero/out-of-prefix-403 preflight and exact twelve-name/value Render read-back with 3598 seconds; worker remains suspended with auto-deploy Off/no deployment/job
Known residual risk: execution remains unproved; credential removal/revocation and resource absence remain pending; corrected execution would require new explicit authority
Next authorised action: human explicitly chooses controlled teardown, or newly authorises one corrected attempt with resume → exact manual `328aadf0` deploy → suspend → verify latest exact → no further resume → fresh bounded credential/job

Current state: Stage C single job failed closed because a second resume replaced accepted exact artifact with current dev head; exact prefix zero, one job/no second job, cause fully reconciled, human disposition pending and no Stage C pass claimed
Last proven commit: 328aadf0a360b4c65837327060302ddc525f6168
Current environment: candidate preserved in current ancestry; exact worker `srv-da7au58u01pc738qld00` remains suspended with auto-deploy Off; run `8ef3e1af-12ad-40b1-987a-de9ec0a9f9cd` was configured with prefix zero/out-of-prefix 403; single Starter job `job-da7cu29srm7s7385o5g0`, accepted command, created `11:33:29.465286145Z`, started `11:33:29Z`, finished `11:34:30Z`, terminal `failed`; final job count one and no second job exists
Next human decision/test: choose teardown or explicitly authorise one corrected attempt; no external mutation until that decision
Safe resumption point: if teardown, remove/revoke retained test resources; if corrected attempt, resume once, manually deploy exact `328aadf0`, suspend, verify latest exact and never resume again before fresh credential/job
```

## 1. Gate Rule

Stage C is one indivisible evidence gate:

```text
exact candidate gates
-> dedicated private bucket and prefix-scoped temporary credentials
-> temporary Render worker, auto-deploy off, exact candidate build
-> one one-off job
-> six private PDF checksum round trips
-> zero exact-prefix objects
-> credential revocation and refusal
-> Render service and R2 bucket deletion/absence
-> PASS
```

A successful renderer/object run without verified cleanup, revocation and resource absence
is **BLOCKED**, not partial acceptance.

## 2. Exact Candidate Gate

| Check | Evidence | Result |
| --- | --- | --- |
| Exact application candidate | `328aadf0a360b4c65837327060302ddc525f6168` | PASS |
| Diff boundary | Proof runner/tests/script/docs only; no schema, route, shared R2 utility or `render.yaml` change | PASS |
| Existing renderer + Stage C tests | 2 files / 9 tests | PASS |
| TypeScript | `npm run type-check` | PASS |
| Repository verification | `npm run verify` | PASS |
| Production build | `npm run build` | PASS |
| Local formatting/diff/pre-commit | Green | PASS |
| Dev alignment | local `dev` = `origin/dev` = exact candidate | PASS |
| Linux container parity | [Run `31599134487`](https://github.com/isocb/isostack-bedrock/actions/runs/31599134487): immutable container build, 9-test proof run and normalised comparison | PASS |
| Exact Security Scan | [Run `31599134488`](https://github.com/isocb/isostack-bedrock/actions/runs/31599134488): dependency, Prisma, TypeScript and Gitleaks jobs | PASS |

The unrelated `1july2026.code-workspace` modification was neither staged nor committed.
Staging and main remain at `cde4eaff1e14b2f02ba0953fe8693e7feb02bb61`.

## 3. Provider Readiness

Read-only readiness inspection found:

- no Render CLI or Wrangler CLI installed;
- no Render/Cloudflare administrative environment-variable names in the current shell;
- no Render/Cloudflare credential records in macOS Keychain;
- no GitHub repository/environment secret names providing those authorities; and
- existing local application R2 S3 credentials, which are deliberately not treated as
  authority to create the proof bucket or as the required dedicated Stage C parent token.

The 2026-08-26 resumption inspection additionally found no local Render or Wrangler CLI,
no Render/Cloudflare/Stage-C environment-variable names and no authenticated provider
connection available to this control window. These are local capability findings only;
they do not prove the current Render workspace, worker, Cloudflare account, bucket, token or
public-access state.

The control owner then completed a read-only Render dashboard inspection on 2026-08-26 and
reported no matching Stage C service. No service was resumed, edited, deployed or deleted,
and no service ID or one-off job exists to carry forward from that inspection. This
supersedes the prior suspended-worker claim but does not prove the Cloudflare/R2 boundary or
authorise creation of a replacement worker.

The control owner then completed a read-only Cloudflare R2 dashboard inspection on
2026-08-26 and reported:

- account ID `43e9ed0a07538f8859168b9c692c91f9`;
- exact bucket `isostack-fund-1r-f-a-stage-c-964210fa`, located in Western Europe (`WEUR`);
- object count zero;
- public-development URL disabled and no custom domain;
- no CORS policy, bucket-lock rule or event notification;
- no connected Worker/binding shown;
- only Cloudflare's default rule to abort incomplete multipart uploads after seven days;
  and
- active parent token `FUND-1R-F-A-Stage-C-2026-08-12`, with Object Read & Write permission
  scoped only to the exact bucket and TTL `forever`; no credential value was shared.

This passes the Phase 2 bucket identity, initial-empty-list and private-access boundary. The
default multipart-abort rule is provider baseline behaviour and does not replace Stage C's
immediate exact-key deletion and final zero-prefix proof. Parent-token usability, secure
retention, revocation/refusal, temporary credential issuance and all Render execution remain
unproved.

The control owner then deleted exact stale token `FUND-1R-F-A-Stage-C-2026-08-12` on
2026-08-26. No replacement token, Render service or temporary credential was created, and
the bucket remained the exact empty/private boundary recorded above. This deletion closes
the stale-token exposure; it is not the final revocation/refusal proof for the fresh parent
token that will govern the one-off execution.

The control owner then created fresh token `FUND-1R-F-A-Stage-C-2026-08-26` with Object Read
& Write permission restricted to the exact bucket and the shortest available TTL of 24
hours. The token value, R2 access-key ID and R2 secret access key were retained as three
separate named generic-password records in the control owner's macOS login Keychain; the
control owner verified all three records from Terminal without sharing their values. The
agent's isolated macOS process could not resolve those login-Keychain records, so this is
control-owner evidence rather than independent credential usability proof. No credential
value entered command output, Git or this record. Parent-token usability and temporary
credential issuance remain objective gates, and this fresh parent token must still be
revoked with refusal proved during teardown even if its 24-hour TTL has elapsed.

This is not yet a failed gate: no external resource should exist before the exact Linux and
Security gates pass. The fresh dedicated Cloudflare/R2 parent-token authority now exists.
Before Phase 3 begins, the control window still requires a dedicated operator-only Render
API key retained outside Render. No secret value may enter Git, documentation, command
output or shell history.

The control owner then created dedicated Render API key
`FUND-1R-F-A-Stage-C-2026-08-26` for workspace `Isostack` and verified its named macOS
Keychain record from Terminal without sharing the value. The agent's isolated process did
not retrieve the credential; this is control-owner retention evidence, while actual API
authentication remains an objective gate. The key must never enter the worker environment
and must be revoked, rejected and removed from the local credential store after the
temporary Render resource is proved absent.

At 2026-08-26 09:20 UTC the control owner accidentally submitted the new background-worker
form before setting auto-deploy to Off. The supplied Render log proves that the initial
build checked out `d78935d407ace7ebe796a31a13adf3e17dafa758` from `dev`, built the accepted proof
Dockerfile inputs and reached `Deploying...`. The log contains no worker-runtime line,
proof-runner invocation, Stage C variable, R2 operation or credential value. Auto-deploy was
then set to Off and the worker was suspended and resumed. Later dashboard evidence identifies
the exact service as `srv-da7au58u01pc738qld00`, name
`isostack-fund-1r-f-a-stage-c-964210fa`, status `Suspended`, latest event
`Manually Suspended`, auto-deploy Off and the accepted inert Docker command. It also records
no linked environment group, secret file or disk. The control owner subsequently confirmed
one user-defined variable, reported as `PORT`; its five-digit value was not shared or
recorded. Render documents `PORT` as an optional web-service setting. This background worker
has no inbound traffic and the accepted inert command does not use it, so it is not treated
as a credential exposure. It nevertheless violated the empty-worker gate. The control
owner removed only that variable using Save only and subsequently confirmed zero user
variables, status `Suspended`, auto-deploy Off and no unexpected deploy. The empty-worker
configuration boundary therefore passes without having run either revision.

The control owner then confirmed that the dashboard does not display Manual Deploy while
the worker is suspended. The bounded correction therefore requires resuming only this
isolated service. The current wrong artifact may run briefly because its command is proved
inert and it has no credential, service link, environment group, secret file or disk. It
remains unacceptable evidence and must be replaced immediately by a specific-commit deploy.

The control owner completed that correction: supplied logs prove checkout of full
`328aadf0a360b4c65837327060302ddc525f6168`, the accepted pinned Node and Playwright image
digests, terminal green/live state, auto-deploy Off and zero user variables. The supplied
“Deploy ID” is a link to the GitHub commit rather than Render's provider deployment ID, so
the required provider identifier remained to be captured without changing the service. The
control owner then supplied exact Render deployment `dep-da7b87i3v7hc73et4ui0`, completing
the Phase 3 service/build identity boundary.

The first Phase 4 helper request went directly from the control owner's Mac to Cloudflare's
temporary-credential endpoint and returned HTTP 403/code 10000. Cloudflare returned no
credential result, so the helper did not reach its Keychain-write path; no temporary local
record, Render variable or job was created. This denial is unrelated to the removed Render
`PORT` variable, which is not read by the helper and cannot affect a Mac-to-Cloudflare API
request. Do not retry the mint until the stored parent token is verified read-only.

The read-only verification returned HTTP 200 with `success=true`, token status `active`,
expiry `2026-08-27T08:23:56Z`, and equality between the returned token ID and stored parent
access-key ID. This excludes expiry and identity mismatch as the cause of the 403. Cloudflare
documents local JWT signing with the same parent secret as an alternative temporary-
credential method. That path preserves the accepted parent/bucket/prefix/permission/TTL
boundary and avoids widening authority; it must pass exact-prefix-empty and out-of-prefix-
denied preflight before its three derived values are retained or configured.

The bounded local-signing fallback then passed with run ID
`ff63e2ec-528f-45f3-9505-ffe85bdbd59d`, exact prefix
`fund/1r-f-a/stage-c/ff63e2ec-528f-45f3-9505-ffe85bdbd59d/`, expiry
`2026-08-26T10:59:48Z`, permission `object-read-write`, TTL 3600 seconds, exact-prefix object
count zero, out-of-prefix HTTP 403 and three verified temporary Keychain items. No secret
value was printed or retained in evidence. The worker is manually suspended with auto-
deploy Off; only the accepted environment may now be configured without deployment.

The bounded Render environment helper then authenticated through the retained operator key,
confirmed the direct environment was empty, replaced it with exactly the twelve accepted
Stage C variables, and read back all twelve key names successfully. It reported 3200 seconds
of credential life, API update without deployment and `JOB_CREATED=false`; no credential
value was printed. Immediate dashboard inspection proved the worker remained suspended,
auto-deploy remained Off and no unexpected deployment started, but reported environment
count zero. Two subsequent no-cache HTTP 200 reads again proved all twelve keys without
mutation; the hard-refreshed Environment page then agreed on count twelve. The disagreement
was display staleness, not configuration loss. The one-hour credential nevertheless expired
safely before execution, so fresh run/prefix/credential values are required before the job.

Fresh run `8ef3e1af-12ad-40b1-987a-de9ec0a9f9cd` then passed exact-prefix zero,
out-of-prefix HTTP 403 and exact twelve-name/value Render read-back with 3598 seconds
remaining. Exactly one Starter job, `job-da7cu29srm7s7385o5g0`, was created with the accepted
command and 2967 seconds remaining. It moved pending to running to failed from `11:33:29Z`
to `11:34:30Z`; final job count is one and no second job exists. Its log reports only
`Render commit differs from Stage C authority`. The runner performs that validation before
creating the renderer or R2 client, so it produced no Stage C storage operation or PASS
evidence. No rerun is authorised.

The bounded read-only diagnostic then used the retained parent R2 authority to list the
exact run prefix at zero objects. It also proved the worker remains `suspended` with auto-
deploy `no`, and identified the artifact mismatch: latest deployment
`dep-da7ck6u7bikc73a9j7lg` is `live` at rejected `d78935d407ace7ebe796a31a13adf3e17dafa758`,
whereas accepted deployment `dep-da7b87i3v7hc73et4ui0` is `deactivated` at exact
`328aadf0a360b4c65837327060302ddc525f6168`. No mutation was performed. Deployment trigger
and timestamp history remain the next read-only diagnostic before disposition.

The complete seven-deployment history resolves that remaining question. Accepted manual
deployment `dep-da7b87i3v7hc73et4ui0` at exact `328aadf0` finished at `09:40:24Z`. A later
`service_resumed` deployment, `dep-da7ck6u7bikc73a9j7lg`, began at `11:12:27Z`, selected
current `dev` head `d78935d4` and became live at `11:14:12Z`, deactivating the accepted
artifact. The environment API did not trigger that deployment. Auto-deploy `no` does not
prevent a deployment caused by resuming the service. A corrected attempt therefore requires
an explicit new authorisation and the exact sequence resume once, manually deploy accepted
commit, suspend, verify latest exact, then never resume again before credential/job execution.

Local comparison also shows that `d78935d4` is not identical to accepted candidate
`328aadf0` inside the proof build boundary: root `tsconfig.json` and
`scripts/proofs/fund-1r-f-a/tsconfig.json` differ. The wrong-revision build therefore cannot
be accepted by ancestry or treated as an equivalent exact artifact. Phase 3 is contained at
its planned commit-mismatch stop gate. No runtime credential or one-off job is authorised
until the worker is resumed only for this correction and exact `328aadf0` reaches a terminal
deploy state.

## 4. External Execution Evidence — Pending

| Required evidence | Result |
| --- | --- |
| Dedicated bucket identity, empty initial list, no `r2.dev`, domain or CORS | PASS — control-owner dashboard inspection; exact WEUR bucket recorded above |
| Dedicated parent token scope retained outside Render | PASS — fresh exact token is Object Read & Write scoped only to the exact bucket, has a 24-hour TTL and is retained in the control owner's macOS Keychain; usability remains a later objective gate |
| Dedicated Render operator key retained outside the service | PASS — control-owner Terminal verification of the named Keychain record for workspace `Isostack`; successful environment update/read-back proves API authentication without exposing the value |
| Temporary worker has no route/disk/database/env group and auto-deploy is off | PASS — exact worker identity, manual suspension, auto-deploy Off, inert command, no linked environment group, no secret file, no disk and no unexpected deployment are proved; two HTTP 200 API reads and hard-refreshed dashboard agree on twelve accepted keys |
| Exact Render build commit and inert base process | STOP — accepted deployment `dep-da7b87i3v7hc73et4ui0` proves exact `328aadf0` but is deactivated; latest live deployment `dep-da7ck6u7bikc73a9j7lg` is rejected `d78935d4`; seven-record trigger/timestamp history pending |
| One-hour prefix-scoped temporary session credential | PASS — documented local signing; fresh run `8ef3e1af-12ad-40b1-987a-de9ec0a9f9cd`, exact prefix, expiry `2026-08-26T12:22:56Z`, object-read-write/3600 seconds, prefix zero, out-of-prefix 403 and three verified temporary Keychain items |
| Out-of-prefix and anonymous access denied | PENDING |
| Six PUT/HEAD/GET/checksum/DELETE/not-found/list-empty sequences | PENDING |
| Node/Playwright/Chromium/font/container identity | PENDING |
| Cold/warm/batch timing and peak memory below 80% | PENDING |
| Job terminal success and final exact-prefix object count zero | STOP — exactly one job `job-da7cu29srm7s7385o5g0` terminal `failed` at the pre-storage commit guard; independent parent-authority exact-prefix count is zero |

## 5. Teardown And Revocation Evidence — Pending

| Required evidence | Result |
| --- | --- |
| Exact prefix independently listed as empty | PASS — retained parent authority read-only listing returned exact-prefix object count zero after terminal job failure |
| Dedicated R2 parent token revoked | PENDING |
| Derived temporary credential rejected after revocation | PENDING |
| Stage C variables removed | PENDING |
| Temporary Render service deleted and exact ID/name absent | PENDING |
| Dedicated Render API key revoked and rejected | PENDING |
| Dedicated empty R2 bucket deleted and exact name absent | PENDING |
| Named local Stage C credential records deleted and absent | PENDING |
| No database, disk, hostname, shared data or customer object created | PENDING |

## 6. Current Disposition

Stage C is the restored root `Now`; resume only from the checkpoint above. Do not promote
staging/main or start `1R-F-B`, `1R-G` or `1R-H-A`.
The record may become PASS only when every pending exact-candidate, execution and teardown
row is replaced by evidence.
