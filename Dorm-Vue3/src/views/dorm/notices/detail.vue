<template>
  <div class="app-container">
    <!-- 页面加载状态 -->
    <div v-if="pageLoading" class="loading-container">
      <el-skeleton :rows="8" animated />
    </div>

    <!-- 表单内容 -->
    <div v-else>
      <el-card class="form-card" shadow="hover">
        <template #header>
          <div class="card-header">
            <h3 class="form-title">
              <el-icon>
                <Document />
              </el-icon>
              {{ isEdit ? '编辑公告' : '新建公告' }}
            </h3>
            <div class="form-actions">
              <el-button @click="goBack" icon="ArrowLeft">返回列表</el-button>
              <el-button type="primary" @click="submitForm" :loading="submitLoading" icon="Check">
                {{ isEdit ? '保存修改' : '创建公告' }}
              </el-button>
            </div>
          </div>
        </template>

        <el-form ref="noticesRef" :model="form" :rules="dynamicRules" label-width="100px" class="notice-form">
          <el-row :gutter="24" class="form-row">
            <el-col :span="24">
              <el-form-item label="公告标题" prop="noticeTitle">
                <el-input v-model="form.noticeTitle" placeholder="请输入公告标题" maxlength="100" show-word-limit
                  class="form-input" />
              </el-form-item>
            </el-col>

            <el-col :span="24">
              <el-form-item label="封面图片" prop="coverImage">
                <el-upload
                  class="cover-image-uploader"
                  :action="uploadUrl"
                  :headers="headers"
                  :show-file-list="false"
                  :on-success="handleCoverSuccess"
                  :before-upload="beforeCoverUpload"
                  :on-error="handleCoverError"
                >
                  <div v-if="form.coverImage" class="cover-image-preview">
                    <img :src="form.coverImage" class="cover-image" />
                    <div class="cover-image-actions">
                      <el-button type="danger" icon="Delete" circle @click.stop="removeCoverImage"></el-button>
                    </div>
                  </div>
                  <div v-else class="upload-placeholder">
                    <el-icon class="upload-icon"><Plus /></el-icon>
                    <div class="upload-text">点击上传封面图片</div>
                  </div>
                </el-upload>
                <div class="cover-image-tip">
                  <p>建议尺寸: 800x450px，支持JPG、PNG、SVG格式，不超过2MB</p>
                </div>
              </el-form-item>
            </el-col>

            <el-col :span="12">
              <el-form-item label="公告类型" prop="noticeType">
                <el-select v-model="form.noticeType" placeholder="请选择公告类型" class="form-select">
                  <el-option v-for="dict in dorm_notice_type" :key="dict.value" :label="dict.label"
                    :value="dict.value"></el-option>
                </el-select>
              </el-form-item>
            </el-col>

            <el-col :span="12">
              <el-form-item label="轮播图显示" prop="isCarousel">
                <el-radio-group v-model="form.isCarousel" class="carousel-radio-group">
                  <el-radio v-for="dict in is_carousel" :key="dict.value" :label="dict.value"
                    class="carousel-radio">
                    {{ dict.label }}
                  </el-radio>
                </el-radio-group>
              </el-form-item>
            </el-col>

            <el-col :span="12" v-if="isEdit">
              <el-form-item label="状态" prop="status">
                <el-radio-group v-model="form.status" class="status-radio-group">
                  <el-radio v-for="dict in sys_notice_status" :key="dict.value" :label="dict.value"
                    class="status-radio">
                    {{ dict.label }}
                  </el-radio>
                </el-radio-group>
              </el-form-item>
            </el-col>
          </el-row>

          <!-- 单独的编辑器区域，不使用栅格系统 -->
          <el-col :span="24">
            <div class="editor-section">
              <el-form-item label="公告内容" prop="noticeContent" class="editor-form-item">
                <div class="editor-container">
                  <editor v-model="form.noticeContent" :min-height="600" class="content-editor" />
                </div>
              </el-form-item>
            </div>
          </el-col>
        </el-form>
      </el-card>
    </div>
  </div>
