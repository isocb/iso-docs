# LMSPro R9-A0 Bounded Read-Only Live-State Query Pack

Date: 2026-07-27

Status: EXECUTED — corrected STAGING target and scope passed preflight; Q1-Q15 completed in
an explicitly read-only transaction and ended with `ROLLBACK`

Application source:

`df40f45cda955ef00e8f790de89a476c2463a629`

Evidence record:

`docs/modules/lmspro/05-review-and-test/2026-07-27-lmspro-r9-a0-static-writer-consumer-and-live-state-inventory-evidence.md`

## 1. Authority And Safety Gate

This pack may be run only after the control owner explicitly names:

- exactly one target: `STAGING` or `PRODUCTION`;
- the tenant/organisation ID;
- the season ID; and
- the authorised read-only operator.

Authority for staging is not authority for production. Do not insert real values into this
document. Supply them only in the controlled execution session.

The operator must:

1. confirm the target identity before connecting;
2. use a read-only database role where available;
3. record the non-secret target label, operator, UTC time and application commit;
4. replace `ORG_UUID_HERE` and `SEASON_UUID_HERE` in the execution copy only;
5. run Section 3 and stop if any preflight condition fails;
6. run Section 4 in one explicitly read-only transaction;
7. retain aggregate output only; and
8. execute `ROLLBACK` even though no write is permitted.

Do not use Prisma migration, seed, studio, repair or application scripts. Do not create
temporary tables, views, exports or server-side files.

## 2. Parameters

The SQL below uses a one-row `scope` CTE in every statement:

```sql
WITH scope AS (
  SELECT
    'ORG_UUID_HERE'::text AS organization_id,
    'SEASON_UUID_HERE'::text AS season_id
)
```

This deliberate repetition keeps every result independently tenant/season bounded.

## 3. Target And Migration Preflight

Run these read-only checks first:

```sql
BEGIN;
SET TRANSACTION READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SET LOCAL idle_in_transaction_session_timeout = '60s';

SELECT
  current_database() AS database_name,
  current_user AS database_role,
  current_schema() AS current_schema,
  current_setting('transaction_read_only') AS transaction_read_only,
  current_setting('statement_timeout') AS statement_timeout;

SELECT
  migration_name,
  finished_at IS NOT NULL AS finished,
  rolled_back_at IS NOT NULL AS rolled_back
FROM public._prisma_migrations
ORDER BY started_at DESC
LIMIT 10;

WITH scope AS (
  SELECT
    'ORG_UUID_HERE'::text AS organization_id,
    'SEASON_UUID_HERE'::text AS season_id
)
SELECT
  s.id = scope.season_id AS season_matches,
  s.organization_id = scope.organization_id AS tenant_matches,
  s.is_current,
  s.status::text AS season_status
FROM scope
LEFT JOIN lmspro.lmspro_seasons s
  ON s.id = scope.season_id;
```

Stop and roll back unless:

- the environment identity matches the single authorised target;
- `transaction_read_only` is `on`;
- the season exists exactly once for the supplied tenant;
- no migration is unfinished or rolled back unexpectedly; and
- deployed ancestry is compatible with application commit `df40f45c`, whose latest local
  migration directory is
  `20260722120000_lmspro_r8_a3_email_delivery_jobs`.

```sql
ROLLBACK;
```

## 4. Aggregate Inventory

After preflight passes, start a new bounded read-only transaction:

```sql
BEGIN;
SET TRANSACTION READ ONLY;
SET LOCAL statement_timeout = '15s';
SET LOCAL lock_timeout = '2s';
SET LOCAL idle_in_transaction_session_timeout = '60s';
```

### Q1 — Club and Team raw statuses

