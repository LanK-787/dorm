<template>
  <view class="leave-list-page">
    <!-- 状态栏占位 -->
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>

    <!-- 顶部导航栏 -->
    <view class="nav-bar">
      <view class="nav-left" @click="goBack">
        <text class="nav-icon">←</text>
      </view>
      <view class="nav-center">
        <text class="nav-title">离校管理</text>
        <text class="nav-count">{{ totalCount }}条记录</text>
      </view>
      <view class="nav-right" @click="goToAdd">
        <text class="nav-icon">+</text>
      </view>
    </view>

    <!-- 快速筛选卡片 -->
    <view class="filter-section">
      <scroll-view class="filter-scroll" scroll-x show-scrollbar="false">
        <view 
          v-for="filter in filterOptions" 
          :key="filter.value"
          class="filter-chip"
          :class="{ 'filter-active': activeFilter === filter.value }"
          @click="changeFilter(filter.value)"
        >
          <view class="chip-content">
            <text class="chip-icon">{{ filter.icon }}</text>
            <text class="chip-label">{{ filter.label }}</text>
            <text v-if="filter.count > 0" class="chip-badge">{{ filter.count }}</text>
          </view>
        </view>
      </scroll-view>
    </view>

    <!-- 搜索栏 -->
    <view class="search-section">
      <view class="search-box">
        <text class="search-icon-left">🔍</text>
        <input 
          class="search-input" 
          v-model="searchText"
          placeholder="搜索目的地或申请编号"
          @input="handleSearchInput"
          confirm-type="search"
        />
        <text v-if="searchText" class="search-clear" @click="clearSearch">×</text>
      </view>
    </view>

    <!-- 主列表区域 -->
    <scroll-view 
      class="content-scroll"
      :style="{ height: contentHeight + 'px' }"
      scroll-y
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onPullRefresh"
      @scrolltolower="onLoadMore"
      :lower-threshold="100"
      enhanced
      :show-scrollbar="false"
    >
      <!-- 下拉刷新提示 -->
      <view v-if="refreshing" class="refresh-indicator">
        <view class="refresh-spinner"></view>
        <text class="refresh-text">刷新中...</text>
      </view>

      <!-- 数据列表 -->
      <view class="list-container">
        <view 
          v-for="(item, index) in displayList" 
          :key="item.leaveId"
          class="leave-item"
          :class="'priority-' + getPriorityLevel(item)"
          :style="{ animationDelay: (index % 8) * 0.05 + 's' }"
          @click="viewDetail(item)"
        >
          <!-- 紧急标记 -->
          <view v-if="isOverdue(item)" class="overdue-flag">
            <text>⚠</text>
          </view>

          <!-- 卡片头部 -->
          <view class="item-header">
            <view class="header-left">
              <view class="status-dot" :class="'dot-' + getStatusType(item)"></view>
              <text class="leave-id">No.{{ item.leaveId }}</text>
            </view>
            <view class="status-tag" :class="'tag-' + getStatusType(item)">
              {{ getStatusLabel(item) }}
            </view>
          </view>

          <!-- 卡片内容 -->
          <view class="item-body">
            <view class="body-row destination-row">
              <text class="row-icon">📍</text>
              <text class="row-text destination-text">{{ item.destination || '未填写目的地' }}</text>
            </view>
            
            <view class="time-section">
              <view class="time-row">
                <text class="time-icon">🚶</text>
                <view class="time-info">
                  <text class="time-label">离校时间</text>
                  <text class="time-value">{{ formatDateTime(item.leaveTime) }}</text>
                </view>
              </view>
              <view class="time-arrow">→</view>
              <view class="time-row">
                <text class="time-icon">🏠</text>
                <view class="time-info">
                  <text class="time-label">返校时间</text>
                  <text class="time-value">{{ formatDateTime(item.expectedReturnTime) }}</text>
                </view>
              </view>
            </view>

            <view v-if="item.reason" class="body-row">
              <text class="row-icon">📝</text>
              <text class="row-text reason-text">{{ item.reason }}</text>
            </view>
          </view>

          <!-- 操作按钮区 -->
          <view v-if="showActions(item)" class="item-actions">
            <view class="action-group">
              <view 
                v-if="canCancel(item)" 
                class="action-btn btn-cancel"
                @click.stop="handleCancel(item)"
              >
                <text class="btn-icon">✕</text>
                <text class="btn-text">取消申请</text>
              </view>
              <view 
                v-if="canReturn(item)" 
                class="action-btn btn-return"
                @click.stop="handleReturn(item)"
              >
                <text class="btn-icon">✓</text>
                <text class="btn-text">确认返校</text>
              </view>
            </view>
          </view>

          <!-- 时间标记 -->
          <view class="item-footer">
            <text class="footer-time">{{ formatTimeAgo(item.createTime || item.leaveTime) }}</text>
            <text class="footer-arrow">›</text>
          </view>
        </view>
      </view>

      <!-- 空状态 -->
      <view v-if="!loading && displayList.length === 0" class="empty-container">
        <view class="empty-animation">
          <text class="empty-emoji">{{ emptyIcon }}</text>
        </view>
        <text class="empty-title">{{ emptyTitle }}</text>
        <text class="empty-desc">{{ emptyDesc }}</text>
        <view v-if="!searchText && activeFilter === 'all'" class="empty-action" @click="goToAdd">
          <text>立即申请</text>
        </view>
      </view>

      <!-- 加载更多 -->
      <view v-if="loadingMore" class="loading-more">
        <view class="loading-spinner"></view>
        <text class="loading-text">加载中...</text>
      </view>

      <!-- 无更多数据 -->
      <view v-if="noMore && displayList.length > 0 && !loading" class="no-more">
        <text>— 已加载全部 —</text>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { 
  getLeaveApplicationList, 
  cancelLeaveApplication,
  confirmReturn 
} from '@/api/leave/registration'

