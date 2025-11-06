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
        <!--学生数据-->
        <pane size="84">
          <el-col>
            <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="100px">
              <el-form-item label="学号" prop="studentNo">
                <el-input v-model="queryParams.studentNo" placeholder="请输入学号" clearable style="width: 240px" @keyup.enter="handleQuery" />
              </el-form-item>
              <el-form-item label="学生姓名" prop="name">
                <el-input v-model="queryParams.name" placeholder="请输入学生姓名" clearable style="width: 240px" @keyup.enter="handleQuery" />
              </el-form-item>
              <el-form-item label="手机号码" prop="phone">
                <el-input v-model="queryParams.phone" placeholder="请输入手机号码" clearable style="width: 240px" @keyup.enter="handleQuery" />
              </el-form-item>
              <el-form-item label="班级名称" prop="className">
                <el-input v-model="queryParams.className" placeholder="请输入班级名称" clearable style="width: 240px" @keyup.enter="handleQuery" />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
                <el-button icon="Refresh" @click="resetQuery">重置</el-button>
              </el-form-item>
            </el-form>

            <el-row :gutter="10" class="mb8">
              <el-col :span="1.5">
                <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['dorm:student:add']">新增</el-button>
              </el-col>
              <el-col :span="1.5">
                <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate" v-hasPermi="['dorm:student:edit']">修改</el-button>
              </el-col>
              <el-col :span="1.5">
                <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete" v-hasPermi="['dorm:student:remove']">删除</el-button>
              </el-col>
              <el-col :span="1.5">
                <el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['dorm:student:export']">导出</el-button>
              </el-col>
              <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
            </el-row>

            <el-table v-loading="loading" :data="studentList" @selection-change="handleSelectionChange">
              <el-table-column type="selection" width="55" align="center" />
              <el-table-column label="学号" align="center" prop="studentNo" />
              <el-table-column label="学生姓名" align="center" prop="name" :show-overflow-tooltip="true" />
              <el-table-column label="性别" align="center" prop="gender" width="60">
                <template #default="scope">
                  <dict-tag :options="sys_user_sex" :value="scope.row.gender"/>
                </template>
              </el-table-column>
              <el-table-column label="班级名称" align="center" prop="className" :show-overflow-tooltip="true" />
              <el-table-column label="宿舍全称" align="center" prop="dormFullName" :show-overflow-tooltip="true" />
              <el-table-column label="手机号码" align="center" prop="phone" width="120" />
              <el-table-column label="邮箱地址" align="center" prop="email" :show-overflow-tooltip="true" />
              <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="150">
                <template #default="scope">
                  <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['dorm:student:edit']">修改</el-button>
                  <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['dorm:student:remove']">删除</el-button>
                </template>
              </el-table-column>
            </el-table>
            <pagination v-show="total>0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />
          </el-col>
        </pane>
      </splitpanes>
    </el-row>

    <!-- 添加或修改学生对话框 -->
    <el-dialog :title="title" v-model="open" width="600px" append-to-body>
      <el-form ref="studentRef" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="学号" prop="studentNo">
              <el-input v-model="form.studentNo" placeholder="请输入学号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="学生姓名" prop="name">
              <el-input v-model="form.name" placeholder="请输入学生姓名" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="性别" prop="gender">
              <el-select v-model="form.gender" placeholder="请选择性别" style="width: 100%">
                <el-option
                  v-for="dict in sys_user_sex"
                  :key="dict.value"
                  :label="dict.label"
                  :value="dict.value"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="班级名称" prop="className">
              <el-input v-model="form.className" placeholder="请输入班级名称" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="手机号码" prop="phone">
              <el-input v-model="form.phone" placeholder="请输入手机号码" maxlength="11" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="邮箱地址" prop="email">
              <el-input v-model="form.email" placeholder="请输入邮箱地址" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="系统用户ID" prop="userId">
              <el-input v-model="form.userId" placeholder="请输入系统用户ID" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="宿舍" prop="dormId">
              <el-tree-select v-model="form.dormId" :data="enabledDormOptions" :props="{ value: 'id', label: 'label', children: 'children' }" value-key="id" placeholder="请选择宿舍" check-strictly />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="备注" prop="remark">
              <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" />
            </el-form-item>
          </el-col>
        </el-row>
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

<script setup name="Student">
import { listStudent, getStudent, delStudent, addStudent, updateStudent, dormTreeSelectWithCapacity } from "@/api/dorm/student"
import { Splitpanes, Pane } from "splitpanes"
import useAppStore from '@/store/modules/app'
import "splitpanes/dist/splitpanes.css"
const { proxy } = getCurrentInstance()
const { sys_user_sex } = proxy.useDict("sys_user_sex")

