import { defineStore } from "pinia"
import { getStudentInfo } from "@/api/dorm/student"

const useStudentStore = defineStore('studentStore', {
  state: () => {
    return {
      // 当前学生信息
      currentStudent: null,
      // 加载状态
      loading: false
    }
  },

  getters: {
    // 获取当前学生信息
    getCurrentStudent: (state) => state.currentStudent,

    // 获取加载状态
    getLoading: (state) => state.loading
  },

  actions: {
    // 设置加载状态
    setLoading(loading) {
      this.loading = loading
    },

    // 获取学生详情
    async fetchStudentDetail() {
      try {
        this.setLoading(true)
        const response = await getStudentInfo()

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

    // 清空当前学生信息
    clearCurrentStudent() {
      this.currentStudent = null
    }
  }
})

export default useStudentStore