import { defineStore } from "pinia"
import storage from "@/utils/storage"
import {
  listStudent,
  getStudent,
  addStudent,
  updateStudent,
  delStudent,
  dormTreeSelect,
  isStudent,
  isStudentInfoFilled,
  getStudentInfo,
  completeStudentInfo,
  updateStudentInfo
} from "@/api/dorm/student"

const useStudentStore = defineStore('studentStore', {
  state: () => {
    return {
      // 学生列表数据
      studentList: [],
      // 学生总数
      total: 0,
      // 当前学生信息
      currentStudent: null,
      // 当前用户的学生信息
      myStudentInfo: storage.get('myStudentInfo') || null,
      // 是否为学生账号
      isStudentAccount: storage.get('isStudentAccount') || false,
      // 学生信息是否完整
      isInfoComplete: storage.get('isInfoComplete') || false,
      // 宿舍树结构数据
      dormTree: [],
      // 加载状态
      loading: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        studentNo: undefined,
        name: undefined,
        className: undefined,
        phone: undefined,
        gender: undefined,
        dormId: undefined
      }
    }
  },

  getters: {
    // 获取学生列表
    getStudentList: (state) => state.studentList,

    // 获取当前学生信息
    getCurrentStudent: (state) => state.currentStudent,

    // 获取我的学生信息
    getMyStudentInfo: (state) => state.myStudentInfo,

    // 是否为学生账号
    getIsStudentAccount: (state) => state.isStudentAccount,

    // 学生信息是否完整
    getIsInfoComplete: (state) => state.isInfoComplete,

    // 获取宿舍树数据
    getDormTree: (state) => state.dormTree,

    // 获取加载状态
    getLoading: (state) => state.loading,

    // 获取查询参数
    getQueryParams: (state) => state.queryParams,

    // 获取分页信息
    getPagination: (state) => ({
      pageNum: state.queryParams.pageNum,
      pageSize: state.queryParams.pageSize,
      total: state.total
    })
  },

  actions: {
    // 设置加载状态
    setLoading(loading) {
      this.loading = loading
    },

    // 设置查询参数
    setQueryParams(params) {
      this.queryParams = { ...this.queryParams, ...params }
    },

    // 重置查询参数
    resetQueryParams() {
      this.queryParams = {
        pageNum: 1,
        pageSize: 10,
        studentNo: undefined,
        name: undefined,
        className: undefined,
        phone: undefined,
        gender: undefined,
        dormId: undefined
      }
    },

    // 获取学生列表
    async fetchStudentList(params = {}) {
      try {
        this.setLoading(true)
        const queryParams = { ...this.queryParams, ...params }

        const response = await listStudent(queryParams)

        if (response.code === 200) {
          this.studentList = response.rows || []
          this.total = response.total || 0
          this.setQueryParams(queryParams)
          return response
        } else {
          throw new Error(response.msg || '获取学生列表失败')
        }
      } catch (error) {
        console.error('获取学生列表失败:', error)
        throw error
      } finally {
        this.setLoading(false)
      }
    },

    // 获取学生详情
    async fetchStudentDetail(studentId) {
      try {
        this.setLoading(true)
        const response = await getStudent(studentId)

        if (response.code === 200) {
          this.currentStudent = response.data
          return response.data
        } else {
          throw new Error(response.msg || '获取学生详情失败')
        }
      } catch (error) {
        console.error('获取学生详情失败:', error)
        throw error
      } finally {
        this.setLoading(false)
      }
    },

    // 新增学生
    async createStudent(studentData) {
      try {
        this.setLoading(true)
        const response = await addStudent(studentData)

        if (response.code === 200) {
          // 新增成功后刷新列表
          await this.fetchStudentList()
          return response
        } else {
          throw new Error(response.msg || '新增学生失败')
        }
      } catch (error) {
        console.error('新增学生失败:', error)
        throw error
      } finally {
        this.setLoading(false)
      }
    },

    // 更新学生信息
    async updateStudentInfo(studentData) {
      try {
        this.setLoading(true)
        const response = await updateStudent(studentData)

        if (response.code === 200) {
          // 更新成功后刷新列表和当前学生信息
          await this.fetchStudentList()
          if (this.currentStudent && this.currentStudent.studentId === studentData.studentId) {
            this.currentStudent = { ...this.currentStudent, ...studentData }
          }
          return response
        } else {
          throw new Error(response.msg || '更新学生信息失败')
        }
      } catch (error) {
        console.error('更新学生信息失败:', error)
        throw error
      } finally {
        this.setLoading(false)
      }
    },

    // 删除学生
    async deleteStudent(studentId) {
      try {
        this.setLoading(true)
        const response = await delStudent(studentId)

        if (response.code === 200) {
          // 删除成功后刷新列表
          await this.fetchStudentList()
          // 如果删除的是当前学生，清空当前学生信息
          if (this.currentStudent && this.currentStudent.studentId === studentId) {
            this.currentStudent = null
          }
          return response
        } else {
          throw new Error(response.msg || '删除学生失败')
        }
      } catch (error) {
        console.error('删除学生失败:', error)
        throw error
      } finally {
        this.setLoading(false)
      }
    },

    // 批量删除学生
    async batchDeleteStudents(studentIds) {
      try {
        this.setLoading(true)
        const promises = studentIds.map(id => delStudent(id))
        await Promise.all(promises)

        // 批量删除成功后刷新列表
        await this.fetchStudentList()

        // 如果当前学生在删除列表中，清空当前学生信息
        if (this.currentStudent && studentIds.includes(this.currentStudent.studentId)) {
          this.currentStudent = null
        }

        return { code: 200, msg: '批量删除成功' }
      } catch (error) {
        console.error('批量删除学生失败:', error)
        throw error
      } finally {
        this.setLoading(false)
      }
    },

    // 获取宿舍树结构
    async fetchDormTree() {
      try {
        const response = await dormTreeSelect()

        if (response.code === 200) {
          this.dormTree = response.data || []
          return response.data
        } else {
          throw new Error(response.msg || '获取宿舍树结构失败')
        }
      } catch (error) {
        console.error('获取宿舍树结构失败:', error)
        throw error
      }
    },

    // 检测是否为学生账号
    async checkIsStudent(username) {
      try {
        const response = await isStudent(username)

        if (response.code === 200) {
          this.isStudentAccount = response.data
          storage.set('isStudentAccount', response.data)
          return response.data
        } else {
          this.isStudentAccount = false
          storage.set('isStudentAccount', false)
          throw new Error(response.msg || '检测学生账号失败')
        }
      } catch (error) {
        console.error('检测学生账号失败:', error)
        this.isStudentAccount = false
        storage.set('isStudentAccount', false)
        throw error
      }
    },

    // 检测学生信息是否完整
    async checkStudentInfoComplete(username) {
      try {
        const response = await isStudentInfoFilled(username)

        if (response.code === 200) {
          this.isInfoComplete = response.data
          storage.set('isInfoComplete', response.data)
          return response.data
        } else {
          this.isInfoComplete = false
          storage.set('isInfoComplete', false)
          throw new Error(response.msg || '检测学生信息完整性失败')
        }
      } catch (error) {
        console.error('检测学生信息完整性失败:', error)
        this.isInfoComplete = false
        storage.set('isInfoComplete', false)
        throw error
      }
    },

    // 获取当前用户的学生信息
    async fetchMyStudentInfo() {
      try {
        this.setLoading(true)
        const response = await getStudentInfo()

        if (response.code === 200) {
          // 提取需要的字段
          const studentData = {
            studentId: response.data.studentId,
            userId: response.data.userId,
            studentNo: response.data.studentNo,
            name: response.data.name,
            gender: response.data.gender,
            className: response.data.className,
            phone: response.data.phone,
            status: response.data.status,
            email: response.data.email
          }

          // 存储到状态和本地存储
          this.myStudentInfo = studentData
          storage.set('myStudentInfo', studentData)

          console.log('获取学生信息成功:', studentData)
          return studentData
        } else {
          throw new Error(response.msg || '获取学生信息失败')
        }
      } catch (error) {
        console.error('获取学生信息失败:', error)
        this.myStudentInfo = null
        storage.remove('myStudentInfo')
        throw error
      } finally {
        this.setLoading(false)
      }
    },

    // 完善学生信息
    async completeMyStudentInfo(studentData) {
      try {
        this.setLoading(true)
        const response = await completeStudentInfo(studentData)

        if (response.code === 200) {
          this.myStudentInfo = studentData
          this.isInfoComplete = true
          storage.set('myStudentInfo', studentData)
          storage.set('isInfoComplete', true)
          return response
        } else {
          throw new Error(response.msg || '完善学生信息失败')
        }
      } catch (error) {
        console.error('完善学生信息失败:', error)
        throw error
      } finally {
        this.setLoading(false)
      }
    },

    // 更新我的学生信息
    async updateMyStudentInfo(studentData) {
      try {
        this.setLoading(true)
        const response = await updateStudentInfo(studentData)

        if (response.code === 200) {
          this.myStudentInfo = { ...this.myStudentInfo, ...studentData }
          storage.set('myStudentInfo', this.myStudentInfo)
          return response
        } else {
          throw new Error(response.msg || '更新学生信息失败')
        }
      } catch (error) {
        console.error('更新学生信息失败:', error)
        throw error
      } finally {
        this.setLoading(false)
      }
    },

    // 设置我的学生信息
    setMyStudentInfo(studentInfo) {
      this.myStudentInfo = studentInfo
      storage.set('myStudentInfo', studentInfo)
    },

    // 设置学生账号状态
    setIsStudentAccount(isStudent) {
      this.isStudentAccount = isStudent
      storage.set('isStudentAccount', isStudent)
    },

    // 设置学生信息完整状态
    setIsInfoComplete(isComplete) {
      this.isInfoComplete = isComplete
      storage.set('isInfoComplete', isComplete)
    },

    // 清空当前学生信息
    clearCurrentStudent() {
      this.currentStudent = null
    },

    // 清空我的学生信息
    clearMyStudentInfo() {
      this.myStudentInfo = null
      this.isStudentAccount = false
      this.isInfoComplete = false
      storage.remove('myStudentInfo')
      storage.remove('isStudentAccount')
      storage.remove('isInfoComplete')
    },

    // 清空学生列表
    clearStudentList() {
      this.studentList = []
      this.total = 0
    },

    // 重置所有状态
    resetState() {
      this.studentList = []
      this.total = 0
      this.currentStudent = null
      this.myStudentInfo = null
      this.isStudentAccount = false
      this.isInfoComplete = false
      this.dormTree = []
      this.loading = false
      this.resetQueryParams()

      // 清除本地存储
      storage.remove('myStudentInfo')
      storage.remove('isStudentAccount')
      storage.remove('isInfoComplete')
    },

    // 搜索学生
    async searchStudents(searchParams) {
      const params = {
        pageNum: 1,
        pageSize: this.queryParams.pageSize,
        ...searchParams
      }
      return await this.fetchStudentList(params)
    },

    // 分页查询
    async paginateStudents(pageNum, pageSize = this.queryParams.pageSize) {
      const params = {
        ...this.queryParams,
        pageNum,
        pageSize
      }
      return await this.fetchStudentList(params)
    }
  }
})

export default useStudentStore