```sql
WITH scope AS (
  SELECT 'ORG_UUID_HERE'::text AS organization_id,
         'SEASON_UUID_HERE'::text AS season_id
)
SELECT 'club' AS entity, c.status::text AS status, count(*) AS record_count
FROM lmspro.lmspro_clubs c
JOIN scope ON c.organization_id = scope.organization_id
          AND c.season_id = scope.season_id
GROUP BY c.status
UNION ALL
SELECT 'team', t.status::text, count(*)
FROM lmspro.lmspro_teams t
JOIN scope ON t.organization_id = scope.organization_id
          AND t.season_id = scope.season_id
GROUP BY t.status
ORDER BY entity, status;
```

### Q2 — Club-instantiation evidence

This classifies evidence, not business truth. A Club can have multiple evidence routes.

```sql
WITH scope AS (
  SELECT 'ORG_UUID_HERE'::text AS organization_id,
         'SEASON_UUID_HERE'::text AS season_id
),
evidence AS (
  SELECT
    c.id,
    EXISTS (
      SELECT 1
      FROM public.legacy_key_mappings lkm
      JOIN public.import_jobs ij ON ij.id = lkm.import_job_id
      WHERE lkm.organization_id = c.organization_id
        AND lkm.entity_type::text = 'LMSPRO_CLUB'
        AND lkm.new_id = c.id::text
        AND ij.organization_id = c.organization_id
        AND ij.status::text = 'COMPLETED'
    ) AS import_evidence,
    EXISTS (
      SELECT 1
      FROM lmspro.lmspro_club_applications a
      WHERE a.organization_id = c.organization_id
        AND a.season_id = c.season_id
        AND a.created_club_id = c.id
        AND a.status::text = 'APPROVED'
        AND a.email_verified_at IS NOT NULL
        AND a.reviewed_at IS NOT NULL
        AND a.reviewed_by_id IS NOT NULL
    ) AS approved_form_evidence,
    EXISTS (
      SELECT 1
      FROM public.audit_logs al
      WHERE al."organizationId" = c.organization_id
        AND al."entityType" = 'LMSProClub'
        AND al."entityId" = c.id::text
        AND al.action = 'LMSPRO_CLUB_CREATED'
    ) AS direct_c1_evidence
  FROM lmspro.lmspro_clubs c
  JOIN scope ON c.organization_id = scope.organization_id
            AND c.season_id = scope.season_id
),
classified AS (
  SELECT *,
    import_evidence::int
      + approved_form_evidence::int
      + direct_c1_evidence::int AS evidence_route_count
  FROM evidence
)
SELECT
  CASE
    WHEN evidence_route_count = 0 THEN 'unknown'
    WHEN evidence_route_count > 1 THEN 'multiple-route'
    WHEN import_evidence THEN 'completed-import'
    WHEN approved_form_evidence THEN 'approved-two-stage-form'
    WHEN direct_c1_evidence THEN 'direct-authorised-c1'
  END AS evidence_class,
  count(*) AS club_count
FROM classified
GROUP BY evidence_class
ORDER BY evidence_class;
```

### Q3 — Application evidence integrity

```sql
WITH scope AS (
  SELECT 'ORG_UUID_HERE'::text AS organization_id,
         'SEASON_UUID_HERE'::text AS season_id
)
SELECT
  a.status::text AS application_status,
  (a.email_verified_at IS NOT NULL) AS email_verified,
  (a.reviewed_at IS NOT NULL AND a.reviewed_by_id IS NOT NULL) AS reviewed,
  (a.created_club_id IS NOT NULL) AS club_linked,
  count(*) AS application_count
FROM lmspro.lmspro_club_applications a
JOIN scope ON a.organization_id = scope.organization_id
          AND a.season_id = scope.season_id
GROUP BY
  a.status,
  (a.email_verified_at IS NOT NULL),
  (a.reviewed_at IS NOT NULL AND a.reviewed_by_id IS NOT NULL),
  (a.created_club_id IS NOT NULL)
ORDER BY application_status, email_verified, reviewed, club_linked;
```

### Q4 — Import completion, mapping and audit evidence

