import request from '@/utils/request'

// 查询宿舍详细信息
export function getDormInfo(dormId) {
  return request({
    url: '/dorm/building/' + dormId,
    method: 'get'
  })
}

// 查询宿舍下的学生列表
export function getDormStudents(dormId) {
  return request({
    url: '/dorm/student/list',
    method: 'get',
    params: {
      dormId: dormId
    }
  })
}

// 查询当前用户的学生信息（包含宿舍信息）
export function getCurrentUserDorm() {
  return request({
    url: '/dorm/student/getStudentInfo',
    method: 'get'
  })
}

// 查询宿舍管理列表（用于搜索）
export function listBuilding(query) {
  return request({
    url: '/dorm/building/list',
    method: 'get',
    params: query
  })
}

// 获取宿舍的宿管信息（通过ancestors查找父级）
export function getDormManagerInfo(dormId) {
  return request({
    url: '/dorm/building/list',
    method: 'get',
    params: {
      dormId: dormId
    }
  })
}
