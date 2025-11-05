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
          <text>申请详情</text>
        </view>
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
          <!-- 
            provider说明：
            - "amap": 高德地图（需在manifest.json配置Android SDK Key）
            - "tencent": 腾讯地图（默认，无需配置，坐标系也是GCJ02）
            - 如果不配置高德SDK，自动使用腾讯地图
          -->
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
            :polyline="polyline"
            :provider="mapProvider"
            @markertap="onMarkerTap"
            @updated="onMapUpdated"
          >
          </map>
        </view>

        <!-- 位置信息面板 -->
        <view class="location-info-panel">
          <view class="info-item address-item">
            <text class="info-label">当前位置：</text>
            <text class="info-value address-text">{{ currentAddress || '获取中...' }}</text>
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
import { onLoad } from '@dcloudio/uni-app'
import {
  getLeaveApplicationDetail,
  cancelLeaveApplication,
  confirmReturn as apiConfirmReturn
} from '@/api/leave/registration'

// 静态导入高德地图工具（避免动态导入导致代码分割）
// 注意：虽然只在H5环境使用高德地图API，但学校配置需要在所有环境使用
import * as amapUtilsModule from '@/utils/amap.js'

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

// 地图提供商：优先使用高德地图，如果未配置则使用腾讯地图
// 注意：需要在manifest.json中配置高德地图Android SDK Key才能使用provider="amap"
// 如果使用腾讯地图，坐标系也是GCJ02，与高德地图一致，无需转换
const mapProvider = ref('tencent') // 'amap' 或 'tencent'

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

// 学校配置（默认值，会在onLoad时从amap.js加载实际配置）
const schoolConfig = {
  name: '学校',
  latitude: 27.930826, // 默认坐标，会从amap.js的SCHOOL_CONFIG加载
  longitude: 120.959226,
  radius: 500, // 学校围栏半径，单位：米
}

