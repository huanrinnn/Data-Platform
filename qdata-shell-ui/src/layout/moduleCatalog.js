import {
  Collection,
  Coin,
  Connection,
  DataAnalysis,
  Document,
  Grid,
  Monitor,
  Menu,
  Operation,
  Promotion,
  Setting,
  Switch,
  TrendCharts,
  User
} from '@element-plus/icons-vue'

// Shared labels for both the local fallback navigation and backend menu data.
// Backend menu records are allowed to omit meta.title in older installations.
export const moduleTitleMap = {
  '/index': '总览',
  '/system': '系统管理',
  '/system/user': '用户管理',
  '/system/role': '角色管理',
  '/system/dept': '部门管理',
  '/system/menu': '菜单管理',
  '/system/post': '岗位管理',
  '/system/dict': '字典管理',
  '/system/config': '参数设置',
  '/system/notice': '通知公告',
  '/sys/system/message': '消息中心',
  '/monitor': '系统监控',
  '/monitor/online': '在线用户',
  '/monitor/logininfor': '登录日志',
  '/monitor/operlog': '操作日志',
  '/monitor/job': '定时任务',
  '/monitor/server': '服务监控',
  '/tool': '系统工具',
  '/tool/gen': '代码生成',
  '/tool/swagger': '接口文档',
  '/da': '数据资产',
  '/da/asset': '资产地图',
  '/da/datasource': '数据源管理',
  '/da/assetApply': '资产申请',
  '/da/quality': '数据质量',
  '/da/quality/qualityTask': '质量任务',
  '/da/quality/qualityTaskLog': '质量执行日志',
  '/dpp': '数据研发',
  '/dpp/asset': '研发资产',
  '/dpp/datasource': '研发数据源',
  '/dpp/task/developTask': '开发任务',
  '/dpp/task/integratioTask': '集成任务',
  '/dpp/instance/developTask': '开发实例',
  '/dpp/instance/integratioTask': '集成实例',
  '/dpp/setting': '研发设置',
  '/ds': '数据服务',
  '/ds/api': 'API 服务',
  '/ds/apiCat': 'API 分类',
  '/ds/client': '应用管理',
  '/ds/apiLog': '调用日志',
  '/dg': '数据治理',
  '/dg/standard': '数据标准',
  '/dg/safety': '数据安全',
  '/dg/safety/dataCategory': '安全分类',
  '/dg/safety/desensitizationRules': '脱敏规则',
  '/dg/safety/whitelist': '脱敏白名单',
  '/dg/dataLevel': '数据分级',
  '/dp': '数据标准与模型',
  '/dp/dataElem': '数据元管理',
  '/dp/model': '逻辑模型',
  '/dp/materializedModel': '物化模型',
  '/dp/document': '标准文档',
  '/dm': '数据管理',
  '/dm/dataLayer': '数据层管理',
  '/dm/businessCategory': '业务域管理',
  '/dm/themeDomain': '主题域管理',
  '/dm/dataDomain': '数据域管理',
  '/mc': '元数据管理',
  '/mc/dataSource': '元数据源',
  '/mc/task': '采集任务',
  '/mc/instance': '采集实例',
  '/meta': '元数据资产',
  '/att': '标签与项目',
  '/att/project': '项目管理',
  '/att/tag': '标签管理',
  '/att/theme': '主题管理',
  '/att/rule': '治理规则',
  '/ai': '智能助手',
  '/ai/chat': '智能问答',
  '/ai/model': '模型管理',
  '/report': '数据报表',
  '/rp': '个人中心',
  '/example': '扩展示例'
}

const iconMap = {
  dashboard: DataAnalysis,
  home: DataAnalysis,
  guide: DataAnalysis,
  monitor: Monitor,
  server: Monitor,
  redis: Coin,
  db: Coin,
  system: Setting,
  tool: Setting,
  tools: Setting,
  setting: Setting,
  user: User,
  people: User,
  tree: User,
  data: DataAnalysis,
  quality: TrendCharts,
  asset: Coin,
  folder: Collection,
  collection: Collection,
  dict: Collection,
  connection: Connection,
  link: Connection,
  operation: Operation,
  job: Operation,
  build: Operation,
  code: Operation,
  form: Operation,
  chart: TrendCharts,
  log: Document,
  document: Document,
  message: Document,
  bug: Monitor,
  example: Grid,
  api: Promotion,
  switch: Switch,
  menu: Menu
}

const pathIconMap = {
  '/index': DataAnalysis,
  '/system': Setting,
  '/monitor': Monitor,
  '/tool': Operation,
  '/da': Coin,
  '/dpp': Connection,
  '/ds': Promotion,
  '/dg': Operation,
  '/dp': Document,
  '/dm': Collection,
  '/mc': Monitor,
  '/att': User,
  '/ai': TrendCharts
}

