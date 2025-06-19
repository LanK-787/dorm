import request from '@/utils/request'

// 查询工单分配列表
export function listAssignment(query) {
  return request({
    url: '/dorm/assignment/list',
    method: 'get',
    params: query
  })
}

// 查询工单分配详细
export function getAssignment(assignmentId) {
  return request({
    url: '/dorm/assignment/' + assignmentId,
    method: 'get'
  })
}

// 新增工单分配
export function addAssignment(data) {
  return request({
    url: '/dorm/assignment',
    method: 'post',
    data: data
  })
}

// 修改工单分配
export function updateAssignment(data) {
  return request({
    url: '/dorm/assignment',
    method: 'put',
    data: data
  })
}

// 删除工单分配
export function delAssignment(assignmentId) {
  return request({
    url: '/dorm/assignment/' + assignmentId,
    method: 'delete'
  })
}
