\set ON_ERROR_STOP on

-- LMSPro R9-A2 production combined reconciliation rehearsal.
--
-- Required psql variables:
--   org_id
--   season_id
--   attestor_id
--   snapshot_branch
--   application_commit
--
-- This controlled artifact is deliberately rollback-only. It must not be changed
-- to COMMIT without a separate execution approval and a fresh snapshot reference.

BEGIN ISOLATION LEVEL SERIALIZABLE;
SET LOCAL lock_timeout = '5s';
SET LOCAL statement_timeout = '60s';

CREATE TEMP TABLE r9_params ON COMMIT DROP AS
SELECT
  :'org_id'::text AS org_id,
  :'season_id'::text AS season_id,
  :'attestor_id'::text AS attestor_id,
  :'snapshot_branch'::text AS snapshot_branch,
  :'application_commit'::text AS application_commit,
  timestamp '2026-05-31 23:00:00' AS cutoff_utc,
  timezone('UTC', clock_timestamp())::timestamp(3) AS run_at,
  gen_random_uuid()::text AS batch_id,
  concat(
    'lmspro-r9-a2:', :'org_id', ':', :'season_id',
    ':legacy-before-2026-06-01:v1:batch'
  ) AS batch_key;

-- Lock the bounded Club and Application source rows for the rehearsal.
SELECT count(*) AS locked_clubs
FROM (
  SELECT c.id
  FROM lmspro.lmspro_clubs c
  JOIN r9_params p
    ON c.organization_id = p.org_id
   AND c.season_id = p.season_id
  ORDER BY c.id
  FOR UPDATE
) locked;

SELECT count(*) AS locked_applications
FROM (
  SELECT a.id
  FROM lmspro.lmspro_club_applications a
  JOIN r9_params p
    ON a.organization_id = p.org_id
   AND a.season_id = p.season_id
  ORDER BY a.id
  FOR SHARE
) locked;

CREATE TEMP TABLE r9_legacy_candidates ON COMMIT DROP AS
SELECT
  c.id AS club_id,
  c.created_at AS effective_at,
  concat(
    'lmspro-r9-a2:', p.org_id, ':', p.season_id,
    ':legacy-before-2026-06-01:v1:club:', c.id
  ) AS evidence_key
FROM lmspro.lmspro_clubs c
JOIN r9_params p
  ON c.organization_id = p.org_id
 AND c.season_id = p.season_id
WHERE c.created_at < p.cutoff_utc;

CREATE TEMP TABLE r9_application_candidates ON COMMIT DROP AS
SELECT
  c.id AS club_id,
  a.id AS application_id,
  a.reviewed_at AS effective_at,
  concat(
    'club-admission:approved-application:',
    p.org_id, ':', a.id
  ) AS evidence_key
FROM lmspro.lmspro_clubs c
JOIN r9_params p
  ON c.organization_id = p.org_id
 AND c.season_id = p.season_id
JOIN lmspro.lmspro_club_applications a
  ON a.organization_id = c.organization_id
 AND a.season_id = c.season_id
 AND a.created_club_id = c.id
WHERE c.created_at >= p.cutoff_utc
  AND a.status = 'APPROVED'
  AND a.email_verified_at IS NOT NULL
  AND a.reviewed_at IS NOT NULL
  AND a.reviewed_by_id IS NOT NULL;

CREATE TEMP TABLE r9_members ON COMMIT DROP AS
SELECT club_id FROM r9_legacy_candidates
UNION ALL
SELECT club_id FROM r9_application_candidates;

CREATE TEMP TABLE r9_club_evaluation ON COMMIT DROP AS
SELECT
  c.id AS club_id,
  c.status AS source_status,
  count(t.id) FILTER (
    WHERE t.status = 'CURRENT'
      AND t.agg_id IS NOT NULL
      AND t.age_group_id IS NOT NULL
      AND t.organization_id = c.organization_id
      AND t.season_id = c.season_id
      AND agg.organization_id = c.organization_id
      AND agg.season_id = c.season_id
      AND agg.age_group_id = t.age_group_id
  )::integer AS qualifying_current_team_count
FROM lmspro.lmspro_clubs c
JOIN r9_params p
  ON c.organization_id = p.org_id
 AND c.season_id = p.season_id
