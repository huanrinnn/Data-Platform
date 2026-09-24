<template>
  <div class="project-switcher">
    <el-form :inline="true" :model="userStore">
      <el-form-item :label="td('sys.dashboard.projectLabel')">
        <el-select
          v-model="userStore.projectId"
          class="project-select"
          :placeholder="td('sys.dashboard.projectPlaceholder')"
          @change="handleProjectChange"
        >
          <el-option
            v-for="item in projectOptions"
            :key="item.id"
            :label="item.name"
            :value="item.id"
          />
        </el-select>
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup>
import { ref } from "vue";
import useDefaultLang from "@/composables/useDefaultLang";
import useUserStore from "@/store/system/user";
import { currentUser } from "@/api/att/project/project";

const { td } = useDefaultLang();
const userStore = useUserStore();
const projectOptions = ref([]);

currentUser().then((response) => {
  projectOptions.value = response?.data || [];
  if (!userStore.projectId && projectOptions.value.length) {
    handleProjectChange(projectOptions.value[0].id);
    return;
  }

  const selectedProject = projectOptions.value.find(
    (project) => String(project.id) === String(userStore.projectId)
  );
  if (selectedProject) {
    userStore.projectCode = selectedProject.code;
  }
});

function handleProjectChange(projectId) {
  const selectedProject = projectOptions.value.find(
    (project) => String(project.id) === String(projectId)
  );
  if (!selectedProject) return;

  userStore.projectId = selectedProject.id;
  userStore.projectCode = selectedProject.code;
  localStorage.setItem("qdataProjectId", String(selectedProject.id));
}
</script>

<style scoped lang="scss">
.project-switcher {
  padding: 12px 15px 0;
  background-color: #fff;
}

.project-select {
  width: 220px;
}
</style>
