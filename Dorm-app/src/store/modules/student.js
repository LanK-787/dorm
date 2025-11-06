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
  },

  // 配置持久化
  persist: {
    key: 'studentStore',
    storage: {
      getItem: (key) => {
        try {
          return uni.getStorageSync(key)
        } catch (error) {
          console.error('获取学生存储数据失败:', error)
          return null
        }
      },
      setItem: (key, value) => {
        try {
          uni.setStorageSync(key, value)
        } catch (error) {
          console.error('保存学生存储数据失败:', error)
        }
      },
      removeItem: (key) => {
        try {
          uni.removeStorageSync(key)
        } catch (error) {
          console.error('删除学生存储数据失败:', error)
        }
      }
    },
    // 指定需要持久化的状态字段
    paths: ['currentStudent'],
    // 在状态恢复后进行数据处理
    afterRestore: (context) => {
      console.log('学生状态恢复完成')
      if (context.store.currentStudent) {
        console.log('已恢复学生信息:', context.store.currentStudent.name)
      }
    }
  }
})

export default useStudentStore