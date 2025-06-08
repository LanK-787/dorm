<template>
  <view class="normal-login-container">
    <view class="logo-content align-center justify-center flex">
      <image style="width: 100rpx;height: 100rpx;" :src="globalConfig.appInfo.logo" mode="widthFix">
      </image>
      <text class="title">若依移动端登录</text>
    </view>
    <view class="login-form-content">
      <view class="input-item flex align-center">
        <view class="iconfont icon-user icon"></view>
        <input v-model="loginForm.username" class="input" type="text" placeholder="请输入账号" maxlength="30" />
      </view>
      <view class="input-item flex align-center">
        <view class="iconfont icon-password icon"></view>
        <input v-model="loginForm.password" type="password" class="input" placeholder="请输入密码" maxlength="20" />
      </view>
      <view class="input-item flex align-center" style="width: 60%;margin: 0px;" v-if="captchaEnabled">
        <view class="iconfont icon-code icon"></view>
        <input v-model="loginForm.code" type="number" class="input" placeholder="请输入验证码" maxlength="4" />
        <view class="login-code"> 
          <image :src="codeUrl" @click="getCode" class="login-code-img"></image>
        </view>
      </view>
      <view class="action-btn">
        <button @click="handleLogin" class="login-btn cu-btn block bg-blue lg round">登录</button>
      </view>
      <view class="reg text-center" v-if="register">
        <text class="text-grey1">没有账号？</text>
        <text @click="handleUserRegister" class="text-blue">立即注册</text>
      </view>
      <view class="xieyi text-center">
        <text class="text-grey1">登录即代表同意</text>
        <text @click="handleUserAgrement" class="text-blue">《用户协议》</text>
        <text @click="handlePrivacy" class="text-blue">《隐私协议》</text>
      </view>
    </view>
     
  </view>
</template>

<script setup>
  import { ref, reactive, getCurrentInstance, onMounted } from 'vue'
  import { getCodeImg } from '@/api/login'
  import useUserStore from '@/store/modules/user'
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
  const globalConfig = ref(getApp().globalData.config)
  const loginForm = reactive({
    username: "admin",
    password: "admin123",
    code: "",
    uuid: ""
  })

  // Pinia store
  const userStore = useUserStore()

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



  // 登录成功后，处理函数
  const loginSuccess = async () => {
    try {
      // 设置用户信息
      userStore.getInfo().then(async () => {
        try {
          // 在获取用户信息成功后进行学生账号检测
          const studentStatus = await checkIsStudent(loginForm.username)

          // 根据检测结果显示不同的成功提示消息
          if (studentStatus) {
            // 是学生账号，检查学生信息是否完整
            const studentInfo = await isStudentInfoFilled(loginForm.username)
            if(studentInfo.data){
              // 学生信息已完善
              proxy.$modal.msgSuccess('学生账号登录成功')

              // 基于用户类型的差异化处理逻辑
              if (isStudentAccount.value) {
                // 学生账号的处理逻辑
                proxy.$tab.reLaunch('/pages/index')
              }
            } else {
              // 学生信息未完善，引导用户完善信息
              proxy.$modal.msgError('学生信息未完善，请先完善个人信息')

              // 跳转到学生信息完善页面
              setTimeout(() => {
                proxy.$tab.reLaunch('/pages/student/complete-info')
              }, 1500)
              return // 提前返回，不执行后续的首页跳转逻辑
            }
          } else {
            // 非学生账号（管理员等）
            proxy.$modal.msgSuccess('管理员账号登录成功')

            // 非学生账号（管理员等）的处理逻辑
            proxy.$tab.reLaunch('/pages/index')
          }
        } catch (detectionError) {
          console.error('学生账号检测失败:', detectionError)
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

      userStore.getInfo().then(() => {
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
      await userStore.login(loginForm)
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
    background-color: #ffffff;
  }

  .normal-login-container {
    width: 100%;

    .logo-content {
      width: 100%;
      font-size: 21px;
      text-align: center;
      padding-top: 15%;

      image {
        border-radius: 4px;
      }

      .title {
        margin-left: 10px;
      }
    }

    .login-form-content {
      text-align: center;
      margin: 20px auto;
      margin-top: 15%;
      width: 80%;

      .input-item {
        margin: 20px auto;
        background-color: #f5f6f7;
        height: 45px;
        border-radius: 20px;

        .icon {
          font-size: 38rpx;
          margin-left: 10px;
          color: #999;
        }

        .input {
          width: 100%;
          font-size: 14px;
          line-height: 20px;
          text-align: left;
          padding-left: 15px;
        }

      }

      .login-btn {
        margin-top: 40px;
        height: 45px;
      }
      
      .reg {
        margin-top: 15px;
      }
      
      .xieyi {
        color: #333;
        margin-top: 20px;
      }
      
      .login-code {
        height: 38px;
        float: right;
      
        .login-code-img {
          height: 38px;
          position: absolute;
          margin-left: 10px;
          width: 200rpx;
        }
      }
    }
  }

</style>
