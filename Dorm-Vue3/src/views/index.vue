<template>
  <div class="dashboard-container">
    <!-- 页面标题 -->
    <div class="dashboard-header">
      <h1 class="dashboard-title">宿舍管理系统数据大屏</h1>
      <div class="dashboard-time">{{ currentTime }}</div>
    </div>

    <!-- 数据加载状态 -->
    <div v-loading="loading" class="dashboard-content">
      <!-- 核心指标卡片 -->
      <el-row :gutter="20" class="metrics-row">
        <el-col :xs="12" :sm="6" :md="6" :lg="6" :xl="6">
          <div class="metric-card dorm-card">
            <div class="metric-icon">
              <el-icon><House /></el-icon>
            </div>
            <div class="metric-content">
              <div class="metric-value">{{ dormStats.totalRooms || 0 }}</div>
              <div class="metric-label">总宿舍数</div>
            </div>
          </div>
        </el-col>
        <el-col :xs="12" :sm="6" :md="6" :lg="6" :xl="6">
          <div class="metric-card student-card">
            <div class="metric-icon">
              <el-icon><User /></el-icon>
            </div>
            <div class="metric-content">
              <div class="metric-value">{{ studentStats.totalStudents || 0 }}</div>
              <div class="metric-label">在校学生</div>
            </div>
          </div>
        </el-col>
        <el-col :xs="12" :sm="6" :md="6" :lg="6" :xl="6">
          <div class="metric-card repair-card">
            <div class="metric-icon">
              <el-icon><Tools /></el-icon>
            </div>
            <div class="metric-content">
              <div class="metric-value">{{ repairStats.totalRequests || 0 }}</div>
              <div class="metric-label">维修工单</div>
            </div>
          </div>
        </el-col>
        <el-col :xs="12" :sm="6" :md="6" :lg="6" :xl="6">
          <div class="metric-card leave-card">
            <div class="metric-icon">
              <el-icon><Document /></el-icon>
            </div>
            <div class="metric-content">
              <div class="metric-value">{{ leaveStats.totalLeaves || 0 }}</div>
              <div class="metric-label">请假申请</div>
            </div>
          </div>
        </el-col>
      </el-row>

      <!-- 详细统计图表 -->
      <el-row :gutter="20" class="charts-row">
        <!-- 宿舍入住率 -->
        <el-col :xs="24" :sm="12" :md="12" :lg="8" :xl="8">
          <div class="chart-card">
            <div class="chart-header">
              <h3>宿舍入住情况</h3>
            </div>
            <div class="chart-content">
              <div id="dormOccupancyChart" class="chart-container"></div>
              <div class="chart-stats">
                <div class="stat-item">
                  <span class="stat-label">入住率:</span>
                  <span class="stat-value">{{ dormStats.occupancyRate || 0 }}%</span>
                </div>
                <div class="stat-item">
                  <span class="stat-label">空闲床位:</span>
                  <span class="stat-value">{{ dormStats.availableBeds || 0 }}</span>
                </div>
              </div>
            </div>
          </div>
        </el-col>

        <!-- 学生性别分布 -->
        <el-col :xs="24" :sm="12" :md="12" :lg="8" :xl="8">
          <div class="chart-card">
            <div class="chart-header">
              <h3>学生性别分布</h3>
            </div>
            <div class="chart-content">
              <div id="genderChart" class="chart-container"></div>
              <div class="chart-stats">
                <div class="stat-item">
                  <span class="stat-label">男生:</span>
                  <span class="stat-value">{{ studentStats.maleStudents || 0 }}</span>
                </div>
                <div class="stat-item">
                  <span class="stat-label">女生:</span>
                  <span class="stat-value">{{ studentStats.femaleStudents || 0 }}</span>
                </div>
              </div>
            </div>
          </div>
        </el-col>

        <!-- 维修工单状态 -->
        <el-col :xs="24" :sm="12" :md="12" :lg="8" :xl="8">
          <div class="chart-card">
            <div class="chart-header">
              <h3>维修工单状态</h3>
            </div>
            <div class="chart-content">
              <div id="repairStatusChart" class="chart-container"></div>
              <div class="chart-stats">
                <div class="stat-item">
                  <span class="stat-label">待处理:</span>
                  <span class="stat-value">{{ repairStats.pendingRequests || 0 }}</span>
                </div>
                <div class="stat-item">
                  <span class="stat-label">已完成:</span>
                  <span class="stat-value">{{ repairStats.completedRequests || 0 }}</span>
                </div>
              </div>
            </div>
          </div>
        </el-col>
      </el-row>
      <!-- 请假申请和公告统计 -->
      <el-row :gutter="20" class="info-row">
        <!-- 请假申请状态 -->
        <el-col :xs="24" :sm="12" :md="12" :lg="12" :xl="12">
          <div class="info-card">
            <div class="info-header">
              <h3>请假申请状态</h3>
            </div>
            <div class="info-content">
              <div class="info-stats">
                <div class="info-stat-item pending">
                  <div class="info-stat-value">{{ leaveStats.pendingApproval || 0 }}</div>
                  <div class="info-stat-label">待审批</div>
                </div>
                <div class="info-stat-item approved">
                  <div class="info-stat-value">{{ leaveStats.approvedLeaves || 0 }}</div>
                  <div class="info-stat-label">已批准</div>
                </div>
                <div class="info-stat-item away">
                  <div class="info-stat-value">{{ leaveStats.awayStudents || 0 }}</div>
                  <div class="info-stat-label">离校中</div>
                </div>
              </div>
            </div>
          </div>
        </el-col>

        <!-- 系统公告统计 -->
        <el-col :xs="24" :sm="12" :md="12" :lg="12" :xl="12">
          <div class="info-card">
            <div class="info-header">
              <h3>系统公告统计</h3>
            </div>
            <div class="info-content">
              <div class="info-stats">
                <div class="info-stat-item notice">
                  <div class="info-stat-value">{{ noticeStats.totalNotices || 0 }}</div>
                  <div class="info-stat-label">总公告数</div>
                </div>
                <div class="info-stat-item carousel">
                  <div class="info-stat-value">{{ noticeStats.carouselNotices || 0 }}</div>
                  <div class="info-stat-label">轮播公告</div>
                </div>
                <div class="info-stat-item activity">
                  <div class="info-stat-value">{{ noticeStats.activities || 0 }}</div>
                  <div class="info-stat-label">活动公告</div>
                </div>
              </div>
            </div>
          </div>
        </el-col>
      </el-row>

      <!-- 刷新按钮 -->
      <div class="refresh-section">
        <el-button
          type="primary"
          icon="Refresh"
          @click="refreshData"
          :loading="loading"
          size="large"
        >
          刷新数据
        </el-button>
        <span class="last-update">最后更新: {{ lastUpdateTime }}</span>
      </div>
    </div>
  </div>
