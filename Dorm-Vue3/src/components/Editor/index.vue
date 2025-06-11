<template>
  <div class="editor-container">
    <!-- 图片上传组件 -->
    <el-upload
      v-if="type === 'url'"
      :action="uploadUrl"
      :before-upload="handleBeforeUpload"
      :on-success="handleUploadSuccess"
      :on-error="handleUploadError"
      name="file"
      :show-file-list="false"
      :headers="headers"
      class="editor-img-uploader"
    >
      <i ref="uploadRef" class="editor-img-uploader"></i>
    </el-upload>

    <!-- 富文本编辑器 -->
    <div class="editor">
      <quill-editor
        ref="quillEditorRef"
        v-model:content="editorContent"
        contentType="html"
        @textChange="handleTextChange"
        :options="editorOptions"
        :style="editorStyles"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted, getCurrentInstance } from 'vue'
import { QuillEditor } from "@vueup/vue-quill"
import "@vueup/vue-quill/dist/vue-quill.snow.css"
import { getToken } from "@/utils/auth"
import axios from 'axios'

// 类型定义
const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  },
  height: {
    type: Number,
    default: null
  },
  minHeight: {
    type: Number,
    default: null
  },
  readOnly: {
    type: Boolean,
    default: false
  },
  fileSize: {
    type: Number,
    default: 5
  },
  type: {
    type: String,
    default: "url"
  }
})

const emit = defineEmits(['update:modelValue'])

// 组件实例
const { proxy } = getCurrentInstance()
const quillEditorRef = ref(null)
const uploadRef = ref(null)

// 响应式数据
const editorContent = ref('')
const uploadUrl = computed(() => import.meta.env.VITE_APP_BASE_API + "/common/upload")
const headers = computed(() => ({
  Authorization: "Bearer " + getToken()
}))

// 编辑器样式
const editorStyles = computed(() => {
  const style = {}
  if (props.minHeight) style.minHeight = `${props.minHeight}px`
  if (props.height) style.height = `${props.height}px`
  return style
})

// 编辑器配置
const editorOptions = computed(() => ({
  theme: "snow",
  bounds: document.body,
  debug: "warn",
  modules: {
    toolbar: [
      ["bold", "italic", "underline", "strike"],
      ["blockquote", "code-block"],
      [{ list: "ordered" }, { list: "bullet" }],
      [{ indent: "-1" }, { indent: "+1" }],
      [{ size: ["small", false, "large", "huge"] }],
      [{ header: [1, 2, 3, 4, 5, 6, false] }],
      [{ color: [] }, { background: [] }],
      [{ align: [] }],
      ["clean"],
      ["link", "image", "video"]
    ]
  },
  placeholder: "请输入内容",
  readOnly: props.readOnly
}))

// 监听 modelValue 变化
watch(() => props.modelValue, 
  (newValue) => {
    if (newValue !== editorContent.value) {
      editorContent.value = newValue ?? "<p></p>"
    }
  }, 
  { immediate: true }
)

// 文本变化处理
const handleTextChange = () => {
  emit('update:modelValue', editorContent.value)
}

// 图片上传前验证
const handleBeforeUpload = (file) => {
  const allowedTypes = ["image/jpeg", "image/jpg", "image/png", "image/svg"]
  
  if (!allowedTypes.includes(file.type)) {
    proxy.$modal.msgError("图片格式错误，仅支持 JPG、PNG、SVG 格式！")
    return false
  }
  
  if (props.fileSize && file.size / 1024 / 1024 > props.fileSize) {
    proxy.$modal.msgError(`图片大小不能超过 ${props.fileSize}MB！`)
    return false
  }
  
  return true
}

// 图片上传成功处理
const handleUploadSuccess = (res) => {
  if (res.code !== 200) {
    proxy.$modal.msgError("图片上传失败")
    return
  }

  const quill = quillEditorRef.value?.getQuill()
  if (!quill) return

  const cursorPosition = quill.selection.savedRange.index
  const imageUrl = res.url || (import.meta.env.VITE_APP_BASE_API + res.fileName)
  
  quill.insertEmbed(cursorPosition, "image", imageUrl)
  quill.setSelection(cursorPosition + 1)
}

// 图片上传失败处理
const handleUploadError = (error) => {
  console.error('图片上传失败:', error)
  proxy.$modal.msgError("图片上传失败，请重试")
}

// 粘贴图片处理
const handlePasteImage = async (file) => {
  try {
    const formData = new FormData()
    formData.append("file", file)
    
    const response = await axios.post(uploadUrl.value, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
        Authorization: headers.value.Authorization
      }
    })
    
    if (response.data?.code === 200) {
      handleUploadSuccess(response.data)
    } else {
      throw new Error(response.data?.msg || "上传失败")
    }
  } catch (error) {
    handleUploadError(error)
  }
}

// 粘贴事件处理
const handlePasteCapture = (event) => {
  const clipboard = event.clipboardData || window.clipboardData
  if (!clipboard?.items) return
  
  for (const item of clipboard.items) {
    if (item.type.startsWith('image/')) {
      event.preventDefault()
      const file = item.getAsFile()
      if (file) handlePasteImage(file)
      break
    }
  }
}

// 组件挂载后的处理
onMounted(() => {
  if (props.type !== 'url') return
  
  const quill = quillEditorRef.value?.getQuill()
  if (!quill) return
  
  // 配置图片上传处理
  const toolbar = quill.getModule("toolbar")
  toolbar.addHandler("image", (value) => {
    if (value) {
      uploadRef.value?.click()
    } else {
      quill.format("image", false)
    }
  })
  
  // 添加粘贴事件监听
  quill.root.addEventListener('paste', handlePasteCapture, true)
})
</script>

<style lang="scss" scoped>
.editor-container {
  .editor-img-uploader {
    display: none;
  }
  
  .editor {
    .ql-toolbar {
      white-space: pre-wrap !important;
      line-height: normal !important;
    }
  }
}

// Quill编辑器中文化
:deep(.ql-snow) {
  .ql-tooltip {
    &[data-mode="link"]::before { content: "请输入链接地址:"; }
    &[data-mode="video"]::before { content: "请输入视频地址:"; }
    
    &.ql-editing a.ql-action::after {
      border-right: 0;
      content: "保存";
      padding-right: 0;
    }
  }

  .ql-picker {
    &.ql-size {
      .ql-picker-label::before,
      .ql-picker-item::before { content: "14px"; }
      
      [data-value="small"]::before { content: "10px"; }
      [data-value="large"]::before { content: "18px"; }
      [data-value="huge"]::before { content: "32px"; }
    }

    &.ql-header {
      .ql-picker-label::before,
      .ql-picker-item::before { content: "文本"; }
      
      @for $i from 1 through 6 {
        [data-value="#{$i}"]::before { content: "标题#{$i}"; }
      }
    }

    &.ql-font {
      .ql-picker-label::before,
      .ql-picker-item::before { content: "标准字体"; }
      
      [data-value="serif"]::before { content: "衬线字体"; }
      [data-value="monospace"]::before { content: "等宽字体"; }
    }
  }
}
</style>
