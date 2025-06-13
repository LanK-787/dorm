<template>
  <view class="page-container">
    <!-- 自定义导航栏 -->
    <view class="custom-navbar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="navbar-content">
        <view class="nav-left" @click="goBack">
          <text class="iconfont icon-back">‹</text>
        </view>
        <view class="nav-title">通知公告</view>
        <view class="nav-right">
          <text class="iconfont icon-search" @click="handleSearch">🔍</text>
        </view>
      </view>
    </view>

    <!-- 筛选栏 -->
    <view class="filter-bar">
      <scroll-view class="filter-scroll" scroll-x="true">
        <view class="filter-item" 
              :class="{ active: currentType === '' }"
              @click="filterByType('')">
          <text class="filter-text">全部</text>
        </view>
        <view class="filter-item" 
              :class="{ active: currentType === '0' }"
              @click="filterByType('0')">
          <text class="filter-text">公告</text>
        </view>
        <view class="filter-item" 
              :class="{ active: currentType === '1' }"
              @click="filterByType('1')">
          <text class="filter-text">通知</text>
        </view>
        <view class="filter-item" 
              :class="{ active: currentType === '2' }"
              @click="filterByType('2')">
          <text class="filter-text">活动</text>
        </view>
      </scroll-view>
    </view>

    <!-- 内容区域 -->
    <scroll-view 
      class="content-container" 
      scroll-y="true"
      @scrolltolower="loadMore"
      refresher-enabled
      @refresherrefresh="onRefresh"
      :refresher-triggered="refreshing"
    >
      <!-- 通告列表 -->
      <view class="notice-list">
        <view 
          v-for="(notice, index) in noticeList" 
          :key="notice.noticeId"
          class="notice-item"
          @click="goToDetail(notice)"
        >
          <view class="notice-content">
            <view class="notice-header">
              <text class="notice-title">{{ notice.noticeTitle }}</text>
              <view class="notice-badge" v-if="notice.isCarousel === '1'">
                <text class="badge-text">轮播</text>
              </view>
            </view>
            <view class="notice-meta">
              <text class="notice-type">{{ getNoticeTypeText(notice.noticeType) }}</text>
              <text class="notice-time">{{ formatTime(notice.createTime) }}</text>
            </view>
          </view>
          <image 
            v-if="notice.coverImage"
            :src="getImageUrl(notice.coverImage)"
            class="notice-thumb"
            mode="aspectFill"
          />
        </view>
      </view>

      <!-- 加载更多 -->
      <view v-if="hasMore" class="load-more">
        <text class="load-text">{{ loadingMore ? '加载中...' : '上拉加载更多' }}</text>
      </view>

      <!-- 没有更多 -->
      <view v-else-if="noticeList.length > 0" class="no-more">
        <text class="no-more-text">没有更多了</text>
      </view>

      <!-- 空状态 -->
      <view v-if="!loading && noticeList.length === 0" class="empty-container">
        <image class="empty-image" src="/static/images/placeholder.svg" mode="aspectFit" />
        <text class="empty-text">暂无通告</text>
      </view>
    </scroll-view>

    <!-- 加载状态 -->
    <view v-if="loading && noticeList.length === 0" class="loading-container">
      <view class="loading-skeleton">
        <view v-for="i in 5" :key="i" class="skeleton-item">
          <view class="skeleton-content">
            <view class="skeleton-title"></view>
            <view class="skeleton-meta"></view>
          </view>
          <view class="skeleton-thumb"></view>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { listNotices } from '@/api/dorm/notices'

export default {
  data() {
    return {
      statusBarHeight: 0,
      loading: false,
      refreshing: false,
      loadingMore: false,
      hasMore: true,
      currentType: '',
      noticeList: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        noticeType: '',
        status: '1' // 只显示已发布的
      },
      noticeTypes: {
        '0': '公告',
        '1': '通知',
        '2': '活动'
      }
    }
  },

  onLoad() {
    this.initPage()
    this.loadNoticeList()
  },

  methods: {
    // 初始化页面
    initPage() {
      const systemInfo = uni.getSystemInfoSync()
      this.statusBarHeight = systemInfo.statusBarHeight || 0
    },

    // 加载通告列表
    async loadNoticeList(isRefresh = false) {
      if (this.loading && !isRefresh) return

      try {
        if (isRefresh) {
          this.refreshing = true
          this.queryParams.pageNum = 1
          this.hasMore = true
        } else {
          this.loading = true
        }

        const response = await listNotices(this.queryParams)
        if (response.code === 200) {
          const newList = response.rows || []
          
          if (isRefresh) {
            this.noticeList = newList
          } else if (this.queryParams.pageNum === 1) {
            this.noticeList = newList
          } else {
            this.noticeList = [...this.noticeList, ...newList]
          }

          // 判断是否还有更多数据
          this.hasMore = newList.length >= this.queryParams.pageSize
        } else {
          uni.showToast({
            title: '获取数据失败',
            icon: 'none'
          })
        }
      } catch (error) {
        console.error('加载通告列表异常:', error)
        uni.showToast({
          title: '网络异常',
          icon: 'none'
        })
      } finally {
        this.loading = false
        this.refreshing = false
        this.loadingMore = false
      }
    },

    // 下拉刷新
    onRefresh() {
      this.loadNoticeList(true)
    },

    // 加载更多
    loadMore() {
      if (this.hasMore && !this.loadingMore && !this.loading) {
        this.loadingMore = true
        this.queryParams.pageNum++
        this.loadNoticeList()
      }
    },

    // 按类型筛选
    filterByType(type) {
      this.currentType = type
      this.queryParams.noticeType = type
      this.queryParams.pageNum = 1
      this.noticeList = []
      this.loadNoticeList()
    },

    // 处理图片URL
    getImageUrl(imageUrl) {
      if (!imageUrl) return ''
      
      if (imageUrl.startsWith('http')) {
        return imageUrl
      }
      
      const baseUrl = this.$config?.baseUrl || 'http://localhost:8080'
      return baseUrl + imageUrl
    },

    // 获取通告类型文本
    getNoticeTypeText(type) {
      return this.noticeTypes[type] || '公告'
    },

    // 格式化时间
    formatTime(timeStr) {
      if (!timeStr) return ''
      
      const date = new Date(timeStr)
      const now = new Date()
      const diff = now - date
      
      // 小于1天显示时分
      if (diff < 24 * 60 * 60 * 1000) {
        return date.toLocaleTimeString('zh-CN', { 
          hour: '2-digit', 
          minute: '2-digit' 
        })
      }
      
      // 大于1天显示月日
      return date.toLocaleDateString('zh-CN', { 
        month: '2-digit', 
        day: '2-digit' 
      })
    },

    // 跳转详情
    goToDetail(notice) {
      uni.navigateTo({
        url: `/pages/notice/detail?id=${notice.noticeId}`
      })
    },

    // 返回上一页
    goBack() {
      uni.navigateBack()
    },

    // 搜索功能
    handleSearch() {
      uni.showToast({
        title: '搜索功能开发中',
        icon: 'none'
      })
    }
  }
}
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