JOIN r9_members m ON m.club_id = c.id
LEFT JOIN lmspro.lmspro_teams t
  ON t.organization_id = c.organization_id
 AND t.season_id = c.season_id
 AND t.club_id = c.id
LEFT JOIN lmspro.lmspro_age_group_groups agg ON agg.id = t.agg_id
GROUP BY c.id, c.status;

CREATE TEMP TABLE r9_transitions ON COMMIT DROP AS
SELECT
  e.club_id,
  e.source_status,
  CASE
    WHEN e.source_status IN ('SUSPENDED', 'WITHDRAWN') THEN e.source_status
    WHEN e.qualifying_current_team_count > 0 THEN 'APPROVED'::lmspro."ClubStatus"
    ELSE 'WAITING_LIST'::lmspro."ClubStatus"
  END AS target_status,
  e.qualifying_current_team_count
FROM r9_club_evaluation e
WHERE e.source_status NOT IN ('SUSPENDED', 'WITHDRAWN')
  AND e.source_status IS DISTINCT FROM CASE
    WHEN e.qualifying_current_team_count > 0 THEN 'APPROVED'::lmspro."ClubStatus"
    ELSE 'WAITING_LIST'::lmspro."ClubStatus"
  END;

CREATE TEMP TABLE r9_guard_before (
  domain text PRIMARY KEY,
  row_count bigint NOT NULL,
  fingerprint text NOT NULL
) ON COMMIT DROP;

INSERT INTO r9_guard_before
SELECT
  'teams',
  count(*),
  md5(string_agg(
    concat_ws(
      '|',
      t.id,
      t.status::text,
      coalesce(t.agg_id, ''),
      coalesce(t.age_group_id, ''),
      t.updated_at::text
    ),
    ',' ORDER BY t.id
  ))
FROM lmspro.lmspro_teams t
JOIN r9_params p
  ON t.organization_id = p.org_id
 AND t.season_id = p.season_id
UNION ALL
SELECT
  'club_officials',
  count(*),
  md5(string_agg(
    concat_ws(
      '|',
      o.id,
      o.club_id,
      o.user_id,
      o.role,
      o.is_primary::text
    ),
    ',' ORDER BY o.id
  ))
FROM lmspro.lmspro_club_officials o
JOIN lmspro.lmspro_clubs c ON c.id = o.club_id
JOIN r9_params p
  ON c.organization_id = p.org_id
 AND c.season_id = p.season_id
WHERE o.organization_id = p.org_id
UNION ALL
SELECT
  'users',
  count(*),
  md5(string_agg(
    concat_ws(
      '|',
      u.id,
      u.status::text,
      coalesce(u."lmsproClubId", ''),
      u."lmsproRoleIds"::text
    ),
    ',' ORDER BY u.id
  ))
FROM public.users u
JOIN r9_params p ON u."organizationId" = p.org_id;

DO $rehearsal_preconditions$
DECLARE
  actual integer;
  fingerprint text;
