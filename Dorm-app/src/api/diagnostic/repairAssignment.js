import request from '@/utils/request'

// 诊断派单状态
export function diagnoseAssignment(assignmentId) {
  return request({
    url: `/diagnostic/repair-assignment/diagnose/${assignmentId}`,
    method: 'get'
  })
}

// 测试接受派单
export function testAcceptAssignment(assignmentId) {
  return request({
    url: `/diagnostic/repair-assignment/test-accept/${assignmentId}`,
    method: 'post'
  })
}

// 获取维修人员的所有派单
export function getRepairerAssignments() {
  return request({
    url: '/diagnostic/repair-assignment/repairer-assignments',
    method: 'get'
  })
}

// 强制刷新派单状态
export function forceRefreshAssignment(assignmentId) {
  return request({
    url: `/diagnostic/repair-assignment/force-refresh/${assignmentId}`,
    method: 'post'
  })
}