// ==================== 状态管理 ====================
// 页面基础数据
const statusBarHeight = ref(0)
const contentHeight = ref(600)
const loading = ref(false)
const refreshing = ref(false)
const loadingMore = ref(false)
const noMore = ref(false)

// 列表数据
const leaveList = ref([])
const pageNum = ref(1)
const pageSize = 20

// 筛选和搜索
const activeFilter = ref('all')
const searchText = ref('')
let searchTimer = null

// ==================== 计算属性 ====================
const totalCount = computed(() => leaveList.value.length)

// 筛选选项
const filterOptions = computed(() => {
  const list = leaveList.value
  return [
    { value: 'all', label: '全部', icon: '📋', count: list.length },
    { value: 'pending', label: '待审批', icon: '⏳', count: list.filter(i => getStatusType(i) === 'pending').length },
    { value: 'approved', label: '已批准', icon: '✅', count: list.filter(i => getStatusType(i) === 'approved').length },
    { value: 'away', label: '离校中', icon: '🚶', count: list.filter(i => getStatusType(i) === 'away').length },
    { value: 'returned', label: '已返校', icon: '🏠', count: list.filter(i => getStatusType(i) === 'returned').length },
    { value: 'rejected', label: '已拒绝', icon: '❌', count: list.filter(i => getStatusType(i) === 'rejected').length },
    { value: 'overdue', label: '逾期', icon: '⚠️', count: list.filter(i => getStatusType(i) === 'overdue').length }
  ]
})

// 显示列表（应用筛选和搜索）
const displayList = computed(() => {
  let list = leaveList.value

  // 状态筛选
  if (activeFilter.value !== 'all') {
    list = list.filter(item => {
      const type = getStatusType(item)
      return type === activeFilter.value
    })
  }

  // 搜索过滤
  if (searchText.value.trim()) {
    const keyword = searchText.value.toLowerCase()
    list = list.filter(item => {
      const searchFields = [
        item.destination,
        String(item.leaveId),
        item.reason
      ].filter(Boolean).join(' ').toLowerCase()
      return searchFields.includes(keyword)
    })
  }

  return list
})

// 空状态
const emptyIcon = computed(() => {
  if (searchText.value) return '🔍'
  if (activeFilter.value !== 'all') return '📭'
  return '✈️'
})

const emptyTitle = computed(() => {
  if (searchText.value) return '未找到相关内容'
  if (activeFilter.value !== 'all') return '暂无数据'
  return '暂无离校记录'
})

