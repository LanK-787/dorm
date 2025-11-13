<template>
  <view class="page-container">
    <!-- 状态栏占位 -->
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>

    <!-- 自定义导航栏 -->
    <view class="custom-navbar">
      <view class="navbar-content">
        <view class="navbar-title">
          <text>个人中心</text>
        </view>
      </view>
    </view>

    <!-- 主要内容 -->
    <scroll-view 
      class="main-content" 
      scroll-y="true" 
      :refresher-enabled="true"
      :refresher-triggered="isRefreshing"
      @refresherrefresh="onRefresh"
    >
      <!-- 个人信息卡片 -->
      <view class="profile-card">
        <view class="profile-header">
          <view class="avatar-wrapper" @click="handleToAvatar">
            <view class="avatar-section">
              <image v-if="avatar" :src="avatar" class="avatar-image" mode="aspectFill"></image>
              <view v-else class="avatar-placeholder">
                <text class="iconfont icon-people"></text>
              </view>
            </view>
            <view class="avatar-edit-badge">
              <text class="iconfont icon-camera"></text>
            </view>
          </view>
          <view class="profile-info" @click="name ? handleToInfo : handleToLogin">
            <text class="profile-name">{{ name || '点击登录' }}</text>
            <text v-if="name" class="profile-role">{{ getUserRole() }}</text>
            <text v-if="name" class="profile-id">ID: {{ userStore.id }}</text>
          </view>
          <view class="profile-edit" @click="handleToInfo">
            <text class="iconfont icon-right"></text>
          </view>
        </view>
      </view>

      <!-- 统计卡片 - 学生 -->
      <view v-if="userStore.roles?.includes('student')" class="stats-card">
        <view class="stats-item">
          <text class="stats-value">{{ leaveCount || 0 }}</text>
          <text class="stats-label">离校申请</text>
        </view>
        <view class="stats-item">
          <text class="stats-value">{{ repairCount || 0 }}</text>
          <text class="stats-label">报修记录</text>
        </view>
      </view>

      <!-- 统计卡片 - 维修工 -->
      <view v-else-if="userStore.roles?.includes('repairer')" class="stats-card">
        <view class="stats-item">
          <text class="stats-value">{{ repairCount || 0 }}</text>
          <text class="stats-label">待处理工单</text>
        </view>
      </view>

      <!-- 统计卡片 - 默认 -->
      <view v-else class="stats-card">
        <view class="stats-item">
          <text class="stats-value">{{ noticeCount || 0 }}</text>
          <text class="stats-label">未读通知</text>
        </view>
        <view class="stats-item">
          <text class="stats-value">0</text>
          <text class="stats-label">我的消息</text>
        </view>
        <view class="stats-item">
          <text class="stats-value">0</text>
          <text class="stats-label">我的收藏</text>
        </view>
      </view>

      <!-- 快捷功能区 -->
      <view class="quick-actions">
        <view class="action-item" hover-class="action-item-hover" @click="handleJiaoLiuQun">
          <view class="action-icon-wrapper icon-friendfill-bg">
            <text class="iconfont icon-friendfill"></text>
          </view>
          <text>宿舍公共号</text>
        </view>
        <view class="action-item" hover-class="action-item-hover" @click="handleBuilding">
          <view class="action-icon-wrapper icon-service-bg">
            <text class="iconfont icon-service"></text>
          </view>
          <text>在线客服</text>
        </view>
        <view class="action-item" hover-class="action-item-hover" @click="handleBuilding">
          <view class="action-icon-wrapper icon-community-bg">
            <text class="iconfont icon-community"></text>
          </view>
          <text>反馈社区</text>
        </view>
        <view class="action-item" hover-class="action-item-hover" @click="handleBuilding">
          <view class="action-icon-wrapper icon-dianzan-bg">
            <text class="iconfont icon-dianzan"></text>
          </view>
          <text>点赞我们</text>
        </view>
      </view>

      <!-- 菜单列表 -->
      <view class="menu-list">
        <view class="menu-item" hover-class="menu-item-hover" @click="handleToEditInfo">
          <view class="menu-item-left">
            <view class="menu-icon-wrapper icon-user-bg">
              <text class="iconfont icon-user"></text>
            </view>
            <text>编辑资料</text>
          </view>
          <text class="iconfont icon-right"></text>
        </view>
        <view class="menu-item" hover-class="menu-item-hover" @click="handleHelp">
          <view class="menu-item-left">
            <view class="menu-icon-wrapper icon-help-bg">
              <text class="iconfont icon-help"></text>
            </view>
            <text>常见问题</text>
          </view>
          <text class="iconfont icon-right"></text>
        </view>
        <view class="menu-item" hover-class="menu-item-hover" @click="handleAbout">
          <view class="menu-item-left">
            <view class="menu-icon-wrapper icon-aixin-bg">
              <text class="iconfont icon-aixin"></text>
            </view>
            <text>关于我们</text>
          </view>
          <text class="iconfont icon-right"></text>
        </view>
        <view class="menu-item" hover-class="menu-item-hover" @click="handleToSetting">
          <view class="menu-item-left">
            <view class="menu-icon-wrapper icon-setting-bg">
              <text class="iconfont icon-setting"></text>
            </view>
            <text>应用设置</text>
          </view>
          <text class="iconfont icon-right"></text>
        </view>
      </view>

      <!-- 版本信息 -->
      <view class="version-info">
        <text>当前版本 v1.0.0</text>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, computed, getCurrentInstance, onMounted } from 'vue'
