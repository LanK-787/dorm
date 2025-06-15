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

// 批量修复宿舍状态
export function batchFixDormStatus() {
  return request({
    url: '/dorm/building/batchFixStatus',
    method: 'post'
  })
}

// 检查宿舍状态一致性
export function checkStatusConsistency() {
  return request({
    url: '/dorm/building/checkStatusConsistency',
    method: 'get'
  })
}

// 验证宿舍状态数据一致性
export function validateStatus() {
  return request({
    url: '/dorm/building/validateStatus',
    method: 'get'
  })
}

// 同步父子节点容量数据
export function syncCapacity() {
  return request({
    url: '/dorm/building/syncCapacity',
    method: 'post'
  })
}