const emptyDesc = computed(() => {
  if (searchText.value) return '试试其他关键词'
  if (activeFilter.value !== 'all') return '切换其他状态查看'
  return '点击右上角+号发起离校申请'
})

// ============ 生命周期 ============
onMounted(() => {
  initPage()
  loadData(true)
})

// ==================== 页面初始化 ====================
const initPage = () => {
  try {
    const systemInfo = uni.getSystemInfoSync()
    statusBarHeight.value = systemInfo.statusBarHeight || 0
    
    // 计算内容高度：屏幕高度 - 状态栏 - 导航栏(88rpx≈44px) - 筛选(160rpx≈80px) - 搜索(120rpx≈60px)
    contentHeight.value = systemInfo.windowHeight - statusBarHeight.value - 44 - 80 - 60
  } catch (error) {
    console.error('页面初始化失败:', error)
    contentHeight.value = 500
  }
}

// ==================== 数据加载 ====================
const loadData = async (refresh = false) => {
  if (loading.value && !refresh) return
  
  try {
    if (refresh) {
      loading.value = true
      refreshing.value = true
      pageNum.value = 1
      noMore.value = false
    } else {
      loadingMore.value = true
    }

    const response = await getLeaveApplicationList({
      pageNum: pageNum.value,
      pageSize: pageSize
    })

    if (response.code === 200) {
      const newData = response.rows || []
      
      if (refresh || pageNum.value === 1) {
        leaveList.value = newData
      } else {
        leaveList.value = [...leaveList.value, ...newData]
      }

      noMore.value = newData.length < pageSize
      if (!noMore.value) pageNum.value++
    }
  } catch (error) {
    console.error('加载离校列表失败:', error)
    uni.showToast({ title: '加载失败', icon: 'none' })
  } finally {
    loading.value = false
    refreshing.value = false
    loadingMore.value = false
  }
}

// 获取状态类型
const getStatusType = (item) => {
  if (!item) return 'unknown'
  
  // approveStatus: 0-待审批, 1-已批准, 2-已拒绝, 3-已取消
  // status: 0-离校中, 1-已返校, 2-逾期未返
  if (item.approveStatus === '0') return 'pending'
  if (item.approveStatus === '2') return 'rejected'
  if (item.approveStatus === '3') return 'cancelled'
  if (item.approveStatus === '1') {
    if (item.status === '0') return 'away'
    if (item.status === '1') return 'returned'
    if (item.status === '2') return 'overdue'
  }
  return 'approved'
}

// 获取状态标签
const getStatusLabel = (item) => {
  const typeMap = {
    pending: '待审批',
    approved: '已批准',
    rejected: '已拒绝',
    cancelled: '已取消',
    away: '离校中',
    returned: '已返校',
    overdue: '逾期未返'
  }
  return typeMap[getStatusType(item)] || '未知'
}

// 格式化日期时间
const formatDateTime = (dateStr) => {
  if (!dateStr) return '--'
  
  try {
    const date = new Date(dateStr)
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    const hour = String(date.getHours()).padStart(2, '0')
    const minute = String(date.getMinutes()).padStart(2, '0')
    return `${month}/${day} ${hour}:${minute}`
  } catch (e) {
    return '--'
  }
}

// ==================== 事件处理 ====================
const onPullRefresh = () => {
  loadData(true)
}

const onLoadMore = () => {
  if (!noMore.value && !loadingMore.value && !loading.value) {
    loadData(false)
  }
}

const handleSearchInput = () => {
  if (searchTimer) clearTimeout(searchTimer)
  searchTimer = setTimeout(() => {
    // 搜索通过计算属性自动实现
  }, 300)
}

const clearSearch = () => {
  searchText.value = ''
}

const changeFilter = (value) => {
  activeFilter.value = value
}

const goBack = () => {
  uni.navigateBack()
}

const goToAdd = () => {
  uni.navigateTo({
    url: '/pages/leave/registration'
  })
}

const viewDetail = (item) => {
  uni.navigateTo({
    url: `/pages/leave/detail?id=${item.leaveId}`
  })
}

