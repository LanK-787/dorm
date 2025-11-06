<template>
  <view class="repair-list-page">
    <!-- 状态栏占位 -->
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>

    <!-- 顶部导航栏 -->
    <view class="nav-bar">
      <view class="nav-left" @click="goBack">
        <text class="nav-icon">←</text>
      </view>
      <view class="nav-center">
        <text class="nav-title">{{ pageTitle }}</text>
        <text class="nav-count">{{ totalCount }}条记录</text>
      </view>
      <view class="nav-right" @click="handleNavAction">
        <text class="nav-icon">{{ isRepairer ? '🔔' : '+' }}</text>
      </view>
    </view>

    <!-- 快速筛选卡片 -->
    <view class="filter-section">
      <scroll-view class="filter-scroll" scroll-x show-scrollbar="false">
        <view 
          v-for="filter in filterOptions" 
          :key="filter.value"
          class="filter-chip"
          :class="{ 'filter-active': activeFilter === filter.value }"
          @click="changeFilter(filter.value)"
        >
          <view class="chip-content">
            <text class="chip-icon">{{ filter.icon }}</text>
            <text class="chip-label">{{ filter.label }}</text>
            <text v-if="filter.count > 0" class="chip-badge">{{ filter.count }}</text>
          </view>
        </view>
      </scroll-view>
    </view>

    <!-- 搜索栏 -->
    <view class="search-section">
      <view class="search-box">
        <text class="search-icon-left">🔍</text>
        <input 
          class="search-input" 
          v-model="searchKeyword"
          :placeholder="searchPlaceholder"
          @input="handleSearchInput"
          confirm-type="search"
        />
        <text v-if="searchKeyword" class="search-clear" @click="clearSearch">×</text>
      </view>
    </view>

    <!-- 主列表区域 -->
    <scroll-view 
      class="content-scroll"
      :style="{ height: contentHeight + 'px' }"
      scroll-y
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onPullRefresh"
      @scrolltolower="onLoadMore"
      :lower-threshold="100"
      enhanced
      :show-scrollbar="false"
    >
      <!-- 下拉刷新提示 -->
      <view v-if="refreshing" class="refresh-indicator">
        <view class="refresh-spinner"></view>
        <text class="refresh-text">刷新中...</text>
      </view>

      <!-- 数据列表 -->
      <view class="list-container">
        <!-- 学生报修列表 -->
        <template v-if="!isRepairer">
          <view 
            v-for="(item, index) in displayList" 
            :key="item.requestId"
            class="repair-item"
            :style="{ animationDelay: (index % 8) * 0.05 + 's' }"
            @click="viewDetail(item)"
          >
            <!-- 卡片内容 -->
            <view class="item-header">
              <view class="header-left">
                <view class="status-dot" :class="'dot-' + item.status"></view>
                <text class="request-no">{{ item.requestNo }}</text>
              </view>
              <view class="status-tag" :class="'tag-' + item.status">
                {{ getStatusText(item.status) }}
              </view>
            </view>

            <view class="item-body">
              <view class="body-row">
                <text class="row-icon">📝</text>
                <text class="row-text">{{ item.description || '无描述' }}</text>
              </view>
              <view class="body-row">
                <text class="row-icon">🏠</text>
                <text class="row-text">{{ item.dormName || '未知宿舍' }}</text>
              </view>
              <view class="body-row">
                <text class="row-icon">🔧</text>
                <text class="row-text">{{ getSpecialtyText(item.specialty) }}</text>
              </view>
            </view>

            <view class="item-footer">
              <text class="footer-time">{{ formatTimeAgo(item.createTime) }}</text>
              <text class="footer-arrow">›</text>
            </view>
          </view>
        </template>

        <!-- 维修人员工单列表 -->
        <template v-else>
          <view 
            v-for="(item, index) in displayList" 
            :key="item.assignmentId"
            class="workorder-item"
            :class="'priority-' + getItemPriority(item)"
            :style="{ animationDelay: (index % 8) * 0.05 + 's' }"
            @click="viewWorkOrderDetail(item)"
          >
            <!-- 紧急标记 -->
            <view v-if="isUrgent(item)" class="urgent-flag">
              <text>⚡</text>
            </view>

            <!-- 卡片头部 -->
            <view class="item-header">
              <view class="header-left">
                <view class="avatar-circle" :class="'avatar-' + item.processStatus">
                  <text>{{ getStatusIcon(item.processStatus) }}</text>
                </view>
                <view class="header-info">
                  <text class="info-name">{{ item.reporterName }}</text>
                  <text class="info-no">{{ item.requestNo }}</text>
                </view>
              </view>
              <view class="status-tag" :class="'tag-' + item.processStatus">
                {{ getWorkOrderStatusText(item.processStatus) }}
              </view>
            </view>

            <!-- 卡片内容 -->
            <view class="item-body">
              <view class="body-desc">
                <text class="desc-text">{{ item.description || '无描述' }}</text>
              </view>
              <view class="body-info-grid">
                <view class="info-cell">
                  <text class="cell-icon">🏠</text>
                  <text class="cell-text">{{ item.dormName }}</text>
                </view>
                <view class="info-cell">
                  <text class="cell-icon">🔧</text>
                  <text class="cell-text">{{ getSpecialtyText(item.specialty) }}</text>
                </view>
                <view class="info-cell">
                  <text class="cell-icon">📞</text>
                  <text class="cell-text">{{ item.contactPhone }}</text>
                </view>
              </view>
            </view>

            <!-- 操作按钮区 -->
            <view v-if="showActions(item)" class="item-actions">
              <view 
                v-if="item.processStatus === '0'"
                class="action-group"
              >
                <view class="action-btn btn-reject" @click.stop="handleReject(item)">
                  <text class="btn-icon">✕</text>
                  <text class="btn-text">拒绝</text>
                </view>
                <view class="action-btn btn-accept" @click.stop="handleAccept(item)">
                  <text class="btn-icon">✓</text>
                  <text class="btn-text">接单</text>
                </view>
              </view>
              <view 
                v-if="item.processStatus === '1'"
                class="action-group"
              >
                <view class="action-btn btn-complete" @click.stop="handleComplete(item)">
                  <text class="btn-icon">✓</text>
                  <text class="btn-text">完成维修</text>
                </view>
              </view>
            </view>

            <!-- 时间标记 -->
            <view class="item-footer">
              <text class="footer-time">{{ formatTimeAgo(item.assignTime) }}</text>
            </view>
          </view>
        </template>
      </view>

      <!-- 空状态 -->
      <view v-if="!loading && displayList.length === 0" class="empty-container">
        <view class="empty-animation">
          <text class="empty-emoji">{{ emptyIcon }}</text>
        </view>
        <text class="empty-title">{{ emptyTitle }}</text>
        <text class="empty-desc">{{ emptyDesc }}</text>
        <view v-if="!isRepairer && !searchKeyword && activeFilter === 'all'" class="empty-action" @click="goToAdd">
          <text>立即报修</text>
        </view>
      </view>

      <!-- 加载更多 -->
      <view v-if="loadingMore" class="loading-more">
        <view class="loading-spinner"></view>
        <text class="loading-text">加载中...</text>
      </view>

      <!-- 无更多数据 -->
      <view v-if="noMore && displayList.length > 0 && !loading" class="no-more">
        <text>— 已加载全部 —</text>
      </view>
    </scroll-view>

    <!-- 拒绝工单弹窗 -->
    <view v-if="rejectModalVisible" class="modal-overlay" @click="closeRejectModal">
      <view class="modal-container reject-modal" @click.stop>
        <view class="modal-header">
          <text class="modal-title">拒绝工单</text>
          <view class="modal-close" @click="closeRejectModal">
            <text>×</text>
          </view>
        </view>
        <view class="modal-body">
          <text class="modal-label">请说明拒绝原因</text>
          <textarea
            v-model="rejectReason"
            class="modal-textarea"
            placeholder="请输入拒绝原因（必填）"
            maxlength="200"
            :auto-height="true"
          ></textarea>
          <text class="char-counter">{{ rejectReason.length }}/200</text>
        </view>
        <view class="modal-footer">
          <view class="modal-btn btn-cancel" @click="closeRejectModal">取消</view>
          <view class="modal-btn btn-confirm" @click="confirmReject">确定</view>
        </view>
      </view>
    </view>

    <!-- 完成维修弹窗 -->
    <view v-if="completeModalVisible" class="modal-overlay" @click="closeCompleteModal">
      <view class="modal-container complete-modal" @click.stop>
        <view class="modal-header">
          <text class="modal-title">完成维修</text>
          <view class="modal-close" @click="closeCompleteModal">
            <text>×</text>
          </view>
        </view>
        <view class="modal-body">
          <text class="modal-label required">维修完成照片</text>
          <view class="image-upload-container">
            <view 
              v-for="(img, index) in completeImages" 
              :key="index"
              class="image-preview"
            >
              <image :src="img.url" mode="aspectFill" class="preview-img" @click="previewImage(index)" />
              <view class="image-delete" @click="deleteImage(index)">
                <text>×</text>
              </view>
            </view>
            <view 
              v-if="completeImages.length < 3" 
              class="image-upload-btn"
              @click="chooseImage"
            >
              <text class="upload-icon">+</text>
              <text class="upload-text">添加照片</text>
            </view>
          </view>
          <text class="upload-hint">*必须上传至少1张照片，最多3张</text>

          <text class="modal-label">维修说明（可选）</text>
          <textarea
            v-model="completeRemark"
            class="modal-textarea"
            placeholder="请描述维修情况"
            maxlength="200"
            :auto-height="true"
          ></textarea>
          <text class="char-counter">{{ completeRemark.length }}/200</text>
        </view>
        <view class="modal-footer">
          <view class="modal-btn btn-cancel" @click="closeCompleteModal">取消</view>
          <view 
            class="modal-btn btn-confirm"
            :class="{ disabled: completeImages.length === 0 }"
            @click="confirmComplete"
          >
            提交
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { listRequest } from '@/api/dorm/request'
import { getAllAssignments, acceptAssignment, rejectAssignment, completeAssignment } from '@/api/repairer/workorder'
import useUserStore from '@/store/modules/user'