```sql
WITH scope AS (
  SELECT 'ORG_UUID_HERE'::text AS organization_id,
         'SEASON_UUID_HERE'::text AS season_id
),
imports AS (
  SELECT
    ij.id,
    ij.status::text AS import_status,
    CASE
      WHEN ij.season_id = scope.season_id THEN 'job-season-matches'
      WHEN ij.season_id IS NULL THEN 'job-season-null'
      ELSE 'job-season-differs'
    END AS job_season_class,
    count(lkm.id) FILTER (
      WHERE lkm.entity_type::text = 'LMSPRO_CLUB'
        AND EXISTS (
          SELECT 1
          FROM lmspro.lmspro_clubs c
          WHERE c.id::text = lkm.new_id
            AND c.organization_id = ij.organization_id
            AND c.season_id = scope.season_id
        )
    ) AS scoped_club_mappings,
    count(lkm.id) FILTER (
      WHERE lkm.entity_type::text = 'LMSPRO_CLUB'
        AND EXISTS (
          SELECT 1
          FROM lmspro.lmspro_clubs c
          WHERE c.id::text = lkm.new_id
            AND c.organization_id = ij.organization_id
            AND c.season_id = scope.season_id
        )
        AND EXISTS (
          SELECT 1
          FROM public.audit_logs al
          WHERE al."organizationId" = ij.organization_id
            AND al."entityType" = 'LMSProClub'
            AND al."entityId" = lkm.new_id
            AND al.action = 'CLUB_IMPORTED'
        )
    ) AS scoped_club_mappings_with_audit
  FROM public.import_jobs ij
  LEFT JOIN public.legacy_key_mappings lkm
    ON lkm.import_job_id = ij.id
   AND lkm.organization_id = ij.organization_id
  JOIN scope ON ij.organization_id = scope.organization_id
  WHERE ij.entity_type::text = 'LMSPRO_CLUB'
    AND (
      ij.season_id = scope.season_id
      OR EXISTS (
        SELECT 1
        FROM public.legacy_key_mappings scoped_lkm
        JOIN lmspro.lmspro_clubs scoped_club
          ON scoped_club.id::text = scoped_lkm.new_id
        WHERE scoped_lkm.import_job_id = ij.id
          AND scoped_lkm.organization_id = scope.organization_id
          AND scoped_lkm.entity_type::text = 'LMSPRO_CLUB'
          AND scoped_club.organization_id = scope.organization_id
          AND scoped_club.season_id = scope.season_id
      )
    )
  GROUP BY ij.id, ij.status, job_season_class
)
SELECT
  import_status,
  job_season_class,
  count(*) AS import_job_count,
  sum(scoped_club_mappings) AS scoped_mapped_club_count,
  sum(scoped_club_mappings_with_audit) AS scoped_mapped_club_with_audit_count
FROM imports
GROUP BY
  import_status,
  job_season_class
ORDER BY import_status, job_season_class;
```

### Q5 — Authoritative primary-C2 evidence

This returns bounded categories only. It does not expose users or role identifiers.

```sql
WITH scope AS (
  SELECT 'ORG_UUID_HERE'::text AS organization_id,
         'SEASON_UUID_HERE'::text AS season_id
),
club_primary AS (
  SELECT
    c.id,
    count(o.id) FILTER (WHERE o.is_primary) AS primary_links,
    count(o.id) FILTER (
      WHERE o.is_primary
        AND o.organization_id = c.organization_id
        AND u."organizationId" = c.organization_id
    ) AS same_tenant_primary_links,
    count(o.id) FILTER (
      WHERE o.is_primary
        AND o.organization_id = c.organization_id
        AND u."organizationId" = c.organization_id
        AND u.status::text = 'ACTIVE'
        AND EXISTS (
          SELECT 1
          FROM public.module_roles mr
          WHERE mr.id = ANY(u."lmsproRoleIds")
            AND mr."organizationId" = c.organization_id
            AND mr."moduleKey" = 'lmspro'
            AND mr."isActive"
            AND mr.role_scope::text IN ('CLUB', 'BOTH')
        )
    ) AS active_authorised_primary_links
  FROM lmspro.lmspro_clubs c
  JOIN scope ON c.organization_id = scope.organization_id
            AND c.season_id = scope.season_id
  LEFT JOIN lmspro.lmspro_club_officials o ON o.club_id = c.id
  LEFT JOIN public.users u ON u.id = o.user_id
  GROUP BY c.id
)
SELECT
  CASE
    WHEN primary_links = 0 THEN 'no-primary-official'
    WHEN same_tenant_primary_links = 0 THEN 'cross-tenant-primary-only'
    WHEN active_authorised_primary_links = 0 THEN 'primary-without-active-club-role'
    WHEN active_authorised_primary_links = 1 THEN 'one-authoritative-primary-c2'
    ELSE 'multiple-authoritative-primary-c2'
  END AS primary_c2_class,
  count(*) AS club_count
FROM club_primary
GROUP BY primary_c2_class
ORDER BY primary_c2_class;
```

