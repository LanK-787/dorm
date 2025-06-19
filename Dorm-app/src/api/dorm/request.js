import request from '@/utils/request'

// 查询报修工单列表
export function listRequest(query) {
  return request({
    url: '/dorm/request/list',
    method: 'get',
    params: query
  })
}

// 查询报修工单详细
export function getRequest(requestId) {
  return request({
    url: '/dorm/request/' + requestId,
    method: 'get'
  })
}

// 新增报修工单
export function addRequest(data) {
  return request({
    url: '/dorm/request',
    method: 'post',
    data: data
  })
}

// 修改报修工单
export function updateRequest(data) {
  return request({
    url: '/dorm/request',
    method: 'put',
    data: data
  })
}

// 删除报修工单
export function delRequest(requestId) {
  return request({
    url: '/dorm/request/' + requestId,
    method: 'delete'
  })
}

// 查询宿舍下拉树结构（用于报修表单）
export function dormTreeSelect() {
  return request({
    url: '/dorm/student/dormTree',
    method: 'get'
  })
}