</template>

<script setup name="Index">
import { ref, reactive, onMounted, onUnmounted, nextTick } from 'vue'
import { getDashboardStatistics } from '@/api/dashboard/index'
import * as echarts from 'echarts'
import { House, User, Tools, Document } from '@element-plus/icons-vue'

// 响应式数据
const loading = ref(false)
const currentTime = ref('')
const lastUpdateTime = ref('')

// 统计数据
const dormStats = reactive({})
const studentStats = reactive({})
const repairStats = reactive({})
const leaveStats = reactive({})
const noticeStats = reactive({})

// 图表实例
let dormOccupancyChart = null
let genderChart = null
let repairStatusChart = null

// 定时器
let timeInterval = null
let dataInterval = null

// 生命周期钩子
onMounted(() => {
  initDashboard()
  startTimeUpdate()
  startDataRefresh()
  // 添加窗口大小改变监听
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  clearInterval(timeInterval)
  clearInterval(dataInterval)
  destroyCharts()
  // 移除窗口大小改变监听
  window.removeEventListener('resize', handleResize)
})

// 方法定义
const initDashboard = async () => {
  await loadDashboardData()
  // 使用nextTick确保DOM已渲染
  await nextTick()
  initCharts()
}

const startTimeUpdate = () => {
  updateCurrentTime()
  timeInterval = setInterval(updateCurrentTime, 1000)
}

const startDataRefresh = () => {
  // 每5分钟自动刷新数据
  dataInterval = setInterval(loadDashboardData, 5 * 60 * 1000)
}

const updateCurrentTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  })
}

const loadDashboardData = async () => {
  loading.value = true
  try {
    const response = await getDashboardStatistics()
    if (response.code === 200) {
      const data = response.data

      // 更新统计数据
      Object.assign(dormStats, data.dormStatistics || {})
      Object.assign(studentStats, data.studentStatistics || {})
      Object.assign(repairStats, data.repairStatistics || {})
      Object.assign(leaveStats, data.leaveStatistics || {})
      Object.assign(noticeStats, data.noticeStatistics || {})

      // 更新图表
      await nextTick()
      updateCharts()

      // 更新最后更新时间
      lastUpdateTime.value = new Date().toLocaleString('zh-CN')
    }
  } catch (error) {
    console.error('加载数据失败:', error)
  } finally {
    loading.value = false
  }
}

