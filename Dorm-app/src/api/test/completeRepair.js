import request from '@/utils/request'

// 测试消息发送功能
export function testMessageSending(assignmentId) {
  return request({
    url: `/test/complete-repair/test-message/${assignmentId}`,
    method: 'post'
  })
}

// 模拟完成维修流程
export function simulateComplete(assignmentId, images = 'test-image1.jpg,test-image2.jpg', processRemark = '测试维修说明') {
  return request({
    url: `/test/complete-repair/simulate-complete/${assignmentId}`,
    method: 'post',
    params: {
      images,
      processRemark
    }
  })
}

// 检查RabbitMQ连接状态
export function checkRabbitMQ() {
  return request({
    url: '/test/complete-repair/check-rabbitmq',
    method: 'get'
  })
}

// 获取派单详细信息
export function getAssignmentDetail(assignmentId) {
  return request({
    url: `/test/complete-repair/assignment-detail/${assignmentId}`,
    method: 'get'
  })
}
