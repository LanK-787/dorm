<template>
  <view class="page-container">
    <!-- 状态栏占位 -->
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>

    <!-- 头部区域 -->
    <view class="header">
      <view class="header-content">
        <view class="back-btn" @click="goBack">
          <text class="iconfont icon-back">‹</text>
        </view>
        <view class="header-title">
          <text class="title-text">提交报修</text>
        </view>
        <view class="header-placeholder"></view>
      </view>
    </view>

    <!-- 主要内容区域 -->
    <scroll-view class="main-content" scroll-y="true">
      <!-- 表单区域 -->
      <view class="form-container">
        <uni-forms ref="formRef" :model="form" :rules="rules" labelWidth="120px">
          <!-- 报修宿舍 -->
          <uni-forms-item label="报修宿舍" name="dormId" required>
            <view class="tree-select-wrapper" @click="showDormPicker">
              <view class="tree-select-input" :class="{ 'has-value': form.dormId }">
                <text class="select-text">{{ selectedDormText || '请选择报修宿舍' }}</text>
                <text class="select-arrow">›</text>
              </view>
            </view>
          </uni-forms-item>

          <!-- 报修项目 -->
          <uni-forms-item label="报修项目" name="specialty" required>
            <view class="specialty-select-wrapper" @click="showSpecialtyPicker">
              <view class="specialty-select-input" :class="{ 'has-value': form.specialty }">
                <text class="select-text">{{ getSelectedSpecialtyText() || '请选择报修项目' }}</text>
                <text class="select-arrow">›</text>
              </view>
            </view>
          </uni-forms-item>

          <!-- 问题描述 -->
          <uni-forms-item label="问题描述" name="description" required>
            <uni-easyinput 
              v-model="form.description" 
              type="textarea"
              placeholder="请详细描述遇到的问题"
              :maxlength="500"
              :clearable="true"
              autoHeight
            />
          </uni-forms-item>

          <!-- 报修人 -->
          <uni-forms-item label="报修人" name="reporterName" required>
            <uni-easyinput 
              v-model="form.reporterName" 
              placeholder="请输入报修人姓名"
              :clearable="true"
            />
          </uni-forms-item>

          <!-- 联系方式 -->
          <uni-forms-item label="联系方式" name="contactPhone" required>
            <uni-easyinput 
              v-model="form.contactPhone" 
              placeholder="请输入手机号码"
              type="number"
              :clearable="true"
            />
          </uni-forms-item>

          <!-- 图片上传 -->
          <uni-forms-item label="图片上传" name="images">
            <view class="upload-section">
              <uni-file-picker
                v-model="imageList"
                fileMediatype="image"
                mode="grid"
                :limit="6"
                :auto-upload="false"
                :sizeType="['compressed']"
                @select="onImageSelect"
                @delete="onImageDelete"
              />
              <view class="upload-tip">
                <text class="tip-text">最多上传6张图片，支持JPG、PNG格式</text>
              </view>
            </view>
          </uni-forms-item>
        </uni-forms>

        <!-- 提交按钮 -->
        <view class="submit-section">
          <view class="submit-btn" @click="submitForm" :class="{ 'loading': submitting }">
            <text class="submit-text">{{ submitting ? '提交中...' : '提交报修' }}</text>
          </view>
        </view>
      </view>
    </scroll-view>

    <!-- 宿舍选择弹窗 -->
    <uni-popup ref="dormPopup" type="bottom" :safe-area="false">
      <view class="popup-content">
        <view class="popup-header">
          <text class="popup-title">选择宿舍</text>
          <view class="popup-close" @click="closeDormPicker">
            <text class="close-icon">×</text>
          </view>
        </view>
        <view class="popup-body">
          <!-- 面包屑导航 -->
          <view v-if="breadcrumbs.length > 0" class="breadcrumb">
            <view
              v-for="(crumb, index) in breadcrumbs"
              :key="index"
              class="breadcrumb-item"
              @click="navigateToBreadcrumb(index)"
            >
              <text class="breadcrumb-text">{{ crumb.label }}</text>
              <text v-if="index < breadcrumbs.length - 1" class="breadcrumb-separator">></text>
            </view>
          </view>

          <scroll-view class="tree-scroll" scroll-y="true">
            <view class="tree-container">
              <view
                v-for="(item, index) in currentTreeData"
                :key="item.id"
                class="tree-item"
                @click="selectDorm(item)"
              >
                <view class="tree-content">
                  <text class="tree-label">{{ item.label }}</text>
                  <text v-if="item.children && item.children.length > 0" class="tree-arrow">›</text>
                  <text v-else class="tree-leaf">📍</text>
                </view>
              </view>
            </view>
          </scroll-view>
        </view>
      </view>
    </uni-popup>

    <!-- 报修项目选择弹窗 -->
    <uni-popup ref="specialtyPopup" type="bottom" :safe-area="false">
      <view class="popup-content">
        <view class="popup-header">
          <text class="popup-title">选择报修项目</text>
          <view class="popup-close" @click="closeSpecialtyPicker">
            <text class="close-icon">×</text>
          </view>
        </view>
        <view class="popup-body">
          <scroll-view class="specialty-scroll" scroll-y="true">
            <view class="specialty-container">
              <view
                v-for="(item, index) in specialtyOptions"
                :key="item.value"
                class="specialty-item"
                :class="{ 'selected': form.specialty === item.value }"
                @click="selectSpecialty(item)"
              >
                <view class="specialty-content">
                  <text class="specialty-label">{{ item.text }}</text>
                  <text v-if="form.specialty === item.value" class="specialty-check">✓</text>
                </view>
              </view>
            </view>
          </scroll-view>
        </view>
      </view>
    </uni-popup>
  </view>
