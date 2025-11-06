import request from '@/utils/request'

// 查询报警记录列表
export function listAlarms(query) {
  return request({
    url: '/dorm/alarms/list',
    method: 'get',
    params: query
  })
}

// 查询报警记录详细
export function getAlarms(alarmId) {
  return request({
    url: '/dorm/alarms/' + alarmId,
    method: 'get'
  })
}

// 新增报警记录
export function addAlarms(data) {
  return request({
    url: '/dorm/alarms',
    method: 'post',
    data: data
  })
}

// 修改报警记录
export function updateAlarms(data) {
  return request({
    url: '/dorm/alarms',
    method: 'put',
    data: data
  })
}

// 删除报警记录
export function delAlarms(alarmId) {
  return request({
    url: '/dorm/alarms/' + alarmId,
    method: 'delete'
  })
}

// 标记报警为已处理
export function handleAlarm(alarmId) {
  return request({
    url: '/dorm/alarms/handle/' + alarmId,
    method: 'put'
  })
}