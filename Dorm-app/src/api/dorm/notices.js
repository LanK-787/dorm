import request from '@/utils/request'

// 查询宿舍公告列表
export function listNotices(query) {
  return request({
    url: '/dorm/notices/list',
    method: 'get',
    params: query
  })
}

// 查询宿舍公告详细
export function getNotices(noticeId) {
  return request({
    url: '/dorm/notices/' + noticeId,
    method: 'get'
  })
}

// 新增宿舍公告
export function addNotices(data) {
  return request({
    url: '/dorm/notices',
    method: 'post',
    data: data
  })
}

// 修改宿舍公告
export function updateNotices(data) {
  return request({
    url: '/dorm/notices',
    method: 'put',
    data: data
  })
}

// 删除宿舍公告
export function delNotices(noticeId) {
  return request({
    url: '/dorm/notices/' + noticeId,
    method: 'delete'
  })
}