const appStore = useAppStore()
const studentList = ref([])
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
    userId: null,
    studentNo: null,
    name: null,
    gender: null,
    className: null,
    phone: null,
    status: null,
    email: null,
    dormId: null,
  },
  rules: {
    userId: [
      { required: true, message: "系统用户ID → sys_user.user_id不能为空", trigger: "blur" }
    ],
    studentNo: [
      { required: true, message: "学号不能为空", trigger: "blur" }
    ],
    name: [
      { required: true, message: "学生姓名不能为空", trigger: "blur" }
    ],
    status: [
      { required: true, message: "学生状态不能为空", trigger: "change" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询宿舍下拉树结构 */
function getDormTree(currentStudentDormId = null) {
  dormTreeSelectWithCapacity().then(response => {
    dormOptions.value = response.data
    // 统一使用同一个函数处理宿舍选项，传入当前学生宿舍ID（如果有）
    enabledDormOptions.value = processDormOptions(JSON.parse(JSON.stringify(response.data)), currentStudentDormId)
  })
}

/**
 * 统一处理宿舍选项：添加容量信息并设置禁用状态
 * @param {Array} dormList 宿舍列表
 * @param {Number|null} currentStudentDormId 当前学生的宿舍ID（编辑时传入，新增时为null）
 */
function processDormOptions(dormList, currentStudentDormId = null) {
  dormList.forEach(dorm => {
    // 添加容量信息显示
    if (dorm.maxCapacity !== null && dorm.maxCapacity !== undefined) {
      const currentCount = dorm.currentCount || 0
      const maxCapacity = dorm.maxCapacity

      // 确保不重复添加容量信息
      const originalLabel = dorm.label.replace(/\s*\(\d+\/\d+\)$/, '')
      dorm.label = `${originalLabel} (${currentCount}/${maxCapacity})`

      // 设置禁用状态：满员的宿舍禁用，但当前学生的宿舍除外
      if (currentCount >= maxCapacity && maxCapacity > 0) {
        // 如果是当前学生的宿舍，即使满员也不禁用
        dorm.disabled = (dorm.id !== currentStudentDormId)
      } else {
        // 未满员的宿舍不禁用
        dorm.disabled = false
      }
    } else {
      // 没有容量信息的宿舍（如楼栋、楼层）不禁用
      dorm.disabled = false
    }

    // 递归处理子节点
    if (dorm.children && dorm.children.length) {
      processDormOptions(dorm.children, currentStudentDormId)
    }
  })

  return dormList
}

/** 查询学生管理列表 */
function getList() {
  loading.value = true
  listStudent(queryParams.value).then(response => {
    studentList.value = response.rows
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
    studentId: null,
    userId: null,
    studentNo: null,
    name: null,
    gender: null,
    className: null,
    phone: null,
    status: null,
    email: null,
    delFlag: null,
    dormId: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null
  }
  proxy.resetForm("studentRef")
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
  ids.value = selection.map(item => item.studentId)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  // 新增时不传入当前学生宿舍ID，满员宿舍将被禁用
  getDormTree()
  open.value = true
  title.value = "添加学生管理"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _studentId = row.studentId || ids.value
  getStudent(_studentId).then(response => {
    form.value = response.data
    // 传入当前学生的宿舍ID，确保其当前宿舍即使满员也不被禁用
    getDormTree(form.value.dormId)
    open.value = true
    title.value = "修改学生管理"
  })
}

/** 节点单击事件 */
function handleNodeClick(data) {
  queryParams.value.dormId = data.id
  handleQuery()
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["studentRef"].validate(valid => {
    if (valid) {
      if (form.value.studentId != null) {
        updateStudent(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
          // 重新加载宿舍树以更新容量信息（不传入学生ID，恢复正常状态）
          getDormTree()
        }).catch(error => {
          proxy.$modal.msgError(error.response?.data?.msg || "修改失败")
        })
      } else {
        addStudent(form.value).then(() => {
          proxy.$modal.msgSuccess("新增成功")
          open.value = false
          getList()
          // 重新加载宿舍树以更新容量信息
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
  const _studentIds = row.studentId || ids.value
  proxy.$modal.confirm('是否确认删除学生管理编号为"' + _studentIds + '"的数据项？').then(function() {
    return delStudent(_studentIds)
  }).then(() => {
    getList()
    // 重新加载宿舍树以更新容量信息
    getDormTree()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('dorm/student/export', {
    ...queryParams.value
  }, `student_${new Date().getTime()}.xlsx`)
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
