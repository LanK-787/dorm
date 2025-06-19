<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="工单ID" prop="requestId">
        <el-input
          v-model="queryParams.requestId"
          placeholder="请输入工单ID"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="工单编号" prop="requestNo">
        <el-input
          v-model="queryParams.requestNo"
          placeholder="请输入工单编号"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="维修人员ID" prop="repairerId">
        <el-input
          v-model="queryParams.repairerId"
          placeholder="请输入维修人员ID"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="维修人员姓名" prop="repairerName">
        <el-input
          v-model="queryParams.repairerName"
          placeholder="请输入维修人员姓名"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="维修项目" prop="specialty">
        <el-select v-model="queryParams.specialty" placeholder="请选择维修项目" clearable>
          <el-option
            v-for="dict in dorm_repairer_specialty"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="分配时间" prop="assignTime">
        <el-date-picker clearable
          v-model="queryParams.assignTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择分配时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="处理状态" prop="processStatus">
        <el-select v-model="queryParams.processStatus" placeholder="请选择处理状态" clearable>
          <el-option
            v-for="dict in process_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="接单时间" prop="acceptTime">
        <el-date-picker clearable
          v-model="queryParams.acceptTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择接单时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="完成时间" prop="completeTime">
        <el-date-picker clearable
          v-model="queryParams.completeTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择完成时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="拒绝时间" prop="rejectTime">
        <el-date-picker clearable
          v-model="queryParams.rejectTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择拒绝时间">
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
          v-hasPermi="['dorm:assignment:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['dorm:assignment:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['dorm:assignment:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['dorm:assignment:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table
      v-loading="loading"
      :data="assignmentList"
      @selection-change="handleSelectionChange"
      @sort-change="handleSortChange"
    >
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="分配ID" align="center" prop="assignmentId" />
      <el-table-column label="工单ID" align="center" prop="requestId" />
      <el-table-column label="工单编号" align="center" prop="requestNo" />
      <el-table-column label="维修人员ID" align="center" prop="repairerId" />
      <el-table-column label="维修人员姓名" align="center" prop="repairerName" />
      <el-table-column label="维修项目" align="center" prop="specialty">
        <template #default="scope">
          <dict-tag :options="dorm_repairer_specialty" :value="scope.row.specialty"/>
        </template>
      </el-table-column>
      <el-table-column label="分配时间" align="center" prop="assignTime" width="200" sortable="custom">
        <template #default="scope">
          <span>{{ parseTime(scope.row.assignTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="处理状态" align="center" prop="processStatus">
        <template #default="scope">
          <dict-tag :options="process_status" :value="scope.row.processStatus"/>
        </template>
      </el-table-column>
      <el-table-column label="接单时间" align="center" prop="acceptTime" width="200">
        <template #default="scope">
          <span>{{ parseTime(scope.row.acceptTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="完成时间" align="center" prop="completeTime" width="200">
        <template #default="scope">
          <span>{{ parseTime(scope.row.completeTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="拒绝时间" align="center" prop="rejectTime" width="200">
        <template #default="scope">
          <span>{{ parseTime(scope.row.rejectTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="拒绝原因" align="center" prop="rejectReason" />
      <el-table-column label="图片URL，多个以逗号分隔，用于完成维修后图片上传" align="center" prop="images" />
      <el-table-column label="处理备注" align="center" prop="processRemark" />
      <el-table-column label="创建时间" align="center" prop="createTime" width="200" sortable="custom">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="更新时间" align="center" prop="updateTime" width="200">
        <template #default="scope">
          <span>{{ parseTime(scope.row.updateTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['dorm:assignment:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['dorm:assignment:remove']">删除</el-button>
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

    <!-- 添加或修改工单分配对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="assignmentRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="维修项目" prop="specialty">
          <el-select v-model="form.specialty" placeholder="请选择维修项目">
            <el-option
              v-for="dict in dorm_repairer_specialty"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="处理备注" prop="processRemark">
          <el-input v-model="form.processRemark" type="textarea" placeholder="请输入内容" />
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

<script setup name="Assignment">
import { listAssignment, getAssignment, delAssignment, addAssignment, updateAssignment } from "@/api/dorm/assignment"

const { proxy } = getCurrentInstance()
const { process_status, dorm_repairer_specialty } = proxy.useDict('process_status', 'dorm_repairer_specialty')

const assignmentList = ref([])
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
    requestId: null,
    requestNo: null,
    repairerId: null,
    repairerName: null,
    specialty: null,
    assignTime: null,
    processStatus: null,
    acceptTime: null,
    completeTime: null,
    rejectTime: null,
    rejectReason: null,
    images: null,
    processRemark: null,
    orderByColumn: 'create_time',
    isAsc: 'desc',
  },
  rules: {
    requestId: [
      { required: true, message: "工单ID不能为空", trigger: "blur" }
    ],
    requestNo: [
      { required: true, message: "工单编号不能为空", trigger: "blur" }
    ],
    repairerId: [
      { required: true, message: "维修人员ID不能为空", trigger: "blur" }
    ],
    repairerName: [
      { required: true, message: "维修人员姓名不能为空", trigger: "blur" }
    ],
    specialty: [
      { required: true, message: "维修项目不能为空", trigger: "change" }
    ],
    assignTime: [
      { required: true, message: "分配时间不能为空", trigger: "blur" }
    ],
    processStatus: [
      { required: true, message: "处理状态不能为空", trigger: "change" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询工单分配列表 */
function getList() {
  loading.value = true
  listAssignment(queryParams.value).then(response => {
    assignmentList.value = response.rows
    total.value = response.total
    loading.value = false
  }).catch(error => {
    console.error('获取工单分配列表失败:', error)
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
    assignmentId: null,
    requestId: null,
    requestNo: null,
    repairerId: null,
    repairerName: null,
    specialty: null,
    assignTime: null,
    processStatus: null,
    acceptTime: null,
    completeTime: null,
    rejectTime: null,
    rejectReason: null,
    images: null,
    processRemark: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null
  }
  proxy.resetForm("assignmentRef")
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef")
  // 恢复默认排序
  queryParams.value.orderByColumn = 'create_time'
  queryParams.value.isAsc = 'desc'
  handleQuery()
}

// 多选框选中数据
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.assignmentId)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 排序变更处理 */
function handleSortChange({ prop, order }) {
  if (!prop) {
    // 清除排序，恢复默认排序（按创建时间降序）
    queryParams.value.orderByColumn = 'create_time'
    queryParams.value.isAsc = 'desc'
  } else {
    // 设置排序字段和顺序
    queryParams.value.orderByColumn = prop === 'createTime' ? 'create_time' :
                                     prop === 'assignTime' ? 'assign_time' :
                                     prop === 'acceptTime' ? 'accept_time' :
                                     prop === 'completeTime' ? 'complete_time' :
                                     prop === 'rejectTime' ? 'reject_time' :
                                     prop === 'updateTime' ? 'update_time' : prop
    queryParams.value.isAsc = order === 'ascending' ? 'asc' : 'desc'
  }

  // 重新查询数据
  queryParams.value.pageNum = 1
  getList()
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = "添加工单分配"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _assignmentId = row.assignmentId || ids.value
  getAssignment(_assignmentId).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改工单分配"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["assignmentRef"].validate(valid => {
    if (valid) {
      if (form.value.assignmentId != null) {
        updateAssignment(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addAssignment(form.value).then(() => {
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
  const _assignmentIds = row.assignmentId || ids.value
  proxy.$modal.confirm('是否确认删除工单分配编号为"' + _assignmentIds + '"的数据项？').then(function() {
    return delAssignment(_assignmentIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('dorm/assignment/export', {
    ...queryParams.value
  }, `assignment_${new Date().getTime()}.xlsx`)
}

getList()
</script>