import useUserStore from '@/store/modules/user'
import useStudentStore from '@/store/modules/student'
import useRepairerStore from '@/store/modules/repairer'
import { getLeaveApplicationList } from '@/api/leave/registration'
import { listRequest } from '@/api/dorm/request'
import { getPendingAssignments, getProcessingAssignments } from '@/api/repairer/workorder'
import { listNotices } from '@/api/dorm/notices'

// 获取当前实例以访问全局属性
const { proxy } = getCurrentInstance()

// 获取store实例
const userStore = useUserStore()
const studentStore = useStudentStore()
const repairerStore = useRepairerStore()

// 统计数据
const leaveCount = ref(0)
const repairCount = ref(0)
const noticeCount = ref(0)
const isRefreshing = ref(false)

// 计算属性 - 优先级：维修人员姓名 > 学生姓名 > 用户昵称
const name = computed(() => {
  if (repairerStore.currentRepairer?.name) {
    return repairerStore.currentRepairer.name
  }
  if (studentStore.currentStudent?.name) {
    return studentStore.currentStudent.name
  }
  return userStore.name
})

const avatar = computed(() => userStore.avatar)
const statusBarHeight = ref(uni.getSystemInfoSync().statusBarHeight || 0)

// 获取用户角色显示文本
const getUserRole = () => {
  if (userStore.roles?.includes('repairer')) {
    return '维修人员'
  }
  if (userStore.roles?.includes('student')) {
    return '学生'
  }
  return '普通用户'
}

// 初始化数据
const initData = async () => {
  if (!userStore.token) return

  try {
    // 加载用户角色信息
    if (userStore.roles?.includes('repairer')) {
      const repairerData = await repairerStore.fetchRepairerByUserId(userStore.id)
      if (repairerData) {
        // 获取维修人员的待处理工单数（待接单 + 处理中）
        await loadRepairerStats()
      }
    } else if (userStore.roles?.includes('student')) {
      await studentStore.fetchStudentDetail()
      // 获取学生的离校申请数和报修记录数
      await loadStudentStats()
    } else {
      // 其他角色（如管理员）获取未读通知数
      await loadNoticeStats()
    }
  } catch (error) {
    console.error('获取用户数据失败:', error)
    // 静默失败，不影响页面显示
  }
}

// 加载维修人员统计数据
const loadRepairerStats = async () => {
  try {
    // 获取待处理工单数（待接单）
    const pendingResponse = await getPendingAssignments({ pageNum: 1, pageSize: 1 })
    const pendingCount = pendingResponse.total || 0
    console.log('维修工-待接单工单数:', pendingCount)

    // 获取处理中工单数
    const processingResponse = await getProcessingAssignments({ pageNum: 1, pageSize: 1 })
    const processingCount = processingResponse.total || 0
    console.log('维修工-处理中工单数:', processingCount)

    // 总的待处理工单数 = 待接单 + 处理中
    repairCount.value = pendingCount + processingCount
    console.log('维修工-总工单数:', repairCount.value)
  } catch (error) {
    console.error('获取维修工单统计失败:', error)
    repairCount.value = 0
  }
}