// ==================== 状态管理 ====================
const userStore = useUserStore()
const isRepairer = computed(() => userStore.roles && userStore.roles.includes('repairer'))

// 页面基础数据
const statusBarHeight = ref(0)
const contentHeight = ref(600)
const loading = ref(false)
const refreshing = ref(false)
const loadingMore = ref(false)
const noMore = ref(false)

// 列表数据
const repairList = ref([])
const workOrderList = ref([])
const pageNum = ref(1)
const pageSize = 20

// 筛选和搜索
const activeFilter = ref('all')
const searchKeyword = ref('')
let searchTimer = null

// 弹窗相关
const rejectModalVisible = ref(false)
const completeModalVisible = ref(false)
const rejectReason = ref('')
const completeRemark = ref('')
const completeImages = ref([])
const currentItem = ref(null)

// ==================== 计算属性 ====================
const pageTitle = computed(() => isRepairer.value ? '工单处理' : '我的报修')

const totalCount = computed(() => {
  const list = isRepairer.value ? workOrderList.value : repairList.value
  return list.length
})

const searchPlaceholder = computed(() => {
  return isRepairer.value ? '搜索工单号、报修人' : '搜索工单号、描述'
})

// 筛选选项
const filterOptions = computed(() => {
  if (isRepairer.value) {
    const list = workOrderList.value
    return [
      { value: 'all', label: '全部', icon: '📋', count: list.length },
      { value: '0', label: '待处理', icon: '⏳', count: list.filter(i => i.processStatus === '0').length },
      { value: '1', label: '处理中', icon: '🔧', count: list.filter(i => i.processStatus === '1').length },
      { value: '2', label: '已完成', icon: '✅', count: list.filter(i => i.processStatus === '2').length },
      { value: '3', label: '已拒绝', icon: '❌', count: list.filter(i => i.processStatus === '3').length }
    ]
  } else {
    const list = repairList.value
    return [
      { value: 'all', label: '全部', icon: '📋', count: list.length },
      { value: '0', label: '待派单', icon: '⏳', count: list.filter(i => i.status === '0').length },
      { value: '1', label: '已派单', icon: '📮', count: list.filter(i => i.status === '1').length },
      { value: '2', label: '维修中', icon: '🔧', count: list.filter(i => i.status === '2').length },
      { value: '3', label: '已完成', icon: '✅', count: list.filter(i => i.status === '3').length }
    ]
  }
})

