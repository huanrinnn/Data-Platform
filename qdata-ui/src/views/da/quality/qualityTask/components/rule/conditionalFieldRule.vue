<template>
  <el-form ref="formRef" :model="form" :disabled="falg">
    <div class="rule-line">
      <span>当</span>
      <el-select v-model="form.when.field" placeholder="条件字段" class="rule-field">
        <el-option
          v-for="col in normalizedColumns"
          :key="col.columnName"
          :label="col.columnName"
          :value="col.columnName"
        />
      </el-select>
      <el-select v-model="form.when.operator" placeholder="条件" class="rule-operator">
        <el-option label="=" value="=" />
        <el-option label="!=" value="!=" />
        <el-option label="IN" value="IN" />
        <el-option label="NOT IN" value="NOT_IN" />
      </el-select>
      <el-input
        v-model="valueText"
        placeholder="值，多个用英文逗号分隔"
        class="rule-value"
      />
    </div>
    <div class="rule-line">
      <span>则</span>
      <el-select v-model="form.then.field" placeholder="校验字段" class="rule-field">
        <el-option
          v-for="col in normalizedColumns"
          :key="col.columnName"
          :label="col.columnName"
          :value="col.columnName"
        />
      </el-select>
      <el-select v-model="form.then.operator" placeholder="校验方式" class="rule-then">
        <el-option label="不能为空" value="IS_NOT_NULL" />
        <el-option label="必须为空" value="IS_NULL" />
      </el-select>
    </div>
  </el-form>
</template>

<script setup>
import { computed, reactive, ref } from "vue";

const props = defineProps({
  form: Object,
  falg: Boolean,
  columnList: Array,
});

const formRef = ref(null);
const form = reactive({
  when: {
    field: props.form?.when?.field || "",
    operator: props.form?.when?.operator || "=",
  },
  then: {
    field: props.form?.then?.field || "",
    operator: props.form?.then?.operator || "IS_NOT_NULL",
  },
});

const valueText = ref(
  props.form?.when?.values?.length
    ? props.form.when.values.join(",")
    : props.form?.when?.value || ""
);

const normalizedColumns = computed(() => props.columnList || []);

function splitValues() {
  return String(valueText.value || "")
    .split(",")
    .map((item) => item.trim())
    .filter(Boolean);
}

function validate() {
  return new Promise((resolve) => {
    const values = splitValues();
    if (!form.when.field || !form.when.operator || values.length === 0 || !form.then.field || !form.then.operator) {
      ElMessage.warning("条件字段校验配置不完整");
      resolve({ valid: false });
      return;
    }
    const when = {
      field: form.when.field,
      operator: form.when.operator,
    };
    if (form.when.operator === "IN" || form.when.operator === "NOT_IN") {
      when.values = values;
    } else {
      when.value = values[0];
    }

    resolve({
      valid: true,
      data: {
        when,
        then: { ...form.then },
        evaColumn: Array.from(new Set([form.when.field, form.then.field])),
      },
    });
  });
}

defineExpose({ validate });
</script>

<style scoped>
.rule-line {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
  margin-bottom: 12px;
}
.rule-field {
  width: 160px;
}
.rule-operator {
  width: 100px;
}
.rule-value {
  width: 240px;
}
.rule-then {
  width: 140px;
}
</style>
