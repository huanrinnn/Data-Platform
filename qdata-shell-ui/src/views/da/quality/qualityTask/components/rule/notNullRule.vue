<!--
  Copyright 漏 2025-present Jiangsu Qiantong Technology Co., Ltd.
-->

<template>
  <el-form ref="formRef" :model="form" :disabled="falg">
    <el-alert
      :title="td('da.qualityTaskRules.ruleCommon.ignoreNullValue') + ' / ' + td('da.qualityTask.ruleSelectorMenu.sampleCheck')"
      type="info"
      :closable="false"
      show-icon
    />
    <div style="margin-top: 12px; color: #606266; line-height: 1.6">
      {{ td('da.qualityTask.ruleSelectorMenu.spotCheck') }}{{ td('common.button.confirm') }}可直接保存当前配置。
    </div>
  </el-form>
</template>

<script setup>
import { ref } from "vue";
import useDefaultLang from "@/composables/useDefaultLang";

const { td } = useDefaultLang();
defineProps({
  form: Object,
  falg: Boolean,
});

const formRef = ref(null);

function validate() {
  return Promise.resolve({ valid: true, data: {} });
}

defineExpose({ validate });
</script>
