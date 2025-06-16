<template>
  <div class="app-container">
    <!-- 面包屑导航 -->
    <el-breadcrumb separator="/" class="breadcrumb-container">
      <el-breadcrumb-item>
        <el-button link type="primary" @click="goBack">
          <el-icon><ArrowLeft /></el-icon>
          宿舍管理
        </el-button>
      </el-breadcrumb-item>
      <el-breadcrumb-item v-for="(item, index) in breadcrumbItems" :key="index">
        <span v-if="index === breadcrumbItems.length - 1" class="current-item">{{ item }}</span>
        <el-button v-else link type="primary" @click="navigateToBreadcrumb(index)">{{ item }}</el-button>
      </el-breadcrumb-item>
    </el-breadcrumb>

    <!-- 页面标题 -->
    <div class="page-header">
      <h2>{{ pageTitle }}</h2>
      <p class="page-subtitle">{{ pageSubtitle }}</p>
    </div>

    <!-- 加载状态 -->
    <div v-loading="loading" class="content-container">
      <!-- 学生信息展示（末尾节点） -->
      <div v-if="isLeafNode && students.length > 0" class="students-container">
        <div class="section-header">
          <h3>宿舍学生信息</h3>
          <el-tag type="info">共 {{ students.length }} 名学生</el-tag>
        </div>
        <el-row :gutter="20">
          <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="student in students" :key="student.studentId">
            <el-card class="student-card" shadow="hover">
              <template #header>
                <div class="card-header">
                  <span class="student-name">{{ student.name }}</span>
                  <el-tag :type="student.gender === '0' ? 'primary' : 'danger'" size="small">
                    {{ student.gender === '0' ? '男' : '女' }}
                  </el-tag>
                </div>
              </template>
              <div class="student-info">
                <div class="info-item">
                  <el-icon><User /></el-icon>
                  <span class="label">学号：</span>
                  <span class="value">{{ student.studentNo }}</span>
                </div>
                <div class="info-item" v-if="student.className">
                  <el-icon><School /></el-icon>
                  <span class="label">班级：</span>
                  <span class="value">{{ student.className }}</span>
                </div>
                <div class="info-item" v-if="student.phone">
                  <el-icon><Phone /></el-icon>
                  <span class="label">电话：</span>
                  <span class="value">{{ student.phone }}</span>
                </div>
                <div class="info-item" v-if="student.email">
                  <el-icon><Message /></el-icon>
                  <span class="label">邮箱：</span>
                  <span class="value">{{ student.email }}</span>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>

      <!-- 空状态（末尾节点但无学生） -->
      <div v-else-if="isLeafNode && students.length === 0" class="empty-state">
        <el-empty description="该宿舍暂无学生入住">
          <el-button type="primary" @click="goBack">返回宿舍管理</el-button>
        </el-empty>
      </div>

      <!-- 子节点展示（父节点） -->
      <div v-else-if="!isLeafNode && childNodes.length > 0" class="child-nodes-container">
        <div class="section-header">
          <h3>下级节点</h3>
          <el-tag type="info">共 {{ childNodes.length }} 个子节点</el-tag>
        </div>
        <el-row :gutter="20">
          <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="node in childNodes" :key="node.dormId">
            <el-card class="node-card" shadow="hover" @click="navigateToChild(node)">
              <template #header>
                <div class="card-header">
                  <span class="node-name">{{ node.buildingName }}</span>
                  <el-tag 
                    :type="node.status === '0' ? 'success' : 'danger'" 
                    size="small"
                  >
                    {{ node.status === '0' ? '空闲' : '满员' }}
                  </el-tag>
                </div>
              </template>
              <div class="node-info">
                <div class="info-item" v-if="node.maxCapacity !== null">
                  <el-icon><House /></el-icon>
                  <span class="label">容量：</span>
                  <span class="value">{{ node.currentCount || 0 }}/{{ node.maxCapacity }}</span>
                </div>
                <div class="info-item" v-if="node.dormManager">
                  <el-icon><User /></el-icon>
                  <span class="label">宿管：</span>
                  <span class="value">{{ node.dormManager }}</span>
                </div>
                <div class="info-item" v-if="node.phone">
                  <el-icon><Phone /></el-icon>
                  <span class="label">电话：</span>
                  <span class="value">{{ node.phone }}</span>
                </div>
                <div class="info-item">
                  <el-icon><Location /></el-icon>
                  <span class="label">全称：</span>
                  <span class="value">{{ node.fullName }}</span>
                </div>
              </div>
              <div class="card-footer">
                <el-button type="primary" link>
                  <el-icon><ArrowRight /></el-icon>
                  查看详情
                </el-button>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>

      <!-- 空状态（父节点但无子节点） -->
      <div v-else-if="!isLeafNode && childNodes.length === 0" class="empty-state">
        <el-empty description="该节点下暂无子节点">
          <el-button type="primary" @click="goBack">返回宿舍管理</el-button>
        </el-empty>
      </div>
    </div>
  </div>
