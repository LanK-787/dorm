<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="宿舍名称" prop="buildingName" style="width: 200px;">
        <el-input
          v-model="queryParams.buildingName"
          placeholder="请输入宿舍名称"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="宿舍全称" prop="fullName" style="width: 200px;">
        <el-input
          v-model="queryParams.fullName"
          placeholder="请输入宿舍全称"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="宿管" prop="dormManager" style="width: 200px;">
        <el-input
          v-model="queryParams.dormManager"
          placeholder="请输入宿管"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="联系电话" prop="phone" style="width: 200px;">
        <el-input
          v-model="queryParams.phone"
          placeholder="请输入联系电话"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="宿舍状态" prop="status" style="width: 220px;">
        <el-select v-model="queryParams.status" placeholder="请选择宿舍状态" clearable>
          <el-option
            v-for="dict in dorm_status"
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
          v-hasPermi="['dorm:building:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="Sort"
          @click="toggleExpandAll"
        >展开/折叠</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Tools"
          @click="handleFixStatus"
          v-hasPermi="['dorm:building:edit']"
        >修复状态</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table
      v-if="refreshTable"
      v-loading="loading"
      :data="buildingList"
      row-key="dormId"
      :default-expand-all="isExpandAll"
      :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
    >
      <el-table-column label="名称" align="left" prop="buildingName"/>
      <el-table-column label="全称" align="left" prop="fullName"/>
      <el-table-column label="宿管" align="center" prop="dormManager" />
      <el-table-column label="联系电话" align="center" prop="phone" />
      <el-table-column label="最大入住人数" align="center" prop="maxCapacity" />
      <el-table-column label="当前入住人数" align="center" prop="currentCount" />
      <el-table-column label="宿舍状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="dorm_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['dorm:building:edit']">修改</el-button>
          <el-button link type="primary" icon="Plus" @click="handleAdd(scope.row)" v-hasPermi="['dorm:building:add']">新增</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['dorm:building:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 添加或修改宿舍管理对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="buildingRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="上级名称" prop="parentId">
          <el-tree-select
            v-model="form.parentId"
            :data="buildingOptions"
            :props="{ value: 'dormId', label: 'buildingName', children: 'children' }"
            value-key="dormId"
            placeholder="请选择上级名称"
            check-strictly
            @change="handleParentChange"
          />
        </el-form-item>
        <el-form-item label="宿舍名称" prop="buildingName">
          <el-input v-model="form.buildingName" placeholder="请输入宿舍名称" />
        </el-form-item>
        <el-form-item label="宿舍全称" prop="fullName" v-if="form.dormId != null">
          <el-input v-model="form.fullName" placeholder="请输入宿舍全称" />
        </el-form-item>
        <el-form-item label="显示顺序" prop="orderNum">
          <el-input
            v-model="form.orderNum"
            :placeholder="form.dormId == null ? '自动计算，可手动修改' : '请输入显示顺序'"
          />
        </el-form-item>
        <el-form-item label="宿管" prop="dormManager">
          <el-input v-model="form.dormManager" placeholder="请输入宿管" />
        </el-form-item>
        <el-form-item label="联系电话" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入联系电话" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="form.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="最大入住人数" prop="maxCapacity">
          <el-input-number
            v-model="form.maxCapacity"
            placeholder="请输入最大入住人数"
            :min="0"
            :max="20"
            :precision="0"
            controls-position="right"
            style="width: 100%"
            @change="handleMaxCapacityChange"
          />
        </el-form-item>
        <el-form-item label="当前入住人数" prop="currentCount">
          <el-input-number
            v-model="form.currentCount"
            placeholder="请输入当前入住人数"
            :min="0"
            :max="form.maxCapacity || 20"
            :precision="0"
            controls-position="right"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="宿舍状态" prop="status">
          <el-select v-model="form.status" placeholder="请选择宿舍状态">
            <el-option
              v-for="dict in dorm_status"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
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

<script setup name="Building">
import { listBuilding, getBuilding, delBuilding, addBuilding, updateBuilding, batchFixDormStatus, checkStatusConsistency } from "@/api/dorm/building"

const { proxy } = getCurrentInstance()
const { dorm_status } = proxy.useDict('dorm_status')

const buildingList = ref([])
const buildingOptions = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const title = ref("")
const isExpandAll = ref(true)
const refreshTable = ref(true)

const data = reactive({
  form: {},
  queryParams: {
    buildingName: null,
    fullName: null,
    orderNum: null,
    dormManager: null,
    phone: null,
    status: null,
  },
  rules: {
    parentId: [
      { required: true, message: "上级节点不能为空", trigger: "blur" }
    ],
    buildingName: [
      { required: true, message: "宿舍名称不能为空", trigger: "blur" }
    ],
    orderNum: [
      { required: true, message: "显示顺序不能为空", trigger: "blur" }
    ],
    maxCapacity: [
      {
        validator: (rule, value, callback) => {
          if (value !== null && value !== undefined) {
            if (!Number.isInteger(value) || value < 0) {
              callback(new Error('最大入住人数必须为大于等于0的整数'))
            } else if (value > 20) {
              callback(new Error('最大入住人数不能超过20'))
            } else {
              // 当最大容量改变时，重新验证当前入住人数
              if (form.value.currentCount !== null && form.value.currentCount !== undefined) {
                proxy.$refs["buildingRef"]?.validateField('currentCount')
              }
              callback()
            }
          } else {
            callback()
          }
        },
        trigger: ["blur", "change"]
      }
    ],
    currentCount: [
      {
        validator: (rule, value, callback) => {
          if (value !== null && value !== undefined) {
            if (!Number.isInteger(value) || value < 0) {
              callback(new Error('当前入住人数必须为大于等于0的整数'))
            } else if (form.value.maxCapacity !== null && form.value.maxCapacity !== undefined && value > form.value.maxCapacity) {
              callback(new Error('当前入住人数不能超过最大入住人数'))
            } else {
              callback()
            }
          } else {
            callback()
          }
        },
        trigger: ["blur", "change"]
      }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/**
 * 获取指定父节点下所有子节点的最大显示顺序
 * @param {Number} parentId 父节点ID
 * @returns {Promise<Number>} 最大显示顺序值
 */
async function getMaxOrderNumByParentId(parentId) {
  try {
    // 构建查询参数
    const queryParams = {}
    if (parentId !== undefined && parentId !== null) {
      queryParams.parentId = parentId
    }

    // 获取指定父节点下的所有子节点
    const response = await listBuilding(queryParams)
    const children = response.data || []

    if (children.length === 0) {
      return 0 // 如果没有子节点，返回0
    }

    // 过滤出真正的子节点（直接子节点）
    const directChildren = children.filter(child => child.parentId === parentId)

    if (directChildren.length === 0) {
      return 0
    }

    // 找出最大的显示顺序值，确保orderNum是数字类型
    const orderNums = directChildren.map(child => {
      const orderNum = parseInt(child.orderNum) || 0
      return orderNum
    })

    const maxOrderNum = Math.max(...orderNums)
    return maxOrderNum
  } catch (error) {
    console.error('获取最大显示顺序失败:', error)
    return 0 // 出错时返回默认值0
  }
}

/**
 * 自动计算并设置显示顺序
 * @param {Number} parentId 父节点ID
 */
async function autoSetOrderNum(parentId) {
  // 只在新增模式下自动设置显示顺序
  if (form.value.dormId != null) {
    return
  }

  try {
    const maxOrderNum = await getMaxOrderNumByParentId(parentId)
    form.value.orderNum = maxOrderNum + 1
  } catch (error) {
    console.error('自动设置显示顺序失败:', error)
    form.value.orderNum = 1 // 设置默认值
  }
}

/**
 * 根据父节点ID和宿舍名称生成宿舍全称
 * @param {Number} parentId 父节点ID
 * @param {String} buildingName 宿舍名称
 * @returns {Promise<String>} 生成的宿舍全称
 */
async function generateFullName(parentId, buildingName) {
  if (!buildingName) {
    return ''
  }

  // 如果是顶级节点（parentId为0），全称就是宿舍名称本身
  if (!parentId || parentId === 0) {
    return buildingName
  }

  try {
    // 递归查找父节点的完整路径
    const getParentPath = async (nodeId) => {
      if (!nodeId || nodeId === 0) {
        return []
      }

      try {
        const response = await getBuilding(nodeId)
        if (response && response.data) {
          const node = response.data
          const parentPath = await getParentPath(node.parentId)
          return [...parentPath, node.buildingName]
        }
      } catch (error) {
        console.error(`获取节点${nodeId}信息失败:`, error)
      }

      return []
    }

    // 获取父节点的完整路径
    const parentPath = await getParentPath(parentId)

    if (parentPath.length > 0) {
      // 生成全称：完整路径 + " - " + 宿舍名称
      return `${parentPath.join(' - ')} - ${buildingName}`
    } else {
      // 如果找不到父节点路径，返回宿舍名称本身
      return buildingName
    }
  } catch (error) {
    console.error('生成宿舍全称失败:', error)
    // 出错时返回宿舍名称本身
    return buildingName
  }
}

/**
 * 补充父节点，确保搜索结果包含完整的树形结构
 * @param {Array} searchResults 搜索返回的节点列表
 * @returns {Promise<Array>} 包含父节点的完整节点列表
 */
async function addParentNodes(searchResults) {
  if (!searchResults || searchResults.length === 0) {
    return []
  }

  try {
    // 获取所有节点（不带搜索条件）
    const allResponse = await listBuilding({})
    const allNodes = allResponse.data || []

    // 创建节点映射，便于快速查找
    const nodeMap = new Map()
    allNodes.forEach(node => {
      nodeMap.set(node.dormId, node)
    })

    // 创建一个Set来存储需要包含的节点ID
    const requiredNodeIds = new Set()

    // 递归添加节点及其所有祖先节点
    function addNodeAndAncestors(nodeId) {
      if (!nodeId || nodeId === 0 || requiredNodeIds.has(nodeId)) {
        return
      }

      const node = nodeMap.get(nodeId)
      if (!node) {
        return
      }

      requiredNodeIds.add(nodeId)

      // 递归添加父节点
      if (node.parentId && node.parentId !== 0) {
        addNodeAndAncestors(node.parentId)
      }
    }

    // 为每个搜索结果节点添加其祖先节点
    searchResults.forEach(node => {
      addNodeAndAncestors(node.dormId)
    })

    // 过滤出需要的节点
    const filteredNodes = allNodes.filter(node =>
      requiredNodeIds.has(node.dormId)
    )

    return filteredNodes
  } catch (error) {
    console.error('获取完整节点列表失败:', error)
    // 如果获取失败，返回原始搜索结果
    return searchResults
  }
}

/** 查询宿舍管理列表 */
async function getList() {
  loading.value = true
  try {
    const response = await listBuilding(queryParams.value)

    // 检查是否有搜索条件
    const hasSearchCondition = queryParams.value.buildingName ||
                               queryParams.value.fullName ||
                               queryParams.value.orderNum ||
                               queryParams.value.dormManager ||
                               queryParams.value.phone ||
                               queryParams.value.status

    if (hasSearchCondition) {
      // 如果有搜索条件，需要补充父节点
      const completeData = await addParentNodes(response.data)
      buildingList.value = proxy.handleTree(completeData, "dormId", "parentId")
    } else {
      // 如果没有搜索条件，直接构建树
      buildingList.value = proxy.handleTree(response.data, "dormId", "parentId")
    }
  } catch (error) {
    console.error('获取宿舍列表失败:', error)
    buildingList.value = []
  } finally {
    loading.value = false
  }
}

/** 查询宿舍管理下拉树结构 */
function getTreeselect() {
  listBuilding().then(response => {
    buildingOptions.value = []
    const data = { dormId: 0, buildingName: '顶级节点', children: [] }
    data.children = proxy.handleTree(response.data, "dormId", "parentId")
    buildingOptions.value.push(data)
  })
}

/**
 * 处理父节点选择变化事件
 * @param {Number} parentId 选中的父节点ID
 */
async function handleParentChange(parentId) {
  // 只在新增模式下自动设置显示顺序
  if (form.value.dormId != null) {
    return
  }

  // 自动计算并设置显示顺序
  await autoSetOrderNum(parentId)
}

/**
 * 处理最大容量变化事件
 * @param {Number} value 新的最大容量值
 */
function handleMaxCapacityChange(value) {
  // 如果当前入住人数超过了新的最大容量，自动调整当前入住人数
  if (form.value.currentCount !== null && form.value.currentCount !== undefined &&
      value !== null && value !== undefined && form.value.currentCount > value) {
    form.value.currentCount = value
  }

  // 触发当前入住人数的重新验证
  nextTick(() => {
    proxy.$refs["buildingRef"]?.validateField('currentCount')
  })
}
	
// 取消按钮
function cancel() {
  open.value = false
  reset()
}

// 表单重置
function reset() {
  form.value = {
    dormId: null,
    parentId: null,
    ancestors: null,
    buildingName: null,
    fullName: null,
    orderNum: null,
    dormManager: null,
    phone: null,
    email: null,
    status: null,
    maxCapacity: null,
    currentCount: null,
    delFlag: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null
  }
  proxy.resetForm("buildingRef")
}

/** 搜索按钮操作 */
function handleQuery() {
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef")
  handleQuery()
}

/** 新增按钮操作 */
async function handleAdd(row) {
  reset()
  getTreeselect()

  let parentId = 0
  if (row != null && row.dormId) {
    parentId = row.dormId
    form.value.parentId = parentId
  } else {
    form.value.parentId = 0
  }

  // 自动设置显示顺序
  await autoSetOrderNum(parentId)

  open.value = true
  title.value = "添加宿舍管理"
}

/** 展开/折叠操作 */
function toggleExpandAll() {
  refreshTable.value = false
  isExpandAll.value = !isExpandAll.value
  nextTick(() => {
    refreshTable.value = true
  })
}

/** 修改按钮操作 */
async function handleUpdate(row) {
  reset()
  await getTreeselect()
  if (row != null) {
    form.value.parentId = row.parentId
  }
  getBuilding(row.dormId).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改宿舍管理"
  })
}

/** 提交按钮 */
async function submitForm() {
  proxy.$refs["buildingRef"].validate(async (valid) => {
    if (valid) {
      try {
        if (form.value.dormId != null) {
          // 编辑模式：直接提交，保持用户输入的fullName
          const response = await updateBuilding(form.value)
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        } else {
          // 新增模式：自动生成fullName
          const generatedFullName = await generateFullName(form.value.parentId, form.value.buildingName)

          // 创建提交数据，包含自动生成的fullName
          const submitData = {
            ...form.value,
            fullName: generatedFullName
          }

          const response = await addBuilding(submitData)
          proxy.$modal.msgSuccess("新增成功")
          open.value = false
          getList()
        }
      } catch (error) {
        console.error('提交失败:', error)
        proxy.$modal.msgError("操作失败，请重试")
      }
    }
  })
}

/** 删除按钮操作 */
function handleDelete(row) {
  proxy.$modal.confirm('是否确认删除宿舍管理编号为"' + row.dormId + '"的数据项？').then(function() {
    return delBuilding(row.dormId)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 修复宿舍状态 */
async function handleFixStatus() {
  console.log('🔧 开始执行修复状态功能')
  let checkResponse = null

  // 第一步：调用检查状态一致性API
  try {
    console.log('📡 调用检查状态一致性API...')
    checkResponse = await checkStatusConsistency()
    console.log('✅ API调用成功，响应:', checkResponse)
  } catch (error) {
    console.error('❌ 调用检查状态一致性API失败:', error)
    proxy.$modal.msgError("检查状态一致性失败，请重试")
    return
  }

  // 第二步：处理API响应
  try {
    // 验证响应数据
    if (!checkResponse) {
      console.error('❌ checkResponse 为空')
      proxy.$modal.msgError("检查状态一致性失败")
      return
    }

    console.log('🔍 分析响应数据:')
    console.log('  - 响应码:', checkResponse.code)
    console.log('  - 响应消息:', checkResponse.msg)
    console.log('  - 响应数据:', checkResponse.data)

    // 判断是否有不一致的状态
    // 当有不一致状态时，data 包含 { count, inconsistentDorms, message }
    // 当无不一致状态时，data 为 null，消息在 msg 中
    if (checkResponse.data && typeof checkResponse.data === 'object' && checkResponse.data.count > 0) {
      console.log('⚠️ 发现不一致状态，需要修复')
      // 有不一致状态，需要修复
      const inconsistentCount = checkResponse.data.count
      const confirmMessage = `检测到 ${inconsistentCount} 个宿舍的状态与容量不一致，是否执行批量修复？`

      // 显示确认对话框
      try {
        console.log('❓ 显示确认对话框')
        await proxy.$modal.confirm(confirmMessage)
        console.log('✅ 用户确认执行修复')
      } catch (error) {
        console.log('🚫 用户取消操作')
        return
      }

      // 执行批量修复
      let fixResponse = null
      try {
        console.log('🔧 执行批量修复...')
        fixResponse = await batchFixDormStatus()
        console.log('✅ 批量修复完成，响应:', fixResponse)
      } catch (error) {
        console.error('❌ 调用批量修复API失败:', error)
        proxy.$modal.msgError("批量修复失败，请重试")
        return
      }

      // 处理修复结果
      if (fixResponse && fixResponse.code === 200) {
        console.log('🎉 修复成功')
        proxy.$modal.msgSuccess(fixResponse.msg || "状态修复成功")
        getList()
      } else {
        console.error('❌ 修复失败:', fixResponse)
        proxy.$modal.msgError(fixResponse?.msg || "状态修复失败")
      }
    } else {
      console.log('ℹ️ 无不一致状态，显示信息提示')
      // 无不一致状态，显示信息提示（使用后端返回的消息）
      proxy.$modal.msgInfo(checkResponse.msg || "所有宿舍状态与容量一致，无需修复")
    }
  } catch (error) {
    console.error('💥 处理修复状态逻辑时发生错误:', error)
    console.error('错误详情:', {
      name: error.name,
      message: error.message,
      stack: error.stack
    })
    proxy.$modal.msgError("修复状态失败，请重试")
  }
}

getList()
</script>