// 显示列表（应用筛选和搜索）
const displayList = computed(() => {
  let list = isRepairer.value ? workOrderList.value : repairList.value
  
  // 状态筛选
  if (activeFilter.value !== 'all') {
    if (isRepairer.value) {
      list = list.filter(item => item.processStatus === activeFilter.value)
    } else {
      list = list.filter(item => item.status === activeFilter.value)
    }
  }
  
  // 搜索过滤
  if (searchKeyword.value.trim()) {
    const keyword = searchKeyword.value.toLowerCase()
    list = list.filter(item => {
      const searchFields = [
        item.requestNo,
        item.description,
        item.dormName,
        item.reporterName
      ].filter(Boolean).join(' ').toLowerCase()
      return searchFields.includes(keyword)
    })
  }
  
  return list
})

// 空状态
const emptyIcon = computed(() => {
  if (searchKeyword.value) return '🔍'
  if (activeFilter.value !== 'all') return '📭'
  return isRepairer.value ? '📋' : '🔧'
})

const emptyTitle = computed(() => {
  if (searchKeyword.value) return '未找到相关内容'
  if (activeFilter.value !== 'all') return '暂无数据'
  return isRepairer.value ? '暂无工单' : '暂无报修记录'
})

const emptyDesc = computed(() => {
  if (searchKeyword.value) return '试试其他关键词'
  if (activeFilter.value !== 'all') return '切换其他状态查看'
  return isRepairer.value ? '等待新工单分配' : '点击右上角+号发起报修'
})

// ==================== 生命周期 ====================
onMounted(() => {
  initPage()
  loadData()
})

