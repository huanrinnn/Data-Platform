<template>
  <div class="shell-layout">
    <aside class="shell-sidebar" :class="{ 'is-collapsed': collapsed }">
      <div class="brand">
        <div class="brand-mark">q</div>
        <div v-if="!collapsed" class="brand-copy">
          <strong>qData</strong>
          <span>数据工作台</span>
        </div>
      </div>

      <div class="workspace-switcher" @click="go('/index')">
        <span class="workspace-dot"></span>
        <span v-if="!collapsed" class="workspace-name">默认工作区</span>
        <el-icon v-if="!collapsed"><ArrowDown /></el-icon>
      </div>

      <nav class="shell-nav">
        <div v-if="!collapsed" class="nav-label">全部模块</div>
        <div class="dynamic-nav">
          <el-menu
            :default-active="route.path"
            :collapse="collapsed"
            :collapse-transition="false"
            background-color="transparent"
            text-color="#aeb9c4"
            active-text-color="#ffffff"
          >
            <ShellNavNode
              v-for="item in visibleRoutes"
              :key="routeKey(item)"
              :route="item"
              :collapsed="collapsed"
            />
          </el-menu>
        </div>
      </nav>

      <div class="sidebar-bottom">
        <button class="collapse-button" type="button" @click="collapsed = !collapsed">
          <el-icon><component :is="collapsed ? Expand : Fold" /></el-icon>
          <span v-if="!collapsed">收起导航</span>
        </button>
      </div>
    </aside>

    <section class="shell-workspace">
      <header class="shell-header">
        <div class="header-context">
          <span class="context-kicker">DATA OPERATIONS</span>
          <strong>{{ pageTitle }}</strong>
        </div>
        <div class="header-actions">
          <label class="global-search">
            <el-icon><Search /></el-icon>
            <input v-model="searchText" placeholder="搜索模块、任务或数据资产" @keyup.enter="runSearch" />
            <kbd>⌘ K</kbd>
          </label>
          <button class="header-icon" type="button" title="帮助">
            <el-icon><Help /></el-icon>
          </button>
          <button class="header-icon notification-button" type="button" title="通知">
            <el-icon><Bell /></el-icon>
            <i></i>
          </button>
          <el-dropdown trigger="click">
            <button class="profile-button" type="button">
              <span class="avatar">{{ initials }}</span>
              <span class="profile-name">{{ displayName }}</span>
              <el-icon><ArrowDown /></el-icon>
            </button>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="go('/user/profile')">个人资料</el-dropdown-item>
                <el-dropdown-item divided @click="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </header>

      <main class="shell-main">
        <router-view />
      </main>
    </section>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import {
  ArrowDown,
  Bell,
  Help,
  Expand,
  Fold,
  Search
} from '@element-plus/icons-vue'
import useUserStore from '@/store/system/user'
import usePermissionStore from '@/store/system/permission'
import ShellNavNode from './components/ShellNavNode.vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const permissionStore = usePermissionStore()
const collapsed = ref(false)
const searchText = ref('')

const visibleRoutes = computed(() => {
  return permissionStore.sidebarRouters
})

const displayName = computed(() => userStore.nickName || userStore.name || '数据管理员')
const initials = computed(() => displayName.value.slice(0, 1).toUpperCase())
const pageTitle = computed(() => {
  if (route.path === '/index' || route.path === '/') return '总览'
  return route.meta?.title || '工作区'
})

function go(path) {
  router.push(path)
}

function runSearch() {
  const query = searchText.value.trim()
  if (!query) return
  ElMessage.info(`正在查找“${query}”`)
}

async function logout() {
  await userStore.logOut()
  router.push('/login')
}

function routeKey(item) {
  return item.path || item.name || item.meta?.title
}
</script>

<style scoped>
.shell-layout {
  --shell-ink: #17202a;
  --shell-line: #e4e9ee;
  --shell-blue: #2d5bff;
  display: flex;
  min-height: 100vh;
  color: var(--shell-ink);
  background: #eef2f4;
}

.shell-sidebar {
  position: relative;
  display: flex;
  flex: 0 0 236px;
  flex-direction: column;
  min-height: 100vh;
  padding: 24px 14px 16px;
  background: #17202a;
  color: #dbe2e8;
  transition: flex-basis 180ms ease;
}

.shell-sidebar.is-collapsed {
  flex-basis: 76px;
}

.brand,
.workspace-switcher,
.nav-item,
.collapse-button,
.profile-button {
  display: flex;
  align-items: center;
}

.brand {
  gap: 11px;
  height: 42px;
  padding: 0 10px;
  color: #fff;
}

.brand-mark {
  display: grid;
  width: 32px;
  height: 32px;
  place-items: center;
  border-radius: 8px;
  background: #4c7dff;
  color: #fff;
  font-size: 22px;
  font-weight: 800;
}

.brand-copy {
  display: grid;
  line-height: 1.1;
}

.brand-copy strong {
  font-size: 17px;
}

.brand-copy span {
  margin-top: 4px;
  color: #8e9ba7;
  font-size: 11px;
}

.workspace-switcher {
  gap: 9px;
  height: 42px;
  margin: 26px 0 22px;
  padding: 0 12px;
  border: 1px solid #303c48;
  border-radius: 6px;
  cursor: pointer;
}

.workspace-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #57d68d;
  box-shadow: 0 0 0 4px rgba(87, 214, 141, 0.12);
}