const refreshData = () => {
  loadDashboardData()
}

const handleResize = () => {
  // 延迟执行，避免频繁调用
  setTimeout(() => {
    if (dormOccupancyChart) dormOccupancyChart.resize()
    if (genderChart) genderChart.resize()
    if (repairStatusChart) repairStatusChart.resize()
  }, 100)
}

const initCharts = () => {
  // 初始化图表
  initDormOccupancyChart()
  initGenderChart()
  initRepairStatusChart()
}

const updateCharts = () => {
  // 更新图表数据
  updateDormOccupancyChart()
  updateGenderChart()
  updateRepairStatusChart()
}

const destroyCharts = () => {
  if (dormOccupancyChart) {
    dormOccupancyChart.dispose()
    dormOccupancyChart = null
  }
  if (genderChart) {
    genderChart.dispose()
    genderChart = null
  }
  if (repairStatusChart) {
    repairStatusChart.dispose()
    repairStatusChart = null
  }
}

// 宿舍入住率图表
const initDormOccupancyChart = () => {
  const chartDom = document.getElementById('dormOccupancyChart')
  if (chartDom) {
    dormOccupancyChart = echarts.init(chartDom)
    updateDormOccupancyChart()
  }
}

const updateDormOccupancyChart = () => {
  if (!dormOccupancyChart) return

  const option = {
    tooltip: {
      trigger: 'item',
      formatter: '{a} <br/>{b}: {c} ({d}%)'
    },
    legend: {
      orient: 'vertical',
      left: 'left',
      textStyle: {
        color: '#333'
      }
    },
    series: [
      {
        name: '宿舍入住情况',
        type: 'pie',
        radius: ['40%', '70%'],
        center: ['60%', '50%'],
        data: [
          {
            value: dormStats.occupiedBeds || 0,
            name: '已入住',
            itemStyle: { color: '#667eea' }
          },
          {
            value: dormStats.availableBeds || 0,
            name: '空闲',
            itemStyle: { color: '#764ba2' }
          }
        ],
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.5)'
          }
        }
      }
    ]
  }

  dormOccupancyChart.setOption(option)
}

// 学生性别分布图表
const initGenderChart = () => {
  const chartDom = document.getElementById('genderChart')
  if (chartDom) {
    genderChart = echarts.init(chartDom)
    updateGenderChart()
  }
}

const updateGenderChart = () => {
  if (!genderChart) return

  const option = {
    tooltip: {
      trigger: 'item',
      formatter: '{a} <br/>{b}: {c} ({d}%)'
    },
    legend: {
      orient: 'vertical',
      left: 'left',
      textStyle: {
        color: '#333'
      }
    },
    series: [
      {
        name: '学生性别分布',
        type: 'pie',
        radius: '70%',
        center: ['60%', '50%'],
        data: [
          {
            value: studentStats.maleStudents || 0,
            name: '男生',
            itemStyle: { color: '#667eea' }
          },
          {
            value: studentStats.femaleStudents || 0,
            name: '女生',
            itemStyle: { color: '#764ba2' }
          }
        ],
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.5)'
          }
        }
      }
    ]
  }

  genderChart.setOption(option)
}

// 维修工单状态图表
const initRepairStatusChart = () => {
  const chartDom = document.getElementById('repairStatusChart')
  if (chartDom) {
    repairStatusChart = echarts.init(chartDom)
    updateRepairStatusChart()
  }
}

const updateRepairStatusChart = () => {
  if (!repairStatusChart) return

  const option = {
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow'
      }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: ['待处理', '进行中', '已完成'],
      axisLine: {
        lineStyle: {
          color: '#333'
        }
      }
    },
    yAxis: {
      type: 'value',
      axisLine: {
        lineStyle: {
          color: '#333'
        }
      }
    },
    series: [
      {
        name: '工单数量',
        type: 'bar',
        data: [
          {
            value: repairStats.pendingRequests || 0,
            itemStyle: { color: '#ff6b6b' }
          },
          {
            value: repairStats.inProgressRequests || 0,
            itemStyle: { color: '#4ecdc4' }
          },
          {
            value: repairStats.completedRequests || 0,
            itemStyle: { color: '#45b7d1' }
          }
        ],
        barWidth: '60%'
      }
    ]
  }

  repairStatusChart.setOption(option)
}
</script>

