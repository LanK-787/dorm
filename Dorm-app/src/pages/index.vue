<template>
  <view class="page-container">
    <!-- 状态栏占位 -->
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>

    <!-- 头部区域 -->
    <view class="header">
      <view class="header-content">
        <view class="welcome-section">
          <text class="welcome-text">欢迎回来</text>
          <text class="app-name">智慧宿舍</text>
        </view>
        <view class="header-actions">
          <view class="search-btn" @click="handleSearch">
            <text class="iconfont icon-search"></text>
          </view>
        </view>
      </view>
    </view>

    <!-- 主要内容区域 -->
    <scroll-view class="main-content" scroll-y="true" @scrolltolower="onReachBottom">
      <!-- 轮播图区域 -->
      <view class="swiper-section">
        <NoticeSwiper />
      </view>

      <!-- 快捷功能区域 -->
      <view class="quick-actions">
        <view class="section-title">
          <text class="title-text">快捷功能</text>
        </view>
        <view class="actions-grid">
          <view class="action-item" @click="navigateTo('/pages/notice/list')">
            <view class="action-icon notice-icon">
              <text class="iconfont icon-notice"></text>
            </view>
            <text class="action-text">通知公告</text>
          </view>
          <view class="action-item" @click="navigateTo('/pages/dorm/info')">
            <view class="action-icon dorm-icon">
              <text class="iconfont icon-home"></text>
            </view>
            <text class="action-text">宿舍信息</text>
          </view>
          <view class="action-item" @click="navigateTo('/pages/repair/list')">
            <view class="action-icon repair-icon">
              <text class="iconfont icon-tool"></text>
              <!-- 维修人员未读工单提醒 -->
              <view v-if="isRepairer && unreadCount > 0" class="badge">
                <text class="badge-text">{{ unreadCount > 99 ? '99+' : unreadCount }}</text>
              </view>
            </view>
            <text class="action-text">{{ isRepairer ? '工单处理' : '报修服务' }}</text>
          </view>
          <view class="action-item" @click="handleLeaveRegistration" @longpress="handleLeaveRecords">
            <view class="action-icon leave-icon">
              <text class="iconfont icon-leave"></text>
            </view>
            <text class="action-text">离校登记</text>
          </view>
        </view>
      </view>

      <!-- 最新动态区域 -->
      <view class="latest-news">
        <view class="section-title">
          <text class="title-text">最新动态</text>
          <text class="more-text" @click="navigateTo('/pages/notice/list')">查看更多</text>
        </view>
        <view class="news-list">
          <!-- 加载状态 -->
          <view v-if="newsLoading" class="news-loading">
            <text class="loading-text">加载中...</text>
          </view>
          <!-- 数据列表 -->
          <view v-else-if="newsList.length > 0">
            <view v-for="(item, index) in newsList" :key="item.id || index" class="news-item" @click="handleNewsClick(item)">
              <view class="news-content">
                <text class="news-title">{{ item.title }}</text>
                <text class="news-time">{{ item.time }}</text>
              </view>
              <view class="news-arrow">
                <text class="iconfont icon-arrow-right"></text>
              </view>
            </view>
          </view>
          <!-- 空状态 -->
          <view v-else class="news-empty">
            <text class="empty-text">暂无最新动态</text>
          </view>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import NoticeSwiper from '@/components/NoticeSwiper/NoticeSwiper.vue'
import { getUnreadCount } from '@/api/repairer/workorder'
import { listNotices } from '@/api/dorm/notices'
import useUserStore from '@/store/modules/user'

// 获取用户store
const userStore = useUserStore()

// 响应式数据
const statusBarHeight = ref(0)
const unreadCount = ref(0)
const newsList = ref([])
const newsLoading = ref(false)

// 计算属性：判断是否为维修人员
const isRepairer = computed(() => {
  return userStore.roles && userStore.roles.includes('repairer')
})

// 计算属性：判断是否为学生
const isStudent = computed(() => {
  return userStore.roles && userStore.roles.includes('student')
})

// 方法定义
// 初始化页面
const initPage = () => {
  // 获取状态栏高度
  const systemInfo = uni.getSystemInfoSync()
  statusBarHeight.value = systemInfo.statusBarHeight || 0
}

