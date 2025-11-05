<template>
  <view class="page-container">
    <!-- 状态栏占位 -->
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>

    <!-- 头部区域 -->
    <view class="custom-navbar">
      <view class="navbar-content">
        <view class="navbar-left" @click="goBack">
          <text class="iconfont icon-arrow-left">‹</text>
        </view>
        <view class="navbar-title">
          <text>离校申请</text>
        </view>
        <view class="navbar-right" @click="goToRegistration">
          <text class="iconfont icon-add">+</text>
        </view>
      </view>
    </view>

    <!-- 主要内容区域 -->
    <scroll-view 
      class="main-content" 
      scroll-y="true"
      @scrolltolower="onReachBottom"
      refresher-enabled
      @refresherrefresh="onRefresh"
      :refresher-triggered="refreshing"
    >
      <!-- 离校申请列表 -->
      <view class="leave-list">
        <view 
          v-for="(item, index) in leaveList" 
          :key="index"
          class="leave-item"
          @click="viewDetail(item)"
        >
          <view class="leave-content">
            <view class="leave-header">
              <text class="leave-title">{{ item.destination || '离校申请' }}</text>
              <view class="leave-status" :class="getStatusClass(item.approveStatus, item.status)">
                <text class="status-text">{{ getStatusText(item.approveStatus, item.status) }}</text>
              </view>
            </view>
            <view class="leave-info">
              <view class="info-row">
                <text class="info-label">申请编号：</text>
                <text class="info-value">{{ item.leaveId }}</text>
              </view>
              <view class="info-row">
                <text class="info-label">目的地：</text>
                <text class="info-value">{{ item.destination }}</text>
              </view>
              <view class="info-row">
                <text class="info-label">离校时间：</text>
                <text class="info-value">{{ formatDate(item.leaveTime) }}</text>
              </view>
              <view class="info-row">
                <text class="info-label">预计返校：</text>
                <text class="info-value">{{ formatDate(item.expectedReturnTime) }}</text>
              </view>
            </view>
            
            <!-- 操作按钮 -->
            <view v-if="canCancel(item) || canReturn(item)" class="leave-actions">
              <view v-if="canCancel(item)" class="action-btn cancel-btn" @click.stop="cancelApplication(item)">
                <text class="btn-text">取消申请</text>
              </view>
              <view v-if="canReturn(item)" class="action-btn return-btn" @click.stop="handleConfirmReturn(item)">
                <text class="btn-text">确认返校</text>
              </view>
            </view>
          </view>
          <view class="leave-arrow">
            <text class="iconfont icon-arrow-right">›</text>
          </view>
        </view>
      </view>

      <!-- 空状态 -->
      <view v-if="!loading && leaveList.length === 0" class="empty-state">
        <text class="empty-icon">📝</text>
        <text class="empty-text">暂无离校申请记录</text>
        <view class="empty-btn" @click="goToRegistration">
          <text class="btn-text">立即申请</text>
        </view>
      </view>

      <!-- 加载更多 -->
      <view v-if="loading" class="loading-more">
        <text class="loading-text">加载中...</text>
      </view>
      
      <!-- 没有更多数据 -->
      <view v-if="!pageParams.hasMore && leaveList.length > 0" class="no-more">
        <text class="no-more-text">没有更多数据了</text>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import {
  getLeaveApplicationList,
  cancelLeaveApplication,
  confirmReturn as apiConfirmReturn
} from '@/api/leave/registration'

// 响应式数据
const statusBarHeight = ref(0)
const loading = ref(false)
const refreshing = ref(false)
const leaveList = ref([])

// 分页参数
const pageParams = ref({
  pageNum: 1,
  pageSize: 10,
  hasMore: true
})

// 初始化页面
onMounted(() => {
  const systemInfo = uni.getSystemInfoSync()
  statusBarHeight.value = systemInfo.statusBarHeight || 0
  loadData()
})

// 加载离校申请列表
const loadData = async (refresh = true) => {
  if (loading.value) return
  
  try {
    loading.value = true
    
    if (refresh) {
      pageParams.value.pageNum = 1
      leaveList.value = []
    }
    
    const params = {
      pageNum: pageParams.value.pageNum,
      pageSize: pageParams.value.pageSize
    }
    
    const response = await getLeaveApplicationList(params)
    
    if (response.code === 200) {
      const newData = response.rows || []
      
      if (refresh) {
        leaveList.value = newData
      } else {
        leaveList.value.push(...newData)
      }
      
      pageParams.value.hasMore = newData.length === pageParams.value.pageSize
      pageParams.value.pageNum++
    }
    
  } catch (error) {
    console.error('加载离校申请列表失败:', error)
    uni.showToast({
      title: '加载失败',
      icon: 'none'
    })
  } finally {
    loading.value = false
    if (refreshing.value) {
      refreshing.value = false
    }
  }
}

