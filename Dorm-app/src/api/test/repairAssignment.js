import request from '@/utils/request'

// 测试条件更新方法
export function testConditionalUpdate(assignmentId, newStatus, expectedStatus) {
  return request({
    url: '/test/repair-assignment/test-conditional-update',
    method: 'post',
    params: {
      assignmentId,
      newStatus,
      expectedStatus
    }
  })
}

// 获取派单当前状态
export function getAssignmentStatus(assignmentId) {
  return request({
    url: `/test/repair-assignment/get-status/${assignmentId}`,
    method: 'get'
  })
}

// 模拟完整的接受流程测试
export function simulateAccept(assignmentId) {
  return request({
    url: `/test/repair-assignment/simulate-accept/${assignmentId}`,
    method: 'post'
  })
}
