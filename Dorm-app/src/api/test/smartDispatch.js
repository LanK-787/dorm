import request from '@/utils/request'

// 创建测试报修工单并触发智能派单
export function createTestOrder(data) {
  return request({
    url: '/test/smart-dispatch/create-test-order',
    method: 'post',
    data: data
  })
}

// 手动触发智能派单
export function manualDispatch(requestId) {
  return request({
    url: `/test/smart-dispatch/manual-dispatch/${requestId}`,
    method: 'post'
  })
}

// 查询工单派单状态
export function getDispatchStatus(requestId) {
  return request({
    url: `/test/smart-dispatch/dispatch-status/${requestId}`,
    method: 'get'
  })
}
