<template>
  <view class="page-container">
    <!-- 状态栏占位 -->
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>

    <!-- 头部区域 -->
    <view class="header">
      <view class="header-content">
        <view class="back-btn" @click="goBack">
          <text class="iconfont icon-back">‹</text>
        </view>
        <view class="header-title">
          <text class="title-text">智能派单测试</text>
        </view>
      </view>
    </view>

    <!-- 主要内容区域 -->
    <scroll-view class="main-content" scroll-y="true">
      <!-- 创建测试工单 -->
      <view class="test-section">
        <view class="section-title">
          <text class="title-text">创建测试工单</text>
        </view>
        
        <view class="form-container">
          <view class="form-item">
            <text class="form-label">学生ID：</text>
            <input v-model="testOrder.studentId" class="form-input" placeholder="请输入学生ID" type="number" />
          </view>
          
          <view class="form-item">
            <text class="form-label">宿舍ID：</text>
            <input v-model="testOrder.dormId" class="form-input" placeholder="请输入宿舍ID" type="number" />
          </view>
          
          <view class="form-item">
            <text class="form-label">维修项目：</text>
            <picker @change="onSpecialtyChange" :value="specialtyIndex" :range="specialtyOptions" range-key="text">
              <view class="picker-input">
                <text>{{ specialtyOptions[specialtyIndex].text }}</text>
                <text class="picker-arrow">›</text>
              </view>
            </picker>
          </view>
          
          <view class="form-item">
            <text class="form-label">问题描述：</text>
            <textarea v-model="testOrder.description" class="form-textarea" placeholder="请描述具体问题" />
          </view>
          
          <view class="form-item">
            <text class="form-label">报修人：</text>
            <input v-model="testOrder.reporterName" class="form-input" placeholder="请输入报修人姓名" />
          </view>
          
          <view class="form-item">
            <text class="form-label">联系电话：</text>
            <input v-model="testOrder.contactPhone" class="form-input" placeholder="请输入联系电话" />
          </view>
          
          <view class="form-actions">
            <button @click="createTestOrder" class="submit-btn" :disabled="submitting">
              {{ submitting ? '创建中...' : '创建测试工单' }}
            </button>
          </view>
        </view>
      </view>

      <!-- 工单状态查询 -->
      <view class="test-section">
        <view class="section-title">
          <text class="title-text">工单状态查询</text>
        </view>
        
        <view class="query-container">
          <view class="query-input">
            <input v-model="queryRequestId" class="form-input" placeholder="请输入工单ID" type="number" />
            <button @click="queryDispatchStatus" class="query-btn">查询状态</button>
          </view>
          
          <view v-if="dispatchStatus" class="status-result">
            <view class="status-item">
              <text class="status-label">工单编号：</text>
              <text class="status-value">{{ dispatchStatus.requestNo }}</text>
            </view>
            <view class="status-item">
              <text class="status-label">工单状态：</text>
              <text class="status-value" :class="getStatusClass(dispatchStatus.status)">
                {{ dispatchStatus.statusText }}
              </text>
            </view>
            <view class="status-item">
              <text class="status-label">维修项目：</text>
              <text class="status-value">{{ getSpecialtyText(dispatchStatus.specialty) }}</text>
            </view>
            <view class="status-item">
              <text class="status-label">创建时间：</text>
              <text class="status-value">{{ formatTime(dispatchStatus.createTime) }}</text>
            </view>
            <view class="status-item">
              <text class="status-label">派单次数：</text>
              <text class="status-value">{{ dispatchStatus.attemptCount || 0 }}</text>
            </view>
            
            <view v-if="dispatchStatus.assignments && dispatchStatus.assignments.length > 0" class="assignments-section">
              <text class="assignments-title">派单记录：</text>
              <view v-for="(assignment, index) in dispatchStatus.assignments" :key="index" class="assignment-item">
                <text class="assignment-text">维修人员：{{ assignment.repairerName }}</text>
                <text class="assignment-text">派单时间：{{ formatTime(assignment.assignTime) }}</text>
                <text class="assignment-text">处理状态：{{ getProcessStatusText(assignment.processStatus) }}</text>
              </view>
            </view>
            
            <view class="manual-dispatch">
              <button @click="triggerManualDispatch" class="manual-btn" :disabled="manualDispatching">
                {{ manualDispatching ? '派单中...' : '手动触发派单' }}
              </button>
            </view>
          </view>
        </view>
      </view>

      <!-- 系统诊断 -->
      <view class="test-section">
        <view class="section-title">
          <text class="title-text">系统诊断</text>
        </view>

        <view class="diagnosis-container">
          <view class="diagnosis-actions">
            <button @click="runFullDiagnosis" class="diagnosis-btn" :disabled="diagnosing">
              {{ diagnosing ? '诊断中...' : '全面诊断' }}
            </button>
            <button @click="testAsyncMessage" class="diagnosis-btn" :disabled="!queryRequestId || testingAsync">
              {{ testingAsync ? '测试中...' : '测试异步消息' }}
            </button>
          </view>

          <view v-if="diagnosisResult" class="diagnosis-result">
            <view class="diagnosis-section">
              <text class="diagnosis-title">维修人员状态</text>
              <view class="diagnosis-content">
                <text class="diagnosis-item">总数：{{ diagnosisResult.repairerStatus?.totalCount || 0 }}</text>
                <text class="diagnosis-item">空闲：{{ diagnosisResult.repairerStatus?.idleCount || 0 }}</text>
                <text class="diagnosis-item">忙碌：{{ diagnosisResult.repairerStatus?.busyCount || 0 }}</text>
              </view>
            </view>

            <view class="diagnosis-section">
              <text class="diagnosis-title">待派单工单</text>
              <view class="diagnosis-content">
                <text class="diagnosis-item">待派单数量：{{ diagnosisResult.pendingRequests?.pendingCount || 0 }}</text>
              </view>
            </view>

            <view class="diagnosis-section">
              <text class="diagnosis-title">RabbitMQ状态</text>
              <view class="diagnosis-content">
                <text class="diagnosis-item" :class="diagnosisResult.rabbitmqStatus?.connectionStatus === '正常' ? 'status-success' : 'status-error'">
                  连接状态：{{ diagnosisResult.rabbitmqStatus?.connectionStatus || '未知' }}
                </text>
                <text v-if="diagnosisResult.rabbitmqStatus?.error" class="diagnosis-item status-error">
                  错误：{{ diagnosisResult.rabbitmqStatus.error }}
                </text>
              </view>
            </view>

            <view class="diagnosis-section">
              <text class="diagnosis-title">智能派单服务</text>
              <view class="diagnosis-content">
                <text class="diagnosis-item" :class="diagnosisResult.smartDispatchService?.serviceStatus === '正常' ? 'status-success' : 'status-error'">
                  服务状态：{{ diagnosisResult.smartDispatchService?.serviceStatus || '未知' }}
                </text>
                <text class="diagnosis-item">电工可用：{{ diagnosisResult.smartDispatchService?.availableRepairersForElectric || 0 }}</text>
                <text class="diagnosis-item">水工可用：{{ diagnosisResult.smartDispatchService?.availableRepairersForWater || 0 }}</text>
                <text class="diagnosis-item">木工可用：{{ diagnosisResult.smartDispatchService?.availableRepairersForWood || 0 }}</text>
                <text class="diagnosis-item">水泥工可用：{{ diagnosisResult.smartDispatchService?.availableRepairersForCement || 0 }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 最近创建的工单 -->
      <view v-if="recentOrders.length > 0" class="test-section">
        <view class="section-title">
          <text class="title-text">最近创建的工单</text>
        </view>

        <view class="recent-orders">
          <view v-for="(order, index) in recentOrders" :key="index" class="order-item" @click="selectOrder(order)">
            <view class="order-info">
              <text class="order-no">{{ order.requestNo }}</text>
              <text class="order-desc">{{ order.description }}</text>
            </view>
            <view class="order-status" :class="getStatusClass(order.status)">
              <text class="status-text">{{ order.statusText }}</text>
            </view>
          </view>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { createTestOrder, manualDispatch, getDispatchStatus } from '@/api/test/smartDispatch'
import { fullDiagnosis, manualTrigger, testAsyncDispatch } from '@/api/diagnostic/smartDispatch'

// 响应式数据
const statusBarHeight = ref(0)
const submitting = ref(false)
const manualDispatching = ref(false)
const diagnosing = ref(false)
const testingAsync = ref(false)
const queryRequestId = ref('')
const dispatchStatus = ref(null)
const diagnosisResult = ref(null)
const recentOrders = ref([])

const specialtyIndex = ref(0)
const specialtyOptions = ref([
  { text: '电工', value: '0' },
  { text: '水工', value: '1' },
  { text: '木工', value: '2' },
  { text: '水泥工', value: '3' }
])

const testOrder = ref({
  studentId: '',
  dormId: '',
  specialty: '0',
  description: '测试报修工单',
  reporterName: '测试用户',
  contactPhone: '13800138000'
})

// 方法定义
const initPage = () => {
  const systemInfo = uni.getSystemInfoSync()
  statusBarHeight.value = systemInfo.statusBarHeight || 0
}

const goBack = () => {
  uni.navigateBack()
}

const onSpecialtyChange = (e) => {
  specialtyIndex.value = e.detail.value
  testOrder.value.specialty = specialtyOptions.value[e.detail.value].value
}

const createTestOrder = async () => {
  if (!testOrder.value.studentId || !testOrder.value.dormId) {
    uni.showToast({
      title: '请填写学生ID和宿舍ID',
      icon: 'none'
    })
    return
  }
  
  try {
    submitting.value = true
    
    const response = await createTestOrder(testOrder.value)
    if (response.code === 200) {
      uni.showToast({
        title: '工单创建成功',
        icon: 'success'
      })
      
      // 添加到最近工单列表
      const newOrder = {
        requestId: response.data.requestId,
        requestNo: response.data.requestNo,
        status: response.data.status,
        statusText: getStatusText(response.data.status),
        description: testOrder.value.description
      }
      recentOrders.value.unshift(newOrder)
      
      // 自动查询状态
      queryRequestId.value = response.data.requestId
      setTimeout(() => {
        queryDispatchStatus()
      }, 1000)
      
    } else {
      uni.showToast({
        title: response.msg || '创建失败',
        icon: 'none'
      })
    }
  } catch (error) {
    console.error('创建测试工单失败:', error)
    uni.showToast({
      title: '网络异常',
      icon: 'none'
    })
  } finally {
    submitting.value = false
  }
}

const queryDispatchStatus = async () => {
  if (!queryRequestId.value) {
    uni.showToast({
      title: '请输入工单ID',
      icon: 'none'
    })
    return
  }
  
  try {
    const response = await getDispatchStatus(queryRequestId.value)
    if (response.code === 200) {
      dispatchStatus.value = response.data
    } else {
      uni.showToast({
        title: response.msg || '查询失败',
        icon: 'none'
      })
    }
  } catch (error) {
    console.error('查询派单状态失败:', error)
    uni.showToast({
      title: '网络异常',
      icon: 'none'
    })
  }
}

const triggerManualDispatch = async () => {
  if (!queryRequestId.value) {
    uni.showToast({
      title: '请先查询工单状态',
      icon: 'none'
    })
    return
  }
  
  try {
    manualDispatching.value = true
    
    const response = await manualDispatch(queryRequestId.value)
    if (response.code === 200) {
      uni.showToast({
        title: '派单成功',
        icon: 'success'
      })
      
      // 重新查询状态
      setTimeout(() => {
        queryDispatchStatus()
      }, 1000)
      
    } else {
      uni.showToast({
        title: response.msg || '派单失败',
        icon: 'none'
      })
    }
  } catch (error) {
    console.error('手动派单失败:', error)
    uni.showToast({
      title: '网络异常',
      icon: 'none'
    })
  } finally {
    manualDispatching.value = false
  }
}

const selectOrder = (order) => {
  queryRequestId.value = order.requestId
  queryDispatchStatus()
}

const runFullDiagnosis = async () => {
  try {
    diagnosing.value = true

    const response = await fullDiagnosis()
    if (response.code === 200) {
      diagnosisResult.value = response.data
      uni.showToast({
        title: '诊断完成',
        icon: 'success'
      })
    } else {
      uni.showToast({
        title: response.msg || '诊断失败',
        icon: 'none'
      })
    }
  } catch (error) {
    console.error('系统诊断失败:', error)
    uni.showToast({
      title: '网络异常',
      icon: 'none'
    })
  } finally {
    diagnosing.value = false
  }
}

const testAsyncMessage = async () => {
  if (!queryRequestId.value) {
    uni.showToast({
      title: '请先选择工单',
      icon: 'none'
    })
    return
  }

  try {
    testingAsync.value = true

    const response = await testAsyncDispatch(queryRequestId.value)
    if (response.code === 200) {
      uni.showToast({
        title: '异步消息发送成功',
        icon: 'success'
      })

      // 延迟查询状态
      setTimeout(() => {
        queryDispatchStatus()
      }, 2000)

    } else {
      uni.showToast({
        title: response.msg || '发送失败',
        icon: 'none'
      })
    }
  } catch (error) {
    console.error('测试异步消息失败:', error)
    uni.showToast({
      title: '网络异常',
      icon: 'none'
    })
  } finally {
    testingAsync.value = false
  }
}

const getStatusText = (status) => {
  const statusMap = {
    '0': '待派单',
    '1': '已派单',
    '2': '维修中',
    '3': '已完成',
    '4': '已取消',
    '5': '等待人工派单'
  }
  return statusMap[status] || '未知状态'
}

const getStatusClass = (status) => {
  const classMap = {
    '0': 'status-pending',
    '1': 'status-assigned',
    '2': 'status-processing',
    '3': 'status-completed',
    '4': 'status-cancelled',
    '5': 'status-manual'
  }
  return classMap[status] || 'status-pending'
}

const getSpecialtyText = (specialty) => {
  const specialtyMap = {
    '0': '电工',
    '1': '水工',
    '2': '木工',
    '3': '水泥工'
  }
  return specialtyMap[specialty] || '未知'
}

const getProcessStatusText = (status) => {
  const statusMap = {
    '0': '待处理',
    '1': '处理中',
    '2': '已完成',
    '3': '已拒绝'
  }
  return statusMap[status] || '未知'
}

const formatTime = (time) => {
  if (!time) return ''
  const date = new Date(time)
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`
}

// 生命周期钩子
onMounted(() => {
  initPage()
})
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background: #f8f9fa;
}

.status-bar {
  background: transparent;
}

.header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20rpx 30rpx 40rpx;
}

.header-content {
  display: flex;
  align-items: center;
}

.back-btn {
  width: 80rpx;
  height: 80rpx;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20rpx;
}

.back-btn .iconfont {
  color: white;
  font-size: 32rpx;
}

.header-title {
  flex: 1;
  text-align: center;
}

.title-text {
  color: white;
  font-size: 36rpx;
  font-weight: bold;
}

.main-content {
  flex: 1;
  padding: 30rpx;
}

.test-section {
  margin-bottom: 40rpx;
  background: white;
  border-radius: 20rpx;
  padding: 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}

.section-title {
  margin-bottom: 30rpx;
  padding-bottom: 20rpx;
  border-bottom: 2rpx solid #f0f0f0;
}

.section-title .title-text {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.form-item {
  margin-bottom: 30rpx;
}

.form-label {
  display: block;
  font-size: 28rpx;
  color: #666;
  margin-bottom: 16rpx;
}

.form-input, .form-textarea {
  width: 100%;
  padding: 20rpx;
  border: 2rpx solid #e0e0e0;
  border-radius: 12rpx;
  font-size: 28rpx;
  background: #fafafa;
}

.form-textarea {
  height: 120rpx;
  resize: none;
}

.picker-input {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx;
  border: 2rpx solid #e0e0e0;
  border-radius: 12rpx;
  background: #fafafa;
}

.picker-arrow {
  color: #999;
  font-size: 24rpx;
}

.form-actions {
  margin-top: 40rpx;
}

.submit-btn, .manual-btn {
  width: 100%;
  padding: 24rpx;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 12rpx;
  font-size: 32rpx;
  font-weight: bold;
}

.submit-btn:disabled, .manual-btn:disabled {
  opacity: 0.6;
}

.query-input {
  display: flex;
  gap: 20rpx;
  margin-bottom: 30rpx;
}

.query-input .form-input {
  flex: 1;
}

.query-btn {
  padding: 20rpx 30rpx;
  background: #28a745;
  color: white;
  border: none;
  border-radius: 12rpx;
  font-size: 28rpx;
}

.status-result {
  padding: 30rpx;
  background: #f8f9fa;
  border-radius: 12rpx;
}

.status-item {
  display: flex;
  margin-bottom: 16rpx;
  font-size: 28rpx;
}

.status-label {
  color: #666;
  min-width: 140rpx;
}

.status-value {
  color: #333;
  flex: 1;
}

.status-pending { color: #ffc107; }
.status-assigned { color: #007bff; }
.status-processing { color: #17a2b8; }
.status-completed { color: #28a745; }
.status-cancelled { color: #dc3545; }
.status-manual { color: #fd7e14; }

.assignments-section {
  margin-top: 30rpx;
  padding-top: 20rpx;
  border-top: 2rpx solid #e0e0e0;
}

.assignments-title {
  font-size: 28rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
}

.assignment-item {
  padding: 20rpx;
  background: white;
  border-radius: 8rpx;
  margin-bottom: 16rpx;
}

.assignment-text {
  display: block;
  font-size: 26rpx;
  color: #666;
  margin-bottom: 8rpx;
}

.manual-dispatch {
  margin-top: 30rpx;
}

.recent-orders {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}

.order-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx;
  background: #f8f9fa;
  border-radius: 12rpx;
  transition: background-color 0.3s ease;
}

.order-item:active {
  background-color: #e9ecef;
}

.order-info {
  flex: 1;
}

.order-no {
  display: block;
  font-size: 28rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 8rpx;
}

.order-desc {
  font-size: 24rpx;
  color: #666;
}

.order-status {
  padding: 8rpx 16rpx;
  border-radius: 20rpx;
  font-size: 24rpx;
}

.icon-back::before {
  content: '‹';
}

.diagnosis-actions {
  display: flex;
  gap: 20rpx;
  margin-bottom: 30rpx;
}

.diagnosis-btn {
  flex: 1;
  padding: 20rpx;
  background: #17a2b8;
  color: white;
  border: none;
  border-radius: 12rpx;
  font-size: 28rpx;
}

.diagnosis-btn:disabled {
  opacity: 0.6;
}

.diagnosis-result {
  background: #f8f9fa;
  border-radius: 12rpx;
  padding: 20rpx;
}

.diagnosis-section {
  margin-bottom: 20rpx;
  padding-bottom: 20rpx;
  border-bottom: 1rpx solid #e0e0e0;
}

.diagnosis-section:last-child {
  border-bottom: none;
  margin-bottom: 0;
}

.diagnosis-title {
  display: block;
  font-size: 28rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 16rpx;
}

.diagnosis-content {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}

.diagnosis-item {
  font-size: 26rpx;
  color: #666;
}

.status-success {
  color: #28a745;
}

.status-error {
  color: #dc3545;
}
</style>