</template>

<script setup name="Notices">
import { getNotices, addNotices, updateNotices } from "@/api/dorm/notices"
import { Document, ArrowLeft, Check, Plus } from '@element-plus/icons-vue'
import { getToken } from "@/utils/auth"

const { proxy } = getCurrentInstance()
const route = useRoute()
const router = useRouter()
const { sys_notice_status, dorm_notice_type, is_carousel } = proxy.useDict('sys_notice_status', 'dorm_notice_type', 'is_carousel')

// 页面状态
const pageLoading = ref(false)
const submitLoading = ref(false)
const isEdit = ref(false)
const uploadUrl = ref(import.meta.env.VITE_APP_BASE_API + "/common/upload")
const headers = ref({ Authorization: "Bearer " + getToken() })

// 表单数据
const form = ref({
  noticeId: null,
  noticeTitle: '',
  coverImage: '',
  noticeType: '',
  noticeContent: '',
  status: '0', // 默认启用状态
  isCarousel: '0', // 默认不在轮播图显示
  createBy: null,
  createTime: null,
  updateBy: null,
  updateTime: null,
  remark: null
})

// 验证规则
const rules = {
  noticeTitle: [
    { required: true, message: "公告标题不能为空", trigger: "blur" },
    { min: 2, max: 100, message: "标题长度在 2 到 100 个字符", trigger: "blur" }
  ],
  noticeType: [
    { required: true, message: "公告类型不能为空", trigger: "change" }
  ],
  noticeContent: [
    { required: true, message: "公告内容不能为空", trigger: "blur" }
  ]
}

// 动态验证规则 - 状态字段只在修改时必填
const dynamicRules = computed(() => {
  const baseRules = { ...rules }

  // 如果是修改操作（有noticeId），则添加状态验证规则
  if (form.value.noticeId != null) {
    baseRules.status = [
      { required: true, message: "状态不能为空", trigger: "change" }
    ]
  }

  return baseRules
})

// 页面初始化
onMounted(() => {
  initPage()
})

// 初始化页面数据
function initPage() {
  console.log('页面初始化，当前路由:', route)
  console.log('路由参数:', route.params)

  // 从路由参数中获取noticeId
  // 支持多种路由格式：
  // /dorm/notices-detail/index/1 -> route.params.id = 1
  // /dorm/notices/detail/1 -> route.params.id = 1
  // /dorm/notices/:id -> route.params.id = 1
  const noticeId = route.params.id || route.params.noticeId || route.params.noticesId

  console.log('获取到的noticeId:', noticeId)

  if (noticeId && noticeId !== 'add' && noticeId !== 'new') {
    // 编辑模式 - 获取公告详情进行回显
    isEdit.value = true
    getInfo(noticeId)
  } else {
    // 新增模式 - 设置默认值
    isEdit.value = false
    form.value.status = '0' // 默认启用状态
    form.value.isCarousel = '0' // 默认不在轮播图显示
    console.log('新增模式，设置默认值')
  }
}

// 获取公告详情（页面回显核心功能）
function getInfo(noticeId) {
  console.log('开始获取公告详情，ID:', noticeId)
  pageLoading.value = true

  getNotices(noticeId).then(response => {
    console.log('获取公告详情成功:', response)

    if (response && response.data) {
      // 数据回显到表单
      form.value = {
        noticeId: response.data.noticeId,
        noticeTitle: response.data.noticeTitle || '',
        coverImage: response.data.coverImage || '',
        noticeType: response.data.noticeType || '',
        noticeContent: response.data.noticeContent || '',
        status: response.data.status || '0',
        isCarousel: response.data.isCarousel || '0',
        createBy: response.data.createBy,
        createTime: response.data.createTime,
        updateBy: response.data.updateBy,
        updateTime: response.data.updateTime,
        remark: response.data.remark
      }

      console.log('表单数据回显完成:', form.value)
      proxy.$modal.msgSuccess("数据加载成功")
    } else {
      throw new Error('返回数据格式错误')
    }

    pageLoading.value = false

  }).catch(error => {
    console.error('获取公告详情失败:', error)
    pageLoading.value = false
    proxy.$modal.msgError(`获取公告详情失败: ${error.message || '请检查ID是否正确'}`)

    // 获取失败时延迟返回列表页
    setTimeout(() => {
      goBack()
    }, 2000)
  })
}

