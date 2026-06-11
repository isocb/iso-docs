# Documentation Map

`isodocs` is the canonical documentation home. `isostack-bedrock` contains code-adjacent notes and is a secondary support source for this repo.

## Canonical Top-Level Navigation

- `README.md` — repository-wide orientation
- `DOCUMENTATION_MAP.md` — this map
- `DOCUMENTATION_RESTRUCTURE_PLAN.md` — current restructuring plan and status source
- `DOCUMENTATION_CONFLICT_REPORT.md` — conflict audit snapshots

## Where to find guidance

### Architecture
- Core architecture: `docs/core/architecture.md`
- Platform architecture patterns: `docs/00-overview/architecture.md`
- Tenant model and tenancy rules: `docs/core/*`

### Deployment / Operations
- Deployment guide: `docs/guides/deployment/deployment-guide.md`
- Commit and verification checklists: `docs/00-overview/` and `../isostack-bedrock/docs/00-READ_THIS/DEPLOY_VERIFY_CHECKLIST.md`
- Database workflow: `SAFE_DATABASE_WORKFLOW.md` (canonical) and `docs/guides/deployment/deployment-guide.md`

### Database & Migrations
- Safe migration policy: `SAFE_DATABASE_WORKFLOW.md`
- Module-specific migration examples: `docs/modules/*/migrations/*` (where present)
- Database architecture references: `docs/core/database-schema.md`, `docs/core/*`

### Modules / Apps
- Module index: `docs/modules/README.md`
- Branding module: `docs/modules/branding/*`
- Tooltips module: `docs/modules/tooltips/*`
- LMSPro and other module docs: `docs/modules/lmspro/*`

### AI / Codex / Agent Guidance
- Canonical AI/Codex context: `docs/00-overview/README.md`
- Codex safety and process reminders in-repo: `../isostack-bedrock/docs/00-READ_THIS/CODEX_OPERATING_CHARTER.md`

## Legacy-safe note

If a file contains legacy workflow steps (`techtest`, `db:push`, `db:seed` in deployment context), treat those lines as historical until reviewed and superseded by:

- `SAFE_DATABASE_WORKFLOW.md`
- `docs/guides/deployment/deployment-guide.md`
- `../isostack-bedrock/docs/00-READ_THIS/SAFE_DATABASE_DEPLOYMENT.md`

