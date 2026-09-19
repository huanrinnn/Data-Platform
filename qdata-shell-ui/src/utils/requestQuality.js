import axios from 'axios'
import { ElMessage } from 'element-plus'
import { getToken } from '@/utils/auth'
import errorCode from '@/utils/errorCode'
import { shellPath } from '@/utils/storage'
import { getStoredLang } from '@/store/system/locale'

// The quality service has its own error boundary: a quality outage must not
// clear the main application's session or trigger its global 401 dialog.
const service = axios.create({
  baseURL: import.meta.env.VITE_APP_BASE_QUALITY,
  timeout: 600000,
  headers: { 'Content-Type': 'application/json;charset=utf-8' }
})

service.interceptors.request.use((config) => {
  const isToken = config.headers?.isToken === false
  if (getToken() && !isToken) {
    config.headers.Authorization = `Bearer ${getToken()}`
  }
  config.headers['accept-language'] = getStoredLang()
  return config
})

service.interceptors.response.use(
  (response) => {
    if (response.config.responseType === 'blob' || response.config.responseType === 'arraybuffer') {
      return response.data
    }

    const payload = response.data || {}
    const code = payload.code ?? 200
    if (code === 200) {
      return payload
    }

    const message = errorCode[code] || payload.msg || errorCode.default
    if (code === 401) {
      ElMessage({ message: '质量服务认证已失效，请重新登录', type: 'warning' })
      window.location.href = shellPath('login')
    } else {
      ElMessage({ message, type: code >= 500 ? 'error' : 'warning' })
    }
    return Promise.reject(payload)
  },
  (error) => {
    const message = error.message === 'Network Error'
      ? '质量服务暂不可用'
      : error.message
    ElMessage({ message, type: 'error' })
    return Promise.reject(error)
  }
)

export default service