BEGIN
  SELECT count(*) INTO actual
  FROM lmspro.lmspro_seasons s
  JOIN r9_params p
    ON s.organization_id = p.org_id
   AND s.id = p.season_id
  WHERE s.is_current = true AND s.status = 'ACTIVE';
  IF actual <> 1 THEN
    RAISE EXCEPTION 'R9-A2 season precondition failed: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM public.users u
  JOIN r9_params p
    ON u.id = p.attestor_id
   AND u."organizationId" = p.org_id
  WHERE u.status = 'ACTIVE'
    AND u.role IN ('OWNER', 'ADMIN')
    AND EXISTS (
      SELECT 1
      FROM lmspro.lmspro_club_applications a
      WHERE a.organization_id = p.org_id
        AND a.season_id = p.season_id
        AND a.reviewed_by_id = u.id
        AND a.status = 'APPROVED'
    );
  IF actual <> 1 THEN
    RAISE EXCEPTION 'R9-A2 attestor precondition failed: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM public._prisma_migrations m
  WHERE m.migration_name IN (
      '20260501090000_fix_bst_key_date_timezone_offset',
      '20260728120000_lmspro_r9_a1_admission_participation',
      '20260729123000_lmspro_team_approved_unallocated'
    )
    AND m.finished_at IS NOT NULL
    AND m.rolled_back_at IS NULL;
  IF actual <> 3 THEN
    RAISE EXCEPTION 'R9-A2 migration precondition failed: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM public._prisma_migrations
  WHERE finished_at IS NULL AND rolled_back_at IS NULL;
  IF actual <> 0 THEN
    RAISE EXCEPTION 'R9-A2 unresolved migration precondition failed: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM lmspro.lmspro_clubs c
  JOIN r9_params p
    ON c.organization_id = p.org_id
   AND c.season_id = p.season_id;
  IF actual <> 64 THEN
    RAISE EXCEPTION 'R9-A2 Club count changed: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM lmspro.lmspro_teams t
  JOIN r9_params p
    ON t.organization_id = p.org_id
   AND t.season_id = p.season_id;
  IF actual <> 400 THEN
    RAISE EXCEPTION 'R9-A2 Team count changed: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM lmspro.lmspro_club_applications a
  JOIN r9_params p
    ON a.organization_id = p.org_id
   AND a.season_id = p.season_id;
  IF actual <> 11 THEN
    RAISE EXCEPTION 'R9-A2 Application count changed: %', actual;
  END IF;

  SELECT count(*), md5(string_agg(club_id, ',' ORDER BY club_id))
  INTO actual, fingerprint
  FROM r9_legacy_candidates;
  IF actual <> 54 OR fingerprint <> 'dcf67475260a9bb325025a6383664394' THEN
    RAISE EXCEPTION
      'R9-A2 legacy cohort changed: count %, fingerprint %',
      actual, fingerprint;
  END IF;

  SELECT count(*) INTO actual FROM r9_application_candidates;
  IF actual <> 9 THEN
    RAISE EXCEPTION 'R9-A2 Application cohort changed: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM r9_application_candidates a
  WHERE NOT (
    EXISTS (
      SELECT 1
      FROM public.users u
      JOIN r9_params p ON u."organizationId" = p.org_id
      WHERE u."lmsproClubId" = a.club_id
        AND u.status = 'ACTIVE'
    )
    AND EXISTS (
      SELECT 1
      FROM lmspro.lmspro_club_officials o
      JOIN public.users u
        ON u.id = o.user_id
       AND u."organizationId" = o.organization_id
      JOIN r9_params p ON o.organization_id = p.org_id
      WHERE o.club_id = a.club_id
        AND u.status = 'ACTIVE'
    )
  );
  IF actual <> 0 THEN
    RAISE EXCEPTION 'R9-A2 Application C2 evidence changed: %', actual;
  END IF;

  SELECT count(*) INTO actual FROM r9_members;
  IF actual <> 63 THEN
    RAISE EXCEPTION 'R9-A2 combined evidence cohort changed: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM r9_members
  GROUP BY club_id
  HAVING count(*) > 1;
  IF actual IS NOT NULL THEN
    RAISE EXCEPTION 'R9-A2 evidence cohort overlap detected';
  END IF;

  SELECT count(*) INTO actual
  FROM r9_transitions
  WHERE source_status = 'APPROVED'
    AND target_status = 'WAITING_LIST';
  IF actual <> 9 OR actual <> (SELECT count(*) FROM r9_transitions) THEN
    RAISE EXCEPTION 'R9-A2 transition cohort changed: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM lmspro.lmspro_club_admission_evidence e
  JOIN r9_params p
    ON e.organization_id = p.org_id
   AND e.season_id = p.season_id;
  IF actual <> 0 THEN
    RAISE EXCEPTION 'R9-A2 evidence already exists: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM lmspro.lmspro_admission_evidence_batches b
  JOIN r9_params p
    ON b.organization_id = p.org_id
   AND b.season_id = p.season_id;
  IF actual <> 0 THEN
    RAISE EXCEPTION 'R9-A2 batch already exists: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM lmspro.lmspro_participation_transition_outbox o
  JOIN r9_params p
    ON o.organization_id = p.org_id
   AND o.season_id = p.season_id;
  IF actual <> 0 THEN
    RAISE EXCEPTION 'R9-A2 outbox is not empty: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM lmspro.lmspro_notification_settings n
  JOIN r9_params p ON n.organization_id = p.org_id
  WHERE n.event_key IN (
      'lmspro.club_participation.became_current',
      'lmspro.club_participation.returned_to_waiting_list'
    )
    AND n.is_enabled = true;
  IF actual <> 0 THEN
    RAISE EXCEPTION 'R9-A2 notification precondition failed: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM (
    SELECT evidence_key FROM r9_legacy_candidates
    UNION ALL
    SELECT evidence_key FROM r9_application_candidates
  ) proposed
  JOIN lmspro.lmspro_club_admission_evidence e
    ON e.idempotency_key = proposed.evidence_key;
  IF actual <> 0 THEN
    RAISE EXCEPTION 'R9-A2 evidence idempotency collision: %', actual;
  END IF;