</template>

<script setup>
import { ref, reactive, onMounted, getCurrentInstance } from 'vue'
import { addRequest, dormTreeSelect } from '@/api/dorm/request'
import { getStudentInfo } from '@/api/dorm/student'
import upload from '@/utils/upload'

// 获取当前实例以访问全局属性
const { proxy } = getCurrentInstance()

// 响应式数据
const statusBarHeight = ref(0)
const submitting = ref(false)
const imageList = ref([])
const dormTreeData = ref([])
const currentTreeData = ref([])
const breadcrumbs = ref([])
const selectedDormText = ref('')
const studentId = ref(null) // 存储当前学生ID

// 表单数据
const form = reactive({
  dormId: null,
  specialty: '', // 改为单个值而不是数组
  description: '',
  reporterName: '',
  contactPhone: '',
  images: ''
})

// 报修项目选项
const specialtyOptions = ref([
  { value: '0', text: '电工' },
  { value: '1', text: '水工' },
  { value: '2', text: '木工' },
  { value: '3', text: '水泥工' }
])

// 表单验证规则
const rules = reactive({
  dormId: {
    rules: [
      { required: true, errorMessage: '请选择报修宿舍' }
    ]
  },
  specialty: {
    rules: [
      { required: true, errorMessage: '请选择报修项目' }
    ]
  },
  description: {
    rules: [
      { required: true, errorMessage: '请输入问题描述' },
      { minLength: 10, maxLength: 500, errorMessage: '问题描述应为10-500个字符' }
    ]
  },
  reporterName: {
    rules: [
      { required: true, errorMessage: '请输入报修人姓名' },
      { minLength: 2, maxLength: 10, errorMessage: '姓名长度应为2-10个字符' }
    ]
  },
  contactPhone: {
    rules: [
      { required: true, errorMessage: '请输入联系方式' },
      { pattern: /^1[3-9]\d{9}$/, errorMessage: '请输入正确的手机号码' }
    ]
  }
})

// 引用
const formRef = ref()
const dormPopup = ref()
const specialtyPopup = ref()

// 方法定义
const initPage = () => {
  const systemInfo = uni.getSystemInfoSync()
  statusBarHeight.value = systemInfo.statusBarHeight || 0

  // 加载学生信息
  loadStudentInfo()

  // 加载宿舍树
  loadDormTree()
}