### Q6 — Team allocation integrity

```sql
WITH scope AS (
  SELECT 'ORG_UUID_HERE'::text AS organization_id,
         'SEASON_UUID_HERE'::text AS season_id
),
classified AS (
  SELECT
    t.status::text AS team_status,
    CASE
      WHEN t.agg_id IS NULL THEN 'unallocated-null'
      WHEN g.id IS NULL THEN 'allocation-missing'
      WHEN g.organization_id <> t.organization_id THEN 'allocation-cross-tenant'
      WHEN g.season_id <> t.season_id THEN 'allocation-cross-season'
      WHEN t.age_group_id IS NOT NULL
       AND g.age_group_id IS NOT NULL
       AND t.age_group_id <> g.age_group_id THEN 'allocation-age-group-mismatch'
      ELSE 'allocation-valid'
    END AS allocation_class
  FROM lmspro.lmspro_teams t
  JOIN scope ON t.organization_id = scope.organization_id
            AND t.season_id = scope.season_id
  LEFT JOIN lmspro.lmspro_age_group_groups g ON g.id = t.agg_id
)
SELECT team_status, allocation_class, count(*) AS team_count
FROM classified
GROUP BY team_status, allocation_class
ORDER BY team_status, allocation_class;
```

### Q7 — Team-to-Club and age-group integrity

```sql
WITH scope AS (
  SELECT 'ORG_UUID_HERE'::text AS organization_id,
         'SEASON_UUID_HERE'::text AS season_id
)
SELECT
  CASE
    WHEN c.id IS NULL THEN 'club-missing'
    WHEN c.organization_id <> t.organization_id THEN 'club-cross-tenant'
    WHEN c.season_id <> t.season_id THEN 'club-cross-season'
    WHEN t.age_group_id IS NOT NULL AND ag.id IS NULL THEN 'age-group-missing'
    WHEN ag.id IS NOT NULL AND ag.organization_id <> t.organization_id THEN 'age-group-cross-tenant'
    WHEN ag.id IS NOT NULL AND ag.season_id <> t.season_id THEN 'age-group-cross-season'
    ELSE 'relations-valid'
  END AS relation_class,
  count(*) AS team_count
FROM lmspro.lmspro_teams t
JOIN scope ON t.organization_id = scope.organization_id
          AND t.season_id = scope.season_id
LEFT JOIN lmspro.lmspro_clubs c ON c.id = t.club_id
LEFT JOIN lmspro.lmspro_age_groups ag ON ag.id = t.age_group_id
GROUP BY relation_class
ORDER BY relation_class;
```

### Q8 — Derived Club participation aggregate

This query treats suspended and withdrawn statuses as explicit overrides and requires at
least one of the three accepted admission-evidence routes. Evidence-free Clubs remain
unclassified rather than being inferred from row or Team presence.

