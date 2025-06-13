<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="公告标题" prop="noticeTitle">
        <el-input
          v-model="queryParams.noticeTitle"
          placeholder="请输入公告标题"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="公告类型" prop="noticeType" style="width: 250px;">
        <el-select v-model="queryParams.noticeType" placeholder="请选择公告类型" clearable>
          <el-option
            v-for="dict in dorm_notice_type"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status" style="width: 250px;">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option
            v-for="dict in sys_notice_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="Plus"
          @click="handleAdd"
          v-hasPermi="['dorm:notices:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['dorm:notices:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['dorm:notices:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['dorm:notices:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="noticesList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="序号" align="center" prop="noticeId" />
      <el-table-column label="封面图片" align="center" width="120">
        <template #default="scope">
          <el-image
            v-if="scope.row.coverImage"
            :src="getImageUrl(scope.row.coverImage)"
            fit="cover"
            class="notice-cover-image"
            :preview-src-list="previewImages"
            :initial-index="getImageIndex(scope.row.coverImage)"
            preview-teleported
            @click="handlePreviewClick(scope.row.coverImage)"
            loading="lazy"
          >
            <template #error>
              <div class="image-error">
                <el-icon class="image-error-icon"><Picture /></el-icon>
                <div class="image-error-text">加载失败</div>
              </div>
            </template>
          </el-image>
          <el-image
            v-else
            :src="defaultImage"
            fit="cover"
            class="notice-cover-image no-preview"
          >
            <template #error>
              <div class="image-error">
                <el-icon class="image-error-icon"><Picture /></el-icon>
                <div class="image-error-text">暂无图片</div>
              </div>
            </template>
          </el-image>
        </template>
      </el-table-column>
      <el-table-column label="公告标题" align="center" prop="noticeTitle" min-width="200" show-overflow-tooltip>
            <template #default="scope">
               <router-link :to="'/dorm/notices-detail/index/' + scope.row.noticeId" class="link-type">
                  <span>{{ scope.row.noticeTitle }}</span>
               </router-link>
            </template>
      </el-table-column>
      <el-table-column label="公告类型" align="center" prop="noticeType">
        <template #default="scope">
          <dict-tag :options="dorm_notice_type" :value="scope.row.noticeType"/>
        </template>
      </el-table-column>
      <el-table-column label="公告内容" align="center" prop="noticeContent" />
      <el-table-column label="状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="sys_notice_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding"  width="200">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['dorm:notices:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['dorm:notices:remove']">删除</el-button>
          <el-button link type="primary" icon="Delete" @click="handleView(scope.row)" v-hasPermi="['dorm:notices:list']">查看</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <pagination
      v-show="total>0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改宿舍公告对话框 -->
    <el-dialog :title="title" v-model="open" width="800px" append-to-body>
      <el-form ref="noticesRef" :model="form" :rules="dynamicRules" label-width="80px">
        <el-form-item label="公告标题" prop="noticeTitle">
          <el-input v-model="form.noticeTitle" placeholder="请输入公告标题" />
        </el-form-item>
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
            <img v-if="form.coverImage" :src="form.coverImage" class="cover-image" />
            <el-icon v-else class="cover-image-uploader-icon"><Plus /></el-icon>
          </el-upload>
          <div class="cover-image-tip" v-if="form.coverImage">
            <el-button type="danger" icon="Delete" size="small" @click="removeCoverImage">删除封面</el-button>
          </div>
        </el-form-item>
        <el-form-item label="公告类型" prop="noticeType">
          <el-select v-model="form.noticeType" placeholder="请选择公告类型">
            <el-option
              v-for="dict in dorm_notice_type"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="公告内容">
          <editor v-model="form.noticeContent" :min-height="300"/>
        </el-form-item>
        <el-form-item label="状态" prop="status" v-if="form.noticeId != null">
          <el-radio-group v-model="form.status">
            <el-radio
              v-for="dict in sys_notice_status"
              :key="dict.value"
              :label="dict.value"
            >{{dict.label}}</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Notices">
import { listNotices, getNotices, delNotices, addNotices, updateNotices } from "@/api/dorm/notices"
import { useRouter } from 'vue-router'
import { Plus, Picture } from '@element-plus/icons-vue'
import { getToken } from "@/utils/auth"
import { isExternal } from "@/utils/validate"

const { proxy } = getCurrentInstance()
const { sys_notice_status, dorm_notice_type } = proxy.useDict('sys_notice_status', 'dorm_notice_type')