// ==================== 辅助函数 ====================
// 获取优先级等级
const getPriorityLevel = (item) => {
  if (isOverdue(item)) return 'high'
  if (getStatusType(item) === 'pending') return 'medium'
  return 'normal'
}

// 是否逾期
const isOverdue = (item) => {
  return getStatusType(item) === 'overdue'
}

// 是否显示操作按钮
const showActions = (item) => {
  return canCancel(item) || canReturn(item)
}

// 是否可以取消
const canCancel = (item) => {
  return item.approveStatus === '0'
}

// 是否可以返校
const canReturn = (item) => {
  return item.approveStatus === '1' && item.status === '0'
}

// 取消申请
const handleCancel = async (item) => {
  try {
    const result = await uni.showModal({
      title: '确认取消',
      content: '确定要取消这条离校申请吗？',
      confirmColor: '#f56c6c'
    })

    if (result.confirm) {
      uni.showLoading({ title: '处理中...' })
      const res = await cancelLeaveApplication(item.leaveId)
      
      if (res.code === 200) {
        uni.showToast({
          title: '取消成功',
          icon: 'success'
        })
        loadData(true)
      } else {
        uni.showToast({
          title: res.msg || '取消失败',
          icon: 'none'
        })
      }
    }
  } catch (error) {
    console.error('取消失败:', error)
  } finally {
    uni.hideLoading()
  }
}

// 确认返校
const handleReturn = (item) => {
  uni.navigateTo({
    url: `/pages/leave/detail?id=${item.leaveId}&autoOpenMap=true`
  })
}

// 时间格式化为"刚刚"、"X分钟前"等
const formatTimeAgo = (time) => {
  if (!time) return ''
  try {
    const now = Date.now()
    const past = new Date(time).getTime()
    const diff = now - past
    
    const minute = 60 * 1000
    const hour = 60 * minute
    const day = 24 * hour
    
    if (diff < minute) return '刚刚'
    if (diff < hour) return `${Math.floor(diff / minute)}分钟前`
    if (diff < day) return `${Math.floor(diff / hour)}小时前`
    if (diff < 7 * day) return `${Math.floor(diff / day)}天前`
    
    const date = new Date(time)
    return `${date.getMonth() + 1}/${date.getDate()}`
  } catch (error) {
    return ''
  }
}
</script>