```sql
WITH scope AS (
  SELECT 'ORG_UUID_HERE'::text AS organization_id,
         'SEASON_UUID_HERE'::text AS season_id
),
club_team_counts AS (
  SELECT
    c.id,
    c.status::text AS club_status,
    (
      EXISTS (
        SELECT 1
        FROM public.legacy_key_mappings lkm
        JOIN public.import_jobs ij ON ij.id = lkm.import_job_id
        WHERE lkm.organization_id = c.organization_id
          AND lkm.entity_type::text = 'LMSPRO_CLUB'
          AND lkm.new_id = c.id::text
          AND ij.organization_id = c.organization_id
          AND ij.status::text = 'COMPLETED'
      )
      OR EXISTS (
        SELECT 1
        FROM lmspro.lmspro_club_applications a
        WHERE a.organization_id = c.organization_id
          AND a.season_id = c.season_id
          AND a.created_club_id = c.id
          AND a.status::text = 'APPROVED'
          AND a.email_verified_at IS NOT NULL
          AND a.reviewed_at IS NOT NULL
          AND a.reviewed_by_id IS NOT NULL
      )
      OR EXISTS (
        SELECT 1
        FROM public.audit_logs al
        WHERE al."organizationId" = c.organization_id
          AND al."entityType" = 'LMSProClub'
          AND al."entityId" = c.id::text
          AND al.action = 'LMSPRO_CLUB_CREATED'
      )
    ) AS admitted_evidence,
    count(t.id) FILTER (
      WHERE t.status::text = 'CURRENT'
        AND g.id IS NOT NULL
        AND t.organization_id = c.organization_id
        AND t.season_id = c.season_id
        AND g.organization_id = c.organization_id
        AND g.season_id = c.season_id
    ) AS qualifying_current_teams,
    count(t.id) FILTER (
      WHERE t.status::text = 'CURRENT'
        AND t.agg_id IS NULL
        AND t.organization_id = c.organization_id
        AND t.season_id = c.season_id
    ) AS current_unallocated_teams,
    count(t.id) FILTER (
      WHERE t.status::text = 'WAITING_LIST'
        AND t.organization_id = c.organization_id
        AND t.season_id = c.season_id
    ) AS consciously_waitlisted_teams
  FROM lmspro.lmspro_clubs c
  JOIN scope ON c.organization_id = scope.organization_id
            AND c.season_id = scope.season_id
  LEFT JOIN lmspro.lmspro_teams t ON t.club_id = c.id
  LEFT JOIN lmspro.lmspro_age_group_groups g ON g.id = t.agg_id
  GROUP BY c.id, c.status
)
SELECT
  club_status,
  CASE
    WHEN club_status IN ('SUSPENDED', 'WITHDRAWN') THEN 'explicit-override'
    WHEN NOT admitted_evidence THEN 'admission-evidence-missing'
    WHEN qualifying_current_teams > 0 THEN 'derived-current'
    ELSE 'derived-club-waiting-list'
  END AS aggregate_class,
  (current_unallocated_teams > 0) AS has_current_unallocated_team,
  (consciously_waitlisted_teams > 0) AS has_team_waiting_list,
  count(*) AS club_count
FROM club_team_counts
GROUP BY
  club_status,
  CASE
    WHEN club_status IN ('SUSPENDED', 'WITHDRAWN') THEN 'explicit-override'
    WHEN NOT admitted_evidence THEN 'admission-evidence-missing'
    WHEN qualifying_current_teams > 0 THEN 'derived-current'
    ELSE 'derived-club-waiting-list'
  END,
  (current_unallocated_teams > 0),
  (consciously_waitlisted_teams > 0)
ORDER BY club_status, aggregate_class,
         has_current_unallocated_team, has_team_waiting_list;
```

### Q9 — Direct contract contradictions