const noticesList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const router = useRouter()
const uploadUrl = ref(import.meta.env.VITE_APP_BASE_API + "/common/upload")
const headers = ref({ Authorization: "Bearer " + getToken() })
const previewImages = ref([]) // 用于存储所有可预览的图片列表
const defaultImage = ref(new URL('@/assets/images/profile.jpg', import.meta.url).href) // 默认图片
const imageViewerVisible = ref(false) // 控制图片预览器的显示状态

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    noticeTitle: null,
    noticeType: null,
    noticeContent: null,
    status: null,
  },
  rules: {
    noticeTitle: [
      { required: true, message: "公告标题不能为空", trigger: "blur" }
    ],
    noticeType: [
      { required: true, message: "公告类型不能为空", trigger: "change" }
    ],
    noticeContent: [
      { required: true, message: "公告内容不能为空", trigger: "blur" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

// 动态验证规则 - 状态字段只在修改时必填
const dynamicRules = computed(() => {
  const baseRules = { ...rules.value }

  // 如果是修改操作（有noticeId），则添加状态验证规则
  if (form.value.noticeId != null) {
    baseRules.status = [
      { required: true, message: "状态不能为空", trigger: "change" }
    ]
  }

  return baseRules
})

/** 查询宿舍公告列表 */
function getList() {
  loading.value = true
  listNotices(queryParams.value).then(response => {
    noticesList.value = response.rows
    total.value = response.total
    loading.value = false

    // 更新预览图片列表
    updatePreviewImages()
  }).catch(error => {
    loading.value = false
    console.error('获取公告列表失败:', error)
    proxy.$modal.msgError('获取公告列表失败，请重试')
  })
}

// 处理图片URL，确保正确的路径
function getImageUrl(imageUrl) {
  if (!imageUrl) return defaultImage.value
  if (isExternal(imageUrl)) {
    return imageUrl
  }
  return import.meta.env.VITE_APP_BASE_API + imageUrl
}

// 更新预览图片列表
function updatePreviewImages() {
  // 收集所有有效的封面图片URL，并处理路径
  previewImages.value = noticesList.value
    .filter(item => item.coverImage)
    .map(item => getImageUrl(item.coverImage))

  // 预加载图片以提升用户体验
  preloadImages()
}

// 预加载图片
function preloadImages() {
  previewImages.value.forEach(imageUrl => {
    const img = new Image()
    img.src = imageUrl
    img.onerror = () => {
      console.warn('图片预加载失败:', imageUrl)
    }
  })
}

// 获取图片在预览列表中的索引
function getImageIndex(imageUrl) {
  const processedUrl = getImageUrl(imageUrl)
  return previewImages.value.findIndex(url => url === processedUrl)
}

// 处理预览点击事件
function handlePreviewClick(imageUrl) {
  // 确保预览列表是最新的
  updatePreviewImages()

  // 设置预览器状态
  imageViewerVisible.value = true

  // 延迟应用初始缩放，确保预览器已经渲染
  nextTick(() => {
    applyInitialZoom()
  })

  // 记录预览行为（可选）
  console.log('预览图片:', getImageUrl(imageUrl))
}

// 应用初始缩放比例
function applyInitialZoom() {
  const viewer = document.querySelector('.el-image-viewer__wrapper')
  if (viewer) {
    const canvas = viewer.querySelector('.el-image-viewer__canvas')
    const img = canvas?.querySelector('img')

    if (img && canvas) {
      // 添加初始缩放标识类
      viewer.classList.add('initial-zoom')

      // 等待图片加载完成
      if (img.complete && img.naturalWidth > 0) {
        setInitialScale(img, canvas)
      } else {
        img.onload = () => {
          if (img.naturalWidth > 0) {
            setInitialScale(img, canvas)
          }
        }

        // 设置超时处理，防止图片加载失败
        setTimeout(() => {
          if (img.naturalWidth > 0) {
            setInitialScale(img, canvas)
          }
        }, 500)
      }
    }
  }
}

// 设置初始缩放比例
function setInitialScale(img, canvas) {
  const canvasRect = canvas.getBoundingClientRect()
  const imgNaturalWidth = img.naturalWidth
  const imgNaturalHeight = img.naturalHeight

  // 计算适合窗口的缩放比例（留出边距）
  const maxWidth = canvasRect.width * 0.85 // 85%的窗口宽度
  const maxHeight = canvasRect.height * 0.85 // 85%的窗口高度

  const scaleX = maxWidth / imgNaturalWidth
  const scaleY = maxHeight / imgNaturalHeight
  const initialScale = Math.min(scaleX, scaleY, 0.85) // 默认85%，不超过原始大小

  // 应用缩放
  img.style.transform = `scale(${initialScale})`
  img.style.transformOrigin = 'center center'
  img.style.transition = 'transform 0.3s ease'
  img.setAttribute('data-initial-scale', initialScale.toString())

  // 存储当前缩放比例，供后续缩放操作使用
  img.dataset.currentScale = initialScale.toString()

  // 添加缩放控制事件监听
  addZoomControls(img)

  console.log(`图片初始缩放设置: ${(initialScale * 100).toFixed(1)}%`)
}

// 添加缩放控制功能
function addZoomControls(img) {
  const viewer = document.querySelector('.el-image-viewer__wrapper')
  if (!viewer) return

  // 监听缩放按钮点击
  const zoomInBtn = viewer.querySelector('.el-image-viewer__zoom-in')
  const zoomOutBtn = viewer.querySelector('.el-image-viewer__zoom-out')

  if (zoomInBtn && zoomOutBtn) {
    // 移除原有的点击事件，添加自定义缩放逻辑
    const handleZoomIn = (e) => {
      e.stopPropagation()
      zoomImage(img, 1.2)
    }

    const handleZoomOut = (e) => {
      e.stopPropagation()
      zoomImage(img, 0.8)
    }

    zoomInBtn.addEventListener('click', handleZoomIn)
    zoomOutBtn.addEventListener('click', handleZoomOut)

    // 存储事件处理器以便后续清理
    viewer.dataset.zoomHandlersAdded = 'true'
  }
}

// 缩放图片
function zoomImage(img, factor) {
  const currentScale = parseFloat(img.dataset.currentScale || '1')
  const newScale = Math.max(0.1, Math.min(5, currentScale * factor)) // 限制缩放范围

  img.style.transform = `scale(${newScale})`
  img.dataset.currentScale = newScale.toString()
}

// 取消按钮
function cancel() {
  open.value = false
  reset()
}

// 表单重置
function reset() {
  form.value = {
    noticeId: null,
    noticeTitle: null,
    coverImage: null,
    noticeType: null,
    noticeContent: null,
    status: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null
  }
  proxy.resetForm("noticesRef")
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef")
  handleQuery()
}

// 多选框选中数据
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.noticeId)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = "添加宿舍公告"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _noticeId = row.noticeId || ids.value
  getNotices(_noticeId).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改宿舍公告"
  })
}

