-- Config-driven quality rule support.
-- This script is idempotent on MySQL 8.0.

SET @rule_config_exists = (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'att_audit_rule'
      AND COLUMN_NAME = 'rule_config'
);
SET @add_rule_config_sql = IF(
    @rule_config_exists = 0,
    'ALTER TABLE att_audit_rule ADD COLUMN rule_config LONGTEXT NULL COMMENT ''Default rule configuration in JSON format'' AFTER strategy_key',
    'SELECT 1'
);
PREPARE add_rule_config_stmt FROM @add_rule_config_sql;
EXECUTE add_rule_config_stmt;
DEALLOCATE PREPARE add_rule_config_stmt;

UPDATE att_audit_rule
SET strategy_key = 'NOT_NULL_VALIDATION',
    rule_config = '{}'
WHERE code IN ('NOT_NULL_VALIDATION', 'NUMERIC_NOT_NULL_VALIDATION');

UPDATE att_audit_rule
SET strategy_key = 'COMPOSITE_UNIQUENESS_VALIDATION',
    rule_config = '{}'
WHERE code = 'UNIQUE_VALIDATION';

UPDATE att_audit_rule
SET strategy_key = 'CHARACTER_VALIDATION',
    rule_config = '{"useRegexFlag":1,"regex":"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+[.][A-Za-z]{2,}$","ignoreNullValue":"0","allowedChars":["1"]}'
WHERE code = 'EMAIL_FORMAT_VALIDATION';

UPDATE att_audit_rule
SET strategy_key = 'CHARACTER_VALIDATION',
    rule_config = '{"useRegexFlag":1,"regex":"^1[3-9][0-9]{9}$","ignoreNullValue":"0","allowedChars":["1"]}'
WHERE code = 'PHONE_FORMAT_VALIDATION';
