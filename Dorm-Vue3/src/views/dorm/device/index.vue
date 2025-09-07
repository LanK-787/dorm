<template>
  <div class="app-container">
    <el-row :gutter="20">
      <splitpanes :horizontal="appStore.device === 'mobile'" class="default-theme">
        <!--宿舍数据-->
        <pane size="16">
          <el-col>
            <div class="head-container">
              <el-input v-model="dormName" placeholder="请输入宿舍名称" clearable prefix-icon="Search" style="margin-bottom: 20px" />
            </div>
            <div class="head-container">
              <el-tree :data="dormOptions" :props="{ label: 'label', children: 'children' }" :expand-on-click-node="false" :filter-node-method="filterNode" ref="dormTreeRef" node-key="id" highlight-current default-expand-all @node-click="handleNodeClick" />
            </div>
          </el-col>
        </pane>
        <!--设备数据-->
        <pane size="84">
          <el-col>
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="设备名称" prop="deviceName">
        <el-input
          v-model="queryParams.deviceName"
          placeholder="请输入设备名称"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="设备类型" prop="deviceType">
        <el-select v-model="queryParams.deviceType" placeholder="请选择设备类型" clearable>
          <el-option
            v-for="dict in dorm_device"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="设备状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择设备状态" clearable>
          <el-option
            v-for="dict in dorm_device_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="最后一次在线时间" prop="lastOnlineTime">
        <el-date-picker clearable
          v-model="queryParams.lastOnlineTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择最后一次在线时间">
        </el-date-picker>
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
          v-hasPermi="['dorm:device:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['dorm:device:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['dorm:device:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['dorm:device:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="deviceList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="设备ID" align="center" prop="deviceId" />
      <el-table-column label="所属宿舍" align="center" prop="dormFullName" />
      <el-table-column label="设备名称" align="center" prop="deviceName" />
      <el-table-column label="设备类型" align="center" prop="deviceType">
        <template #default="scope">
          <dict-tag :options="dorm_device" :value="scope.row.deviceType"/>
        </template>
      </el-table-column>
      <el-table-column label="设备状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="dorm_device_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="最后一次在线时间" align="center" prop="lastOnlineTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.lastOnlineTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['dorm:device:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['dorm:device:remove']">删除</el-button>
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
          </el-col>
        </pane>
      </splitpanes>
    </el-row>

    <!-- 添加或修改设备管理对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="deviceRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="宿舍" prop="dormId">
          <el-tree-select v-model="form.dormId" :data="enabledDormOptions" :props="{ value: 'id', label: 'label', children: 'children' }" value-key="id" placeholder="请选择宿舍" check-strictly />
        </el-form-item>
        <el-form-item label="设备名称" prop="deviceName">
          <el-input v-model="form.deviceName" placeholder="请输入设备名称" />
        </el-form-item>
        <el-form-item label="设备类型" prop="deviceType">
          <el-select v-model="form.deviceType" placeholder="请选择设备类型">
            <el-option
              v-for="dict in dorm_device"
              :key="dict.value"
              :label="dict.label"
              :value="parseInt(dict.value)"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="设备状态" prop="status">
          <el-select v-model="form.status" placeholder="请选择设备状态">
            <el-option
              v-for="dict in dorm_device_status"
              :key="dict.value"
              :label="dict.label"
              :value="parseInt(dict.value)"
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

<script setup name="Device">
import { listDevice, getDevice, delDevice, addDevice, updateDevice } from "@/api/dorm/device"
import { dormTreeSelectWithCapacity } from "@/api/dorm/student"
import { Splitpanes, Pane } from "splitpanes"
import useAppStore from '@/store/modules/app'
import "splitpanes/dist/splitpanes.css"

const { proxy } = getCurrentInstance()
const { dorm_device_status, dorm_device } = proxy.useDict('dorm_device_status', 'dorm_device')