```sql
WITH scope AS (
  SELECT 'ORG_UUID_HERE'::text AS organization_id,
         'SEASON_UUID_HERE'::text AS season_id
),
qualifying AS (
  SELECT
    c.id AS club_id,
    c.status::text AS club_status,
    count(t.id) FILTER (
      WHERE t.status::text = 'CURRENT'
        AND g.id IS NOT NULL
        AND t.organization_id = c.organization_id
        AND t.season_id = c.season_id
        AND g.organization_id = c.organization_id
        AND g.season_id = c.season_id
    ) AS qualifying_team_count
  FROM lmspro.lmspro_clubs c
  JOIN scope ON c.organization_id = scope.organization_id
            AND c.season_id = scope.season_id
  LEFT JOIN lmspro.lmspro_teams t ON t.club_id = c.id
  LEFT JOIN lmspro.lmspro_age_group_groups g ON g.id = t.agg_id
  GROUP BY c.id, c.status
)
SELECT contradiction, record_count
FROM (
  SELECT
    'approved-club-zero-qualifying-team' AS contradiction,
    count(*) AS record_count
  FROM qualifying
  WHERE club_status = 'APPROVED' AND qualifying_team_count = 0

  UNION ALL

  SELECT
    'waiting-list-club-has-qualifying-team',
    count(*)
  FROM qualifying
  WHERE club_status = 'WAITING_LIST' AND qualifying_team_count > 0

  UNION ALL

  SELECT
    'suspended-or-withdrawn-club-has-qualifying-team',
    count(*)
  FROM qualifying
  WHERE club_status IN ('SUSPENDED', 'WITHDRAWN')
    AND qualifying_team_count > 0
) q
ORDER BY contradiction;
```

### Q10 — Non-Current Teams retaining allocation

```sql
WITH scope AS (
  SELECT 'ORG_UUID_HERE'::text AS organization_id,
         'SEASON_UUID_HERE'::text AS season_id
)
SELECT
  t.status::text AS team_status,
  count(*) FILTER (WHERE t.agg_id IS NOT NULL) AS allocated_count,
  count(*) FILTER (WHERE t.agg_id IS NULL) AS unallocated_count
FROM lmspro.lmspro_teams t
JOIN scope ON t.organization_id = scope.organization_id
          AND t.season_id = scope.season_id
WHERE t.status::text <> 'CURRENT'
GROUP BY t.status
ORDER BY team_status;
```

### Q11 — Team Waiting List position evidence

The current model has no explicit authorised waiting-list decision record or position field.
This query reports only whether ordering inputs exist; it does not assert that `team_number`
or creation time is the accepted position authority.

```sql
WITH scope AS (
  SELECT 'ORG_UUID_HERE'::text AS organization_id,
         'SEASON_UUID_HERE'::text AS season_id
)
SELECT
  t.age_group_id IS NOT NULL AS has_age_group,
  t.team_number IS NOT NULL AS has_team_number,
  t.created_at IS NOT NULL AS has_created_timestamp,
  (
    EXISTS (
      SELECT 1
      FROM public.audit_logs al
      WHERE al."organizationId" = t.organization_id
        AND al."entityType" = 'LMSProTeam'
        AND al."entityId" = t.id::text
        AND al.action = 'LMSPRO_TEAM_UPDATED'
        AND al.metadata->'changes'->>'status' = 'WAITING_LIST'
    )
    OR EXISTS (
      SELECT 1
      FROM public.audit_logs al
      WHERE al."organizationId" = t.organization_id
        AND al."entityType" = 'LMSProTeam'
        AND al.action = 'LMSPRO_TEAMS_BULK_STATUS_UPDATE'
        AND al.metadata->>'newStatus' = 'WAITING_LIST'
        AND (al.metadata->'teamIds') ? t.id
    )
    OR EXISTS (
      SELECT 1
      FROM public.legacy_key_mappings lkm
      JOIN public.import_jobs ij ON ij.id = lkm.import_job_id
      WHERE lkm.organization_id = t.organization_id
        AND lkm.entity_type::text = 'LMSPRO_TEAM'
        AND lkm.new_id = t.id::text
        AND ij.status::text = 'COMPLETED'
        AND upper(coalesce(lkm.legacy_data->>'status', '')) = 'WAITING_LIST'
    )
  ) AS has_waitlist_decision_evidence,
  count(*) AS waitlisted_team_count
FROM lmspro.lmspro_teams t
JOIN scope ON t.organization_id = scope.organization_id
          AND t.season_id = scope.season_id
WHERE t.status::text = 'WAITING_LIST'
GROUP BY
  (t.age_group_id IS NOT NULL),
  (t.team_number IS NOT NULL),
  (t.created_at IS NOT NULL),
  has_waitlist_decision_evidence
ORDER BY
  has_waitlist_decision_evidence,
  has_age_group,
  has_team_number,
  has_created_timestamp;
```