// 获取高德地图工具（改为静态导入，避免代码分割）
const loadAmapUtils = () => {
  // H5环境返回完整工具，App环境返回null（不使用高德API）
  // #ifdef H5
  if (isH5.value && amapUtilsModule) {
    // 更新学校配置为高德的配置
    if (amapUtilsModule.SCHOOL_CONFIG) {
      Object.assign(schoolConfig, amapUtilsModule.SCHOOL_CONFIG)
      console.log('⚙️ 学校配置已更新:', schoolConfig)
    }
    return amapUtilsModule
  }
  // #endif
  
  // App环境：虽然不使用高德API，但需要加载学校配置
  if (amapUtilsModule && amapUtilsModule.SCHOOL_CONFIG) {
    Object.assign(schoolConfig, amapUtilsModule.SCHOOL_CONFIG)
    console.log('⚙️ App环境：学校配置已加载:', schoolConfig)
  }
  
  return null
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

// 圆形围栏可视化（备用方案，如果多边形配置不完整时使用）
const circles = ref([
  {
    latitude: schoolConfig.latitude,
    longitude: schoolConfig.longitude,
    radius: schoolConfig.radius,
    color: '#1890ff40',
    fillColor: '#1890ff20',
    strokeWidth: 5  // 加粗边框：从2增加到5
  }
])

// 多边形围栏折线（使用polyline绘制多边形边界）
const polyline = ref([])

// 初始化多边形围栏折线
const initPolygonPolyline = () => {
  // 检查是否有多边形配置
  if (schoolConfig.polygon && schoolConfig.polygon.path && schoolConfig.polygon.path.length >= 3) {
    // 将多边形坐标转换为polyline格式
    // uni-app的polyline需要points数组，格式：[{latitude: 纬度, longitude: 经度}, ...]
    const points = schoolConfig.polygon.path.map(coord => ({
      latitude: coord[1], // 注意：coord是[经度, 纬度]，polyline需要[纬度, 经度]
      longitude: coord[0]
    }))
    
    // 创建闭合的折线（最后一个点回到起点）
    if (points.length > 0 && 
        (points[points.length - 1].latitude !== points[0].latitude || 
         points[points.length - 1].longitude !== points[0].longitude)) {
      points.push(points[0]) // 确保闭合
    }
    
    polyline.value = [
      {
        points: points,
        // 使用更醒目的颜色和更粗的线条
        color: schoolConfig.polygon.strokeColor || '#1890ff',
        width: schoolConfig.polygon.strokeWeight || 5, // 加粗线条：从2增加到5
        borderColor: schoolConfig.polygon.strokeColor || '#1890ff',
        borderWidth: schoolConfig.polygon.strokeWeight || 5, // 加粗边框：从2增加到5
        arrowLine: false, // 不显示箭头
        arrowIconPath: '',
        dottedLine: false // 实线
      }
    ]
    
    // 清空圆形围栏，因为使用了多边形
    circles.value = []
    
    console.log('✅ 多边形围栏折线已初始化，点数:', points.length)
  } else {
    // 如果没有多边形配置，使用圆形围栏
    console.log('⚠️ 多边形配置不完整，使用圆形围栏')
    polyline.value = []
  }
}

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

// 页面加载时获取参数
onLoad((options) => {
  // 获取状态栏高度
  const systemInfo = uni.getSystemInfoSync()
  statusBarHeight.value = systemInfo.statusBarHeight || 0
  
  // 初始化时加载学校配置（确保所有环境都能获取正确的学校坐标）
  loadAmapUtils()
  
  // 初始化多边形围栏折线（App端使用polyline绘制多边形边界）
  initPolygonPolyline()
  
  // 设置地图提供商
  // 注意：腾讯地图使用GCJ02坐标系，与高德地图一致，无需坐标转换
  // 如果后续需要切换到高德地图，需要在manifest.json中配置Android SDK Key
  // #ifdef APP-PLUS
  mapProvider.value = 'tencent' // 使用腾讯地图（GCJ02坐标系）
  console.log('🗺️ App环境：使用腾讯地图（GCJ02坐标系，与高德一致）')
  // #endif
  
  // 从页面参数中获取 id
  if (options && options.id) {
    leaveId.value = options.id
    loadDetail()
    // 注意：自动打开地图验证的逻辑在 loadDetail() 中处理
  } else {
    // 备用方案：从 getCurrentPages 获取
    const pages = getCurrentPages()
    if (pages && pages.length > 0) {
      const currentPage = pages[pages.length - 1]
      if (currentPage && currentPage.options) {
        leaveId.value = currentPage.options.id || ''
      }
    }
    
    if (leaveId.value) {
      loadDetail()
    } else {
      uni.showToast({
        title: '参数错误',
        icon: 'none'
      })
    }
  }
})

// 初始化页面（保留用于其他初始化逻辑）
const initPage = () => {
  // 状态栏高度已在 onLoad 中设置
}

// 加载详情
const loadDetail = async () => {
  if (!leaveId.value) return
  
  try {
    loading.value = true
    
    const response = await getLeaveApplicationDetail(leaveId.value)
    
    if (response.code === 200) {
      leaveDetail.value = response.data
      
      // 检查是否需要自动打开地图验证（从URL参数获取）
      const pages = getCurrentPages()
      if (pages && pages.length > 0) {
        const currentPage = pages[pages.length - 1]
        if (currentPage && currentPage.options && currentPage.options.autoOpenMap === 'true') {
          // 延迟打开地图验证，确保数据已加载
          setTimeout(() => {
            if (canReturn(leaveDetail.value)) {
              openMapValidation()
            } else {
              uni.showToast({
                title: '当前状态无法确认返校',
                icon: 'none'
              })
            }
          }, 300)
        }
      }
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
    // 检测运行环境 - 使用uni-app平台判断
    // #ifdef H5
    isH5.value = true
    // #endif
    
    // #ifndef H5
    isH5.value = false
    // #endif
    
    // 双重检查：确保真机环境下不会误判
    // 在真机环境下，通常没有 window.document 或 window.location
    const hasWindow = typeof window !== 'undefined'
    const hasDocument = hasWindow && typeof document !== 'undefined'
    const hasLocation = hasWindow && typeof window.location !== 'undefined'
    
    // 如果检测为H5但实际没有document或location，说明可能是误判
    if (isH5.value && (!hasDocument || !hasLocation)) {
      console.warn('⚠️ 检测到H5环境但缺少关键对象，切换到原生模式')
      isH5.value = false
    }
    
    // 重置错误状态
    amapLoadFailed.value = false
    
    // 输出诊断信息（安全访问）
    const hasAMap = hasWindow && typeof window.AMap !== 'undefined' && !!window.AMap
    console.log('🔍 地图验证诊断信息:', {
      isH5: isH5.value,
      amapLoadFailed: amapLoadFailed.value,
      hasWindow: hasWindow,
      hasDocument: hasDocument,
      hasLocation: hasLocation,
      hasAMap: hasAMap,
      userAgent: hasWindow && window.navigator ? window.navigator.userAgent : 'N/A',
      platform: uni.getSystemInfoSync().platform || 'unknown'
    })
    
    showMapDialog.value = true
    mapLoading.value = true
    loadingText.value = '初始化地图...'
    
    await nextTick()
    
    // 设置地图中心点
    centerLatitude.value = schoolConfig.latitude
    centerLongitude.value = schoolConfig.longitude
    
    // 重新初始化多边形围栏折线（确保使用最新的配置）
    initPolygonPolyline()
    
    // 初始化地图（只在确认是H5环境时）
    if (isH5.value && hasDocument && hasLocation) {
      console.log('🗺️ 尝试初始化高德地图...')
      await initAmapMap()
    } else {
      console.log('📱 使用原生地图模式')
      // 确保在非H5环境下不会尝试初始化高德地图
      isH5.value = false
      amapLoadFailed.value = true
    }
    
    // 获取当前位置
    await getCurrentLocation()
    
  } catch (error) {
    console.error('打开地图验证失败:', error)
    
    // 如果是window相关的错误，自动切换到原生模式
    if (error.message && (
      error.message.includes('window') || 
      error.message.includes('AMap') ||
      error.message.includes('Cannot read property')
    )) {
      console.warn('⚠️ 检测到环境相关错误，切换到原生地图模式')
      isH5.value = false
      amapLoadFailed.value = true
      
      // 重新获取位置（使用原生定位）
      try {
        await getCurrentLocation()
      } catch (locError) {
        console.error('原生定位也失败:', locError)
      }
    } else {
      uni.showToast({
        title: '地图初始化失败',
        icon: 'none'
      })
    }
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
    const utils = loadAmapUtils()
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
  // 检查环境：只在H5环境下且AMap可用时执行
  if (!isH5.value || typeof window === 'undefined' || !window.AMap) {
    console.log('⚠️ 非H5环境或AMap不可用，跳过高德标记添加')
    return
  }
  
  if (!amapInstance.value) return
  
  const utils = loadAmapUtils()
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
  // 检查环境：只在H5环境下且AMap可用时执行
  if (!isH5.value || typeof window === 'undefined' || !window.AMap) {
    console.log('⚠️ 非H5环境或AMap不可用，跳过高德围栏添加')
    return
  }
  
  if (!amapInstance.value) return
  
  const utils = loadAmapUtils()
  if (!utils) return
  
  // 优先使用多边形围栏
  if (utils.SCHOOL_CONFIG && utils.SCHOOL_CONFIG.polygon && utils.SCHOOL_CONFIG.polygon.path) {
    console.log('🔷 创建多边形学校围栏')
    schoolCircle.value = utils.createPolygon(amapInstance.value, {
      path: utils.SCHOOL_CONFIG.polygon.path,
      strokeColor: utils.SCHOOL_CONFIG.polygon.strokeColor || '#1890ff',
      strokeWeight: utils.SCHOOL_CONFIG.polygon.strokeWeight || 5, // 加粗：从2增加到5
      strokeOpacity: utils.SCHOOL_CONFIG.polygon.strokeOpacity || 1.0, // 不透明：从0.8增加到1.0
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
        strokeWeight: 5, // 加粗：从2增加到5
        strokeOpacity: 1.0, // 不透明：从0.8增加到1.0
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
        const utils = loadAmapUtils()
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
      try {
        locationResult = await getUniLocation()
        console.log('✅ uni-app原生定位成功:', locationResult)
      } catch (error) {
        console.error('❌ uni-app原生定位也失败:', error)
        throw error // 重新抛出错误，让外层处理
      }
    }
    
    // 更新位置信息
    currentLatitude.value = locationResult.latitude
    currentLongitude.value = locationResult.longitude
    
    // 处理地址信息
    if (locationResult.address) {
      // 如果已经有格式化后的地址，直接使用
      currentAddress.value = locationResult.address
    } else if (locationResult.addressDetail) {
      // 如果有地址对象，进行格式化
      currentAddress.value = formatAddress(locationResult.addressDetail)
    } else {
      // 如果没有地址信息，尝试获取详细地址
      currentAddress.value = '获取中...'
      await getDetailedAddress()
    }
    
    // 如果地址仍然为空或无效，尝试获取详细地址
    if (!currentAddress.value || currentAddress.value === '获取中...' || currentAddress.value.trim() === '') {
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
    
    // 移除弹窗提示，因为：
    // 1. 地图上已经显示位置标记，用户可以直接看到
    // 2. 位置信息面板已经显示当前位置和距离
    // 3. 避免多次调用时弹窗叠加或冲突
    // 只在控制台输出日志
    console.log('✅ 位置获取成功，已更新地图标记')
    
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
      const utils = loadAmapUtils()
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

// 格式化地址信息（将地址对象转换为可读字符串）
const formatAddress = (address) => {
  if (!address) return ''
  
  // 如果address是字符串，直接返回
  if (typeof address === 'string') {
    return address
  }
  
  // 如果address是对象，格式化地址字符串
  if (typeof address === 'object') {
    // 优先显示POI名称（如果有），这是最精确的位置信息
    if (address.poiName) {
      // POI名称通常已包含位置信息，直接返回POI名称
      // 例如：浙江工贸职业技术学院(瓯江口校区)
      return address.poiName
    }
    
    // 如果没有POI名称，组合省市区街道信息
    const parts = []
    
    // 拼接省市区
    if (address.province) {
      parts.push(address.province)
    }
    if (address.city && address.city !== address.province) {
      parts.push(address.city)
    }
    if (address.district) {
      parts.push(address.district)
    }
    
    // 拼接街道和门牌号
    if (address.street) {
      parts.push(address.street)
    }
    if (address.streetNum) {
      parts.push(address.streetNum)
    }
    
    // 组合地址字符串
    return parts.join('')
  }
  
  return ''
}

// uni-app原生定位
const getUniLocation = () => {
  return new Promise((resolve, reject) => {
    uni.getLocation({
      // 直接使用GCJ02坐标系（高德/腾讯/百度坐标系），与高德地图一致
      // 注意：在App端，uni-app会自动处理坐标系转换，无需手动转换
      type: 'gcj02',
      geocode: true, // 启用地理编码，获取地址信息
      isHighAccuracy: true, // 启用高精度定位（GPS定位）
      altitude: false, // 不需要海拔信息，节省资源
      timeout: 15000, // 增加超时时间，确保GPS定位完成
      success: (res) => {
        console.log('📍 uni-app定位成功:', {
          latitude: res.latitude,
          longitude: res.longitude,
          accuracy: res.accuracy,
          address: res.address
        })
        
        // 格式化地址信息
        const formattedAddress = formatAddress(res.address)
        
        resolve({
          latitude: res.latitude,
          longitude: res.longitude,
          accuracy: res.accuracy || 0,
          address: formattedAddress, // 格式化后的地址字符串
          addressDetail: res.address, // 保留原始地址对象，供后续使用
          timestamp: Date.now()
        })
      },
      fail: (error) => {
        console.error('❌ uni-app定位失败:', error)
        
        // 如果是权限问题，给出明确提示
        let errorMsg = error.errMsg || '定位失败'
        if (errorMsg.includes('permission') || errorMsg.includes('权限')) {
          errorMsg = '请允许位置权限后重试'
        } else if (errorMsg.includes('timeout')) {
          errorMsg = '定位超时，请检查GPS是否开启'
        }
        
        reject(new Error(errorMsg))
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
    const utils = loadAmapUtils()
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
  // 检查环境：只在H5环境下且AMap可用时执行
  if (!isH5.value || typeof window === 'undefined' || !window.AMap) {
    console.log('⚠️ 非H5环境或AMap不可用，跳过高德标记更新')
    return
  }
  
  if (!amapInstance.value) return
  
  // 移除旧的用户标记
  if (userMarker.value) {
    userMarker.value.setMap(null)
  }
  
  const utils = loadAmapUtils()
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
// 注意：参数获取已在 onLoad 中处理，onMounted 不再需要调用 initPage
onMounted(() => {
  // 其他需要在组件挂载后的初始化逻辑可以在这里添加
})
</script>

<style lang="scss" scoped>
.page-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background: linear-gradient(180deg, #f8f9fa 0%, #ffffff 100%);
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
  background: linear-gradient(180deg, #f8f9fa 0%, #ffffff 100%);
}

.loading-container,
.error-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 100rpx 0;
  min-height: 60vh;
}

.loading-text,
.error-text {
  color: #666;
  font-size: 32rpx;
  margin-bottom: 30rpx;
  text-align: center;
  letter-spacing: 1rpx;
}

.retry-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 50rpx;
  padding: 24rpx 80rpx;
  font-size: 32rpx;
  font-weight: bold;
  position: relative;
  overflow: hidden;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.1);
}

.retry-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: left 0.5s ease;
}

.retry-btn:active::before {
  left: 100%;
}

.retry-btn:active {
  transform: scale(0.96);
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.15);
}

.detail-container {
  padding: 30rpx;
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}

.status-card {
  background: white;
  border-radius: 24rpx;
  padding: 30rpx;
  box-shadow: 0 8rpx 32rpx rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.status-card:active {
  transform: scale(0.98);
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.05);
}

.status-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24rpx;
}

.status-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #333;
}

.status-tag {
  padding: 6rpx 20rpx;
  border-radius: 20rpx;
  font-size: 24rpx;
  color: #fff;
  font-weight: 500;
}

// 审批状态样式
.status-tag.pending {
  background: linear-gradient(135deg, #ffa500, #ff8c00);  // 待审批 - 橙色渐变
}

.status-tag.approved {
  background: linear-gradient(135deg, #52c41a, #389e0d);  // 已批准 - 绿色渐变
}

.status-tag.rejected {
  background: linear-gradient(135deg, #ff4d4f, #cf1322);  // 已拒绝 - 红色渐变
}

.status-tag.cancelled {
  background: linear-gradient(135deg, #6c757d, #545b62);  // 已取消 - 灰色渐变
}

// 离校状态样式
.status-tag.away {
  background: linear-gradient(135deg, #1890ff, #096dd9);  // 离校中 - 蓝色渐变
}

.status-tag.returned {
  background: linear-gradient(135deg, #52c41a, #389e0d);  // 已返校 - 绿色渐变
}

.status-tag.overdue {
  background: linear-gradient(135deg, #ff4d4f, #cf1322);  // 逾期未返 - 红色渐变
}

.status-content {
  padding: 24rpx;
  background: #f8f9fa;
  border-radius: 16rpx;
}

.status-desc {
  font-size: 28rpx;
  color: #666;
  line-height: 1.6;
}

.info-card {
  background: white;
  border-radius: 24rpx;
  padding: 30rpx;
  box-shadow: 0 8rpx 32rpx rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.info-card:active {
  transform: scale(0.98);
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.05);
}

.card-title {
  margin-bottom: 30rpx;
  padding-bottom: 20rpx;
  border-bottom: 2rpx solid #f0f0f0;
  position: relative;
}

.card-title::after {
  content: '';
  position: absolute;
  bottom: -2rpx;
  left: 0;
  width: 60rpx;
  height: 6rpx;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 6rpx;
}

.card-title text {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  letter-spacing: 1rpx;
}

.info-list {
  .info-item {
    display: flex;
    margin-bottom: 16rpx;
    align-items: center;
    
    .info-label {
      width: 160rpx;
      font-size: 28rpx;
      color: #666;
      flex-shrink: 0;
    }
    
    .info-value {
      flex: 1;
      font-size: 28rpx;
      color: #333;
      font-weight: 500;
    }
  }
  
  .info-item:last-child {
    margin-bottom: 0;
  }
}

.reason-content {
  padding: 24rpx;
  background: #f8f9fa;
  border-radius: 16rpx;
  position: relative;
}

.reason-content::before {
  content: '';
  position: absolute;
  top: 24rpx;
  left: 24rpx;
  width: 4rpx;
  height: 32rpx;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 4rpx;
}

.reason-text {
  font-size: 28rpx;
  color: #333;
  line-height: 1.6;
  padding-left: 36rpx;
}

.action-section {
  display: flex;
  gap: 24rpx;
  padding: 24rpx 0;
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
  position: relative;
  overflow: hidden;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.1);
}

.action-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: left 0.5s ease;
}

.action-btn:active::before {
  left: 100%;
}

.cancel-btn {
  background: linear-gradient(135deg, #ff4d4f 0%, #cf1322 100%);
  color: white;
}

.return-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.action-btn:active {
  transform: scale(0.96);
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.15);
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
  backdrop-filter: blur(8rpx);
}

.map-dialog {
  background: white;
  border-radius: 32rpx;
  width: 100%;
  max-width: 600rpx;
  max-height: 80vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  position: relative;
  box-shadow: 0 16rpx 64rpx rgba(0, 0, 0, 0.15);
  transform: scale(0.95);
  animation: dialogSlideIn 0.3s ease forwards;
}

@keyframes dialogSlideIn {
  to {
    transform: scale(1);
  }
}

.dialog-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 32rpx 32rpx 0 0;
}

.dialog-title {
  font-size: 32rpx;
  font-weight: bold;
  letter-spacing: 2rpx;
}

.close-btn {
  width: 60rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.2);
  transition: background-color 0.3s ease, transform 0.2s ease;
}

.close-btn:active {
  background: rgba(255, 255, 255, 0.3);
  transform: scale(0.9);
}

.close-icon {
  font-size: 36rpx;
  color: white;
}

.map-container {
  height: 400rpx;
  position: relative;
  overflow: hidden;
  border-bottom: 1rpx solid #f0f0f0;
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
  border-radius: 0 0 16rpx 16rpx;
}

.location-info-panel {
  padding: 30rpx;
  background: #f8f9fa;
  border-top: 1rpx solid #e9ecef;
}

.location-info-panel .info-item {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 24rpx;
  padding: 8rpx 0;
}

.location-info-panel .info-item:last-child {
  margin-bottom: 0;
}

.location-info-panel .address-item {
  align-items: flex-start;
}

.location-info-panel .info-label {
  font-size: 28rpx;
  color: #666;
  min-width: 160rpx;
  flex-shrink: 0;
  font-weight: 500;
}

.location-info-panel .info-value {
  font-size: 28rpx;
  color: #333;
  flex: 1;
  text-align: right;
  font-weight: bold;
  transition: color 0.3s ease;
}

.location-info-panel .address-text {
  word-break: break-all;
  line-height: 1.6;
  text-align: right;
  font-weight: normal;
}

.location-info-panel .info-value.in-range {
  color: #52c41a;
  animation: pulseGreen 2s infinite;
}

@keyframes pulseGreen {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.7;
  }
}

.location-info-panel .info-value.out-range {
  color: #ff4d4f;
  animation: pulseRed 1s infinite;
}

@keyframes pulseRed {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.7;
  }
}

.validation-status {
  margin-top: 20rpx;
  padding: 24rpx;
  border-radius: 16rpx;
  text-align: center;
  background: white;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.05);
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
  gap: 24rpx;
  border-top: 1rpx solid #f0f0f0;
  background: white;
}

.btn {
  flex: 1;
  height: 88rpx;
  border: none;
  border-radius: 44rpx;
  font-size: 30rpx;
  font-weight: bold;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.1);
}

.btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: left 0.5s ease;
}

.btn:active::before {
  left: 100%;
}

.refresh-btn {
  background: linear-gradient(135deg, #f5f5f5 0%, #e0e0e0 100%);
  color: #666;
}

.confirm-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.confirm-btn.disabled {
  background: linear-gradient(135deg, #d9d9d9 0%, #bfbfbf 100%);
  color: #999;
  box-shadow: none;
}

.confirm-btn.disabled:active {
  transform: none;
  box-shadow: none;
}

.btn:active {
  transform: scale(0.96);
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.15);
}

.btn-text {
  font-size: 30rpx;
}

.dialog-loading {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 255, 255, 0.95);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
  border-radius: 32rpx;
}

.loading-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 24rpx;
}

.loading-spinner {
  width: 60rpx;
  height: 60rpx;
  border: 4rpx solid #f3f3f3;
  border-top: 4rpx solid #667eea;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>