const appStore = useAppStore()
const deviceList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const dormOptions = ref(undefined)
const enabledDormOptions = ref(undefined)
const dormName = ref("")

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    dormId: null,
    dormIds: null,
    deviceName: null,
    deviceType: null,
    status: null,
    lastOnlineTime: null,
  },
  rules: {
    dormId: [
      { required: true, message: "所属宿舍/房间ID不能为空", trigger: "blur" }
    ],
    deviceName: [
      { required: true, message: "设备名称不能为空", trigger: "blur" }
    ],
    deviceType: [
      { required: true, message: "设备类型，'0'为烟雾报警器不能为空", trigger: "change" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询宿舍下拉树结构 */
function getDormTree(currentDeviceDormId = null) {
  dormTreeSelectWithCapacity().then(response => {
    dormOptions.value = response.data
    // 统一使用同一个函数处理宿舍选项，传入当前设备宿舍ID（如果有）
    enabledDormOptions.value = processDormOptions(JSON.parse(JSON.stringify(response.data)), currentDeviceDormId)
  })
}

/**
 * 统一处理宿舍选项：设置禁用状态
 * @param {Array} dormList 宿舍列表
 * @param {Number|null} currentDeviceDormId 当前设备的宿舍ID（编辑时传入，新增时为null）
 */
function processDormOptions(dormList, currentDeviceDormId = null) {
  dormList.forEach(dorm => {
    // 设置禁用状态：对于设备管理，不禁用任何宿舍，因为设备可以安装到任何宿舍
    dorm.disabled = false

    // 递归处理子节点
    if (dorm.children && dorm.children.length) {
      processDormOptions(dorm.children, currentDeviceDormId)
    }
  })

  return dormList
}

/** 查询设备管理列表 */
function getList() {
  loading.value = true
  listDevice(queryParams.value).then(response => {
    deviceList.value = response.rows
    total.value = response.total
    loading.value = false
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
    deviceId: null,
    dormId: null,
    deviceName: null,
    deviceType: null,
    location: null,
    status: null,
    lastOnlineTime: null,
    createTime: null,
    updateTime: null
  }
  proxy.resetForm("deviceRef")
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  // 清空多宿舍ID查询参数
  queryParams.value.dormIds = null
  proxy.resetForm("queryRef")
  handleQuery()
}

// 多选框选中数据
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.deviceId)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  // 新增时不传入当前设备宿舍ID
  getDormTree()
  open.value = true
  title.value = "添加设备管理"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _deviceId = row.deviceId || ids.value
  getDevice(_deviceId).then(response => {
    form.value = response.data
    // 传入当前设备的宿舍ID，确保其当前宿舍不被禁用
    getDormTree(form.value.dormId)
    open.value = true
    title.value = "修改设备管理"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["deviceRef"].validate(valid => {
    if (valid) {
      if (form.value.deviceId != null) {
        updateDevice(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
          // 重新加载宿舍树数据
          getDormTree()
        }).catch(error => {
          proxy.$modal.msgError(error.response?.data?.msg || "修改失败")
        })
      } else {
        addDevice(form.value).then(response => {
          proxy.$modal.msgSuccess("新增成功")
          open.value = false
          getList()
          // 重新加载宿舍树数据
          getDormTree()
        }).catch(error => {
          proxy.$modal.msgError(error.response?.data?.msg || "新增失败")
        })
      }
    }
  })
}

/** 删除按钮操作 */
function handleDelete(row) {
  const _deviceIds = row.deviceId || ids.value
  proxy.$modal.confirm('是否确认删除设备管理编号为"' + _deviceIds + '"的数据项？').then(function() {
    return delDevice(_deviceIds)
  }).then(() => {
    getList()
    // 重新加载宿舍树数据
    getDormTree()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('dorm/device/export', {
    ...queryParams.value
  }, `device_${new Date().getTime()}.xlsx`)
}

/** 节点单击事件 */
function handleNodeClick(data) {
  // 收集当前节点及其所有子节点的ID
  const dormIds = collectDormIds(data)
  
  if (dormIds.length === 1) {
    // 如果只有一个ID（叶子节点），直接设置
    queryParams.value.dormId = dormIds[0]
  } else {
    // 如果有多个ID（父节点），清空单个宿舍ID筛选，使用列表查询时会在后端进行特殊处理
    queryParams.value.dormId = null
    queryParams.value.dormIds = dormIds
  }
  
  handleQuery()
}

/**
 * 收集节点及其所有子节点的ID
 * @param {Object} node 树节点
 * @returns {Array} ID数组
 */
function collectDormIds(node) {
  const ids = []
  
  // 添加当前节点ID
  if (node.id) {
    ids.push(node.id)
  }
  
  // 递归添加子节点ID
  if (node.children && node.children.length > 0) {
    node.children.forEach(child => {
      ids.push(...collectDormIds(child))
    })
  }
  
  return ids
}

/** 宿舍树过滤 */
function filterNode(value, data) {
  if (!value) return true
  return data.label.indexOf(value) !== -1
}

/** 监听宿舍名称变化 */
watch(dormName, val => {
  proxy.$refs.dormTreeRef.filter(val)
})

getDormTree()
getList()
</script>
