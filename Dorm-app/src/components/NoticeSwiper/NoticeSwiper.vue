<template>
  <view class="notice-swiper-container">
    <!-- 加载状态 -->
    <view v-if="loading" class="loading-container">
      <view class="loading-skeleton">
        <view class="skeleton-item">
          <view class="skeleton-shimmer"></view>
          <view class="skeleton-content">
            <view class="skeleton-title"></view>
            <view class="skeleton-meta">
              <view class="skeleton-tag"></view>
              <view class="skeleton-time"></view>
            </view>
          </view>
        </view>
      </view>
    </view>
    
    <!-- 轮播图 -->
    <swiper
      v-else-if="noticeList.length > 0"
      class="notice-swiper"
      :indicator-dots="true"
      :autoplay="true"
      :interval="5000"
      :duration="800"
      :circular="true"
      indicator-color="rgba(255, 255, 255, 0.3)"
      indicator-active-color="#ffffff"
      @change="onSwiperChange"
    >
      <swiper-item
        v-for="(notice, index) in noticeList"
        :key="notice.noticeId"
        class="swiper-item"
        @click="handleNoticeClick(notice)"
      >
        <view class="notice-card" :class="{ 'card-hover': isHovering === index }" @touchstart="handleTouchStart(index)" @touchend="handleTouchEnd">
          <!-- 背景图片 -->
          <image
            :src="getImageUrl(notice.coverImage)"
            class="notice-image"
            mode="aspectFill"
            :lazy-load="true"
            @error="handleImageError(index)"
          />

          <!-- 动态遮罩层 -->
          <view class="notice-overlay">
            <view class="overlay-gradient"></view>
            <view class="overlay-pattern"></view>
          </view>

          <!-- 装饰性元素 -->
          <view class="decorative-elements">
            <view class="floating-dot dot-1"></view>
            <view class="floating-dot dot-2"></view>
            <view class="floating-dot dot-3"></view>
          </view>

          <!-- 内容区域 -->
          <view class="notice-content">
            <view class="content-wrapper">
              <view class="notice-title">{{ notice.noticeTitle }}</view>
              <view class="notice-summary" v-if="notice.summary">{{ notice.summary }}</view>
              <view class="notice-meta">
                <view class="meta-left">
                  <text class="notice-type" :class="getNoticeTypeClass(notice.noticeType)">
                    <text class="type-icon">{{ getNoticeTypeIcon(notice.noticeType) }}</text>
                    {{ getNoticeTypeText(notice.noticeType) }}
                  </text>
                </view>
                <view class="meta-right">
                  <text class="notice-time">{{ formatTime(notice.createTime) }}</text>
                </view>
              </view>
            </view>
          </view>

          <!-- 增强的角标 -->
          <view class="notice-badge" :class="getBadgeClass(notice)">
            <view class="badge-inner">
              <text class="badge-icon">🔥</text>
              <text class="badge-text">{{ getBadgeText(notice) }}</text>
            </view>
            <view class="badge-glow"></view>
          </view>

          <!-- 点击波纹效果 -->
          <view class="ripple-effect" :class="{ 'ripple-active': rippleActive === index }"></view>
        </view>
      </swiper-item>
    </swiper>
    
    <!-- 增强的空状态 -->
    <view v-else class="empty-container">
      <view class="empty-content">
        <view class="empty-icon-wrapper">
          <view class="empty-icon">📢</view>
          <view class="empty-icon-bg"></view>
        </view>
        <text class="empty-title">暂无通知公告</text>
        <text class="empty-subtitle">精彩内容即将发布，敬请期待</text>
        <view class="empty-decoration">
          <view class="decoration-line"></view>
          <view class="decoration-dot"></view>
          <view class="decoration-line"></view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, reactive, onMounted, getCurrentInstance } from 'vue'
import { listNotices } from '@/api/dorm/notices'

// 获取当前实例
const { proxy } = getCurrentInstance()

// 响应式数据
const loading = ref(true)
const noticeList = ref([])
const currentIndex = ref(0)

// 通知类型映射
const noticeTypes = reactive({
  '0': '公告',
  '1': '通知',
  '2': '活动'
})

// 新增的响应式数据
const isHovering = ref(null)
const rippleActive = ref(null)

// 振动功能相关状态
const vibrationSupported = ref(false)
const userHasInteracted = ref(false)

// 扩展的通知类型映射
Object.assign(noticeTypes, {
  '3': '紧急',
  '4': '重要'
})

// 通知类型图标映射
const noticeTypeIcons = reactive({
  '0': '📋',
  '1': '📢',
  '2': '🎉',
  '3': '🚨',
  '4': '⭐'
})

