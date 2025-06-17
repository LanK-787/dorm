import request from '@/utils/request'

// 查询维修人员管理列表
export function listRepairer(query) {
  return request({
    url: '/manage/repairer/list',
    method: 'get',
    params: query
  })
}

// 查询维修人员管理详细
export function getRepairer(repairerId) {
  return request({
    url: '/manage/repairer/' + repairerId,
    method: 'get'
  })
}

// 根据用户ID查询维修人员信息
export function getRepairerByUserId(userId) {
  return request({
    url: '/manage/repairer/user/' + userId,
    method: 'get'
  })
}

// 新增维修人员管理
export function addRepairer(data) {
  return request({
    url: '/manage/repairer',
    method: 'post',
    data: data
  })
}

// 修改维修人员管理
export function updateRepairer(data) {
  return request({
    url: '/manage/repairer',
    method: 'put',
    data: data
  })
}

// 删除维修人员管理
export function delRepairer(repairerId) {
  return request({
    url: '/manage/repairer/' + repairerId,
    method: 'delete'
  })
}
