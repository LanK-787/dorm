<template>
  <view class="page-container">
    <!-- 自定义导航栏 -->
    <view class="custom-navbar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="navbar-content">
        <view class="nav-left" @click="goBack">
          <text class="iconfont icon-back">‹</text>
        </view>
        <view class="nav-title">通告详情</view>
        <view class="nav-right">
          <text class="iconfont icon-share" @click="handleShare">⋯</text>
        </view>
      </view>
    </view>

    <!-- 内容区域 -->
    <scroll-view class="content-container" scroll-y="true">
      <!-- 加载状态 -->
      <view v-if="loading" class="loading-container">
        <view class="loading-skeleton">
          <view class="skeleton-title"></view>
          <view class="skeleton-meta"></view>
          <view class="skeleton-image"></view>
          <view class="skeleton-content"></view>
        </view>
      </view>

      <!-- 通告内容 -->
      <view v-else-if="noticeInfo" class="notice-detail">
        <!-- 头部信息 -->
        <view class="notice-header">
          <text class="notice-title">{{ noticeInfo.noticeTitle }}</text>
          <view class="notice-meta">
            <view class="meta-item">
              <text class="meta-label">类型：</text>
              <text class="meta-value">{{ getNoticeTypeText(noticeInfo.noticeType) }}</text>
            </view>
            <view class="meta-item">
              <text class="meta-label">发布时间：</text>
              <text class="meta-value">{{ formatTime(noticeInfo.createTime) }}</text>
            </view>
          </view>
        </view>

        <!-- 封面图片 -->
        <view v-if="noticeInfo.coverImage" class="notice-cover">
          <image 
            :src="getImageUrl(noticeInfo.coverImage)"
            class="cover-image"
            mode="aspectFill"
            @click="previewImage"
          />
        </view>

        <!-- 正文内容 -->
        <view class="notice-content">
          <rich-text :nodes="formatContent(noticeInfo.noticeContent)"></rich-text>
        </view>

        <!-- 底部操作 -->
        <view class="notice-actions">
          <view class="action-btn" :class="{ 'liked': isLiked, 'loading': likeLoading }" @click="handleLike">
            <text class="like-icon" :class="{ 'liked': isLiked }">{{ isLiked ? '❤️' : '🤍' }}</text>
            <text class="action-text" :class="{ 'liked': isLiked }">
              {{ isLiked ? '已赞' : '点赞' }}
              <text v-if="likeCount > 0" class="like-count">({{ likeCount }})</text>
            </text>
          </view>
          <view class="action-btn" @click="handleShare">
            <text class="iconfont icon-share">📤</text>
            <text class="action-text">分享</text>
          </view>
        </view>
      </view>

      <!-- 错误状态 -->
      <view v-else class="error-container">
        <image class="error-image" src="/static/images/placeholder.svg" mode="aspectFit" />
        <text class="error-text">通告不存在或已删除</text>
        <view class="error-btn" @click="goBack">
          <text class="btn-text">返回</text>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script>
import { getNotices, toggleLike, isUserLiked, getLikeCount } from '@/api/dorm/notices'

