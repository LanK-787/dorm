<template>
  <view class="normal-login-container">
    <!-- 背景图片 -->
    <image class="background-image" src="/static/images/background.png" mode="aspectFill"></image>
    
    <!-- 遮罩层 -->
    <view class="overlay"></view>
    
    <!-- 内容区域 -->
    <view class="content-wrapper">
      <view class="logo-content align-center justify-center flex">
        <image class="logo-img" :src="globalConfig.appInfo.logo" mode="widthFix"></image>
        <text class="title">智慧宿舍</text>
      </view>
      
      <view class="login-form-content">
        <view class="form-card">
          <view class="input-item flex align-center">
            <view class="iconfont icon-user icon"></view>
            <input v-model="loginForm.username" class="input" type="text" placeholder="请输入账号" maxlength="30" />
          </view>
          
          <view class="input-item flex align-center">
            <view class="iconfont icon-password icon"></view>
            <input v-model="loginForm.password" type="password" class="input" placeholder="请输入密码" maxlength="20" />
          </view>
          
          <view class="input-item flex align-center captcha-item" v-if="captchaEnabled">
            <view class="iconfont icon-code icon"></view>
            <input v-model="loginForm.code" type="number" class="input" placeholder="请输入验证码" maxlength="4" />
            <view class="login-code"> 
              <image :src="codeUrl" @click="getCode" class="login-code-img"></image>
            </view>
          </view>
          
          <view class="action-btn">
            <button @click="handleLogin" class="login-btn cu-btn block lg round">登录</button>
          </view>
          
          <view class="reg text-center" v-if="register">
            <text class="text-grey1">没有账号？</text>
            <text @click="handleUserRegister" class="text-blue">立即注册</text>
          </view>
        </view>
        
        <view class="xieyi text-center">
          <text class="text-white-light">登录即代表同意</text>
          <text @click="handleUserAgrement" class="text-white">《用户协议》</text>
          <text class="text-white-light"> 和 </text>
          <text @click="handlePrivacy" class="text-white">《隐私协议》</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
  import { ref, reactive, getCurrentInstance, onMounted } from 'vue'
  import { getCodeImg } from '@/api/login'
  import useUserStore from '@/store/modules/user'
  import useRepairerStore from '@/store/modules/repairer'
  import useStudentStore from '@/store/modules/student'
  import { isStudent, isStudentInfoFilled } from '@/api/dorm/student'


  // 获取当前实例以访问全局属性
  const { proxy } = getCurrentInstance()

  // 响应式数据
  const codeUrl = ref("")
  const captchaEnabled = ref(true)
  // 用户注册开关
  const register = ref(false)
  // 学生账号状态
  const isStudentAccount = ref(false)
  // 安全获取全局配置，避免 globalData 未初始化时报错
  const getGlobalConfig = () => {
    const app = getApp()
    if (app && app.globalData && app.globalData.config) {
      return app.globalData.config
    }
    // 如果 globalData 未初始化，返回默认配置
    return {
      appInfo: {
        logo: "/static/logo.png",
        agreements: [
          { title: "隐私政策", url: "https://ruoyi.vip/protocol.html" },
          { title: "用户服务协议", url: "https://ruoyi.vip/protocol.html" }
        ]
      }
    }
  }
  const globalConfig = ref(getGlobalConfig())
  const loginForm = reactive({
    username: "2310305320",
    password: "123456",
    code: "",
    uuid: ""
  })

  // Pinia store
  const userStore = useUserStore()
  const repairerStore = useRepairerStore()
  const studentStore = useStudentStore()

  // 生命周期钩子
  onMounted(() => {
    getCode()
  })

  // 用户注册
  const handleUserRegister = () => {
    proxy.$tab.redirectTo(`/pages/register`)
  }

  // 隐私协议
  const handlePrivacy = () => {
    let site = globalConfig.value.appInfo.agreements[0]
    proxy.$tab.navigateTo(`/pages/common/webview/index?title=${site.title}&url=${site.url}`)
  }

  // 用户协议
  const handleUserAgrement = () => {
    let site = globalConfig.value.appInfo.agreements[1]
    proxy.$tab.navigateTo(`/pages/common/webview/index?title=${site.title}&url=${site.url}`)
  }

  // 获取图形验证码
  const getCode = () => {
    getCodeImg().then(res => {
      captchaEnabled.value = res.captchaEnabled === undefined ? true : res.captchaEnabled
      if (captchaEnabled.value) {
        codeUrl.value = 'data:image/gif;base64,' + res.img
        loginForm.uuid = res.uuid
      }
    })
  }

  // 检测是否为学生账号
  const checkIsStudent = async (username) => {
    try {
      const response = await isStudent(username)
      // 处理API响应格式：{ "msg": "操作成功", "code": 200, "data": true/false }
      if (response.code === 200) {
        isStudentAccount.value = response.data
        return response.data
      } else {
        console.error('检测学生账号失败:', response.msg)
        isStudentAccount.value = false
        return false
      }
    } catch (error) {
      console.error('检测学生账号出错:', error)
      isStudentAccount.value = false
      return false
    }
  }



  // 检查维修人员权限和信息
  const checkRepairerInfo = async () => {
    try {
      // 检查用户是否具有维修人员权限
      if (userStore.roles && userStore.roles.includes('repairer')) {
        console.log('检测到维修人员权限，开始获取维修人员信息')

        // 尝试获取维修人员信息
        const repairerData = await repairerStore.fetchRepairerByUserId(userStore.id)

        if (!repairerData) {
          // 没有维修人员信息，引导用户完善
          proxy.$modal.msgError('检测到您具有维修人员权限，但尚未完善相关信息，请先完善维修人员信息')

          setTimeout(() => {
            proxy.$tab.reLaunch('/pages/mine/repairer/setup')
          }, 2000)
          return false // 返回false表示需要完善信息
        } else {
          console.log('维修人员信息获取成功:', repairerData.name)
          return true // 返回true表示信息完整
        }
      }
      return true // 非维修人员用户，返回true继续正常流程
    } catch (error) {
      console.error('检查维修人员信息失败:', error)
      return true // 出错时继续正常流程，避免阻塞登录
    }
  }

  // 显示个性化欢迎弹窗
  const showWelcomeModal = (userName, userType) => {
    let welcomeMessage = ''
    
    if (userType === 'student') {
      welcomeMessage = `欢迎回来，${userName}同学！\n祝你学习进步，生活愉快～`
    } else if (userType === 'repairer') {
      welcomeMessage = `欢迎回来，${userName}维修师傅！\n感谢您的辛勤付出～`
    } else {
      welcomeMessage = `欢迎回来，${userName}！\n祝你工作顺利～`
    }
    
    // 先跳转到首页
    proxy.$tab.reLaunch('/pages/index')
    
    // 跳转后立即显示欢迎提示
    uni.showToast({
      title: welcomeMessage,
      icon: 'none',
      duration: 2500,
      mask: false
    })
  }

  // 登录成功后，处理函数
  const loginSuccess = async () => {
    try {
      // 清空之前的用户相关数据，避免数据混乱
      studentStore.clearCurrentStudent()
      repairerStore.clearCurrentRepairer()
      
      // 设置用户信息
      userStore.GetInfo().then(async () => {
        try {
          // 在获取用户信息成功后进行学生账号检测
          const studentStatus = await checkIsStudent(loginForm.username)

          // 检查维修人员权限和信息
          const repairerInfoComplete = await checkRepairerInfo()
          if (!repairerInfoComplete) {
            return // 如果维修人员信息不完整，已经跳转到完善页面，直接返回
          }

          // 根据检测结果显示不同的成功提示消息
          if (studentStatus) {
            // 是学生账号，检查学生信息是否完整
            const studentInfo = await isStudentInfoFilled(loginForm.username)
            if(studentInfo.data){
              // 学生信息已完善，获取学生详细信息
              try {
                const studentDetail = await studentStore.fetchStudentDetail()
                const studentName = studentDetail?.name || loginForm.username
                
                // 显示学生欢迎弹窗
                showWelcomeModal(studentName, 'student')
              } catch (error) {
                console.error('获取学生详细信息失败:', error)
                // 降级处理：使用用户名显示欢迎信息
                showWelcomeModal(loginForm.username, 'student')
              }
            } else {
              // 学生信息未完善，引导用户完善信息
              // proxy.$modal.msgError('学生信息未完善，请先完善个人信息')
              proxy.$modal.alert('学生信息未完善，请先完善个人信息', '温馨提示')

              // 跳转到学生信息完善页面
              setTimeout(() => {
                proxy.$tab.reLaunch('/pages/student/complete-info')
              }, 1500)
              return // 提前返回，不执行后续的首页跳转逻辑
            }
          } else {
            // 非学生账号，检查是否为维修人员
            if (userStore.roles && userStore.roles.includes('repairer')) {
              // 获取维修人员详细信息
              try {
                const repairerData = await repairerStore.fetchRepairerByUserId(userStore.id)
                const repairerName = repairerData?.name || userStore.nickName || loginForm.username
                
                // 显示维修人员欢迎弹窗
                showWelcomeModal(repairerName, 'repairer')
              } catch (error) {
                console.error('获取维修人员详细信息失败:', error)
                // 降级处理：使用昵称或用户名显示欢迎信息
                showWelcomeModal(userStore.nickName || loginForm.username, 'repairer')
              }
            } else {
              // 管理员账号
              const adminName = userStore.nickName || loginForm.username
              showWelcomeModal(adminName, 'admin')
            }
          }
        } catch (detectionError) {
          console.error('账号检测失败:', detectionError)
          // 如果检测失败，默认按普通用户处理
          proxy.$modal.msgSuccess('登录成功')
          proxy.$tab.reLaunch('/pages/index')
        }
      }).catch(error => {
        console.error('获取用户信息失败:', error)
        proxy.$modal.msgError('获取用户信息失败')
      })

    } catch (error) {
      console.error('登录后处理失败:', error)
      // 确保即使检测失败也不影响正常登录流程
      proxy.$modal.msgSuccess('登录成功')

      userStore.GetInfo().then(() => {
        proxy.$tab.reLaunch('/pages/index')
      }).catch(error => {
        console.error('获取用户信息失败:', error)
        proxy.$modal.msgError('获取用户信息失败')
      })
    }
  }

  // 登录方法
  const handleLogin = async () => {
    if (loginForm.username === "") {
      proxy.$modal.msgError("请输入账号")
    } else if (loginForm.password === "") {
      proxy.$modal.msgError("请输入密码")
    } else if (loginForm.code === "" && captchaEnabled.value) {
      proxy.$modal.msgError("请输入验证码")
    } else {
      proxy.$modal.loading("登录中，请耐心等待...")
      await pwdLogin()
    }
  }

  // 密码登录
  const pwdLogin = async () => {
    try {
      await userStore.Login(loginForm)
      proxy.$modal.closeLoading()
      await loginSuccess()
    } catch (error) {
      console.error('登录失败:', error)
      proxy.$modal.closeLoading()
      if (captchaEnabled.value) {
        getCode()
      }
    }
  }


