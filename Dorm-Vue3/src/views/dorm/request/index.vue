<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="工单编号" prop="requestNo">
        <el-input
          v-model="queryParams.requestNo"
          placeholder="请输入工单编号"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="报修学生ID" prop="studentId">
        <el-input
          v-model="queryParams.studentId"
          placeholder="请输入报修学生ID"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="宿舍ID" prop="dormId">
        <el-input
          v-model="queryParams.dormId"
          placeholder="请输入宿舍ID"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="报修项目" prop="specialty">
        <el-select v-model="queryParams.specialty" placeholder="请选择报修项目" clearable>
          <el-option
            v-for="dict in dorm_repairer_specialty"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="报修人" prop="reporterName">
        <el-input
          v-model="queryParams.reporterName"
          placeholder="请输入报修人"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="联系方式" prop="contactPhone">
        <el-input
          v-model="queryParams.contactPhone"
          placeholder="请输入联系方式"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option
            v-for="dict in repair_request_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="创建时间" prop="createTime">
        <el-date-picker clearable
          v-model="queryParams.createTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择创建时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="更新时间" prop="updateTime">
        <el-date-picker clearable
          v-model="queryParams.updateTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择更新时间">
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
          v-hasPermi="['dorm:request:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['dorm:request:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['dorm:request:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['dorm:request:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table
      v-loading="loading"
      :data="requestList"
      @selection-change="handleSelectionChange"
      @sort-change="handleSortChange"
    >
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="工单ID" align="center" prop="requestId" />
      <el-table-column label="工单编号" align="center" prop="requestNo" />
      <el-table-column label="报修学生ID" align="center" prop="studentId" />
      <el-table-column label="宿舍ID" align="center" prop="dormId" />
      <el-table-column label="报修项目" align="center" prop="specialty">
        <template #default="scope">
          <dict-tag :options="dorm_repairer_specialty" :value="scope.row.specialty"/>
        </template>
      </el-table-column>
      <el-table-column label="问题描述" align="center" prop="description" />
      <el-table-column label="报修人" align="center" prop="reporterName" />
      <el-table-column label="联系方式" align="center" prop="contactPhone" />
      <el-table-column label="图片URL" align="center" prop="images" />
      <el-table-column label="状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="repair_request_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="200" sortable="custom">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="更新时间" align="center" prop="updateTime" width="200" sortable="custom">
        <template #default="scope">
          <span>{{ parseTime(scope.row.updateTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['dorm:request:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['dorm:request:remove']">删除</el-button>
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

    <!-- 添加或修改报修工单对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="requestRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="工单编号" prop="requestNo">
          <el-input v-model="form.requestNo" placeholder="请输入工单编号" />
        </el-form-item>
        <el-form-item label="报修学生ID" prop="studentId">
          <el-input v-model="form.studentId" placeholder="请输入报修学生ID" />
        </el-form-item>
        <el-form-item label="宿舍ID" prop="dormId">
          <el-input v-model="form.dormId" placeholder="请输入宿舍ID" />
        </el-form-item>
        <el-form-item label="报修项目" prop="specialty">
          <el-select v-model="form.specialty" placeholder="请选择报修项目">
            <el-option
              v-for="dict in dorm_repairer_specialty"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="问题描述" prop="description">
          <el-input v-model="form.description" type="textarea" placeholder="请输入内容" />
        </el-form-item>
        <el-form-item label="报修人" prop="reporterName">
          <el-input v-model="form.reporterName" placeholder="请输入报修人" />
        </el-form-item>
        <el-form-item label="联系方式" prop="contactPhone">
          <el-input v-model="form.contactPhone" placeholder="请输入联系方式" />
        </el-form-item>
        <!-- <el-form-item label="图片URL，多个以逗号分隔" prop="images">
          <el-input v-model="form.images" type="textarea" placeholder="请输入内容" />
        </el-form-item> -->
        <el-form-item label="状态" prop="status">
          <el-select v-model="form.status" placeholder="请选择状态">
            <el-option
              v-for="dict in repair_request_status"
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

<script setup name="Request">
import { listRequest, getRequest, delRequest, addRequest, updateRequest } from "@/api/dorm/request"

const { proxy } = getCurrentInstance()
const { repair_request_status, dorm_repairer_specialty } = proxy.useDict('repair_request_status', 'dorm_repairer_specialty')

const requestList = ref([])
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
    requestNo: null,
    studentId: null,
    dormId: null,
    specialty: null,
    description: null,
    reporterName: null,
    contactPhone: null,
    images: null,
    status: null,
    createTime: null,
    updateTime: null,
    orderByColumn: 'create_time',
    isAsc: 'desc',
  },
  rules: {
    requestNo: [
      { required: true, message: "工单编号不能为空", trigger: "blur" }
    ],
    dormId: [
      { required: true, message: "宿舍ID不能为空", trigger: "blur" }
    ],
    specialty: [
      { required: true, message: "报修项目不能为空", trigger: "change" }
    ],
    reporterName: [
      { required: true, message: "报修人不能为空", trigger: "blur" }
    ],
    contactPhone: [
      { required: true, message: "联系方式不能为空", trigger: "blur" }
    ],
    status: [
      { required: true, message: "状态不能为空", trigger: "change" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询报修工单列表 */
function getList() {
  loading.value = true
  listRequest(queryParams.value).then(response => {
    requestList.value = response.rows
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
    requestId: null,
    requestNo: null,
    studentId: null,
    dormId: null,
    specialty: null,
    description: null,
    reporterName: null,
    contactPhone: null,
    images: null,
    status: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null
  }
  proxy.resetForm("requestRef")
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
  ids.value = selection.map(item => item.requestId)
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
  title.value = "添加报修工单"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _requestId = row.requestId || ids.value
  getRequest(_requestId).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改报修工单"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["requestRef"].validate(valid => {
    if (valid) {
      if (form.value.requestId != null) {
        updateRequest(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addRequest(form.value).then(() => {
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
  const _requestIds = row.requestId || ids.value
  proxy.$modal.confirm('是否确认删除报修工单编号为"' + _requestIds + '"的数据项？').then(function() {
    return delRequest(_requestIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('dorm/request/export', {
    ...queryParams.value
  }, `request_${new Date().getTime()}.xlsx`)
}

getList()
</script>
