<template>
  <view class="page-container">
    <!-- 自定义导航栏 -->
    <view class="custom-navbar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="navbar-content">
        <view class="navbar-left" @click="goBack">
          <text class="iconfont icon-back">‹</text>
        </view>
        <view class="navbar-title">
          <text>申请详情</text>
        </view>
        <view class="navbar-right"></view>
      </view>
    </view>

    <!-- 主要内容 -->
    <scroll-view class="main-content" scroll-y="true">
      <view v-if="loading" class="loading-container">
        <text class="loading-text">加载中...</text>
      </view>
      
      <view v-else-if="leaveDetail" class="detail-container">
        <!-- 状态卡片 -->
        <view class="status-card">
          <view class="status-header">
            <text class="status-title">申请状态</text>
            <text
              class="status-tag"
              :class="getStatusClass(leaveDetail.approveStatus, leaveDetail.status)"
            >
              {{ getStatusText(leaveDetail.approveStatus, leaveDetail.status) }}
            </text>
          </view>
          <view class="status-content">
            <text class="status-desc">{{ getStatusDescription(leaveDetail.approveStatus, leaveDetail.status) }}</text>
          </view>
        </view>

        <!-- 基本信息 -->
        <view class="info-card">
          <view class="card-title">
            <text>基本信息</text>
          </view>
          <view class="info-list">
            <view class="info-item">
              <text class="info-label">学号</text>
              <text class="info-value">{{ leaveDetail.studentId }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">姓名</text>
              <text class="info-value">{{ leaveDetail.studentName }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">离校时间</text>
              <text class="info-value">{{ formatDateTime(leaveDetail.leaveTime) }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">预计返校时间</text>
              <text class="info-value">{{ formatDateTime(leaveDetail.expectedReturnTime) }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">目的地</text>
              <text class="info-value">{{ leaveDetail.destination }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">联系电话</text>
              <text class="info-value">{{ leaveDetail.contactPhone }}</text>
            </view>
          </view>
        </view>

        <!-- 离校原因 -->
        <view class="info-card">
          <view class="card-title">
            <text>离校原因</text>
          </view>
          <view class="reason-content">
            <text class="reason-text">{{ leaveDetail.leaveReason }}</text>
          </view>
        </view>

        <!-- 紧急联系人 -->
        <view class="info-card">
          <view class="card-title">
            <text>紧急联系人</text>
          </view>
          <view class="info-list">
            <view class="info-item">
              <text class="info-label">姓名</text>
              <text class="info-value">{{ leaveDetail.emergencyContact }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">电话</text>
              <text class="info-value">{{ leaveDetail.emergencyPhone }}</text>
            </view>
          </view>
        </view>

        <!-- 审批信息 -->
        <view v-if="leaveDetail.approveStatus !== '0'" class="info-card">
          <view class="card-title">
            <text>审批信息</text>
          </view>
          <view class="info-list">
            <view class="info-item">
              <text class="info-label">审批人</text>
              <text class="info-value">{{ leaveDetail.approver || '系统' }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">审批时间</text>
              <text class="info-value">{{ formatDateTime(leaveDetail.approveTime) }}</text>
            </view>
            <view v-if="leaveDetail.approveRemark" class="info-item">
              <text class="info-label">审批意见</text>
              <text class="info-value">{{ leaveDetail.approveRemark }}</text>
            </view>
          </view>
        </view>

        <!-- 备注 -->
        <view v-if="leaveDetail.remark" class="info-card">
          <view class="card-title">
            <text>备注</text>
          </view>
          <view class="reason-content">
            <text class="reason-text">{{ leaveDetail.remark }}</text>
          </view>
        </view>

        <!-- 操作按钮 -->
        <view class="action-section">
          <button 
            v-if="canCancel(leaveDetail)" 
            class="action-btn cancel-btn" 
            @click="cancelApplication"
          >
            取消申请
          </button>
          <button 
            v-if="canReturn(leaveDetail)" 
            class="action-btn return-btn" 
            @click="confirmReturn"
          >
            确认返校
          </button>
        </view>
      </view>
      
      <view v-else class="error-container">
        <text class="error-text">申请详情加载失败</text>
        <button class="retry-btn" @click="loadDetail">重试</button>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import {
  getLeaveApplicationDetail,
  cancelLeaveApplication,
  confirmReturn as apiConfirmReturn
} from '@/api/leave/registration'

// 响应式数据
const statusBarHeight = ref(0)
const loading = ref(false)
const leaveDetail = ref(null)
const leaveId = ref('')

// 初始化页面
const initPage = () => {
  // 获取状态栏高度
  const systemInfo = uni.getSystemInfoSync()
  statusBarHeight.value = systemInfo.statusBarHeight || 0
  
  // 获取页面参数
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  leaveId.value = currentPage.options.id || ''
  
  if (leaveId.value) {
    loadDetail()
  } else {
    uni.showToast({
      title: '参数错误',
      icon: 'none'
    })
  }
}

// 加载详情
const loadDetail = async () => {
  if (!leaveId.value) return
  
  try {
    loading.value = true
    
    const response = await getLeaveApplicationDetail(leaveId.value)
    
    if (response.code === 200) {
      leaveDetail.value = response.data
    } else {
      uni.showToast({
        title: response.msg || '加载失败',
        icon: 'none'
      })
    }
    
  } catch (error) {
    console.error('加载申请详情失败:', error)
    uni.showToast({
      title: '加载失败',
      icon: 'none'
    })
  } finally {
    loading.value = false
  }
}

// 格式化日期时间
const formatDateTime = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')} ${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`
}

// 状态映射配置
const statusMappings = {
  // 审批状态映射 (approveStatus)
  approve: {
    '0': { text: '待审批', class: 'pending' },
    '1': { text: '已批准', class: 'approved' },
    '2': { text: '已拒绝', class: 'rejected' },
    '3': { text: '已取消', class: 'cancelled' }
  },
  // 离校状态映射 (status)
  leave: {
    '0': { text: '离校中', class: 'away' },
    '1': { text: '已返校', class: 'returned' },
    '2': { text: '逾期未返', class: 'overdue' }
  }
}

// 获取状态样式类
const getStatusClass = (approveStatus, status) => {
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
    return leaveStatusConfig ? leaveStatusConfig.class : 'pending'
  }

  return 'pending'
}

// 获取状态文本
const getStatusText = (approveStatus, status) => {
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

// 获取状态描述
const getStatusDescription = (approveStatus, status) => {
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

// 判断是否可以取消
const canCancel = (item) => {
  // 只有待审批状态才能取消
  return item && item.approveStatus === '0'
}

// 判断是否可以确认返校
const canReturn = (item) => {
  // 审批通过且状态为离校中才能确认返校，已取消状态不能确认返校
  return item && item.approveStatus === '1' && item.status === '0'
}

// 取消申请
const cancelApplication = async () => {
  try {
    await uni.showModal({
      title: '确认取消',
      content: '确定要取消这个离校申请吗？'
    })

    const response = await cancelLeaveApplication(leaveId.value)

    if (response.code === 200) {
      uni.showToast({
        title: '取消成功',
        icon: 'success'
      })

      // 更新本地状态为已取消
      if (leaveDetail.value) {
        leaveDetail.value.approveStatus = '3'
      }

      // 刷新详情数据以确保状态同步
      setTimeout(() => {
        loadDetail()
      }, 1000)
    } else {
      uni.showToast({
        title: response.msg || '取消失败',
        icon: 'none'
      })
    }

  } catch (error) {
    if (error.errMsg && error.errMsg.includes('cancel')) {
      return
    }
    console.error('取消申请失败:', error)
    uni.showToast({
      title: '操作失败',
      icon: 'none'
    })
  }
}

// 确认返校
const confirmReturn = async () => {
  try {
    const [err, res] = await uni.showModal({
      title: '确认返校',
      content: '确定已经返校了吗？'
    })
    
    // 用户点击取消按钮
    if (err || !res.confirm) {
      return
    }

    const response = await apiConfirmReturn(leaveId.value)

    if (response.code === 200) {
      uni.showToast({
        title: '返校确认成功',
        icon: 'success'
      })

      // 刷新详情
      loadDetail()
    } else {
      uni.showToast({
        title: response.msg || '确认失败',
        icon: 'none'
      })
    }

  } catch (error) {
    console.error('确认返校失败:', error)
    uni.showToast({
      title: '操作失败',
      icon: 'none'
    })
  }
}

// 返回上一页
const goBack = () => {
  uni.navigateBack()
}

// 生命周期钩子
onMounted(() => {
  initPage()
})
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background: #f8f9fa;
}

.custom-navbar {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
}

.navbar-content {
  height: 88rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 30rpx;
}

.navbar-left,
.navbar-right {
  width: 80rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.navbar-left .iconfont {
  color: white;
  font-size: 40rpx;
  font-weight: bold;
}

.navbar-title {
  flex: 1;
  text-align: center;
}

.navbar-title text {
  color: white;
  font-size: 36rpx;
  font-weight: bold;
}

.main-content {
  margin-top: 88rpx;
  padding: 30rpx;
}

.loading-container,
.error-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 100rpx 0;
}

.loading-text,
.error-text {
  color: #666;
  font-size: 28rpx;
  margin-bottom: 30rpx;
}

.retry-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 40rpx;
  padding: 20rpx 60rpx;
  font-size: 28rpx;
}

.detail-container {
  display: flex;
  flex-direction: column;
  gap: 30rpx;
}

.status-card {
  background: white;
  border-radius: 20rpx;
  padding: 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}

.status-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.status-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.status-tag {
  padding: 8rpx 16rpx;
  border-radius: 20rpx;
  font-size: 24rpx;
  font-weight: bold;
}

// 审批状态样式
.status-tag.pending {
  background: #fff3cd;
  color: #856404;
}

.status-tag.approved {
  background: #d4edda;
  color: #155724;
}

.status-tag.rejected {
  background: #f5c6cb;
  color: #721c24;
}

.status-tag.cancelled {
  background: #e9ecef;
  color: #6c757d;
}

// 离校状态样式
.status-tag.away {
  background: #cce5ff;
  color: #0066cc;
}

.status-tag.returned {
  background: #d4edda;
  color: #155724;
}

.status-tag.overdue {
  background: #f8d7da;
  color: #721c24;
}

.status-content {
  padding: 20rpx;
  background: #f8f9fa;
  border-radius: 12rpx;
}

.status-desc {
  font-size: 28rpx;
  color: #666;
  line-height: 1.5;
}

.info-card {
  background: white;
  border-radius: 20rpx;
  padding: 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}

.card-title {
  margin-bottom: 30rpx;
}

.card-title text {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.info-list {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.info-label {
  font-size: 28rpx;
  color: #666;
  min-width: 160rpx;
}

.info-value {
  font-size: 28rpx;
  color: #333;
  flex: 1;
  text-align: right;
  word-break: break-all;
}

.reason-content {
  padding: 20rpx;
  background: #f8f9fa;
  border-radius: 12rpx;
}

.reason-text {
  font-size: 28rpx;
  color: #333;
  line-height: 1.6;
}

.action-section {
  display: flex;
  gap: 20rpx;
  padding: 20rpx 0;
}

.action-btn {
  flex: 1;
  height: 88rpx;
  border: none;
  border-radius: 44rpx;
  font-size: 32rpx;
  font-weight: bold;
  display: flex;
  align-items: center;
  justify-content: center;
}

.cancel-btn {
  background: #ff4d4f;
  color: white;
}

.return-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.action-btn:active {
  transform: scale(0.98);
}
</style>
