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
            </view>
            <text class="action-text">报修服务</text>
          </view>
          <view class="action-item" @click="navigateTo('/pages/user/profile')">
            <view class="action-icon profile-icon">
              <text class="iconfont icon-user"></text>
            </view>
            <text class="action-text">个人中心</text>
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
          <view v-for="(item, index) in newsList" :key="index" class="news-item" @click="handleNewsClick(item)">
            <view class="news-content">
              <text class="news-title">{{ item.title }}</text>
              <text class="news-time">{{ item.time }}</text>
            </view>
            <view class="news-arrow">
              <text class="iconfont icon-arrow-right"></text>
            </view>
          </view>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script>
import NoticeSwiper from '@/components/NoticeSwiper/NoticeSwiper.vue'

export default {
  components: {
    NoticeSwiper
  },

  data() {
    return {
      statusBarHeight: 0,
      newsList: [
        {
          id: 1,
          title: '关于宿舍卫生检查的通知',
          time: '2024-01-15'
        },
        {
          id: 2,
          title: '春节放假安排及注意事项',
          time: '2024-01-14'
        },
        {
          id: 3,
          title: '宿舍网络维护公告',
          time: '2024-01-13'
        }
      ]
    }
  },

  onLoad() {
    this.initPage()
  },

  onShow() {
    // 页面显示时刷新数据
    this.refreshData()
  },

  methods: {
    // 初始化页面
    initPage() {
      // 获取状态栏高度
      const systemInfo = uni.getSystemInfoSync()
      this.statusBarHeight = systemInfo.statusBarHeight || 0
    },

    // 刷新数据
    refreshData() {
      // 这里可以刷新最新动态等数据
      console.log('刷新首页数据')
    },

    // 搜索功能
    handleSearch() {
      uni.navigateTo({
        url: '/pages/search/index'
      })
    },

    // 页面导航
    navigateTo(url) {
      uni.navigateTo({
        url: url
      })
    },

    // 点击新闻项
    handleNewsClick(item) {
      uni.navigateTo({
        url: `/pages/notice/detail?id=${item.id}`
      })
    },

    // 滚动到底部
    onReachBottom() {
      console.log('到达底部，可以加载更多数据')
    }
  }
}
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

.profile-icon {
  background: linear-gradient(135deg, #a8edea, #fed6e3);
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

.icon-arrow-right::before {
  content: '›';
}
</style>
