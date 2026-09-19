<template>
  <div class="workspace-home">
    <section class="welcome-row">
      <div>
        <p class="eyebrow">WEDNESDAY, SEPTEMBER 16, 2026</p>
        <h1>你好，{{ displayName }}</h1>
        <p class="welcome-copy">今天的工作从这里开始。查看平台状态，继续处理你的数据任务。</p>
      </div>
      <div class="welcome-actions">
        <el-button class="secondary-action" :icon="Document" @click="go('/dpp/task/developTask')">查看任务</el-button>
        <el-button type="primary" :icon="Connection" @click="go('/da/datasource')">接入数据源</el-button>
      </div>
    </section>

    <section class="signal-grid">
      <article v-for="signal in signals" :key="signal.label" class="signal-card" :class="`tone-${signal.tone}`">
        <div class="signal-head">
          <span>{{ signal.label }}</span>
          <el-icon><component :is="signal.icon" /></el-icon>
        </div>
        <strong>{{ signal.value }}</strong>
        <div class="signal-foot">
          <span>{{ signal.detail }}</span>
          <span class="signal-change" :class="{ positive: signal.positive }">{{ signal.change }}</span>
        </div>
      </article>
    </section>

    <section class="content-grid">
      <div class="main-column">
        <div class="section-heading">
          <div>
            <p class="eyebrow">WORKSPACES</p>
            <h2>从工作区继续</h2>
          </div>
          <button class="text-button" type="button" @click="go('/da/asset')">查看全部 <span>→</span></button>
        </div>

        <div class="module-grid">
          <button v-for="module in modules" :key="module.title" class="module-card" type="button" @click="go(module.path)">
            <span class="module-index">{{ module.index }}</span>
            <span class="module-icon" :class="`module-${module.tone}`">
              <el-icon><component :is="module.icon" /></el-icon>
            </span>
            <strong>{{ module.title }}</strong>
            <span class="module-description">{{ module.description }}</span>
            <span class="module-link">进入工作区 <b>↗</b></span>
          </button>
        </div>

        <div class="section-heading activity-heading">
          <div>
            <p class="eyebrow">RECENT ACTIVITY</p>
            <h2>最近动态</h2>
          </div>
          <button class="text-button" type="button" @click="go('/monitor/operlog')">操作日志 <span>→</span></button>
        </div>

        <div class="activity-list">
          <div v-for="item in activities" :key="item.title" class="activity-item">
            <span class="activity-marker" :class="`marker-${item.tone}`"></span>
            <div class="activity-copy">
              <strong>{{ item.title }}</strong>
              <span>{{ item.description }}</span>
            </div>
            <time>{{ item.time }}</time>
          </div>
        </div>
      </div>

      <aside class="side-column">
        <section class="health-panel">
          <div class="section-heading compact">
            <div>
              <p class="eyebrow">PLATFORM HEALTH</p>
              <h2>平台运行状态</h2>
            </div>
            <span class="live-indicator"><i></i>正常</span>
          </div>
          <div class="health-score">
            <strong>98.6</strong>
            <span>/ 100</span>
          </div>
          <div class="health-bar"><i></i></div>
          <div class="health-meta">
            <span>服务可用性</span>
            <strong>99.98%</strong>
          </div>
          <div class="health-meta">
            <span>近 24 小时任务成功率</span>
            <strong>96.4%</strong>
          </div>
          <button class="panel-link" type="button" @click="go('/monitor/server')">查看监控详情 <span>↗</span></button>
        </section>

        <section class="shortcut-panel">
          <div class="section-heading compact">
            <div>
              <p class="eyebrow">SHORTCUTS</p>
              <h2>常用入口</h2>
            </div>
          </div>
          <button v-for="shortcut in shortcuts" :key="shortcut.title" class="shortcut-item" type="button" @click="go(shortcut.path)">
            <el-icon><component :is="shortcut.icon" /></el-icon>
            <span>{{ shortcut.title }}</span>
            <b>→</b>
          </button>
        </section>
      </aside>
    </section>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import useUserStore from '@/store/system/user'
import {
  Coin,
  Connection,
  DataAnalysis,
  Document,
  Promotion,
  Switch,
  TrendCharts
} from '@element-plus/icons-vue'

const router = useRouter()
const userStore = useUserStore()
const displayName = computed(() => userStore.nickName || userStore.name || '数据管理员')

const signals = [
  { label: '数据资产', value: '1,284', detail: '较上月', change: '+12.8%', positive: true, tone: 'blue', icon: Coin },
  { label: '活跃数据源', value: '36', detail: '已连接', change: '+4', positive: true, tone: 'green', icon: Connection },
  { label: '运行中任务', value: '18', detail: '今日完成', change: '94.2%', positive: true, tone: 'orange', icon: Switch },
  { label: 'API 服务', value: '72', detail: '对外服务', change: '3 待发布', positive: false, tone: 'violet', icon: Promotion }
]

