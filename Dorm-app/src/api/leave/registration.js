import request from '@/utils/request'

// 提交离校申请
export function submitLeaveApplication(data) {
  return request({
    url: '/dorm/leave',
    method: 'post',
    data: data
  })
}

// 获取离校申请列表
export function getLeaveApplicationList(params) {
  return request({
    url: '/dorm/leave/list',
    method: 'get',
    params: params
  })
}

// 获取离校申请详情
export function getLeaveApplicationDetail(id) {
  return request({
    url: `/dorm/leave/${id}`,
    method: 'get'
  })
}

// 取消离校申请
export function cancelLeaveApplication(id) {
  return request({
    url: `/dorm/leave/cancel/${id}`,
    method: 'put'
  })
}

// 确认返校
export function confirmReturn(id) {
  return request({
    url: `/dorm/leave/return/${id}`,
    method: 'put'
  })
}

// 获取离校状态统计
export function getLeaveStatistics() {
  return request({
    url: '/dorm/leave/statistics',
    method: 'get'
  })
}
