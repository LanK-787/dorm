<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="学号" prop="studentNo">
        <el-input
          v-model="queryParams.studentNo"
          placeholder="请输入学号"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="离校时间" prop="leaveTime">
        <el-date-picker clearable
          v-model="queryParams.leaveTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择离校时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="预计返校时间" prop="expectedReturnTime">
        <el-date-picker clearable
          v-model="queryParams.expectedReturnTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择预计返校时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="实际返校时间" prop="actualReturnTime">
        <el-date-picker clearable
          v-model="queryParams.actualReturnTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择实际返校时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="离校原因" prop="leaveReason">
        <el-input
          v-model="queryParams.leaveReason"
          placeholder="请输入离校原因"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="目的地" prop="destination">
        <el-input
          v-model="queryParams.destination"
          placeholder="请输入目的地"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="离校期间联系电话" prop="contactDuringLeave">
        <el-input
          v-model="queryParams.contactDuringLeave"
          placeholder="请输入离校期间联系电话"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="紧急联系人" prop="emergencyContact">
        <el-input
          v-model="queryParams.emergencyContact"
          placeholder="请输入紧急联系人"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="紧急联系人电话" prop="emergencyPhone">
        <el-input
          v-model="queryParams.emergencyPhone"
          placeholder="请输入紧急联系人电话"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option
            v-for="dict in leave_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="审批人" prop="approver">
        <el-input
          v-model="queryParams.approver"
          placeholder="请输入审批人"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="审批时间" prop="approveTime">
        <el-date-picker clearable
          v-model="queryParams.approveTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择审批时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="审批状态" prop="approveStatus">
        <el-select v-model="queryParams.approveStatus" placeholder="请选择审批状态" clearable>
          <el-option
            v-for="dict in approve_status"
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
          v-hasPermi="['dorm:leave:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['dorm:leave:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['dorm:leave:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['dorm:leave:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="leaveList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="离校记录ID" align="center" prop="leaveId" />
      <el-table-column label="学号" align="center" prop="studentNo" />
      <el-table-column label="离校时间" align="center" prop="leaveTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.leaveTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="预计返校时间" align="center" prop="expectedReturnTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.expectedReturnTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="实际返校时间" align="center" prop="actualReturnTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.actualReturnTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="离校原因" align="center" prop="leaveReason" />
      <el-table-column label="目的地" align="center" prop="destination" />
      <el-table-column label="离校期间联系电话" align="center" prop="contactDuringLeave" />
      <el-table-column label="紧急联系人" align="center" prop="emergencyContact" />
      <el-table-column label="紧急联系人电话" align="center" prop="emergencyPhone" />
      <el-table-column label="状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="leave_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="审批人" align="center" prop="approver" />
      <el-table-column label="审批时间" align="center" prop="approveTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.approveTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="审批状态" align="center" prop="approveStatus">
        <template #default="scope">
          <dict-tag :options="approve_status" :value="scope.row.approveStatus"/>
        </template>
      </el-table-column>
      <el-table-column label="审批备注" align="center" prop="approveRemark" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['dorm:leave:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['dorm:leave:remove']">删除</el-button>
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

    <!-- 添加或修改学生离校登记对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="leaveRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="学号" prop="studentNo">
          <el-input v-model="form.studentNo" placeholder="请输入学号" />
        </el-form-item>
        <el-form-item label="离校时间" prop="leaveTime">
          <el-date-picker clearable
            v-model="form.leaveTime"
            type="date"
            value-format="YYYY-MM-DD"
            placeholder="请选择离校时间">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="预计返校时间" prop="expectedReturnTime">
          <el-date-picker clearable
            v-model="form.expectedReturnTime"
            type="date"
            value-format="YYYY-MM-DD"
            placeholder="请选择预计返校时间">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="实际返校时间" prop="actualReturnTime">
          <el-date-picker clearable
            v-model="form.actualReturnTime"
            type="date"
            value-format="YYYY-MM-DD"
            placeholder="请选择实际返校时间">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="离校原因" prop="leaveReason">
          <el-input v-model="form.leaveReason" placeholder="请输入离校原因" />
        </el-form-item>
        <el-form-item label="目的地" prop="destination">
          <el-input v-model="form.destination" placeholder="请输入目的地" />
        </el-form-item>
        <el-form-item label="离校期间联系电话" prop="contactDuringLeave">
          <el-input v-model="form.contactDuringLeave" placeholder="请输入离校期间联系电话" />
        </el-form-item>
        <el-form-item label="紧急联系人" prop="emergencyContact">
          <el-input v-model="form.emergencyContact" placeholder="请输入紧急联系人" />
        </el-form-item>
        <el-form-item label="紧急联系人电话" prop="emergencyPhone">
          <el-input v-model="form.emergencyPhone" placeholder="请输入紧急联系人电话" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="form.status" placeholder="请选择状态">
            <el-option
              v-for="dict in leave_status"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="审批人" prop="approver">
          <el-input v-model="form.approver" placeholder="请输入审批人" />
        </el-form-item>
        <el-form-item label="审批状态" prop="approveStatus">
          <el-select v-model="form.approveStatus" placeholder="请选择审批状态">
            <el-option
              v-for="dict in approve_status"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="审批备注" prop="approveRemark">
          <el-input v-model="form.approveRemark" placeholder="请输入审批备注" />
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

<script setup name="Leave">
import { listLeave, getLeave, delLeave, addLeave, updateLeave } from "@/api/dorm/leave"

const { proxy } = getCurrentInstance()
const { leave_status, approve_status } = proxy.useDict('leave_status', 'approve_status')

const leaveList = ref([])
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
    studentNo: null,
    leaveTime: null,
    expectedReturnTime: null,
    actualReturnTime: null,
    leaveReason: null,
    destination: null,
    contactDuringLeave: null,
    emergencyContact: null,
    emergencyPhone: null,
    status: null,
    approver: null,
    approveTime: null,
    approveStatus: null,
  },
  rules: {
    studentNo: [
      { required: true, message: "学号不能为空", trigger: "blur" }
    ],
    leaveTime: [
      { required: true, message: "离校时间不能为空", trigger: "blur" }
    ],
    leaveReason: [
      { required: true, message: "离校原因不能为空", trigger: "blur" }
    ],
    emergencyContact: [
      { required: true, message: "紧急联系人不能为空", trigger: "blur" }
    ],
    emergencyPhone: [
      { required: true, message: "紧急联系人电话不能为空", trigger: "blur" },
      { pattern: /^1[3-9]\d{9}$/, message: "请输入正确的手机号码", trigger: "blur" }
    ],
    status: [
      { required: true, message: "状态不能为空", trigger: "change" }
    ],
    approveStatus: [
      { required: true, message: "审批状态不能为空", trigger: "change" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询学生离校登记列表 */
function getList() {
  loading.value = true
  listLeave(queryParams.value).then(response => {
    leaveList.value = response.rows
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
    leaveId: null,
    studentNo: null,
    leaveTime: null,
    expectedReturnTime: null,
    actualReturnTime: null,
    leaveReason: null,
    destination: null,
    contactDuringLeave: null,
    emergencyContact: null,
    emergencyPhone: null,
    status: null,
    approver: null,
    approveTime: null,
    approveStatus: null,
    approveRemark: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null
  }
  proxy.resetForm("leaveRef")
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
  ids.value = selection.map(item => item.leaveId)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = "添加学生离校登记"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _leaveId = row.leaveId || ids.value
  getLeave(_leaveId).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改学生离校登记"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["leaveRef"].validate(valid => {
    if (valid) {
      if (form.value.leaveId != null) {
        updateLeave(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addLeave(form.value).then(response => {
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
  const _leaveIds = row.leaveId || ids.value
  proxy.$modal.confirm('是否确认删除学生离校登记编号为"' + _leaveIds + '"的数据项？').then(function() {
    return delLeave(_leaveIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('dorm/leave/export', {
    ...queryParams.value
  }, `leave_${new Date().getTime()}.xlsx`)
}

getList()
</script>
