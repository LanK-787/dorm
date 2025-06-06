<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="公告标题" prop="noticeTitle">
        <el-input
          v-model="queryParams.noticeTitle"
          placeholder="请输入公告标题"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="公告类型" prop="noticeType" style="width: 250px;">
        <el-select v-model="queryParams.noticeType" placeholder="请选择公告类型" clearable>
          <el-option
            v-for="dict in dorm_notice_type"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status" style="width: 250px;">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option
            v-for="dict in sys_notice_status"
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
          v-hasPermi="['dorm:notices:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['dorm:notices:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['dorm:notices:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['dorm:notices:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="noticesList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="公告ID" align="center" prop="noticeId" />
      <el-table-column label="公告标题" align="center" prop="noticeTitle" />
      <el-table-column label="公告类型" align="center" prop="noticeType">
        <template #default="scope">
          <dict-tag :options="dorm_notice_type" :value="scope.row.noticeType"/>
        </template>
      </el-table-column>
      <el-table-column label="公告内容" align="center" prop="noticeContent" />
      <el-table-column label="状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="sys_notice_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['dorm:notices:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['dorm:notices:remove']">删除</el-button>
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

    <!-- 添加或修改宿舍公告对话框 -->
    <el-dialog :title="title" v-model="open" width="800px" append-to-body>
      <el-form ref="noticesRef" :model="form" :rules="dynamicRules" label-width="80px">
        <el-form-item label="公告标题" prop="noticeTitle">
          <el-input v-model="form.noticeTitle" placeholder="请输入公告标题" />
        </el-form-item>
        <el-form-item label="公告类型" prop="noticeType">
          <el-select v-model="form.noticeType" placeholder="请选择公告类型">
            <el-option
              v-for="dict in dorm_notice_type"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="公告内容">
          <editor v-model="form.noticeContent" :min-height="300"/>
        </el-form-item>
        <el-form-item label="状态" prop="status" v-if="form.noticeId != null">
          <el-radio-group v-model="form.status">
            <el-radio
              v-for="dict in sys_notice_status"
              :key="dict.value"
              :label="dict.value"
            >{{dict.label}}</el-radio>
          </el-radio-group>
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

<script setup name="Notices">
import { listNotices, getNotices, delNotices, addNotices, updateNotices } from "@/api/dorm/notices"

const { proxy } = getCurrentInstance()
const { sys_notice_status, dorm_notice_type } = proxy.useDict('sys_notice_status', 'dorm_notice_type')

const noticesList = ref([])
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
    noticeTitle: null,
    noticeType: null,
    noticeContent: null,
    status: null,
  },
  rules: {
    noticeTitle: [
      { required: true, message: "公告标题不能为空", trigger: "blur" }
    ],
    noticeType: [
      { required: true, message: "公告类型不能为空", trigger: "change" }
    ],
    noticeContent: [
      { required: true, message: "公告内容不能为空", trigger: "blur" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

// 动态验证规则 - 状态字段只在修改时必填
const dynamicRules = computed(() => {
  const baseRules = { ...rules.value }

  // 如果是修改操作（有noticeId），则添加状态验证规则
  if (form.value.noticeId != null) {
    baseRules.status = [
      { required: true, message: "状态不能为空", trigger: "change" }
    ]
  }

  return baseRules
})

/** 查询宿舍公告列表 */
function getList() {
  loading.value = true
  listNotices(queryParams.value).then(response => {
    noticesList.value = response.rows
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
    noticeId: null,
    noticeTitle: null,
    noticeType: null,
    noticeContent: null,
    status: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null
  }
  proxy.resetForm("noticesRef")
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
  ids.value = selection.map(item => item.noticeId)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = "添加宿舍公告"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _noticeId = row.noticeId || ids.value
  getNotices(_noticeId).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改宿舍公告"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["noticesRef"].validate(valid => {
    if (valid) {
      if (form.value.noticeId != null) {
        updateNotices(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addNotices(form.value).then(() => {
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
  const _noticeIds = row.noticeId || ids.value
  proxy.$modal.confirm('是否确认删除宿舍公告编号为"' + _noticeIds + '"的数据项？').then(function() {
    return delNotices(_noticeIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('dorm/notices/export', {
    ...queryParams.value
  }, `notices_${new Date().getTime()}.xlsx`)
}

getList()
</script>
