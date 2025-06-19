import request from '@/utils/request'

// 快速测试智能派单
export function quickTest() {
  return request({
    url: '/quick-test/smart-dispatch/quick-test',
    method: 'post'
  })
}

// 检查系统基础状态
export function checkBasicStatus() {
  return request({
    url: '/quick-test/smart-dispatch/check-basic-status',
    method: 'get'
  })
}

// 创建测试维修人员
export function createTestRepairer(name, specialty) {
  return request({
    url: '/quick-test/smart-dispatch/create-test-repairer',
    method: 'post',
    params: { name, specialty }
  })
}

// 清理测试数据
export function cleanupTestData() {
  return request({
    url: '/quick-test/smart-dispatch/cleanup-test-data',
    method: 'post'
  })
}
