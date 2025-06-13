<template>
  <view class="notice-swiper-container">
    <!-- 加载状态 -->
    <view v-if="loading" class="loading-container">
      <view class="loading-skeleton">
        <view class="skeleton-item"></view>
      </view>
    </view>
    
    <!-- 轮播图 -->
    <swiper 
      v-else-if="noticeList.length > 0"
      class="notice-swiper"
      :indicator-dots="true"
      :autoplay="true"
      :interval="4000"
      :duration="500"
      :circular="true"
      indicator-color="rgba(255, 255, 255, 0.5)"
      indicator-active-color="#ffffff"
      @change="onSwiperChange"
    >
      <swiper-item 
        v-for="(notice, index) in noticeList" 
        :key="notice.noticeId"
        class="swiper-item"
        @click="handleNoticeClick(notice)"
      >
        <view class="notice-card">
          <!-- 背景图片 -->
          <image 
            :src="getImageUrl(notice.coverImage)"
            class="notice-image"
            mode="aspectFill"
            :lazy-load="true"
            @error="handleImageError(index)"
          />
          
          <!-- 遮罩层 -->
          <view class="notice-overlay"></view>
          
          <!-- 内容区域 -->
          <view class="notice-content">
            <view class="notice-title">{{ notice.noticeTitle }}</view>
            <view class="notice-meta">
              <text class="notice-type">{{ getNoticeTypeText(notice.noticeType) }}</text>
              <text class="notice-time">{{ formatTime(notice.createTime) }}</text>
            </view>
          </view>
          
          <!-- 角标 -->
          <view class="notice-badge">
            <text class="badge-text">热门</text>
          </view>
        </view>
      </swiper-item>
    </swiper>
    
    <!-- 空状态 -->
    <view v-else class="empty-container">
      <image class="empty-image" src="/static/images/placeholder.svg" mode="aspectFit" />
      <text class="empty-text">暂无轮播内容</text>
    </view>
  </view>
</template>

<script>
import { listNotices } from '@/api/dorm/notices'

export default {
  name: 'NoticeSwiper',
  data() {
    return {
      loading: true,
      noticeList: [],
      currentIndex: 0,
      noticeTypes: {
        '0': '公告',
        '1': '通知',
        '2': '活动'
      }
    }
  },
  
  mounted() {
    this.loadNotices()
  },
  
  methods: {
    // 加载轮播图数据
    async loadNotices() {
      try {
        this.loading = true
        const params = {
          isCarousel: '1', // 只获取轮播图显示的通告
          status: '1', // 只获取已发布的通告
          pageNum: 1,
          pageSize: 10
        }
        
        const response = await listNotices(params)
        if (response.code === 200) {
          this.noticeList = response.rows || []
        } else {
          console.error('获取轮播图数据失败:', response.msg)
          uni.showToast({
            title: '获取数据失败',
            icon: 'none'
          })
        }
      } catch (error) {
        console.error('加载轮播图数据异常:', error)
        uni.showToast({
          title: '网络异常',
          icon: 'none'
        })
      } finally {
        this.loading = false
      }
    },
    
    // 处理图片URL
    getImageUrl(imageUrl) {
      if (!imageUrl) {
        return '/static/images/placeholder.svg'
      }

      // 如果是完整URL，直接返回
      if (imageUrl.startsWith('http')) {
        return imageUrl
      }

      // 拼接基础URL
      const baseUrl = this.$config?.baseUrl || 'http://localhost:8080'
      return baseUrl + imageUrl
    },
    
    // 处理图片加载失败
    handleImageError(index) {
      console.log('图片加载失败:', index)
      // 可以设置默认图片
      this.$set(this.noticeList[index], 'coverImage', '')
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
    
    // 轮播图切换事件
    onSwiperChange(e) {
      this.currentIndex = e.detail.current
    },
    
    // 点击通告跳转详情
    handleNoticeClick(notice) {
      uni.navigateTo({
        url: `/pages/notice/detail?id=${notice.noticeId}`
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.notice-swiper-container {
  width: 100%;
  margin: 20rpx;
  border-radius: 20rpx;
  overflow: hidden;
  box-shadow: 0 8rpx 30rpx rgba(0, 0, 0, 0.1);
}

.loading-container {
  height: 360rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f8f9fa;
  border-radius: 20rpx;
}

.loading-skeleton {
  width: 100%;
  height: 100%;
  position: relative;
  overflow: hidden;
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
}

.skeleton-item {
  width: 100%;
  height: 100%;
  border-radius: 20rpx;
}

@keyframes loading {
  0% {
    background-position: 200% 0;
  }
  100% {
    background-position: -200% 0;
  }
}

.notice-swiper {
  height: 360rpx;
  border-radius: 20rpx;
  overflow: hidden;
}

.swiper-item {
  height: 100%;
  border-radius: 20rpx;
  overflow: hidden;
}

.notice-card {
  position: relative;
  width: 100%;
  height: 100%;
  border-radius: 20rpx;
  overflow: hidden;
  cursor: pointer;
}

.notice-image {
  width: 100%;
  height: 100%;
  border-radius: 20rpx;
}

.notice-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(
    to bottom,
    rgba(0, 0, 0, 0.1) 0%,
    rgba(0, 0, 0, 0.3) 60%,
    rgba(0, 0, 0, 0.6) 100%
  );
  border-radius: 20rpx;
}

.notice-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 30rpx;
  color: white;
  z-index: 2;
}

.notice-title {
  font-size: 32rpx;
  font-weight: bold;
  line-height: 1.4;
  margin-bottom: 16rpx;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
  text-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.3);
}

.notice-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 24rpx;
  opacity: 0.9;
}

.notice-type {
  background: rgba(255, 255, 255, 0.2);
  padding: 8rpx 16rpx;
  border-radius: 20rpx;
  backdrop-filter: blur(10rpx);
}

.notice-time {
  opacity: 0.8;
}

.notice-badge {
  position: absolute;
  top: 20rpx;
  right: 20rpx;
  background: linear-gradient(135deg, #ff6b6b, #ff8e8e);
  border-radius: 20rpx;
  padding: 8rpx 16rpx;
  z-index: 3;
}

.badge-text {
  color: white;
  font-size: 20rpx;
  font-weight: bold;
}

.empty-container {
  height: 360rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #f8f9fa;
  border-radius: 20rpx;
}

.empty-image {
  width: 120rpx;
  height: 120rpx;
  opacity: 0.5;
  margin-bottom: 20rpx;
}

.empty-text {
  color: #999;
  font-size: 28rpx;
}

/* 自定义指示器样式 */
::v-deep .uni-swiper-dots {
  bottom: 20rpx !important;
}

::v-deep .uni-swiper-dot {
  width: 16rpx !important;
  height: 16rpx !important;
  border-radius: 50% !important;
  margin: 0 8rpx !important;
  transition: all 0.3s ease !important;
}

::v-deep .uni-swiper-dot-active {
  width: 32rpx !important;
  border-radius: 16rpx !important;
}
</style>