// 加载当前学生信息
const loadStudentInfo = async () => {
  try {
    const response = await getStudentInfo()
    if (response.code === 200 && response.data) {
      // 保存学生ID
      studentId.value = response.data.studentId

      // 可选：自动填充报修人信息
      if (response.data.name) {
        form.reporterName = response.data.name
      }
      if (response.data.phone) {
        form.contactPhone = response.data.phone
      }

      console.log('学生信息加载成功，studentId:', studentId.value)
    } else {
      console.error('获取学生信息失败:', response.msg)
      uni.showToast({
        title: '获取学生信息失败',
        icon: 'none'
      })
    }
  } catch (error) {
    console.error('加载学生信息失败:', error)
    uni.showToast({
      title: '加载学生信息失败，请重新登录',
      icon: 'none'
    })
  }
}

const loadDormTree = async () => {
  try {
    const response = await dormTreeSelect()
    if (response.code === 200) {
      dormTreeData.value = response.data || []
      currentTreeData.value = dormTreeData.value
      breadcrumbs.value = []
    }
  } catch (error) {
    console.error('加载宿舍树失败:', error)
    uni.showToast({
      title: '加载宿舍信息失败',
      icon: 'none'
    })
  }
}

const showDormPicker = () => {
  // 重置到根节点
  currentTreeData.value = dormTreeData.value
  breadcrumbs.value = []
  dormPopup.value.open()
}

const closeDormPicker = () => {
  dormPopup.value.close()
}

const selectDorm = (item) => {
  // 只能选择叶子节点（房间）
  if (!item.children || item.children.length === 0) {
    form.dormId = item.id
    // 构建完整路径显示
    const fullPath = [...breadcrumbs.value.map(b => b.label), item.label].join(' > ')
    selectedDormText.value = fullPath
    closeDormPicker()
  } else {
    // 如果是父节点，进入子级
    breadcrumbs.value.push({ id: item.id, label: item.label })
    currentTreeData.value = item.children
  }
}

const navigateToBreadcrumb = (index) => {
  // 导航到面包屑指定层级
  if (index === -1) {
    // 返回根节点
    currentTreeData.value = dormTreeData.value
    breadcrumbs.value = []
  } else {
    // 返回指定层级
    breadcrumbs.value = breadcrumbs.value.slice(0, index + 1)
    let targetData = dormTreeData.value

    for (let i = 0; i <= index; i++) {
      const crumb = breadcrumbs.value[i]
      const found = targetData.find(item => item.id === crumb.id)
      if (found && found.children) {
        targetData = found.children
      }
    }

    currentTreeData.value = targetData
  }
}

// 报修项目选择相关方法
const showSpecialtyPicker = () => {
  specialtyPopup.value.open()
}

const closeSpecialtyPicker = () => {
  specialtyPopup.value.close()
}

const selectSpecialty = (item) => {
  form.specialty = item.value
  closeSpecialtyPicker()
}

const getSelectedSpecialtyText = () => {
  if (!form.specialty) return ''
  const selected = specialtyOptions.value.find(item => item.value === form.specialty)
  return selected ? selected.text : ''
}

const onImageSelect = (e) => {
  console.log('选择图片事件:', e)

  // 手动更新 imageList - 这是关键修复！
  if (e.tempFiles && e.tempFiles.length > 0) {
    // 验证图片格式和大小
    const validFiles = []
    e.tempFiles.forEach(file => {
      const fileSize = file.size / 1024 / 1024 // 转换为MB
      if (fileSize > 5) {
        uni.showToast({
          title: '图片大小不能超过5MB',
          icon: 'none'
        })
        return
      }
      validFiles.push(file)
    })

    // 手动更新 imageList
    imageList.value = [...imageList.value, ...validFiles]

    console.log('已选择图片数量:', validFiles.length)
    console.log('tempFiles 详情:', validFiles)
    console.log('更新后的 imageList:', imageList.value)
  }
}

const onImageDelete = (e) => {
  console.log('删除图片事件:', e)

  // 手动更新 imageList
  if (e.index !== undefined) {
    imageList.value.splice(e.index, 1)
  }

  console.log('删除后的 imageList:', imageList.value)
}

// 上传单个图片
const uploadSingleImage = async (filePath) => {
  try {
    const result = await upload({
      url: '/common/upload',
      filePath: filePath,
      name: 'file'
    })
    return result.fileName
  } catch (error) {
    console.error('图片上传失败:', error)
    throw error
  }
}

