# IsoStack Git Workflow

Purpose: define the plain-English branch and promotion model used for day-to-day IsoStack work.

Scope: applies to collaborative development, AI-assisted work, staging promotion, and live release discussion.

Last updated: 2026-07-01

---

## Human Working Model

For normal work, use this mental model:

```text
local work branch -> dev -> origin/dev -> staging -> live
```

This is the standard operating language for IsoStack work.

- `local work branch` is where an isolated feature, fix, review or remediation starts.
- `dev` is the local accepted development line.
- `origin/dev` is the backed-up/shared remote copy of `dev`.
- `staging` is the online test version.
- `live` is the production version used by real users.

This model is intentionally simple. It keeps branch discussion grounded in the promotion path rather than abstract Git topology.

---

## Standard Flow

Use this flow unless a specific release plan says otherwise:

1. Create a local work branch from `dev`.
2. Implement and test the change on the local work branch.
3. Commit the local work branch.
4. Consolidate the branch into local `dev`.
5. Align local `dev` with `origin/dev`.
6. Promote `dev` to `staging` when online testing is needed.
7. Smoke test the staging environment.
8. Promote to `live` only after explicit approval.

Database/schema changes must also follow the safe database workflow:

```text
SAFE_DATABASE_WORKFLOW.md
```

---

## Required Wording

Use these phrases in human status reports:

- "still on a local work branch"
- "consolidated into dev"
- "dev and origin/dev match"
- "promoted to staging"
- "ready for live promotion"

Avoid ambiguous wording where possible.

In particular, avoid saying "staged" when talking to a human unless specifically referring to the Git index. The Staging environment is a separate concept, so prefer:

- "added to commit" instead of "staged"
- "queued for commit" instead of "staged"
- "promoted to staging" when the online Staging environment is meant

---

## Branch Types

Short-lived work branches should sit before `dev` in the working model.

Examples:

```text
feature/<short-description>
fix/<short-description>
module-<module>/<short-description>
```

The branch name can describe the work, but the communication should still use the same ladder:

```text
local work branch -> dev -> origin/dev -> staging -> live
```

---

## Sanity Check

Before promotion, answer these questions:

1. Is the change committed on the local work branch?
2. Have the relevant checks/tests passed?
3. Has the branch been consolidated into local `dev`?
4. Does local `dev` match `origin/dev`?
5. Is staging promotion explicitly wanted now?
6. Is any database change covered by the safe database workflow?
