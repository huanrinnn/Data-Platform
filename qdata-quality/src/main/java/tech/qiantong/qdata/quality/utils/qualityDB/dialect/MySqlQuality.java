/*
 * Copyright © 2025-present Jiangsu Qiantong Technology Co., Ltd.
 *
 * This file is part of qData Data Middle Platform (Open Source Edition).
 *
 * qData is licensed under Apache License 2.0 with additional qData terms.
 * You may use qData for commercial purposes, but you may not remove, hide,
 * modify, or replace the qData logo, copyright notices, license notices,
 * or attribution information without a separate commercial license.
 *
 * White-label use, OEM distribution, rebranding, or presenting qData as
 * another product requires separate commercial authorization from
 * Jiangsu Qiantong Technology Co., Ltd.
 *
 * Business License: https://community.qdata.tech/business/policy.html
 * See the LICENSE file in the project root for full license information.
 */

package tech.qiantong.qdata.quality.utils.qualityDB.dialect;


import tech.qiantong.qdata.quality.dal.dataobject.quality.QualityRuleEntity;
import tech.qiantong.qdata.quality.utils.qualityDB.ComponentItem;

public class MySqlQuality implements ComponentItem {

    @Override
    public String fragDateFormat(QualityRuleEntity rule) {
        String column = rule.getRuleColumn();
        Object configured = rule.getConfig().get("dateFormat");
        String format = configured == null ? String.valueOf(rule.getConfig().get("format")) : configured.toString();
        String regex;
        String mysqlFormat;
        if ("yyyy-MM-dd HH:mm:ss".equals(format)) {
            regex = "^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$";
            mysqlFormat = "%Y-%m-%d %H:%i:%s";
        } else if ("yyyy-MM-dd".equals(format)) {
            regex = "^[0-9]{4}-[0-9]{2}-[0-9]{2}$";
            mysqlFormat = "%Y-%m-%d";
        } else {
            throw new IllegalArgumentException("Unsupported date format: " + format);
        }
        String value = "CAST(" + column + " AS CHAR)";
        return "(" + value + " REGEXP '" + regex + "' AND STR_TO_DATE(" + value + ", '" + mysqlFormat + "') IS NOT NULL)";
    }

    @Override
    public String fragCharacter(QualityRuleEntity rule) {
        String column = rule.getRuleColumn();
        String regex = (String) rule.getConfig().get("regex");
        String escapedRegex = regex == null ? "" : regex.replace("'", "''");
        return String.format(
                "REGEXP_LIKE(CAST(%s AS CHAR CHARACTER SET utf8mb4), '%s', 'c')",
                column,
                escapedRegex
        );
    }

}