// ==================== 页面初始化 ====================
const initPage = () => {
  try {
    const systemInfo = uni.getSystemInfoSync()
    statusBarHeight.value = systemInfo.statusBarHeight || 0
    
    // 计算内容高度：屏幕高度 - 状态栏 - 导航栏(88rpx≈44px) - 筛选(160rpx≈80px) - 搜索(120rpx≈60px)
    contentHeight.value = systemInfo.windowHeight - statusBarHeight.value - 44 - 80 - 60
  } catch (error) {
    console.error('页面初始化失败:', error)
    contentHeight.value = 500
  }
}

// ==================== 数据加载 ====================
const loadData = async (refresh = false) => {
  if (isRepairer.value) {
    await loadWorkOrders(refresh)
  } else {
    await loadRepairs(refresh)
  }
}

const loadRepairs = async (refresh = false) => {
  if (loading.value && !refresh) return
  
  try {
    if (refresh) {
      loading.value = true
      refreshing.value = true
      pageNum.value = 1
      noMore.value = false
    } else {
      loadingMore.value = true
    }

    const response = await listRequest({
      pageNum: pageNum.value,
      pageSize: pageSize
    })

    if (response.code === 200) {
      const newData = response.rows || []
      
      if (refresh || pageNum.value === 1) {
        repairList.value = newData
      } else {
        repairList.value = [...repairList.value, ...newData]
      }

      noMore.value = newData.length < pageSize
      if (!noMore.value) pageNum.value++
    }
  } catch (error) {
    console.error('加载报修列表失败:', error)
    uni.showToast({ title: '加载失败', icon: 'none' })
  } finally {
    loading.value = false
    refreshing.value = false
    loadingMore.value = false
  }
}

const loadWorkOrders = async (refresh = false) => {
  if (loading.value && !refresh) return
  
  try {
    if (refresh) {
      loading.value = true
      refreshing.value = true
      pageNum.value = 1
      noMore.value = false
    } else {
      loadingMore.value = true
    }

    const response = await getAllAssignments({
      pageNum: pageNum.value,
      pageSize: pageSize
    })

    if (response.code === 200) {
      let newData = response.rows || []
      
      // 排序：待处理 > 处理中 > 已完成 > 已拒绝
      newData.sort((a, b) => {
        const priority = { '0': 0, '1': 1, '2': 2, '3': 3 }
        const aPriority = priority[a.processStatus] || 999
        const bPriority = priority[b.processStatus] || 999
        
        if (aPriority !== bPriority) {
          return aPriority - bPriority
        }
        
        return new Date(b.assignTime) - new Date(a.assignTime)
      })

      if (refresh || pageNum.value === 1) {
        workOrderList.value = newData
      } else {
        workOrderList.value = [...workOrderList.value, ...newData]
      }

      noMore.value = newData.length < pageSize
      if (!noMore.value) pageNum.value++
    }
  } catch (error) {
    console.error('加载工单列表失败:', error)
    uni.showToast({ title: '加载失败', icon: 'none' })
  } finally {
    loading.value = false
    refreshing.value = false
    loadingMore.value = false
  }
}

// ==================== 事件处理 ====================
const onPullRefresh = () => {
  loadData(true)
}

const onLoadMore = () => {
  if (!noMore.value && !loadingMore.value && !loading.value) {
    loadData(false)
  }
}

const handleSearchInput = () => {
  if (searchTimer) clearTimeout(searchTimer)
  searchTimer = setTimeout(() => {
    // 搜索通过计算属性自动实现
  }, 300)
}

const clearSearch = () => {
  searchKeyword.value = ''
}

const changeFilter = (value) => {
  activeFilter.value = value
}

const goBack = () => {
  uni.navigateBack()
}

const handleNavAction = () => {
  if (isRepairer.value) {
    // 维修人员：显示通知
    uni.showToast({ title: '通知功能开发中', icon: 'none' })
  } else {
    // 学生：跳转到添加报修
    goToAdd()
  }
}

const goToAdd = () => {
  uni.navigateTo({ url: '/pages/repair/add' })
}

const viewDetail = (item) => {
  uni.navigateTo({ url: `/pages/repair/detail?id=${item.requestId}` })
}

const viewWorkOrderDetail = (item) => {
  uni.navigateTo({ 
    url: `/pages/repair/detail?id=${item.requestId}&assignmentId=${item.assignmentId}` 
  })
}

// ==================== 工单操作 ====================
const showActions = (item) => {
  return ['0', '1'].includes(item.processStatus)
}

const getItemPriority = (item) => {
  if (item.processStatus === '0') return 'high'
  if (item.processStatus === '1') return 'medium'
  return 'normal'
}

