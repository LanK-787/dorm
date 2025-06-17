<template>
  <view class="container">
    <!-- 顶部提示 -->
    <view class="tip-card">
      <view class="tip-icon">
        <uni-icons type="info-filled" size="24" color="#409EFF"></uni-icons>
      </view>
      <view class="tip-content">
        <text class="tip-title">完善维修人员信息</text>
        <text class="tip-desc">检测到您具有维修人员权限，请完善相关信息以便更好地为您提供服务</text>
      </view>
    </view>

    <!-- 表单区域 -->
    <view class="form-container">
      <uni-forms ref="formRef" :model="form" :rules="rules" labelWidth="100px">
        <uni-forms-item label="工号" name="repairerNo" required>
          <uni-easyinput
            v-model="form.repairerNo"
            placeholder="请输入工号"
            :clearable="false"
            :disabled="true"
          />
        </uni-forms-item>

        <uni-forms-item label="姓名" name="name" required>
          <uni-easyinput
            v-model="form.name"
            placeholder="请输入姓名"
            :clearable="false"
            :disabled="true"
          />
        </uni-forms-item>

        <uni-forms-item label="联系电话" name="phone" required>
          <uni-easyinput 
            v-model="form.phone" 
            placeholder="请输入联系电话" 
            :clearable="true"
            type="number"
          />
        </uni-forms-item>

        <uni-forms-item label="专长领域" name="specialty" required>
          <uni-data-checkbox
            v-model="form.specialty"
            :localdata="specialtyOptions"
            multiple
            :wrap="true"
          />
        </uni-forms-item>
      </uni-forms>
    </view>

    <!-- 操作按钮 -->
    <view class="button-container">
      <button 
        type="primary" 
        class="submit-btn"
        :loading="loading"
        @click="handleSubmit"
      >
        {{ loading ? '提交中...' : '完成设置' }}
      </button>
    </view>
  </view>
</template>

<script setup>
import { ref, reactive, getCurrentInstance, onMounted } from 'vue'
import { addRepairer } from '@/api/manage/repairer'
import useUserStore from '@/store/modules/user'
import useRepairerStore from '@/store/modules/repairer'

// 获取当前实例以访问全局属性
const { proxy } = getCurrentInstance()

// 获取store实例
const userStore = useUserStore()
const repairerStore = useRepairerStore()

// 响应式数据
const loading = ref(false)
const formRef = ref(null)

// 表单数据
const form = reactive({
  userId: userStore.id,
  repairerNo: '', // 将在onMounted中自动填充
  name: '', // 姓名字段默认为空
  phone: '',
  specialty: [],
  status: '1' // 默认状态为空闲，但不在表单中显示
})

// 专长领域选项
const specialtyOptions = ref([
  { value: '0', text: '电工' },
  { value: '1', text: '水工' },
  { value: '2', text: '木工' },
  { value: '3', text: '水泥工' }
])

// 删除状态选项，不再在表单中显示

// 表单验证规则
const rules = reactive({
  repairerNo: {
    rules: [
      { required: true, errorMessage: '请输入工号' },
      { minLength: 2, maxLength: 20, errorMessage: '工号长度应为2-20个字符' }
    ]
  },
  name: {
    rules: [
      { required: true, errorMessage: '请输入姓名' },
      { minLength: 2, maxLength: 10, errorMessage: '姓名长度应为2-10个字符' }
    ]
  },
  phone: {
    rules: [
      { required: true, errorMessage: '请输入联系电话' },
      { pattern: /^1[3-9]\d{9}$/, errorMessage: '请输入正确的手机号码' }
    ]
  },
  specialty: {
    rules: [
      { required: true, errorMessage: '请选择专长领域' }
    ]
  }
})

// 提交表单
const handleSubmit = async () => {
  try {
    // 额外验证禁用字段是否有值
    if (!form.repairerNo) {
      proxy.$modal.showToast('工号信息异常，请重新登录')
      return
    }
    if (!form.name) {
      proxy.$modal.showToast('姓名信息异常，请重新登录')
      return
    }

    // 表单验证（主要验证用户可编辑的字段）
    const valid = await formRef.value.validate()
    if (!valid) {
      return
    }

    loading.value = true

    // 处理专长领域数据
    const submitData = {
      ...form,
      specialty: form.specialty.join(',')
    }

    // 调用API提交数据
    const response = await addRepairer(submitData)
    
    if (response.code === 200) {
      proxy.$modal.showToast('维修人员信息设置成功！')

      // 更新store中的维修人员信息
      repairerStore.setCurrentRepairer(response.data)

      // 延迟跳转到首页
      setTimeout(() => {
        proxy.$tab.reLaunch('/pages/index')
      }, 1500)
    } else {
      proxy.$modal.showToast(response.msg || '设置失败，请重试')
    }
  } catch (error) {
    console.error('提交维修人员信息失败:', error)
    proxy.$modal.showToast('设置失败，请检查网络连接')
  } finally {
    loading.value = false
  }
}

// 页面加载时的初始化
onMounted(() => {
  // 确保用户ID存在
  if (!form.userId) {
    proxy.$modal.showToast('用户信息异常，请重新登录')
    setTimeout(() => {
      proxy.$tab.reLaunch('/pages/login')
    }, 1500)
    return
  }

  // 自动填充工号字段（使用用户名）
  if (userStore.name) {
    form.repairerNo = userStore.name
    console.log('自动填充工号:', userStore.name)
  }

  // 自动填充姓名字段（使用用户昵称）
  if (userStore.nickName) {
    form.name = userStore.nickName
    console.log('自动填充姓名:', userStore.nickName)
  }
})
</script>

<style lang="scss" scoped>
.container {
  min-height: 100vh;
  background: linear-gradient(180deg, #f8f9fa 0%, #ffffff 100%);
  padding: 20rpx;
}

.tip-card {
  background: #ffffff;
  border-radius: 16rpx;
  padding: 30rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.08);
  display: flex;
  align-items: flex-start;
}

.tip-icon {
  margin-right: 20rpx;
  margin-top: 4rpx;
}

.tip-content {
  flex: 1;
}

.tip-title {
  display: block;
  font-size: 32rpx;
  font-weight: 600;
  color: #333333;
  margin-bottom: 10rpx;
}

.tip-desc {
  display: block;
  font-size: 28rpx;
  color: #666666;
  line-height: 1.5;
}

.form-container {
  background: #ffffff;
  border-radius: 16rpx;
  padding: 30rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.08);
}

.button-container {
  padding: 0 30rpx;
}

.submit-btn {
  width: 100%;
  height: 88rpx;
  border-radius: 44rpx;
  font-size: 32rpx;
  font-weight: 600;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  color: #ffffff;
  
  &:active {
    opacity: 0.8;
  }
}
</style>