END
$rehearsal_preconditions$;

INSERT INTO lmspro.lmspro_admission_evidence_batches (
  id,
  organization_id,
  season_id,
  attested_by_id,
  attested_at,
  scope_description,
  evidential_basis,
  idempotency_key,
  created_at
)
SELECT
  p.batch_id,
  p.org_id,
  p.season_id,
  p.attestor_id,
  p.run_at,
  'PRODUCTION Derby JFL Clubs created before 1 June 2026 Europe/London, excluding Clubs with existing admission evidence.',
  'Control-owner attestation: every Club before 1 June 2026 was imported from the Derby JFL Knack system by the control owner. Automated historic source evidence is unavailable; no import job or unsupported source reference is fabricated.',
  p.batch_key,
  p.run_at
FROM r9_params p;

INSERT INTO lmspro.lmspro_club_admission_evidence (
  id,
  organization_id,
  season_id,
  club_id,
  evidence_type,
  source_type,
  source_reference_id,
  import_job_id,
  club_application_id,
  attestation_batch_id,
  recorded_by_id,
  effective_at,
  recorded_at,
  evidence_version,
  automated_source_unavailable,
  primary_c2_outcome,
  primary_c2_detail_code,
  rollover_source_evidence_id,
  supersedes_evidence_id,
  idempotency_key
)
SELECT
  gen_random_uuid()::text,
  p.org_id,
  p.season_id,
  c.club_id,
  'LEGACY_ATTESTED_IMPORT',
  'ATTESTATION_BATCH',
  p.batch_id,
  NULL,
  NULL,
  p.batch_id,
  p.attestor_id,
  c.effective_at,
  p.run_at,
  1,
  true,
  'NOT_REQUESTED',
  NULL,
  NULL,
  NULL,
  c.evidence_key
FROM r9_legacy_candidates c
CROSS JOIN r9_params p;

INSERT INTO lmspro.lmspro_club_admission_evidence (
  id,
  organization_id,
  season_id,
  club_id,
  evidence_type,
  source_type,
  source_reference_id,
  import_job_id,
  club_application_id,
  attestation_batch_id,
  recorded_by_id,
  effective_at,
  recorded_at,
  evidence_version,
  automated_source_unavailable,
  primary_c2_outcome,
  primary_c2_detail_code,
  rollover_source_evidence_id,
  supersedes_evidence_id,
  idempotency_key
)
SELECT
  gen_random_uuid()::text,
  p.org_id,
  p.season_id,
  c.club_id,
  'APPROVED_APPLICATION',
  'CLUB_APPLICATION',
  c.application_id,
  NULL,
  c.application_id,
  NULL,
  NULL,
  c.effective_at,
  p.run_at,
  1,
  false,
  'LINKED',
  NULL,
  NULL,
  NULL,
  c.evidence_key
FROM r9_application_candidates c
CROSS JOIN r9_params p;

CREATE TEMP TABLE r9_changed_clubs ON COMMIT DROP AS
WITH changed AS (
  UPDATE lmspro.lmspro_clubs c
  SET status = t.target_status,
      updated_at = p.run_at
  FROM r9_transitions t
  CROSS JOIN r9_params p
  WHERE c.id = t.club_id
    AND c.organization_id = p.org_id
    AND c.season_id = p.season_id
    AND c.status = t.source_status
  RETURNING c.id AS club_id
)
SELECT
  changed.club_id,
  t.source_status,
  t.target_status,
  t.qualifying_current_team_count