.nav-left, .nav-right {
  width: 80rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.nav-left .iconfont, .nav-right .iconfont {
  color: white;
  font-size: 36rpx;
  font-weight: bold;
}

.nav-title {
  flex: 1;
  text-align: center;
  color: white;
  font-size: 32rpx;
  font-weight: bold;
}

.filter-bar {
  position: fixed;
  top: 88rpx;
  left: 0;
  right: 0;
  background: white;
  border-bottom: 1rpx solid #f0f0f0;
  z-index: 999;
}

.filter-scroll {
  white-space: nowrap;
  padding: 20rpx 30rpx;
}

.filter-item {
  display: inline-block;
  padding: 16rpx 32rpx;
  margin-right: 20rpx;
  background: #f8f9fa;
  border-radius: 50rpx;
  transition: all 0.3s ease;

  &.active {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    
    .filter-text {
      color: white;
    }
  }
}

.filter-text {
  font-size: 28rpx;
  color: #666;
}

.content-container {
  margin-top: 148rpx;
  padding: 0 30rpx;
}

.notice-list {
  .notice-item {
    background: white;
    border-radius: 20rpx;
    padding: 30rpx;
    margin-bottom: 20rpx;
    display: flex;
    align-items: center;
    box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
    transition: all 0.3s ease;

    &:active {
      transform: scale(0.98);
    }
  }
}

.notice-content {
  flex: 1;
  margin-right: 20rpx;
}

.notice-header {
  display: flex;
  align-items: flex-start;
  margin-bottom: 16rpx;
}

.notice-title {
  flex: 1;
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.notice-badge {
  background: linear-gradient(135deg, #ff6b6b, #ff8e8e);
  color: white;
  padding: 4rpx 12rpx;
  border-radius: 12rpx;
  margin-left: 16rpx;
  flex-shrink: 0;
}

.badge-text {
  font-size: 20rpx;
  color: white;
}

.notice-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.notice-type {
  background: #f0f0f0;
  color: #666;
  padding: 8rpx 16rpx;
  border-radius: 16rpx;
  font-size: 24rpx;
}

.notice-time {
  color: #999;
  font-size: 24rpx;
}

.notice-thumb {
  width: 120rpx;
  height: 120rpx;
  border-radius: 16rpx;
  flex-shrink: 0;
}

.load-more, .no-more {
  text-align: center;
  padding: 40rpx;
}

.load-text, .no-more-text {
  color: #999;
  font-size: 28rpx;
}

.empty-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 100rpx 40rpx;
  text-align: center;
}

.empty-image {
  width: 200rpx;
  height: 200rpx;
  opacity: 0.5;
  margin-bottom: 40rpx;
}

.empty-text {
  color: #999;
  font-size: 32rpx;
}

.loading-container {
  padding: 30rpx;
}

.loading-skeleton {
  .skeleton-item {
    display: flex;
    align-items: center;
    background: white;
    border-radius: 20rpx;
    padding: 30rpx;
    margin-bottom: 20rpx;
  }

  .skeleton-content {
    flex: 1;
    margin-right: 20rpx;
  }

  .skeleton-title {
    height: 40rpx;
    background: #e0e0e0;
    border-radius: 8rpx;
    margin-bottom: 16rpx;
    animation: skeleton-loading 1.5s infinite;
  }

  .skeleton-meta {
    height: 24rpx;
    width: 60%;
    background: #e0e0e0;
    border-radius: 8rpx;
    animation: skeleton-loading 1.5s infinite;
  }

  .skeleton-thumb {
    width: 120rpx;
    height: 120rpx;
    background: #e0e0e0;
    border-radius: 16rpx;
    animation: skeleton-loading 1.5s infinite;
  }
}

@keyframes skeleton-loading {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.6; }
}
</style>