### Q12 — Access-sensitive Waiting List Clubs

```sql
WITH scope AS (
  SELECT 'ORG_UUID_HERE'::text AS organization_id,
         'SEASON_UUID_HERE'::text AS season_id
),
waiting_clubs AS (
  SELECT c.id
  FROM lmspro.lmspro_clubs c
  JOIN scope ON c.organization_id = scope.organization_id
            AND c.season_id = scope.season_id
  WHERE c.status::text = 'WAITING_LIST'
),
access_state AS (
  SELECT
    wc.id,
    count(DISTINCT o.user_id) FILTER (
      WHERE o.organization_id = scope.organization_id
    ) AS official_users,
    count(DISTINCT o.user_id) FILTER (
      WHERE o.organization_id = scope.organization_id
        AND u."organizationId" = scope.organization_id
        AND u.status::text = 'ACTIVE'
        AND EXISTS (
          SELECT 1
          FROM public.module_roles mr
          WHERE mr.id = ANY(u."lmsproRoleIds")
            AND mr."organizationId" = scope.organization_id
            AND mr."moduleKey" = 'lmspro'
            AND mr."isActive"
            AND mr.role_scope::text IN ('CLUB', 'BOTH')
        )
    ) AS active_club_role_users
  FROM waiting_clubs wc
  CROSS JOIN scope
  LEFT JOIN lmspro.lmspro_club_officials o ON o.club_id = wc.id
  LEFT JOIN public.users u ON u.id = o.user_id
  GROUP BY wc.id
)
SELECT
  CASE
    WHEN official_users = 0 THEN 'no-official'
    WHEN active_club_role_users = 0 THEN 'official-without-active-club-role'
    ELSE 'active-c2-present'
  END AS access_class,
  count(*) AS club_count
FROM access_state
GROUP BY access_class
ORDER BY access_class;
```

### Q13 — Communication and public-directory cohort deltas

```sql
WITH scope AS (
  SELECT 'ORG_UUID_HERE'::text AS organization_id,
         'SEASON_UUID_HERE'::text AS season_id
),
club_aggregate AS (
  SELECT
    c.id,
    c.status::text AS club_status,
    (
      EXISTS (
        SELECT 1
        FROM public.legacy_key_mappings lkm
        JOIN public.import_jobs ij ON ij.id = lkm.import_job_id
        WHERE lkm.organization_id = c.organization_id
          AND lkm.entity_type::text = 'LMSPRO_CLUB'
          AND lkm.new_id = c.id::text
          AND ij.organization_id = c.organization_id
          AND ij.status::text = 'COMPLETED'
      )
      OR EXISTS (
        SELECT 1
        FROM lmspro.lmspro_club_applications a
        WHERE a.organization_id = c.organization_id
          AND a.season_id = c.season_id
          AND a.created_club_id = c.id
          AND a.status::text = 'APPROVED'
          AND a.email_verified_at IS NOT NULL
          AND a.reviewed_at IS NOT NULL
          AND a.reviewed_by_id IS NOT NULL
      )
      OR EXISTS (
        SELECT 1
        FROM public.audit_logs al
        WHERE al."organizationId" = c.organization_id
          AND al."entityType" = 'LMSProClub'
          AND al."entityId" = c.id::text
          AND al.action = 'LMSPRO_CLUB_CREATED'
      )
    ) AS admitted_evidence,
    count(t.id) FILTER (
      WHERE t.status::text = 'CURRENT'
        AND g.id IS NOT NULL
        AND t.organization_id = c.organization_id
        AND t.season_id = c.season_id
        AND g.organization_id = c.organization_id
        AND g.season_id = c.season_id
    ) > 0 AS has_qualifying_current_team
  FROM lmspro.lmspro_clubs c
  JOIN scope ON c.organization_id = scope.organization_id
            AND c.season_id = scope.season_id
  LEFT JOIN lmspro.lmspro_teams t ON t.club_id = c.id
  LEFT JOIN lmspro.lmspro_age_group_groups g ON g.id = t.agg_id
  GROUP BY c.id, c.status
)
SELECT cohort, record_count
FROM (
  SELECT 'raw-approved-clubs' AS cohort,
         count(*) FILTER (WHERE club_status = 'APPROVED') AS record_count
  FROM club_aggregate
  UNION ALL
  SELECT 'derived-current-clubs',
         count(*) FILTER (
           WHERE admitted_evidence
             AND has_qualifying_current_team
             AND club_status NOT IN ('SUSPENDED', 'WITHDRAWN')
         )
  FROM club_aggregate
  UNION ALL
  SELECT 'admitted-operational-clubs',
         count(*) FILTER (
           WHERE admitted_evidence
             AND club_status NOT IN ('SUSPENDED', 'WITHDRAWN')
         )
  FROM club_aggregate
) q
ORDER BY cohort;
```

