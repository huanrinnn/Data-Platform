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

package tech.qiantong.qdata.quality.dal.dataobject.quality;

import lombok.Data;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Data
public class ColumnCompare {

    private static final Set<String> OPERATORS = new HashSet<>(Arrays.asList("=", "!=", "<>", "<", "<=", ">", ">="));

    private String leftField;
    private String operator;
    private String rightField;

    public String toExpression() {
        validateOperator(operator);
        return String.format("%s %s %s", leftField, normalizeOperator(operator), rightField);
    }

    public String toExpressionIgnoreNullValue() {
        validateOperator(operator);
        String sqlOperator = normalizeOperator(operator);
        return String.format("(%s IS NULL OR %s IS NULL OR %s %s %s)", leftField, rightField, leftField, sqlOperator, rightField);
    }

    public static String toExpressions(List<ColumnCompare> compares, boolean ignoreNullValue) {
        if (ignoreNullValue) {
            return compares.stream().map(ColumnCompare::toExpressionIgnoreNullValue).collect(Collectors.joining(" AND "));
        }
        return compares.stream().map(ColumnCompare::toExpression).collect(Collectors.joining(" AND "));
    }

    public static String toExpressionsNeg(List<ColumnCompare> compares, boolean ignoreNullValue) {
        if (ignoreNullValue) {
            return compares.stream().map(it -> String.format("(NOT %s)", it.toExpression())).collect(Collectors.joining(" OR "));
        }
        return compares.stream().map(it -> String.format("(%s IS NULL OR %s IS NULL OR NOT %s)", it.getLeftField(), it.getRightField(), it.toExpression()))
                .collect(Collectors.joining(" OR "));
    }

    private static void validateOperator(String operator) {
        if (!OPERATORS.contains(operator)) {
            throw new IllegalArgumentException("operator is not supported: " + operator);
        }
    }

    private static String normalizeOperator(String operator) {
        return "!=".equals(operator) ? "<>" : operator;
    }

}
