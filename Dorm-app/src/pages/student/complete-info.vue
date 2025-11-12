<template>
  <view class="container">
    <view class="header">
      <view class="title">完善学生信息</view>
      <view class="subtitle">请填写完整的学生信息以继续使用系统</view>
    </view>
    
    <view class="form-container">
      <uni-forms ref="studentForm" :model="studentInfo" :rules="rules" labelWidth="100px">
        <uni-forms-item label="学号" name="studentNo" required>
          <uni-easyinput 
            v-model="studentInfo.studentNo" 
            placeholder="请输入学号" 
            :clearable="true"
          />
        </uni-forms-item>
        
        <uni-forms-item label="姓名" name="name" required>
          <uni-easyinput 
            v-model="studentInfo.name" 
            placeholder="请输入真实姓名" 
            :clearable="true"
          />
        </uni-forms-item>
        
        <uni-forms-item label="班级" name="className" required>
          <uni-easyinput 
            v-model="studentInfo.className" 
            placeholder="请输入班级名称" 
            :clearable="true"
          />
        </uni-forms-item>
        
        <uni-forms-item label="手机号" name="phone" required>
          <uni-easyinput 
            v-model="studentInfo.phone" 
            placeholder="请输入手机号码" 
            type="number"
            :clearable="true"
          />
        </uni-forms-item>
        
        <uni-forms-item label="性别" name="gender" required>
          <uni-data-checkbox 
            v-model="studentInfo.gender" 
            :localdata="genderOptions"
          />
        </uni-forms-item>
        
        <uni-forms-item label="邮箱" name="email">
          <uni-easyinput 
            v-model="studentInfo.email" 
            placeholder="请输入邮箱" 
            :clearable="true"
          />
        </uni-forms-item>
      </uni-forms>
      
      <view class="button-group">
        <button 
          type="primary" 
          class="submit-btn" 
          @click="handleSubmit"
          :loading="submitting"
        >
          {{ submitting ? '提交中...' : '提交信息' }}
        </button>
        
      </view>
    </view>
  </view>
</template>

<script setup>
  import { ref, reactive, getCurrentInstance, onMounted } from 'vue'
  import { addStudent, updateStudent } from '@/api/dorm/student'
  
  // 获取当前实例以访问全局属性
  const { proxy } = getCurrentInstance()
  
  // 响应式数据
  const submitting = ref(false)
  const studentForm = ref(null)
  
  // 学生信息表单数据
  const studentInfo = reactive({
    studentNo: '',
    name: '',
    className: '',
    phone: '',
    gender: '',
    eamil: ''
  })
  
  // 性别选项
  const genderOptions = [
    { text: '男', value: '0' },
    { text: '女', value: '1' }
  ]
  
  // 表单验证规则
  const rules = {
    studentNo: {
      rules: [
        { required: true, errorMessage: '学号不能为空' },
        { minLength: 6, maxLength: 20, errorMessage: '学号长度应为6-20位' }
      ]
    },
    name: {
      rules: [
        { required: true, errorMessage: '姓名不能为空' },
        { minLength: 2, maxLength: 10, errorMessage: '姓名长度应为2-10位' }
      ]
    },
    className: {
      rules: [
        { required: true, errorMessage: '班级不能为空' }
      ]
    },
    phone: {
      rules: [
        { required: true, errorMessage: '手机号不能为空' },
        { pattern: /^1[3-9]\d{9}$/, errorMessage: '请输入正确的手机号码' }
      ]
    },
    gender: {
      rules: [
        { required: true, errorMessage: '请选择性别' }
      ]
    }
  }
  
  // 提交学生信息
  const handleSubmit = async () => {
    try {
      // 表单验证
      await studentForm.value.validate()
      
      submitting.value = true
      
      // 提交学生信息
      await addStudent(studentInfo)
      
      proxy.$modal.msgSuccess('学生信息提交成功！')
      
      // 延迟跳转到首页
      setTimeout(() => {
        proxy.$tab.reLaunch('/pages/index')
      }, 1500)
      
    } catch (error) {
      console.error('提交学生信息失败:', error)
      if (error.message) {
        proxy.$modal.msgError(error.message)
      } else {
        proxy.$modal.msgError('提交失败，请检查网络连接')
      }
    } finally {
      submitting.value = false
    }
  }
  
  // 暂时跳过
  const handleSkip = () => {
    proxy.$modal.confirm('暂时跳过将无法使用完整功能，确定要跳过吗？').then(() => {
      proxy.$tab.reLaunch('/pages/index')
    }).catch(() => {
      // 用户取消，不做任何操作
    })
  }
  
  onMounted(() => {
    // 页面加载完成后的初始化操作
  })
</script>

<style lang="scss" scoped>
  page {
    background-color: #f8f9fa;
  }
  
  .container {
    min-height: 100vh;
    padding: 20px;
  }
  
  .header {
    text-align: center;
    margin-bottom: 30px;
    
    .title {
      font-size: 24px;
      font-weight: bold;
      color: #333;
      margin-bottom: 10px;
    }
    
    .subtitle {
      font-size: 14px;
      color: #666;
      line-height: 1.5;
    }
  }
  
  .form-container {
    background-color: #fff;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  }
  
  .button-group {
    margin-top: 30px;
    display: flex;
    flex-direction: column;
    gap: 15px;
    
    .submit-btn {
      width: 100%;
      background-color: #007aff;
      border-radius: 12px;
      height: 48px;
      font-size: 17px;
      font-weight: 600;
      color: #fff;
      box-shadow: 0 4px 16px rgba(0, 122, 255, 0.08);
      display: flex;
      align-items: center;
      justify-content: center;
      letter-spacing: 1px;
      transition: background 0.2s, box-shadow 0.2s;
      border: none;
      padding: 0 20px;
    }
    .submit-btn:active {
      background-color: #005ecb;
      box-shadow: 0 2px 8px rgba(0, 122, 255, 0.16);
    }
    
    .skip-btn {
      background-color: #f8f9fa;
      color: #666;
      border: 1px solid #ddd;
      border-radius: 8px;
      height: 45px;
      font-size: 14px;
    }
  }
</style>
