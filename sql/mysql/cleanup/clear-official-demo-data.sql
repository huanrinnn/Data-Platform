-- qData official demo data cleanup script
-- Scope:
-- 1. Remove built-in report demo tables under the qdata schema.
-- 2. Remove official sample projects and their ETL/quality/asset metadata.
-- 3. Remove demo datasources and model materialization records that point to demo environments.
--
-- Notes:
-- 1. This script intentionally keeps system users, menus, roles, dictionaries,
--    and other platform bootstrap metadata required for normal operation.
-- 2. Review the SELECT statements near the bottom before running in a shared environment.
-- 3. Run against MySQL 8.0 with the default qdata metadata database selected.

SET NAMES utf8mb4;
USE `qdata`;

SET @old_foreign_key_checks := @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;

DROP TEMPORARY TABLE IF EXISTS tmp_demo_project_ids;
CREATE TEMPORARY TABLE tmp_demo_project_ids AS
SELECT DISTINCT id
FROM att_project
WHERE name IN ('基础数据组', '监测数据组', '业务数据组');

DROP TEMPORARY TABLE IF EXISTS tmp_demo_datasource_ids;
CREATE TEMPORARY TABLE tmp_demo_datasource_ids AS
SELECT DISTINCT datasource_id AS id
FROM da_datasource_project_rel
WHERE project_id IN (SELECT id FROM tmp_demo_project_ids)
UNION
SELECT DISTINCT id
FROM da_datasource
WHERE datasource_name IN (
        '水资源管理系统（第三方库）',
        '水文监测系统（第三方库）',
        '水资源管理系统（MySQL）',
        '水资源管理系统（DM）',
        '水资源管理系统（Oracle）'
     )
   OR ip IN ('dm8-demo', 'mysql-demo', 'oracle-demo', 'dm8')
   OR datasource_config LIKE '%WATER_TP%'
   OR datasource_config LIKE '%dm8-demo%'
   OR datasource_config LIKE '%mysql-demo%'
   OR datasource_config LIKE '%oracle-demo%';

DROP TEMPORARY TABLE IF EXISTS tmp_demo_asset_ids;
CREATE TEMPORARY TABLE tmp_demo_asset_ids AS
SELECT DISTINCT id
FROM da_asset
WHERE id IN (
        SELECT asset_id
        FROM da_asset_project_rel
        WHERE project_id IN (SELECT id FROM tmp_demo_project_ids)
     )
   OR datasource_id IN (SELECT id FROM tmp_demo_datasource_ids)
   OR table_name IN (
        'rep_demo_dxtj',
        'rep_demo_employee',
        'rep_demo_gongsi',
        'rep_demo_jianpiao',
        'rep_demo_xiaoshou'
     );

DROP TEMPORARY TABLE IF EXISTS tmp_demo_asset_api_ids;
CREATE TEMPORARY TABLE tmp_demo_asset_api_ids AS
SELECT DISTINCT id
FROM da_asset_api
WHERE asset_id IN (SELECT id FROM tmp_demo_asset_ids);

DROP TEMPORARY TABLE IF EXISTS tmp_demo_model_ids;
CREATE TEMPORARY TABLE tmp_demo_model_ids AS
SELECT DISTINCT id
FROM dp_model
WHERE datasource_id IN (SELECT id FROM tmp_demo_datasource_ids);

DROP TEMPORARY TABLE IF EXISTS tmp_demo_etl_task_ids;
CREATE TEMPORARY TABLE tmp_demo_etl_task_ids AS
SELECT DISTINCT id
FROM dpp_etl_task
WHERE project_id IN (SELECT id FROM tmp_demo_project_ids);

DROP TEMPORARY TABLE IF EXISTS tmp_demo_etl_node_ids;
CREATE TEMPORARY TABLE tmp_demo_etl_node_ids AS
SELECT DISTINCT id
FROM dpp_etl_node
WHERE project_id IN (SELECT id FROM tmp_demo_project_ids);

DROP TEMPORARY TABLE IF EXISTS tmp_demo_quality_task_ids;
CREATE TEMPORARY TABLE tmp_demo_quality_task_ids AS
SELECT DISTINCT id
FROM dpp_quality_task
WHERE asset_id IN (SELECT id FROM tmp_demo_asset_ids);