function normalizeIconKey(icon) {
  return String(icon || '')
    .trim()
    .replace(/^el-icon-/, '')
    .replace(/^s-/, '')
    .replace(/([a-z])([A-Z])/g, '$1-$2')
    .replace(/[^a-zA-Z0-9]+/g, '-')
    .replace(/^-|-$/g, '')
    .toLowerCase()
}

export const moduleIcon = (icon, fullPath = '') => {
  const normalizedIcon = normalizeIconKey(icon)
  const compactIcon = normalizedIcon.replace(/-/g, '')
  return iconMap[normalizedIcon] || iconMap[compactIcon] || pathIconMap[fullPath] || Menu
}

function catalogEntry(path, title, icon, children = []) {
  return { path, name: title, meta: { title, icon }, children }
}

const leaf = (path, title, icon = 'document') => ({ path, name: title, meta: { title, icon } })

export const fallbackModuleCatalog = [
  leaf('/index', '总览', 'dashboard'),
  catalogEntry('/system', '系统管理', 'system', [
    leaf('user', '用户管理', 'user'), leaf('role', '角色管理', 'user'), leaf('dept', '部门管理', 'system'),
    leaf('menu', '菜单管理', 'system'), leaf('post', '岗位管理', 'user'), leaf('dict', '字典管理', 'document'),
    leaf('config', '参数设置', 'system'), leaf('notice', '通知公告', 'document')
  ]),
  catalogEntry('/monitor', '系统监控', 'monitor', [
    leaf('online', '在线用户', 'user'), leaf('logininfor', '登录日志', 'document'), leaf('operlog', '操作日志', 'document'),
    leaf('job', '定时任务', 'operation'), leaf('server', '服务监控', 'monitor')
  ]),
  catalogEntry('/tool', '系统工具', 'operation', [
    leaf('gen', '代码生成', 'document'), leaf('swagger', '接口文档', 'document'),
    leaf('build', '表单构建', 'operation'), leaf('choose', '模板选择', 'document')
  ]),
  catalogEntry('/da', '数据资产', 'asset', [
    leaf('asset', '资产地图', 'asset'), leaf('datasource', '数据源管理', 'connection'), leaf('assetApply', '资产申请', 'document'),
      catalogEntry('quality', '数据质量', 'data', [leaf('qualityTask', '质量任务', 'operation'), leaf('qualityTaskLog', '质量执行日志', 'document')])
  ]),
  catalogEntry('/dpp', '数据研发', 'operation', [
    leaf('asset', '研发资产', 'asset'), leaf('datasource', '研发数据源', 'connection'),
    leaf('task/developTask', '开发任务', 'chart'), leaf('task/integratioTask', '集成任务', 'switch'),
    leaf('instance/developTask', '开发实例', 'monitor'), leaf('instance/integratioTask', '集成实例', 'monitor')
  ]),
  catalogEntry('/ds', '数据服务', 'api', [leaf('api', 'API 服务', 'api'), leaf('apiCat', 'API 分类', 'document'), leaf('client', '应用管理', 'user'), leaf('apiLog', '调用日志', 'document')]),
  catalogEntry('/dg', '数据治理', 'data', [leaf('standard', '数据标准', 'document'), leaf('safety', '数据安全', 'system'), leaf('dataLevel', '数据分级', 'document')]),
  catalogEntry('/dp', '数据标准与模型', 'document', [leaf('dataElem', '数据元管理'), leaf('model', '逻辑模型', 'chart'), leaf('materializedModel', '物化模型', 'database'), leaf('document', '标准文档')]),
  catalogEntry('/dm', '数据管理', 'collection', [leaf('dataLayer', '数据层管理'), leaf('businessCategory', '业务域管理'), leaf('themeDomain', '主题域管理'), leaf('dataDomain', '数据域管理')]),
  catalogEntry('/mc', '元数据管理', 'collection', [leaf('dataSource', '元数据源', 'connection'), leaf('task', '采集任务', 'operation'), leaf('instance', '采集实例', 'monitor')]),
  catalogEntry('/att', '标签与项目', 'collection', [leaf('project', '项目管理', 'document'), leaf('tag', '标签管理', 'collection'), leaf('theme', '主题管理', 'document'), leaf('rule', '治理规则', 'data')]),
  catalogEntry('/ai', '智能助手', 'chart', [leaf('chat', '智能问答', 'chart'), leaf('model', '模型管理', 'operation')])
]

