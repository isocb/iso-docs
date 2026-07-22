# LMSPro Remediation Slice R8-A2R-F1 - Draft Resource State, Rehydration And Attachment Transport Correction Implementation Confirmation

Date: 2026-07-22
Module: LMSPro / SeasonPro shared communications
Status: Technically implemented on the dedicated corrective branch; transport-boundary and human UI smoke acceptance pending

Planning source:

`docs/modules/lmspro/03-slice-planning/2026-07-22-lmspro-remediation-slice-r8-a2r-f1-draft-resource-state-rehydration-and-attachment-transport-correction-planning.md`

## Repository Boundary

```text
repository: isostack-bedrock
branch: fix/lmspro-r8-a2r-f1-draft-resource-correction
base: origin/dev at 3b148a650896ad4f67bbdeb006c457a9e87e3ccb
implementation: c8af7bd3 fix(communications): reconcile draft resources and transport errors
promotion: none
schema/migration/environment change: none
```

No merge into `dev`, `staging` or `main`, deployment or promotion is part of this
confirmation.

## Implemented Outcome

### Stable Draft Hydration

The communications page now memoises its mapped compose draft. The modal retains current
draft and filter inputs through refs and hydrates only when the modal opens or its draft ID
changes. A background query object refresh can no longer overwrite in-progress file/link
state merely because object identity changed.

### Canonical Save Reconciliation

A successful create/update response immediately becomes the modal's resource state. The
exact `communications.emails.get({ id })` cache is merged with the canonical mutation
response and invalidated for background refresh before the parent save callback runs. This
preserves saved attachments and links while retaining query-only template/recipient data.

### Atomic Attachment Selection

One selection is converted as a group and reconciled once against the latest attachment
state. A processing lock refuses overlapping selection work. The deterministic policy:

- accepts candidates in selection order while count and cumulative size permit;
- retains earlier accepted candidates;
- refuses empty, fourth and over-total candidates individually;
- does not count conversion failures or refusals; and
- reports the filename and exact refusal reason.

Dropzone type refusals also retain each filename and library validation reason rather than
collapsing every failure into one generic message.

### CSV Contract

UTF-8 and UTF-8-BOM CSV remain accepted. Because browser claims are not stable across
operating systems, the service explicitly normalises these CSV claims before comparing them
with extension and detected UTF-8 content:

- `text/csv`;
- `text/plain`;
- `application/csv`;
- `text/x-csv`;
- `text/comma-separated-values`;
- `application/vnd.ms-excel` when the filename remains `.csv`; and
- empty/`application/octet-stream` claims when extension and detected content establish the
  accepted type.

An `.xls` file is still refused by extension. UTF-16 CSV remains outside the settled
contract and was not silently enabled.

### Non-JSON Transport Evidence

The shared tRPC fetch boundary now refuses a non-JSON response before the tRPC parser tries
to parse HTML. It preserves the HTTP classification in a safe message:

- `413`: attachment request exceeded the web transport limit;
- `502`, `503` or `504`: service unavailable or timed out; and
- other status: unexpected non-JSON service response.

Every message states that no draft changes were saved. HTML response bodies are not exposed.

## Transport Assessment

The 10 MiB decoded binary boundary expands to exactly 13,981,016 Base64 bytes before JSON,
filenames and tRPC batching overhead. The current synchronous mutation also performs:

```text
validate decoded bytes
-> R2 PutObject
-> R2 HeadObject
-> R2 GetObject/full byte readback
-> checksum comparison
-> database transaction
```

This slice does not reduce the accepted 10 MB binary contract and does not increase an
unknown infrastructure limit. The original staging HTML response did not include its HTTP
status in the supplied evidence, so the current route is not yet certified at the upper
boundary. The new classification makes the required deployed evidence observable. A
staged/raw upload design remains a possible separate expansion only if deployed proof shows
that the accepted boundary cannot be supported by the current mutation.

## Automated Evidence

```text
focused communications/R2 Vitest suites                  PASS - 7 files, 48 tests
full Vitest suite                                        PASS - 21 files, 1 skipped;
                                                               142 tests, 12 skipped
npm run type-check                                       PASS
npm run verify                                           PASS
npm run build                                            PASS
focused ESLint over changed production files             PASS - no errors
focused Prettier check/write                             PASS
application git diff --check                             PASS
```

Repository-wide `npm run lint` remains non-green because of existing unrelated application
errors and warnings. The changed production files introduce no focused ESLint error. The
first sandboxed verification attempt could not open the `tsx` IPC socket; the same standard
verification command passed when run with the required local permission.

## Remaining Gate

R8-A2R-F1 is not lifecycle-complete. The business/testing team must repeat the blocked UI
smoke and record the HTTP status/content classification if any save still fails. R8-A3,
merge, deployment and promotion remain outside this confirmation.