const isUrgent = (item) => {
  // 判断是否紧急：创建时间超过24小时且状态为待处理
  if (item.processStatus !== '0') return false
  const createTime = new Date(item.assignTime).getTime()
  const now = Date.now()
  return (now - createTime) > 24 * 60 * 60 * 1000
}

const handleAccept = async (item) => {
  try {
    uni.showLoading({ title: '处理中...' })
    const response = await acceptAssignment(item.assignmentId)
    
    if (response.code === 200) {
      uni.showToast({ title: '接单成功', icon: 'success' })
      loadData(true)
    } else {
      uni.showToast({ title: response.msg || '接单失败', icon: 'none' })
    }
  } catch (error) {
    console.error('接单失败:', error)
    uni.showToast({ title: '操作失败', icon: 'none' })
  } finally {
    uni.hideLoading()
  }
}

const handleReject = (item) => {
  currentItem.value = item
  rejectReason.value = ''
  rejectModalVisible.value = true
}

const closeRejectModal = () => {
  rejectModalVisible.value = false
  currentItem.value = null
  rejectReason.value = ''
}

const confirmReject = async () => {
  if (!rejectReason.value.trim()) {
    uni.showToast({ title: '请填写拒绝原因', icon: 'none' })
    return
  }

  try {
    uni.showLoading({ title: '提交中...' })
    const response = await rejectAssignment(currentItem.value.assignmentId, {
      rejectReason: rejectReason.value
    })

    if (response.code === 200) {
      uni.showToast({ title: '已拒绝', icon: 'success' })
      closeRejectModal()
      loadData(true)
    } else {
      uni.showToast({ title: response.msg || '操作失败', icon: 'none' })
    }
  } catch (error) {
    console.error('拒绝失败:', error)
    uni.showToast({ title: '操作失败', icon: 'none' })
  } finally {
    uni.hideLoading()
  }
}

const handleComplete = (item) => {
  currentItem.value = item
  completeRemark.value = ''
  completeImages.value = []
  completeModalVisible.value = true
}

const closeCompleteModal = () => {
  completeModalVisible.value = false
  currentItem.value = null
  completeRemark.value = ''
  completeImages.value = []
}

const chooseImage = () => {
  if (completeImages.value.length >= 3) {
    uni.showToast({ title: '最多上传3张照片', icon: 'none' })
    return
  }

  uni.chooseImage({
    count: 3 - completeImages.value.length,
    sizeType: ['compressed'],
    sourceType: ['camera', 'album'],
    success: (res) => {
      res.tempFilePaths.forEach(path => {
        completeImages.value.push({ url: path })
      })
    }
  })
}

const deleteImage = (index) => {
  completeImages.value.splice(index, 1)
}

const previewImage = (index) => {
  const urls = completeImages.value.map(img => img.url)
  uni.previewImage({
    urls: urls,
    current: index
  })
}

const confirmComplete = async () => {
  if (completeImages.value.length === 0) {
    uni.showToast({ title: '请上传完成照片', icon: 'none' })
    return
  }

  try {
    uni.showLoading({ title: '提交中...' })
    const imageUrls = completeImages.value.map(img => img.url).join(',')
    
    const response = await completeAssignment(currentItem.value.assignmentId, {
      images: imageUrls,
      processRemark: completeRemark.value
    })

    if (response.code === 200) {
      uni.showToast({ title: '提交成功', icon: 'success' })
      closeCompleteModal()
      loadData(true)
    } else {
      uni.showToast({ title: response.msg || '提交失败', icon: 'none' })
    }
  } catch (error) {
    console.error('完成维修失败:', error)
    uni.showToast({ title: '操作失败', icon: 'none' })
  } finally {
    uni.hideLoading()
  }
}

// ==================== 辅助函数 ====================
const getStatusText = (status) => {
  const map = {
    '0': '待派单',
    '1': '已派单',
    '2': '维修中',
    '3': '已完成',
    '4': '已取消'
  }
  return map[status] || '未知'
}

const getWorkOrderStatusText = (status) => {
  const map = {
    '0': '待处理',
    '1': '处理中',
    '2': '已完成',
    '3': '已拒绝'
  }
  return map[status] || '未知'
}

const getStatusIcon = (status) => {
  const map = {
    '0': '⏳',
    '1': '🔧',
    '2': '✅',
    '3': '❌'
  }
  return map[status] || '📋'
}

const getSpecialtyText = (specialty) => {
  if (!specialty) return '未知'
  const map = { '0': '电工', '1': '水工', '2': '木工', '3': '水泥工' }
  return specialty.split(',').map(s => map[s] || '未知').join('、')
}

