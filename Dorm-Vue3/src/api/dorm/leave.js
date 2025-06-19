import request from '@/utils/request'

// 查询学生离校登记列表
export function listLeave(query) {
  return request({
    url: '/dorm/leave/list',
    method: 'get',
    params: query
  })
}

// 查询学生离校登记详细
export function getLeave(leaveId) {
  return request({
    url: '/dorm/leave/' + leaveId,
    method: 'get'
  })
}

// 新增学生离校登记
export function addLeave(data) {
  return request({
    url: '/dorm/leave',
    method: 'post',
    data: data
  })
}

// 修改学生离校登记
export function updateLeave(data) {
  return request({
    url: '/dorm/leave',
    method: 'put',
    data: data
  })
}

// 删除学生离校登记
export function delLeave(leaveId) {
  return request({
    url: '/dorm/leave/' + leaveId,
    method: 'delete'
  })
}

// 批准离校申请
export function approveLeave(data) {
  return request({
    url: '/dorm/leave/approve',
    method: 'put',
    data: data
  })
}

// 拒绝离校申请
export function rejectLeave(data) {
  return request({
    url: '/dorm/leave/reject',
    method: 'put',
    data: data
  })
}

// 批量审批离校申请
export function batchApproveLeave(data) {
  return request({
    url: '/dorm/leave/batch-approve',
    method: 'put',
    data: data
  })
}
