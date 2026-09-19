<template>
  <template v-if="!isHidden">
    <el-sub-menu v-if="hasChildren" :index="nodeKey">
      <template #title>
        <el-icon><component :is="iconComponent" /></el-icon>
        <span>{{ nodeTitle }}</span>
      </template>
      <ShellNavNode
        v-for="child in visibleChildren"
        :key="childKey(child)"
        :route="child"
        :parent-path="resolvedPath"
        :collapsed="collapsed"
      />
    </el-sub-menu>
    <router-link v-else :to="resolvedPath" custom v-slot="{ navigate, isActive }">
      <a
        class="shell-route-item"
        :class="{ 'is-active': isActive || currentRoute.meta?.activeMenu === resolvedPath }"
        :href="resolvedPath"
        @click="navigate"
      >
        <el-icon><component :is="iconComponent" /></el-icon>
        <span>{{ nodeTitle }}</span>
      </a>
    </router-link>
  </template>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { moduleIcon, resolveModuleTitle } from '../moduleCatalog'

defineOptions({ name: 'ShellNavNode' })

const props = defineProps({
  route: { type: Object, required: true },
  parentPath: { type: String, default: '' },
  collapsed: { type: Boolean, default: false }
})

const currentRoute = useRoute()
const nodeTitle = computed(() => resolveModuleTitle(props.route, resolvedPath.value))
const visibleChildren = computed(() => (props.route.children || []).filter((item) => !item.hidden && item.meta?.hidden !== true))
const hasChildren = computed(() => visibleChildren.value.length > 0)
const resolvedPath = computed(() => {
  const value = props.route.path || ''
  if (/^https?:\/\//.test(value)) return value
  if (value.startsWith('/')) return value
  return `${props.parentPath.replace(/\/$/, '')}/${value}`.replace(/\/+/g, '/')
})
const nodeKey = computed(() => resolvedPath.value || nodeTitle.value)
const iconComponent = computed(() => moduleIcon(props.route.meta?.icon))
const isHidden = computed(() => props.route.hidden || props.route.meta?.hidden === true || !props.route.path)

function childKey(child) {
  return `${resolvedPath.value}/${child.path || child.name || child.meta?.title}`
}
</script>

<style scoped>
.shell-route-item {
  position: relative;
  display: flex;
  align-items: center;
  gap: 11px;
  min-height: 38px;
  margin: 3px 0;
  padding: 0 12px;
  border-radius: 6px;
  color: #aeb9c4;
  font-size: 12px;
  text-decoration: none;
  cursor: pointer;
}

.shell-route-item .el-icon {
  flex: 0 0 18px;
  font-size: 16px;
}

.shell-route-item:hover,
.shell-route-item.is-active {
  background: #253441;
  color: #fff;
}

.shell-route-item.is-active::before {
  position: absolute;
  left: 0;
  width: 3px;
  height: 19px;
  border-radius: 0 3px 3px 0;
  background: #63a3ff;
  content: '';
}

:deep(.el-sub-menu__title) {
  height: 38px;
  line-height: 38px;
}
</style>