<style lang="scss" scoped>
.leave-list-page {
  min-height: 100vh;
  background: linear-gradient(180deg, #f5f7fa 0%, #ffffff 100%);
}

// ==================== 导航栏 ====================
.nav-bar {
  display: flex;
  align-items: center;
  padding: 16rpx 32rpx;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  box-shadow: 0 4rpx 24rpx rgba(102, 126, 234, 0.25);
}

.nav-left,
.nav-right {
  width: 72rpx;
  height: 72rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  backdrop-filter: blur(20rpx);
  transition: all 0.3s;

  &:active {
    transform: scale(0.9);
    background: rgba(255, 255, 255, 0.3);
  }
}

.nav-icon {
  font-size: 40rpx;
  font-weight: bold;
  color: white;
}

.nav-center {
  flex: 1;
  text-align: center;
  padding: 0 20rpx;
}

.nav-title {
  display: block;
  font-size: 36rpx;
  font-weight: bold;
  color: white;
  line-height: 1.3;
}

.nav-count {
  display: block;
  font-size: 22rpx;
  color: rgba(255, 255, 255, 0.85);
  margin-top: 4rpx;
}

// ==================== 筛选区域 ====================
.filter-section {
  padding: 24rpx 0;
  background: white;
}

.filter-scroll {
  white-space: nowrap;
  padding: 0 32rpx;
}

.filter-chip {
  display: inline-block;
  margin-right: 20rpx;
  transition: all 0.3s;

  &:active {
    transform: scale(0.95);
  }
}

.chip-content {
  display: flex;
  align-items: center;
  padding: 16rpx 28rpx;
  background: #f5f7fa;
  border-radius: 48rpx;
  border: 2rpx solid transparent;
  transition: all 0.3s;
}

.filter-active .chip-content {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  box-shadow: 0 6rpx 20rpx rgba(102, 126, 234, 0.3);
}

.chip-icon {
  font-size: 32rpx;
  margin-right: 12rpx;
}

.chip-label {
  font-size: 28rpx;
  font-weight: 500;
  color: #333;
}

.filter-active .chip-label {
  color: white;
}

.chip-badge {
  margin-left: 12rpx;
  padding: 4rpx 12rpx;
  background: rgba(0, 0, 0, 0.1);
  border-radius: 20rpx;
  font-size: 22rpx;
  font-weight: 600;
  color: #666;
}

.filter-active .chip-badge {
  background: rgba(255, 255, 255, 0.25);
  color: white;
}

// ==================== 搜索区域 ====================
.search-section {
  padding: 16rpx 32rpx;
  background: white;
}

.search-box {
  display: flex;
  align-items: center;
  height: 80rpx;
  padding: 0 32rpx;
  background: #f5f7fa;
  border-radius: 48rpx;
  transition: all 0.3s;

  &:focus-within {
    background: #eef2f7;
    box-shadow: 0 0 0 4rpx rgba(102, 126, 234, 0.1);
  }
}

.search-icon-left {
  font-size: 32rpx;
  margin-right: 16rpx;
}

.search-input {
  flex: 1;
  font-size: 28rpx;
  color: #333;
}

.search-clear {
  font-size: 40rpx;
  color: #999;
  padding: 0 8rpx;
  
  &:active {
    opacity: 0.6;
  }
}

// ==================== 内容滚动区 ====================
.content-scroll {
  overflow: hidden;
}

.refresh-indicator {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 30rpx;
}

.refresh-spinner {
  width: 32rpx;
  height: 32rpx;
  border: 3rpx solid #f0f0f0;
  border-top-color: #667eea;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  margin-right: 16rpx;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.refresh-text {
  font-size: 26rpx;
  color: #999;
}

// ==================== 列表容器 ====================
.list-container {
  padding: 0 32rpx 40rpx;
}

// 离校列表项
.leave-item {
  position: relative;
  background: white;
  border-radius: 24rpx;
  padding: 32rpx;
  margin-bottom: 24rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.06);
  transition: all 0.3s;
  animation: slideUp 0.5s ease-out backwards;

  &:active {
    transform: translateY(-4rpx);
    box-shadow: 0 8rpx 32rpx rgba(0, 0, 0, 0.12);
  }

  &.priority-high {
    border-left: 6rpx solid #ff6b6b;
  }

  &.priority-medium {
    border-left: 6rpx solid #ffa502;
  }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30rpx);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.overdue-flag {
  position: absolute;
  top: -8rpx;
  right: 32rpx;
  width: 64rpx;
  height: 64rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #ff6b6b, #ee5a6f);
  border-radius: 50%;
  box-shadow: 0 4rpx 16rpx rgba(255, 107, 107, 0.4);
  font-size: 32rpx;
  animation: pulse 1.5s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.1); }
}

// ==================== 卡片内容 ====================
.item-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24rpx;
}

.header-left {
  display: flex;
  align-items: center;
  flex: 1;
  min-width: 0;
}

