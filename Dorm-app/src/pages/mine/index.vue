<template>
  <view class="mine-container" :style="{height: `${windowHeight}px`}">
    <!--顶部个人信息栏-->
    <view class="header-section">
      <view class="flex padding justify-between">
        <view class="flex align-center">
          <view v-if="!avatar" class="cu-avatar xl round bg-white">
            <view class="iconfont icon-people text-gray icon"></view>
          </view>
          <image v-if="avatar" @click="handleToAvatar" :src="avatar" class="cu-avatar xl round" mode="widthFix">
          </image>
          <view v-if="!name" @click="handleToLogin" class="login-tip">
            点击登录
          </view>
          <view v-if="name" @click="handleToInfo" class="user-info">
            <view class="u_title">
              姓名：{{ name }}
            </view>
          </view>
        </view>
        <view @click="handleToInfo" class="flex align-center">
          <text>个人信息</text>
          <view class="iconfont icon-right"></view>
        </view>
      </view>
    </view>

    <view class="content-section">
      <view class="mine-actions grid col-4 text-center">
        <view class="action-item" @click="handleJiaoLiuQun">
          <view class="iconfont icon-friendfill text-pink icon"></view>
          <text class="text">交流群</text>
        </view>
        <view class="action-item" @click="handleBuilding">
          <view class="iconfont icon-service text-blue icon"></view>
          <text class="text">在线客服</text>
        </view>
        <view class="action-item" @click="handleBuilding">
          <view class="iconfont icon-community text-mauve icon"></view>
          <text class="text">反馈社区</text>
        </view>
        <view class="action-item" @click="handleBuilding">
          <view class="iconfont icon-dianzan text-green icon"></view>
          <text class="text">点赞我们</text>
        </view>
      </view>

      <view class="menu-list">
        <view class="list-cell list-cell-arrow" @click="handleToEditInfo">
          <view class="menu-item-box">
            <view class="iconfont icon-user menu-icon"></view>
            <view>编辑资料</view>
          </view>
        </view>
        <view class="list-cell list-cell-arrow" @click="handleHelp">
          <view class="menu-item-box">
            <view class="iconfont icon-help menu-icon"></view>
            <view>常见问题</view>
          </view>
        </view>
        <view class="list-cell list-cell-arrow" @click="handleAbout">
          <view class="menu-item-box">
            <view class="iconfont icon-aixin menu-icon"></view>
            <view>关于我们</view>
          </view>
        </view>
        <view class="list-cell list-cell-arrow" @click="handleToSetting">
          <view class="menu-item-box">
            <view class="iconfont icon-setting menu-icon"></view>
            <view>应用设置</view>
          </view>
        </view>
      </view>

    </view>
  </view>
</template>

<script setup>
  import { computed, getCurrentInstance, onMounted } from 'vue'
  import useUserStore from '@/store/modules/user'
  import useStudentStore from '@/store/modules/student'
import useRepairerStore from '@/store/modules/repairer'

  // 获取student store实例
  const studentStore = useStudentStore()


// 检查用户是否已登录且获取相应角色信息
onMounted(async () => {
  const userStore = useUserStore()

  // 检查用户是否已登录
  if (userStore.token) {
    try {
      // 检查维修人员权限并获取维修人员信息（优先处理）
      if (userStore.roles && userStore.roles.includes('repairer')) {
        try {
          const repairerData = await repairerStore.fetchRepairerByUserId(userStore.id)
          if (repairerData) {
            console.log('维修人员信息加载成功:', repairerData.name)
          } else {
            console.log('维修人员信息不存在，用户可能需要完善信息')
          }
        } catch (error) {
          console.log('维修人员信息获取失败，可能是首次登录:', error)
          // 如果获取失败，说明可能是首次登录，不做处理，在个人信息页面会引导用户完善信息
        }
      }

      // 检查学生权限并获取学生信息
      if (userStore.roles && userStore.roles.includes('student')) {
        await studentStore.fetchStudentDetail()
      }
    } catch (error) {
      console.error('获取用户角色信息失败:', error)
      // 可以添加错误处理逻辑
    }
  }
})

  // 获取当前实例以访问全局属性
  const { proxy } = getCurrentInstance()

  // 获取store实例
  const userStore = useUserStore()
  const repairerStore = useRepairerStore()

  // 计算属性 - 优先级：维修人员姓名 > 学生姓名 > 用户昵称
  const name = computed(() => {
    // 优先使用维修人员信息中的姓名
    if (repairerStore.currentRepairer && repairerStore.currentRepairer.name) {
      return repairerStore.currentRepairer.name
    }
    // 其次使用学生信息中的姓名
    if (studentStore.currentStudent && studentStore.currentStudent.name) {
      return studentStore.currentStudent.name
    }
    // 最后使用用户store中的姓名
    return userStore.name
  })
  const avatar = computed(() => userStore.avatar)
  const windowHeight = computed(() => uni.getSystemInfoSync().windowHeight - 50)

  // 方法定义
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
</script>

<style lang="scss" scoped>
  page {
    background-color: #f5f6f7;
  }

  .mine-container {
    width: 100%;
    height: 100%;


    .header-section {
      padding: 15px 15px 45px 15px;
      background-color: #3c96f3;
      color: white;

      .login-tip {
        font-size: 18px;
        margin-left: 10px;
      }

      .cu-avatar {
        border: 2px solid #eaeaea;

        .icon {
          font-size: 40px;
        }
      }

      .user-info {
        margin-left: 15px;

        .u_title {
          font-size: 18px;
          line-height: 30px;
        }
      }
    }

    .content-section {
      position: relative;
      top: -50px;

      .mine-actions {
        margin: 15px 15px;
        padding: 20px 0px;
        border-radius: 8px;
        background-color: white;

        .action-item {
          .icon {
            font-size: 28px;
          }

          .text {
            display: block;
            font-size: 13px;
            margin: 8px 0px;
          }
        }
      }
    }
  }
</style>
