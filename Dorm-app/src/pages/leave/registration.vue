<template>
  <view class="page-container">
    <!-- 状态栏占位 -->
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>

    <!-- 自定义导航栏 -->
    <view class="custom-navbar">
      <view class="navbar-content">
        <view class="navbar-left" @click="handleBack">
          <text class="iconfont icon-arrow-left">‹</text>
        </view>
        <view class="navbar-title">
          <text>离校登记</text>
        </view>
        <view class="navbar-right"></view>
      </view>
    </view>

    <!-- 主要内容区域 -->
    <scroll-view 
      class="main-content" 
      scroll-y="true"
    >
      <!-- 加载状态 -->
      <view v-if="loading" class="loading-container">
        <view class="loading-spinner"></view>
        <text class="loading-text">加载中...</text>
      </view>

      <!-- 错误状态 -->
      <view v-else-if="error" class="error-container">
        <text class="error-text">{{ error }}</text>
        <view class="retry-btn" @click="initStudentInfo">重试</view>
      </view>

      <!-- 表单内容 -->
      <view v-else class="form-container">
        <!-- 调试信息 (开发环境显示) -->
        <view v-if="isDev" class="debug-info">
          <text class="debug-title">调试信息</text>
          <text class="debug-text">学号: {{ formData.studentId || '未获取' }}</text>
          <text class="debug-text">姓名: {{ formData.studentName || '未获取' }}</text>
          <text class="debug-text">联系电话: {{ formData.contactPhone || '未获取' }}</text>
        </view>

        <view class="form-group">
          <view class="form-item">
            <text class="label">学号</text>
            <text class="value">{{ formData.studentId || '-' }}</text>
          </view>
          <view class="form-item">
            <text class="label">姓名</text>
            <text class="value">{{ formData.studentName || '-' }}</text>
          </view>
          <view class="form-item required">
            <text class="label">离校时间</text>
            <uni-datetime-picker
              v-model="formData.leaveTime"
              type="datetime"
              :clear-icon="false"
              :start="startDate"
              @change="handleLeaveTimeChange"
            >
              <view class="date-picker">
                <text :class="{'placeholder': !formData.leaveTime}">
                  {{ formData.leaveTime || '请选择离校时间' }}
                </text>
              </view>
            </uni-datetime-picker>
          </view>
          <view class="form-item required">
            <text class="label">返校时间</text>
            <uni-datetime-picker
              v-model="formData.expectedReturnTime"
              type="datetime"
              :clear-icon="false"
              :start="formData.leaveTime || startDate"
              @change="handleReturnTimeChange"
            >
              <view class="date-picker">
                <text :class="{'placeholder': !formData.expectedReturnTime}">
                  {{ formData.expectedReturnTime || '请选择返校时间' }}
                </text>
              </view>
            </uni-datetime-picker>
          </view>
          <view class="form-item required">
            <text class="label">目的地</text>
            <input 
              class="input"
              v-model="formData.destination"
              type="text"
              placeholder="请输入目的地"
            />
          </view>
          <view class="form-item required">
            <text class="label">离校原因</text>
            <textarea 
              class="textarea"
              v-model="formData.leaveReason"
              placeholder="请详细说明离校原因"
              :maxlength="200"
            />
            <text class="char-count">{{ formData.leaveReason.length }}/200</text>
          </view>
          <view class="form-item required">
            <text class="label">联系电话</text>
            <input 
              class="input"
              v-model="formData.contactPhone"
              type="number"
              maxlength="11"
              placeholder="请输入联系电话"
            />
          </view>
          <view class="form-item required">
            <text class="label">紧急联系人</text>
            <input 
              class="input"
              v-model="formData.emergencyContact"
              type="text"
              placeholder="请输入紧急联系人姓名"
            />
          </view>
          <view class="form-item required">
            <text class="label">紧急电话</text>
            <input 
              class="input"
              v-model="formData.emergencyPhone"
              type="number"
              maxlength="11"
              placeholder="请输入紧急联系人电话"
            />
          </view>
          <view class="form-item">
            <text class="label">备注信息</text>
            <textarea 
              class="textarea"
              v-model="formData.remark"
              placeholder="如有其他需要说明的信息，请在此填写（选填）"
              :maxlength="100"
            />
            <text class="char-count">{{ formData.remark.length }}/100</text>
          </view>
        </view>

        <!-- 提交按钮 -->
        <view class="submit-container">
          <button 
            class="submit-button" 
            :loading="submitting"
            :disabled="submitting"
            @click="handleSubmit"
          >
            {{ submitting ? '提交中...' : '提交申请' }}
          </button>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import useUserStore from '@/store/modules/user'
