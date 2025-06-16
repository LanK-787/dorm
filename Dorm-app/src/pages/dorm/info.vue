<template>
  <view class="page-container">
    <!-- 状态栏占位 -->
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>

    <!-- 自定义导航栏 -->
    <view class="custom-navbar">
      <view class="navbar-content">
        <view class="navbar-left" @click="goBack">
          <text class="iconfont icon-arrow-left"></text>
        </view>
        <view class="navbar-title">
          <text>宿舍信息</text>
        </view>
        <view class="navbar-right"></view>
      </view>
    </view>

    <!-- 主要内容区域 -->
    <scroll-view class="main-content" scroll-y="true">
      <!-- 加载状态 -->
      <view v-if="loading" class="loading-container">
        <view class="loading-spinner"></view>
        <text class="loading-text">加载中...</text>
      </view>

      <!-- 错误状态 -->
      <view v-else-if="error" class="error-container">
        <view class="error-icon">
          <text class="iconfont icon-error"></text>
        </view>
        <text class="error-text">{{ error }}</text>
        <view class="retry-btn" @click="loadData">
          <text>重试</text>
        </view>
      </view>

      <!-- 宿舍信息内容 -->
      <view v-else class="content-container">
        <!-- 宿舍基本信息卡片 -->
        <view class="info-card dorm-info-card">
          <view class="card-header">
            <view class="header-icon">
              <text class="iconfont icon-home"></text>
            </view>
            <text class="header-title">宿舍基本信息</text>
          </view>
          <view class="card-content">
            <view class="info-row">
              <text class="info-label">宿舍号</text>
              <text class="info-value">{{ dormInfo.buildingName || '-' }}</text>
            </view>
            <view class="info-row">
              <text class="info-label">完整地址</text>
              <text class="info-value">{{ dormInfo.fullName || '-' }}</text>
            </view>
            <view class="info-row">
              <text class="info-label">宿舍容量</text>
              <text class="info-value">{{ dormInfo.maxCapacity || 0 }}人</text>
            </view>
            <view class="info-row">
              <text class="info-label">当前入住</text>
              <text class="info-value capacity-info">
                <text class="current-count">{{ dormInfo.currentCount || 0 }}</text>
                <text class="separator">/</text>
                <text class="total-count">{{ dormInfo.maxCapacity || 0 }}</text>
                <text class="unit">人</text>
              </text>
            </view>
            <view class="info-row">
              <text class="info-label">宿舍状态</text>
              <view class="status-badge" :class="getStatusClass(dormInfo.status)">
                <text>{{ getStatusText(dormInfo.status) }}</text>
              </view>
            </view>
            <view v-if="dormInfo.dormManager" class="info-row">
              <text class="info-label">宿管员</text>
              <text class="info-value">{{ dormInfo.dormManager }}</text>
            </view>
            <view v-if="dormInfo.phone" class="info-row">
              <text class="info-label">联系电话</text>
              <text class="info-value phone-number" @click="makeCall(dormInfo.phone)">
                {{ dormInfo.phone }}
              </text>
            </view>
          </view>
        </view>

        <!-- 入住学生信息卡片 -->
        <view class="info-card students-card">
          <view class="card-header">
            <view class="header-icon">
              <text class="iconfont icon-user-group"></text>
            </view>
            <text class="header-title">入住学生</text>
            <view class="student-count">
              <text>{{ students.length }}人</text>
            </view>
          </view>
          
          <!-- 学生列表 -->
          <view v-if="students.length > 0" class="students-list">
            <view v-for="(student, index) in students" :key="student.studentId" class="student-item">
              <view class="student-avatar">
                <text class="avatar-text">{{ getAvatarText(student.name) }}</text>
              </view>
              <view class="student-info">
                <view class="student-name">{{ student.name }}</view>
                <view class="student-details">
                  <text class="student-no">学号：{{ student.studentNo }}</text>
                  <view class="gender-tag" :class="student.gender === '0' ? 'male' : 'female'">
                    <text>{{ student.gender === '0' ? '男' : '女' }}</text>
                  </view>
                </view>
                <view v-if="student.className" class="student-class">
                  <text>班级：{{ student.className }}</text>
                </view>
              </view>
              <view v-if="student.phone" class="contact-btn" @click="makeCall(student.phone)">
                <text class="iconfont icon-phone"></text>
              </view>
            </view>
          </view>

          <!-- 空状态 -->
          <view v-else class="empty-state">
            <view class="empty-icon">
              <text class="iconfont icon-empty"></text>
            </view>
            <text class="empty-text">暂无入住学生</text>
            <text class="empty-desc">该宿舍目前没有学生入住</text>
          </view>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getDormInfo, getDormStudents, getCurrentUserDorm, getDormManagerInfo } from '@/api/dorm/info.js'

// 响应式数据
const statusBarHeight = ref(0)
const loading = ref(true)
const error = ref('')
const dormInfo = ref({})
const students = ref([])