-- Preview counts before delete.
SELECT 'demo_projects' AS object_type, COUNT(*) AS rows_to_delete FROM tmp_demo_project_ids
UNION ALL
SELECT 'demo_datasources', COUNT(*) FROM tmp_demo_datasource_ids
UNION ALL
SELECT 'demo_assets', COUNT(*) FROM tmp_demo_asset_ids
UNION ALL
SELECT 'demo_asset_apis', COUNT(*) FROM tmp_demo_asset_api_ids
UNION ALL
SELECT 'demo_models', COUNT(*) FROM tmp_demo_model_ids
UNION ALL
SELECT 'demo_etl_tasks', COUNT(*) FROM tmp_demo_etl_task_ids
UNION ALL
SELECT 'demo_etl_nodes', COUNT(*) FROM tmp_demo_etl_node_ids
UNION ALL
SELECT 'demo_quality_tasks', COUNT(*) FROM tmp_demo_quality_task_ids
UNION ALL
SELECT 'audit_rule_templates', COUNT(*) FROM att_audit_rule
UNION ALL
SELECT 'clean_rule_templates', COUNT(*) FROM att_clean_rule
UNION ALL
SELECT 'clean_rule_categories', COUNT(*) FROM att_clean_cat
UNION ALL
SELECT 'quality_rule_categories', COUNT(*) FROM att_quality_cat
UNION ALL
SELECT 'category_management_rows', SUM(cnt)
FROM (
    SELECT COUNT(*) AS cnt FROM att_api_cat
    UNION ALL SELECT COUNT(*) FROM att_asset_cat
    UNION ALL SELECT COUNT(*) FROM att_data_dev_cat
    UNION ALL SELECT COUNT(*) FROM att_data_elem_cat
    UNION ALL SELECT COUNT(*) FROM att_discover_task_cat
    UNION ALL SELECT COUNT(*) FROM att_doc_cat
    UNION ALL SELECT COUNT(*) FROM att_document_cat
    UNION ALL SELECT COUNT(*) FROM att_job_cat
    UNION ALL SELECT COUNT(*) FROM att_model_cat
    UNION ALL SELECT COUNT(*) FROM att_tag_cat
    UNION ALL SELECT COUNT(*) FROM att_task_cat
) category_counts
UNION ALL
SELECT 'source_systems', COUNT(*) FROM att_source_system;

START TRANSACTION;

-- Asset-related metadata.
DELETE FROM da_asset_api_param
WHERE api_id IN (SELECT id FROM tmp_demo_asset_api_ids);

DELETE FROM da_asset_api
WHERE id IN (SELECT id FROM tmp_demo_asset_api_ids);

DELETE FROM da_asset_file
WHERE asset_id IN (SELECT id FROM tmp_demo_asset_ids);

DELETE FROM da_asset_files
WHERE asset_id IN (SELECT id FROM tmp_demo_asset_ids);

DELETE FROM da_asset_apply
WHERE asset_id IN (SELECT id FROM tmp_demo_asset_ids)
   OR project_id IN (SELECT id FROM tmp_demo_project_ids);

DELETE FROM da_asset_audit_alert
WHERE asset_id IN (SELECT id FROM tmp_demo_asset_ids);

DELETE FROM da_asset_audit_rule
WHERE asset_id IN (SELECT id FROM tmp_demo_asset_ids);

DELETE FROM da_asset_audit_schedule
WHERE asset_id IN (SELECT id FROM tmp_demo_asset_ids)
   OR task_id IN (SELECT id FROM tmp_demo_etl_task_ids)
   OR node_id IN (SELECT id FROM tmp_demo_etl_node_ids);

DELETE FROM att_tag_asset_rel
WHERE asset_id IN (SELECT id FROM tmp_demo_asset_ids);

DELETE FROM dg_desensitize_assetcolumn
WHERE asset_id IN (SELECT id FROM tmp_demo_asset_ids)
   OR assetcolumn_id IN (
        SELECT id
        FROM da_asset_column
        WHERE asset_id IN (SELECT id FROM tmp_demo_asset_ids)
     );

DELETE FROM dp_data_elem_asset_rel
WHERE asset_id IN (SELECT id FROM tmp_demo_asset_ids)
   OR column_id IN (
        SELECT id
        FROM da_asset_column
        WHERE asset_id IN (SELECT id FROM tmp_demo_asset_ids)
     );

DELETE FROM da_asset_theme_rel
WHERE asset_id IN (SELECT id FROM tmp_demo_asset_ids);

DELETE FROM da_asset_project_rel
WHERE asset_id IN (SELECT id FROM tmp_demo_asset_ids)
   OR project_id IN (SELECT id FROM tmp_demo_project_ids);

DELETE FROM da_asset_column
WHERE asset_id IN (SELECT id FROM tmp_demo_asset_ids);

