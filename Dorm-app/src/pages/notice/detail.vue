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
          <text class="iconfont icon-share" @click="handleShare"></text>
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
            mode="widthFix"
            @click="previewImage"
            lazy-load
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
            <text class="iconfont icon-share"></text>
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

  // 微信小程序分享配置
  onShareAppMessage() {
    if (!this.noticeInfo) {
      return {
        title: '宿舍通知',
        path: `/pages/notice/detail?id=${this.noticeId}`
      }
    }

    const shareTitle = this.noticeInfo.noticeTitle || '宿舍通知'
    const shareContent = this.getShareContent()
    const shareImageUrl = this.noticeInfo.coverImage ? this.getImageUrl(this.noticeInfo.coverImage) : ''

    return {
      title: shareTitle,
      path: `/pages/notice/detail?id=${this.noticeId}`,
      imageUrl: shareImageUrl || '/static/logo.png'
    }
  },

  // 微信小程序分享到朋友圈配置
  onShareTimeline() {
    if (!this.noticeInfo) {
      return {
        title: '宿舍通知'
      }
    }

    const shareTitle = this.noticeInfo.noticeTitle || '宿舍通知'
    const shareImageUrl = this.noticeInfo.coverImage ? this.getImageUrl(this.noticeInfo.coverImage) : ''

    return {
      title: shareTitle,
      query: `id=${this.noticeId}`,
      imageUrl: shareImageUrl || '/static/logo.png'
    }
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

    // 格式化时间 - 移动端友好显示
    formatTime(timeStr) {
      if (!timeStr) return ''
      
      try {
        const date = new Date(timeStr)
        
        // 检查是否为有效日期
        if (isNaN(date.getTime())) return ''
        
        // 格式化为 YYYY-MM-DD HH:mm 格式，移动端更清晰易读
        const year = date.getFullYear()
        const month = String(date.getMonth() + 1).padStart(2, '0')
        const day = String(date.getDate()).padStart(2, '0')
        const hour = String(date.getHours()).padStart(2, '0')
        const minute = String(date.getMinutes()).padStart(2, '0')
        
        return `${year}-${month}-${day} ${hour}:${minute}`
      } catch (error) {
        console.error('时间格式化错误:', error)
        return ''
      }
    },

    // 格式化内容 - 处理图片自适应
    formatContent(content) {
      if (!content) return ''
      
      let html = content
      
      // 处理换行
      html = html.replace(/\n/g, '<br/>')
      
      // 处理图片标签：统一处理URL和样式
      html = html.replace(/<img([^>]*?)>/gi, (match, attrs) => {
        // 提取src属性
        const srcMatch = attrs.match(/src=["']([^"']*?)["']/i)
        let src = srcMatch ? srcMatch[1] : ''
        
        // 处理图片URL，确保使用完整的URL
        if (src) {
          src = this.getImageUrl(src)
        }
        
        // 处理style属性
        let styleValue = 'max-width:100%;width:100%;height:auto;display:block;margin:20rpx 0;border-radius:8rpx;'
        if (attrs.includes('style=')) {
          const styleMatch = attrs.match(/style=["']([^"']*?)["']/i)
          if (styleMatch) {
            const existingStyle = styleMatch[1]
            // 保留原有样式，但确保包含自适应样式
            styleValue = existingStyle
            if (!styleValue.includes('max-width')) {
              styleValue += ';max-width:100%'
            }
            if (!styleValue.includes('width:100%')) {
              styleValue += ';width:100%'
            }
            if (!styleValue.includes('height:auto') && !styleValue.includes('height: auto')) {
              styleValue += ';height:auto'
            }
            if (!styleValue.includes('display:block')) {
              styleValue += ';display:block'
            }
          }
        }
        
        // 移除原有的src和style属性，重新构建
        let newAttrs = attrs
          .replace(/src=["'][^"']*?["']/gi, '')
          .replace(/style=["'][^"']*?["']/gi, '')
          .trim()
        
        // 构建新的img标签
        return `<img src="${src}" style="${styleValue}" ${newAttrs}>`.replace(/\s+/g, ' ').trim()
      })
      
      return html
    },

    // 获取所有图片URL（用于预览）
    getAllImageUrls() {
      const imageUrls = []
      
      // 添加封面图片
      if (this.noticeInfo?.coverImage) {
        imageUrls.push(this.getImageUrl(this.noticeInfo.coverImage))
      }
      
      // 从正文内容中提取所有图片URL
      if (this.noticeInfo?.noticeContent) {
        const imgRegex = /<img[^>]+src=["']([^"']+)["'][^>]*>/gi
        let match
        const content = this.noticeInfo.noticeContent
        
        while ((match = imgRegex.exec(content)) !== null) {
          const imgSrc = match[1]
          if (imgSrc) {
            const imgUrl = this.getImageUrl(imgSrc)
            // 避免重复
            if (!imageUrls.includes(imgUrl)) {
              imageUrls.push(imgUrl)
            }
          }
        }
      }
      
      return imageUrls
    },
    
    // 预览图片
    previewImage() {
      const imageUrls = this.getAllImageUrls()
      if (imageUrls.length > 0) {
        uni.previewImage({
          urls: imageUrls,
          current: imageUrls[0] // 从封面图片开始预览
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
      if (!this.noticeInfo) {
        uni.showToast({
          title: '通知信息加载中',
          icon: 'none'
        })
        return
      }

      // 准备分享内容
      const shareTitle = this.noticeInfo.noticeTitle || '宿舍通知'
      const shareContent = this.getShareContent()
      const shareImageUrl = this.noticeInfo.coverImage ? this.getImageUrl(this.noticeInfo.coverImage) : ''

      // 根据平台显示不同的分享选项
      let itemList = []

      // #ifdef MP-WEIXIN
      // 微信小程序环境：支持微信分享
      itemList = ['分享给微信好友', '复制分享内容', '复制通知标题', '保存封面图片']
      // #endif

      // #ifdef H5
      // H5环境：检测是否在微信浏览器中
      const isWeChat = /MicroMessenger/i.test(navigator.userAgent)
      itemList = isWeChat
        ? ['分享给微信好友', '复制分享内容', '复制通知标题', '保存封面图片']
        : ['复制分享内容', '复制通知标题', '保存封面图片']
      // #endif

      // #ifdef APP-PLUS
      // App环境：支持微信分享（需要配置微信SDK）
      itemList = ['分享给微信好友', '分享到朋友圈', '复制分享内容', '复制通知标题', '保存封面图片']
      // #endif

      // #ifndef MP-WEIXIN || H5 || APP-PLUS
      // 其他平台：只支持复制和保存
      itemList = ['复制分享内容', '复制通知标题', '保存封面图片']
      // #endif

      // 显示分享选项
      uni.showActionSheet({
        itemList: itemList,
        success: (res) => {
          const selectedOption = itemList[res.tapIndex]

          switch (selectedOption) {
            case '分享给微信好友':
              this.shareToWechat(shareTitle, shareContent, shareImageUrl, 'WXSceneSession')
              break
            case '分享到朋友圈':
              this.shareToWechat(shareTitle, shareContent, shareImageUrl, 'WXSceneTimeline')
              break
            case '复制分享内容':
              this.copyShareContent(shareTitle, shareContent)
              break
            case '复制通知标题':
              this.copyToClipboard(shareTitle, '标题已复制')
              break
            case '保存封面图片':
              if (shareImageUrl) {
                this.saveImageToAlbum(shareImageUrl)
              } else {
                uni.showToast({
                  title: '该通知没有封面图片',
                  icon: 'none'
                })
              }
              break
          }
        },
        fail: (err) => {
          console.log('用户取消分享', err)
        }
      })
    },

    // 分享到微信
    shareToWechat(title, content, imageUrl, scene = 'WXSceneSession') {
      // #ifdef MP-WEIXIN
      // 微信小程序：使用按钮的 open-type="share" 或者 onShareAppMessage
      // 这里我们触发页面的分享功能
      this.triggerWechatMiniProgramShare(title, content, imageUrl)
      // #endif

      // #ifdef H5
      // H5环境：使用微信JS-SDK
      this.shareToWechatH5(title, content, imageUrl, scene)
      // #endif

      // #ifdef APP-PLUS
      // App环境：使用uni.share API
      this.shareToWechatApp(title, content, imageUrl, scene)
      // #endif

      // #ifndef MP-WEIXIN || H5 || APP-PLUS
      // 其他平台：降级到复制分享内容
      uni.showToast({
        title: '当前平台不支持微信分享',
        icon: 'none'
      })
      this.copyShareContent(title, content)
      // #endif
    },

    // 微信小程序分享
    triggerWechatMiniProgramShare(title, content, imageUrl) {
      // 微信小程序需要通过 onShareAppMessage 实现分享
      // 这里我们提示用户使用右上角的分享按钮
      uni.showModal({
        title: '分享提示',
        content: '请点击右上角的"..."按钮，选择"转发"分享给好友',
        showCancel: false,
        confirmText: '我知道了'
      })

      // 同时复制分享内容，方便用户粘贴
      this.copyShareContent(title, content)
    },

    // H5微信分享
    shareToWechatH5(title, content, imageUrl, scene) {
      // 检测是否在微信浏览器中
      const isWeChat = /MicroMessenger/i.test(navigator.userAgent)

      if (!isWeChat) {
        uni.showToast({
          title: '请在微信中打开',
          icon: 'none'
        })
        return
      }

      // H5环境需要配置微信JS-SDK
      // 这里提示用户使用微信自带的分享功能
      uni.showModal({
        title: '分享提示',
        content: '请点击右上角的"..."按钮，选择"发送给朋友"或"分享到朋友圈"',
        showCancel: false,
        confirmText: '我知道了'
      })

      // 同时复制分享内容
      this.copyShareContent(title, content)
    },

    // App微信分享
    shareToWechatApp(title, content, imageUrl, scene) {
      // 构建分享链接（App环境可能没有window对象）
      let shareUrl = ''
      // #ifdef H5
      shareUrl = window.location.href
      // #endif
      // #ifndef H5
      // App环境使用配置的基础URL
      const baseUrl = this.$config?.baseUrl || 'http://localhost:8080'
      shareUrl = `${baseUrl}/pages/notice/detail?id=${this.noticeId}`
      // #endif

      uni.share({
        provider: 'weixin',
        scene: scene, // WXSceneSession: 分享到聊天界面, WXSceneTimeline: 分享到朋友圈
        type: 0, // 0: 图文分享
        title: title,
        summary: content,
        imageUrl: imageUrl || '/static/logo.png',
        href: shareUrl,
        success: (res) => {
          console.log('分享成功:', res)
          uni.showToast({
            title: '分享成功',
            icon: 'success'
          })
        },
        fail: (err) => {
          console.error('分享失败:', err)

          // 如果是用户取消，不显示错误
          if (err.errMsg && err.errMsg.includes('cancel')) {
            return
          }

          // 其他错误，降级到复制分享内容
          uni.showModal({
            title: '分享失败',
            content: '微信分享功能暂不可用，已为您复制分享内容',
            showCancel: false,
            success: () => {
              this.copyShareContent(title, content)
            }
          })
        }
      })
    },

    // 获取分享内容摘要
    getShareContent() {
      if (!this.noticeInfo?.noticeContent) return ''

      // 移除HTML标签，获取纯文本
      let content = this.noticeInfo.noticeContent
        .replace(/<[^>]+>/g, '') // 移除HTML标签
        .replace(/&nbsp;/g, ' ') // 替换空格实体
        .replace(/&lt;/g, '<')
        .replace(/&gt;/g, '>')
        .replace(/&amp;/g, '&')
        .replace(/&quot;/g, '"')
        .replace(/\s+/g, ' ') // 合并多个空格
        .trim()

      // 限制长度，生成摘要
      const maxLength = 100
      if (content.length > maxLength) {
        content = content.substring(0, maxLength) + '...'
      }

      return content
    },

    // 复制分享内容（标题 + 内容摘要）
    copyShareContent(title, content) {
      const shareText = `【${this.getNoticeTypeText(this.noticeInfo.noticeType)}】${title}\n\n${content}\n\n发布时间：${this.formatTime(this.noticeInfo.createTime)}`

      this.copyToClipboard(shareText, '分享内容已复制到剪贴板')
    },

    // 复制到剪贴板
    copyToClipboard(text, successMsg = '复制成功') {
      // #ifdef H5
      // H5环境使用浏览器API
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text)
          .then(() => {
            uni.showToast({
              title: successMsg,
              icon: 'success'
            })
          })
          .catch((err) => {
            console.error('复制失败:', err)
            this.fallbackCopyToClipboard(text, successMsg)
          })
      } else {
        this.fallbackCopyToClipboard(text, successMsg)
      }
      // #endif

      // #ifndef H5
      // 非H5环境使用uni-app API
      uni.setClipboardData({
        data: text,
        success: () => {
          uni.showToast({
            title: successMsg,
            icon: 'success'
          })
        },
        fail: (err) => {
          console.error('复制失败:', err)
          uni.showToast({
            title: '复制失败，请重试',
            icon: 'none'
          })
        }
      })
      // #endif
    },

    // H5降级方案：使用传统方法复制
    fallbackCopyToClipboard(text, successMsg) {
      const textArea = document.createElement('textarea')
      textArea.value = text
      textArea.style.position = 'fixed'
      textArea.style.top = '-9999px'
      textArea.style.left = '-9999px'
      document.body.appendChild(textArea)
      textArea.focus()
      textArea.select()

      try {
        const successful = document.execCommand('copy')
        if (successful) {
          uni.showToast({
            title: successMsg,
            icon: 'success'
          })
        } else {
          throw new Error('复制命令执行失败')
        }
      } catch (err) {
        console.error('降级复制方案失败:', err)
        uni.showToast({
          title: '复制失败，请手动复制',
          icon: 'none'
        })
      } finally {
        document.body.removeChild(textArea)
      }
    },

    // 保存图片到相册
    saveImageToAlbum(imageUrl) {
      uni.showLoading({
        title: '保存中...'
      })

      // #ifdef H5
      // H5环境：下载图片
      this.downloadImage(imageUrl)
      // #endif

      // #ifndef H5
      // 非H5环境：保存到相册
      uni.downloadFile({
        url: imageUrl,
        success: (res) => {
          if (res.statusCode === 200) {
            uni.saveImageToPhotosAlbum({
              filePath: res.tempFilePath,
              success: () => {
                uni.hideLoading()
                uni.showToast({
                  title: '图片已保存到相册',
                  icon: 'success'
                })
              },
              fail: (err) => {
                uni.hideLoading()
                console.error('保存图片失败:', err)

                // 可能是权限问题
                if (err.errMsg.includes('auth')) {
                  uni.showModal({
                    title: '需要相册权限',
                    content: '请在设置中允许访问相册',
                    confirmText: '去设置',
                    success: (modalRes) => {
                      if (modalRes.confirm) {
                        uni.openSetting()
                      }
                    }
                  })
                } else {
                  uni.showToast({
                    title: '保存失败，请重试',
                    icon: 'none'
                  })
                }
              }
            })
          } else {
            uni.hideLoading()
            uni.showToast({
              title: '图片下载失败',
              icon: 'none'
            })
          }
        },
        fail: (err) => {
          uni.hideLoading()
          console.error('下载图片失败:', err)
          uni.showToast({
            title: '下载失败，请重试',
            icon: 'none'
          })
        }
      })
      // #endif
    },

    // H5环境下载图片
    downloadImage(imageUrl) {
      // 创建一个隐藏的a标签来触发下载
      const link = document.createElement('a')
      link.href = imageUrl
      link.download = `notice_cover_${this.noticeId}.jpg`
      link.target = '_blank'

      // 对于跨域图片，尝试使用fetch下载
      fetch(imageUrl)
        .then(response => response.blob())
        .then(blob => {
          const url = window.URL.createObjectURL(blob)
          link.href = url
          document.body.appendChild(link)
          link.click()
          document.body.removeChild(link)
          window.URL.revokeObjectURL(url)

          uni.hideLoading()
          uni.showToast({
            title: '图片已下载',
            icon: 'success'
          })
        })
        .catch(err => {
          console.error('H5下载图片失败:', err)
          // 降级方案：直接打开图片
          window.open(imageUrl, '_blank')
          uni.hideLoading()
          uni.showToast({
            title: '请右键保存图片',
            icon: 'none'
          })
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
  max-width: 100%;
  height: auto;
  border-radius: 16rpx;
  display: block;
}

.notice-content {
  padding: 0 40rpx 40rpx;
  
  ::v-deep rich-text {
    line-height: 1.8;
    font-size: 30rpx;
    color: #333;
    word-wrap: break-word;
    word-break: break-all;
    
    // 确保图片自适应
    img {
      max-width: 100% !important;
      width: 100% !important;
      height: auto !important;
      display: block !important;
      margin: 20rpx 0 !important;
      border-radius: 8rpx;
      box-sizing: border-box;
    }
    
    // 处理其他内容
    p {
      margin: 20rpx 0;
      line-height: 1.8;
    }
    
    // 处理视频等媒体
    video {
      max-width: 100% !important;
      width: 100% !important;
      height: auto !important;
    }
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
