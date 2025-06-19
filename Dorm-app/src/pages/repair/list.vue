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
          <text class="title-text">{{ isRepairer ? '工单处理' : '报修服务' }}</text>
        </view>
        <view class="header-actions">
          <view v-if="!isRepairer" class="add-btn" @click="goToAdd">
            <text class="iconfont icon-add">+</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 主要内容区域 -->
    <scroll-view 
      class="main-content" 
      scroll-y="true"
      @scrolltolower="loadMore"
      refresher-enabled
      @refresherrefresh="onRefresh"
      :refresher-triggered="refreshing"
    >
      <!-- 学生报修列表 -->
      <view v-if="!isRepairer" class="repair-list">
        <view 
          v-for="(item, index) in repairList" 
          :key="item.requestId"
          class="repair-item"
          @click="goToDetail(item)"
        >
          <view class="repair-content">
            <view class="repair-header">
              <text class="repair-title">{{ item.description || '报修申请' }}</text>
              <view class="repair-status" :class="getStatusClass(item.status)">
                <text class="status-text">{{ getStatusText(item.status) }}</text>
              </view>
            </view>
            <view class="repair-info">
              <view class="info-row">
                <text class="info-label">工单编号：</text>
                <text class="info-value">{{ item.requestNo }}</text>
              </view>
              <view class="info-row">
                <text class="info-label">报修宿舍：</text>
                <text class="info-value">{{ item.dormName || '未知宿舍' }}</text>
              </view>
              <view class="info-row">
                <text class="info-label">报修项目：</text>
                <text class="info-value">{{ getSpecialtyText(item.specialty) }}</text>
              </view>
              <view class="info-row">
                <text class="info-label">申请时间：</text>
                <text class="info-value">{{ formatTime(item.createTime) }}</text>
              </view>
            </view>
          </view>
          <view class="repair-arrow">
            <text class="iconfont icon-arrow-right">›</text>
          </view>
        </view>
      </view>

      <!-- 维修人员工单列表 -->
      <view v-if="isRepairer" class="workorder-list">
        <view 
          v-for="(item, index) in workOrderList" 
          :key="item.assignmentId"
          class="workorder-item"
          @click="handleWorkOrderClick(item)"
        >
          <view class="workorder-content">
            <view class="workorder-header">
              <text class="workorder-title">{{ item.description || '维修工单' }}</text>
              <view class="workorder-status" :class="getWorkOrderStatusClass(item.processStatus)">
                <text class="status-text">{{ getWorkOrderStatusText(item.processStatus) }}</text>
              </view>
            </view>
            <view class="workorder-info">
              <view class="info-row">
                <text class="info-label">工单编号：</text>
                <text class="info-value">{{ item.requestNo }}</text>
              </view>
              <view class="info-row">
                <text class="info-label">报修宿舍：</text>
                <text class="info-value">{{ item.dormName || '未知宿舍' }}</text>
              </view>
              <view class="info-row">
                <text class="info-label">维修项目：</text>
                <text class="info-value">{{ getSpecialtyText(item.specialty) }}</text>
              </view>
              <view class="info-row">
                <text class="info-label">报修人：</text>
                <text class="info-value">{{ item.reporterName }}</text>
              </view>
              <view class="info-row">
                <text class="info-label">联系方式：</text>
                <text class="info-value">{{ item.contactPhone }}</text>
              </view>
              <view class="info-row">
                <text class="info-label">派单时间：</text>
                <text class="info-value">{{ formatTime(item.assignTime) }}</text>
              </view>
            </view>
            
            <!-- 工单操作按钮 -->
            <view v-if="item.processStatus === '0'" class="workorder-actions">
              <view class="action-btn reject-btn" @click.stop="showRejectDialog(item)">
                <text class="btn-text">拒绝</text>
              </view>
              <view class="action-btn accept-btn" @click.stop="handleAcceptOrder(item)">
                <text class="btn-text">接受</text>
              </view>
            </view>

            <view v-if="item.processStatus === '1'" class="workorder-actions">
              <view class="action-btn complete-btn" @click.stop="showCompleteDialog(item)">
                <text class="btn-text">完成维修</text>
              </view>
            </view>

            <!-- 已完成和已拒绝的工单显示完成时间或拒绝时间 -->
            <view v-if="item.processStatus === '2' || item.processStatus === '3'" class="workorder-completion">
              <view class="completion-info">
                <text class="completion-label">
                  {{ item.processStatus === '2' ? '完成时间：' : '拒绝时间：' }}
                </text>
                <text class="completion-time">
                  {{ formatTime(item.processStatus === '2' ? item.completeTime : item.rejectTime) }}
                </text>
              </view>
              <view v-if="item.processStatus === '3' && item.rejectReason" class="reject-reason">
                <text class="reason-label">拒绝原因：</text>
                <text class="reason-text">{{ item.rejectReason }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 空状态 -->
      <view v-if="!loading && (isRepairer ? workOrderList.length === 0 : repairList.length === 0)" class="empty-state">
        <text class="empty-icon">📝</text>
        <text class="empty-text">{{ isRepairer ? '暂无工单' : '暂无报修记录' }}</text>
        <view v-if="!isRepairer" class="empty-btn" @click="goToAdd">
          <text class="btn-text">立即报修</text>
        </view>
      </view>

      <!-- 加载更多 -->
      <view v-if="loadingMore" class="loading-more">
        <text class="loading-text">加载中...</text>
      </view>
      
      <!-- 没有更多数据 -->
      <view v-if="!hasMore && (isRepairer ? workOrderList.length > 0 : repairList.length > 0)" class="no-more">
        <text class="no-more-text">没有更多数据了</text>
      </view>
    </scroll-view>

    <!-- 拒绝工单弹窗 -->
    <view v-if="rejectModalVisible" class="modal-mask" @click="closeRejectModal">
      <view class="reject-modal" @click.stop>
        <view class="modal-header">
          <text class="modal-title">拒绝工单</text>
        </view>
        <view class="modal-body">
          <view class="modal-content">
            <text class="modal-label">请填写拒绝原因：</text>
            <textarea
              v-model="rejectReason"
              class="reject-textarea"
              placeholder="请输入拒绝原因"
              maxlength="200"
              placeholder-style="color: #999;"
            ></textarea>
            <view class="char-count">
              <text class="count-text">{{ rejectReason.length }}/200</text>
            </view>
          </view>
        </view>
        <view class="modal-footer">
          <view class="modal-btn cancel-btn" @click="closeRejectModal">
            <text class="btn-text">取消</text>
          </view>
          <view class="modal-btn confirm-btn" @click="handleRejectOrder">
            <text class="btn-text">确认</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 完成维修弹窗 -->
    <view v-if="completeModalVisible" class="modal-mask" @click="closeCompleteModal">
      <view class="complete-modal" @click.stop>
        <view class="modal-header">
          <text class="modal-title">完成维修</text>
        </view>
        <view class="modal-body">
          <view class="modal-content">
            <view class="photo-requirement">
              <text class="modal-label">维修完成照片：</text>
              <text class="requirement-text">*必填，请上传维修完成后的照片（最多3张）</text>
            </view>
            <view class="image-upload-area">
              <view
                v-for="(image, index) in completeImages"
                :key="index"
                class="image-item"
              >
                <image :src="image.url" class="uploaded-image" @click="previewImage(image.url)" />
                <view class="delete-btn" @click="deleteImage(index)">
                  <text class="delete-icon">×</text>
                </view>
              </view>
              <view
                v-if="completeImages.length < 3"
                class="upload-btn"
                @click="chooseImage"
              >
                <text class="upload-icon">+</text>
                <text class="upload-text">添加照片</text>
              </view>
            </view>

            <text class="modal-label">维修说明（可选）：</text>
            <textarea
              v-model="completeRemark"
              class="complete-textarea"
              placeholder="请输入维修说明"
              maxlength="200"
              placeholder-style="color: #999;"
            ></textarea>
            <view class="char-count">
              <text class="count-text">{{ completeRemark.length }}/200</text>
            </view>
          </view>
        </view>
        <view class="modal-footer">
          <view class="modal-btn cancel-btn" @click="closeCompleteModal">
            <text class="btn-text">取消</text>
          </view>
          <view
            class="modal-btn submit-btn"
            :class="{ 'disabled': !canSubmit }"
            @click="handleCompleteOrder"
          >
            <text class="btn-text">提交</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { listRequest } from '@/api/dorm/request'
import { getAllAssignments, acceptAssignment, rejectAssignment, completeAssignment } from '@/api/repairer/workorder'
import useUserStore from '@/store/modules/user'

// 获取用户store
const userStore = useUserStore()

// 响应式数据
const statusBarHeight = ref(0)
const repairList = ref([])
const workOrderList = ref([])
const loading = ref(false)
const refreshing = ref(false)
const loadingMore = ref(false)
const hasMore = ref(true)

// 弹窗相关
const rejectModalVisible = ref(false)
const completeModalVisible = ref(false)
const rejectReason = ref('')
const completeRemark = ref('')
const completeImages = ref([])
const currentWorkOrder = ref(null)

const queryParams = ref({
  pageNum: 1,
  pageSize: 10
})

// 计算属性：判断是否为维修人员
const isRepairer = computed(() => {
  return userStore.roles && userStore.roles.includes('repairer')
})

// 计算属性：判断是否可以提交完成维修
const canSubmit = computed(() => {
  return completeImages.value.length > 0
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
  loadData()
}

const loadData = async (isRefresh = false) => {
  if (isRepairer.value) {
    await loadWorkOrderList(isRefresh)
  } else {
    await loadRepairList(isRefresh)
  }
}

const loadRepairList = async (isRefresh = false) => {
  try { 
    if (isRefresh) {
      refreshing.value = true
      queryParams.value.pageNum = 1
      hasMore.value = true
    } else {
      loading.value = true
    }

    const response = await listRequest(queryParams.value)
    if (response.code === 200) {
      const newList = response.rows || []
      
      if (isRefresh) {
        repairList.value = newList
      } else if (queryParams.value.pageNum === 1) {
        repairList.value = newList
      } else {
        repairList.value = [...repairList.value, ...newList]
      }

      hasMore.value = newList.length >= queryParams.value.pageSize
    } else {
      uni.showToast({
        title: '获取数据失败',
        icon: 'none'
      })
    }
  } catch (error) {
    console.error('加载报修列表异常:', error)
    uni.showToast({
      title: '网络异常',
      icon: 'none'
    })
  } finally {
    loading.value = false
    refreshing.value = false
    loadingMore.value = false
  }
}

const loadWorkOrderList = async (isRefresh = false) => {
  try {
    if (isRefresh) {
      refreshing.value = true
      queryParams.value.pageNum = 1
      hasMore.value = true
    } else {
      loading.value = true
    }

    // 获取所有状态的工单
    const response = await getAllAssignments(queryParams.value)

    if (response.code === 200) {
      const allList = response.rows || []

      // 按状态优先级排序：待处理(0) > 处理中(1) > 已完成(2) > 已拒绝(3)
      const sortedList = allList.sort((a, b) => {
        const statusOrder = { '0': 0, '1': 1, '2': 2, '3': 3 }
        const aOrder = statusOrder[a.processStatus] || 999
        const bOrder = statusOrder[b.processStatus] || 999

        if (aOrder !== bOrder) {
          return aOrder - bOrder
        }

        // 同状态按时间排序（最新的在前）
        return new Date(b.assignTime || b.createTime) - new Date(a.assignTime || a.createTime)
      })

      if (isRefresh) {
        workOrderList.value = sortedList
      } else if (queryParams.value.pageNum === 1) {
        workOrderList.value = sortedList
      } else {
        workOrderList.value = [...workOrderList.value, ...sortedList]
      }

      hasMore.value = sortedList.length >= queryParams.value.pageSize
    } else {
      uni.showToast({
        title: response.msg || '获取数据失败',
        icon: 'none'
      })
    }
  } catch (error) {
    console.error('加载工单列表异常:', error)
    uni.showToast({
      title: '网络异常',
      icon: 'none'
    })
  } finally {
    loading.value = false
    refreshing.value = false
    loadingMore.value = false
  }
}

// 生命周期钩子
onMounted(() => {
  initPage()
})

const onRefresh = () => {
  loadData(true)
}

const loadMore = () => {
  if (!hasMore.value || loadingMore.value) return

  loadingMore.value = true
  queryParams.value.pageNum++
  loadData()
}

const goBack = () => {
  uni.navigateBack()
}

const goToAdd = () => {
  uni.navigateTo({
    url: '/pages/repair/add'
  })
}

const goToDetail = (item) => {
  uni.navigateTo({
    url: `/pages/repair/detail?id=${item.requestId}`
  })
}

const handleWorkOrderClick = (item) => {
  // 维修人员点击工单，可以查看详情
  uni.navigateTo({
    url: `/pages/repair/detail?id=${item.requestId}&assignmentId=${item.assignmentId}`
  })
}

const getSpecialtyText = (specialty) => {
  if (!specialty) return '未知'
  const specialties = specialty.split(',')
  return specialties.map(s => specialtyMap[s] || '未知').join('、')
}

const getStatusText = (status) => {
  return statusMap[status] || '未知'
}

const getStatusClass = (status) => {
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

const getWorkOrderStatusText = (status) => {
  return workOrderStatusMap[status] || '未知'
}

const getWorkOrderStatusClass = (status) => {
  const classMap = {
    '0': 'status-pending',      // 待处理
    '1': 'status-processing',   // 处理中
    '2': 'status-completed',    // 已完成
    '3': 'status-rejected'      // 已拒绝
  }
  return classMap[status] || 'status-pending'
}

const formatTime = (time) => {
  if (!time) return ''
  const date = new Date(time)
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`
}

// 工单操作方法
const showRejectDialog = (workOrder) => {
  currentWorkOrder.value = workOrder
  rejectReason.value = ''
  rejectModalVisible.value = true
}

const closeRejectModal = () => {
  rejectModalVisible.value = false
}

const showCompleteDialog = (workOrder) => {
  currentWorkOrder.value = workOrder
  completeRemark.value = ''
  completeImages.value = []
  completeModalVisible.value = true
}

const closeCompleteModal = () => {
  completeModalVisible.value = false
}

const handleAcceptOrder = async (workOrder) => {
  try {
    uni.showLoading({ title: '处理中...' })

    const response = await acceptAssignment(workOrder.assignmentId)
    if (response.code === 200) {
      uni.showToast({
        title: '接受成功',
        icon: 'success'
      })
      // 刷新列表
      loadData(true)
    } else {
      // 检查是否是状态已变更的错误
      if (response.msg && response.msg.includes('状态已变更')) {
        uni.showToast({
          title: '工单状态已变更，正在刷新',
          icon: 'none'
        })
        // 自动刷新列表
        setTimeout(() => {
          loadData(true)
        }, 1000)
      } else {
        uni.showToast({
          title: response.msg || '接受失败',
          icon: 'none'
        })
      }
    }
  } catch (error) {
    console.error('接受工单失败:', error)

    // 检查是否是网络错误但实际操作可能成功的情况
    if (error.message && error.message.includes('500')) {
      uni.showModal({
        title: '提示',
        content: '操作可能已成功，是否刷新页面查看最新状态？',
        success: (res) => {
          if (res.confirm) {
            loadData(true)
          }
        }
      })
    } else {
      uni.showToast({
        title: '网络异常',
        icon: 'none'
      })
    }
  } finally {
    uni.hideLoading()
  }
}

const handleRejectOrder = async () => {
  if (!rejectReason.value.trim()) {
    uni.showToast({
      title: '请填写拒绝原因',
      icon: 'none'
    })
    return
  }

  try {
    uni.showLoading({ title: '处理中...' })

    const response = await rejectAssignment(currentWorkOrder.value.assignmentId, {
      rejectReason: rejectReason.value
    })

    if (response.code === 200) {
      uni.showToast({
        title: '拒绝成功',
        icon: 'success'
      })
      closeRejectModal()
      // 刷新列表
      loadData(true)
    } else {
      uni.showToast({
        title: response.msg || '拒绝失败',
        icon: 'none'
      })
    }
  } catch (error) {
    console.error('拒绝工单失败:', error)
    uni.showToast({
      title: '网络异常',
      icon: 'none'
    })
  } finally {
    uni.hideLoading()
  }
}

const handleCompleteOrder = async () => {
  // 验证是否可以提交
  if (!canSubmit.value) {
    uni.showToast({
      title: '请上传维修完成照片',
      icon: 'none'
    })
    return
  }

  // 验证当前工单
  if (!currentWorkOrder.value || !currentWorkOrder.value.assignmentId) {
    uni.showToast({
      title: '工单信息异常',
      icon: 'none'
    })
    return
  }

  try {
    uni.showLoading({ title: '提交中...' })

    // 处理图片URL
    const imageUrls = completeImages.value.map(img => img.url).join(',')

    const response = await completeAssignment(currentWorkOrder.value.assignmentId, {
      images: imageUrls,
      processRemark: completeRemark.value.trim()
    })

    if (response.code === 200) {
      uni.showToast({
        title: '维修完成提交成功',
        icon: 'success'
      })
      closeCompleteModal()
      // 刷新列表
      loadData(true)
    } else {
      uni.showToast({
        title: response.msg || '提交失败',
        icon: 'none'
      })
    }
  } catch (error) {
    console.error('完成维修失败:', error)
    uni.showToast({
      title: '网络异常，请重试',
      icon: 'none'
    })
  } finally {
    uni.hideLoading()
  }
}

// 图片上传相关方法
const chooseImage = () => {
  uni.chooseImage({
    count: 3 - completeImages.value.length,
    sizeType: ['compressed'],
    sourceType: ['camera', 'album'],
    success: (res) => {
      res.tempFilePaths.forEach(path => {
        // 这里应该调用图片上传API，暂时使用本地路径
        completeImages.value.push({
          url: path,
          path: path
        })
      })
    },
    fail: (err) => {
      console.error('选择图片失败:', err)
      uni.showToast({
        title: '选择图片失败',
        icon: 'none'
      })
    }
  })
}

const deleteImage = (index) => {
  completeImages.value.splice(index, 1)
}

const previewImage = (url) => {
  const urls = completeImages.value.map(img => img.url)
  uni.previewImage({
    current: url,
    urls: urls
  })
}

// 导出方法供页面生命周期使用
defineExpose({
  onShow: () => {
    loadData(true)
  }
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

.header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20rpx 30rpx 40rpx;
  border-radius: 0 0 40rpx 40rpx;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.back-btn, .add-btn {
  width: 80rpx;
  height: 80rpx;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  backdrop-filter: blur(10rpx);
  transition: all 0.3s ease;
}

.back-btn:active, .add-btn:active {
  background: rgba(255, 255, 255, 0.3);
  transform: scale(0.95);
}

.back-btn .iconfont, .add-btn .iconfont {
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
  margin-top: -20rpx;
}

.repair-list, .workorder-list {
  margin-bottom: 40rpx;
}

/* 添加进入动画 */
.repair-item, .workorder-item {
  animation: slideInUp 0.6s ease-out;
}

@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(30rpx);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.repair-item, .workorder-item {
  display: flex;
  flex-direction: column;
  padding: 30rpx;
  margin-bottom: 20rpx;
  background: white;
  border-radius: 24rpx;
  box-shadow: 0 8rpx 32rpx rgba(0, 0, 0, 0.08);
  border: 1rpx solid rgba(255, 255, 255, 0.8);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.repair-item::before, .workorder-item::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 6rpx;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.repair-item:active, .workorder-item:active {
  transform: translateY(-4rpx) scale(0.98);
  box-shadow: 0 12rpx 40rpx rgba(0, 0, 0, 0.12);
}

.repair-content, .workorder-content {
  flex: 1;
}

.repair-header, .workorder-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 24rpx;
  padding-bottom: 16rpx;
  border-bottom: 1rpx solid #f0f2f5;
}

.repair-title, .workorder-title {
  font-size: 34rpx;
  font-weight: 600;
  color: #1a1a1a;
  flex: 1;
  line-height: 1.4;
  margin-right: 20rpx;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  overflow: hidden;
}

.repair-status, .workorder-status {
  padding: 12rpx 20rpx;
  border-radius: 24rpx;
  font-size: 24rpx;
  font-weight: 500;
  letter-spacing: 0.5rpx;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(10rpx);
}

.status-pending {
  background: linear-gradient(135deg, #ffeaa7, #fdcb6e);
  color: #d63031;
}

.status-assigned {
  background: linear-gradient(135deg, #74b9ff, #0984e3);
  color: white;
}

.status-processing {
  background: linear-gradient(135deg, #00cec9, #00b894);
  color: white;
}

.status-completed {
  background: linear-gradient(135deg, #00b894, #00a085);
  color: white;
}

.status-cancelled {
  background: linear-gradient(135deg, #fd79a8, #e84393);
  color: white;
}

.status-manual {
  background: linear-gradient(135deg, #fdcb6e, #e17055);
  color: white;
}

.status-rejected {
  background: linear-gradient(135deg, #fd79a8, #e84393);
  color: white;
}

.repair-info, .workorder-info {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
  margin-bottom: 24rpx;
  padding: 20rpx;
  background: linear-gradient(135deg, #f8f9fa, #ffffff);
  border-radius: 16rpx;
  border: 1rpx solid #f0f2f5;
}

.info-row {
  display: flex;
  align-items: center;
  font-size: 28rpx;
  line-height: 1.5;
}

.info-label {
  color: #8c8c8c;
  min-width: 140rpx;
  font-weight: 500;
  position: relative;
}

.info-label::after {
  content: ':';
  margin-left: 4rpx;
  color: #d9d9d9;
}

.info-value {
  color: #262626;
  flex: 1;
  font-weight: 400;
}

.workorder-actions {
  display: flex;
  gap: 16rpx;
  margin-top: 24rpx;
  padding-top: 20rpx;
  border-top: 1rpx solid #f0f2f5;
}

.action-btn {
  flex: 1;
  padding: 20rpx 24rpx;
  border-radius: 20rpx;
  text-align: center;
  font-size: 28rpx;
  font-weight: 600;
  letter-spacing: 0.5rpx;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
  border: none;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.1);
}

.action-btn:active {
  transform: translateY(2rpx);
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.15);
}

.reject-btn {
  background: linear-gradient(135deg, #ff7675, #d63031);
  color: white;
  box-shadow: 0 4rpx 16rpx rgba(214, 48, 49, 0.3);
}

.reject-btn:active {
  background: linear-gradient(135deg, #d63031, #b71c1c);
  box-shadow: 0 2rpx 8rpx rgba(214, 48, 49, 0.4);
}

.accept-btn {
  background: linear-gradient(135deg, #00b894, #00a085);
  color: white;
  box-shadow: 0 4rpx 16rpx rgba(0, 184, 148, 0.3);
}

.accept-btn:active {
  background: linear-gradient(135deg, #00a085, #008f72);
  box-shadow: 0 2rpx 8rpx rgba(0, 184, 148, 0.4);
}

.complete-btn {
  background: linear-gradient(135deg, #0984e3, #74b9ff);
  color: white;
  box-shadow: 0 4rpx 16rpx rgba(9, 132, 227, 0.3);
}

.complete-btn:active {
  background: linear-gradient(135deg, #74b9ff, #0984e3);
  box-shadow: 0 2rpx 8rpx rgba(9, 132, 227, 0.4);
}

/* 工单完成信息样式 */
.workorder-completion {
  margin-top: 24rpx;
  padding: 20rpx;
  background: linear-gradient(135deg, rgba(248, 249, 250, 0.8), rgba(255, 255, 255, 0.6));
  border-radius: 16rpx;
  border: 1rpx solid rgba(240, 242, 245, 0.8);
}

.completion-info {
  display: flex;
  align-items: center;
  margin-bottom: 12rpx;
}

.completion-label {
  font-size: 26rpx;
  color: #8c8c8c;
  font-weight: 500;
  min-width: 140rpx;
}

.completion-time {
  font-size: 26rpx;
  color: #262626;
  font-weight: 400;
}

.reject-reason {
  display: flex;
  align-items: flex-start;
  padding-top: 12rpx;
  border-top: 1rpx solid rgba(240, 242, 245, 0.6);
}

.reason-label {
  font-size: 26rpx;
  color: #8c8c8c;
  font-weight: 500;
  min-width: 140rpx;
  margin-top: 2rpx;
}

.reason-text {
  font-size: 26rpx;
  color: #e53e3e;
  font-weight: 400;
  line-height: 1.5;
  flex: 1;
}

.repair-arrow {
  margin-left: 20rpx;
}

.repair-arrow .iconfont {
  color: #ccc;
  font-size: 24rpx;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 120rpx 40rpx;
  text-align: center;
  background: white;
  border-radius: 24rpx;
  margin: 20rpx 0;
  box-shadow: 0 8rpx 32rpx rgba(0, 0, 0, 0.06);
}

.empty-icon {
  font-size: 140rpx;
  margin-bottom: 32rpx;
  opacity: 0.6;
}

.empty-text {
  font-size: 32rpx;
  color: #8c8c8c;
  margin-bottom: 48rpx;
  line-height: 1.5;
}

.empty-btn {
  padding: 24rpx 48rpx;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50rpx;
  box-shadow: 0 6rpx 20rpx rgba(102, 126, 234, 0.3);
  transition: all 0.3s ease;
}

.empty-btn:active {
  transform: translateY(2rpx);
  box-shadow: 0 4rpx 16rpx rgba(102, 126, 234, 0.4);
}

.btn-text {
  color: white;
  font-size: 28rpx;
}

.loading-more, .no-more {
  text-align: center;
  padding: 30rpx;
}

.loading-text, .no-more-text {
  color: #999;
  font-size: 28rpx;
}

.modal-content {
  padding: 20rpx;
}

.modal-label {
  display: block;
  font-size: 28rpx;
  color: #333;
  margin-bottom: 16rpx;
  margin-top: 20rpx;
}

.modal-label:first-child {
  margin-top: 0;
}

/* 图标字体样式 */
.iconfont {
  font-family: 'iconfont';
}

.icon-back::before {
  content: '‹';
}

.icon-add::before {
  content: '+';
}

.icon-arrow-right::before {
  content: '›';
}

/* 弹窗样式 */
.modal-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
  backdrop-filter: blur(10rpx);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
  animation: modalMaskFadeIn 0.3s ease-out;
}

@keyframes modalMaskFadeIn {
  from {
    opacity: 0;
    backdrop-filter: blur(0);
  }
  to {
    opacity: 1;
    backdrop-filter: blur(10rpx);
  }
}

.reject-modal, .complete-modal {
  background: linear-gradient(145deg, #ffffff, #f8f9fa);
  border-radius: 32rpx;
  width: 640rpx;
  max-height: 85vh;
  overflow: hidden;
  margin: 0 30rpx;
  box-shadow:
    0 20rpx 60rpx rgba(102, 126, 234, 0.15),
    0 8rpx 24rpx rgba(0, 0, 0, 0.1),
    inset 0 1rpx 0 rgba(255, 255, 255, 0.8);
  border: 1rpx solid rgba(255, 255, 255, 0.2);
  animation: modalSlideIn 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
  position: relative;
}

@keyframes modalSlideIn {
  from {
    opacity: 0;
    transform: translateY(60rpx) scale(0.9);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

.reject-modal::before, .complete-modal::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 8rpx;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 32rpx 32rpx 0 0;
}

.modal-header {
  padding: 48rpx 40rpx 32rpx;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));
  border-bottom: 1rpx solid rgba(240, 242, 245, 0.8);
  text-align: center;
  position: relative;
  margin-top: 8rpx;
}

.modal-header::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 60rpx;
  height: 4rpx;
  background: linear-gradient(135deg, #667eea, #764ba2);
  border-radius: 2rpx;
}

.modal-title {
  font-size: 36rpx;
  font-weight: 600;
  color: #1a1a1a;
  letter-spacing: 1rpx;
  position: relative;
  display: inline-block;
}

.modal-title::before {
  content: '';
  position: absolute;
  top: 50%;
  left: -40rpx;
  transform: translateY(-50%);
  width: 24rpx;
  height: 24rpx;
  background: linear-gradient(135deg, #667eea, #764ba2);
  border-radius: 50%;
  opacity: 0.8;
}

.modal-title::after {
  content: '';
  position: absolute;
  top: 50%;
  right: -40rpx;
  transform: translateY(-50%);
  width: 24rpx;
  height: 24rpx;
  background: linear-gradient(135deg, #667eea, #764ba2);
  border-radius: 50%;
  opacity: 0.8;
}

.modal-body {
  padding: 40rpx;
  max-height: 60vh;
  overflow-y: auto;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.9), rgba(248, 249, 250, 0.5));
}

.modal-body::-webkit-scrollbar {
  width: 8rpx;
}

.modal-body::-webkit-scrollbar-track {
  background: rgba(240, 242, 245, 0.5);
  border-radius: 4rpx;
}

.modal-body::-webkit-scrollbar-thumb {
  background: linear-gradient(135deg, #667eea, #764ba2);
  border-radius: 4rpx;
}

.modal-content {
  display: flex;
  flex-direction: column;
  gap: 32rpx;
}

.modal-label {
  font-size: 30rpx;
  color: #262626;
  font-weight: 600;
  margin-bottom: 20rpx;
  position: relative;
  padding-left: 20rpx;
}

.modal-label::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 6rpx;
  height: 24rpx;
  background: linear-gradient(135deg, #667eea, #764ba2);
  border-radius: 3rpx;
}

.photo-requirement {
  margin-bottom: 24rpx;
  padding: 24rpx;
  background: linear-gradient(135deg, rgba(255, 107, 107, 0.05), rgba(255, 107, 107, 0.02));
  border-radius: 20rpx;
  border: 1rpx solid rgba(255, 107, 107, 0.1);
}

.requirement-text {
  font-size: 26rpx;
  color: #ff6b6b;
  margin-top: 12rpx;
  display: block;
  font-weight: 500;
  line-height: 1.5;
  position: relative;
  padding-left: 32rpx;
}

.requirement-text::before {
  content: '⚠️';
  position: absolute;
  left: 0;
  top: 0;
  font-size: 24rpx;
}

.reject-textarea, .complete-textarea {
  width: 100%;
  min-height: 160rpx;
  padding: 24rpx;
  border: 2rpx solid rgba(102, 126, 234, 0.2);
  border-radius: 20rpx;
  font-size: 30rpx;
  line-height: 1.6;
  background: linear-gradient(145deg, #ffffff, #f8f9fa);
  box-sizing: border-box;
  transition: all 0.3s ease;
  box-shadow:
    inset 0 2rpx 8rpx rgba(0, 0, 0, 0.05),
    0 0 0 0 rgba(102, 126, 234, 0.2);
  color: #262626;
  resize: none;
}

.reject-textarea:focus, .complete-textarea:focus {
  border-color: #667eea;
  background: #ffffff;
  box-shadow:
    inset 0 2rpx 8rpx rgba(0, 0, 0, 0.05),
    0 0 0 4rpx rgba(102, 126, 234, 0.1),
    0 8rpx 24rpx rgba(102, 126, 234, 0.15);
  outline: none;
  transform: translateY(-2rpx);
}

.reject-textarea::placeholder, .complete-textarea::placeholder {
  color: #bbb;
  font-weight: 400;
}

.char-count {
  text-align: right;
  margin-top: 16rpx;
  padding: 8rpx 16rpx;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));
  border-radius: 12rpx;
  display: block;
  width: fit-content;
  margin-left: auto;
}

.count-text {
  font-size: 24rpx;
  color: #8c8c8c;
  font-weight: 500;
}

.image-upload-area {
  display: flex;
  flex-wrap: wrap;
  gap: 24rpx;
  padding: 24rpx;
  background: linear-gradient(145deg, rgba(255, 255, 255, 0.8), rgba(248, 249, 250, 0.6));
  border-radius: 20rpx;
  border: 2rpx dashed rgba(102, 126, 234, 0.2);
  transition: all 0.3s ease;
  margin-bottom: 24rpx;
}

.image-upload-area:hover {
  border-color: rgba(102, 126, 234, 0.4);
  background: linear-gradient(145deg, rgba(255, 255, 255, 0.9), rgba(248, 249, 250, 0.8));
}

.image-item {
  position: relative;
  width: 180rpx;
  height: 180rpx;
  border-radius: 20rpx;
  overflow: hidden;
  box-shadow:
    0 8rpx 24rpx rgba(0, 0, 0, 0.1),
    0 4rpx 8rpx rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
  border: 2rpx solid rgba(255, 255, 255, 0.8);
}

.image-item:hover {
  transform: translateY(-4rpx);
  box-shadow:
    0 12rpx 32rpx rgba(0, 0, 0, 0.15),
    0 6rpx 12rpx rgba(0, 0, 0, 0.08);
}

.uploaded-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.image-item:hover .uploaded-image {
  transform: scale(1.05);
}

.delete-btn {
  position: absolute;
  top: 12rpx;
  right: 12rpx;
  width: 48rpx;
  height: 48rpx;
  background: linear-gradient(135deg, rgba(255, 107, 107, 0.9), rgba(214, 48, 49, 0.9));
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4rpx 12rpx rgba(255, 107, 107, 0.3);
  transition: all 0.3s ease;
  backdrop-filter: blur(10rpx);
}

.delete-btn:active {
  transform: scale(0.9);
  background: linear-gradient(135deg, rgba(214, 48, 49, 0.9), rgba(183, 28, 28, 0.9));
}

.delete-icon {
  color: white;
  font-size: 24rpx;
  font-weight: bold;
}

.upload-btn {
  width: 180rpx;
  height: 180rpx;
  border: 3rpx dashed rgba(102, 126, 234, 0.3);
  border-radius: 20rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: linear-gradient(145deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));
  color: #667eea;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.upload-btn::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 0;
  height: 0;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
  border-radius: 50%;
  transition: all 0.4s ease;
}

.upload-btn:active::before {
  width: 200rpx;
  height: 200rpx;
}

.upload-btn:active {
  transform: scale(0.95);
  border-color: #667eea;
  background: linear-gradient(145deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
}

.upload-icon {
  font-size: 56rpx;
  margin-bottom: 12rpx;
  font-weight: 300;
  position: relative;
  z-index: 1;
}

.upload-text {
  font-size: 26rpx;
  font-weight: 500;
  position: relative;
  z-index: 1;
}

.modal-footer {
  display: flex;
  border-top: 1rpx solid rgba(240, 242, 245, 0.8);
  background: linear-gradient(135deg, rgba(248, 249, 250, 0.8), rgba(255, 255, 255, 0.9));
  padding: 24rpx;
  gap: 16rpx;
}

.modal-btn {
  flex: 1;
  padding: 32rpx 24rpx;
  text-align: center;
  font-size: 32rpx;
  font-weight: 600;
  border-radius: 20rpx;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
  letter-spacing: 1rpx;
}

.modal-btn::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 0;
  height: 0;
  border-radius: 50%;
  transition: all 0.4s ease;
}

.modal-btn:active::before {
  width: 300rpx;
  height: 300rpx;
}

.cancel-btn {
  background: linear-gradient(135deg, #dc3545, #c82333);
  color: white;
  border: 2rpx solid transparent;
  box-shadow: 0 4rpx 12rpx rgba(220, 53, 69, 0.3);
}

.cancel-btn::before {
  background: rgba(255, 255, 255, 0.15);
}

.cancel-btn:active {
  background: linear-gradient(135deg, #c82333, #bd2130);
  transform: translateY(1rpx) scale(0.98);
  box-shadow: 0 2rpx 8rpx rgba(220, 53, 69, 0.4);
}

.confirm-btn, .submit-btn {
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  border: 2rpx solid transparent;
  box-shadow: 0 6rpx 20rpx rgba(102, 126, 234, 0.3);
}

.confirm-btn::before, .submit-btn::before {
  background: rgba(255, 255, 255, 0.2);
}

.confirm-btn:active, .submit-btn:not(.disabled):active {
  background: linear-gradient(135deg, #5a6fd8, #6a42a0);
  transform: translateY(2rpx) scale(0.98);
  box-shadow: 0 4rpx 16rpx rgba(102, 126, 234, 0.4);
}

.submit-btn.disabled {
  background: linear-gradient(135deg, rgba(204, 204, 204, 0.6), rgba(170, 170, 170, 0.6));
  color: rgba(255, 255, 255, 0.7);
  box-shadow: none;
  pointer-events: none;
  cursor: not-allowed;
}

.submit-btn.disabled::before {
  display: none;
}

/* 弹窗退出动画 */
.modal-mask.closing {
  animation: modalMaskFadeOut 0.3s ease-in forwards;
}

@keyframes modalMaskFadeOut {
  from {
    opacity: 1;
    backdrop-filter: blur(10rpx);
  }
  to {
    opacity: 0;
    backdrop-filter: blur(0);
  }
}

.reject-modal.closing, .complete-modal.closing {
  animation: modalSlideOut 0.3s ease-in forwards;
}

@keyframes modalSlideOut {
  from {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
  to {
    opacity: 0;
    transform: translateY(-40rpx) scale(0.95);
  }
}

/* 响应式优化 */
@media (max-width: 750rpx) {
  .reject-modal, .complete-modal {
    width: 90vw;
    margin: 0 5vw;
  }

  .modal-header {
    padding: 40rpx 32rpx 24rpx;
  }

  .modal-body {
    padding: 32rpx;
  }

  .modal-footer {
    padding: 20rpx;
  }

  .image-item, .upload-btn {
    width: 160rpx;
    height: 160rpx;
  }

  .image-upload-area {
    gap: 20rpx;
    padding: 20rpx;
  }
}

/* 深色模式适配 */
@media (prefers-color-scheme: dark) {
  .reject-modal, .complete-modal {
    background: linear-gradient(145deg, #2a2a2a, #1f1f1f);
    border-color: rgba(255, 255, 255, 0.1);
  }

  .modal-header {
    background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
    border-bottom-color: rgba(255, 255, 255, 0.1);
  }

  .modal-title {
    color: #ffffff;
  }

  .modal-label {
    color: #e0e0e0;
  }

  .reject-textarea, .complete-textarea {
    background: linear-gradient(145deg, #333333, #2a2a2a);
    border-color: rgba(102, 126, 234, 0.3);
    color: #ffffff;
  }

  .reject-textarea::placeholder, .complete-textarea::placeholder {
    color: #888;
  }
}
</style>
