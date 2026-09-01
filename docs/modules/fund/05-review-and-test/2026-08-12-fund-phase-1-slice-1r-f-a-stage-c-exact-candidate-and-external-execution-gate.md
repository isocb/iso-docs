# FUND Phase 1 Slice 1R-F-A Stage C — Exact Candidate And External Execution Gate

Date: 2026-08-12

Restart checkpoint reconciled: 2026-09-01

Status: **PRIOR STAGE C FAIL CONTAINED; STAGE C-R1 EXACT `0c7e4848` EXTERNAL BEHAVIOURAL
PROOF PASS; ZERO OBJECT/RENDER RESIDUE PASS; FINAL PROVIDER REVOCATION, BUCKET DELETION AND
LOCAL-RECORD ABSENCE PENDING; NO PRODUCTION MODEL BUILT OR AUTHORISED**

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
Exact commit: corrected candidate 0c7e48489aef697c6f39faf1a081456f9f3858a4; prior failed candidate 328aadf0a360b4c65837327060302ddc525f6168 retained as historical evidence
Files/change boundary: Stage C-R1 changes only renderer.ts browser-context layout collection; no template, fixture, threshold, schema, route, shared R2 utility or render.yaml change
Automated checks: corrected local proof and focused 9/9 PASS; proof/application TypeScript and repository verification PASS; Linux parity 32970902854 and Security Scan 32970902848 PASS
Human evidence: accepted R1B source/physical review 12/12 PASS; control-owner created the exact fresh provider authority through the prompt-only boundary; agent-operated provider/API evidence proves the external behaviour and current cleanup state
Environment proven: exact R1 prefix zero; Render direct variables 12 -> 0, exact service deletion returned 204 then ID/list absence; no derived credential was written to Keychain; the empty private bucket and two provider credentials remain only for final deletion/revocation proof
Known residual risk: external renderer/private-object behaviour is now proved for this bounded test only; it does not establish a production operating model, and final provider/local revocation evidence remains incomplete
Next authorised action: remove the exact empty proof bucket, revoke the two named provider credentials, prove refusal/absence from retained local records, then delete those records and temporary helpers