</script>

<style lang="scss" scoped>
  page {
    background-color: #1a1a2e;
  }

  .normal-login-container {
    position: relative;
    width: 100%;
    min-height: 100vh;
    overflow: hidden;

    // 背景图片
    .background-image {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      z-index: 0;
    }

    // 遮罩层 - 添加渐变遮罩增强可读性
    .overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: linear-gradient(
        180deg,
        rgba(26, 26, 46, 0.3) 0%,
        rgba(26, 26, 46, 0.5) 50%,
        rgba(26, 26, 46, 0.7) 100%
      );
      z-index: 1;
    }

    // 内容区域
    .content-wrapper {
      position: relative;
      z-index: 2;
      width: 100%;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    .logo-content {
      width: 100%;
      font-size: 24px;
      font-weight: bold;
      text-align: center;
      padding-top: 20%;
      padding-bottom: 40rpx;
      animation: fadeInDown 0.8s ease-out;

      .logo-img {
        width: 120rpx;
        height: 120rpx;
        border-radius: 20rpx;
        box-shadow: 0 8rpx 32rpx rgba(255, 255, 255, 0.2);
        background: rgba(255, 255, 255, 0.1);
        backdrop-filter: blur(10rpx);
        padding: 10rpx;
      }

      .title {
        margin-left: 20rpx;
        color: #ffffff;
        text-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.3);
        letter-spacing: 2rpx;
      }
    }

    .login-form-content {
      text-align: center;
      margin: 0 auto;
      width: 85%;
      animation: fadeInUp 0.8s ease-out;

      .form-card {
        background: rgba(255, 255, 255, 0.15);
        backdrop-filter: blur(20rpx);
        border-radius: 40rpx;
        padding: 60rpx 40rpx 50rpx;
        box-shadow: 0 16rpx 64rpx rgba(0, 0, 0, 0.3);
        border: 1rpx solid rgba(255, 255, 255, 0.18);
      }

      .input-item {
        margin: 30rpx auto;
        background: rgba(255, 255, 255, 0.9);
        height: 90rpx;
        border-radius: 45rpx;
        transition: all 0.3s ease;
        box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.1);

        &:hover {
          box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.15);
          transform: translateY(-2rpx);
        }

        .icon {
          font-size: 40rpx;
          margin-left: 30rpx;
          color: #666;
          flex-shrink: 0;
        }

        .input {
          width: 100%;
          font-size: 28rpx;
          line-height: 40rpx;
          text-align: left;
          padding-left: 20rpx;
          padding-right: 20rpx;
          color: #333;
        }
      }

      .captcha-item {
        width: 100%;
        padding-right: 20rpx;

        .input {
          flex: 1;
          padding-right: 10rpx;
        }
      }

      .login-code {
        height: 76rpx;
        margin-left: 20rpx;
        flex-shrink: 0;

        .login-code-img {
          height: 70rpx;
          width: 200rpx;
          border-radius: 12rpx;
          border: 1rpx solid rgba(0, 0, 0, 0.1);
          cursor: pointer;
          transition: all 0.3s ease;

          &:active {
            opacity: 0.8;
            transform: scale(0.95);
          }
        }
      }

      .login-btn {
        margin-top: 50rpx;
        height: 90rpx;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: #ffffff;
        font-size: 32rpx;
        font-weight: bold;
        border: none;
        box-shadow: 0 8rpx 24rpx rgba(102, 126, 234, 0.4);
        transition: all 0.3s ease;

        &:active {
          transform: translateY(2rpx);
          box-shadow: 0 4rpx 12rpx rgba(102, 126, 234, 0.3);
        }
      }

      .reg {
        margin-top: 30rpx;
        font-size: 26rpx;

        .text-grey1 {
          color: #888;
        }

        .text-blue {
          color: #667eea;
          font-weight: bold;
          margin-left: 10rpx;
        }
      }

      .xieyi {
        margin-top: 50rpx;
        font-size: 24rpx;
        padding: 0 20rpx;

        .text-white-light {
          color: rgba(255, 255, 255, 0.7);
        }

        .text-white {
          color: #ffffff;
          font-weight: bold;
          text-decoration: underline;
          margin: 0 4rpx;
        }
      }
    }
  }

  // 动画效果
  @keyframes fadeInDown {
    from {
      opacity: 0;
      transform: translateY(-40rpx);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  @keyframes fadeInUp {
    from {
      opacity: 0;
      transform: translateY(40rpx);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
</style>

