<template>
  <el-form ref="formRef" :model="form" :disabled="falg">
    <div class="rule-lines">
      <div v-for="(cond, index) in form.conditions" :key="index" class="rule-line">
        <el-select v-model="cond.leftField" placeholder="左侧字段" class="rule-field">
          <el-option
            v-for="col in normalizedColumns"
            :key="col.columnName"
            :label="col.columnName"
            :value="col.columnName"
          />
        </el-select>
        <el-select v-model="cond.operator" placeholder="比较" class="rule-operator">
          <el-option label="=" value="=" />
          <el-option label="!=" value="!=" />
          <el-option label="<" value="<" />
          <el-option label="<=" value="<=" />
          <el-option label=">" value=">" />
          <el-option label=">=" value=">=" />
        </el-select>
        <el-select v-model="cond.rightField" placeholder="右侧字段" class="rule-field">
          <el-option
            v-for="col in normalizedColumns"
            :key="col.columnName"
            :label="col.columnName"
            :value="col.columnName"
          />
        </el-select>
        <el-button
          v-if="!falg"
          icon="Delete"
          type="danger"
          circle
          :disabled="form.conditions.length === 1"
          @click="removeCondition(index)"
        />
      </div>
      <el-button v-if="!falg" icon="Plus" type="primary" circle @click="addCondition" />
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
  conditions: props.form?.conditions?.length
    ? JSON.parse(JSON.stringify(props.form.conditions))
    : [{ leftField: "", operator: "<=", rightField: "" }],
  ignoreNullValue: props.form?.ignoreNullValue ?? "1",
});

const normalizedColumns = computed(() => props.columnList || []);

function addCondition() {
  form.conditions.push({ leftField: "", operator: "<=", rightField: "" });
}

function removeCondition(index) {
  if (form.conditions.length > 1) {
    form.conditions.splice(index, 1);
  }
}

function validate() {
  return new Promise((resolve) => {
    for (let i = 0; i < form.conditions.length; i++) {
      const cond = form.conditions[i];
      if (!cond.leftField || !cond.operator || !cond.rightField) {
        ElMessage.warning(`第 ${i + 1} 组字段比较条件不完整`);
        resolve({ valid: false });
        return;
      }
    }
    const fieldNames = new Set();
    form.conditions.forEach((cond) => {
      fieldNames.add(cond.leftField);
      fieldNames.add(cond.rightField);
    });
    resolve({
      valid: true,
      data: {
        conditions: JSON.parse(JSON.stringify(form.conditions)),
        ignoreNullValue: form.ignoreNullValue,
        evaColumn: Array.from(fieldNames),
      },
    });
  });
}

defineExpose({ validate });
</script>

<style scoped>
.rule-lines {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.rule-line {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}
.rule-field {
  width: 160px;
}
.rule-operator {
  width: 80px;
}
</style>