<style scoped lang="scss">
.dashboard-container {
  padding: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  min-height: 100vh;

  .dashboard-header {
    text-align: center;
    margin-bottom: 30px;

    .dashboard-title {
      font-size: 32px;
      font-weight: bold;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      margin-bottom: 10px;
    }

    .dashboard-time {
      font-size: 16px;
      color: #666;
      font-weight: 500;
    }
  }

  .dashboard-content {
    .metrics-row {
      margin-bottom: 30px;

      .metric-card {
        background: white;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        display: flex;
        align-items: center;
        transition: all 0.3s ease;
        cursor: pointer;

        &:hover {
          transform: translateY(-5px);
          box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
        }

        .metric-icon {
          width: 60px;
          height: 60px;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          margin-right: 20px;

          .el-icon {
            font-size: 24px;
            color: white;
          }
        }

        .metric-content {
          flex: 1;

          .metric-value {
            font-size: 28px;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
          }

          .metric-label {
            font-size: 14px;
            color: #666;
          }
        }

        &.dorm-card .metric-icon {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        &.student-card .metric-icon {
          background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        &.repair-card .metric-icon {
          background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        &.leave-card .metric-icon {
          background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }
      }
    }

    .charts-row {
      margin-bottom: 30px;

      .chart-card {
        background: white;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        height: 400px;

        .chart-header {
          margin-bottom: 20px;

          h3 {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin: 0;
          }
        }

        .chart-content {
          height: calc(100% - 60px);

          .chart-container {
            height: 70%;
            width: 100%;
          }

          .chart-stats {
            height: 30%;
            display: flex;
            justify-content: space-around;
            align-items: center;
            padding-top: 20px;
            border-top: 1px solid #eee;

            .stat-item {
              text-align: center;

              .stat-label {
                font-size: 14px;
                color: #666;
                margin-right: 8px;
              }

              .stat-value {
                font-size: 18px;
                font-weight: bold;
                color: #333;
              }
            }
          }
        }
      }
    }

    .info-row {
      margin-bottom: 30px;

      .info-card {
        background: white;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        height: 200px;

        .info-header {
          margin-bottom: 20px;

          h3 {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin: 0;
          }
        }

        .info-content {
          .info-stats {
            display: flex;
            justify-content: space-around;
            align-items: center;
            height: 120px;

            .info-stat-item {
              text-align: center;
              padding: 20px;
              border-radius: 8px;
              transition: all 0.3s ease;

              &:hover {
                transform: scale(1.05);
              }

              .info-stat-value {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 8px;
              }

              .info-stat-label {
                font-size: 14px;
                color: #666;
              }

              &.pending {
                background: linear-gradient(135deg, #ffeaa7 0%, #fab1a0 100%);
                .info-stat-value { color: #d63031; }
              }

              &.approved {
                background: linear-gradient(135deg, #55efc4 0%, #81ecec 100%);
                .info-stat-value { color: #00b894; }
              }

              &.away {
                background: linear-gradient(135deg, #a29bfe 0%, #6c5ce7 100%);
                .info-stat-value { color: #5f3dc4; }
              }

              &.notice {
                background: linear-gradient(135deg, #fd79a8 0%, #fdcb6e 100%);
                .info-stat-value { color: #e84393; }
              }

              &.carousel {
                background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);
                .info-stat-value { color: #0984e3; }
              }

              &.activity {
                background: linear-gradient(135deg, #fd79a8 0%, #e84393 100%);
                .info-stat-value { color: #e84393; }
              }
            }
          }
        }
      }
    }

    .refresh-section {
      text-align: center;
      padding: 30px 0;

      .el-button {
        margin-right: 20px;
      }

      .last-update {
        font-size: 14px;
        color: #666;
      }
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .dashboard-container {
    padding: 10px;

    .dashboard-header .dashboard-title {
      font-size: 24px;
    }

    .metrics-row .metric-card {
      margin-bottom: 15px;

      .metric-icon {
        width: 50px;
        height: 50px;
        margin-right: 15px;

        .el-icon {
          font-size: 20px;
        }
      }

      .metric-content .metric-value {
        font-size: 24px;
      }
    }

    .charts-row .chart-card {
      height: 350px;
      margin-bottom: 20px;
    }

    .info-row .info-card {
      height: auto;
      margin-bottom: 20px;

      .info-content .info-stats {
        flex-direction: column;
        height: auto;

        .info-stat-item {
          margin-bottom: 10px;
          width: 100%;
        }
      }
    }
  }
}
</style>

