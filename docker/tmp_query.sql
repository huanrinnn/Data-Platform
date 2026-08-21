DESCRIBE da_datasource;
SELECT '--- DATA ---' AS sep;
SELECT id, name, type, host, port, db_name, username, valid_flag, del_flag FROM da_datasource;
SELECT '--- MC_DB ---' AS sep;
DESCRIBE mc_db;
SELECT id, name, type, host, port, db_name, username, valid_flag, del_flag FROM mc_db;
