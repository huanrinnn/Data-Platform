import requestQuality from '@/utils/requestQuality'

export function pageErrorData(data) {
  return requestQuality({ url: '/quality/qualityTaskExecutor/pageErrorData', method: 'post', data })
}

export function updateErrorData(data) {
  return requestQuality({ url: '/quality/qualityTaskExecutor/updateErrorData', method: 'post', data })
}

export function generateValidationValidDataSql(data) {
  return requestQuality({ url: '/quality/qualityTaskExecutor/generateValidationValidDataSql', method: 'post', data })
}

export function generateValidationErrorDataSql(data) {
  return requestQuality({ url: '/quality/qualityTaskExecutor/generateValidationErrorDataSql', method: 'post', data })
}

export function runExecuteTask(id) {
  return requestQuality({ url: `/quality/qualityTaskExecutor/runExecuteTask/${id}`, method: 'put' })
}

export function generateDataCheck(data) {
  return requestQuality({ url: '/quality/qualityTaskExecutor/generateDataCheck', method: 'post', data })
}

export function test2() {
  return requestQuality({ url: '/test/test2', method: 'post' })
}

export function test3() {
  return requestQuality({ url: '/test/test3', method: 'post' })
}

