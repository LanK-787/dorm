<template>
  <view class="page-container">
    <!-- 自定义导航栏 -->
    <view class="custom-navbar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="navbar-content">
        <view class="navbar-left" @click="goBack">
          <text class="iconfont icon-back">‹</text>
        </view>
        <view class="navbar-title">
          <text>申请详情</text>
        </view>
        <view class="navbar-right"></view>
      </view>
    </view>

    <!-- 主要内容 -->
    <scroll-view class="main-content" scroll-y="true">
      <view v-if="loading" class="loading-container">
        <text class="loading-text">加载中...</text>
      </view>
      
      <view v-else-if="leaveDetail" class="detail-container">
        <!-- 状态卡片 -->
        <view class="status-card">
          <view class="status-header">
            <text class="status-title">申请状态</text>
            <text
              class="status-tag"
              :class="getStatusClass(leaveDetail.approveStatus, leaveDetail.status)"
            >
              {{ getStatusText(leaveDetail.approveStatus, leaveDetail.status) }}
            </text>
          </view>
          <view class="status-content">
            <text class="status-desc">{{ getStatusDescription(leaveDetail.approveStatus, leaveDetail.status) }}</text>
          </view>
        </view>

        <!-- 基本信息 -->
        <view class="info-card">
          <view class="card-title">
            <text>基本信息</text>
          </view>
          <view class="info-list">
            <view class="info-item">
              <text class="info-label">学号</text>
              <text class="info-value">{{ leaveDetail.studentId }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">姓名</text>
              <text class="info-value">{{ leaveDetail.studentName }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">离校时间</text>
              <text class="info-value">{{ formatDateTime(leaveDetail.leaveTime) }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">预计返校时间</text>
              <text class="info-value">{{ formatDateTime(leaveDetail.expectedReturnTime) }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">目的地</text>
              <text class="info-value">{{ leaveDetail.destination }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">联系电话</text>
              <text class="info-value">{{ leaveDetail.contactPhone }}</text>
            </view>
          </view>
        </view>

        <!-- 离校原因 -->
        <view class="info-card">
          <view class="card-title">
            <text>离校原因</text>
          </view>
          <view class="reason-content">
            <text class="reason-text">{{ leaveDetail.leaveReason }}</text>
          </view>
        </view>

        <!-- 紧急联系人 -->
        <view class="info-card">
          <view class="card-title">
            <text>紧急联系人</text>
          </view>
          <view class="info-list">
            <view class="info-item">
              <text class="info-label">姓名</text>
              <text class="info-value">{{ leaveDetail.emergencyContact }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">电话</text>
              <text class="info-value">{{ leaveDetail.emergencyPhone }}</text>
            </view>
          </view>
        </view>

        <!-- 审批信息 -->
        <view v-if="leaveDetail.approveStatus !== '0'" class="info-card">
          <view class="card-title">
            <text>审批信息</text>
          </view>
          <view class="info-list">
            <view class="info-item">
              <text class="info-label">审批人</text>
              <text class="info-value">{{ leaveDetail.approver || '系统' }}</text>
            </view>
            <view class="info-item">
              <text class="info-label">审批时间</text>
              <text class="info-value">{{ formatDateTime(leaveDetail.approveTime) }}</text>
            </view>
            <view v-if="leaveDetail.approveRemark" class="info-item">
              <text class="info-label">审批意见</text>
              <text class="info-value">{{ leaveDetail.approveRemark }}</text>
            </view>
          </view>
        </view>

        <!-- 备注 -->
        <view v-if="leaveDetail.remark" class="info-card">
          <view class="card-title">
            <text>备注</text>
          </view>
          <view class="reason-content">
            <text class="reason-text">{{ leaveDetail.remark }}</text>
          </view>
        </view>

        <!-- 操作按钮 -->
        <view class="action-section">
          <button 
            v-if="canCancel(leaveDetail)" 
            class="action-btn cancel-btn" 
            @click="cancelApplication"
          >
            取消申请
          </button>
          <button 
            v-if="canReturn(leaveDetail)" 
            class="action-btn return-btn" 
            @click="openMapValidation"
          >
            确认返校
          </button>
        </view>
      </view>
      
      <view v-else class="error-container">
        <text class="error-text">申请详情加载失败</text>
        <button class="retry-btn" @click="loadDetail">重试</button>
      </view>
    </scroll-view>

    <!-- 地图验证对话框 -->
    <view v-if="showMapDialog" class="map-dialog-overlay" @click="closeMapDialog">
      <view class="map-dialog" @click.stop>
        <!-- 对话框头部 -->
        <view class="dialog-header">
          <text class="dialog-title">位置验证</text>
          <view class="close-btn" @click="closeMapDialog">
            <text class="close-icon">×</text>
          </view>
        </view>

        <!-- 地图容器 -->
        <view class="map-container">
          <!-- H5端优先使用高德地图API -->
          <view v-if="isH5 && !amapLoadFailed" class="amap-container">
            <view :id="mapContainerId" class="amap-instance"></view>
            <view v-if="!amapInstance" class="map-loading">
              <text class="loading-text">正在加载高德地图...</text>
            </view>
          </view>
          
          <!-- App端或H5端降级使用原生地图 -->
          <map v-else
            :id="mapId"
            class="native-map"
            :latitude="centerLatitude" 
            :longitude="centerLongitude"
            :scale="16"
            :show-location="true"
            :enable-3D="false"
            :enable-overlook="false"
            :enable-zoom="true"
            :enable-scroll="true"
            :enable-rotate="false"
            :markers="markers"
            :circles="circles"
            @markertap="onMarkerTap"
            @updated="onMapUpdated"
          >
          </map>
        </view>

        <!-- 位置信息面板 -->
        <view class="location-info-panel">
          <view class="info-item">
            <text class="info-label">当前位置：</text>
            <text class="info-value">{{ currentAddress || '获取中...' }}</text>
          </view>
          <view class="info-item">
            <text class="info-label">距离学校：</text>
            <text class="info-value" :class="{ 'in-range': isInSchoolRange, 'out-range': !isInSchoolRange && distance > 0 }">
              {{ formatDistance(distance) }}
            </text>
          </view>
          <view class="validation-status">
            <text class="status-text" :class="validationStatusClass">
              {{ validationStatusText }}
            </text>
          </view>
        </view>
        
        <!-- 操作按钮 -->
        <view class="dialog-actions">
          <button class="btn refresh-btn" @click="refreshLocation">
            <text class="btn-text">🔄 刷新位置</text>
          </button>
          <button 
            class="btn confirm-btn" 
            :class="{ 'disabled': !isInSchoolRange }"
            :disabled="!isInSchoolRange"
            @click="confirmReturnWithLocation"
          >
            <text class="btn-text">✓ 确认返校</text>
          </button>
        </view>

        <!-- 加载遮罩 -->
        <view v-if="mapLoading" class="dialog-loading">
          <view class="loading-content">
            <view class="loading-spinner"></view>
            <text class="loading-text">{{ loadingText }}</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted, computed, nextTick } from 'vue'
import {
  getLeaveApplicationDetail,
  cancelLeaveApplication,
  confirmReturn as apiConfirmReturn
} from '@/api/leave/registration'

// 响应式数据
const statusBarHeight = ref(0)
const loading = ref(false)
const leaveDetail = ref(null)
const leaveId = ref('')

// 地图验证对话框相关
const showMapDialog = ref(false)
const mapLoading = ref(false)
const loadingText = ref('正在获取位置...')
const isH5 = ref(false)
const mapId = 'locationValidationMap'
const mapContainerId = 'amapContainer' // 高德地图容器ID

// 高德地图相关
const amapInstance = ref(null) // 高德地图实例
const schoolMarker = ref(null) // 学校标记
const userMarker = ref(null) // 用户标记
const schoolCircle = ref(null) // 学校围栏
const amapLoadFailed = ref(false) // 高德地图加载失败标记

// 地图相关数据
const centerLatitude = ref(0)
const centerLongitude = ref(0)
const currentLatitude = ref(0)
const currentLongitude = ref(0)
const currentAddress = ref('')
const distance = ref(0)
const isInSchoolRange = ref(false)

// 学校配置
const schoolConfig = {
  name: '学校',
  latitude: 31.230416, // 示例坐标，请替换为实际学校坐标
  longitude: 121.473701,
  radius: 500, // 学校围栏半径，单位：米
}

// 高德地图动态导入
let amapUtils = null
const loadAmapUtils = async () => {
  if (isH5.value && !amapUtils) {
    try {
      console.log('🚀 开始加载高德地图工具模块...')
      amapUtils = await import('@/utils/amap.js')
      console.log('✅ 高德地图工具模块加载成功')
      
      // 更新学校配置为高德的配置
      if (amapUtils.SCHOOL_CONFIG) {
        Object.assign(schoolConfig, amapUtils.SCHOOL_CONFIG)
        console.log('⚙️ 学校配置已更新:', schoolConfig)
      }
    } catch (error) {
      console.error('❌ 加载高德地图工具失败:', error)
      amapLoadFailed.value = true
      return null
    }
  }
  return amapUtils
}

// 地图标记
const markers = ref([
  {
    id: 1,
    latitude: schoolConfig.latitude,
    longitude: schoolConfig.longitude,
    title: schoolConfig.name,
    iconPath: '/static/images/markers/school-marker.svg',
    width: 32,
    height: 32,
    callout: {
      content: schoolConfig.name,
      color: '#333',
      bgColor: '#fff',
      padding: 8,
      borderRadius: 4
    }
  }
])

// 圆形围栏可视化
const circles = ref([
  {
    latitude: schoolConfig.latitude,
    longitude: schoolConfig.longitude,
    radius: schoolConfig.radius,
    color: '#1890ff40',
    fillColor: '#1890ff20',
    strokeWidth: 2
  }
])

// 计算属性

// 验证状态文本
const validationStatusText = computed(() => {
  if (distance.value === 0) {
    return '正在获取位置信息...'
  }
  
  if (isInSchoolRange.value) {
    return '✓ 在学校范围内，可以确认返校'
  } else {
    return '⚠ 不在学校范围内，请先返回学校'
  }
})

// 验证状态样式类
const validationStatusClass = computed(() => {
  if (distance.value === 0) {
    return 'status-loading'
  }
  
  return isInSchoolRange.value ? 'status-success' : 'status-warning'
})

// 格式化距离显示
const formatDistance = (dist) => {
  if (typeof dist !== 'number' || isNaN(dist) || dist <= 0) {
    return '计算中...'
  }
  
  if (dist < 1000) {
    return `${dist.toFixed(0)}m`
  } else {
    return `${(dist / 1000).toFixed(1)}km`
  }
}

// 初始化页面
const initPage = () => {
  // 获取状态栏高度
  const systemInfo = uni.getSystemInfoSync()
  statusBarHeight.value = systemInfo.statusBarHeight || 0
  
  // 获取页面参数
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  leaveId.value = currentPage.options.id || ''
  
  if (leaveId.value) {
    loadDetail()
  } else {
    uni.showToast({
      title: '参数错误',
      icon: 'none'
    })
  }
}

// 加载详情
const loadDetail = async () => {
  if (!leaveId.value) return
  
  try {
    loading.value = true
    
    const response = await getLeaveApplicationDetail(leaveId.value)
    
    if (response.code === 200) {
      leaveDetail.value = response.data
    } else {
      uni.showToast({
        title: response.msg || '加载失败',
        icon: 'none'
      })
    }
    
  } catch (error) {
    console.error('加载申请详情失败:', error)
    uni.showToast({
      title: '加载失败',
      icon: 'none'
    })
  } finally {
    loading.value = false
  }
}

// 格式化日期时间
const formatDateTime = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')} ${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`
}

// 状态映射配置
const statusMappings = {
  // 审批状态映射 (approveStatus)
  approve: {
    '0': { text: '待审批', class: 'pending' },
    '1': { text: '已批准', class: 'approved' },
    '2': { text: '已拒绝', class: 'rejected' },
    '3': { text: '已取消', class: 'cancelled' }
  },
  // 离校状态映射 (status)
  leave: {
    '0': { text: '离校中', class: 'away' },
    '1': { text: '已返校', class: 'returned' },
    '2': { text: '逾期未返', class: 'overdue' }
  }
}

// 获取状态样式类
const getStatusClass = (approveStatus, status) => {
  // 审批状态优先级处理
  if (approveStatus === '0') {
    return statusMappings.approve['0'].class  // 待审批
  }

  if (approveStatus === '2') {
    return statusMappings.approve['2'].class  // 已拒绝
  }

  if (approveStatus === '3') {
    return statusMappings.approve['3'].class  // 已取消
  }

  // 审批通过后，根据离校状态判断
  if (approveStatus === '1') {
    const leaveStatusConfig = statusMappings.leave[status]
    return leaveStatusConfig ? leaveStatusConfig.class : 'pending'
  }

  return 'pending'
}

// 获取状态文本
const getStatusText = (approveStatus, status) => {
  // 审批状态优先级处理
  if (approveStatus === '0') {
    return statusMappings.approve['0'].text  // 待审批
  }

  if (approveStatus === '2') {
    return statusMappings.approve['2'].text  // 已拒绝
  }

  if (approveStatus === '3') {
    return statusMappings.approve['3'].text  // 已取消
  }

  // 审批通过后，根据离校状态判断
  if (approveStatus === '1') {
    const leaveStatusConfig = statusMappings.leave[status]
    return leaveStatusConfig ? leaveStatusConfig.text : '未知状态'
  }

  return '未知状态'
}

// 获取状态描述
const getStatusDescription = (approveStatus, status) => {
  // 审批状态优先级处理
  if (approveStatus === '0') {
    return '您的离校申请正在审批中，请耐心等待'
  }

  if (approveStatus === '2') {
    return '您的离校申请已被拒绝，请查看审批意见'
  }

  if (approveStatus === '3') {
    return '您的离校申请已取消'
  }

  // 审批通过后，根据离校状态判断
  if (approveStatus === '1') {
    const descriptions = {
      '0': '您的离校申请已通过，请注意安全',
      '1': '您已确认返校，欢迎回来',
      '2': '您已逾期未返校，请及时联系管理员'
    }
    return descriptions[status] || ''
  }

  return ''
}

// 判断是否可以取消
const canCancel = (item) => {
  // 只有待审批状态才能取消
  return item && item.approveStatus === '0'
}

// 判断是否可以确认返校
const canReturn = (item) => {
  // 审批通过且状态为离校中才能确认返校，已取消状态不能确认返校
  return item && item.approveStatus === '1' && item.status === '0'
}

// 取消申请
const cancelApplication = async () => {
  try {
    await uni.showModal({
      title: '确认取消',
      content: '确定要取消这个离校申请吗？'
    })

    const response = await cancelLeaveApplication(leaveId.value)

    if (response.code === 200) {
      uni.showToast({
        title: '取消成功',
        icon: 'success'
      })

      // 更新本地状态为已取消
      if (leaveDetail.value) {
        leaveDetail.value.approveStatus = '3'
      }

      // 刷新详情数据以确保状态同步
      setTimeout(() => {
        loadDetail()
      }, 1000)
    } else {
      uni.showToast({
        title: response.msg || '取消失败',
        icon: 'none'
      })
    }

  } catch (error) {
    if (error.errMsg && error.errMsg.includes('cancel')) {
      return
    }
    console.error('取消申请失败:', error)
    uni.showToast({
      title: '操作失败',
      icon: 'none'
    })
  }
}

// 打开地图验证对话框
const openMapValidation = async () => {
  try {
    // 检测运行环境 - 增强版检测
    // #ifdef H5
    isH5.value = true
    // #endif
    
    // 备用H5环境检测
    if (!isH5.value && (typeof window !== 'undefined' && window.location)) {
      isH5.value = true
      console.log('备用H5环境检测成功')
    }
    
    // 重置错误状态
    amapLoadFailed.value = false
    
    // 输出诊断信息
    console.log('🔍 地图验证诊断信息:', {
      isH5: isH5.value,
      amapLoadFailed: amapLoadFailed.value,
      hasWindow: typeof window !== 'undefined',
      hasAMap: !!window.AMap,
      userAgent: typeof window !== 'undefined' ? window.navigator.userAgent : 'N/A'
    })
    
    showMapDialog.value = true
    mapLoading.value = true
    loadingText.value = '初始化地图...'
    
    await nextTick()
    
    // 设置地图中心点
    centerLatitude.value = schoolConfig.latitude
    centerLongitude.value = schoolConfig.longitude
    
    // 初始化地图
    if (isH5.value) {
      console.log('🗺️ 尝试初始化高德地图...')
      await initAmapMap()
    } else {
      console.log('📱 使用原生地图模式')
    }
    
    // 获取当前位置
    await getCurrentLocation()
    
  } catch (error) {
    console.error('打开地图验证失败:', error)
    uni.showToast({
      title: '地图初始化失败',
      icon: 'none'
    })
  } finally {
    mapLoading.value = false
  }
}

// 关闭地图验证对话框
const closeMapDialog = () => {
  showMapDialog.value = false
  
  // 清理高德地图资源
  if (amapInstance.value) {
    amapInstance.value.destroy()
    amapInstance.value = null
  }
  
  // 重置相关状态
  schoolMarker.value = null
  userMarker.value = null
  schoolCircle.value = null
  currentLatitude.value = 0
  currentLongitude.value = 0
  currentAddress.value = ''
  distance.value = 0
  isInSchoolRange.value = false
}

// 初始化高德地图
const initAmapMap = async () => {
  if (!isH5.value) {
    console.log('⚠️ 非H5环境，跳过高德地图初始化')
    return
  }
  
  try {
    console.log('🚀 正在初始化高德地图...')
    
    // 加载高德地图工具
    const utils = await loadAmapUtils()
    if (!utils) {
      console.error('❌ 高德地图工具加载失败，切换到原生地图模式')
      isH5.value = false
      amapLoadFailed.value = true
      return
    }
    
    console.log('✅ 高德地图工具加载成功，开始初始化地图实例')
    
    // 初始化地图实例
    const mapInstance = await utils.safeInitAmapInstance(mapContainerId, {
      zoom: 16,
      center: [schoolConfig.longitude, schoolConfig.latitude]
    })
    
    if (!mapInstance) {
      throw new Error('地图实例初始化返回null')
    }
    
    amapInstance.value = mapInstance
    console.log('✅ 高德地图实例初始化成功')
    
    // 添加学校标记
    await addAmapSchoolMarker()
    
    // 添加学校围栏
    await addAmapSchoolCircle()
    
    console.log('✨ 高德地图初始化完成！')
    
  } catch (error) {
    console.error('❌ 高德地图初始化失败:', error)
    
    // API Key权限问题特殊处理
    if (error.message && (
      error.message.includes('权限') || 
      error.message.includes('USERKEY_PLAT_NOMATCH') ||
      error.message.includes('key不正确') ||
      error.message.includes('API Key权限不匹配')
    )) {
      console.warn('🔑 检测到API Key权限问题，自动切换到原生地图模式')
      uni.showModal({
        title: '地图服务提示',
        content: '高德地图API Key需要配置Web端权限，当前将使用基础地图功能。请联系管理员配置API Key的Web端(JSAPI)权限。',
        showCancel: false,
        confirmText: '知道了'
      })
    } else {
      // 其他错误类型
      console.warn('😨 其他错误原因，切换到原生地图模式:', error.message)
    }
    
    // 自动降级到原生地图
    isH5.value = false
    amapLoadFailed.value = true
    
    // 重新设置中心点
    centerLatitude.value = schoolConfig.latitude
    centerLongitude.value = schoolConfig.longitude
    
    console.log('📱 已切换到原生地图模式')
  }
}

// 添加学校标记
const addAmapSchoolMarker = async () => {
  if (!amapInstance.value || !window.AMap) return
  
  const utils = await loadAmapUtils()
  if (!utils) return
  
  schoolMarker.value = utils.createMarker(amapInstance.value, {
    position: [schoolConfig.longitude, schoolConfig.latitude],
    title: schoolConfig.name,
    icon: new window.AMap.Icon({
      size: new window.AMap.Size(32, 32),
      image: '/static/images/markers/school-marker.svg',
      imageSize: new window.AMap.Size(32, 32)
    }),
    anchor: 'center'
  })
  
  // 添加信息窗
  const infoWindow = new window.AMap.InfoWindow({
    content: `<div style="padding: 8px;">${schoolConfig.name}</div>`,
    anchor: 'bottom-center',
    offset: new window.AMap.Pixel(0, -32)
  })
  
  schoolMarker.value.on('click', () => {
    infoWindow.open(amapInstance.value, schoolMarker.value.getPosition())
  })
}

// 添加学校围栏（优先显示多边形）
const addAmapSchoolCircle = async () => {
  if (!amapInstance.value || !window.AMap) return
  
  const utils = await loadAmapUtils()
  if (!utils) return
  
  // 优先使用多边形围栏
  if (utils.SCHOOL_CONFIG && utils.SCHOOL_CONFIG.polygon && utils.SCHOOL_CONFIG.polygon.path) {
    console.log('🔷 创建多边形学校围栏')
    schoolCircle.value = utils.createPolygon(amapInstance.value, {
      path: utils.SCHOOL_CONFIG.polygon.path,
      strokeColor: utils.SCHOOL_CONFIG.polygon.strokeColor || '#1890ff',
      strokeWeight: utils.SCHOOL_CONFIG.polygon.strokeWeight || 2,
      strokeOpacity: utils.SCHOOL_CONFIG.polygon.strokeOpacity || 0.8,
      fillColor: utils.SCHOOL_CONFIG.polygon.fillColor || '#1890ff',
      fillOpacity: utils.SCHOOL_CONFIG.polygon.fillOpacity || 0.2
    })
    
    if (schoolCircle.value) {
      console.log('✅ 多边形学校围栏显示成功')
    } else {
      console.warn('⚠️ 多边形围栏创建失败，使用圆形围栏')
      // 降级使用圆形围栏
      schoolCircle.value = utils.createCircle(amapInstance.value, {
        center: [schoolConfig.longitude, schoolConfig.latitude],
        radius: schoolConfig.radius,
        strokeColor: '#1890ff',
        strokeWeight: 2,
        strokeOpacity: 0.8,
        fillColor: '#1890ff',
        fillOpacity: 0.2
      })
    }
  } else {
    console.log('🔵 使用圆形学校围栏（多边形配置不完整）')
    // 使用圆形围栏作为备用
    schoolCircle.value = utils.createCircle(amapInstance.value, {
      center: [schoolConfig.longitude, schoolConfig.latitude],
      radius: schoolConfig.radius,
      strokeColor: '#1890ff',
      strokeWeight: 2,
      strokeOpacity: 0.8,
      fillColor: '#1890ff',
      fillOpacity: 0.2
    })
  }
}

// 获取当前位置
const getCurrentLocation = async () => {
  try {
    mapLoading.value = true
    loadingText.value = '正在获取位置...'
    
    let locationResult = null
    
    // H5端优先尝试高德定位
    if (isH5.value && !amapLoadFailed.value) {
      try {
        const utils = await loadAmapUtils()
        if (utils) {
          locationResult = await utils.getAmapLocation({
            timeout: 15000,
            enableHighAccuracy: true
          })
          console.log('高德定位成功:', locationResult)
        }
      } catch (error) {
        console.warn('高德定位失败，将使用uni-app原生定位:', error)
      }
    }
    
    // 如果高德定位失败，使用uni-app原生定位
    if (!locationResult) {
      locationResult = await getUniLocation()
      console.log('uni-app定位成功:', locationResult)
    }
    
    // 更新位置信息
    currentLatitude.value = locationResult.latitude
    currentLongitude.value = locationResult.longitude
    currentAddress.value = locationResult.address || '获取中...'
    
    // 尝试获取地址信息
    if (!locationResult.address || locationResult.address === '获取中...') {
      await getDetailedAddress()
    }
    
    // 计算距离
    if (isH5.value && !amapLoadFailed.value) {
      await calculateAmapDistance()
    } else {
      calculateDistance()
    }
    
    // 更新地图标记
    if (isH5.value && !amapLoadFailed.value) {
      await updateAmapMarkers()
    } else {
      updateUserMarker()
    }
    
    uni.showToast({
      title: '位置获取成功',
      icon: 'success',
      duration: 1500
    })
    
  } catch (error) {
    console.error('获取位置失败:', error)
    
    let errorMessage = '位置获取失败'
    if (error.message) {
      if (error.message.includes('User denied')) {
        errorMessage = '请允许位置权限后重试'
      } else if (error.message.includes('timeout')) {
        errorMessage = '定位超时，请检查GPS是否开启'
      } else if (error.message.includes('network')) {
        errorMessage = '网络连接失败，请检查网络'
      }
    }
    
    uni.showToast({
      title: errorMessage,
      icon: 'none',
      duration: 3000
    })
  } finally {
    mapLoading.value = false
  }
}

// 获取详细地址信息
const getDetailedAddress = async () => {
  if (!currentLatitude.value || !currentLongitude.value) return
  
  try {
    // 尝试使用高德地址逆解析
    if (isH5.value && !amapLoadFailed.value) {
      const utils = await loadAmapUtils()
      if (utils) {
        const address = await utils.getAddressByLocation(currentLongitude.value, currentLatitude.value)
        if (address) {
          currentAddress.value = address
          console.log('高德地址解析成功:', address)
          return
        }
      }
    }
    
    // 如果高德解析失败，显示坐标信息
    currentAddress.value = `${currentLatitude.value.toFixed(6)}, ${currentLongitude.value.toFixed(6)}`
    
  } catch (error) {
    console.warn('地址解析失败:', error)
    currentAddress.value = `${currentLatitude.value.toFixed(6)}, ${currentLongitude.value.toFixed(6)}`
  }
}

// uni-app原生定位
const getUniLocation = () => {
  return new Promise((resolve, reject) => {
    uni.getLocation({
      type: 'wgs84',
      geocode: false,
      isHighAccuracy: false,
      timeout: 10000,
      success: (res) => {
        // WGS84转GCJ02坐标转换
        const converted = wgs84ToGcj02(res.longitude, res.latitude)
        resolve({
          latitude: converted.latitude,
          longitude: converted.longitude,
          accuracy: res.accuracy || 0,
          address: '',
          timestamp: Date.now()
        })
      },
      fail: (error) => {
        console.error('uni-app定位失败:', error)
        reject(new Error(error.errMsg || '定位失败'))
      }
    })
  })
}

// WGS84转GCJ02坐标系转换
const wgs84ToGcj02 = (lng, lat) => {
  const PI = 3.1415926535897932384626
  const ee = 0.00669342162296594323
  const a = 6378245.0
  
  const transformLat = (lng, lat) => {
    let ret = -100.0 + 2.0 * lng + 3.0 * lat + 0.2 * lat * lat + 0.1 * lng * lat + 0.2 * Math.sqrt(Math.abs(lng))
    ret += (20.0 * Math.sin(6.0 * lng * PI) + 20.0 * Math.sin(2.0 * lng * PI)) * 2.0 / 3.0
    ret += (20.0 * Math.sin(lat * PI) + 40.0 * Math.sin(lat / 3.0 * PI)) * 2.0 / 3.0
    ret += (160.0 * Math.sin(lat / 12.0 * PI) + 320 * Math.sin(lat * PI / 30.0)) * 2.0 / 3.0
    return ret
  }
  
  const transformLng = (lng, lat) => {
    let ret = 300.0 + lng + 2.0 * lat + 0.1 * lng * lng + 0.1 * lng * lat + 0.1 * Math.sqrt(Math.abs(lng))
    ret += (20.0 * Math.sin(6.0 * lng * PI) + 20.0 * Math.sin(2.0 * lng * PI)) * 2.0 / 3.0
    ret += (20.0 * Math.sin(lng * PI) + 40.0 * Math.sin(lng / 3.0 * PI)) * 2.0 / 3.0
    ret += (150.0 * Math.sin(lng / 12.0 * PI) + 300.0 * Math.sin(lng / 30.0 * PI)) * 2.0 / 3.0
    return ret
  }
  
  const dlat = transformLat(lng - 105.0, lat - 35.0)
  const dlng = transformLng(lng - 105.0, lat - 35.0)
  const radlat = lat / 180.0 * PI
  let magic = Math.sin(radlat)
  magic = 1 - ee * magic * magic
  const sqrtmagic = Math.sqrt(magic)
  const dlat_result = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * PI)
  const dlng_result = (dlng * 180.0) / (a / sqrtmagic * Math.cos(radlat) * PI)
  
  return {
    longitude: lng + dlng_result,
    latitude: lat + dlat_result
  }
}

// 高德地图距离计算（使用多边形围栏）
const calculateAmapDistance = async () => {
  try {
    const utils = await loadAmapUtils()
    if (utils && currentLatitude.value && currentLongitude.value) {
      // 使用新的多边形围栏检查功能
      const rangeResult = utils.checkSchoolRange(currentLongitude.value, currentLatitude.value)
      
      // 更新距离和范围状态
      distance.value = rangeResult.distance
      isInSchoolRange.value = rangeResult.isInRange
      
      console.log(`✅ 多边形围栏检查结果:`, {
        type: rangeResult.type,
        distance: `${rangeResult.distance.toFixed(2)}米`,
        inRange: rangeResult.isInRange,
        message: rangeResult.message
      })
      
      return
    }
    
    // 如果工具加载失败，使用备用方法
    console.warn('⚙️ 高德工具不可用，使用备用计算方法')
    calculateDistance()
    
  } catch (error) {
    console.error('❌ 高德距离计算失败:', error)
    calculateDistance() // 使用备用方法
  }
}

// 备用距离计算方法（Haversine公式）
const calculateDistance = () => {
  const lat1 = currentLatitude.value
  const lon1 = currentLongitude.value
  const lat2 = schoolConfig.latitude
  const lon2 = schoolConfig.longitude
  
  // 验证坐标有效性
  if (!lat1 || !lon1 || !lat2 || !lon2) {
    console.warn('坐标参数无效，无法计算距离')
    distance.value = 0
    isInSchoolRange.value = false
    return
  }
  
  try {
    // Haversine公式计算
    const R = 6371000
    const dLat = (lat2 - lat1) * Math.PI / 180
    const dLon = (lon2 - lon1) * Math.PI / 180
    const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
              Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
              Math.sin(dLon/2) * Math.sin(dLon/2)
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    const calculatedDistance = R * c
    
    // 确保结果是有效数值
    if (typeof calculatedDistance === 'number' && !isNaN(calculatedDistance) && calculatedDistance >= 0) {
      distance.value = calculatedDistance
    } else {
      distance.value = 0
    }
    
    isInSchoolRange.value = distance.value <= schoolConfig.radius
    console.log(`计算距离: ${distance.value.toFixed(2)}米, 在范围内: ${isInSchoolRange.value}`)
  } catch (error) {
    console.error('距离计算出现错误:', error)
    distance.value = 0
    isInSchoolRange.value = false
  }
}

// 更新高德地图标记
const updateAmapMarkers = async () => {
  if (!amapInstance.value || !window.AMap) return
  
  // 移除旧的用户标记
  if (userMarker.value) {
    userMarker.value.setMap(null)
  }
  
  const utils = await loadAmapUtils()
  if (!utils) return
  
  // 添加新的用户标记
  userMarker.value = utils.createMarker(amapInstance.value, {
    position: [currentLongitude.value, currentLatitude.value],
    title: '我的位置',
    icon: new window.AMap.Icon({
      size: new window.AMap.Size(28, 28),
      image: '/static/images/markers/user-marker.svg',
      imageSize: new window.AMap.Size(28, 28)
    }),
    anchor: 'center'
  })
  
  // 添加信息窗
  const distanceText = formatDistance(distance.value)
  const infoWindow = new window.AMap.InfoWindow({
    content: `<div style="padding: 8px;">我的位置 (${distanceText})</div>`,
    anchor: 'bottom-center',
    offset: new window.AMap.Pixel(0, -28)
  })
  
  userMarker.value.on('click', () => {
    infoWindow.open(amapInstance.value, userMarker.value.getPosition())
  })
  
  // 调整地图视野包含两个标记
  const bounds = new window.AMap.Bounds(
    [Math.min(schoolConfig.longitude, currentLongitude.value), Math.min(schoolConfig.latitude, currentLatitude.value)],
    [Math.max(schoolConfig.longitude, currentLongitude.value), Math.max(schoolConfig.latitude, currentLatitude.value)]
  )
  
  amapInstance.value.setBounds(bounds, false, [50, 50, 50, 50])
}

// 更新用户位置标记
const updateUserMarker = () => {
  const distanceText = formatDistance(distance.value)
  
  const userMarkerData = {
    id: 2,
    latitude: currentLatitude.value,
    longitude: currentLongitude.value,
    title: '我的位置',
    iconPath: '/static/images/markers/user-marker.svg',
    width: 28,
    height: 28,
    callout: {
      content: `我的位置 (${distanceText})`,
      color: '#333',
      bgColor: isInSchoolRange.value ? '#f6ffed' : '#fff2f0',
      padding: 8,
      borderRadius: 4
    }
  }
  
  // 更新标记数组：保留学校标记，添加用户标记
  markers.value = [markers.value[0], userMarkerData]
}

// 刷新位置
const refreshLocation = () => {
  getCurrentLocation()
}

// 地图验证成功后确认返校
const confirmReturnWithLocation = async () => {
  if (!isInSchoolRange.value) {
    uni.showToast({
      title: '请在学校范围内确认返校',
      icon: 'none',
      duration: 2000
    })
    return
  }

  try {
    mapLoading.value = true
    loadingText.value = '正在确认返校...'
    
    const response = await apiConfirmReturn(leaveId.value)
    
    if (response.code === 200) {
      uni.showToast({
        title: '返校确认成功',
        icon: 'success'
      })
      
      // 关闭对话框并刷新详情
      closeMapDialog()
      setTimeout(() => {
        loadDetail()
      }, 500)
    } else {
      uni.showToast({
        title: response.msg || '确认失败',
        icon: 'none'
      })
    }
  } catch (error) {
    console.error('确认返校失败:', error)
    uni.showToast({
      title: '确认失败，请重试',
      icon: 'none'
    })
  } finally {
    mapLoading.value = false
  }
}

// 地图事件处理
const onMarkerTap = (e) => {
  console.log('标记点击:', e)
}

const onMapUpdated = (e) => {
  console.log('地图更新:', e)
}

// 确认返校（原始方法，保留作为备用）
const confirmReturn = async () => {
  try {
    const [err, res] = await uni.showModal({
      title: '确认返校',
      content: '确定已经返校了吗？'
    })
    
    // 用户点击取消按钮
    if (err || !res.confirm) {
      return
    }

    const response = await apiConfirmReturn(leaveId.value)

    if (response.code === 200) {
      uni.showToast({
        title: '返校确认成功',
        icon: 'success'
      })

      // 刷新详情
      loadDetail()
    } else {
      uni.showToast({
        title: response.msg || '确认失败',
        icon: 'none'
      })
    }

  } catch (error) {
    console.error('确认返校失败:', error)
    uni.showToast({
      title: '操作失败',
      icon: 'none'
    })
  }
}

// 返回上一页
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

.navbar-left,
.navbar-right {
  width: 80rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.navbar-left .iconfont {
  color: white;
  font-size: 40rpx;
  font-weight: bold;
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

.main-content {
  margin-top: 88rpx;
  padding: 30rpx;
}

.loading-container,
.error-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 100rpx 0;
}

.loading-text,
.error-text {
  color: #666;
  font-size: 28rpx;
  margin-bottom: 30rpx;
}

.retry-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 40rpx;
  padding: 20rpx 60rpx;
  font-size: 28rpx;
}

.detail-container {
  display: flex;
  flex-direction: column;
  gap: 30rpx;
}

.status-card {
  background: white;
  border-radius: 20rpx;
  padding: 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}

.status-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.status-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.status-tag {
  padding: 8rpx 16rpx;
  border-radius: 20rpx;
  font-size: 24rpx;
  font-weight: bold;
}

// 审批状态样式
.status-tag.pending {
  background: #fff3cd;
  color: #856404;
}

.status-tag.approved {
  background: #d4edda;
  color: #155724;
}

.status-tag.rejected {
  background: #f5c6cb;
  color: #721c24;
}

.status-tag.cancelled {
  background: #e9ecef;
  color: #6c757d;
}

// 离校状态样式
.status-tag.away {
  background: #cce5ff;
  color: #0066cc;
}

.status-tag.returned {
  background: #d4edda;
  color: #155724;
}

.status-tag.overdue {
  background: #f8d7da;
  color: #721c24;
}

.status-content {
  padding: 20rpx;
  background: #f8f9fa;
  border-radius: 12rpx;
}

.status-desc {
  font-size: 28rpx;
  color: #666;
  line-height: 1.5;
}

.info-card {
  background: white;
  border-radius: 20rpx;
  padding: 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}

.card-title {
  margin-bottom: 30rpx;
}

.card-title text {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.info-list {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.info-label {
  font-size: 28rpx;
  color: #666;
  min-width: 160rpx;
}

.info-value {
  font-size: 28rpx;
  color: #333;
  flex: 1;
  text-align: right;
  word-break: break-all;
}

.reason-content {
  padding: 20rpx;
  background: #f8f9fa;
  border-radius: 12rpx;
}

.reason-text {
  font-size: 28rpx;
  color: #333;
  line-height: 1.6;
}

.action-section {
  display: flex;
  gap: 20rpx;
  padding: 20rpx 0;
}

.action-btn {
  flex: 1;
  height: 88rpx;
  border: none;
  border-radius: 44rpx;
  font-size: 32rpx;
  font-weight: bold;
  display: flex;
  align-items: center;
  justify-content: center;
}

.cancel-btn {
  background: #ff4d4f;
  color: white;
}

.return-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.action-btn:active {
  transform: scale(0.98);
}

// 地图验证对话框样式
.map-dialog-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 2000;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40rpx;
}

.map-dialog {
  background: white;
  border-radius: 20rpx;
  width: 100%;
  max-width: 600rpx;
  max-height: 80vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  position: relative;
}

.dialog-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.dialog-title {
  font-size: 32rpx;
  font-weight: bold;
}

.close-btn {
  width: 60rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.2);
}

.close-icon {
  font-size: 36rpx;
  color: white;
}

.map-container {
  height: 400rpx;
  position: relative;
  overflow: hidden;
}

.amap-container {
  width: 100%;
  height: 100%;
  position: relative;
}

.amap-instance {
  width: 100%;
  height: 100%;
}

.native-map {
  width: 100%;
  height: 100%;
}

.map-loading {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.9);
  z-index: 10;
}

.location-info-panel {
  padding: 30rpx;
  background: #f8f9fa;
  border-top: 1rpx solid #e9ecef;
}

.location-info-panel .info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.location-info-panel .info-item:last-child {
  margin-bottom: 0;
}

.location-info-panel .info-label {
  font-size: 28rpx;
  color: #666;
  min-width: 160rpx;
}

.location-info-panel .info-value {
  font-size: 28rpx;
  color: #333;
  flex: 1;
  text-align: right;
  font-weight: bold;
}

.location-info-panel .info-value.in-range {
  color: #52c41a;
}

.location-info-panel .info-value.out-range {
  color: #ff4d4f;
}

.validation-status {
  margin-top: 20rpx;
  padding: 20rpx;
  border-radius: 12rpx;
  text-align: center;
}

.status-text {
  font-size: 28rpx;
  font-weight: bold;
}

.status-text.status-loading {
  color: #1890ff;
}

.status-text.status-success {
  color: #52c41a;
}

.status-text.status-warning {
  color: #ff4d4f;
}

.dialog-actions {
  display: flex;
  padding: 30rpx;
  gap: 20rpx;
  border-top: 1rpx solid #f0f0f0;
}

.btn {
  flex: 1;
  height: 80rpx;
  border: none;
  border-radius: 40rpx;
  font-size: 28rpx;
  font-weight: bold;
  display: flex;
  align-items: center;
  justify-content: center;
}

.refresh-btn {
  background: #f0f0f0;
  color: #666;
}

.confirm-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.confirm-btn.disabled {
  background: #d9d9d9;
  color: #999;
}

.btn-text {
  font-size: 28rpx;
}

.dialog-loading {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 255, 255, 0.9);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
}

.loading-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20rpx;
}

.loading-spinner {
  width: 60rpx;
  height: 60rpx;
  border: 4rpx solid #f3f3f3;
  border-top: 4rpx solid #1890ff;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>