const modules = [
  { index: '01', title: '数据资产', description: '统一查看、盘点和管理全域数据资产。', path: '/da/asset', tone: 'blue', icon: Coin },
  { index: '02', title: '数据接入', description: '配置数据源与跨系统的数据连接。', path: '/da/datasource', tone: 'green', icon: Connection },
  { index: '03', title: '任务开发', description: '编排开发任务，跟踪执行与发布状态。', path: '/dpp/task/developTask', tone: 'orange', icon: TrendCharts },
  { index: '04', title: '集成中心', description: '管理同步链路、调度计划和运行日志。', path: '/dpp/task/integratioTask', tone: 'violet', icon: Switch },
  { index: '05', title: 'API 服务', description: '设计、发布和维护数据服务接口。', path: '/ds/api', tone: 'blue', icon: Promotion },
  { index: '06', title: '治理规则', description: '沉淀标准、质量规则与治理动作。', path: '/dp/dataElem', tone: 'green', icon: DataAnalysis }
]

const activities = [
  { title: '客户主题域同步任务已完成', description: '集成中心 · 运行成功 · 处理 18,420 条记录', time: '10 分钟前', tone: 'green' },
  { title: '新增数据源“营销数仓”', description: '数据接入 · MySQL · 连接测试通过', time: '42 分钟前', tone: 'blue' },
  { title: 'API「用户画像查询」已发布', description: 'API 服务 · 生产环境 · v2.3.1', time: '昨天 18:36', tone: 'orange' }
]

const shortcuts = [
  { title: '创建开发任务', path: '/dpp/task/developTask', icon: TrendCharts },
  { title: '管理数据源', path: '/da/datasource', icon: Connection },
  { title: '发布 API 服务', path: '/ds/api', icon: Promotion },
  { title: '查看数据资产', path: '/da/asset', icon: Document }
]

function go(path) {
  router.push(path)
}
</script>

<style scoped>
.workspace-home {
  max-width: 1480px;
  margin: 0 auto;
}

.welcome-row,
.section-heading,
.signal-head,
.signal-foot,
.health-meta,
.module-link,
.activity-item,
.shortcut-item {
  display: flex;
  align-items: center;
}

.welcome-row {
  justify-content: space-between;
  gap: 30px;
  margin-bottom: 27px;
}

.eyebrow {
  margin: 0 0 8px;
  color: #91a0ad;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.14em;
}

h1,
h2,
p {
  margin-top: 0;
}

h1 {
  margin-bottom: 8px;
  color: #1b2732;
  font-size: 30px;
  line-height: 1.15;
}

.welcome-copy {
  margin-bottom: 0;
  color: #7c8995;
  font-size: 13px;
}

.welcome-actions {
  display: flex;
  gap: 10px;
}

.welcome-actions :deep(.el-button) {
  height: 38px;
  border-radius: 5px;
  font-size: 12px;
}

.secondary-action {
  border-color: #dbe2e8;
  background: #fff;
  color: #53616d;
}

.signal-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 12px;
  margin-bottom: 38px;
}

.signal-card {
  min-height: 128px;
  padding: 18px 19px 15px;
  border: 1px solid #e2e8ed;
  border-top: 3px solid var(--tone);
  background: #fff;
}

