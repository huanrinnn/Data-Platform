/*
 * Copyright © 2025-present Jiangsu Qiantong Technology Co., Ltd.
 *
 * This file is part of qData Data Middle Platform (Open Source Edition).
 */

package tech.qiantong.qdata.module.dp.controller.admin.dataElem.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import tech.qiantong.qdata.common.annotation.Excel;

/**
 * Data element Excel import template.
 */
@Schema(description = "数据元 Excel 导入 VO")
@Data
public class DpDataElemImportVO {

    @Excel(name = "ID")
    @Schema(description = "ID；仅在勾选更新已有数据时填写")
    private Long id;

    @Excel(name = "编码")
    private String code;

    @Excel(name = "名称")
    private String name;

    @Excel(name = "英文名称")
    private String engName;

    @Excel(name = "类目编码")
    private String catCode;

    @Excel(name = "类型")
    private String type;

    @Excel(name = "责任人")
    private String personCharge;

    @Excel(name = "联系电话")
    private String contactNumber;

    @Excel(name = "字段类型")
    private String columnType;

    @Excel(name = "状态")
    private String status;

    @Excel(name = "描述")
    private String description;

    @Excel(name = "标准登记 ID")
    private Long documentId;
}