.status-dot {
  width: 12rpx;
  height: 12rpx;
  border-radius: 50%;
  margin-right: 16rpx;
  flex-shrink: 0;

  &.dot-pending { background: #ffa502; }
  &.dot-approved { background: #4caf50; }
  &.dot-rejected { background: #f44336; }
  &.dot-cancelled { background: #95a5a6; }
  &.dot-away { background: #3498db; }
  &.dot-returned { background: #4caf50; }
  &.dot-overdue { background: #ff6b6b; }
}

.leave-id {
  font-size: 28rpx;
  font-weight: 600;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.status-tag {
  padding: 10rpx 20rpx;
  border-radius: 24rpx;
  font-size: 24rpx;
  font-weight: 600;
  white-space: nowrap;
  flex-shrink: 0;

  &.tag-pending { background: #fff4e6; color: #ff9500; }
  &.tag-approved { background: #e8f5e9; color: #4caf50; }
  &.tag-rejected { background: #ffebee; color: #f44336; }
  &.tag-cancelled { background: #f5f5f5; color: #999; }
  &.tag-away { background: #e3f2fd; color: #2196f3; }
  &.tag-returned { background: #e8f5e9; color: #4caf50; }
  &.tag-overdue { background: #ffebee; color: #ff6b6b; }
}

.item-body {
  margin-bottom: 20rpx;
}

.body-row {
  display: flex;
  align-items: center;
  margin-bottom: 16rpx;

  &:last-child {
    margin-bottom: 0;
  }
}

.destination-row {
  margin-bottom: 20rpx;
}

.row-icon {
  font-size: 28rpx;
  margin-right: 12rpx;
  flex-shrink: 0;
}

.row-text {
  font-size: 28rpx;
  color: #666;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.destination-text {
  font-size: 30rpx;
  font-weight: 600;
  color: #333;
}

.reason-text {
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  overflow: hidden;
  white-space: normal;
}

.time-section {
  display: flex;
  align-items: center;
  padding: 20rpx;
  background: linear-gradient(135deg, #f5f7fa, #eef2f7);
  border-radius: 16rpx;
  margin-bottom: 16rpx;
}

.time-row {
  flex: 1;
  display: flex;
  align-items: center;
}

.time-icon {
  font-size: 28rpx;
  margin-right: 12rpx;
  flex-shrink: 0;
}

.time-info {
  display: flex;
  flex-direction: column;
}

.time-label {
  font-size: 22rpx;
  color: #999;
  margin-bottom: 6rpx;
}

.time-value {
  font-size: 26rpx;
  color: #333;
  font-weight: 500;
}

.time-arrow {
  font-size: 28rpx;
  color: #667eea;
  margin: 0 16rpx;
  font-weight: bold;
  flex-shrink: 0;
}

.item-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-top: 20rpx;
  border-top: 1rpx solid #f5f7fa;
}

.footer-time {
  font-size: 24rpx;
  color: #999;
}

.footer-arrow {
  font-size: 40rpx;
  color: #d9d9d9;
  font-weight: bold;
}

// ==================== 操作按钮 ====================
.item-actions {
  margin-top: 24rpx;
  padding-top: 24rpx;
  border-top: 1rpx solid #f5f7fa;
}

.action-group {
  display: flex;
  gap: 16rpx;
}

.action-btn {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 72rpx;
  border-radius: 16rpx;
  font-size: 28rpx;
  font-weight: 600;
  transition: all 0.3s;

  &:active {
    transform: scale(0.96);
  }
}

.btn-icon {
  font-size: 32rpx;
  margin-right: 8rpx;
}

.btn-cancel {
  background: linear-gradient(135deg, #ff6b6b, #ee5a6f);
  color: white;
  box-shadow: 0 4rpx 16rpx rgba(255, 107, 107, 0.3);
}

.btn-return {
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  box-shadow: 0 4rpx 16rpx rgba(102, 126, 234, 0.3);
}

// ==================== 空状态 ====================
.empty-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 48rpx;
  text-align: center;
}

.empty-animation {
  width: 160rpx;
  height: 160rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
  border-radius: 50%;
  margin-bottom: 32rpx;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-16rpx); }
}

.empty-emoji {
  font-size: 80rpx;
}

.empty-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #333;
  margin-bottom: 16rpx;
}

.empty-desc {
  font-size: 26rpx;
  color: #999;
  margin-bottom: 48rpx;
}

.empty-action {
  padding: 24rpx 64rpx;
  background: linear-gradient(135deg, #667eea, #764ba2);
  border-radius: 48rpx;
  color: white;
  font-size: 28rpx;
  font-weight: 600;
  box-shadow: 0 8rpx 24rpx rgba(102, 126, 234, 0.3);

  &:active {
    transform: scale(0.95);
  }
}

// ==================== 加载状态 ====================
.loading-more,
.no-more {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40rpx;
  font-size: 26rpx;
  color: #999;
}

.loading-spinner {
  width: 28rpx;
  height: 28rpx;
  border: 3rpx solid #f0f0f0;
  border-top-color: #667eea;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  margin-right: 12rpx;
}

.loading-text {
  font-size: 26rpx;
  color: #999;
}
</style>