// 加载学生统计数据
const loadStudentStats = async () => {
  try {
    // 从studentStore获取学生信息
    const currentStudent = studentStore.currentStudent
    const queryParams = { pageNum: 1, pageSize: 1 }

    // 如果有学号，添加到查询参数中
    if (currentStudent && currentStudent.studentNo) {
      queryParams.studentNo = currentStudent.studentNo
      console.log('使用学号查询统计数据:', currentStudent.studentNo)
    }

    // 获取离校申请数（进行中的申请：待审批 + 已批准未返校）
    const leaveResponse = await getLeaveApplicationList(queryParams)
    leaveCount.value = leaveResponse.total || 0
    console.log('学生-离校申请数:', leaveCount.value)

    // 获取报修记录数
    const repairResponse = await listRequest({ pageNum: 1, pageSize: 1 })
    repairCount.value = repairResponse.total || 0
    console.log('学生-报修记录数:', repairCount.value)
  } catch (error) {
    console.error('获取学生统计数据失败:', error)
    leaveCount.value = 0
    repairCount.value = 0
  }
}

// 加载通知统计数据
const loadNoticeStats = async () => {
  try {
    // 获取未读通知数（状态为已发布的通知）
    const noticeResponse = await listNotices({
      pageNum: 1,
      pageSize: 1,
      status: '0' // 已发布状态
    })
    noticeCount.value = noticeResponse.total || 0
    console.log('未读通知数:', noticeCount.value)
  } catch (error) {
    console.error('获取通知统计失败:', error)
    noticeCount.value = 0
  }
}

// 下拉刷新
const onRefresh = async () => {
  if (isRefreshing.value) return
  
  isRefreshing.value = true
  try {
    await initData()
    proxy.$modal.msgSuccess('刷新成功')
  } catch (error) {
    console.error('刷新数据失败:', error)
    proxy.$modal.msgError('刷新失败，请稍后重试')
  } finally {
    isRefreshing.value = false
  }
}

// 页面跳转方法
const handleToInfo = () => {
  proxy.$tab.navigateTo('/pages/mine/info/index')
}

const handleToEditInfo = () => {
  proxy.$tab.navigateTo('/pages/mine/info/edit')
}

const handleToSetting = () => {
  proxy.$tab.navigateTo('/pages/mine/setting/index')
}

const handleToLogin = () => {
  proxy.$tab.reLaunch('/pages/login')
}

const handleToAvatar = () => {
  proxy.$tab.navigateTo('/pages/mine/avatar/index')
}

const handleHelp = () => {
  proxy.$tab.navigateTo('/pages/mine/help/index')
}

const handleAbout = () => {
  proxy.$tab.navigateTo('/pages/mine/about/index')
}

const handleJiaoLiuQun = () => {
  proxy.$modal.showToast('QQ群：①133713780(满)、②146013835(满)、③189091635')
}

const handleBuilding = () => {
  proxy.$modal.showToast('模块建设中~')
}

// 生命周期钩子
onMounted(() => {
  initData()
})
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background-color: #f8f9fa;
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

.profile-card {
  background: white;
  border-radius: 20rpx;
  padding: 40rpx 30rpx;
  margin: 30rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);

  .profile-header {
    display: flex;
    align-items: center;
  }

  .avatar-wrapper {
    position: relative;
    margin-right: 30rpx;

    .avatar-section {
      width: 120rpx;
      height: 120rpx;
      border-radius: 60rpx;
      overflow: hidden;
      background: #f0f2f5;
      border: 4rpx solid rgba(255, 255, 255, 0.8);
      box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.1);
      transition: transform 0.3s ease;

      &:active {
        transform: scale(0.95);
      }

      .avatar-image {
        width: 100%;
        height: 100%;
      }

      .avatar-placeholder {
        width: 100%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        
        .iconfont {
          font-size: 60rpx;
          color: #999;
        }
      }
    }

    .avatar-edit-badge {
      position: absolute;
      right: -6rpx;
      bottom: -6rpx;
      width: 40rpx;
      height: 40rpx;
      background: #667eea;
      border-radius: 20rpx;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.2);

      .iconfont {
        color: white;
        font-size: 24rpx;
      }
    }
  }

  .profile-info {
    flex: 1;

    .profile-name {
      font-size: 36rpx;
      font-weight: bold;
      color: #333;
      display: block;
      margin-bottom: 10rpx;
    }

    .profile-role {
      font-size: 24rpx;
      color: #667eea;
      background: rgba(102, 126, 234, 0.1);
      padding: 4rpx 16rpx;
      border-radius: 20rpx;
      display: inline-block;
      margin-bottom: 8rpx;
    }

    .profile-id {
      font-size: 24rpx;
      color: #999;
      display: block;
    }
  }

  .profile-edit {
    padding: 20rpx;
    
    .iconfont {
      color: #999;
      font-size: 32rpx;
    }
  }
}

