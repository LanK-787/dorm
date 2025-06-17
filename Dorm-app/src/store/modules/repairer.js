import { defineStore } from 'pinia'
import { getRepairerByUserId } from '@/api/manage/repairer'

const useRepairerStore = defineStore('repairerStore', {
  state: () => {
    return {
      // 当前维修人员信息
      currentRepairer: null,
      // 加载状态
      loading: false
    }
  },

  getters: {
    // 获取当前维修人员信息
    getCurrentRepairer: (state) => state.currentRepairer,

    // 获取加载状态
    getLoading: (state) => state.loading,

    // 检查是否有维修人员数据
    hasRepairerData: (state) => state.currentRepairer !== null
  },

  actions: {
    // 设置加载状态
    setLoading(loading) {
      this.loading = loading
    },

    // 根据用户ID获取维修人员详情
    async fetchRepairerByUserId(userId) {
      try {
        this.setLoading(true)
        const response = await getRepairerByUserId(userId)

        if (response.code === 200) {
          this.currentRepairer = response.data
          return response.data
        } else {
          // 如果没有找到维修人员数据，设置为null
          this.currentRepairer = null
          return null
        }
      } catch (error) {
        console.error('获取维修人员详情失败:', error)
        this.currentRepairer = null
        throw error
      } finally {
        this.setLoading(false)
      }
    },

    // 设置当前维修人员信息
    setCurrentRepairer(repairer) {
      this.currentRepairer = repairer
    },

    // 清空当前维修人员信息
    clearCurrentRepairer() {
      this.currentRepairer = null
    }
  },

  // 配置持久化
  persist: {
    key: 'repairerStore',
    storage: {
      getItem: (key) => {
        try {
          return uni.getStorageSync(key)
        } catch (error) {
          console.error('获取维修人员存储数据失败:', error)
          return null
        }
      },
      setItem: (key, value) => {
        try {
          uni.setStorageSync(key, value)
        } catch (error) {
          console.error('保存维修人员存储数据失败:', error)
        }
      },
      removeItem: (key) => {
        try {
          uni.removeStorageSync(key)
        } catch (error) {
          console.error('删除维修人员存储数据失败:', error)
        }
      }
    },
    // 指定需要持久化的状态字段
    paths: ['currentRepairer'],
    // 在状态恢复后进行数据处理
    afterRestore: (context) => {
      console.log('维修人员状态恢复完成')
      if (context.store.currentRepairer) {
        console.log('已恢复维修人员信息:', context.store.currentRepairer.name)
      }
    }
  }
})

export default useRepairerStore