// 刷新数据
const refreshData = async () => {
  // 刷新最新动态等数据
  await loadLatestNews()

  // 如果是维修人员，获取未读工单数量
  if (isRepairer.value) {
    await loadUnreadCount()
  }
}

// 加载最新动态
const loadLatestNews = async () => {
  try {
    newsLoading.value = true
    const params = {
      pageNum: 1,
      pageSize: 5, // 只获取最新的5条
      status: '0' // 只获取已发布的（0=正常，1=关闭）
    }
    
    const response = await listNotices(params)
    if (response.code === 200) {
      let list = response.rows || []
      
      // 确保按创建时间倒序排序（最新的在前）
      list.sort((a, b) => {
        const timeA = new Date(a.createTime || 0).getTime()
        const timeB = new Date(b.createTime || 0).getTime()
        return timeB - timeA
      })
      
      // 格式化数据
      newsList.value = list.map(item => ({
        id: item.noticeId,
        title: item.noticeTitle || '',
        time: formatNewsTime(item.createTime)
      }))
    } else {
      console.error('获取最新动态失败:', response.msg)
      // 失败时保持空数组，不显示错误提示（首页不应该因为一个小模块失败而报错）
      newsList.value = []
    }
  } catch (error) {
    console.error('加载最新动态异常:', error)
    // 异常时保持空数组
    newsList.value = []
  } finally {
    newsLoading.value = false
  }
}

// 格式化新闻时间
const formatNewsTime = (timeStr) => {
  if (!timeStr) return ''
  
  try {
    const date = new Date(timeStr)
    // 检查日期是否有效
    if (isNaN(date.getTime())) {
      return timeStr
    }
    
    const now = new Date()
    const diff = now.getTime() - date.getTime()
    
    // 如果时间差为负数（未来时间），直接返回日期
    if (diff < 0) {
      const month = date.getMonth() + 1
      const day = date.getDate()
      return `${month}-${day}`
    }
    
    const seconds = Math.floor(diff / 1000)
    const minutes = Math.floor(seconds / 60)
    const hours = Math.floor(minutes / 60)
    const days = Math.floor(hours / 24)
    
    // 如果是今天，显示相对时间
    if (days === 0) {
      if (hours === 0) {
        if (minutes === 0) {
          return '刚刚'
        }
        return `${minutes}分钟前`
      }
      return `${hours}小时前`
    }
    
    // 如果是昨天
    if (days === 1) {
      return '昨天'
    }
    
    // 如果是一周内
    if (days < 7) {
      return `${days}天前`
    }
    
    // 超过一周，显示月-日
    const month = date.getMonth() + 1
    const day = date.getDate()
    return `${month}-${day}`
  } catch (error) {
    console.error('格式化时间失败:', error)
    return timeStr
  }
}

// 获取未读工单数量
const loadUnreadCount = async () => {
  try {
    const response = await getUnreadCount()
    if (response.code === 200) {
      unreadCount.value = response.data || 0
    }
  } catch (error) {
    console.error('获取未读工单数量失败:', error)
  }
}

// 搜索功能
const handleSearch = () => {
  uni.navigateTo({
    url: '/pages/search/index'
  })
}

// 页面导航
const navigateTo = (url) => {
  uni.navigateTo({
    url: url
  })
}

// 点击新闻项
const handleNewsClick = (item) => {
  uni.navigateTo({
    url: `/pages/notice/detail?id=${item.id}`
  })
}

// 处理离校登记功能
const handleLeaveRegistration = () => {
  // 检查用户角色权限
  if (!isStudent.value) {
    uni.showToast({
      title: '此功能仅限学生使用',
      icon: 'none',
      duration: 2000
    })
    return
  }

  // 跳转到离校记录列表页面
  uni.navigateTo({
    url: '/pages/leave/list'
  })
}

// 处理离校记录查看功能（长按触发）
const handleLeaveRecords = () => {
  // 检查用户角色权限
  if (!isStudent.value) {
    uni.showToast({
      title: '此功能仅限学生使用',
      icon: 'none',
      duration: 2000
    })
    return
  }

  // 显示操作选择
  uni.showActionSheet({
    itemList: ['查看离校记录', '新建离校申请'],
    success: (res) => {
      if (res.tapIndex === 0) {
        // 查看离校记录
        uni.navigateTo({
          url: '/pages/leave/list'
        })
      } else if (res.tapIndex === 1) {
        // 新建离校申请
        uni.navigateTo({
          url: '/pages/leave/registration'
        })
      }
    }
  })
}

