# IsoStack Documentation Agent Instructions

This file is the automatic entry point for work in this repository. It applies the
authoritative IsoStack method; it does not create a second process or documentation lane.

## Start With Current Authority

- For substantive CR, triage, planning, review, promotion-record or reconciliation work,
  first read `docs/core/how-we-work-addendum.md`.
- Treat `docs/modules/<module>/work-method.md` as the full method authority. Read only the
  sections relevant to the current lifecycle stage, then read the root roadmap, owning
  child roadmap and active lifecycle record.
- Inspect the current branch and worktree and preserve unrelated human changes.
- A CR records a need; a triage records disposition; a plan records an accepted boundary.
  None independently proves implementation, testing, promotion or live operation.
- Documentation-only authority does not permit application-code, database, provider or
  deployment changes. If current evidence is unavailable, record `pending` or `not run`
  rather than inventing it.

## Apply Proportionate, Risk-Aware Control

Use the existing lifecycle and record one control depth in its existing triage or slice:

- `Low`: only for a tightly bounded presentation, wording or local-interaction change with
  no material authority, tenancy, privacy/security, schema/live-data, bulk-operation,
  financial, integration, credential/configuration or environment consequence.
- `Standard`: normal bounded product work and the default whenever classification is
  uncertain.
- `High`: authentication, authority, roles/permissions, tenant isolation, privacy/security,
  schema/migration/live data, payments, bulk communications, destructive action,
  credentials/runtime configuration or a material external-service contract.

Depth controls evidence, not priority, urgency, lifecycle stages or document count. Raise
the depth when findings increase risk; reduce `High` only with an explicit reason in the
same controlling record. Do not create a separate risk assessment, lane, approval, roadmap
or status document merely to apply the depth.

- `Low`: concise existing records, focused checks and one direct human proof where visible.
- `Standard`: ordinary plan, confirmation, automated checks, relevant human smoke and
  controlled promotion evidence.
- `High`: explicit failure, rollback and negative-test boundaries plus the relevant full
  tenant/role, migration, environment and human gates.

For schema, migration or live-data planning/evidence, also follow
`SAFE_DATABASE_WORKFLOW.md`.

## Keep The Portfolio And Evidence Truthful

- Register every new CR in its authoritative child roadmap with an explicit disposition in
  the same documentation change. Registration is not selection.
- The root roadmap alone owns one portfolio `Now` and one `Next`. Update it only when that
  pair, cross-lane ownership/dependency or accepted expedite state materially changes.
- Keep one five-field restart checkpoint in the active controlling record only; do not make
  a separate handoff or status file.
- Lead confirmation/review with exact commit, change boundary, automated and human evidence,
  environment proven, residual risk and next authorised action. Use `pending`, `not run` or
  `not applicable` explicitly.
- Keep detailed proof local, staging proof environment-specific and live proof minimally
  safe and non-destructive. Do not duplicate full matrices without a material risk reason.
- Do not add Scrum ceremony, story points, another ticket system, extra approval states,
  duplicate roadmaps, minor-decision documents or persistent branches without a specific
  unresolved control failure and explicit human acceptance.
- Never record secrets, access tokens, complete personal data or sensitive database output.