const formatTimeAgo = (time) => {
  if (!time) return ''
  try {
    const now = Date.now()
    const past = new Date(time).getTime()
    const diff = now - past
    
    const minute = 60 * 1000
    const hour = 60 * minute
    const day = 24 * hour
    
    if (diff < minute) return '刚刚'
    if (diff < hour) return `${Math.floor(diff / minute)}分钟前`
    if (diff < day) return `${Math.floor(diff / hour)}小时前`
    if (diff < 7 * day) return `${Math.floor(diff / day)}天前`
    
    const date = new Date(time)
    return `${date.getMonth() + 1}/${date.getDate()}`
  } catch (error) {
    return ''
  }
}
</script>

<style lang="scss" scoped>
.repair-list-page {
  min-height: 100vh;
  background: linear-gradient(180deg, #f5f7fa 0%, #ffffff 100%);
}

// ==================== 导航栏 ====================
.nav-bar {
  display: flex;
  align-items: center;
  padding: 16rpx 32rpx;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  box-shadow: 0 4rpx 24rpx rgba(102, 126, 234, 0.25);
}

.nav-left,
.nav-right {
  width: 72rpx;
  height: 72rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  backdrop-filter: blur(20rpx);
  transition: all 0.3s;

  &:active {
    transform: scale(0.9);
    background: rgba(255, 255, 255, 0.3);
  }
}

.nav-icon {
  font-size: 40rpx;
  font-weight: bold;
  color: white;
}

.nav-center {
  flex: 1;
  text-align: center;
  padding: 0 20rpx;
}

.nav-title {
  display: block;
  font-size: 36rpx;
  font-weight: bold;
  color: white;
  line-height: 1.3;
}

.nav-count {
  display: block;
  font-size: 22rpx;
  color: rgba(255, 255, 255, 0.85);
  margin-top: 4rpx;
}

// ==================== 筛选区域 ====================
.filter-section {
  padding: 24rpx 0;
  background: white;
}

.filter-scroll {
  white-space: nowrap;
  padding: 0 32rpx;
}

.filter-chip {
  display: inline-block;
  margin-right: 20rpx;
  transition: all 0.3s;

  &:active {
    transform: scale(0.95);
  }
}

.chip-content {
  display: flex;
  align-items: center;
  padding: 16rpx 28rpx;
  background: #f5f7fa;
  border-radius: 48rpx;
  border: 2rpx solid transparent;
  transition: all 0.3s;
}

.filter-active .chip-content {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  box-shadow: 0 6rpx 20rpx rgba(102, 126, 234, 0.3);
}

.chip-icon {
  font-size: 32rpx;
  margin-right: 12rpx;
}

.chip-label {
  font-size: 28rpx;
  font-weight: 500;
  color: #333;
}

.filter-active .chip-label {
  color: white;
}

.chip-badge {
  margin-left: 12rpx;
  padding: 4rpx 12rpx;
  background: rgba(0, 0, 0, 0.1);
  border-radius: 20rpx;
  font-size: 22rpx;
  font-weight: 600;
  color: #666;
}

.filter-active .chip-badge {
  background: rgba(255, 255, 255, 0.25);
  color: white;
}

// ==================== 搜索区域 ====================
.search-section {
  padding: 16rpx 32rpx;
  background: white;
}

.search-box {
  display: flex;
  align-items: center;
  height: 80rpx;
  padding: 0 32rpx;
  background: #f5f7fa;
  border-radius: 48rpx;
  transition: all 0.3s;

  &:focus-within {
    background: #eef2f7;
    box-shadow: 0 0 0 4rpx rgba(102, 126, 234, 0.1);
  }
}

.search-icon-left {
  font-size: 32rpx;
  margin-right: 16rpx;
}

.search-input {
  flex: 1;
  font-size: 28rpx;
  color: #333;
}

.search-clear {
  font-size: 40rpx;
  color: #999;
  padding: 0 8rpx;
  
  &:active {
    opacity: 0.6;
  }
}

// ==================== 内容滚动区 ====================
.content-scroll {
  overflow: hidden;
}

.refresh-indicator {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 30rpx;
}

.refresh-spinner {
  width: 32rpx;
  height: 32rpx;
  border: 3rpx solid #f0f0f0;
  border-top-color: #667eea;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  margin-right: 16rpx;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.refresh-text {
  font-size: 26rpx;
  color: #999;
}

// ==================== 列表容器 ====================
.list-container {
  padding: 0 32rpx 40rpx;
}

// 学生报修列表项
.repair-item {
  background: white;
  border-radius: 24rpx;
  padding: 32rpx;
  margin-bottom: 24rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.06);
  transition: all 0.3s;
  animation: slideUp 0.5s ease-out backwards;

  &:active {
    transform: translateY(-4rpx);
    box-shadow: 0 8rpx 32rpx rgba(0, 0, 0, 0.12);
  }
}

