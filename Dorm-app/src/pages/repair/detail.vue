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
          <text>报修详情</text>
        </view>
      </view>
    </view>

    <!-- 主要内容区域 -->
    <scroll-view class="main-content" scroll-y="true">
      <view v-if="loading" class="loading-container">
        <text class="loading-text">加载中...</text>
      </view>

      <view v-else-if="repairDetail" class="detail-container">
        <!-- 状态卡片 -->
        <view class="status-card">
          <view class="status-header">
            <view class="status-badge" :class="getStatusClass(isRepairer ? repairDetail.processStatus : repairDetail.status)">
              <text class="status-text">{{ getStatusText(isRepairer ? repairDetail.processStatus : repairDetail.status) }}</text>
            </view>
            <text class="request-no">工单号：{{ repairDetail.requestNo }}</text>
          </view>
          <text class="create-time">
            {{ isRepairer ? '派单时间：' : '申请时间：' }}{{ formatTime(isRepairer ? repairDetail.assignTime : repairDetail.createTime) }}
          </text>
        </view>

        <!-- 基本信息 -->
        <view class="info-card">
          <view class="card-title">
            <text class="title-text">基本信息</text>
          </view>
          <view class="info-list">
            <view class="info-item">
              <text class="info-label">报修宿舍</text>
              <text class="info-value">{{ repairDetail.dormName || '未知宿舍' }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">报修项目</text>
              <text class="info-value">{{ getSpecialtyText(repairDetail.specialty) }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">报修人</text>
              <text class="info-value">{{ repairDetail.reporterName }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">联系方式</text>
              <text class="info-value">{{ repairDetail.contactPhone }}</text>
            </view>
          </view>
        </view>

        <!-- 问题描述 -->
        <view class="info-card">
          <view class="card-title">
            <text class="title-text">问题描述</text>
          </view>
          <view class="description-content">
            <text class="description-text">{{ repairDetail.description }}</text>
          </view>
        </view>

        <!-- 图片展示 -->
        <view v-if="imageList.length > 0" class="info-card">
          <view class="card-title">
            <text class="title-text">相关图片</text>
          </view>
          <view class="image-grid">
            <view 
              v-for="(image, index) in imageList" 
              :key="index"
              class="image-item"
              @click="previewImage(index)"
            >
              <image :src="image" mode="aspectFill" class="image-content" />
            </view>
          </view>
        </view>

        <!-- 处理进度 -->
        <view v-if="repairDetail.status !== '0'" class="info-card">
          <view class="card-title">
            <text class="title-text">处理进度</text>
          </view>
          <view class="progress-list">
            <!-- 提交申请 -->
            <view class="progress-item active">
              <view class="progress-dot"></view>
              <view class="progress-content">
                <text class="progress-title">提交申请</text>
                <text class="progress-time">{{ formatTime(repairDetail.createTime) }}</text>
              </view>
            </view>

            <!-- 已派单 -->
            <view v-if="['1', '2', '3'].includes(repairDetail.status)" class="progress-item active">
              <view class="progress-dot"></view>
              <view class="progress-content">
                <text class="progress-title">已派单</text>
                <text class="progress-time">{{ formatTime(repairDetail.updateTime) }}</text>
              </view>
            </view>

            <!-- 维修中 -->
            <view v-if="['2', '3'].includes(repairDetail.status)" class="progress-item active">
              <view class="progress-dot"></view>
              <view class="progress-content">
                <text class="progress-title">维修中</text>
                <text class="progress-time">{{ formatTime(repairDetail.updateTime) }}</text>
              </view>
            </view>

            <!-- 已完成 -->
            <view v-if="repairDetail.status === '3'" class="progress-item active">
              <view class="progress-dot"></view>
              <view class="progress-content">
                <text class="progress-title">已完成</text>
                <text class="progress-time">{{ formatTime(repairDetail.updateTime) }}</text>
              </view>
            </view>

            <!-- 已取消 -->
            <view v-if="repairDetail.status === '4'" class="progress-item cancelled">
              <view class="progress-dot"></view>
              <view class="progress-content">
                <text class="progress-title">已取消</text>
                <text class="progress-time">{{ formatTime(repairDetail.updateTime) }}</text>
              </view>
            </view>
          </view>
        </view>

        <!-- 操作按钮 -->
        <view v-if="['0', '1'].includes(repairDetail.status)" class="action-section">
          <view class="action-btn cancel-btn" @click="cancelRepair">
            <text class="btn-text">取消报修</text>
          </view>
        </view>
      </view>

      <view v-else class="error-container">
        <text class="error-text">加载失败，请重试</text>
        <view class="retry-btn" @click="loadDetail">
          <text class="retry-text">重新加载</text>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { getRequest, updateRequest } from '@/api/dorm/request'
import { getAssignmentDetail } from '@/api/repairer/workorder'
import useUserStore from '@/store/modules/user'

// 响应式数据
const statusBarHeight = ref(0)
const loading = ref(true)
const repairDetail = ref(null)
const imageList = ref([])

// 获取用户store
const userStore = useUserStore()

// 页面参数（使用 onLoad 安全获取）
const requestId = ref('')
const assignmentId = ref('')

onLoad((options) => {
  // 学生查看：id；维修查看：assignmentId
  if (options) {
    if (options.id) requestId.value = options.id
    if (options.assignmentId) assignmentId.value = options.assignmentId
  }
})

// 计算属性：判断是否为维修人员
const isRepairer = computed(() => {
  return userStore.roles && userStore.roles.includes('repairer')
})

// 报修项目映射
const specialtyMap = {
  '0': '电工',
  '1': '水工',
  '2': '木工',
  '3': '水泥工'
}

// 学生报修状态映射
const statusMap = {
  '0': '待派单',
  '1': '已派单',
  '2': '维修中',
  '3': '已完成',
  '4': '已取消',
  '5': '等待人工派单'
}

// 维修人员工单状态映射
const workOrderStatusMap = {
  '0': '待处理',
  '1': '处理中',
  '2': '已完成',
  '3': '已拒绝'
}

// 方法定义
const initPage = () => {
  const systemInfo = uni.getSystemInfoSync()
  statusBarHeight.value = systemInfo.statusBarHeight || 0

  // 根据用户角色检查参数
  if (isRepairer.value && assignmentId.value) {
    loadDetail()
  } else if (!isRepairer.value && requestId.value) {
    loadDetail()
  } else {
    uni.showToast({
      title: '参数错误',
      icon: 'none'
    })
    setTimeout(() => {
      uni.navigateBack()
    }, 1500)
  }
}

const loadDetail = async () => {
  try {
    loading.value = true
    let response

    if (isRepairer.value) {
      // 维修人员查看工单详情
      response = await getAssignmentDetail(assignmentId.value)
    } else {
      // 学生查看报修详情
      response = await getRequest(requestId.value)
    }

    if (response.code === 200) {
      repairDetail.value = response.data

      // 处理图片列表
      if (repairDetail.value.images) {
        imageList.value = repairDetail.value.images.split(',').filter(url => url.trim())
      }
    } else {
      uni.showToast({
        title: response.msg || '加载失败',
        icon: 'none'
      })
    }
  } catch (error) {
    console.error('加载详情失败:', error)
    uni.showToast({
      title: '网络异常',
      icon: 'none'
    })
  } finally {
    loading.value = false
  }
}

const cancelRepair = async () => {
  uni.showModal({
    title: '确认取消',
    content: '确定要取消这个报修申请吗？',
    success: async (res) => {
      if (res.confirm) {
        try {
          const response = await updateRequest({
            ...repairDetail.value,
            status: '4'
          })
          if (response.code === 200) {
            uni.showToast({
              title: '取消成功',
              icon: 'success'
            })
            loadDetail() // 重新加载详情
          } else {
            uni.showToast({
              title: response.msg || '取消失败',
              icon: 'none'
            })
          }
        } catch (error) {
          console.error('取消报修失败:', error)
          uni.showToast({
            title: '操作失败',
            icon: 'none'
          })
        }
      }
    }
  })
}

const previewImage = (index) => {
  uni.previewImage({
    urls: imageList.value,
    current: index
  })
}

const getSpecialtyText = (specialty) => {
  if (!specialty) return '未知'
  const specialties = specialty.split(',')
  return specialties.map(s => specialtyMap[s] || '未知').join('、')
}

const getStatusText = (status) => {
  if (isRepairer.value) {
    return workOrderStatusMap[status] || '未知'
  } else {
    return statusMap[status] || '未知'
  }
}

const getStatusClass = (status) => {
  if (isRepairer.value) {
    // 维修人员工单状态样式
    const classMap = {
      '0': 'status-pending',      // 待处理
      '1': 'status-processing',   // 处理中
      '2': 'status-completed',    // 已完成
      '3': 'status-rejected'      // 已拒绝
    }
    return classMap[status] || 'status-pending'
  } else {
    // 学生报修状态样式
    const classMap = {
      '0': 'status-pending',      // 待派单
      '1': 'status-assigned',     // 已派单
      '2': 'status-processing',   // 维修中
      '3': 'status-completed',    // 已完成
      '4': 'status-cancelled',    // 已取消
      '5': 'status-manual'        // 等待人工派单
    }
    return classMap[status] || 'status-pending'
  }
}

const formatTime = (time) => {
  if (!time) return ''
  const date = new Date(time)
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`
}

const goBack = () => {
  uni.navigateBack()
}

// 生命周期钩子
onMounted(() => {
  initPage()
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

.custom-navbar {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20rpx 30rpx;
}

.navbar-content {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 88rpx;
  position: relative;
}

.navbar-left {
  position: absolute;
  left: 0;
  width: 80rpx;
  height: 80rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  backdrop-filter: blur(10rpx);
}

.navbar-left .iconfont {
  color: white;
  font-size: 36rpx;
  font-weight: bold;
}

.navbar-title {
  text-align: center;
}

.navbar-title text {
  color: white;
  font-size: 36rpx;
  font-weight: bold;
}

.main-content {
  flex: 1;
  padding: 30rpx;
}

.loading-container, .error-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 100rpx 40rpx;
  text-align: center;
}

.loading-text, .error-text {
  font-size: 32rpx;
  color: #666;
  margin-bottom: 40rpx;
}

.retry-btn {
  padding: 20rpx 40rpx;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50rpx;
}

.retry-text {
  color: white;
  font-size: 28rpx;
}

.detail-container {
  display: flex;
  flex-direction: column;
  gap: 30rpx;
}

.status-card, .info-card {
  background: white;
  border-radius: 20rpx;
  padding: 40rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}

.status-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.status-badge {
  padding: 12rpx 24rpx;
  border-radius: 20rpx;
  font-size: 24rpx;
}

.status-pending {
  background: #fff3cd;
  color: #856404;
}

.status-assigned {
  background: #cce5ff;
  color: #004085;
}

.status-processing {
  background: #d1ecf1;
  color: #0c5460;
}

.status-completed {
  background: #d4edda;
  color: #155724;
}

.status-cancelled {
  background: #f8d7da;
  color: #721c24;
}

.status-rejected {
  background: #f8d7da;
  color: #721c24;
}

.status-manual {
  background: #fff3cd;
  color: #856404;
}

.request-no {
  font-size: 28rpx;
  color: #666;
}

.create-time {
  font-size: 26rpx;
  color: #999;
}

.card-title {
  margin-bottom: 30rpx;
}

.card-title .title-text {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.info-list {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}

.info-item {
  display: flex;
  align-items: center;
  font-size: 28rpx;
}

.info-label {
  color: #666;
  min-width: 140rpx;
}

.info-value {
  color: #333;
  flex: 1;
}

.description-content {
  padding: 30rpx;
  background: #f8f9fa;
  border-radius: 15rpx;
}

.description-text {
  font-size: 28rpx;
  color: #333;
  line-height: 1.6;
}

.image-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20rpx;
}

.image-item {
  aspect-ratio: 1;
  border-radius: 15rpx;
  overflow: hidden;
}

.image-content {
  width: 100%;
  height: 100%;
}

.progress-list {
  position: relative;
}

.progress-item {
  display: flex;
  align-items: flex-start;
  padding: 20rpx 0;
  position: relative;
}

.progress-item:not(:last-child)::after {
  content: '';
  position: absolute;
  left: 20rpx;
  top: 60rpx;
  width: 2rpx;
  height: 60rpx;
  background: #e0e0e0;
}

.progress-item.active:not(:last-child)::after {
  background: #667eea;
}

.progress-dot {
  width: 40rpx;
  height: 40rpx;
  border-radius: 50%;
  background: #e0e0e0;
  margin-right: 30rpx;
  flex-shrink: 0;
}

.progress-item.active .progress-dot {
  background: #667eea;
}

.progress-item.cancelled .progress-dot {
  background: #dc3545;
}

.progress-content {
  flex: 1;
}

.progress-title {
  display: block;
  font-size: 28rpx;
  color: #333;
  margin-bottom: 8rpx;
}

.progress-time {
  font-size: 24rpx;
  color: #999;
}

.action-section {
  margin-top: 40rpx;
}

.action-btn {
  width: 100%;
  height: 100rpx;
  border-radius: 50rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.cancel-btn {
  background: #f8d7da;
  border: 2rpx solid #f5c6cb;
}

.cancel-btn:active {
  transform: scale(0.98);
  background: #f1b0b7;
}

.btn-text {
  font-size: 32rpx;
  font-weight: bold;
  color: #721c24;
}

/* 图标字体样式 */
.iconfont {
  font-family: 'iconfont';
}

.icon-back::before {
  content: '‹';
}
</style>