import useStudentStore from '@/store/modules/student'
import { submitLeaveApplication } from '@/api/leave/registration'

// store实例
const userStore = useUserStore()
const studentStore = useStudentStore()

// 状态变量
const statusBarHeight = ref(0)
const loading = ref(true)
const error = ref('')
const submitting = ref(false)
const startDate = ref(formatDate(new Date()))

// 表单数据
const formData = reactive({
  studentId: '',
  studentName: '',
  leaveTime: '',
  expectedReturnTime: '',
  leaveReason: '',
  destination: '',
  contactPhone: '',
  emergencyContact: '',
  emergencyPhone: '',
  remark: ''
})

// 处理离校时间变化
const handleLeaveTimeChange = (value) => {
  formData.leaveTime = formatDate(new Date(value))
  // 如果返校时间早于离校时间，清空返校时间
  if (formData.expectedReturnTime && new Date(formData.expectedReturnTime) <= new Date(value)) {
    formData.expectedReturnTime = ''
  }
}

// 处理返校时间变化
const handleReturnTimeChange = (value) => {
  if (!formData.leaveTime) {
    uni.showToast({
      title: '请先选择离校时间',
      icon: 'none'
    })
    return
  }

  if (new Date(value) <= new Date(formData.leaveTime)) {
    uni.showToast({
      title: '返校时间必须晚于离校时间',
      icon: 'none'
    })
    return
  }

  formData.expectedReturnTime = formatDate(new Date(value))
}

// 初始化页面
onMounted(async () => {
  const systemInfo = uni.getSystemInfoSync()
  statusBarHeight.value = systemInfo.statusBarHeight || 0
  await initStudentInfo()
})

// 初始化学生信息
const initStudentInfo = async () => {
  loading.value = true
  error.value = ''

  try {
    console.log('开始获取学生信息...')

    // 首先尝试从 studentStore 获取缓存的学生信息
    let studentInfo = null

    if (typeof studentStore.getCurrentStudent === 'function') {
      studentInfo = studentStore.getCurrentStudent()
    } else if (studentStore.getCurrentStudent) {
      studentInfo = studentStore.getCurrentStudent
    }

    console.log('studentStore 中的学生信息:', studentInfo)

    // 如果没有缓存信息，调用 API 获取
    if (!studentInfo && typeof studentStore.fetchStudentDetail === 'function') {
      console.log('从 API 获取学生信息...')
      studentInfo = await studentStore.fetchStudentDetail()
      console.log('API 返回的学生信息:', studentInfo)
    }

    if (studentInfo && (studentInfo.studentNo || studentInfo.name)) {
      // 填充学生基本信息
      formData.studentId = studentInfo.studentNo || studentInfo.studentId || ''
      formData.studentName = studentInfo.name || studentInfo.studentName || ''
      formData.contactPhone = studentInfo.phone || studentInfo.contactPhone || ''

      console.log('学生信息填充完成:', {
        studentId: formData.studentId,
        studentName: formData.studentName,
        contactPhone: formData.contactPhone
      })
    } else {
      // 如果没有学生信息，尝试使用用户基本信息
      console.log('未获取到学生信息，尝试使用用户基本信息')
      formData.studentId = userStore.name || ''
      formData.studentName = userStore.nickName || ''

      if (!formData.studentId && !formData.studentName) {
        throw new Error('无法获取用户信息，请重新登录')
      }
    }
  } catch (err) {
    console.error('获取学生信息失败:', err)
    error.value = err.message || '获取信息失败，请重试'

    // 显示错误提示
    uni.showToast({
      title: error.value,
      icon: 'none',
      duration: 3000
    })
  } finally {
    loading.value = false
  }
}