.tone-blue { --tone: #3972f6; }
.tone-green { --tone: #35b47a; }
.tone-orange { --tone: #ee9a43; }
.tone-violet { --tone: #8f73d6; }

.signal-head {
  justify-content: space-between;
  color: #7e8b97;
  font-size: 12px;
}

.signal-head .el-icon {
  color: var(--tone);
  font-size: 18px;
}

.signal-card > strong {
  display: block;
  margin: 12px 0 11px;
  color: #1a2732;
  font-size: 29px;
  line-height: 1;
}

.signal-foot {
  justify-content: space-between;
  color: #a0abb3;
  font-size: 11px;
}

.signal-change {
  color: #e18d4f;
}

.signal-change.positive {
  color: #28a86e;
}

.content-grid {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 325px;
  gap: 30px;
}

.section-heading {
  justify-content: space-between;
  margin-bottom: 16px;
}

.section-heading h2 {
  margin-bottom: 0;
  color: #25323d;
  font-size: 19px;
}

.text-button,
.panel-link {
  border: 0;
  background: transparent;
  color: #4166d9;
  font: inherit;
  font-size: 12px;
  cursor: pointer;
}

.text-button span,
.panel-link span {
  margin-left: 6px;
  font-size: 16px;
}

.module-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 10px;
}

.module-card {
  position: relative;
  display: flex;
  min-height: 170px;
  flex-direction: column;
  align-items: flex-start;
  padding: 18px;
  overflow: hidden;
  border: 1px solid #e2e8ed;
  background: #fff;
  color: #1d2a34;
  text-align: left;
  cursor: pointer;
  transition: border-color 150ms ease, transform 150ms ease;
}

.module-card:hover {
  border-color: #9ab3f8;
  transform: translateY(-2px);
}

.module-index {
  position: absolute;
  top: 13px;
  right: 16px;
  color: #c0cad2;
  font-size: 11px;
}

.module-icon {
  display: grid;
  width: 35px;
  height: 35px;
  margin-bottom: 16px;
  place-items: center;
  border-radius: 7px;
  font-size: 18px;
}

.module-blue { background: #e5edff; color: #3972f6; }
.module-green { background: #e1f5eb; color: #27a56c; }
.module-orange { background: #fff0de; color: #e18b38; }
.module-violet { background: #eee9ff; color: #8268cf; }

.module-card strong {
  margin-bottom: 8px;
  font-size: 15px;
}

.module-description {
  min-height: 35px;
  color: #84919c;
  font-size: 11px;
  line-height: 1.6;
}

.module-link {
  gap: 5px;
  margin-top: auto;
  color: #5674d2;
  font-size: 11px;
}

.module-link b {
  font-size: 15px;
  font-weight: 400;
}

.activity-heading {
  margin-top: 38px;
}

.activity-list {
  border-top: 1px solid #dfe5e9;
}

.activity-item {
  gap: 12px;
  min-height: 67px;
  border-bottom: 1px solid #e6ebee;
}

.activity-marker {
  width: 8px;
  height: 8px;
  margin-left: 3px;
  border-radius: 50%;
}

.marker-green { background: #35b47a; }
.marker-blue { background: #3972f6; }
.marker-orange { background: #ee9a43; }

.activity-copy {
  display: grid;
  flex: 1;
  gap: 5px;
}

.activity-copy strong {
  color: #34414c;
  font-size: 12px;
}

.activity-copy span,
.activity-item time {
  color: #9aa6af;
  font-size: 11px;
}

.activity-item time {
  align-self: flex-start;
  margin-top: 21px;
  white-space: nowrap;
}

.side-column {
  display: grid;
  align-content: start;
  gap: 12px;
}

.health-panel,
.shortcut-panel {
  padding: 20px;
  border: 1px solid #e2e8ed;
  background: #fff;
}

.section-heading.compact {
  margin-bottom: 24px;
}

.section-heading.compact h2 {
  font-size: 16px;
}

.live-indicator {
  color: #2ba871;
  font-size: 11px;
}

.live-indicator i {
  display: inline-block;
  width: 7px;
  height: 7px;
  margin-right: 5px;
  border-radius: 50%;
  background: #35b47a;
}

.health-score {
  display: flex;
  align-items: baseline;
  gap: 4px;
}

.health-score strong {
  color: #26343e;
  font-size: 39px;
}

.health-score span {
  color: #a6b0b8;
  font-size: 12px;
}

.health-bar {
  height: 6px;
  margin: 13px 0 18px;
  overflow: hidden;
  border-radius: 5px;
  background: #e6f2eb;
}

.health-bar i {
  display: block;
  width: 98.6%;
  height: 100%;
  border-radius: inherit;
  background: #38b67c;
}

.health-meta {
  justify-content: space-between;
  padding: 10px 0;
  border-top: 1px solid #edf0f2;
  color: #87949e;
  font-size: 11px;
}

.health-meta strong {
  color: #394853;
  font-size: 12px;
}

.panel-link {
  margin-top: 13px;
  padding: 0;
}

.shortcut-panel {
  padding-bottom: 9px;
}

.shortcut-item {
  gap: 10px;
  width: 100%;
  min-height: 43px;
  padding: 0;
  border: 0;
  border-top: 1px solid #edf0f2;
  background: transparent;
  color: #54636f;
  font: inherit;
  font-size: 12px;
  text-align: left;
  cursor: pointer;
}

.shortcut-item .el-icon {
  color: #5674d2;
  font-size: 16px;
}

.shortcut-item b {
  margin-left: auto;
  color: #9aa6af;
  font-size: 16px;
  font-weight: 400;
}

@media (max-width: 1100px) {
  .content-grid {
    grid-template-columns: 1fr;
  }

  .side-column {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 780px) {
  .signal-grid,
  .module-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .welcome-row {
    align-items: flex-start;
    flex-direction: column;
  }
}

@media (max-width: 560px) {
  .signal-grid,
  .module-grid,
  .side-column {
    grid-template-columns: 1fr;
  }

  h1 {
    font-size: 25px;
  }
}
</style>