// 滚动到底部
const onReachBottom = () => {
  console.log('到达底部，可以加载更多数据')
}

// 生命周期钩子
onMounted(() => {
  initPage()
  refreshData()
})

// uni-app 页面生命周期钩子
const onShow = () => {
  // 页面显示时刷新数据
  refreshData()
}

// 导出页面生命周期钩子
defineExpose({
  onShow
})
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background: linear-gradient(180deg, #f8f9fa 0%, #ffffff 100%);
}

.status-bar {
  background: transparent;
}

.header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20rpx 30rpx 40rpx;
  border-radius: 0 0 40rpx 40rpx;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.welcome-section {
  flex: 1;
}

.welcome-text {
  display: block;
  color: rgba(255, 255, 255, 0.8);
  font-size: 28rpx;
  margin-bottom: 8rpx;
}

.app-name {
  color: white;
  font-size: 40rpx;
  font-weight: bold;
}

.header-actions {
  display: flex;
  align-items: center;
}

.search-btn {
  width: 80rpx;
  height: 80rpx;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  backdrop-filter: blur(10rpx);
}

.search-btn .iconfont {
  color: white;
  font-size: 32rpx;
}

.main-content {
  flex: 1;
  padding: 0 30rpx;
  margin-top: -20rpx;
}

.swiper-section {
  margin-bottom: 40rpx;
}

.quick-actions {
  margin-bottom: 40rpx;
}

.section-title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
}

.title-text {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
}

.more-text {
  font-size: 28rpx;
  color: #666;
}

.actions-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 30rpx;
}

.action-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 30rpx 20rpx;
  background: white;
  border-radius: 20rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.action-item:active {
  transform: scale(0.95);
}

.action-icon {
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 16rpx;
  position: relative;
}

.notice-icon {
  background: linear-gradient(135deg, #ff6b6b, #ff8e8e);
}

.dorm-icon {
  background: linear-gradient(135deg, #4ecdc4, #44a08d);
}

.repair-icon {
  background: linear-gradient(135deg, #feca57, #ff9ff3);
}

.leave-icon {
  background: linear-gradient(135deg, #74b9ff, #0984e3);
}

.action-icon .iconfont {
  color: white;
  font-size: 36rpx;
}

.action-text {
  font-size: 24rpx;
  color: #666;
  text-align: center;
}

.badge {
  position: absolute;
  top: -8rpx;
  right: -8rpx;
  min-width: 32rpx;
  height: 32rpx;
  background: #ff4757;
  border-radius: 16rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2rpx solid white;
}

.badge-text {
  color: white;
  font-size: 20rpx;
  font-weight: bold;
  line-height: 1;
  padding: 0 6rpx;
}

.latest-news {
  margin-bottom: 40rpx;
}

.news-list {
  background: white;
  border-radius: 20rpx;
  overflow: hidden;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}

.news-item {
  display: flex;
  align-items: center;
  padding: 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
  transition: background-color 0.3s ease;
}

.news-item:last-child {
  border-bottom: none;
}

.news-item:active {
  background-color: #f8f9fa;
}

.news-content {
  flex: 1;
}

.news-title {
  display: block;
  font-size: 30rpx;
  color: #333;
  margin-bottom: 8rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.news-time {
  font-size: 24rpx;
  color: #999;
}

.news-arrow {
  margin-left: 20rpx;
}

.news-arrow .iconfont {
  color: #ccc;
  font-size: 24rpx;
}

.news-loading,
.news-empty {
  padding: 60rpx 30rpx;
  text-align: center;
}

.loading-text,
.empty-text {
  font-size: 28rpx;
  color: #999;
}

/* 图标字体样式 */
.iconfont {
  font-family: 'iconfont';
}

/* 如果没有图标字体，使用文字替代 */
.icon-search::before {
  content: '🔍';
}

.icon-notice::before {
  content: '📢';
}

.icon-home::before {
  content: '🏠';
}

.icon-tool::before {
  content: '🔧';
}

.icon-user::before {
  content: '👤';
}

.icon-leave::before {
  content: '🚪';
}

.icon-arrow-right::before {
  content: '›';
}
</style>