// Pages that exist in the legacy shell but are commonly omitted from a
// reduced backend menu configuration. They remain available as navigation
// children while authorization still comes from the backend route tree.
const extraModulePages = {
  '/system': [
    leaf('messageTemplate', '消息模板', 'document'), leaf('content', '内容管理', 'document'),
    leaf('/auth/client', '应用授权', 'user')
  ],
  '/monitor': [leaf('cache', '缓存监控', 'monitor'), leaf('druid', 'Druid 监控', 'monitor')],
  '/tool': [leaf('build', '表单构建', 'operation'), leaf('choose', '模板选择', 'document')],
  '/da': [leaf('dataQuery', '数据查询', 'data'), leaf('security/sensitiveLevel', '敏感等级', 'system')],
  '/dpp': [leaf('setting/taskCat', '任务分类', 'document'), leaf('setting/dataDevCat', '开发分类', 'document'), leaf('setting/projectUserRel', '项目成员', 'user')],
  '/dg': [leaf('safety/dataCategory', '安全分类', 'document'), leaf('safety/desensitizationRules', '脱敏规则', 'system'), leaf('safety/whitelist', '脱敏白名单', 'document'), leaf('safety/desensWhitelist', '脱敏白名单配置', 'document'), leaf('safety/sensitiveList', '敏感数据清单', 'data')],
  '/dp': [leaf('document/national', '国家标准', 'document'), leaf('document/industry', '行业标准', 'document'), leaf('document/provincial', '地方标准', 'document'), leaf('document/group', '团体标准', 'document'), leaf('document/search', '标准检索', 'data')],
  '/mc': [leaf('task/structured', '结构化采集', 'operation'), leaf('instance/structured', '采集实例', 'monitor')],
  '/att': [leaf('cat/assetCat', '资产分类', 'document'), leaf('cat/dataElemCat', '数据元分类', 'document'), leaf('cat/qualityCat', '质量分类', 'document'), leaf('cat/modelCat', '模型分类', 'document'), leaf('cat/tagCat', '标签分类', 'document'), leaf('cat/documentCat', '文档分类', 'document')],
  '/meta': [leaf('released/structured/table', '已发布表元数据', 'document'), leaf('unreleased/structured/table', '未发布表元数据', 'document')]
}

for (const entry of fallbackModuleCatalog) {
  const additions = extraModulePages[entry.path]
  if (additions) entry.children.push(...additions)
}

const catalogByPath = new Map()
const indexCatalog = (items) => {
  items.forEach((item) => {
    catalogByPath.set(item.path, item)
    if (item.children) indexCatalog(item.children)
  })
}
indexCatalog(fallbackModuleCatalog)

export function resolveModuleTitle(route, fullPath) {
  const title = moduleTitleMap[fullPath] || route.meta?.title || route.name
  return title && !isGenericModuleTitle(title) ? title : ''
}

export function normalizeModuleRoutes(routes, parentPath = '') {
  return routes
    .flatMap((route) => {
      const currentPath = route.path?.startsWith('/')
        ? route.path
        : `${parentPath}/${route.path || ''}`.replace(/\/+/g, '/')
      const children = route.children ? normalizeModuleRoutes(route.children, currentPath) : []

      // The legacy route table uses an empty Layout wrapper for the home page.
      // Flatten that wrapper so it does not become an extra unnamed module.
      if (currentPath === '/' && children.length) return children
      if (route.hidden || route.meta?.hidden === true || currentPath === '/') return []

      return [{
        ...route,
        path: currentPath,
        meta: { ...(route.meta || {}), title: resolveModuleTitle(route, currentPath) },
        ...(children.length ? { children } : {})
      }]
    })
}

export function mergeModuleRoutes(routes) {
  const normalizedRoutes = normalizeModuleRoutes(routes)
  const mergeByPath = (items) => {
    const merged = []
    const routeByPath = new Map()
    items.forEach((route) => {
      const catalogRoute = catalogByPath.get(route.path)
      const children = mergeByPath(route.children || [])
      const mergedRoute = {
        ...route,
        meta: {
          ...(catalogRoute?.meta || {}),
          ...(route.meta || {}),
          title: resolveModuleTitle(route, route.path) || catalogRoute?.meta?.title || ''
        },
        ...(children.length ? { children } : {})
      }
      const existing = routeByPath.get(route.path)
      if (!existing) {
        routeByPath.set(route.path, mergedRoute)
        merged.push(mergedRoute)
        return
      }
      const existingChildren = existing.children || []
      const childByPath = new Map(existingChildren.map((child) => [child.path, child]))
      for (const child of mergedRoute.children || []) {
        if (!childByPath.has(child.path)) {
          existingChildren.push(child)
          childByPath.set(child.path, child)
        }
      }
      existing.children = existingChildren
      existing.meta = { ...existing.meta, ...mergedRoute.meta }
    })
    return merged.filter((route) => route.meta?.title)
  }

  return mergeByPath(normalizedRoutes)
}

const genericModuleTitles = new Set(['模块', '未命名模块', 'Layout', 'ParentView'])

function isGenericModuleTitle(title) {
  return genericModuleTitles.has(String(title).trim())
}