FROM changed
JOIN r9_transitions t ON t.club_id = changed.club_id;

INSERT INTO lmspro.lmspro_participation_transition_outbox (
  id,
  organization_id,
  season_id,
  club_id,
  event_key,
  from_status,
  to_status,
  triggering_mutation_id,
  idempotency_key,
  status,
  attempt_count,
  available_at,
  created_at,
  updated_at
)
SELECT
  gen_random_uuid()::text,
  p.org_id,
  p.season_id,
  c.club_id,
  'lmspro.club_participation.returned_to_waiting_list',
  c.source_status,
  c.target_status,
  p.batch_id,
  concat(
    'lmspro-r9-a2:', p.org_id, ':', p.season_id,
    ':participation:club:', c.club_id
  ),
  'SUPPRESSED',
  0,
  p.run_at,
  p.run_at,
  p.run_at
FROM r9_changed_clubs c
CROSS JOIN r9_params p;

INSERT INTO public.audit_logs (
  id,
  action,
  "entityType",
  "entityId",
  metadata,
  "createdAt",
  "userId",
  "organizationId"
)
SELECT
  gen_random_uuid()::text,
  'LMSPRO_CLUB_PARTICIPATION_CONVERGED',
  'LMSProClub',
  c.club_id,
  jsonb_build_object(
    'seasonId', p.season_id,
    'fromStatus', c.source_status,
    'toStatus', c.target_status,
    'qualifyingCurrentTeamCount', c.qualifying_current_team_count,
    'notificationStatus', 'SUPPRESSED',
    'reconciliationBatchId', p.batch_id,
    'snapshotBranch', p.snapshot_branch
  ),
  p.run_at,
  p.attestor_id,
  p.org_id
FROM r9_changed_clubs c
CROSS JOIN r9_params p;

INSERT INTO public.audit_logs (
  id,
  action,
  "entityType",
  "entityId",
  metadata,
  "createdAt",
  "userId",
  "organizationId"
)
SELECT
  gen_random_uuid()::text,
  'LMSPRO_R9_A2_COMBINED_ADMISSION_RECONCILED',
  'LMSProAdmissionEvidenceBatch',
  p.batch_id,
  jsonb_build_object(
    'seasonId', p.season_id,
    'cutoff', '2026-06-01 Europe/London',
    'legacyEvidenceInserted', 54,
    'approvedApplicationEvidenceInserted', 9,
    'clubStatusChanges', 9,
    'membershipFingerprint', 'dcf67475260a9bb325025a6383664394',
    'notifications', 'SUPPRESSED',
    'snapshotBranch', p.snapshot_branch,
    'applicationCommit', p.application_commit
  ),
  p.run_at,
  p.attestor_id,
  p.org_id
FROM r9_params p;

CREATE TEMP TABLE r9_guard_after (
  domain text PRIMARY KEY,
  row_count bigint NOT NULL,
  fingerprint text NOT NULL
) ON COMMIT DROP;

INSERT INTO r9_guard_after
SELECT
  'teams',
  count(*),
  md5(string_agg(
    concat_ws(
      '|',
      t.id,
      t.status::text,
      coalesce(t.agg_id, ''),
      coalesce(t.age_group_id, ''),
      t.updated_at::text
    ),
    ',' ORDER BY t.id
  ))
FROM lmspro.lmspro_teams t
JOIN r9_params p
  ON t.organization_id = p.org_id
 AND t.season_id = p.season_id
UNION ALL
SELECT
  'club_officials',
  count(*),
  md5(string_agg(
    concat_ws(
      '|',
      o.id,
      o.club_id,
      o.user_id,
      o.role,
      o.is_primary::text
    ),
    ',' ORDER BY o.id
  ))
FROM lmspro.lmspro_club_officials o
JOIN lmspro.lmspro_clubs c ON c.id = o.club_id
JOIN r9_params p
  ON c.organization_id = p.org_id
 AND c.season_id = p.season_id
WHERE o.organization_id = p.org_id
UNION ALL
SELECT
  'users',
  count(*),
  md5(string_agg(
    concat_ws(
      '|',
      u.id,
      u.status::text,
      coalesce(u."lmsproClubId", ''),
      u."lmsproRoleIds"::text
    ),
    ',' ORDER BY u.id
  ))
