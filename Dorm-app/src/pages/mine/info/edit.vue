<template>
  <view class="container">
    <view class="example">
      <!-- 学生模式表单 -->
      <uni-forms v-if="isStudentMode" ref="form" :model="student" labelWidth="80px">
        <uni-forms-item label="学号" name="studentNo">
          <uni-easyinput v-model="student.studentNo" placeholder="请输入学号" disabled/>
        </uni-forms-item>
        <uni-forms-item label="姓名" name="name">
          <uni-easyinput v-model="student.name" placeholder="请输入姓名" />
        </uni-forms-item>
        <uni-forms-item label="班级" name="className">
          <uni-easyinput v-model="student.className" placeholder="请输入班级" />
        </uni-forms-item>
        <uni-forms-item label="手机号码" name="phone">
          <uni-easyinput v-model="student.phone" placeholder="请输入手机号码" />
        </uni-forms-item>
        <uni-forms-item label="邮箱" name="email">
          <uni-easyinput v-model="student.email" placeholder="请输入邮箱" />
        </uni-forms-item>
        <uni-forms-item label="性别" name="gender" required>
          <uni-data-checkbox v-model="student.gender" :localdata="sexs" />
        </uni-forms-item>
        <uni-forms-item label="状态" name="status" required>
          <uni-data-checkbox v-model="student.status" :localdata="statusOptions" />
        </uni-forms-item>
      </uni-forms>

      <!-- 用户模式表单 -->
      <uni-forms v-else ref="form" :model="user" labelWidth="80px">
        <uni-forms-item label="用户昵称" name="nickName">
          <uni-easyinput v-model="user.nickName" placeholder="请输入昵称" />
        </uni-forms-item>
        <uni-forms-item label="手机号码" name="phonenumber">
          <uni-easyinput v-model="user.phonenumber" placeholder="请输入手机号码" />
        </uni-forms-item>
        <uni-forms-item label="邮箱" name="email">
          <uni-easyinput v-model="user.email" placeholder="请输入邮箱" />
        </uni-forms-item>
        <uni-forms-item label="性别" name="sex" required>
          <uni-data-checkbox v-model="user.sex" :localdata="sexs" />
        </uni-forms-item>
      </uni-forms>

      <button type="primary" @click="submit">
        {{ isStudentMode ? '更新学生信息' : '更新用户信息' }}
      </button>
    </view>
  </view>
</template>

