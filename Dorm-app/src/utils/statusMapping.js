/**
 * 离校申请状态映射工具
 * 用于统一管理离校申请的状态显示逻辑
 */

// 状态映射配置
export const statusMappings = {
  // 审批状态映射 (approveStatus)
  approve: {
    '0': { text: '待审批', class: 'status-pending' },
    '1': { text: '已批准', class: 'status-approved' },
    '2': { text: '已拒绝', class: 'status-rejected' },
    '3': { text: '已取消', class: 'status-cancelled' }
  },
  // 离校状态映射 (status)
  leave: {
    '0': { text: '离校中', class: 'status-away' },
    '1': { text: '已返校', class: 'status-returned' },
    '2': { text: '逾期未返', class: 'status-overdue' }
  }
}

/**
 * 获取状态样式类
 * @param {string} approveStatus 审批状态
 * @param {string} status 离校状态
 * @returns {string} CSS类名
 */
export const getStatusClass = (approveStatus, status) => {
  // 审批状态优先级处理
  if (approveStatus === '0') {
    return statusMappings.approve['0'].class  // 待审批
  }

  if (approveStatus === '2') {
    return statusMappings.approve['2'].class  // 已拒绝
  }

  if (approveStatus === '3') {
    return statusMappings.approve['3'].class  // 已取消
  }

  // 审批通过后，根据离校状态判断
  if (approveStatus === '1') {
    const leaveStatusConfig = statusMappings.leave[status]
    return leaveStatusConfig ? leaveStatusConfig.class : 'status-pending'
  }

  return 'status-pending'
}

/**
 * 获取状态文本
 * @param {string} approveStatus 审批状态
 * @param {string} status 离校状态
 * @returns {string} 状态文本
 */
export const getStatusText = (approveStatus, status) => {
  // 审批状态优先级处理
  if (approveStatus === '0') {
    return statusMappings.approve['0'].text  // 待审批
  }

  if (approveStatus === '2') {
    return statusMappings.approve['2'].text  // 已拒绝
  }

  if (approveStatus === '3') {
    return statusMappings.approve['3'].text  // 已取消
  }

  // 审批通过后，根据离校状态判断
  if (approveStatus === '1') {
    const leaveStatusConfig = statusMappings.leave[status]
    return leaveStatusConfig ? leaveStatusConfig.text : '未知状态'
  }

  return '未知状态'
}

/**
 * 获取状态描述
 * @param {string} approveStatus 审批状态
 * @param {string} status 离校状态
 * @returns {string} 状态描述
 */
export const getStatusDescription = (approveStatus, status) => {
  // 审批状态优先级处理
  if (approveStatus === '0') {
    return '您的离校申请正在审批中，请耐心等待'
  }

  if (approveStatus === '2') {
    return '您的离校申请已被拒绝，请查看审批意见'
  }

  if (approveStatus === '3') {
    return '您的离校申请已取消'
  }

  // 审批通过后，根据离校状态判断
  if (approveStatus === '1') {
    const descriptions = {
      '0': '您的离校申请已通过，请注意安全',
      '1': '您已确认返校，欢迎回来',
      '2': '您已逾期未返校，请及时联系管理员'
    }
    return descriptions[status] || ''
  }

  return ''
}