DELETE FROM da_asset
WHERE id IN (SELECT id FROM tmp_demo_asset_ids);

-- Data model metadata generated from demo datasources.
DELETE FROM dp_model_materialized
WHERE model_id IN (SELECT id FROM tmp_demo_model_ids)
   OR datasource_id IN (SELECT id FROM tmp_demo_datasource_ids)
   OR asset_id IN (SELECT id FROM tmp_demo_asset_ids);

DELETE FROM dp_model_column
WHERE model_id IN (SELECT id FROM tmp_demo_model_ids);

DELETE FROM dp_model
WHERE id IN (SELECT id FROM tmp_demo_model_ids);

-- ETL runtime metadata.
DELETE FROM dpp_etl_node_instance_log
WHERE node_id IN (SELECT id FROM tmp_demo_etl_node_ids)
   OR task_instance_id IN (
        SELECT id
        FROM dpp_etl_task_instance
        WHERE task_id IN (SELECT id FROM tmp_demo_etl_task_ids)
     );

DELETE FROM dpp_etl_node_instance
WHERE node_id IN (SELECT id FROM tmp_demo_etl_node_ids)
   OR task_instance_id IN (
        SELECT id
        FROM dpp_etl_task_instance
        WHERE task_id IN (SELECT id FROM tmp_demo_etl_task_ids)
     );

DELETE FROM dpp_etl_task_instance_log
WHERE task_id IN (SELECT id FROM tmp_demo_etl_task_ids)
   OR task_instance_id IN (
        SELECT id
        FROM dpp_etl_task_instance
        WHERE task_id IN (SELECT id FROM tmp_demo_etl_task_ids)
     );

DELETE FROM dpp_etl_task_instance
WHERE task_id IN (SELECT id FROM tmp_demo_etl_task_ids)
   OR project_id IN (SELECT id FROM tmp_demo_project_ids);

DELETE FROM dpp_etl_task_node_rel_log
WHERE task_id IN (SELECT id FROM tmp_demo_etl_task_ids)
   OR post_node_id IN (SELECT id FROM tmp_demo_etl_node_ids)
   OR pre_node_id IN (SELECT id FROM tmp_demo_etl_node_ids);

DELETE FROM dpp_etl_task_node_rel
WHERE task_id IN (SELECT id FROM tmp_demo_etl_task_ids)
   OR post_node_id IN (SELECT id FROM tmp_demo_etl_node_ids)
   OR pre_node_id IN (SELECT id FROM tmp_demo_etl_node_ids);

DELETE FROM dpp_etl_scheduler
WHERE task_id IN (SELECT id FROM tmp_demo_etl_task_ids);

DELETE FROM dpp_etl_node_log
WHERE project_id IN (SELECT id FROM tmp_demo_project_ids)
   OR id IN (SELECT id FROM tmp_demo_etl_node_ids);

DELETE FROM dpp_etl_task_log
WHERE project_id IN (SELECT id FROM tmp_demo_project_ids)
   OR id IN (SELECT id FROM tmp_demo_etl_task_ids);

DELETE FROM dpp_etl_node
WHERE id IN (SELECT id FROM tmp_demo_etl_node_ids);

DELETE FROM dpp_etl_task
WHERE id IN (SELECT id FROM tmp_demo_etl_task_ids);

-- Quality task metadata linked to demo assets.
DELETE FROM dpp_quality_log
WHERE quality_id IN (SELECT id FROM tmp_demo_quality_task_ids);

DELETE FROM dpp_quality_task_obj
WHERE task_id IN (SELECT id FROM tmp_demo_quality_task_ids);

DELETE FROM dpp_quality_task_evaluate
WHERE task_id IN (SELECT id FROM tmp_demo_quality_task_ids);

DELETE FROM dpp_quality_task
WHERE id IN (SELECT id FROM tmp_demo_quality_task_ids);

-- Project and datasource relations.
DELETE FROM da_datasource_project_rel
WHERE project_id IN (SELECT id FROM tmp_demo_project_ids)
   OR datasource_id IN (SELECT id FROM tmp_demo_datasource_ids);

DELETE FROM att_project_user_rel
WHERE project_id IN (SELECT id FROM tmp_demo_project_ids);

DELETE FROM att_project
WHERE id IN (SELECT id FROM tmp_demo_project_ids);

DELETE FROM da_datasource
WHERE id IN (SELECT id FROM tmp_demo_datasource_ids);

-- Built-in rule templates.
DELETE FROM att_audit_rule;

DELETE FROM att_clean_rule;

-- Built-in category management and source system demo data.
DELETE FROM att_api_cat;

