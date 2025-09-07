<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="对应报警设备ID" prop="deviceId">
        <el-input
          v-model="queryParams.deviceId"
          placeholder="请输入对应报警设备ID"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="房间ID" prop="dormId">
        <el-input
          v-model="queryParams.dormId"
          placeholder="请输入房间ID"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="告警时烟雾值" prop="smokeValue">
        <el-input
          v-model="queryParams.smokeValue"
          placeholder="请输入告警时烟雾值"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="告警等级" prop="alarmLevel">
        <el-input
          v-model="queryParams.alarmLevel"
          placeholder="请输入告警等级"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="告警时间" prop="alarmTime">
        <el-date-picker clearable
          v-model="queryParams.alarmTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择告警时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="是否处理" prop="handled">
        <el-select v-model="queryParams.handled" placeholder="请选择是否处理" clearable>
          <el-option
            v-for="dict in dorm_alarm_state"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="处理时间" prop="handledTime">
        <el-date-picker clearable
          v-model="queryParams.handledTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择处理时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="备注" prop="remarks">
        <el-input
          v-model="queryParams.remarks"
          placeholder="请输入备注"
          clearable
          @keyup.enter="handleQuery"
        />
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
          v-hasPermi="['dorm:alarms:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['dorm:alarms:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['dorm:alarms:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['dorm:alarms:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="alarmsList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="报警ID" align="center" prop="alarmId" />
      <el-table-column label="设备ID" align="center" prop="deviceId" />
      <el-table-column label="房间ID" align="center" prop="dormId" />
      <el-table-column label="告警时烟雾值" align="center" prop="smokeValue" />
      <el-table-column label="告警等级" align="center" prop="alarmLevel">
        <template #default="scope">
          <dict-tag :options="dorm_alarm_level" :value="scope.row.alarmLevel"/>
        </template>
      </el-table-column>
      <el-table-column label="告警时间" align="center" prop="alarmTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.alarmTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="是否处理" align="center" prop="handled">
        <template #default="scope">
          <dict-tag :options="dorm_alarm_state" :value="scope.row.handled"/>
        </template>
      </el-table-column>
      <el-table-column label="处理时间" align="center" prop="handledTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.handledTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="处理人" align="center" prop="handler" />
      <el-table-column label="备注" align="center" prop="remarks" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['dorm:alarms:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['dorm:alarms:remove']">删除</el-button>
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

    <!-- 添加或修改报警记录对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="alarmsRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="对应报警设备ID" prop="deviceId">
          <el-input v-model="form.deviceId" placeholder="请输入对应报警设备ID" />
        </el-form-item>
        <el-form-item label="房间ID" prop="dormId">
          <el-input v-model="form.dormId" placeholder="请输入房间ID" />
        </el-form-item>
        <el-form-item label="告警等级" prop="alarmLevel">
          <el-input v-model="form.alarmLevel" placeholder="请输入告警等级" />
        </el-form-item>
        <el-form-item label="告警时间" prop="alarmTime">
          <el-date-picker clearable
            v-model="form.alarmTime"
            type="date"
            value-format="YYYY-MM-DD"
            placeholder="请选择告警时间">
          </el-date-picker>
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

<script setup name="Alarms">
import { listAlarms, getAlarms, delAlarms, addAlarms, updateAlarms } from "@/api/dorm/alarms"

const { proxy } = getCurrentInstance()
const { dorm_alarm_state } = proxy.useDict('dorm_alarm_state')

const alarmsList = ref([])
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
    deviceId: null,
    dormId: null,
    smokeValue: null,
    alarmLevel: null,
    alarmTime: null,
    handled: null,
    handledTime: null,
    remarks: null
  },
  rules: {
    deviceId: [
      { required: true, message: "对应报警设备ID不能为空", trigger: "blur" }
    ],
    dormId: [
      { required: true, message: "房间ID不能为空", trigger: "blur" }
    ],
    smokeValue: [
      { required: true, message: "告警时烟雾值不能为空", trigger: "blur" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询报警记录列表 */
function getList() {
  loading.value = true
  listAlarms(queryParams.value).then(response => {
    alarmsList.value = response.rows
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
    alarmId: null,
    deviceId: null,
    dormId: null,
    smokeValue: null,
    alarmLevel: null,
    alarmTime: null,
    handled: null,
    handledTime: null,
    handler: null,
    remarks: null
  }
  proxy.resetForm("alarmsRef")
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
  ids.value = selection.map(item => item.alarmId)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = "添加报警记录"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _alarmId = row.alarmId || ids.value
  getAlarms(_alarmId).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改报警记录"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["alarmsRef"].validate(valid => {
    if (valid) {
      if (form.value.alarmId != null) {
        updateAlarms(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addAlarms(form.value).then(response => {
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
  const _alarmIds = row.alarmId || ids.value
  proxy.$modal.confirm('是否确认删除报警记录编号为"' + _alarmIds + '"的数据项？').then(function() {
    return delAlarms(_alarmIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('dorm/alarms/export', {
    ...queryParams.value
  }, `alarms_${new Date().getTime()}.xlsx`)
}

getList()
</script>
