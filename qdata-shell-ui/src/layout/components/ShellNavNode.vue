<template>
  <template v-if="!isHidden">
    <el-sub-menu
      v-if="hasChildren"
      :index="nodeKey"
      :class="['shell-submenu', nodeDepthClass]"
    >
      <template #title>
        <svg-icon v-if="hasSvgIcon" :icon-class="route.meta.icon" class-name="shell-menu-svg-icon" />
        <el-icon v-else><component :is="iconComponent" /></el-icon>
        <span>{{ nodeTitle }}</span>
      </template>
      <ShellNavNode
        v-for="child in visibleChildren"
        :key="childKey(child)"
        :route="child"
        :parent-path="resolvedPath"
        :collapsed="collapsed"
        :level="level + 1"
      />
    </el-sub-menu>
    <router-link v-else :to="resolvedPath" custom v-slot="{ navigate, isActive }">
      <a
        class="shell-route-item"
        :class="[nodeDepthClass, { 'is-active': isActive || currentRoute.meta?.activeMenu === resolvedPath }]"
        :href="resolvedPath"
        @click="navigate"
      >
        <svg-icon v-if="hasSvgIcon" :icon-class="route.meta.icon" class-name="shell-menu-svg-icon" />
        <el-icon v-else><component :is="iconComponent" /></el-icon>
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
  collapsed: { type: Boolean, default: false },
  level: { type: Number, default: 0 }
})

const currentRoute = useRoute()
const svgIconFiles = import.meta.glob('@/assets/icons/svg/*.svg')
const svgIconNames = new Set(Object.keys(svgIconFiles).map((file) => file.split('/').pop().replace(/\.svg$/, '')))
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
const iconComponent = computed(() => moduleIcon(props.route.meta?.icon, resolvedPath.value))
const hasSvgIcon = computed(() => svgIconNames.has(props.route.meta?.icon))
const nodeDepthClass = computed(() => props.level === 0 ? 'is-root-node' : 'is-child-node')
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

.shell-route-item :deep(.shell-menu-svg-icon) {
  flex: 0 0 18px;
  width: 16px;
  height: 16px;
  fill: currentColor;
}

.shell-route-item.is-root-node {
  min-height: 40px;
  margin-top: 6px;
  color: #d8e1eb;
  font-size: 13px;
  font-weight: 600;
}

.shell-route-item.is-root-node .el-icon {
  color: #91b4ff;
  font-size: 17px;
}

.shell-route-item.is-root-node :deep(.shell-menu-svg-icon) {
  width: 18px;
  height: 18px;
  color: #91b4ff;
}

.shell-route-item.is-child-node {
  min-height: 35px;
  margin: 1px 0;
  padding-left: 10px;
  color: #9eacb9;
  font-size: 12px;
}

.shell-route-item.is-child-node .el-icon {
  color: #8293a3;
  font-size: 14px;
}

.shell-route-item.is-child-node :deep(.shell-menu-svg-icon) {
  width: 15px;
  height: 15px;
  color: #8293a3;
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

:deep(.shell-submenu.is-root-node > .el-sub-menu__title) {
  height: 42px;
  margin-top: 6px;
  color: #d8e1eb;
  font-size: 13px;
  font-weight: 600;
}

:deep(.shell-submenu.is-root-node > .el-sub-menu__title .el-icon) {
  color: #91b4ff;
  font-size: 17px;
}

:deep(.shell-submenu.is-root-node > .el-sub-menu__title .shell-menu-svg-icon) {
  width: 18px;
  height: 18px;
  margin-right: 8px;
  color: #91b4ff;
}

:deep(.shell-submenu.is-child-node > .el-sub-menu__title) {
  height: 35px;
  color: #aeb9c4;
  font-size: 12px;
}

:deep(.shell-submenu.is-child-node > .el-sub-menu__title .el-icon) {
  color: #8293a3;
  font-size: 14px;
}

:deep(.shell-submenu.is-child-node > .el-sub-menu__title .shell-menu-svg-icon) {
  width: 15px;
  height: 15px;
  margin-right: 8px;
  color: #8293a3;
}
</style>