// 返回列表页
function goBack() {
  router.push('/dorm/notices')
}

// 表单重置
function reset() {
  form.value = {
    noticeId: null,
    noticeTitle: '',
    coverImage: '',
    noticeType: '',
    noticeContent: '',
    status: '0',
    isCarousel: '0',
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null
  }
  proxy.resetForm("noticesRef")
}

// 封面图片上传前的校验
function beforeCoverUpload(file) {
  const isJPG = file.type === 'image/jpeg'
  const isPNG = file.type === 'image/png'
  const isSVG = file.type === 'image/svg+xml'
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isJPG && !isPNG && !isSVG) {
    proxy.$modal.msgError('封面图片只能是 JPG/PNG/SVG 格式!')
    return false
  }
  if (!isLt2M) {
    proxy.$modal.msgError('封面图片大小不能超过 2MB!')
    return false
  }
  return true
}

// 封面图片上传成功处理
function handleCoverSuccess(res, file) {
  if (res.code === 200) {
    form.value.coverImage = res.url
  } else {
    proxy.$modal.msgError('封面图片上传失败，请重试!')
  }
}

// 封面图片上传失败处理
function handleCoverError() {
  proxy.$modal.msgError('封面图片上传失败，请重试!')
}

// 删除封面图片
function removeCoverImage() {
  form.value.coverImage = ''
}

/** 提交表单 */
function submitForm() {
  proxy.$refs["noticesRef"].validate(valid => {
    if (valid) {
      submitLoading.value = true

      const submitData = { ...form.value }
      console.log('提交数据:', submitData)

      if (isEdit.value && form.value.noticeId) {
        // 修改操作
        updateNotices(submitData).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          goBack()
        }).catch(error => {
          console.error('修改失败:', error)
          proxy.$modal.msgError("修改失败")
        }).finally(() => {
          submitLoading.value = false
        })
      } else {
        // 新增操作
        addNotices(submitData).then(() => {
          proxy.$modal.msgSuccess("创建成功")
          goBack()
        }).catch(error => {
          console.error('创建失败:', error)
          proxy.$modal.msgError("创建失败")
        }).finally(() => {
          submitLoading.value = false
        })
      }
    }
  })
}
</script>

<style lang="scss" scoped>
// 全局富文本编辑器样式重置 - 强制占满宽度
:global(.ql-editor) {
  width: 100% !important;
  max-width: 100% !important;
  min-width: 100% !important;
  box-sizing: border-box !important;
  margin: 0 !important;
  padding: 24px !important;
}

:global(.ql-container) {
  width: 100% !important;
  max-width: 100% !important;
  min-width: 100% !important;
  box-sizing: border-box !important;
  margin: 0 !important;
  padding: 0 !important;
}

:global(.ql-toolbar) {
  width: 100% !important;
  max-width: 100% !important;
  min-width: 100% !important;
  box-sizing: border-box !important;
  margin: 0 !important;
}

:global(.ql-snow) {
  width: 100% !important;
  max-width: 100% !important;
  min-width: 100% !important;
}

// 针对wangEditor的样式
:global(.w-e-text-editor) {
  width: 100% !important;
  max-width: 100% !important;
  min-width: 100% !important;
}

:global(.w-e-toolbar) {
  width: 100% !important;
  max-width: 100% !important;
  min-width: 100% !important;
}

:global(.w-e-text-container) {
  width: 100% !important;
  max-width: 100% !important;
  min-width: 100% !important;
}

:global(.w-e-text) {
  width: 100% !important;
  max-width: 100% !important;
  min-width: 100% !important;
}

.app-container {
  width: 100%;
  max-width: 100%;
  padding: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  min-height: calc(100vh - 84px);
  box-sizing: border-box;
}