// 维修人员工单列表项
.workorder-item {
  position: relative;
  background: white;
  border-radius: 24rpx;
  padding: 32rpx;
  margin-bottom: 24rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.06);
  transition: all 0.3s;
  animation: slideUp 0.5s ease-out backwards;

  &:active {
    transform: translateY(-4rpx);
    box-shadow: 0 8rpx 32rpx rgba(0, 0, 0, 0.12);
  }

  &.priority-high {
    border-left: 6rpx solid #ff6b6b;
  }

  &.priority-medium {
    border-left: 6rpx solid #4dabf7;
  }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30rpx);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.urgent-flag {
  position: absolute;
  top: -8rpx;
  right: 32rpx;
  width: 64rpx;
  height: 64rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #ff6b6b, #ee5a6f);
  border-radius: 50%;
  box-shadow: 0 4rpx 16rpx rgba(255, 107, 107, 0.4);
  font-size: 32rpx;
  animation: pulse 1.5s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.1); }
}

// ==================== 卡片内容 ====================
.item-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24rpx;
}

.header-left {
  display: flex;
  align-items: center;
  flex: 1;
  min-width: 0;
}

.status-dot {
  width: 12rpx;
  height: 12rpx;
  border-radius: 50%;
  margin-right: 16rpx;
  flex-shrink: 0;

  &.dot-0 { background: #ffa502; }
  &.dot-1 { background: #3498db; }
  &.dot-2 { background: #00bcd4; }
  &.dot-3 { background: #4caf50; }
  &.dot-4 { background: #95a5a6; }
}

.avatar-circle {
  width: 72rpx;
  height: 72rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  font-size: 36rpx;
  margin-right: 20rpx;
  flex-shrink: 0;

  &.avatar-0 { background: rgba(255, 165, 2, 0.15); }
  &.avatar-1 { background: rgba(0, 188, 212, 0.15); }
  &.avatar-2 { background: rgba(76, 175, 80, 0.15); }
  &.avatar-3 { background: rgba(244, 67, 54, 0.15); }
}

.header-info {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-width: 0;
}

.info-name {
  font-size: 30rpx;
  font-weight: 600;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.info-no {
  font-size: 24rpx;
  color: #999;
  margin-top: 6rpx;
}

.request-no {
  font-size: 28rpx;
  font-weight: 600;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.status-tag {
  padding: 10rpx 20rpx;
  border-radius: 24rpx;
  font-size: 24rpx;
  font-weight: 600;
  white-space: nowrap;
  flex-shrink: 0;

  &.tag-0 { background: #fff4e6; color: #ff9500; }
  &.tag-1 { background: #e3f2fd; color: #2196f3; }
  &.tag-2 { background: #e0f2f1; color: #00bcd4; }
  &.tag-3 { background: #e8f5e9; color: #4caf50; }
  &.tag-4 { background: #f5f5f5; color: #999; }
}

.item-body {
  margin-bottom: 20rpx;
}

.body-row {
  display: flex;
  align-items: center;
  margin-bottom: 16rpx;

  &:last-child {
    margin-bottom: 0;
  }
}

.row-icon {
  font-size: 28rpx;
  margin-right: 12rpx;
  flex-shrink: 0;
}

.row-text {
  font-size: 28rpx;
  color: #666;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.body-desc {
  margin-bottom: 20rpx;
}

.desc-text {
  font-size: 28rpx;
  color: #333;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.body-info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16rpx;
}

.info-cell {
  display: flex;
  align-items: center;
  padding: 16rpx;
  background: #f8f9fc;
  border-radius: 12rpx;
}

.cell-icon {
  font-size: 28rpx;
  margin-right: 8rpx;
  flex-shrink: 0;
}

.cell-text {
  font-size: 24rpx;
  color: #666;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.item-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-top: 20rpx;
  border-top: 1rpx solid #f5f7fa;
}

.footer-time {
  font-size: 24rpx;
  color: #999;
}

.footer-arrow {
  font-size: 40rpx;
  color: #d9d9d9;
  font-weight: bold;
}

// ==================== 操作按钮 ====================
.item-actions {
  margin-top: 24rpx;
  padding-top: 24rpx;
  border-top: 1rpx solid #f5f7fa;
}

.action-group {
  display: flex;
  gap: 16rpx;
}

.action-btn {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 72rpx;
  border-radius: 16rpx;
  font-size: 28rpx;
  font-weight: 600;
  transition: all 0.3s;

  &:active {
    transform: scale(0.96);
  }
}

.btn-icon {
  font-size: 32rpx;
  margin-right: 8rpx;
}

.btn-reject {
  background: linear-gradient(135deg, #ff6b6b, #ee5a6f);
  color: white;
  box-shadow: 0 4rpx 16rpx rgba(255, 107, 107, 0.3);
}

.btn-accept {
  background: linear-gradient(135deg, #51cf66, #37b24d);
  color: white;
  box-shadow: 0 4rpx 16rpx rgba(81, 207, 102, 0.3);
}

.btn-complete {
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  box-shadow: 0 4rpx 16rpx rgba(102, 126, 234, 0.3);
}

// ==================== 空状态 ====================
.empty-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 48rpx;
  text-align: center;
}

.empty-animation {
  width: 160rpx;
  height: 160rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
  border-radius: 50%;
  margin-bottom: 32rpx;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-16rpx); }
}

.empty-emoji {
  font-size: 80rpx;
}

.empty-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #333;
  margin-bottom: 16rpx;
}

.empty-desc {
  font-size: 26rpx;
  color: #999;
  margin-bottom: 48rpx;
}

.empty-action {
  padding: 24rpx 64rpx;
  background: linear-gradient(135deg, #667eea, #764ba2);
  border-radius: 48rpx;
  color: white;
  font-size: 28rpx;
  font-weight: 600;
  box-shadow: 0 8rpx 24rpx rgba(102, 126, 234, 0.3);

  &:active {
    transform: scale(0.95);
  }
}

// ==================== 加载状态 ====================
.loading-more,
.no-more {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40rpx;
  font-size: 26rpx;
  color: #999;
}

.loading-spinner {
  width: 28rpx;
  height: 28rpx;
  border: 3rpx solid #f0f0f0;
  border-top-color: #667eea;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  margin-right: 12rpx;
}

.loading-text {
  font-size: 26rpx;
  color: #999;
}

// ==================== 弹窗样式 ====================
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(10rpx);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
  animation: fadeIn 0.3s;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.modal-container {
  width: 640rpx;
  max-height: 80vh;
  background: white;
  border-radius: 32rpx;
  overflow: hidden;
  animation: slideIn 0.3s;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(60rpx);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.modal-header {
  position: relative;
  padding: 40rpx;
  text-align: center;
  border-bottom: 1rpx solid #f5f7fa;
}

.modal-title {
  font-size: 36rpx;
  font-weight: 600;
  color: #333;
}

.modal-close {
  position: absolute;
  top: 32rpx;
  right: 32rpx;
  width: 56rpx;
  height: 56rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 48rpx;
  color: #999;
  line-height: 1;

  &:active {
    opacity: 0.6;
  }
}

.modal-body {
  padding: 40rpx;
  max-height: 60vh;
  overflow-y: auto;
}

.modal-label {
  display: block;
  font-size: 28rpx;
  font-weight: 600;
  color: #333;
  margin-bottom: 20rpx;

  &.required::before {
    content: '* ';
    color: #ff6b6b;
  }
}

.modal-textarea {
  width: 100%;
  min-height: 160rpx;
  padding: 24rpx;
  background: #f8f9fc;
  border-radius: 16rpx;
  font-size: 28rpx;
  line-height: 1.6;
  color: #333;
  box-sizing: border-box;
}

.char-counter {
  display: block;
  text-align: right;
  font-size: 24rpx;
  color: #999;
  margin-top: 12rpx;
}

.image-upload-container {
  display: flex;
  flex-wrap: wrap;
  gap: 20rpx;
  margin-bottom: 16rpx;
}

.image-preview {
  position: relative;
  width: 180rpx;
  height: 180rpx;
  border-radius: 16rpx;
  overflow: hidden;
}

.preview-img {
  width: 100%;
  height: 100%;
}

.image-delete {
  position: absolute;
  top: 8rpx;
  right: 8rpx;
  width: 48rpx;
  height: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.6);
  border-radius: 50%;
  font-size: 32rpx;
  color: white;

  &:active {
    opacity: 0.8;
  }
}

.image-upload-btn {
  width: 180rpx;
  height: 180rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #f8f9fc;
  border: 2rpx dashed #d9d9d9;
  border-radius: 16rpx;
  transition: all 0.3s;

  &:active {
    background: #eef2f7;
  }
}

.upload-icon {
  font-size: 56rpx;
  color: #999;
  line-height: 1;
}

.upload-text {
  font-size: 24rpx;
  color: #999;
  margin-top: 12rpx;
}

.upload-hint {
  display: block;
  font-size: 24rpx;
  color: #ff6b6b;
  margin-bottom: 24rpx;
}

.modal-footer {
  display: flex;
  border-top: 1rpx solid #f5f7fa;
  padding: 24rpx;
  gap: 16rpx;
}

.modal-btn {
  flex: 1;
  height: 88rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 16rpx;
  font-size: 32rpx;
  font-weight: 600;
  transition: all 0.3s;

  &:active {
    transform: scale(0.96);
  }
}

.btn-cancel {
  background: #f5f7fa;
  color: #666;
}

.btn-confirm {
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  box-shadow: 0 6rpx 20rpx rgba(102, 126, 234, 0.3);

  &.disabled {
    opacity: 0.5;
    pointer-events: none;
  }
}
</style>
