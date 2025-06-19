<template>
  <view class="container">
    <uni-list>
      <!-- 昵称/姓名 -->
      <uni-list-item
        showExtraIcon="true"
        :extraIcon="{type: 'person-filled'}"
        :title="hasStudentData || hasRepairerData ? '姓名' : '昵称'"
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

      <!-- 学号（仅学生）-->
      <uni-list-item
        v-if="hasStudentData && studentNo"
        showExtraIcon="true"
        :extraIcon="{type: 'contact-filled'}"
        title="学号"
        :rightText="studentNo" />

      <!-- 工号（仅维修人员）-->
      <uni-list-item
        v-if="hasRepairerData && repairerNo"
        showExtraIcon="true"
        :extraIcon="{type: 'contact-filled'}"
        title="工号"
        :rightText="repairerNo" />

      <!-- 班级（学生）、专长（维修人员）或岗位（非学生） -->
      <uni-list-item
        showExtraIcon="true"
        :extraIcon="{type: hasStudentData ? 'home-filled' : hasRepairerData ? 'gear-filled' : 'auth-filled'}"
        :title="fourthFieldTitle"
        :rightText="className" />

      <!-- 性别（学生）、状态（维修人员）或角色（非学生） -->
      <uni-list-item
        showExtraIcon="true"
        :extraIcon="{type: hasStudentData ? 'person' : hasRepairerData ? 'checkmarkempty' : 'staff-filled'}"
        :title="fifthFieldTitle"
        :rightText="genderText" />

      <!-- 状态（学生）或创建日期（非学生） -->
      <uni-list-item
        showExtraIcon="true"
        :extraIcon="{type: hasStudentData ? 'checkmarkempty' : 'calendar-filled'}"
        :title="sixthFieldTitle"
        :rightText="statusText" />

      <!-- 已接单数量（仅维修人员） -->
      <uni-list-item
        v-if="hasRepairerData"
        showExtraIcon="true"
        :extraIcon="{type: 'list-filled'}"
        title="已接单数量"
        :rightText="orderCountText" />
    </uni-list>
  </view>
</template>

<script setup>
  import { ref, reactive, computed, onMounted, getCurrentInstance } from 'vue'
  import { getUserProfile } from "@/api/system/user"
  import { getStudentInfo } from "@/api/dorm/student"
  import useUserStore from '@/store/modules/user'
  import useRepairerStore from '@/store/modules/repairer'

  // 获取当前实例以访问全局属性
  const { proxy } = getCurrentInstance()

  // 获取store实例
  const userStore = useUserStore()
  const repairerStore = useRepairerStore()

  // 响应式数据
  const user = reactive({})
  const student = reactive({})
  const repairer = reactive({})
  const roleGroup = ref("")
  const postGroup = ref("")

  // 计算属性 - 判断是否为学生模式
  const isStudentMode = computed(() => {
    return userStore.roles && userStore.roles.includes('student')
  })

  // 计算属性 - 判断是否为维修人员模式
  const isRepairerMode = computed(() => {
    return userStore.roles && userStore.roles.includes('repairer')
  })

  // 计算属性 - 判断是否有学生数据
  const hasStudentData = computed(() => {
    return isStudentMode.value && student.name
  })

  // 计算属性 - 判断是否有维修人员数据
  const hasRepairerData = computed(() => {
    return isRepairerMode.value && repairer.name
  })

  // 计算属性 - 动态显示数据
  const displayName = computed(() => {
    if (hasStudentData.value) return student.name
    if (hasRepairerData.value) return repairer.name
    return user.nickName
  })

  const displayPhone = computed(() => {
    if (hasStudentData.value) return student.phone
    if (hasRepairerData.value) return repairer.phone
    return user.phonenumber
  })

  const displayEmail = computed(() => {
    if (hasStudentData.value) return student.email
    return user.email
  })

  // 学生专用字段
  const studentNo = computed(() => {
    return hasStudentData.value ? student.studentNo : ''
  })

  // 维修人员专用字段
  const repairerNo = computed(() => {
    return hasRepairerData.value ? repairer.repairerNo : ''
  })

  const className = computed(() => {
    if (hasStudentData.value) return student.className
    if (hasRepairerData.value) return repairer.specialtyText || '未设置'
    return postGroup.value
  })

  // 性别文本转换
  const genderText = computed(() => {
    if (hasStudentData.value) {
      const gender = student.gender
      return gender === '0' ? '男' : gender === '1' ? '女' : '未知'
    }
    if (hasRepairerData.value) {
      const status = repairer.status
      return status === '0' ? '出工' : status === '1' ? '空闲' : '未知'
    }
    return roleGroup.value
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
    if (hasStudentData.value) return '班级'
    if (hasRepairerData.value) return '专长领域'
    return '岗位'
  })

  const fifthFieldTitle = computed(() => {
    if (hasStudentData.value) return '性别'
    if (hasRepairerData.value) return '当前状态'
    return '角色'
  })

  const sixthFieldTitle = computed(() => {
    return hasStudentData.value ? '状态' : '创建日期'
  })

  // 已接单数量文本
  const orderCountText = computed(() => {
    if (hasRepairerData.value) {
      const count = repairer.orderCount || 0
      return `${count} 单`
    }
    return '0 单'
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

  const getRepairerData = async () => {
    try {
      const repairerData = await repairerStore.fetchRepairerByUserId(userStore.id)
      if (repairerData) {
        // 清空并重新赋值repairer对象
        Object.keys(repairer).forEach(key => delete repairer[key])

        // 处理专长领域文本
        const specialtyText = repairerData.specialty ?
          repairerData.specialty.split(',').map(item => {
            const specialtyMap = {
              '0': '电工',
              '1': '水工',
              '2': '木工',
              '3': '水泥工'
            }
            return specialtyMap[item] || item
          }).join('、') : '未设置'

        Object.assign(repairer, {
          repairerId: repairerData.repairerId || '',
          repairerNo: repairerData.repairerNo || '',
          name: repairerData.name || '',
          phone: repairerData.phone || '',
          specialty: repairerData.specialty || '',
          specialtyText: specialtyText,
          status: repairerData.status || '1',
          orderCount: repairerData.orderCount || 0
        })
      } else {
        // 如果没有维修人员数据，跳转到信息填写页面
        proxy.$modal.confirm('检测到您具有维修人员权限，但尚未完善相关信息，是否立即完善？')
          .then(() => {
            proxy.$tab.navigateTo('/pages/mine/repairer/setup')
          })
          .catch(() => {
            console.log('用户取消完善维修人员信息')
          })
      }
    } catch (error) {
      console.error('获取维修人员信息出错:', error)
    }
  }

  // 生命周期钩子
  onMounted(() => {
    getUser()

    // 如果是学生模式，获取学生信息
    if (isStudentMode.value) {
      getStudentData()
    }

    // 如果是维修人员模式，获取维修人员信息
    if (isRepairerMode.value) {
      getRepairerData()
    }
  })
</script>

<style lang="scss">
  page {
    background-color: #ffffff;
  }
</style>
