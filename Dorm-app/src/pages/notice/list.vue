<template>
  <view class="page-container">
    <!-- 状态栏占位 -->
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>

    <!-- 自定义导航栏 -->
    <view class="custom-navbar">
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

    <!-- 内容区域 - 使用scroll-view配合动态加载优化 -->
    <scroll-view 
      class="content-container" 
      scroll-y="true"
      @scrolltolower="loadMore"
      refresher-enabled="true"
      refresher-default-style="black"
      refresher-background="#f8f9fa"
      @refresherrefresh="onRefresh"
      :refresher-triggered="refreshing"
      :style="{ height: contentHeight + 'px' }"
      @scroll="handleScroll"
      enhanced
      lower-threshold="100"
      scroll-with-animation
      :scroll-top="scrollTop"
    >
      <!-- 通告列表 -->
      <view class="notice-list">
        <view 
          v-for="(notice, index) in visibleNoticeList" 
          :key="notice.noticeId"
          class="notice-item"
          @click="goToDetail(notice)"
          v-memo="[notice.noticeId, notice.noticeTitle, notice.noticeType, notice.createTime]"
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
            lazy-load
            :lazy-load-strategy="1"
            :show-menu-by-longpress="false"
          />
          <view v-else class="notice-thumb-placeholder"></view>
        </view>
      </view>

      <!-- 加载更多 -->
      <view v-if="loadingMore" class="loading-more">
        <text class="loading-text">加载中...</text>
      </view>

      <!-- 没有更多数据 -->
      <view v-if="!hasMore && noticeList.length > 0" class="no-more">
        <text class="no-more-text">没有更多数据了</text>
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
      contentHeight: 0,
      loading: false,
      refreshing: false,
      loadingMore: false,
      hasMore: true,
      currentType: '',
      noticeList: [],
      visibleNoticeList: [], // 当前可见的列表项
      initialDisplayCount: 10, // 初始显示数量
      currentScrollPosition: 0, // 当前滚动位置
      scrollTop: 0, // 控制滚动位置，防止误触发刷新
      queryParams: {
        pageNum: 1,
        pageSize: 20, // 增加每页加载数量以减少请求次数
        noticeType: '',
        status: '0' // 只显示已发布的（0=正常，1=关闭）
      },
      noticeTypes: {
        '0': '公告',
        '1': '通知',
        '2': '活动'
      },
      // 预计算的时间格式缓存
      timeFormatCache: new Map()
    }
  },
  
  watch: {
    // 监听列表变化，更新可见列表
    noticeList: {
      handler(newList) {
        this.updateVisibleList()
      },
      immediate: true
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
      // 计算内容区域高度
      const navHeight = 88 // 导航栏高度
      const filterHeight = 60 // 筛选栏高度
      this.contentHeight = systemInfo.windowHeight - this.statusBarHeight - navHeight - filterHeight - 30 // 减去padding等
    },
    
    // 更新可见列表 - 初始只显示10条，通过上拉加载更多
    updateVisibleList() {
      // 初始只显示前10条，后续通过上拉加载更多来显示更多数据
      this.visibleNoticeList = this.noticeList
    },

    // 加载通告列表 - 优化性能和内存管理
    async loadNoticeList(isRefresh = false) {
      if (this.loading && !isRefresh) return

      try {
        if (isRefresh) {
          this.refreshing = true
          this.queryParams.pageNum = 1
          this.hasMore = true
          this.noticeList = []
          this.visibleNoticeList = []
          this.currentScrollPosition = 0
          // 清空缓存
          this.timeFormatCache.clear()
        } else {
          this.loading = true
        }

        const response = await listNotices(this.queryParams)
        if (response.code === 200) {
          const newList = response.rows || []
          
          // 优化数据处理，避免不必要的展开
          if (isRefresh || this.queryParams.pageNum === 1) {
            // 初始只显示前10条
            this.noticeList = newList.slice(0, this.initialDisplayCount)
          } else {
            // 上拉加载更多时，追加新数据
            Array.prototype.push.apply(this.noticeList, newList)
          }

          // 判断是否还有更多数据
          this.hasMore = newList.length === this.queryParams.pageSize
          this.queryParams.pageNum++
          
          // 更新可见列表
          this.updateVisibleList()
        } else {
          uni.showToast({
            title: '获取数据失败',
            icon: 'none',
            duration: 1500
          })
        }
      } catch (error) {
        console.error('加载通告列表异常:', error)
        uni.showToast({
          title: '网络异常',
          icon: 'none',
          duration: 1500
        })
      } finally {
        // 使用setTimeout避免阻塞UI
        setTimeout(() => {
          this.loading = false
          this.refreshing = false
          this.loadingMore = false
        }, 0)
      }
    },

    // 下拉刷新
    onRefresh() {
      // 只有在滚动到顶部时才允许刷新
      if (this.currentScrollPosition <= 5) {
        this.loadNoticeList(true)
      } else {
        // 如果不在顶部，取消刷新状态
        this.refreshing = false
      }
    },

    // 处理滚动事件，用于触发加载更多
    handleScroll(e) {
      this.currentScrollPosition = e.detail.scrollTop
      
      // 滚动到底部，触发加载更多
      if (e.detail.scrollTop + this.contentHeight > e.detail.scrollHeight - 200) {
        this.loadMore()
      }
    },

    // 加载更多 - 增强防抖和性能优化
    loadMore() {
      if (!this.hasMore || this.loadingMore || this.loading || this.loadMoreTimer) return

      this.loadMoreTimer = setTimeout(() => {
        this.loadingMore = true
        this.loadNoticeList()
        this.loadMoreTimer = null
      }, 300) // 防抖时间300ms
    },

    // 按类型筛选
    filterByType(type) {
      this.currentType = type
      this.queryParams.noticeType = type
      this.queryParams.pageNum = 1
      this.noticeList = []
      this.currentScrollPosition = 0
      // 清空缓存
      this.timeFormatCache.clear()
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

    // 格式化时间 - 优化性能和缓存管理
    formatTime(timeStr) {
      if (!timeStr) return ''
      
      // 使用缓存避免重复计算
      if (this.timeFormatCache.has(timeStr)) {
        return this.timeFormatCache.get(timeStr)
      }
      
      try {
        const date = new Date(timeStr)
        
        // 检查是否为有效日期
        if (isNaN(date.getTime())) return ''
        
        const now = new Date()
        const diff = now - date
        
        let result
        // 小于1天显示时分
        if (diff < 24 * 60 * 60 * 1000) {
          result = date.toLocaleTimeString('zh-CN', { 
            hour: '2-digit', 
            minute: '2-digit' 
          })
        } else {
          // 大于1天显示月日
          result = date.toLocaleDateString('zh-CN', { 
            month: '2-digit', 
            day: '2-digit' 
          })
        }
        
        // 限制缓存大小，避免内存占用过高
        if (this.timeFormatCache.size > 100) {
          const firstKey = this.timeFormatCache.keys().next().value
          this.timeFormatCache.delete(firstKey)
        }
        
        // 缓存结果
        this.timeFormatCache.set(timeStr, result)
        return result
      } catch (error) {
        console.error('时间格式化错误:', error)
        return ''
      }
    },

    // 跳转详情 - 优化性能和交互
    goToDetail(notice) {
      if (!notice || !notice.noticeId) {
        uni.showToast({
          title: '通告ID不存在',
          icon: 'none',
          duration: 1500
        })
        return
      }
      
      // 使用setTimeout避免阻塞UI
      setTimeout(() => {
        uni.navigateTo({
          url: `/pages/notice/detail?id=${notice.noticeId}`,
          animationType: 'pop-in',
          animationDuration: 200
        })
      }, 30)
    },

    // 返回上一页 - 优化性能
    goBack() {
      setTimeout(() => {
        uni.navigateBack({
          delta: 1,
          animationDuration: 200
        })
      }, 30)
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

.status-bar {
  background: transparent;
}

.custom-navbar {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20rpx 30rpx;
}

.navbar-content {
  height: 88rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
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
  background: white;
  border-bottom: 1rpx solid #f0f0f0;
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
  flex: 1;
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
  background: #f0f0f0;
  transition: opacity 0.3s ease;
}

.notice-thumb-placeholder {
  width: 120rpx;
  height: 120rpx;
  border-radius: 16rpx;
  flex-shrink: 0;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  animation: placeholder-pulse 1.5s infinite;
}

@keyframes placeholder-pulse {
  0% { opacity: 0.6; }
  50% { opacity: 0.8; }
  100% { opacity: 0.6; }
}

.loading-more, .no-more {
  text-align: center;
  padding: 40rpx 0;
}

.loading-text, .no-more-text {
  color: #999;
  font-size: 28rpx;
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
