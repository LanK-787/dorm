<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="所属宿舍/房间ID" prop="dormId">
        <el-input
          v-model="queryParams.dormId"
          placeholder="请输入所属宿舍/房间ID"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="设备名称" prop="deviceName">
        <el-input
          v-model="queryParams.deviceName"
          placeholder="请输入设备名称"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="设备类型，'0'为烟雾报警器" prop="deviceType">
        <el-select v-model="queryParams.deviceType" placeholder="请选择设备类型，'0'为烟雾报警器" clearable>
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
      <el-table-column label="主键，设备ID" align="center" prop="deviceId" />
      <el-table-column label="所属宿舍/房间ID" align="center" prop="dormId" />
      <el-table-column label="设备名称" align="center" prop="deviceName" />
      <el-table-column label="设备类型，'0'为烟雾报警器" align="center" prop="deviceType">
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

    <!-- 添加或修改设备管理对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="deviceRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="所属宿舍/房间ID" prop="dormId">
          <el-input v-model="form.dormId" placeholder="请输入所属宿舍/房间ID" />
        </el-form-item>
        <el-form-item label="设备名称" prop="deviceName">
          <el-input v-model="form.deviceName" placeholder="请输入设备名称" />
        </el-form-item>
        <el-form-item label="设备类型，'0'为烟雾报警器" prop="deviceType">
          <el-select v-model="form.deviceType" placeholder="请选择设备类型，'0'为烟雾报警器">
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

const { proxy } = getCurrentInstance()
const { dorm_device_status, dorm_device } = proxy.useDict('dorm_device_status', 'dorm_device')

const deviceList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    dormId: null,
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
  open.value = true
  title.value = "添加设备管理"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _deviceId = row.deviceId || ids.value
  getDevice(_deviceId).then(response => {
    form.value = response.data
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
        })
      } else {
        addDevice(form.value).then(response => {
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
  const _deviceIds = row.deviceId || ids.value
  proxy.$modal.confirm('是否确认删除设备管理编号为"' + _deviceIds + '"的数据项？').then(function() {
    return delDevice(_deviceIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('dorm/device/export', {
    ...queryParams.value
  }, `device_${new Date().getTime()}.xlsx`)
}

getList()
</script>