</template>

<script setup name="BuildingDetail">
import { listStudent } from "@/api/dorm/student"
import { listBuilding, getBuilding } from "@/api/dorm/building"

const { proxy } = getCurrentInstance()
const route = useRoute()
const router = useRouter()

// 响应式数据
const loading = ref(true)
const students = ref([])
const childNodes = ref([])
const isLeafNode = ref(false)
const currentNode = ref({})
const breadcrumbItems = ref([])
const pageTitle = ref('')
const pageSubtitle = ref('')

// 当前宿舍信息
const dormId = ref(null)
const fullName = ref('')
const buildingName = ref('')

/** 初始化页面数据 */
async function initPageData() {
  loading.value = true
  
  try {
    // 获取路由参数
    dormId.value = route.query.dormId
    fullName.value = route.query.fullName || ''
    buildingName.value = route.query.buildingName || ''
    
    if (!dormId.value) {
      proxy.$modal.msgError("缺少宿舍ID参数")
      goBack()
      return
    }

    // 获取当前节点详细信息
    const nodeResponse = await getBuilding(dormId.value)
    currentNode.value = nodeResponse.data
    
    // 设置页面标题和面包屑
    setupPageInfo()
    
    // 判断是否为末尾节点（检查是否有子节点）
    await checkNodeType()
    
    if (isLeafNode.value) {
      // 末尾节点：获取学生信息
      await loadStudents()
    } else {
      // 父节点：获取子节点信息
      await loadChildNodes()
    }
  } catch (error) {
    console.error('初始化页面数据失败:', error)
    proxy.$modal.msgError("加载数据失败，请重试")
  } finally {
    loading.value = false
  }
}

/** 设置页面信息 */
function setupPageInfo() {
  pageTitle.value = buildingName.value || currentNode.value.buildingName || '宿舍详情'
  pageSubtitle.value = fullName.value || currentNode.value.fullName || ''

  // 生成面包屑导航
  if (fullName.value) {
    breadcrumbItems.value = fullName.value.split(' - ')
  } else {
    breadcrumbItems.value = [pageTitle.value]
  }
}

/** 检查节点类型 */
async function checkNodeType() {
  try {
    // 查询子节点
    const childResponse = await listBuilding({ parentId: dormId.value })
    const children = childResponse.data || []
    
    // 如果没有子节点，则认为是末尾节点
    isLeafNode.value = children.length === 0
  } catch (error) {
    console.error('检查节点类型失败:', error)
    // 默认认为是末尾节点
    isLeafNode.value = true
  }
}

/** 加载学生信息 */
async function loadStudents() {
  try {
    const response = await listStudent({ dormId: dormId.value })
    students.value = response.rows || []
  } catch (error) {
    console.error('加载学生信息失败:', error)
    students.value = []
  }
}

/** 加载子节点信息 */
async function loadChildNodes() {
  try {
    const response = await listBuilding({ parentId: dormId.value })
    childNodes.value = response.data || []
  } catch (error) {
    console.error('加载子节点信息失败:', error)
    childNodes.value = []
  }
}