// 方法定义
// 初始化页面
const initPage = () => {
  // 获取状态栏高度
  const systemInfo = uni.getSystemInfoSync()
  statusBarHeight.value = systemInfo.statusBarHeight || 0
}

// 返回上一页
const goBack = () => {
  uni.navigateBack()
}

// 加载数据
const loadData = async () => {
  loading.value = true
  error.value = ''

  try {
    // 获取当前用户的学生信息
    const studentResponse = await getCurrentUserDorm()
    if (studentResponse.code === 200 && studentResponse.data) {
      const studentData = studentResponse.data

      // 如果学生有宿舍分配
      if (studentData.dormId) {
        // 获取宿舍详细信息
        const dormResponse = await getDormInfo(studentData.dormId)
        if (dormResponse.code === 200 && dormResponse.data) {
          dormInfo.value = dormResponse.data

          // 如果宿舍信息中没有宿管信息，尝试从父级获取
          await ensureDormManagerInfo(dormResponse.data)
        }

        // 获取宿舍学生列表
        const studentsResponse = await getDormStudents(studentData.dormId)
        if (studentsResponse.code === 200) {
          students.value = studentsResponse.rows || []
        }
      } else {
        error.value = '您还未分配宿舍'
      }
    } else {
      error.value = '获取学生信息失败'
    }
  } catch (err) {
    console.error('加载宿舍信息失败:', err)
    error.value = '加载失败，请重试'
  } finally {
    loading.value = false
  }
}

// 确保获取到宿管信息
const ensureDormManagerInfo = async (dormData) => {
  // 如果当前宿舍信息已有宿管信息，直接返回
  if (dormData.dormManager && dormData.phone) {
    return
  }

  try {
    // 如果没有宿管信息，通过ancestors查找父级宿管信息
    if (dormData.ancestors) {
      const ancestorIds = dormData.ancestors.split(',').filter(id => id && id !== '0')

      // 从最近的父级开始查找
      for (let i = ancestorIds.length - 1; i >= 0; i--) {
        const parentId = ancestorIds[i]
        const parentResponse = await getDormInfo(parentId)

        if (parentResponse.code === 200 && parentResponse.data) {
          const parentData = parentResponse.data

          // 如果找到宿管信息，更新到当前宿舍信息中
          if (parentData.dormManager || parentData.phone) {
            if (!dormInfo.value.dormManager && parentData.dormManager) {
              dormInfo.value.dormManager = parentData.dormManager
            }
            if (!dormInfo.value.phone && parentData.phone) {
              dormInfo.value.phone = parentData.phone
            }

            // 如果两个信息都找到了，就停止查找
            if (dormInfo.value.dormManager && dormInfo.value.phone) {
              break
            }
          }
        }
      }
    }

    // 如果ancestors中没有找到，尝试查找直接父级
    if ((!dormInfo.value.dormManager || !dormInfo.value.phone) && dormData.parentId && dormData.parentId !== 0) {
      const parentResponse = await getDormInfo(dormData.parentId)

      if (parentResponse.code === 200 && parentResponse.data) {
        const parentData = parentResponse.data

        if (!dormInfo.value.dormManager && parentData.dormManager) {
          dormInfo.value.dormManager = parentData.dormManager
        }
        if (!dormInfo.value.phone && parentData.phone) {
          dormInfo.value.phone = parentData.phone
        }
      }
    }
  } catch (err) {
    console.warn('获取宿管信息失败:', err)
    // 不影响主要功能，只记录警告
  }
}

// 获取状态样式类
const getStatusClass = (status) => {
  switch (status) {
    case '0': return 'status-normal'
    case '1': return 'status-closed'
    default: return 'status-unknown'
  }
}

// 获取状态文本
const getStatusText = (status) => {
  switch (status) {
    case '0': return '空闲'
    case '1': return '满员'
    default: return '未知'
  }
}

// 获取头像文字
const getAvatarText = (name) => {
  return name ? name.charAt(name.length - 1) : '?'
}

// 拨打电话
const makeCall = (phone) => {
  if (!phone) return
  
  uni.showModal({
    title: '拨打电话',
    content: `确定要拨打 ${phone} 吗？`,
    success: (res) => {
      if (res.confirm) {
        uni.makePhoneCall({
          phoneNumber: phone,
          fail: (err) => {
            console.error('拨打电话失败:', err)
            uni.showToast({
              title: '拨打失败',
              icon: 'none'
            })
          }
        })
      }
    }
  })
}

// 生命周期钩子
onMounted(() => {
  initPage()
  loadData()
})

// uni-app 页面生命周期钩子
const onShow = () => {
  // 页面显示时刷新数据
  loadData()
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

.custom-navbar {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20rpx 30rpx;
}

.navbar-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 88rpx;
}

.navbar-left {
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
  font-size: 32rpx;
}

.navbar-title {
  flex: 1;
  text-align: center;
}

.navbar-title text {
  color: white;
  font-size: 36rpx;
  font-weight: bold;
}

.navbar-right {
  width: 80rpx;
}

