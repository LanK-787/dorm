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
      <el-form-item label="显示顺序" prop="orderNum" style="width: 200px;">
        <el-input
          v-model="queryParams.orderNum"
          placeholder="请输入显示顺序"
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
      <el-table-column label="显示顺序" align="center" prop="orderNum" />
      <el-table-column label="宿管" align="center" prop="dormManager" />
      <el-table-column label="联系电话" align="center" prop="phone" />
      <el-table-column label="邮箱" align="center" prop="email" />
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
          />
        </el-form-item>
        <el-form-item label="宿舍名称" prop="buildingName">
          <el-input v-model="form.buildingName" placeholder="请输入宿舍名称" />
        </el-form-item>
        <el-form-item label="显示顺序" prop="orderNum">
          <el-input v-model="form.orderNum" placeholder="请输入显示顺序" />
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
import { listBuilding, getBuilding, delBuilding, addBuilding, updateBuilding } from "@/api/dorm/building"

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
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询宿舍管理列表 */
function getList() {
  loading.value = true
  listBuilding(queryParams.value).then(response => {
    buildingList.value = proxy.handleTree(response.data, "dormId", "parentId")
    loading.value = false
  })
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
    orderNum: null,
    dormManager: null,
    phone: null,
    email: null,
    status: null,
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
function handleAdd(row) {
  reset()
  getTreeselect()
  if (row != null && row.dormId) {
    form.value.parentId = row.dormId
  } else {
    form.value.parentId = 0
  }
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
function submitForm() {
  proxy.$refs["buildingRef"].validate(valid => {
    if (valid) {
      if (form.value.dormId != null) {
        updateBuilding(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addBuilding(form.value).then(response => {
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
  proxy.$modal.confirm('是否确认删除宿舍管理编号为"' + row.dormId + '"的数据项？').then(function() {
    return delBuilding(row.dormId)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

getList()
</script>