/** 导航到子节点 */
function navigateToChild(node) {
  router.push({
    path: '/dorm/building-detail/index',
    query: {
      dormId: node.dormId,
      fullName: node.fullName,
      buildingName: node.buildingName
    }
  })
}

/** 面包屑导航 */
async function navigateToBreadcrumb(index) {
  try {
    // 根据面包屑索引导航到对应层级
    if (index === 0) {
      // 点击第一级，返回宿舍管理页面
      goBack()
      return
    }

    // 构建目标路径
    const targetPath = breadcrumbItems.value.slice(0, index + 1).join(' - ')

    // 查找对应的宿舍节点
    const response = await listBuilding({})
    const allNodes = response.data || []

    // 查找匹配的节点
    const targetNode = allNodes.find(node => node.fullName === targetPath)

    if (targetNode) {
      // 导航到目标节点
      router.push({
        path: '/dorm/building-detail/index',
        query: {
          dormId: targetNode.dormId,
          fullName: targetNode.fullName,
          buildingName: targetNode.buildingName
        }
      })
    } else {
      // 如果找不到对应节点，返回上级
      goBack()
    }
  } catch (error) {
    console.error('面包屑导航失败:', error)
    goBack()
  }
}

/** 返回宿舍管理页面 */
function goBack() {
  router.push('/dorm/building')
}

// 页面加载时初始化数据
onMounted(() => {
  initPageData()
})

// 监听路由变化，重新加载数据
watch(() => route.query, () => {
  if (route.path === '/dorm/building-detail/index') {
    initPageData()
  }
}, { deep: true })
</script>

<style scoped>
.breadcrumb-container {
  margin-bottom: 20px;
  padding: 12px 0;
  border-bottom: 1px solid #e4e7ed;
}

.breadcrumb-container .current-item {
  color: #606266;
  font-weight: 500;
}

.page-header {
  margin-bottom: 24px;
}

.page-header h2 {
  margin: 0 0 8px 0;
  color: #303133;
  font-size: 24px;
  font-weight: 600;
}

.page-subtitle {
  margin: 0;
  color: #909399;
  font-size: 14px;
}

.content-container {
  min-height: 400px;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 2px solid #f0f2f5;
}

.section-header h3 {
  margin: 0;
  color: #303133;
  font-size: 18px;
  font-weight: 600;
}

/* 学生卡片样式 */
.students-container {
  margin-bottom: 24px;
}

.student-card {
  margin-bottom: 20px;
  transition: all 0.3s ease;
  border-radius: 8px;
}

.student-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.student-card .card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.student-name {
  font-weight: 600;
  font-size: 16px;
  color: #303133;
}

.student-info {
  padding: 0;
}

.info-item {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
  font-size: 14px;
}

.info-item:last-child {
  margin-bottom: 0;
}

.info-item .el-icon {
  margin-right: 8px;
  color: #909399;
  font-size: 16px;
}

.info-item .label {
  color: #606266;
  margin-right: 4px;
  min-width: 40px;
}

.info-item .value {
  color: #303133;
  font-weight: 500;
}

/* 子节点卡片样式 */
.child-nodes-container {
  margin-bottom: 24px;
}

.node-card {
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 8px;
}

.node-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
  border-color: #409eff;
}

.node-card .card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.node-name {
  font-weight: 600;
  font-size: 16px;
  color: #303133;
}

.node-info {
  padding: 0;
  margin-bottom: 12px;
}

.card-footer {
  text-align: right;
  padding-top: 8px;
  border-top: 1px solid #f0f2f5;
}

/* 空状态样式 */
.empty-state {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 300px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .page-header h2 {
    font-size: 20px;
  }

  .section-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }

  .info-item {
    flex-direction: column;
    align-items: flex-start;
  }

  .info-item .label {
    margin-bottom: 2px;
  }
}
</style>
