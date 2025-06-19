import request from '@/utils/request'

// 全面诊断智能派单系统状态
export function fullDiagnosis() {
  return request({
    url: '/diagnostic/smart-dispatch/full-diagnosis',
    method: 'get'
  })
}

// 手动触发智能派单
export function manualTrigger(requestId) {
  return request({
    url: `/diagnostic/smart-dispatch/manual-trigger/${requestId}`,
    method: 'post'
  })
}

// 测试异步派单消息发送
export function testAsyncDispatch(requestId) {
  return request({
    url: `/diagnostic/smart-dispatch/test-async-dispatch/${requestId}`,
    method: 'post'
  })
}