DELETE FROM att_asset_cat;

DELETE FROM att_clean_cat;

DELETE FROM att_data_dev_cat;

DELETE FROM att_data_elem_cat;

DELETE FROM att_discover_task_cat;

DELETE FROM att_doc_cat;

DELETE FROM att_document_cat;

DELETE FROM att_job_cat;

DELETE FROM att_model_cat;

DELETE FROM att_quality_cat;

DELETE FROM att_tag_cat;

DELETE FROM att_task_cat;

DELETE FROM att_source_system;

UPDATE mc_db
SET source_system_id = NULL,
    source_system_name = NULL
WHERE source_system_id IS NOT NULL
   OR source_system_name IS NOT NULL;

UPDATE mc_task
SET source_system_id = 0,
    source_system_name = ''
WHERE source_system_id <> 0
   OR source_system_name <> '';

UPDATE mc_task_instance
SET source_system_id = 0,
    source_system_name = ''
WHERE source_system_id <> 0
   OR source_system_name <> '';

UPDATE da_asset
SET cat_code = NULL
WHERE cat_code IS NOT NULL
  AND cat_code <> '';

UPDATE dp_model
SET cat_code = NULL
WHERE cat_code IS NOT NULL
  AND cat_code <> '';

UPDATE dpp_etl_task
SET cat_code = NULL,
    cat_id = NULL
WHERE (cat_code IS NOT NULL AND cat_code <> '')
   OR cat_id IS NOT NULL;

UPDATE dpp_onl_desform
SET cat_code = NULL
WHERE cat_code IS NOT NULL
  AND cat_code <> '';

UPDATE att_tag
SET cat_code = '',
    cat_name = NULL
WHERE cat_code <> ''
   OR cat_name IS NOT NULL;

UPDATE da_discovery_task
SET cat_code = ''
WHERE cat_code <> '';

UPDATE da_doc
SET cat_code = '',
    cat_id = 0
WHERE cat_code <> ''
   OR cat_id <> 0;

UPDATE dp_data_elem
SET cat_code = ''
WHERE cat_code <> '';

UPDATE dp_document
SET cat_code = ''
WHERE cat_code <> '';

UPDATE dpp_etl_task_instance
SET cat_code = '',
    cat_id = 0
WHERE cat_code <> ''
   OR cat_id <> 0;

UPDATE dpp_quality_task
SET cat_code = ''
WHERE cat_code <> '';

UPDATE ds_api
SET cat_code = '',
    cat_id = 0
WHERE cat_code <> ''
   OR cat_id <> 0;

UPDATE ds_api_log
SET cat_code = '',
    cat_id = 0
WHERE cat_code <> ''
   OR cat_id <> 0;

-- The application requires one active project context for datasource creation.
-- If demo cleanup removes the last project, keep an empty bootstrap project and
-- attach remaining user-created datasources to it.
SET @active_project_count := (
    SELECT COUNT(*)
    FROM att_project
    WHERE del_flag = '0'
);

SET @bootstrap_manager_id := COALESCE(
    (SELECT user_id FROM system_user WHERE user_id = 2 AND del_flag = '0' LIMIT 1),
    (SELECT user_id FROM system_user WHERE user_id = 1 AND del_flag = '0' LIMIT 1),
    1
);

INSERT INTO att_project (
    id,
    name,
    manager_id,
    description,
    valid_flag,
    del_flag,
    create_by,
    creator_id,
    update_by,
    updater_id,
    remark,
    code
)
SELECT
    1,
    'Default Project',
    @bootstrap_manager_id,
    'Bootstrap project retained after demo cleanup.',
    '1',
    '0',
    'system',
    1,
    'system',
    1,
    'demo cleanup bootstrap project',
    '141883958809440'
WHERE @active_project_count = 0
  AND NOT EXISTS (SELECT 1 FROM att_project WHERE id = 1);

UPDATE att_project
SET name = 'Default Project',
    manager_id = @bootstrap_manager_id,
    description = 'Bootstrap project retained after demo cleanup.',
    valid_flag = '1',
    del_flag = '0',
    update_by = 'system',
    updater_id = 1,
    remark = 'demo cleanup bootstrap project',
    code = COALESCE(NULLIF(code, ''), '141883958809440')
WHERE @active_project_count = 0
  AND id = 1;

SET @bootstrap_project_id := IF(
    @active_project_count = 0,
    1,
    (SELECT id FROM att_project WHERE del_flag = '0' ORDER BY id LIMIT 1)
);