.main-content {
  flex: 1;
  padding: 30rpx;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 100rpx 0;
}

.loading-spinner {
  width: 60rpx;
  height: 60rpx;
  border: 4rpx solid #f3f3f3;
  border-top: 4rpx solid #667eea;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 20rpx;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading-text {
  color: #666;
  font-size: 28rpx;
}

.error-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 100rpx 0;
}

.error-icon {
  width: 120rpx;
  height: 120rpx;
  background: #ff6b6b;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 30rpx;
}

.error-icon .iconfont {
  color: white;
  font-size: 60rpx;
}

.error-text {
  color: #666;
  font-size: 28rpx;
  margin-bottom: 40rpx;
}

.retry-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 20rpx 40rpx;
  border-radius: 50rpx;
  font-size: 28rpx;
}

.content-container {
  padding-bottom: 40rpx;
}

.info-card {
  background: white;
  border-radius: 24rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 8rpx 32rpx rgba(0, 0, 0, 0.08);
  overflow: hidden;
  transition: all 0.3s ease;
}

.card-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 30rpx;
  display: flex;
  align-items: center;
}

.header-icon {
  width: 60rpx;
  height: 60rpx;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20rpx;
}

.header-icon .iconfont {
  color: white;
  font-size: 28rpx;
}

.header-title {
  color: white;
  font-size: 32rpx;
  font-weight: bold;
  flex: 1;
}

.student-count {
  background: rgba(255, 255, 255, 0.2);
  padding: 8rpx 16rpx;
  border-radius: 20rpx;
  backdrop-filter: blur(10rpx);
}

.student-count text {
  color: white;
  font-size: 24rpx;
}

.card-content {
  padding: 30rpx;
}

.info-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.info-row:last-child {
  border-bottom: none;
}

.info-label {
  color: #666;
  font-size: 28rpx;
  flex-shrink: 0;
  width: 160rpx;
}

.info-value {
  color: #333;
  font-size: 28rpx;
  text-align: right;
  flex: 1;
}

.capacity-info {
  display: flex;
  align-items: center;
  justify-content: flex-end;
}

.current-count {
  color: #667eea;
  font-weight: bold;
  font-size: 32rpx;
}

.separator {
  color: #ccc;
  margin: 0 8rpx;
}

.total-count {
  color: #666;
}

.unit {
  color: #999;
  margin-left: 8rpx;
}

.status-badge {
  padding: 8rpx 16rpx;
  border-radius: 20rpx;
  font-size: 24rpx;
}

.status-normal {
  background: #e8f5e8;
  color: #52c41a;
}

.status-closed {
  background: #fff2f0;
  color: #ff4d4f;
}

.status-unknown {
  background: #f0f0f0;
  color: #999;
}

.phone-number {
  color: #667eea !important;
  text-decoration: underline;
}

.students-list {
  padding: 0 30rpx 30rpx;
}

.student-item {
  display: flex;
  align-items: center;
  padding: 24rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.student-item:last-child {
  border-bottom: none;
}

.student-avatar {
  width: 80rpx;
  height: 80rpx;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 24rpx;
  flex-shrink: 0;
}

.avatar-text {
  color: white;
  font-size: 28rpx;
  font-weight: bold;
}

.student-info {
  flex: 1;
}

.student-name {
  color: #333;
  font-size: 30rpx;
  font-weight: bold;
  margin-bottom: 8rpx;
}

.student-details {
  display: flex;
  align-items: center;
  margin-bottom: 8rpx;
}

.student-no {
  color: #666;
  font-size: 24rpx;
  margin-right: 16rpx;
}

.gender-tag {
  padding: 4rpx 12rpx;
  border-radius: 12rpx;
  font-size: 20rpx;
}

.gender-tag.male {
  background: #e6f7ff;
  color: #1890ff;
}

.gender-tag.female {
  background: #fff0f6;
  color: #eb2f96;
}

.student-class {
  color: #999;
  font-size: 24rpx;
}

.contact-btn {
  width: 60rpx;
  height: 60rpx;
  background: #667eea;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-left: 20rpx;
}

.contact-btn .iconfont {
  color: white;
  font-size: 24rpx;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 80rpx 30rpx;
}

.empty-icon {
  width: 120rpx;
  height: 120rpx;
  background: #f0f0f0;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 30rpx;
}

.empty-icon .iconfont {
  color: #ccc;
  font-size: 60rpx;
}

.empty-text {
  color: #666;
  font-size: 28rpx;
  margin-bottom: 12rpx;
}

.empty-desc {
  color: #999;
  font-size: 24rpx;
}

/* 图标字体样式 */
.iconfont {
  font-family: 'iconfont';
}

/* 如果没有图标字体，使用文字替代 */
.icon-arrow-left::before {
  content: '‹';
}

.icon-home::before {
  content: '🏠';
}

.icon-user-group::before {
  content: '👥';
}

.icon-phone::before {
  content: '📞';
}

.icon-error::before {
  content: '❌';
}

.icon-empty::before {
  content: '📭';
}
</style>