### Q14 — Season clone/roll-forward exposure

```sql
WITH scope AS (
  SELECT 'ORG_UUID_HERE'::text AS organization_id,
         'SEASON_UUID_HERE'::text AS season_id
),
team_integrity AS (
  SELECT
    t.status::text AS team_status,
    CASE
      WHEN t.agg_id IS NULL THEN false
      WHEN g.id IS NULL THEN false
      WHEN g.organization_id <> t.organization_id THEN false
      WHEN g.season_id <> t.season_id THEN false
      ELSE true
    END AS allocation_valid,
    t.continuing_next_season
  FROM lmspro.lmspro_teams t
  JOIN scope ON t.organization_id = scope.organization_id
            AND t.season_id = scope.season_id
  LEFT JOIN lmspro.lmspro_age_group_groups g ON g.id = t.agg_id
)
SELECT
  team_status,
  allocation_valid,
  continuing_next_season,
  count(*) AS team_count
FROM team_integrity
GROUP BY team_status, allocation_valid, continuing_next_season
ORDER BY team_status, allocation_valid, continuing_next_season;
```

### Q15 — Active disciplinary override restoration risk

```sql
WITH scope AS (
  SELECT 'ORG_UUID_HERE'::text AS organization_id,
         'SEASON_UUID_HERE'::text AS season_id
)
SELECT
  CASE
    WHEN dr.club_id IS NOT NULL THEN 'club'
    WHEN dr.team_id IS NOT NULL THEN 'team'
    ELSE 'missing-target'
  END AS target_type,
  coalesce(dr.previous_club_status::text,
           dr.previous_team_status::text,
           'missing-previous-status') AS previous_status,
  count(*) AS active_record_count
FROM lmspro.lmspro_disciplinary_records dr
JOIN scope ON dr.organization_id = scope.organization_id
          AND dr.season_id = scope.season_id
WHERE dr.status::text = 'ACTIVE'
GROUP BY target_type, previous_status
ORDER BY target_type, previous_status;
```

Finish without committing any transaction:

```sql
ROLLBACK;
```

## 5. Evidence Capture Template

Append only aggregate results to the evidence record:

```text
Authorised target:
Operator:
Execution UTC:
Application/deployment commit:
Database name/label:
Latest compatible migration:
Read-only confirmed:
Statement timeout:

Q1:
...
Q15:

Stopped/aborted conditions:
Unexpected schema or ancestry:
Queries omitted:
```

Do not include names, emails, phone numbers, free text, raw UUIDs, credentials, connection
strings or row-level extracts.

## 6. Stop Gate

Execution of this pack, even when authorised, does not authorise:

- source or schema changes;
- a migration or constraint;
- record reconciliation;
- user, role, access, Club-official, Club or Team changes;
- notification sending;
- environment or deployment changes; or
- acceptance of a successor R9-A implementation slice.