const submitForm = async () => {
  if (submitting.value) return

  try {
    // 表单验证
    await formRef.value.validate()

    submitting.value = true

    // 处理图片上传
    console.log('提交表单时的 imageList:', imageList.value)
    console.log('imageList 长度:', imageList.value ? imageList.value.length : 0)

    let uploadedImageUrls = []
    if (imageList.value && imageList.value.length > 0) {
      uni.showLoading({
        title: '上传图片中...'
      })

      try {
        console.log('开始上传图片，imageList:', imageList.value)

        // 上传所有图片
        const uploadPromises = imageList.value.map(async (item) => {
          console.log('处理图片项:', item)

          // 如果已经有url或fileID，直接使用
          if (item.url && !item.url.startsWith('blob:')) {
            console.log('使用已有URL:', item.url)
            return item.url
          }
          if (item.fileID) {
            console.log('使用fileID:', item.fileID)
            return item.fileID
          }

          // 否则上传本地文件 - 修复：使用正确的路径字段
          const filePath = item.path || item.url
          if (filePath) {
            console.log('上传本地文件:', filePath)
            return await uploadSingleImage(filePath)
          }

          console.warn('图片项没有有效路径:', item)
          return null
        })

        uploadedImageUrls = await Promise.all(uploadPromises)
        uploadedImageUrls = uploadedImageUrls.filter(url => url) // 过滤空值

        console.log('图片上传完成，URLs:', uploadedImageUrls)

        uni.hideLoading()
      } catch (uploadError) {
        uni.hideLoading()
        console.error('图片上传失败:', uploadError)
        uni.showToast({
          title: '图片上传失败，请重试',
          icon: 'none'
        })
        submitting.value = false
        return
      }
    }

    // 将上传后的图片URL拼接成字符串
    const imagesStr = uploadedImageUrls.length > 0 ? uploadedImageUrls.join(',') : ''
    console.log('最终图片字符串:', imagesStr)

    // 检查studentId是否存在
    if (!studentId.value) {
      uni.showToast({
        title: '获取学生信息失败，请重新登录',
        icon: 'none'
      })
      submitting.value = false
      return
    }

    const submitData = {
      studentId: studentId.value, // 添加学生ID
      dormId: form.dormId,
      specialty: form.specialty, // 现在是单个值，直接使用
      description: form.description,
      reporterName: form.reporterName,
      contactPhone: form.contactPhone,
      images: imagesStr
      // 注意：不发送requestNo字段，由后端自动生成
    }

    console.log('提交数据:', submitData)

    const response = await addRequest(submitData)
    if (response.code === 200) {
      uni.showToast({
        title: '提交成功',
        icon: 'success'
      })

      // 清空表单
      resetForm()

      // 延迟返回列表页
      setTimeout(() => {
        uni.navigateBack()
      }, 1500)
    } else {
      uni.showToast({
        title: response.msg || '提交失败',
        icon: 'none'
      })
    }
  } catch (error) {
    if (error.errorMessage) {
      // 表单验证错误
      uni.showToast({
        title: error.errorMessage,
        icon: 'none'
      })
    } else {
      uni.showToast({
        title: '提交失败，请检查网络连接',
        icon: 'none'
      })
    }
  } finally {
    submitting.value = false
  }
}

const resetForm = () => {
  Object.assign(form, {
    dormId: null,
    specialty: '', // 改为空字符串
    description: '',
    reporterName: '',
    contactPhone: '',
    images: ''
  })
  selectedDormText.value = ''
  imageList.value = []
  formRef.value?.clearValidate()
}

const goBack = () => {
  uni.navigateBack()
}

// 生命周期钩子
onMounted(() => {
  initPage()
})
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background: linear-gradient(180deg, #f8f9fa 0%, #ffffff 100%);
}

.status-bar {
  background: transparent;
}

.header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20rpx 30rpx 40rpx;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.back-btn {
  width: 80rpx;
  height: 80rpx;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  backdrop-filter: blur(10rpx);
}

