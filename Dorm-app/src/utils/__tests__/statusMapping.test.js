/**
 * 离校申请状态映射工具测试
 */

import { getStatusClass, getStatusText, getStatusDescription } from '../statusMapping.js'

describe('离校申请状态映射工具', () => {
  describe('getStatusClass', () => {
    test('待审批状态', () => {
      expect(getStatusClass('0', '0')).toBe('status-pending')
      expect(getStatusClass('0', '1')).toBe('status-pending')
      expect(getStatusClass('0', '2')).toBe('status-pending')
    })

    test('已拒绝状态', () => {
      expect(getStatusClass('2', '0')).toBe('status-rejected')
      expect(getStatusClass('2', '1')).toBe('status-rejected')
      expect(getStatusClass('2', '2')).toBe('status-rejected')
    })

    test('已取消状态', () => {
      expect(getStatusClass('3', '0')).toBe('status-cancelled')
      expect(getStatusClass('3', '1')).toBe('status-cancelled')
      expect(getStatusClass('3', '2')).toBe('status-cancelled')
    })

    test('已批准状态 - 根据离校状态判断', () => {
      expect(getStatusClass('1', '0')).toBe('status-away')      // 离校中
      expect(getStatusClass('1', '1')).toBe('status-returned')  // 已返校
      expect(getStatusClass('1', '2')).toBe('status-overdue')   // 逾期未返
    })

    test('未知状态处理', () => {
      expect(getStatusClass('3', '0')).toBe('status-pending')
      expect(getStatusClass('1', '3')).toBe('status-pending')
      expect(getStatusClass(undefined, undefined)).toBe('status-pending')
    })
  })

  describe('getStatusText', () => {
    test('待审批状态', () => {
      expect(getStatusText('0', '0')).toBe('待审批')
      expect(getStatusText('0', '1')).toBe('待审批')
      expect(getStatusText('0', '2')).toBe('待审批')
    })

    test('已拒绝状态', () => {
      expect(getStatusText('2', '0')).toBe('已拒绝')
      expect(getStatusText('2', '1')).toBe('已拒绝')
      expect(getStatusText('2', '2')).toBe('已拒绝')
    })

    test('已取消状态', () => {
      expect(getStatusText('3', '0')).toBe('已取消')
      expect(getStatusText('3', '1')).toBe('已取消')
      expect(getStatusText('3', '2')).toBe('已取消')
    })

    test('已批准状态 - 根据离校状态判断', () => {
      expect(getStatusText('1', '0')).toBe('离校中')
      expect(getStatusText('1', '1')).toBe('已返校')
      expect(getStatusText('1', '2')).toBe('逾期未返')
    })

    test('未知状态处理', () => {
      expect(getStatusText('3', '0')).toBe('未知状态')
      expect(getStatusText('1', '3')).toBe('未知状态')
      expect(getStatusText(undefined, undefined)).toBe('未知状态')
    })
  })

  describe('getStatusDescription', () => {
    test('待审批状态', () => {
      expect(getStatusDescription('0', '0')).toBe('您的离校申请正在审批中，请耐心等待')
    })

    test('已拒绝状态', () => {
      expect(getStatusDescription('2', '0')).toBe('您的离校申请已被拒绝，请查看审批意见')
    })

    test('已取消状态', () => {
      expect(getStatusDescription('3', '0')).toBe('您的离校申请已取消')
    })

    test('已批准状态 - 根据离校状态判断', () => {
      expect(getStatusDescription('1', '0')).toBe('您的离校申请已通过，请注意安全')
      expect(getStatusDescription('1', '1')).toBe('您已确认返校，欢迎回来')
      expect(getStatusDescription('1', '2')).toBe('您已逾期未返校，请及时联系管理员')
    })

    test('未知状态处理', () => {
      expect(getStatusDescription('3', '0')).toBe('')
      expect(getStatusDescription('1', '3')).toBe('')
      expect(getStatusDescription(undefined, undefined)).toBe('')
    })
  })

  describe('状态映射一致性测试', () => {
    test('所有状态组合都应该有对应的文本和样式', () => {
      const testCases = [
        { approveStatus: '0', status: '0' },
        { approveStatus: '0', status: '1' },
        { approveStatus: '0', status: '2' },
        { approveStatus: '1', status: '0' },
        { approveStatus: '1', status: '1' },
        { approveStatus: '1', status: '2' },
        { approveStatus: '2', status: '0' },
        { approveStatus: '2', status: '1' },
        { approveStatus: '2', status: '2' },
        { approveStatus: '3', status: '0' },
        { approveStatus: '3', status: '1' },
        { approveStatus: '3', status: '2' }
      ]

      testCases.forEach(({ approveStatus, status }) => {
        const statusClass = getStatusClass(approveStatus, status)
        const statusText = getStatusText(approveStatus, status)
        
        expect(statusClass).toBeTruthy()
        expect(statusText).toBeTruthy()
        expect(statusClass).not.toBe('未知状态')
        expect(statusText).not.toBe('')
      })
    })
  })
})