/* 加载状态 */
.loading-container {
  background: white;
  border-radius: 16px;
  padding: 40px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

/* 表单卡片 */
.form-card {
  width: 100%;
  max-width: 100%;
  border-radius: 16px;
  border: none;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);

  :deep(.el-card__header) {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 16px 16px 0 0;
    padding: 20px 24px;

    .card-header {
      display: flex;
      align-items: center;
      justify-content: space-between;

      .form-title {
        display: flex;
        align-items: center;
        color: white;
        margin: 0;
        font-size: 18px;
        font-weight: 600;

        .el-icon {
          margin-right: 8px;
          font-size: 20px;
        }
      }

      .form-actions {
        display: flex;
        gap: 12px;

        .el-button {
          border-radius: 8px;
          font-weight: 500;

          &:not(.el-button--primary) {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;

            &:hover {
              background: rgba(255, 255, 255, 0.3);
            }
          }

          &.el-button--primary {
            background: rgba(255, 255, 255, 0.9);
            border: none;
            color: #667eea;

            &:hover {
              background: white;
              transform: translateY(-2px);
            }
          }
        }
      }
    }
  }

  :deep(.el-card__body) {
    width: 100%;
    max-width: 100%;
    padding: 32px;
    box-sizing: border-box;
  }
}

/* 表单样式 */
.notice-form {
  width: 100%;
  max-width: 100%;

  .form-row {
    width: 100%;
    margin-bottom: 24px;
  }

  .editor-section {
    width: 100%;
    max-width: 1200px; // 限制最大宽度为1000px
    margin: 24px auto 0 24px; // 居中显示
    padding: 0;
  }

  .el-form-item {
    width: 100%;
    margin-bottom: 24px;

    :deep(.el-form-item__label) {
      font-weight: 600;
      color: #2c3e50;
      font-size: 14px;
    }

    :deep(.el-form-item__content) {
      width: 100% !important;
      max-width: 100% !important;
    }

    // 专门针对编辑器表单项的样式
    &.editor-form-item {
      width: 100% !important;
      max-width: 100% !important;
      margin: 0 !important;

      :deep(.el-form-item__label) {
        width: auto !important;
        margin-bottom: 8px !important;
      }

      :deep(.el-form-item__content) {
        width: 100% !important;
        max-width: 100% !important;
        min-width: 100% !important;
        margin-left: 0 !important;
        margin-right: 0 !important;
        padding: 0 !important;
        flex: 1 !important;
      }

      .editor-container {
        width: 100% !important;
        max-width: 100% !important;
        min-width: 100% !important;
        margin: 0 !important;
        padding: 0 !important;
        display: block !important;
        position: relative;
      }
    }

    .form-input,
    .form-select {
      width: 100%;

      :deep(.el-input__wrapper) {
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        transition: all 0.3s ease;

        &:hover {
          box-shadow: 0 4px 12px rgba(102, 126, 234, 0.15);
        }

        &.is-focus {
          box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
        }
      }

      :deep(.el-select__wrapper) {
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        transition: all 0.3s ease;

        &:hover {
          box-shadow: 0 4px 12px rgba(102, 126, 234, 0.15);
        }
      }
    }

    /* 封面图片上传组件样式 */
    .cover-image-uploader {
      width: 100%;
      max-width: 500px;
      cursor: pointer;
      
      .cover-image-preview {
        position: relative;
        width: 100%;
        height: 280px;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        
        .cover-image {
          width: 100%;
          height: 100%;
          object-fit: cover;
          transition: transform 0.3s;
        }
        
        .cover-image-actions {
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background: rgba(0, 0, 0, 0.5);
          display: flex;
          justify-content: center;
          align-items: center;
          opacity: 0;
          transition: opacity 0.3s;
        }
        
        &:hover {
          .cover-image {
            transform: scale(1.05);
          }
          
          .cover-image-actions {
            opacity: 1;
          }
        }
      }
      
      .upload-placeholder {
        width: 100%;
        height: 280px;
        border: 2px dashed #d9d9d9;
        border-radius: 8px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        background: #fafafa;
        transition: all 0.3s;
        
        .upload-icon {
          font-size: 48px;
          color: #8c939d;
          margin-bottom: 16px;
        }
        
        .upload-text {
          font-size: 16px;
          color: #8c939d;
        }
        
        &:hover {
          border-color: #409EFF;
          background: #f0f9ff;
          
          .upload-icon, .upload-text {
            color: #409EFF;
          }
        }
      }
    }
    
    .cover-image-tip {
      margin-top: 8px;
      color: #909399;
      font-size: 12px;
    }

    .status-radio-group {
      display: flex;
      gap: 16px;

      .status-radio {
        padding: 12px 20px;
        border: 2px solid #e4e7ed;
        border-radius: 12px;
        background: white;
        transition: all 0.3s ease;

        &:hover {
          border-color: #667eea;
          background: #f8f9ff;
        }

        :deep(.el-radio__input.is-checked) {
          +.el-radio__label {
            color: #667eea;
            font-weight: 600;
          }
        }

        :deep(.el-radio__input.is-checked) {
          .el-radio__inner {
            background-color: #667eea;
            border-color: #667eea;
          }
        }
      }
    }

    .content-editor {
      width: 100% !important;
      max-width: 100% !important;
      min-width: 100% !important;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
      margin: 8px 0 0 0 !important;
      padding: 0 !important;
      display: block !important;

      // 强制设置编辑器组件的根元素
      :deep(.w-e-text-editor) {
        width: 100% !important;
        max-width: 100% !important;
      }

      :deep(.ql-snow) {
        width: 100% !important;
        max-width: 100% !important;
        border: 1px solid #e4e7ed;
      }

      :deep(.ql-toolbar) {
        width: 100% !important;
        max-width: 100% !important;
        background: #f8f9fa;
        border-bottom: 1px solid #e4e7ed;
        padding: 12px 16px;
        box-sizing: border-box !important;
        margin: 0 !important;
      }

      :deep(.ql-container) {
        width: 100% !important;
        max-width: 100% !important;
        min-width: 100% !important;
        border: none;
        font-size: 14px;
        line-height: 1.6;
        min-height: 600px;
        box-sizing: border-box !important;
        margin: 0 !important;
        padding: 0 !important;
      }

      :deep(.ql-editor) {
        width: 100% !important;
        max-width: 100% !important;
        min-width: 100% !important;
        padding: 24px !important;
        min-height: 600px;
        font-size: 15px;
        line-height: 1.8;
        box-sizing: border-box !important;
        margin: 0 !important;
        border: none !important;

        &.ql-blank::before {
          font-style: normal;
          color: #c0c4cc;
          font-size: 14px;
        }
      }

      // 工具栏按钮样式优化
      :deep(.ql-toolbar) {
        .ql-formats {
          margin-right: 15px;
        }

        .ql-picker-label {
          border-radius: 4px;
          padding: 4px 8px;

          &:hover {
            background: #e1f3ff;
          }
        }

        button {
          border-radius: 4px;
          margin: 0 2px;

          &:hover {
            background: #e1f3ff;
          }

          &.ql-active {
            background: #409eff;
            color: white;
          }
        }
      }
    }
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .app-container {
    padding: 12px;
  }

  .form-card {
    :deep(.el-card__header) {
      .card-header {
        flex-direction: column;
        gap: 16px;

        .form-actions {
          width: 100%;
          justify-content: center;
        }
      }
    }

    :deep(.el-card__body) {
      padding: 20px;
    }
  }

  .notice-form {
    .status-radio-group {
      flex-direction: column;
      gap: 8px;

      .status-radio {
        width: 100%;
        text-align: center;
      }
    }

    .content-editor {
      :deep(.ql-container) {
        min-height: 400px;
      }

      :deep(.ql-editor) {
        min-height: 400px;
        padding: 16px;
        font-size: 14px;
      }

      :deep(.ql-toolbar) {
        padding: 8px 12px;
      }
    }
  }
}

/* 动画效果 */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