FROM public.users u
JOIN r9_params p ON u."organizationId" = p.org_id;

DO $rehearsal_postconditions$
DECLARE
  actual integer;
BEGIN
  SELECT count(*) INTO actual
  FROM r9_guard_before before_guard
  JOIN r9_guard_after after_guard USING (domain)
  WHERE before_guard.row_count <> after_guard.row_count
     OR before_guard.fingerprint <> after_guard.fingerprint;
  IF actual <> 0 THEN
    RAISE EXCEPTION 'R9-A2 protected-domain guard failed: %', actual;
  END IF;

  SELECT count(*) INTO actual FROM r9_changed_clubs;
  IF actual <> 9 THEN
    RAISE EXCEPTION 'R9-A2 changed-Club postcondition failed: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM lmspro.lmspro_club_admission_evidence e
  JOIN r9_params p
    ON e.organization_id = p.org_id
   AND e.season_id = p.season_id;
  IF actual <> 63 THEN
    RAISE EXCEPTION 'R9-A2 evidence postcondition failed: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM lmspro.lmspro_participation_transition_outbox o
  JOIN r9_params p
    ON o.organization_id = p.org_id
   AND o.season_id = p.season_id
  WHERE o.status = 'SUPPRESSED';
  IF actual <> 9 THEN
    RAISE EXCEPTION 'R9-A2 outbox postcondition failed: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM lmspro.lmspro_participation_transition_outbox o
  JOIN r9_params p
    ON o.organization_id = p.org_id
   AND o.season_id = p.season_id
  WHERE o.status <> 'SUPPRESSED';
  IF actual <> 0 THEN
    RAISE EXCEPTION 'R9-A2 notification suppression failed: %', actual;
  END IF;

  SELECT count(*) INTO actual
  FROM public.audit_logs a
  JOIN r9_params p
    ON a."organizationId" = p.org_id
   AND a."createdAt" = p.run_at
  WHERE a.action IN (
    'LMSPRO_CLUB_PARTICIPATION_CONVERGED',
    'LMSPRO_R9_A2_COMBINED_ADMISSION_RECONCILED'
  );
  IF actual <> 10 THEN
    RAISE EXCEPTION 'R9-A2 audit postcondition failed: %', actual;
  END IF;
END
$rehearsal_postconditions$;

SELECT evidence_type, count(*) AS rehearsed_evidence_rows
FROM lmspro.lmspro_club_admission_evidence e
JOIN r9_params p
  ON e.organization_id = p.org_id
 AND e.season_id = p.season_id
GROUP BY evidence_type
ORDER BY evidence_type;

SELECT source_status, target_status, count(*) AS rehearsed_club_changes
FROM r9_changed_clubs
GROUP BY source_status, target_status
ORDER BY source_status, target_status;

SELECT c.status, count(*) AS rehearsed_club_total
FROM lmspro.lmspro_clubs c
JOIN r9_params p
  ON c.organization_id = p.org_id
 AND c.season_id = p.season_id
GROUP BY c.status
ORDER BY c.status;

SELECT status, count(*) AS rehearsed_outbox_rows
FROM lmspro.lmspro_participation_transition_outbox o
JOIN r9_params p
  ON o.organization_id = p.org_id
 AND o.season_id = p.season_id
GROUP BY status
ORDER BY status;

SELECT action, count(*) AS rehearsed_audit_rows
FROM public.audit_logs a
JOIN r9_params p
  ON a."organizationId" = p.org_id
 AND a."createdAt" = p.run_at
WHERE a.action IN (
  'LMSPRO_CLUB_PARTICIPATION_CONVERGED',
  'LMSPRO_R9_A2_COMBINED_ADMISSION_RECONCILED'
)
GROUP BY action
ORDER BY action;

SELECT
  before_guard.domain,
  before_guard.row_count AS before_rows,
  after_guard.row_count AS after_rows,
  before_guard.fingerprint = after_guard.fingerprint AS unchanged
FROM r9_guard_before before_guard
JOIN r9_guard_after after_guard USING (domain)
ORDER BY before_guard.domain;

ROLLBACK;
