/*
 * Copyright 2025-present Jiangsu Qiantong Technology Co., Ltd.
 */

package tech.qiantong.qdata.quality.utils.quality.enums;

import org.springframework.stereotype.Component;
import tech.qiantong.qdata.quality.dal.dataobject.quality.QualityRuleEntity;
import tech.qiantong.qdata.quality.utils.quality.QualitySqlGenerator;
import tech.qiantong.qdata.quality.utils.quality.enums.CommonGenerator;
import tech.qiantong.qdata.quality.utils.qualityDB.ComponentItem;
import tech.qiantong.qdata.quality.utils.qualityDB.ComponentRegistry;

/**
 * Field non-null validation.
 */
@Component("NOT_NULL_VALIDATION")
public class NotNullValidationGenerator implements QualitySqlGenerator {

    @Override
    public String generateSql(QualityRuleEntity rule) {
        return CommonGenerator.generateSql(rule, rule.getRuleColumn() + " IS NULL");
    }

    @Override
    public String generateErrorSql(QualityRuleEntity rule) {
        return CommonGenerator.generateDataSql(rule, rule.getRuleColumn() + " IS NULL");
    }

    @Override
    public String generateValidDataSql(QualityRuleEntity rule, int limit, int offset) {
        ComponentItem componentItem = new ComponentRegistry()
                .getComponentItem(rule.getDaDatasourceById().getDatasourceType());
        return componentItem.addPagination(
                CommonGenerator.generateDataSql(rule, rule.getRuleColumn() + " IS NOT NULL"),
                limit,
                offset
        );
    }
}