Current state: Stage C-R1 external behavioural evidence PASS; Render/object cleanup PASS; final provider/local cleanup pending
Last proven commit: 0c7e48489aef697c6f39faf1a081456f9f3858a4
Current environment: dev/origin-dev exact; run prefix zero; Render variables and disposable service absent; empty private bucket, dedicated Cloudflare token, dedicated Render key and three local parent/provider records remain for final revocation/absence proof
Next human decision/test: delete the exact empty bucket and Cloudflare token, revoke the exact Render key, and report only completion booleans
Safe resumption point: never rerun the job; use retained records only to prove provider rejection/absence, then remove the three exact Keychain records and all temporary helpers before final reconciliation
```

### Stage C-R1 credential-origin containment — 2026-08-26

The first replacement-credential entry attempt exposed the three newly created values in
the collaboration transcript and literal Terminal commands. The agent stopped before using
any credential or creating any Render service, variable, derived credential, object or job.
It deleted and proved absence of all three exact local Keychain records. The control owner
then revoked both provider credentials, deleted the empty dedicated bucket, ran `fc -p` and
closed the originating Terminal session. A subsequent disk check found six matching Zsh
history entries despite that precaution; the agent removed only entries containing the
exact Stage C-R1 credential-record prefix and independently proved zero history matches and
zero matching Keychain records.

No secret value is retained in this evidence. Replacement credentials must be entered only
through a local prompt-only helper that invokes macOS `security ... -w` without a value;
they must not enter shell variables, command arguments, history, chat or documentation.

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
prevent a deployment caused by resuming the service. The control owner subsequently provided
the explicit new authorisation and reports the sequence resume once, manually deploy accepted
commit to green, then suspend complete. Read-only API proof of latest manual/live/exact,
suspension, auto-deploy `no` and original-job-only is required before credential/job action.

That corrected-base verification passed at deployment `dep-da7d78a3v7hc73eug70g`, manual,
live and exact `328aadf0`, with the worker suspended, auto-deploy `no` and only original
failed job `job-da7cu29srm7s7385o5g0`. Fresh run
`345d4353-3af7-4a7e-93ba-11c3e1fcf6f9` then passed exact-prefix zero, out-of-prefix 403 and
exact twelve-name/value read-back with 3598 seconds remaining. Corrected Starter job
`job-da7dbsh42hec73b401pg` passed the same inline gates with 3387 seconds, then moved pending
to running to terminal `failed` from `12:02:58Z` to `12:03:51Z`. Final job count is two and
no third job was created. No further attempt is authorised; log diagnosis and cleanup follow.

The corrected job log then identified the exact runtime failure:
`page.evaluate: ReferenceError: __name is not defined`, originating inside Playwright's page
evaluation utility. The corrected job had already proved exact artifact, service and fresh
credential/environment gates, so this is a proof-runner browser-context serialization defect,
not deployment identity, Cloudflare credential scope or R2 access. No
`FUND_STAGE_C_EVIDENCE` was produced and no behavioural Stage C PASS is claimed.

The same command then reproduced the identical error locally, with the stack identifying
`collectLayout` at `scripts/proofs/fund-1r-f-a/renderer.ts:157` and its caller at line 303.
This confirms the nested function serialized through `page.evaluate` references the
transpiler's `__name` helper, which is not defined inside the Chromium page context. The
diagnosis requires no provider mutation; correction/new-candidate work remains separate.

Local comparison also shows that `d78935d4` is not identical to accepted candidate
`328aadf0` inside the proof build boundary: root `tsconfig.json` and
`scripts/proofs/fund-1r-f-a/tsconfig.json` differ. The wrong-revision build therefore cannot
be accepted by ancestry or treated as an equivalent exact artifact. Phase 3 was contained at
its planned commit-mismatch stop gate. The later corrected attempt proved exact `328aadf0`
before execution, then exposed the independent runner serialization defect recorded above.

Teardown then proceeded without another job. The bounded Render environment call replaced
the twelve direct variables with an empty array and read back zero while preserving the
suspended/auto-deploy-off state, exact latest deployment and final count of two failed jobs.
The exact service deletion then passed those same fail-closed preconditions, returned HTTP
204 and was independently absent both by ID (HTTP 404) and filtered service list.

The retained parent R2 credentials again listed the complete bucket at zero objects. S3
container deletion was refused with HTTP 403 `AccessDenied`; no object deletion occurred and
a read-only check proved the bucket remained empty. The control owner then deleted that
exact empty bucket through Cloudflare. Independent S3 readback returned HTTP 404
`NotFound`, proving the exact bucket absent. The three expired derived session-credential
Keychain records were then deleted and independently found absent.

The control owner deleted exact Cloudflare token
`FUND-1R-F-A-Stage-C-2026-08-26` and revoked the dedicated temporary Render API key. The
retained local values were used only for refusal proof: Cloudflare user and account verify
endpoints each returned HTTP 401/code 1000, and Render returned HTTP 401. The final four
parent/provider Keychain records were then deleted; combined with the three derived records,
all seven named Stage C local credential records are absent and no secret value entered the
evidence. A final exact filename scan returned no Stage C temporary helper file.

The actual removal order differed from section 13: the exact bucket-scoped parent authority
was retained through the complete zero-object and bucket-absence checks, and the Render key
was retained through service deletion/absence. This avoided losing the only bounded cleanup
and verification authorities, did not widen scope, and ended with objective 401 refusal
before local deletion. The deviation is recorded explicitly rather than presenting the
planned order as the observed order.

## 4. External Execution Evidence — Complete, Behaviour Not Proved

| Required evidence | Result |
| --- | --- |
| Dedicated bucket identity, empty initial list, no `r2.dev`, domain or CORS | PASS — control-owner dashboard inspection; exact WEUR bucket recorded above |
| Dedicated parent token scope retained outside Render | PASS — fresh exact token is Object Read & Write scoped only to the exact bucket, has a 24-hour TTL and is retained in the control owner's macOS Keychain; usability remains a later objective gate |
| Dedicated Render operator key retained outside the service | PASS — control-owner Terminal verification of the named Keychain record for workspace `Isostack`; successful environment update/read-back proves API authentication without exposing the value |
| Temporary worker has no route/disk/database/env group and auto-deploy is off | PASS — exact worker identity, manual suspension, auto-deploy Off, inert command, no linked environment group, no secret file, no disk and no unexpected deployment are proved; two HTTP 200 API reads and hard-refreshed dashboard agree on twelve accepted keys |
| Exact Render build commit and inert base process | PASS — corrected latest deployment `dep-da7d78a3v7hc73eug70g` is manual/live at exact `328aadf0`; worker is suspended with auto-deploy `no` and inert base command |
| One-hour prefix-scoped temporary session credential | PASS — documented local signing; corrected run `345d4353-3af7-4a7e-93ba-11c3e1fcf6f9`, exact prefix, expiry `2026-08-26T12:59:26Z`, object-read-write/3600 seconds, prefix zero, out-of-prefix 403 and three verified temporary Keychain items |
| Out-of-prefix and anonymous access denied | PARTIAL — out-of-prefix 403 proved in preflight; corrected runner failed before anonymous-object test |
| Six PUT/HEAD/GET/checksum/DELETE/not-found/list-empty sequences | NOT OBTAINED — accepted runner failed before the first sequence; assumption remains unproved |
| Node/Playwright/Chromium/font/container identity | FAIL — exact container reached Playwright execution but serialized `page.evaluate` code referenced unavailable `__name`; local reproduction confirms deterministic runner defect |
| Cold/warm/batch timing and peak memory below 80% | NOT OBTAINED — runner stopped before measurements |
| Job terminal success and final exact-prefix object count zero | STOP — corrected job `job-da7dbsh42hec73b401pg` failed at renderer serialization after inline gates; two jobs/no third; independent parent-authority fresh-prefix count is zero |

## 5. Teardown And Revocation Evidence — Pass

| Required evidence | Result |
| --- | --- |
| Exact prefix independently listed as empty | PASS — retained parent authority read-only listing returned corrected fresh-prefix object count zero after terminal job failure |
| Dedicated R2 parent token revoked | PASS — control-owner deletion; retained value subsequently rejected at both Cloudflare verify endpoints with HTTP 401/code 1000 |
| Derived temporary credential rejected after revocation | PASS end state — parent token is rejected, all three derived-value records are absent and the target bucket is absent; no separate derived replay was possible after those records were removed |
| Stage C variables removed | PASS — direct environment count changed from twelve to zero by API update without deploy; suspension/off, exact deploy and two-job state were preserved |
| Temporary Render service deleted and exact ID/name absent | PASS — exact preflight passed; DELETE returned 204; subsequent exact-ID read returned 404 and filtered service list had no match |
| Dedicated Render API key revoked and rejected | PASS — control-owner revocation; retained value subsequently returned HTTP 401 from Render |
| Dedicated empty R2 bucket deleted and exact name absent | PASS — complete parent-authority listing was zero; control-owner deleted the exact bucket after S3 container deletion was refused under object-only authority; independent readback returned 404 `NotFound` |
| Named local Stage C credential records and helpers deleted and absent | PASS — three derived plus four parent/provider records deleted; all seven exact record names absent; all seventeen exact temporary helper files absent |
| No database, disk, hostname, shared data or customer object created | PASS — worker had no disk/route/database/environment group, exact run prefix remained zero and both isolated provider resources are absent |

## 6. Prior Stage C Disposition

Stage C is complete with result **FAIL — assumption not proved**. The accepted exact
candidate reached browser execution but its deterministic `__name` serialization defect
prevented the private-object round-trip evidence. This is not a Cloudflare or Render
security-model failure and is not a production-build result. Zero-residue and credential
revocation pass in full.

Do not promote staging/main, reopen Stage C, correct the runner or start `1R-F-B`, `1R-G` or
`1R-H-A` automatically. The next action is a deliberate control-owner portfolio selection;
any local runner correction and new exact candidate must be separately accepted.

## 7. Stage C-R1 External Execution Evidence — 2026-09-01

The control owner created exact disposable provider authority and entered its three values
only through the prompt-only Keychain helper. The agent then operated the accepted one-off
workflow. A read-only preflight proved the exact bucket empty, cross-bucket access denied
with HTTP 403 and anonymous S3-endpoint access refused. Render returned the workspace label
`My Workspace`, differing from the earlier recorded `Isostack` label; read-only listing
proved that exact workspace owns all four existing `isocb/isostack-bedrock` services, so
the difference is reconciled as provider display-name drift rather than a different account.

The agent created disposable background worker `srv-dab9dip42hec73a9vuvg` with auto-deploy
`no`, no initial environment values, Starter plan, Frankfurt region, the accepted inert
command and proof Dockerfile. Initial deployment `dep-dab9dj142hec73a9vvtg` reached `live`
at exact full commit `0c7e48489aef697c6f39faf1a081456f9f3858a4`; the worker was then
suspended before any runtime credential was installed.

Locally signed one-hour credential run `70e0f321-b64f-44ac-8598-bbc6c6098ff4` was restricted
to exact prefix `fund/1r-f-a/stage-c/70e0f321-b64f-44ac-8598-bbc6c6098ff4/`. The prefix
began empty, out-of-prefix HEAD returned HTTP 403, and exact readback of the twelve accepted
Render variables passed. Exactly one Starter one-off job, `job-dab9eirtqb8s73f7r5n0`,
ran `npm run proof:fund:1r-f-a:stage-c` and reached terminal `succeeded`.

| Required evidence | Stage C-R1 result |
| --- | --- |
| Exact candidate/runtime gate | PASS — deploy and runner both report exact `0c7e48489aef697c6f39faf1a081456f9f3858a4` |
| Private/scope negative tests | PASS — cross-bucket parent request 403; temporary out-of-prefix request 403; anonymous object-endpoint preflight refused |
| Controlled renderer fixtures/refusals | PASS — six accepted fixtures and six refusal fixtures |
| Six private PDF round trips | PASS — each PUT/HEAD/GET/DELETE used one attempt; checksum, not-found and prefix-empty checks pass |
| Timing | PASS — cold `2908.62 ms`, warm `1904.02 ms`, complete batch `22627 ms` |
| Memory | PASS — cgroup-v2 peak `353406976` bytes, ratio `0.6582717895507812`, below the accepted `0.8` ceiling |
| Job bound | PASS — exactly one job created; terminal `succeeded` |
| Final object state | PASS — structured report and independent operator listing both return exact-prefix count zero |

PDF evidence, in controlled fixture order:

| Fixture | Bytes | SHA-256 |
| --- | ---: | --- |
| `portrait-short-no-logo` | 16067 | `6663fcbe32b2791a5225d4fd09aab1676255bda921d89a87cccf60e43939aa80` |
| `landscape-short-with-logo` | 30489 | `690ca453612a9536056095882b0381dceb8abf788815eedc74024b9ed86a7c79` |
| `portrait-long-content` | 16314 | `dc92e82887f931c2665beda716896e1f6e699e1653d0ff7eacc6672f9ea4d424` |
| `landscape-long-content` | 30391 | `9789a5f25951ef0996c20aef752c2ffb0550db034de77b63b597dbf3ae357c86` |
| `portrait-standard-maximum` | 16412 | `d8666d355f635a13273f983365692015542172f5774252e39d8f57eefe5e28a7` |
| `landscape-compact-maximum` | 30883 | `2f86c52e97514c3e4c12635af5df876144089564e116a2621d1c199097a5498a` |

No database, customer data, public hostname, disk, environment group, shared bucket or
production service was used or changed.

## 8. Stage C-R1 Cleanup Evidence — Provider Revocation Pending

The agent removed all twelve direct Render variables, verified zero, deleted exact service
`srv-dab9dip42hec73a9vuvg`, received subsequent exact-ID absence and proved zero exact-name
matches. The exact run prefix independently lists zero objects. No second job or service was
created.

Remaining bounded cleanup is human-provider authority only:

1. delete empty bucket `isostack-fund-1r-f-a-stage-c-r1-5b1791b5`;
2. delete Cloudflare token `FUND-1R-F-A-Stage-C-R1-B-2026-09-01`;
3. revoke the Render API key with the same name;
4. use the retained local records only for refusal/absence proof; and
5. delete the three exact Keychain records and all `/private/tmp` Stage C-R1 helpers.

Until those five actions pass, Stage C-R1 is **behaviourally PASS but cleanup-incomplete**.
It is not yet the indivisible final PASS defined by section 1.

## 9. Stage C-R1 Current Disposition

The external assumption under test is proved at exact `0c7e4848`: the corrected deterministic
renderer runs in the pinned Render Linux container, stays inside the Starter memory bound,
and completes all six private scoped R2 checksum round trips with zero object residue. This
supports later production planning only. It does not build or authorise production storage,
credentials, backup, recovery, retention, renderer service or operating model.

Root `Now` remains only the final revocation/deletion/absence sequence. Root `Next` remains
unselected; do not infer `1R-F-B`, `1R-G`, `1R-H-A`, promotion or another external run.