// 表单验证
const validateForm = () => {
  const requiredFields = {
    leaveTime: '离校时间',
    expectedReturnTime: '预计返校时间',
    leaveReason: '离校原因',
    destination: '目的地',
    contactPhone: '联系电话',
    emergencyContact: '紧急联系人',
    emergencyPhone: '紧急联系人电话'
  }

  for (const [field, label] of Object.entries(requiredFields)) {
    if (!formData[field]) {
      uni.showToast({
        title: `请填写${label}`,
        icon: 'none'
      })
      return false
    }
  }

  const phoneRegex = /^1[3-9]\d{9}$/
  if (!phoneRegex.test(formData.contactPhone)) {
    uni.showToast({
      title: '请输入正确的联系电话',
      icon: 'none'
    })
    return false
  }

  if (!phoneRegex.test(formData.emergencyPhone)) {
    uni.showToast({
      title: '请输入正确的紧急联系人电话',
      icon: 'none'
    })
    return false
  }

  return true
}

// 提交表单
const handleSubmit = async () => {
  if (!validateForm()) return

  try {
    submitting.value = true
    const submitData = {
      studentNo: formData.studentId,
      leaveTime: formData.leaveTime,
      expectedReturnTime: formData.expectedReturnTime,
      leaveReason: formData.leaveReason.trim(),
      destination: formData.destination.trim(),
      contactDuringLeave: formData.contactPhone,
      emergencyContact: formData.emergencyContact.trim(),
      emergencyPhone: formData.emergencyPhone,
      remark: formData.remark.trim()
    }

    const response = await submitLeaveApplication(submitData)

    if (response.code === 200) {
      uni.showToast({
        title: '提交成功',
        icon: 'success'
      })
      setTimeout(() => {
        uni.navigateBack()
      }, 1500)
    } else {
      throw new Error(response.msg || '提交失败')
    }
  } catch (error) {
    console.error('提交失败:', error)
    uni.showToast({
      title: error.message || '提交失败，请重试',
      icon: 'none'
    })
  } finally {
    submitting.value = false
  }
}

// 返回上一页
const handleBack = () => {
  uni.navigateBack()
}

// 格式化日期
function formatDate(date) {
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  const seconds = String(date.getSeconds()).padStart(2, '0')  // 添加秒
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
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

.form-container {
  padding: 30rpx;
  background: #fff;
}

.form-group {
  border-radius: 16rpx;
  overflow: hidden;
}

.form-item {
  padding: 30rpx 0;
  border-bottom: 2rpx solid #f0f0f0;
  position: relative;

  &:last-child {
    border-bottom: none;
  }

  &.required {
    .label::after {
      content: '*';
      color: #ff4d4f;
      margin-left: 4rpx;
    }
  }
}

.label {
  display: block;
  color: #333;
  font-size: 28rpx;
  margin-bottom: 16rpx;
  font-weight: 500;
}

.value {
  color: #666;
  font-size: 28rpx;
}

.input,
.textarea,
.date-picker {
  width: 100%;
  background: #f8f9fa;
  border: 2rpx solid #e9ecef;
  border-radius: 12rpx;
  font-size: 28rpx;
  color: #333;
}

.input {
  height: 88rpx;
  padding: 0 24rpx;
}

.textarea {
  height: 200rpx;
  padding: 24rpx;
  line-height: 1.5;
}

.date-picker {
  height: 88rpx;
  padding: 0 24rpx;
  display: flex;
  align-items: center;

  .placeholder {
    color: #999;
  }
}

.char-count {
  position: absolute;
  right: 0;
  bottom: 0;
  font-size: 24rpx;
  color: #999;
}

.submit-container {
  padding: 40rpx 30rpx calc(40rpx + env(safe-area-inset-bottom));
}

.submit-button {
  width: 100%;
  height: 88rpx;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 44rpx;
  color: white;
  font-size: 32rpx;
  font-weight: 500;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  transition: all 0.3s ease;
  
  &:active {
    transform: scale(0.98);
    opacity: 0.9;
  }
  
  &[disabled] {
    background: #cccccc;
    opacity: 0.6;
  }
}

/* 适配 iPhone X 及以上机型 */
@supports (padding-bottom: env(safe-area-inset-bottom)) {
  .submit-container {
    padding-bottom: calc(40rpx + env(safe-area-inset-bottom));
  }
}
</style> 