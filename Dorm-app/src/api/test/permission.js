import request from '@/utils/request'

// 检查当前用户角色
export function checkRole() {
  return request({
    url: '/test/repair-permission/check-role',
    method: 'get'
  })
}

// 测试报修工单列表查询权限
export function testList(testUserId) {
  return request({
    url: '/test/repair-permission/test-list',
    method: 'get',
    params: testUserId ? { testUserId } : {}
  })
}

// 测试工单详情查询权限
export function testDetail(requestId) {
  return request({
    url: `/test/repair-permission/test-detail/${requestId}`,
    method: 'get'
  })
}

// 创建测试工单
export function createTestRequest(data) {
  return request({
    url: '/test/repair-permission/create-test-request',
    method: 'post',
    data: data
  })
}

// 调用实际的报修工单列表接口
export function getRepairRequestList(query) {
  return request({
    url: '/dorm/request/list',
    method: 'get',
    params: query
  })
}

// 调用实际的报修工单详情接口
export function getRepairRequestDetail(requestId) {
  return request({
    url: `/dorm/request/${requestId}`,
    method: 'get'
  })
}