// 方法定义
// 检测振动API支持
const checkVibrationSupport = () => {
  try {
    // 检查uni-app振动API是否存在
    if (typeof uni !== 'undefined' && uni.vibrateShort) {
      vibrationSupported.value = true
      return true
    }

    // 检查原生振动API是否存在（H5环境）
    if (typeof navigator !== 'undefined' && 'vibrate' in navigator) {
      vibrationSupported.value = true
      return true
    }

    vibrationSupported.value = false
    return false
  } catch (error) {
    console.debug('振动API检测失败:', error)
    vibrationSupported.value = false
    return false
  }
}

// 安全的振动调用函数
const safeVibrate = () => {
  // 检查是否支持振动
  if (!vibrationSupported.value) {
    return
  }

  // 检查用户是否已经有过交互
  if (!userHasInteracted.value) {
    console.debug('用户尚未进行有效交互，跳过振动')
    return
  }

  try {
    // 优先使用uni-app API
    if (typeof uni !== 'undefined' && uni.vibrateShort) {
      uni.vibrateShort({
        type: 'light',
        success: () => {
          console.debug('振动反馈成功')
        },
        fail: (err) => {
          console.debug('uni振动失败:', err.errMsg || err)
          // 尝试使用原生API作为备选
          fallbackVibrate()
        }
      })
    } else {
      // 使用原生振动API
      fallbackVibrate()
    }
  } catch (error) {
    console.debug('振动调用异常:', error)
  }
}

// 备选振动方案（原生API）
const fallbackVibrate = () => {
  try {
    if (typeof navigator !== 'undefined' && navigator.vibrate) {
      // 轻微振动 50ms
      navigator.vibrate(50)
      console.debug('原生振动反馈成功')
    }
  } catch (error) {
    console.debug('原生振动失败:', error)
  }
}

// 记录用户交互
const recordUserInteraction = () => {
  if (!userHasInteracted.value) {
    userHasInteracted.value = true
    console.debug('用户交互已记录')
  }
}

// 加载轮播图数据
const loadNotices = async () => {
  try {
    loading.value = true
    const params = {
      isCarousel: '1', // 只获取轮播图显示的通告
      status: '0', // 只获取已发布的通告（0=正常，1=关闭）
      pageNum: 1,
      pageSize: 10
    }

    const response = await listNotices(params)
    if (response.code === 200) {
      noticeList.value = response.rows || []
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
    loading.value = false
  }
}

// 处理图片URL
const getImageUrl = (imageUrl) => {
  if (!imageUrl) {
    return '/static/images/placeholder.svg'
  }

  // 如果是完整URL，直接返回
  if (imageUrl.startsWith('http')) {
    return imageUrl
  }

  // 拼接基础URL
  const baseUrl = proxy.$config?.baseUrl || 'http://localhost:8080'
  return baseUrl + imageUrl
}

// 处理图片加载失败
const handleImageError = (index) => {
  console.log('图片加载失败:', index)
  // 直接修改响应式数组
  noticeList.value[index].coverImage = ''
}

// 获取通告类型文本
const getNoticeTypeText = (type) => {
  return noticeTypes[type] || '公告'
}

// 获取通告类型图标
const getNoticeTypeIcon = (type) => {
  return noticeTypeIcons[type] || '📋'
}

// 获取通告类型样式类
const getNoticeTypeClass = (type) => {
  const classMap = {
    '0': 'type-announcement',
    '1': 'type-notice',
    '2': 'type-activity',
    '3': 'type-urgent',
    '4': 'type-important'
  }
  return classMap[type] || 'type-announcement'
}

// 获取角标文本
const getBadgeText = (notice) => {
  if (notice.isUrgent) return '紧急'
  if (notice.isImportant) return '重要'
  if (notice.isHot) return '热门'
  return '最新'
}

// 获取角标样式类
const getBadgeClass = (notice) => {
  if (notice.isUrgent) return 'badge-urgent'
  if (notice.isImportant) return 'badge-important'
  if (notice.isHot) return 'badge-hot'
  return 'badge-new'
}

// 处理触摸开始
const handleTouchStart = (index) => {
  // 记录用户交互（必须在真实的用户事件中调用）
  recordUserInteraction()

  isHovering.value = index
  rippleActive.value = index

  // 在用户交互事件中直接调用振动
  safeVibrate()
}

// 处理触摸结束
const handleTouchEnd = () => {
  setTimeout(() => {
    isHovering.value = null
    rippleActive.value = null
  }, 150)
}

// 格式化时间
const formatTime = (timeStr) => {
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
}

// 轮播图切换事件
const onSwiperChange = (e) => {
  currentIndex.value = e.detail.current
}

// 点击通告跳转详情
const handleNoticeClick = (notice) => {
  // 记录用户交互
  recordUserInteraction()

  uni.navigateTo({
    url: `/pages/notice/detail?id=${notice.noticeId}`
  })
}

// 生命周期钩子
onMounted(() => {
  // 检测振动API支持
  checkVibrationSupport()

  // 加载通知数据
  loadNotices()
})
</script>

<style lang="scss" scoped>
.notice-swiper-container {
  width: 100%;
  margin: 20rpx 0rpx 0rpx;
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
  line-clamp: 2;
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