.back-btn .iconfont {
  color: white;
  font-size: 32rpx;
}

.header-title {
  flex: 1;
  text-align: center;
}

.title-text {
  color: white;
  font-size: 36rpx;
  font-weight: bold;
}

.header-placeholder {
  width: 80rpx;
}

.main-content {
  flex: 1;
  padding: 30rpx;
}

.form-container {
  background: white;
  border-radius: 20rpx;
  padding: 40rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}

.tree-select-wrapper,
.specialty-select-wrapper {
  width: 100%;
}

.tree-select-input,
.specialty-select-input {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx;
  border: 2rpx solid #e0e0e0;
  border-radius: 10rpx;
  background: #f8f9fa;
  min-height: 80rpx;
  transition: all 0.3s ease;
}

.tree-select-input.has-value,
.specialty-select-input.has-value {
  border-color: #667eea;
  background: white;
}

.select-text {
  flex: 1;
  font-size: 28rpx;
  color: #333;
}

.tree-select-input:not(.has-value) .select-text,
.specialty-select-input:not(.has-value) .select-text {
  color: #999;
}

.select-arrow {
  font-size: 32rpx;
  color: #999;
  transform: rotate(90deg);
}

.upload-section {
  width: 100%;
}

.upload-tip {
  margin-top: 20rpx;
}

.tip-text {
  font-size: 24rpx;
  color: #999;
}

.submit-section {
  margin-top: 60rpx;
}

.submit-btn {
  width: 100%;
  height: 100rpx;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.submit-btn.loading {
  opacity: 0.7;
}

.submit-btn:active {
  transform: scale(0.98);
}

.submit-text {
  color: white;
  font-size: 32rpx;
  font-weight: bold;
}

/* 弹窗样式 */
.popup-content {
  background: white;
  border-radius: 20rpx 20rpx 0 0;
  max-height: 80vh;
}

.popup-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 30rpx 40rpx;
  border-bottom: 2rpx solid #f0f0f0;
}

.popup-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.popup-close {
  width: 60rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-icon {
  font-size: 40rpx;
  color: #999;
}

.popup-body {
  padding: 20rpx 0;
}

.breadcrumb {
  display: flex;
  align-items: center;
  padding: 20rpx 40rpx;
  background: #f8f9fa;
  border-bottom: 1rpx solid #e0e0e0;
  overflow-x: auto;
  white-space: nowrap;
}

.breadcrumb-item {
  display: flex;
  align-items: center;
  flex-shrink: 0;
}

.breadcrumb-text {
  font-size: 28rpx;
  color: #667eea;
  cursor: pointer;
}

.breadcrumb-separator {
  margin: 0 16rpx;
  font-size: 24rpx;
  color: #999;
}

.tree-scroll {
  max-height: 50vh;
}

.tree-container {
  padding: 0 40rpx;
}

.tree-item {
  padding: 30rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.tree-item:last-child {
  border-bottom: none;
}

.tree-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.tree-label {
  font-size: 30rpx;
  color: #333;
  flex: 1;
}

.tree-arrow {
  font-size: 32rpx;
  color: #999;
  transform: rotate(90deg);
}

.tree-leaf {
  font-size: 24rpx;
  color: #667eea;
}

/* 报修项目选择器样式 */
.specialty-scroll {
  max-height: 50vh;
}

.specialty-container {
  padding: 0 40rpx;
}

.specialty-item {
  padding: 30rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
  transition: all 0.3s ease;
}

.specialty-item:last-child {
  border-bottom: none;
}

.specialty-item.selected {
  background: rgba(102, 126, 234, 0.1);
  border-radius: 10rpx;
  margin: 0 -20rpx;
  padding: 30rpx 20rpx;
}

.specialty-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.specialty-label {
  font-size: 30rpx;
  color: #333;
  flex: 1;
}

.specialty-item.selected .specialty-label {
  color: #667eea;
  font-weight: bold;
}

.specialty-check {
  font-size: 32rpx;
  color: #667eea;
  font-weight: bold;
}

/* 图标字体样式 */
.iconfont {
  font-family: 'iconfont';
}

.icon-back::before {
  content: '‹';
}
</style>
