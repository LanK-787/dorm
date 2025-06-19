import request from '@/utils/request'

// 获取当前维修人员的待处理工单列表
export function getPendingAssignments(query) {
  return request({
    url: '/app/repairer/assignments/pending',
    method: 'get',
    params: query
  })
}

// 获取当前维修人员的处理中工单列表
export function getProcessingAssignments(query) {
  return request({
    url: '/app/repairer/assignments/processing',
    method: 'get',
    params: query
  })
}

// 获取当前维修人员的已完成工单列表
export function getCompletedAssignments(query) {
  return request({
    url: '/app/repairer/assignments/completed',
    method: 'get',
    params: query
  })
}

// 获取当前维修人员的已拒绝工单列表
export function getRejectedAssignments(query) {
  return request({
    url: '/app/repairer/assignments/rejected',
    method: 'get',
    params: query
  })
}

// 获取当前维修人员的所有工单列表
export function getAllAssignments(query) {
  return request({
    url: '/app/repairer/assignments/all',
    method: 'get',
    params: query
  })
}

// 获取工单详情
export function getAssignmentDetail(assignmentId) {
  return request({
    url: `/app/repairer/assignments/${assignmentId}`,
    method: 'get'
  })
}

// 检查是否有未处理的工单（用于首页消息提醒）
export function getUnreadCount() {
  return request({
    url: '/app/repairer/assignments/unread-count',
    method: 'get'
  })
}

// 接受工单
export function acceptAssignment(assignmentId) {
  return request({
    url: `/app/repairer/assignments/${assignmentId}/accept`,
    method: 'post'
  })
}

// 拒绝工单
export function rejectAssignment(assignmentId, data) {
  return request({
    url: `/app/repairer/assignments/${assignmentId}/reject`,
    method: 'post',
    data: data
  })
}

// 完成维修
export function completeAssignment(assignmentId, data) {
  return request({
    url: `/app/repairer/assignments/${assignmentId}/complete`,
    method: 'post',
    data: data
  })
}