// 下拉刷新
const onRefresh = () => {
  refreshing.value = true
  loadData()
}

// 上拉加载更多
const onReachBottom = () => {
  if (pageParams.value.hasMore && !loading.value) {
    loadData(false)
  }
}

// 状态映射配置
const statusMappings = {
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
    return leaveStatusConfig ? leaveStatusConfig.class : 'status-pending'
  }

  return 'status-pending'
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

// 格式化日期时间
const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')} ${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`
}

// 判断是否可以取消申请
const canCancel = (item) => {
  // 只有待审批状态才能取消
  return item.approveStatus === '0'
}

// 判断是否可以确认返校
const canReturn = (item) => {
  // 审批通过且状态为离校中（0）才能确认返校，已取消状态不能确认返校
  return item.approveStatus === '1' && item.status === '0'
}

// 取消申请
const cancelApplication = async (item) => {
  try {
    // 显示确认对话框
    await uni.showModal({
      title: '确认取消',
      content: '确定要取消这个离校申请吗？'
    })

    uni.showLoading({ title: '取消中...' })
    const response = await cancelLeaveApplication(item.leaveId)

    if (response.code === 200) {
      uni.showToast({
        title: '取消成功',
        icon: 'success'
      })
      // 刷新列表数据
      loadData()
    } else {
      uni.showToast({
        title: response.msg || '取消失败',
        icon: 'none'
      })
    }
  } catch (error) {
    if (error.errMsg && error.errMsg.includes('cancel')) {
      return // 用户取消了确认对话框
    }
    console.error('取消申请失败:', error)
    uni.showToast({
      title: '取消失败',
      icon: 'none'
    })
  } finally {
    uni.hideLoading()
  }
}

// 确认返校（跳转到详情页面进行地图定位验证）
const handleConfirmReturn = async (item) => {
  // 跳转到详情页面，详情页面会进行地图定位验证
  if (!item || !item.leaveId) {
    uni.showToast({
      title: '申请ID不存在',
      icon: 'none'
    })
    return
  }
  
  // 跳转到详情页面，并传递参数标识需要打开地图验证
  uni.navigateTo({
    url: `/pages/leave/detail?id=${item.leaveId}&autoOpenMap=true`
  })
}

// 页面跳转
const goBack = () => {
  uni.navigateBack()
}

const goToRegistration = () => {
  uni.navigateTo({
    url: '/pages/leave/registration'
  })
}

const viewDetail = (item) => {
  if (!item || !item.leaveId) {
    uni.showToast({
      title: '申请ID不存在',
      icon: 'none'
    })
    console.error('离校申请数据错误:', item)
    return
  }
  
  uni.navigateTo({
    url: `/pages/leave/detail?id=${item.leaveId}`
  })
}
</script>

<style lang="scss" scoped>
.page-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background: linear-gradient(180deg, #f8f9fa 0%, #ffffff 100%);
}

.status-bar {
  background: transparent;
}

.custom-navbar {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20rpx 30rpx;
}

.navbar-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 88rpx;
}

.navbar-left,
.navbar-right {
  width: 80rpx;
  height: 80rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  backdrop-filter: blur(10rpx);
}