.stats-card {
  display: flex;
  justify-content: space-around;
  background: white;
  border-radius: 20rpx;
  padding: 40rpx 30rpx;
  margin: 0 30rpx 30rpx 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
  min-height: 140rpx;

  .stats-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 12rpx;
    flex: 1;
    min-width: 150rpx;

    .stats-value {
      font-size: 48rpx;
      font-weight: bold;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      -webkit-background-clip: text;
      background-clip: text;
      color: transparent;
      line-height: 1;
    }

    .stats-label {
      font-size: 26rpx;
      color: #666;
      white-space: nowrap;
    }
  }
}

.quick-actions {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20rpx;
  background: white;
  border-radius: 20rpx;
  padding: 30rpx;
  margin: 0 30rpx 30rpx 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);

  .action-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12rpx;

    .action-icon-wrapper {
      width: 80rpx;
      height: 80rpx;
      border-radius: 30rpx;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.3s ease;

      &.icon-friendfill-bg { background: rgba(255, 107, 107, 0.1); }
      &.icon-service-bg { background: rgba(77, 171, 247, 0.1); }
      &.icon-community-bg { background: rgba(132, 94, 247, 0.1); }
      &.icon-dianzan-bg { background: rgba(81, 207, 102, 0.1); }

      .iconfont {
        font-size: 44rpx;
        
        &.icon-friendfill { color: #ff6b6b; }
        &.icon-service { color: #4dabf7; }
        &.icon-community { color: #845ef7; }
        &.icon-dianzan { color: #51cf66; }
      }
    }

    text {
      font-size: 24rpx;
      color: #666;
    }
  }
}

.action-item-hover {
  .action-icon-wrapper {
    transform: scale(0.9);
    box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.1);
  }
}

.menu-list {
  background: white;
  border-radius: 20rpx;
  padding: 0 30rpx;
  margin: 0 30rpx 30rpx 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);

  .menu-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 30rpx 0;
    border-bottom: 2rpx solid #f5f6f7;
    transition: background-color 0.3s ease;

    &:last-child {
      border-bottom: none;
    }

    .menu-item-left {
      display: flex;
      align-items: center;
      gap: 20rpx;

      .menu-icon-wrapper {
        width: 64rpx;
        height: 64rpx;
        border-radius: 20rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: transform 0.3s ease;

        &.icon-user-bg { background: rgba(77, 171, 247, 0.1); }
        &.icon-help-bg { background: rgba(132, 94, 247, 0.1); }
        &.icon-aixin-bg { background: rgba(255, 107, 107, 0.1); }
        &.icon-setting-bg { background: rgba(81, 207, 102, 0.1); }

        .iconfont {
          font-size: 36rpx;
          
          &.icon-user { color: #4dabf7; }
          &.icon-help { color: #845ef7; }
          &.icon-aixin { color: #ff6b6b; }
          &.icon-setting { color: #51cf66; }
        }
      }

      text {
        font-size: 28rpx;
        color: #333;
      }
    }

    .iconfont.icon-right {
      color: #999;
      font-size: 32rpx;
      transition: transform 0.3s ease;
    }
  }
}

.menu-item-hover {
  background-color: rgba(0, 0, 0, 0.02);

  .menu-icon-wrapper {
    transform: scale(0.9);
  }

  .iconfont.icon-right {
    transform: translateX(4rpx);
  }
}

.version-info {
  text-align: center;
  padding: 30rpx 0;
  
  text {
    font-size: 24rpx;
    color: #999;
  }
}
</style>

