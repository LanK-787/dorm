import request from '@/utils/request'

// 获取首页统计数据
export function getDashboardStatistics() {
  return request({
    url: '/dashboard/statistics',
    method: 'get'
  })
}

// 获取宿舍统计数据
export function getDormStatistics() {
  return request({
    url: '/dorm/building/statistics',
    method: 'get'
  })
}

// 获取学生统计数据
export function getStudentStatistics() {
  return request({
    url: '/dorm/student/statistics',
    method: 'get'
  })
}

// 获取维修工单统计数据
export function getRepairStatistics() {
  return request({
    url: '/dorm/request/statistics',
    method: 'get'
  })
}

// 获取请假申请统计数据
export function getLeaveStatistics() {
  return request({
    url: '/dorm/leave/statistics',
    method: 'get'
  })
}

// 获取派单监控数据
export function getDispatchMonitorData() {
  return request({
    url: '/dorm/monitor/dashboard',
    method: 'get'
  })
}