.navbar-left .iconfont,
.navbar-right .iconfont {
  color: white;
  font-size: 36rpx;
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
  flex: 1;
  background: linear-gradient(180deg, #f8f9fa 0%, #ffffff 100%);
}

.leave-list {
  padding: 30rpx;
  
  .leave-item {
    display: flex;
    align-items: center;
    margin-bottom: 24rpx;
    background-color: #fff;
    border-radius: 24rpx;
    overflow: hidden;
    box-shadow: 0 8rpx 32rpx rgba(0, 0, 0, 0.08);
    transition: all 0.3s ease;
    
    &:active {
      transform: scale(0.98);
      box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.05);
    }
    
    .leave-content {
      flex: 1;
      padding: 30rpx;
      
      .leave-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24rpx;
        
        .leave-title {
          font-size: 32rpx;
          font-weight: 600;
          color: #333;
          flex: 1;
          margin-right: 20rpx;
        }
        
        .leave-status {
          padding: 6rpx 20rpx;
          border-radius: 20rpx;
          
          .status-text {
            font-size: 24rpx;
            color: #fff;
            font-weight: 500;
          }
          
          // 审批状态样式
          &.status-pending {
            background: linear-gradient(135deg, #ffa500, #ff8c00);  // 待审批 - 橙色渐变
          }

          &.status-approved {
            background: linear-gradient(135deg, #52c41a, #389e0d);  // 已批准 - 绿色渐变
          }

          &.status-rejected {
            background: linear-gradient(135deg, #ff4d4f, #cf1322);  // 已拒绝 - 红色渐变
          }

          &.status-cancelled {
            background: linear-gradient(135deg, #6c757d, #545b62);  // 已取消 - 灰色渐变
          }

          // 离校状态样式
          &.status-away {
            background: linear-gradient(135deg, #1890ff, #096dd9);  // 离校中 - 蓝色渐变
          }

          &.status-returned {
            background: linear-gradient(135deg, #52c41a, #389e0d);  // 已返校 - 绿色渐变
          }

          &.status-overdue {
            background: linear-gradient(135deg, #ff4d4f, #cf1322);  // 逾期未返 - 红色渐变
          }
        }
      }
      
      .leave-info {
        .info-row {
          display: flex;
          margin-bottom: 16rpx;
          align-items: center;
          
          .info-label {
            width: 160rpx;
            font-size: 28rpx;
            color: #666;
            flex-shrink: 0;
          }
          
          .info-value {
            flex: 1;
            font-size: 28rpx;
            color: #333;
            font-weight: 500;
          }
        }
        
        .info-row:last-child {
          margin-bottom: 0;
        }
      }
      
      .leave-actions {
        display: flex;
        justify-content: flex-end;
        margin-top: 24rpx;
        padding-top: 24rpx;
        border-top: 1rpx solid #f0f0f0;
        
        .action-btn {
          margin-left: 20rpx;
          padding: 14rpx 32rpx;
          border-radius: 24rpx;
          transition: all 0.3s ease;
          
          .btn-text {
            font-size: 28rpx;
            color: #fff;
            font-weight: 500;
          }
          
          &.cancel-btn {
            background: linear-gradient(135deg, #ff4d4f, #cf1322);
          }
          
          &.return-btn {
            background: linear-gradient(135deg, #1890ff, #096dd9);
          }
          
          &:active {
            opacity: 0.8;
            transform: scale(0.95);
          }
        }
      }
    }
    
    .leave-arrow {
      display: flex;
      align-items: center;
      padding: 0 30rpx;
      color: #999;
      font-size: 36rpx;
    }
  }
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 160rpx 40rpx;
  text-align: center;
  
  .empty-icon {
    font-size: 120rpx;
    margin-bottom: 40rpx;
  }
  
  .empty-text {
    font-size: 32rpx;
    color: #666;
    margin-bottom: 50rpx;
    font-weight: 500;
  }
  
  .empty-btn {
    padding: 24rpx 80rpx;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 50rpx;
    box-shadow: 0 8rpx 32rpx rgba(102, 126, 234, 0.3);
    transition: all 0.3s ease;
    
    .btn-text {
      font-size: 30rpx;
      color: #fff;
      font-weight: 600;
    }
    
    &:active {
      transform: scale(0.95);
      box-shadow: 0 4rpx 16rpx rgba(102, 126, 234, 0.2);
    }
  }
}

.loading-more, .no-more {
  text-align: center;
  padding: 40rpx 0;
  
  .loading-text, .no-more-text {
    font-size: 28rpx;
    color: #999;
  }
}

/* 骨架屏加载动画 */
.loading-more {
  .loading-text::after {
    content: '';
    display: inline-block;
    width: 20rpx;
    animation: loading-dots 1.5s infinite;
  }
}

@keyframes loading-dots {
  0%, 20% {
    content: '.';
  }
  40% {
    content: '..';
  }
  60%, 100% {
    content: '...';
  }
}

/* 全局交互效果 */
:active {
  opacity: 0.9;
}

/* 优化按钮点击效果 */
.back-btn,
.add-btn,
.empty-btn,
.action-btn {
  -webkit-tap-highlight-color: transparent;
  tap-highlight-color: transparent;
}

/* 滚动条美化 */
.main-content::-webkit-scrollbar {
  width: 6rpx;
}

.main-content::-webkit-scrollbar-track {
  background: transparent;
}

.main-content::-webkit-scrollbar-thumb {
  background: rgba(102, 126, 234, 0.3);
  border-radius: 3rpx;
}

.main-content::-webkit-scrollbar-thumb:hover {
  background: rgba(102, 126, 234, 0.5);
}
</style>
