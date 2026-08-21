package tech.qiantong.qdata.quality.utils.quality.enums;

import org.springframework.stereotype.Component;
import tech.qiantong.qdata.quality.dal.dataobject.quality.QualityRuleEntity;
import tech.qiantong.qdata.quality.utils.quality.QualitySqlGenerator;
import tech.qiantong.qdata.quality.utils.qualityDB.ComponentItem;
import tech.qiantong.qdata.quality.utils.qualityDB.ComponentRegistry;

/** Date and date-time format validation. */
@Component("DATE_FORMAT_VALIDATION")
public class DateFormatValidationGenerator implements QualitySqlGenerator {

    private ComponentItem component(QualityRuleEntity rule) {
        ComponentRegistry registry = new ComponentRegistry();
        return registry.getComponentItem(rule.getDaDatasourceById().getDatasourceType());
    }

    @Override
    public String generateSql(QualityRuleEntity rule) {
        return component(rule).generateDateFormatValidationSql(rule);
    }

    @Override
    public String generateErrorSql(QualityRuleEntity rule) {
        return component(rule).generateDateFormatValidationErrorSql(rule);
    }

    @Override
    public String generateValidDataSql(QualityRuleEntity rule, int limit, int offset) {
        return component(rule).generateDateFormatValidationValidDataSql(rule, limit, offset);
    }
}
