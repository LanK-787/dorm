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
  import useStudentStore from '@/store/modules/student'

  // 获取学生store实例
  const studentStore = useStudentStore()

  // 响应式数据
  const user = reactive({})
  const roleGroup = ref("")
  const postGroup = ref("")

  // 计算属性 - 判断是否显示学生信息
  const hasStudentData = computed(() => {
    return studentStore.currentStudent &&
           Object.keys(studentStore.currentStudent).length > 0 &&
           studentStore.currentStudent.name
  })

  // 计算属性 - 动态显示数据
  const displayName = computed(() => {
    return hasStudentData.value ? studentStore.currentStudent.name : user.nickName
  })

  const displayPhone = computed(() => {
    return hasStudentData.value ? studentStore.currentStudent.phone : user.phonenumber
  })

  const displayEmail = computed(() => {
    return hasStudentData.value ? studentStore.currentStudent.email : user.email
  })

  // 学生专用字段
  const studentNo = computed(() => {
    return hasStudentData.value ? studentStore.currentStudent.studentNo : ''
  })

  const className = computed(() => {
    return hasStudentData.value ? studentStore.currentStudent.className : postGroup.value
  })

  // 性别文本转换
  const genderText = computed(() => {
    if (!hasStudentData.value) return roleGroup.value
    const gender = studentStore.currentStudent.gender
    return gender === '0' ? '男' : gender === '1' ? '女' : '未知'
  })

  // 状态文本转换
  const statusText = computed(() => {
    if (!hasStudentData.value) return user.createTime
    const status = studentStore.currentStudent.status
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

  // 生命周期钩子
  onMounted(() => {
    getUser()
  })
</script>

<style lang="scss">
  page {
    background-color: #ffffff;
  }
</style>
