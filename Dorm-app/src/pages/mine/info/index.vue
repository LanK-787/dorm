<template>
  <view class="container">
    <uni-list>
      <!-- 昵称/姓名 -->
      <uni-list-item
        showExtraIcon="true"
        :extraIcon="{type: 'person-filled'}"
        :title="hasStudentData ? '姓名' : '昵称'"
        :rightText="displayName" />

      <!-- 手机号码 -->
      <uni-list-item
        showExtraIcon="true"
        :extraIcon="{type: 'phone-filled'}"
        title="手机号码"
        :rightText="displayPhone" />

      <!-- 邮箱 -->
      <uni-list-item
        showExtraIcon="true"
        :extraIcon="{type: 'email-filled'}"
        title="邮箱"
        :rightText="displayEmail" />

      <!-- 学号（仅学生）或岗位（非学生） -->
      <uni-list-item
        v-if="hasStudentData && studentNo"
        showExtraIcon="true"
        :extraIcon="{type: 'contact-filled'}"
        title="学号"
        :rightText="studentNo" />

      <!-- 班级（学生）或岗位（非学生） -->
      <uni-list-item
        showExtraIcon="true"
        :extraIcon="{type: hasStudentData ? 'home-filled' : 'auth-filled'}"
        :title="fourthFieldTitle"
        :rightText="className" />

      <!-- 性别（学生）或角色（非学生） -->
      <uni-list-item
        showExtraIcon="true"
        :extraIcon="{type: hasStudentData ? 'person' : 'staff-filled'}"
        :title="fifthFieldTitle"
        :rightText="genderText" />

      <!-- 状态（学生）或创建日期（非学生） -->
      <uni-list-item
        showExtraIcon="true"
        :extraIcon="{type: hasStudentData ? 'checkmarkempty' : 'calendar-filled'}"
        :title="sixthFieldTitle"
        :rightText="statusText" />
    </uni-list>
  </view>
</template>

<script setup>
  import { ref, reactive, computed, onMounted } from 'vue'
  import { getUserProfile } from "@/api/system/user"
  import { getStudentInfo } from "@/api/dorm/student"
  import useUserStore from '@/store/modules/user'

  // 获取用户store实例
  const userStore = useUserStore()

  // 响应式数据
  const user = reactive({})
  const student = reactive({})
  const roleGroup = ref("")
  const postGroup = ref("")

  // 计算属性 - 判断是否为学生模式
  const isStudentMode = computed(() => {
    return userStore.roles && userStore.roles.includes('student')
  })

  // 计算属性 - 判断是否有学生数据
  const hasStudentData = computed(() => {
    return isStudentMode.value && student.name
  })

  // 计算属性 - 动态显示数据
  const displayName = computed(() => {
    return hasStudentData.value ? student.name : user.nickName
  })

  const displayPhone = computed(() => {
    return hasStudentData.value ? student.phone : user.phonenumber
  })

  const displayEmail = computed(() => {
    return hasStudentData.value ? student.email : user.email
  })

  // 学生专用字段
  const studentNo = computed(() => {
    return hasStudentData.value ? student.studentNo : ''
  })

  const className = computed(() => {
    return hasStudentData.value ? student.className : postGroup.value
  })

  // 性别文本转换
  const genderText = computed(() => {
    if (!hasStudentData.value) return roleGroup.value
    const gender = student.gender
    return gender === '0' ? '男' : gender === '1' ? '女' : '未知'
  })

  // 状态文本转换
  const statusText = computed(() => {
    if (!hasStudentData.value) return user.createTime
    const status = student.status
    // 根据实际业务需求定义状态文本
    switch(status) {
      case '0': return '正常'
      case '1': return '停用'
      case '2': return '毕业'
      default: return '未知'
    }
  })

  // 动态标题
  const fourthFieldTitle = computed(() => {
    return hasStudentData.value ? '班级' : '岗位'
  })

  const fifthFieldTitle = computed(() => {
    return hasStudentData.value ? '性别' : '角色'
  })

  const sixthFieldTitle = computed(() => {
    return hasStudentData.value ? '状态' : '创建日期'
  })

  // 方法定义
  const getUser = () => {
    getUserProfile().then(response => {
      // 清空并重新赋值user对象
      Object.keys(user).forEach(key => delete user[key])
      Object.assign(user, response.data)

      roleGroup.value = response.roleGroup
      postGroup.value = response.postGroup
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
      }
    }).catch(error => {
      console.error('获取学生信息出错:', error)
    })
  }

  // 生命周期钩子
  onMounted(() => {
    getUser()

    // 如果是学生模式，获取学生信息
    if (isStudentMode.value) {
      getStudentData()
    }
  })
</script>

<style lang="scss">
  page {
    background-color: #ffffff;
  }
</style>