SET @bootstrap_project_code := (
    SELECT code
    FROM att_project
    WHERE id = @bootstrap_project_id
);

INSERT INTO att_project_user_rel (
    project_id,
    user_id,
    valid_flag,
    del_flag,
    create_by,
    creator_id,
    update_by,
    updater_id,
    remark
)
SELECT
    @bootstrap_project_id,
    @bootstrap_manager_id,
    '1',
    '0',
    'system',
    1,
    'system',
    1,
    'demo cleanup bootstrap manager relation'
WHERE @active_project_count = 0
  AND @bootstrap_project_id IS NOT NULL
  AND @bootstrap_manager_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM att_project_user_rel
      WHERE project_id = @bootstrap_project_id
        AND user_id = @bootstrap_manager_id
  );

INSERT INTO da_datasource_project_rel (
    project_id,
    project_code,
    datasource_id,
    valid_flag,
    create_by,
    creator_id,
    update_by,
    updater_id,
    remark,
    dpp_assigned
)
SELECT
    @bootstrap_project_id,
    @bootstrap_project_code,
    ds.id,
    '1',
    'system',
    1,
    'system',
    1,
    'demo cleanup bootstrap datasource relation',
    '1'
FROM da_datasource ds
WHERE @active_project_count = 0
  AND @bootstrap_project_id IS NOT NULL
  AND @bootstrap_project_code IS NOT NULL
  AND ds.del_flag = '0'
  AND NOT EXISTS (
      SELECT 1
      FROM da_datasource_project_rel rel
      WHERE rel.project_id = @bootstrap_project_id
        AND rel.datasource_id = ds.id
  );

COMMIT;

-- Built-in report demo tables.
DROP TABLE IF EXISTS `rep_demo_dxtj`;
DROP TABLE IF EXISTS `rep_demo_employee`;
DROP TABLE IF EXISTS `rep_demo_gongsi`;
DROP TABLE IF EXISTS `rep_demo_jianpiao`;
DROP TABLE IF EXISTS `rep_demo_xiaoshou`;

SET FOREIGN_KEY_CHECKS = @old_foreign_key_checks;

-- Post-cleanup verification.
SELECT 'att_project' AS table_name, COUNT(*) AS remaining_rows
FROM att_project
WHERE name IN ('基础数据组', '监测数据组', '业务数据组')
UNION ALL
SELECT 'da_datasource', COUNT(*)
FROM da_datasource
WHERE id IN (SELECT id FROM tmp_demo_datasource_ids)
UNION ALL
SELECT 'da_asset', COUNT(*)
FROM da_asset
WHERE id IN (SELECT id FROM tmp_demo_asset_ids)
UNION ALL
SELECT 'dpp_etl_task', COUNT(*)
FROM dpp_etl_task
WHERE id IN (SELECT id FROM tmp_demo_etl_task_ids)
UNION ALL
SELECT 'dpp_etl_node', COUNT(*)
FROM dpp_etl_node
WHERE id IN (SELECT id FROM tmp_demo_etl_node_ids)
UNION ALL
SELECT 'dpp_quality_task', COUNT(*)
FROM dpp_quality_task
WHERE id IN (SELECT id FROM tmp_demo_quality_task_ids)
UNION ALL
SELECT 'att_audit_rule', COUNT(*)
FROM att_audit_rule
UNION ALL
SELECT 'att_clean_rule', COUNT(*)
FROM att_clean_rule
UNION ALL
SELECT 'att_clean_cat', COUNT(*)
FROM att_clean_cat
UNION ALL
SELECT 'att_quality_cat', COUNT(*)
FROM att_quality_cat
UNION ALL
SELECT 'category_management_rows', SUM(cnt)
FROM (
    SELECT COUNT(*) AS cnt FROM att_api_cat
    UNION ALL SELECT COUNT(*) FROM att_asset_cat
    UNION ALL SELECT COUNT(*) FROM att_data_dev_cat
    UNION ALL SELECT COUNT(*) FROM att_data_elem_cat
    UNION ALL SELECT COUNT(*) FROM att_discover_task_cat
    UNION ALL SELECT COUNT(*) FROM att_doc_cat
    UNION ALL SELECT COUNT(*) FROM att_document_cat
    UNION ALL SELECT COUNT(*) FROM att_job_cat
    UNION ALL SELECT COUNT(*) FROM att_model_cat
    UNION ALL SELECT COUNT(*) FROM att_tag_cat
    UNION ALL SELECT COUNT(*) FROM att_task_cat
) category_counts
UNION ALL
SELECT 'att_source_system', COUNT(*)
FROM att_source_system;