export default {
  data() {
    return {
      statusBarHeight: 0,
      loading: true,
      noticeInfo: null,
      noticeId: null,
      noticeTypes: {
        '0': '公告',
        '1': '通知',
        '2': '活动'
      },
      // 点赞相关数据
      isLiked: false,
      likeCount: 0,
      likeLoading: false
    }
  },

  onLoad(options) {
    this.noticeId = options.id
    this.initPage()
    this.loadNoticeDetail()
  },

  methods: {
    // 初始化页面
    initPage() {
      const systemInfo = uni.getSystemInfoSync()
      this.statusBarHeight = systemInfo.statusBarHeight || 0
    },

    // 加载通告详情
    async loadNoticeDetail() {
      if (!this.noticeId) {
        this.loading = false
        return
      }

      try {
        this.loading = true
        const response = await getNotices(this.noticeId)
        if (response.code === 200) {
          this.noticeInfo = response.data
          // 设置点赞数量
          this.likeCount = response.data.likeCount || 0
          // 加载用户点赞状态
          await this.loadLikeStatus()
        } else {
          console.error('获取通告详情失败:', response.msg)
          uni.showToast({
            title: '获取详情失败',
            icon: 'none'
          })
        }
      } catch (error) {
        console.error('加载通告详情异常:', error)
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
      return date.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
      })
    },

    // 格式化内容
    formatContent(content) {
      if (!content) return ''
      
      // 简单的HTML转换，实际项目中可能需要更复杂的处理
      return content.replace(/\n/g, '<br/>')
    },

    // 预览图片
    previewImage() {
      if (this.noticeInfo?.coverImage) {
        uni.previewImage({
          urls: [this.getImageUrl(this.noticeInfo.coverImage)]
        })
      }
    },

    // 返回上一页
    goBack() {
      uni.navigateBack()
    },

    // 点赞功能
    async handleLike() {
      if (this.likeLoading) return

      try {
        this.likeLoading = true
        const response = await toggleLike(this.noticeId)

        if (response.code === 200) {
          // 切换点赞状态
          this.isLiked = !this.isLiked

          // 更新点赞数量
          if (this.isLiked) {
            this.likeCount += 1
            uni.showToast({
              title: '点赞成功',
              icon: 'success'
            })
          } else {
            this.likeCount = Math.max(0, this.likeCount - 1)
            uni.showToast({
              title: '取消点赞',
              icon: 'success'
            })
          }
        } else {
          uni.showToast({
            title: response.msg || '操作失败',
            icon: 'none'
          })
        }
      } catch (error) {
        console.error('点赞操作失败:', error)
        uni.showToast({
          title: '网络异常',
          icon: 'none'
        })
      } finally {
        this.likeLoading = false
      }
    },

    // 加载用户点赞状态
    async loadLikeStatus() {
      try {
        const response = await isUserLiked(this.noticeId)
        if (response.code === 200) {
          this.isLiked = response.data
        }
      } catch (error) {
        console.error('获取点赞状态失败:', error)
      }
    },

    // 分享功能
    handleShare() {
      uni.showActionSheet({
        itemList: ['分享到微信', '分享到朋友圈', '复制链接'],
        success: (res) => {
          console.log('选择了第' + (res.tapIndex + 1) + '个按钮')
          uni.showToast({
            title: '分享功能开发中',
            icon: 'none'
          })
        }
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

.content-container {
  margin-top: 88rpx;
  padding: 30rpx;
}

.loading-container {
  padding: 30rpx;
}

.loading-skeleton {
  .skeleton-title {
    height: 60rpx;
    background: #e0e0e0;
    border-radius: 8rpx;
    margin-bottom: 20rpx;
    animation: skeleton-loading 1.5s infinite;
  }

  .skeleton-meta {
    height: 40rpx;
    width: 60%;
    background: #e0e0e0;
    border-radius: 8rpx;
    margin-bottom: 30rpx;
    animation: skeleton-loading 1.5s infinite;
  }

  .skeleton-image {
    height: 400rpx;
    background: #e0e0e0;
    border-radius: 16rpx;
    margin-bottom: 30rpx;
    animation: skeleton-loading 1.5s infinite;
  }

  .skeleton-content {
    height: 300rpx;
    background: #e0e0e0;
    border-radius: 8rpx;
    animation: skeleton-loading 1.5s infinite;
  }
}

@keyframes skeleton-loading {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.6; }
}

.notice-detail {
  background: white;
  border-radius: 20rpx;
  overflow: hidden;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}

.notice-header {
  padding: 40rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.notice-title {
  display: block;
  font-size: 40rpx;
  font-weight: bold;
  color: #333;
  line-height: 1.4;
  margin-bottom: 30rpx;
}

.notice-meta {
  .meta-item {
    display: flex;
    align-items: center;
    margin-bottom: 16rpx;
    
    &:last-child {
      margin-bottom: 0;
    }
  }

  .meta-label {
    color: #666;
    font-size: 28rpx;
    margin-right: 16rpx;
  }

  .meta-value {
    color: #333;
    font-size: 28rpx;
  }
}

.notice-cover {
  padding: 0 40rpx 40rpx;
}

.cover-image {
  width: 100%;
  height: 400rpx;
  border-radius: 16rpx;
}

.notice-content {
  padding: 0 40rpx 40rpx;
  
  ::v-deep rich-text {
    line-height: 1.6;
    font-size: 30rpx;
    color: #333;
  }
}

.notice-actions {
  display: flex;
  justify-content: center;
  gap: 60rpx;
  padding: 40rpx;
  border-top: 1rpx solid #f0f0f0;
}

.action-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20rpx;
  border-radius: 16rpx;
  transition: all 0.3s ease;

  &:active {
    transform: scale(0.95);
    background: #f8f9fa;
  }

  &.liked {
    background: #ffe6e6;
    transform: scale(1.05);
  }

  &.loading {
    opacity: 0.6;
    pointer-events: none;
  }
}

.action-btn .iconfont {
  font-size: 48rpx;
  margin-bottom: 12rpx;
}

.like-icon {
  font-size: 32rpx;
  margin-bottom: 12rpx;
  transition: all 0.3s ease;

  &.liked {
    animation: heartBeat 0.6s ease-in-out;
  }
}

.action-text {
  font-size: 24rpx;
  color: #666;
  transition: color 0.3s ease;

  &.liked {
    color: #ff4757;
    font-weight: bold;
  }
}

.like-count {
  font-size: 20rpx;
  margin-left: 4rpx;
}

@keyframes heartBeat {
  0% {
    transform: scale(1);
  }
  14% {
    transform: scale(1.3);
  }
  28% {
    transform: scale(1);
  }
  42% {
    transform: scale(1.3);
  }
  70% {
    transform: scale(1);
  }
}

.error-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 100rpx 40rpx;
  text-align: center;
}

.error-image {
  width: 200rpx;
  height: 200rpx;
  opacity: 0.5;
  margin-bottom: 40rpx;
}

.error-text {
  color: #999;
  font-size: 32rpx;
  margin-bottom: 60rpx;
}

.error-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 24rpx 60rpx;
  border-radius: 50rpx;
  font-size: 28rpx;
}

.btn-text {
  color: white;
}
</style>