.workspace-name {
  flex: 1;
  overflow: hidden;
  color: #f5f8fa;
  font-size: 13px;
  white-space: nowrap;
  text-overflow: ellipsis;
}

.shell-nav {
  flex: 1;
  overflow: auto;
}

.dynamic-nav :deep(.el-menu) {
  border-right: 0;
}

.dynamic-nav :deep(.el-sub-menu__title) {
  height: 40px;
  margin: 3px 0;
  padding: 0 12px !important;
  border-radius: 6px;
  color: #aeb9c4;
  font-size: 12px;
}

.dynamic-nav :deep(.el-sub-menu__title:hover) {
  background: #253441;
  color: #fff;
}

.dynamic-nav :deep(.el-sub-menu .el-menu) {
  margin-left: 18px;
  padding-left: 8px;
  border-left: 1px solid #33414e;
}

.dynamic-nav :deep(.el-menu--collapse .el-sub-menu__title) {
  justify-content: center;
  padding: 0 !important;
}

.nav-group {
  margin-bottom: 25px;
}

.nav-label {
  padding: 0 12px 8px;
  color: #758391;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

.nav-item,
.collapse-button {
  position: relative;
  gap: 11px;
  width: 100%;
  min-height: 40px;
  padding: 0 12px;
  border: 0;
  border-radius: 6px;
  background: transparent;
  color: #aeb9c4;
  font: inherit;
  font-size: 13px;
  text-decoration: none;
  cursor: pointer;
}

.nav-item + .nav-item {
  margin-top: 3px;
}

.nav-item .el-icon,
.collapse-button .el-icon {
  flex: 0 0 18px;
  font-size: 17px;
}

.nav-item:hover,
.nav-item.is-active,
.collapse-button:hover {
  background: #253441;
  color: #fff;
}

.nav-item.is-active::before {
  position: absolute;
  left: 0;
  width: 3px;
  height: 20px;
  border-radius: 0 3px 3px 0;
  background: #63a3ff;
  content: '';
}

.nav-badge {
  margin-left: auto;
  color: #62d49a;
  font-size: 9px;
  font-weight: 700;
}

.sidebar-bottom {
  padding-top: 14px;
  border-top: 1px solid #303c48;
}

.collapse-button {
  margin-top: 5px;
}

.shell-workspace {
  display: flex;
  flex: 1;
  min-width: 0;
  flex-direction: column;
}

.shell-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-height: 78px;
  padding: 0 34px;
  border-bottom: 1px solid var(--shell-line);
  background: #fff;
}

.header-context {
  display: grid;
  gap: 5px;
}

.context-kicker {
  color: #91a0ad;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.14em;
}

.header-context strong {
  font-size: 20px;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.global-search {
  display: flex;
  align-items: center;
  gap: 8px;
  width: 265px;
  height: 36px;
  padding: 0 10px;
  border: 1px solid var(--shell-line);
  border-radius: 6px;
  color: #82909d;
}

.global-search input {
  width: 100%;
  border: 0;
  outline: 0;
  color: var(--shell-ink);
  font: inherit;
  font-size: 12px;
}

.global-search input::placeholder {
  color: #aab4bd;
}

kbd {
  padding: 2px 5px;
  border: 1px solid #dbe1e6;
  border-radius: 3px;
  color: #9ca8b2;
  font-size: 10px;
  white-space: nowrap;
}

.header-icon {
  display: grid;
  width: 34px;
  height: 34px;
  place-items: center;
  border: 0;
  background: transparent;
  color: #71808c;
  cursor: pointer;
}

.header-icon:hover {
  color: var(--shell-blue);
}

.notification-button {
  position: relative;
}

.notification-button i {
  position: absolute;
  top: 6px;
  right: 6px;
  width: 5px;
  height: 5px;
  border: 1px solid #fff;
  border-radius: 50%;
  background: #f08a61;
}

.profile-button {
  gap: 8px;
  border: 0;
  background: transparent;
  color: var(--shell-ink);
  cursor: pointer;
}

.avatar {
  display: grid;
  width: 30px;
  height: 30px;
  place-items: center;
  border-radius: 50%;
  background: #dce7ff;
  color: #315ce0;
  font-size: 12px;
  font-weight: 700;
}

.profile-name {
  max-width: 100px;
  overflow: hidden;
  font-size: 12px;
  white-space: nowrap;
  text-overflow: ellipsis;
}

.shell-main {
  flex: 1;
  min-width: 0;
  overflow: auto;
  padding: 28px 34px 42px;
}

@media (max-width: 900px) {
  .shell-sidebar {
    flex-basis: 76px;
  }

  .shell-sidebar .brand-copy,
  .shell-sidebar .workspace-name,
  .shell-sidebar .workspace-switcher .el-icon,
  .shell-sidebar .nav-label,
  .shell-sidebar .nav-item span,
  .shell-sidebar .collapse-button span {
    display: none;
  }

  .global-search {
    width: 180px;
  }

  .shell-header {
    padding: 0 20px;
  }

  .shell-main {
    padding: 22px 20px 34px;
  }
}

@media (max-width: 640px) {
  .header-context {
    display: none;
  }

  .header-actions {
    width: 100%;
  }

  .global-search {
    flex: 1;
    width: auto;
  }

  .profile-name,
  kbd {
    display: none;
  }
}
</style>
