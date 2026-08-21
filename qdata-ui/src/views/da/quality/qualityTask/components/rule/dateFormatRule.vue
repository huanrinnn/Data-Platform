<!--
  Copyright © 2025-present Jiangsu Qiantong Technology Co., Ltd.

  This file is part of qData Data Middle Platform (Open Source Edition).
-->

<template>
  <el-form ref="formRef" :model="form" :disabled="falg">
    <el-row :gutter="20">
      <el-col :span="12">
        <el-form-item
          :label="td('da.qualityTaskRules.ruleCommon.dateFormat')"
          prop="dateFormat"
        >
          <el-select
            v-if="!falg"
            v-model="form.dateFormat"
            :placeholder="td('da.qualityTaskRules.ruleCommon.dateFormatPlaceholder')"
            style="width: 100%"
          >
            <el-option
              v-for="item in dateFormats"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
          <div v-else class="form-readonly">{{ form.dateFormat || "-" }}</div>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item
          :label="td('da.qualityTaskRules.ruleCommon.ignoreNullValue')"
          prop="ignoreNullValue"
        >
          <el-radio-group v-if="!falg" v-model="form.ignoreNullValue">
            <el-radio :value="'1'">{{ td('da.qualityTaskRules.ruleCommon.yes') }}</el-radio>
            <el-radio :value="'0'">{{ td('da.qualityTaskRules.ruleCommon.no') }}</el-radio>
          </el-radio-group>
          <div v-else class="form-readonly">
            {{
              form.ignoreNullValue === "1"
                ? td('da.qualityTaskRules.ruleCommon.yes')
                : form.ignoreNullValue === "0"
                ? td('da.qualityTaskRules.ruleCommon.no')
                : "-"
            }}
          </div>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script setup>
import { reactive, ref } from "vue";
import useDefaultLang from "@/composables/useDefaultLang";

const { td } = useDefaultLang();
const props = defineProps({
  form: Object,
  falg: Boolean,
});

const formRef = ref(null);
const form = reactive({
  dateFormat: props.form.dateFormat || "yyyy-MM-dd",
  ignoreNullValue: props.form.ignoreNullValue || "1",
});

const dateFormats = [
  { value: "yyyy-MM-dd", label: "yyyy-MM-dd" },
  { value: "yyyy-MM-dd HH:mm:ss", label: "yyyy-MM-dd HH:mm:ss" },
];

function validate() {
  return new Promise((resolve) => {
    formRef.value.validate((valid) => {
      resolve({
        valid,
        data: {
          dateFormat: form.dateFormat,
          format: form.dateFormat,
          ignoreNullValue: form.ignoreNullValue,
        },
      });
    });
  });
}

defineExpose({ validate });
</script>

<style scoped>
.form-readonly {
  min-height: 32px;
  line-height: 32px;
}
</style>
