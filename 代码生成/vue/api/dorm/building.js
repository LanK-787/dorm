import request from '@/utils/request'

// 查询宿舍管理列表
export function listBuilding(query) {
  return request({
    url: '/dorm/building/list',
    method: 'get',
    params: query
  })
}

// 查询宿舍管理详细
export function getBuilding(dormId) {
  return request({
    url: '/dorm/building/' + dormId,
    method: 'get'
  })
}

// 新增宿舍管理
export function addBuilding(data) {
  return request({
    url: '/dorm/building',
    method: 'post',
    data: data
  })
}

// 修改宿舍管理
export function updateBuilding(data) {
  return request({
    url: '/dorm/building',
    method: 'put',
    data: data
  })
}

// 删除宿舍管理
export function delBuilding(dormId) {
  return request({
    url: '/dorm/building/' + dormId,
    method: 'delete'
  })
}