/** 查看按钮操作 */
function handleView(row) {
  router.push({
    path: `/dorm/notices-detail/index/${row.noticeId}`
  });
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
function handleCoverSuccess(res) {
  if (res.code === 200) {
    form.value.coverImage = res.url
    // 上传成功后更新预览列表
    updatePreviewImages()
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
  form.value.coverImage = null
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["noticesRef"].validate(valid => {
    if (valid) {
      if (form.value.noticeId != null) {
        updateNotices(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addNotices(form.value).then(() => {
          proxy.$modal.msgSuccess("新增成功")
          open.value = false
          getList()
        })
      }
    }
  })
}

/** 删除按钮操作 */
function handleDelete(row) {
  const _noticeIds = row.noticeId || ids.value
  proxy.$modal.confirm('是否确认删除宿舍公告编号为"' + _noticeIds + '"的数据项？').then(function() {
    return delNotices(_noticeIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('dorm/notices/export', {
    ...queryParams.value
  }, `notices_${new Date().getTime()}.xlsx`)
}

// 监听预览器的打开和关闭
onMounted(() => {
  // 使用 MutationObserver 监听预览器的显示状态
  const observer = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
      if (mutation.type === 'childList') {
        const viewer = document.querySelector('.el-image-viewer__wrapper')
        if (viewer && !viewer.dataset.initialized) {
          // 预览器打开
          viewer.dataset.initialized = 'true'
          imageViewerVisible.value = true

          // 延迟应用初始缩放
          setTimeout(() => {
            applyInitialZoom()
          }, 100)
        } else if (!viewer && imageViewerVisible.value) {
          // 预览器关闭
          imageViewerVisible.value = false
        }
      }
    })
  })

  // 开始观察 body 的变化
  observer.observe(document.body, {
    childList: true,
    subtree: true
  })

  // 组件卸载时清理观察器
  onUnmounted(() => {
    observer.disconnect()
  })
})

getList()
</script>

<style lang="scss" scoped>
/* 公告标题样式 */
.notice-title {
  color: #303133;
  font-weight: 500;
  cursor: default;
  display: inline-block;
  max-width: 100%;

  &:hover {
    color: #409eff;
    cursor: pointer;
  }
}

/* 封面图片样式 */
.notice-cover-image {
  width: 80px;
  height: 80px;
  border-radius: 4px;
  object-fit: cover;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  transition: all 0.3s;
  cursor: pointer;

  &:hover {
    transform: scale(1.05);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  }

  &.no-preview {
    cursor: default;

    &:hover {
      transform: none;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
    }
  }
}

/* 图片加载错误样式 */
.image-error {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  background-color: #f5f7fa;
  color: #909399;
  border-radius: 4px;

  .image-error-icon {
    font-size: 24px;
    margin-bottom: 4px;
  }

  .image-error-text {
    font-size: 12px;
    text-align: center;
  }
}

/* 封面上传组件样式 */
.cover-image-uploader {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  width: 180px;
  height: 180px;
  display: flex;
  justify-content: center;
  align-items: center;
  
  &:hover {
    border-color: #409EFF;
  }
}

.cover-image-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 180px;
  height: 180px;
  text-align: center;
  display: flex;
  justify-content: center;
  align-items: center;
}

.cover-image {
  width: 178px;
  height: 178px;
  display: block;
  object-fit: cover;
}

.cover-image-tip {
  margin-top: 8px;
}

/* 表格样式优化 */
:deep(.el-table) {
  .el-table__header-wrapper {
    th {
      background: #f8f9fa !important;
      color: #495057 !important;
      font-weight: 600 !important;
      border-bottom: 2px solid #dee2e6 !important;
    }
  }

  .el-table__body-wrapper {
    .el-table__row {
      transition: all 0.3s ease;

      &:hover {
        background-color: #f8f9fa !important;
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      }
    }
  }
}

/* 自定义图片预览样式 */
:deep(.el-image-viewer__wrapper) {
  .el-image-viewer__close {
    color: #fff;
    font-size: 32px;
    opacity: 0.8;
    z-index: 2001;

    &:hover {
      opacity: 1;
      transform: scale(1.1);
    }
  }

  .el-image-viewer__prev,
  .el-image-viewer__next {
    width: 50px;
    height: 50px;
    font-size: 24px;
    color: #fff;
    background-color: rgba(0, 0, 0, 0.3);
    border-radius: 50%;
    z-index: 2001;

    &:hover {
      background-color: rgba(0, 0, 0, 0.5);
      transform: scale(1.05);
    }

    &:disabled {
      opacity: 0.3;
      cursor: not-allowed;
    }
  }

  .el-image-viewer__actions {
    opacity: 0.9;
    padding: 12px 20px;
    background-color: rgba(0, 0, 0, 0.5);
    border-radius: 8px;
    z-index: 2001;

    &:hover {
      opacity: 1;
    }

    .el-image-viewer__actions__inner {
      .el-image-viewer__zoom-in,
      .el-image-viewer__zoom-out,
      .el-image-viewer__refresh,
      .el-image-viewer__rotate {
        font-size: 20px;
        margin: 0 8px;
        padding: 8px;
        border-radius: 4px;
        transition: all 0.3s;

        &:hover {
          transform: scale(1.1);
          background-color: rgba(255, 255, 255, 0.1);
        }
      }
    }
  }

  .el-image-viewer__canvas {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    height: 100%;
    overflow: hidden;

    img {
      max-width: none;
      max-height: none;
      width: auto;
      height: auto;
      object-fit: contain;
      transition: transform 0.3s ease;
      cursor: grab;
      transform-origin: center center;

      &:active {
        cursor: grabbing;
      }

      // 确保图片居中显示
      display: block;
      margin: auto;

      // 初始状态下的缩放
      &[data-initial-scale] {
        transform: scale(var(--initial-scale, 0.85));
      }
    }
  }

  // 添加一个标识类来控制初始缩放
  &.initial-zoom {
    .el-image-viewer__canvas img {
      transform: scale(0.85);
    }
  }
}

/* 移动端适配 */
@media (max-width: 768px) {
  .notice-cover-image {
    width: 60px;
    height: 60px;
  }

  :deep(.el-image-viewer__wrapper) {
    .el-image-viewer__prev,
    .el-image-viewer__next {
      width: 40px;
      height: 40px;
      font-size: 20px;
    }

    .el-image-viewer__actions {
      padding: 8px 16px;

      .el-image-viewer__actions__inner {
        .el-image-viewer__zoom-in,
        .el-image-viewer__zoom-out,
        .el-image-viewer__refresh,
        .el-image-viewer__rotate {
          font-size: 18px;
          margin: 0 6px;
          padding: 6px;
        }
      }
    }

    .el-image-viewer__canvas {
      img {
        max-width: none;
        max-height: none;
      }
    }
  }
}
</style>
