# LMSPro Remediation Slice R8-A2R-F1 - Draft Resource State, Rehydration And Attachment Transport Correction Planning

Date: 2026-07-22
Module: LMSPro / SeasonPro shared communications
Status: Active bounded corrective slice; implementation authorised on a dedicated dev-based branch; human acceptance pending
Type: Human-smoke-blocking draft resource and transport correction

Controlling parent:

`docs/modules/lmspro/03-slice-planning/2026-07-20-lmspro-remediation-slice-r8-a-attachment-aware-email-delivery-route-and-fail-closed-evidence-planning.md`

Corrected foundations:

- `docs/modules/lmspro/03-slice-planning/2026-07-21-lmspro-remediation-slice-r8-a2-attachment-persistence-drafts-and-fail-closed-preflight-planning.md`
- `docs/modules/lmspro/03-slice-planning/2026-07-21-lmspro-remediation-slice-r8-a2r-bounded-unscanned-attachment-policy-correction-planning.md`

Blocked human review:

`docs/modules/lmspro/05-review-and-test/2026-07-21-lmspro-remediation-slice-r8-a2r-bounded-unscanned-attachment-policy-correction-review-and-test.md`

## 1. Purpose

The R8-A2R deployed human smoke exposed failures that prevent meaningful continuation of
the accepted gate. Newly added files can disappear from the compose surface, the exact
attachment set is not reliably retained, saved links can reopen from stale state and some
CSV saves surface a non-JSON HTML response as `Unexpected token '<'`.

R8-A2R-F1 corrects the bounded draft-resource state and error paths without implementing
R8-A3 attachment delivery, changing the no-attachment batch sender or claiming that
R8-A2R has passed human acceptance.

## 2. Confirmed Failure Classes

### 2.1 Stale Draft Rehydration

The communications page maps query data into a new compose object while the modal hydrates
from whole-object identity. After a successful mutation, the parent invalidates the list
but not the exact draft query. A parent render can consequently replace the canonical save
response with stale cached attachments and links.

### 2.2 Non-Atomic File Selection And Opaque Refusal

File conversion appends one file at a time from closure-based count/size evidence. The
dropzone discards per-file rejection reasons, and a selection exceeding the remaining slot
count is refused as one undifferentiated batch. This does not create a deliberate hidden
failure count, but it makes the visible state non-deterministic and the refusal difficult
to diagnose.

### 2.3 CSV And Non-JSON Failure Ambiguity

The current policy accepts UTF-8 CSV with strict content/extension/browser-claim agreement.
Browser MIME aliases and non-UTF-8 files require distinct messages. An HTML response is not
a normal policy rejection: the HTTP status and content type must distinguish request-size,
gateway, framework and other infrastructure failures.

### 2.4 Base64 Transport Exposure

The current save mutation embeds binary content as Base64 JSON. Base64 expands binary
content by approximately one third before JSON/request overhead. The server then uploads,
heads and completely reads each private R2 object before returning. The accepted 10 MB
binary contract therefore requires measured transport proof rather than an assumed 10 MB
HTTP envelope.

## 3. Settled Contract

R8-A2R-F1 must preserve:

1. no more than three uploaded files;
2. no more than 10 MB cumulative decoded binary content;
3. PDF, JPEG/JPG, PNG, GIF, WebP, UTF-8 TXT and CSV only;
4. refusal of Office, archive, executable, script and mismatched content;
5. three labelled HTTPS external links independently from uploaded files;
6. private R2 storage with no public object URL;
7. no malware-scanning or external-link verification claim;
8. explicit C1 resource-integrity responsibility acknowledgement;
9. fail-closed attachment sending until R8-A3; and
10. no change to the proven no-attachment batch route.

UTF-16 CSV is not silently added. If evidence shows it is required, implementation pauses
for a business decision.

## 4. Included Work

- hydrate compose state only for an intentional draft/open or canonical-version change;
- make the successful mutation response the immediate canonical modal/query state;
- reconcile or invalidate the exact draft query after save;
- validate and convert one selected batch before one atomic state update;
- serialise overlapping file-selection work and use current state for count/size authority;
- retain every accepted file and exclude every refused/failed file from the visible count;
- surface filename-specific client refusal reasons;
- test representative CSV BOM and browser MIME behaviour without weakening content checks;
- classify non-JSON tRPC responses into a safe actionable error;
- measure Base64 request expansion and assess the existing R2 Put/Head/Get sequence;
- add focused state, resource-policy, transport-error and sender-regression tests; and
- produce implementation and review/test evidence while leaving human acceptance open.

## 5. Excluded Work

- attachment delivery jobs or ordinary Resend `/emails` delivery;
- changing the no-attachment batch path;
- allowing UTF-16 CSV without business approval;
- reducing the 10 MB binary contract without business approval;
- blindly increasing HTTP/framework/provider limits;
- building a staged/raw upload aggregate without a separately accepted expansion;
- changing R2 publicity, malware policy or the responsibility notice; and
- roadmap completion, merge, deployment or promotion.

## 6. Implementation Sequence

1. Lock the modal hydration boundary to draft identity/canonical revision.
2. Reconcile the exact query cache from every successful save response.
3. Extract deterministic file-selection policy and atomic accumulation.
4. Preserve strict server authority and add explicit CSV MIME/encoding evidence.
5. Add non-JSON response classification without masking its HTTP status.
6. Measure the 10 MB transport envelope and record whether the current route remains
   supportable.
7. Run focused tests, type-check, lint and the appropriate regression/build suite.
8. Create implementation and review/test records and stop before promotion.

If step 6 proves that preserving 10 MB requires a materially larger staged/raw/private
upload design, this slice records the evidence and pauses before implementing that design.

## 7. Automated Acceptance

Automated evidence must cover:

- new and existing drafts with one, two and three files;
- remove, replace, save and reopen with the exact resource set;
- rapid/overlapping selections and mixed accepted/refused files;
- fourth-file and over-10-MB refusal;
- supported content, prohibited content and extension/type mismatch;
- UTF-8 and UTF-8-BOM CSV plus representative browser MIME claims;
- one and three links, fourth-link refusal, and save/reopen retention;
- exact-query cache reconciliation after create/update;
- safe non-JSON error classification;
- private storage response contracts with no public URL;
- acknowledgement and attachment-send fail-closed behaviour; and
- no-attachment batch-dispatch regression.

## 8. Human Gate And Exit

The prior R8-A2R PASS observations for private bucket configuration, disclosure,
acknowledgement and interim attachment-send blocking remain evidence. The remaining human
checks are blocked until this correction is deployed to an authorised test environment.

R8-A2R-F1 exits technical implementation only when automated evidence and lifecycle records
exist. It remains open pending the business/testing team's repeated UI smoke. No merge into
`dev`, promotion to `staging`/`main`, deployment or R8-A3 commencement is authorised by this
document.