<script setup>
  import { ref, reactive, computed, onMounted, getCurrentInstance, nextTick } from 'vue'
  import { getUserProfile } from "@/api/system/user"
  import { updateUserProfile } from "@/api/system/user"
  import { updateStudentInfo, getStudentInfo } from "@/api/dorm/student"

  import useUserStore from '@/store/modules/user'

  // 获取当前实例以访问全局属性
  const { proxy } = getCurrentInstance()

  // 获取用户store实例
  const userStore = useUserStore()

  // 计算属性 - 判断是否为学生模式
  const isStudentMode = computed(() => {
    return userStore.roles && userStore.roles.includes('student')
  })

  // 响应式数据 - 用户信息
  const user = reactive({
    nickName: "",
    phonenumber: "",
    email: "",
    sex: ""
  })

  // 响应式数据 - 学生信息
  const student = reactive({
    studentNo: "",
    name: "",
    gender: "",
    className: "",
    phone: "",
    status: "",
    email: ""
  })

  // 性别/状态选项
  const sexs = ref([{
    text: '男',
    value: "0"
  }, {
    text: '女',
    value: "1"
  }])

  const statusOptions = ref([{
    text: '在校',
    value: "0"
  }, {
    text: '离校',
    value: "1"
  }])

  // 用户模式验证规则
  const userRules = ref({
    nickName: {
      rules: [{
        required: true,
        errorMessage: '用户昵称不能为空'
      }]
    },
    phonenumber: {
      rules: [{
        required: true,
        errorMessage: '手机号码不能为空'
      }, {
        pattern: /^1[3|4|5|6|7|8|9][0-9]\d{8}$/,
        errorMessage: '请输入正确的手机号码'
      }]
    },
    email: {
      rules: [{
        required: true,
        errorMessage: '邮箱地址不能为空'
      }, {
        format: 'email',
        errorMessage: '请输入正确的邮箱地址'
      }]
    }
  })

  // 学生模式验证规则
  const studentRules = ref({
    studentNo: {
      rules: [{
        required: true,
        errorMessage: '学号不能为空'
      }, {
        minLength: 6,
        maxLength: 20,
        errorMessage: '学号长度应为6-20位'
      }]
    },
    name: {
      rules: [{
        required: true,
        errorMessage: '姓名不能为空'
      }, {
        minLength: 2,
        maxLength: 10,
        errorMessage: '姓名长度应为2-10位'
      }]
    },
    className: {
      rules: [{
        required: true,
        errorMessage: '班级不能为空'
      }]
    },
    phone: {
      rules: [{
        required: true,
        errorMessage: '手机号码不能为空'
      }, {
        pattern: /^1[3-9]\d{9}$/,
        errorMessage: '请输入正确的手机号码'
      }]
    },
    gender: {
      rules: [{
        required: true,
        errorMessage: '请选择性别'
      }]
    },
    email: {
      rules: [{
        format: 'email',
        errorMessage: '请输入正确的邮箱地址'
      }]
    },
    status: {
      rules: [{
        required: true,
        errorMessage: '请选择状态'
      }]
    }
  })

  // 动态规则
  const currentRules = computed(() => {
    return isStudentMode.value ? studentRules.value : userRules.value
  })

  // 表单引用
  const form = ref(null)

  // 方法定义
  const getUser = () => {
    getUserProfile().then(response => {
      // 清空并重新赋值user对象
      Object.keys(user).forEach(key => delete user[key])
      Object.assign(user, response.data)
    })
  }

  const getStudentData = () => {
    getStudentInfo().then(response => {
      if (response.code === 200 && response.data) {
        // 清空并重新赋值student对象
        Object.keys(student).forEach(key => delete student[key])
        Object.assign(student, {
          studentNo: response.data.studentNo || '',
          name: response.data.name || '',
          gender: response.data.gender || '',
          className: response.data.className || '',
          phone: response.data.phone || '',
          status: response.data.status || '0',
          email: response.data.email || ''
        })
      } else {
        console.error('获取学生信息失败:', response.msg)
        proxy.$modal.msgError(response.msg || '获取学生信息失败')
      }
    }).catch(error => {
      console.error('获取学生信息出错:', error)
      proxy.$modal.msgError('获取学生信息失败，请检查网络连接')
    })
  }

  const submit = () => {
    form.value.validate().then(res => {
      if (isStudentMode.value) {
        // 学生模式：提交学生信息
        updateStudentInfo(student).then(response => {
          if (response.code === 200) {
            proxy.$modal.msgSuccess("学生信息修改成功")
            // 重新获取最新的学生信息
            getStudentData()
          } else {
            proxy.$modal.msgError(response.msg || "修改失败")
          }
        }).catch(error => {
          console.error('更新学生信息失败:', error)
          proxy.$modal.msgError("修改失败，请检查网络连接")
        })
      } else {
        // 用户模式：提交用户信息
        updateUserProfile(user).then(response => {
          if (response.code === 200) {
            proxy.$modal.msgSuccess("用户信息修改成功")
          } else {
            proxy.$modal.msgError(response.msg || "修改失败")
          }
        }).catch(error => {
          console.error('更新用户信息失败:', error)
          proxy.$modal.msgError("修改失败，请检查网络连接")
        })
      }
    }).catch(error => {
      console.error('表单验证失败:', error)
    })
  }

  // 生命周期钩子
  onMounted(() => {
    // 根据模式加载不同的数据
    if (isStudentMode.value) {
      getStudentData()
    } else {
      getUser()
    }

    // 使用nextTick确保表单组件已渲染完成后设置规则
    nextTick(() => {
      if (form.value) {
        form.value.setRules(currentRules.value)
      }
    })
  })
</script>

<style lang="scss" scoped>
  page {
    background-color: #ffffff;
  }

  .example {
    padding: 15px;
    background-color: #fff;
  }

  .segmented-control {
    margin-bottom: 15px;
  }

  .button-group {
    margin-top: 15px;
    display: flex;
    justify-content: space-around;
  }

  .form-item {
    display: flex;
    align-items: center;
    flex: 1;
  }

  .button {
    display: flex;
    align-items: center;
    height: 35px;
    line-height: 35px;
    margin-left: 10px;
  }
</style>
