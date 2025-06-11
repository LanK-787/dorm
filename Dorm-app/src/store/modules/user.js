import { defineStore } from 'pinia'
import config from '@/config'
import { getToken, setToken, removeToken } from '@/utils/auth'
import { login, logout, getInfo } from '@/api/login'

const baseUrl = config.baseUrl

const useUserStore = defineStore('userStore', {
  state: () => ({
    token: getToken(),
    id: '',
    name: '',
    avatar: '',
    roles: [],
    permissions: []
  }),

  actions: {
    // 登录
    Login(userInfo) {
      const username = userInfo.username.trim()
      const password = userInfo.password
      const code = userInfo.code
      const uuid = userInfo.uuid
      return new Promise((resolve, reject) => {
        login(username, password, code, uuid).then(res => {
          setToken(res.token)
          this.token = res.token
          resolve()
        }).catch(error => {
          reject(error)
        })
      })
    },

    // 获取用户信息
    GetInfo() {
      return new Promise((resolve, reject) => {
        getInfo().then(res => {
          const user = res.user

          // 处理头像URL - 检查是否已经是完整URL
          let avatar
          if (user == null || user.avatar == "" || user.avatar == null) {
            // 使用默认头像的静态路径
            avatar = "/static/images/profile.jpg"
          } else if (user.avatar.startsWith('http://') || user.avatar.startsWith('https://')) {
            // 如果已经是完整URL，直接使用
            avatar = user.avatar
          } else {
            // 如果是相对路径，则拼接baseUrl
            avatar = baseUrl + user.avatar
          }

          const username = (user == null || user.userName == "" || user.userName == null)
            ? ""
            : user.userName

          if (res.roles && res.roles.length > 0) {
            this.roles = res.roles
            this.permissions = res.permissions
          } else {
            this.roles = ['ROLE_DEFAULT']
          }

          this.id = user.userId
          this.name = username
          this.avatar = avatar
          resolve(res)
        }).catch(error => {
          reject(error)
        })
      })
    },
    // 退出系统
    LogOut() {
      return new Promise((resolve, reject) => {
        logout(this.token).then(() => {
          this.token = ''
          this.id = ''
          this.name = ''
          this.avatar = ''
          this.roles = []
          this.permissions = []
          removeToken()
          resolve()
        }).catch(error => {
          reject(error)
        })
      })
    },

    // 设置头像
    setAvatar(avatar) {
      // 检查传入的avatar是否已经是完整URL
      if (avatar.startsWith('http://') || avatar.startsWith('https://')) {
        this.avatar = avatar
      } else {
        // 如果是相对路径，则拼接baseUrl
        this.avatar = baseUrl + avatar
      }
    }
  },

  // 配置持久化
  persist: {
    key: 'userStore',
    storage: {
      getItem: (key) => {
        try {
          return uni.getStorageSync(key)
        } catch (error) {
          console.error('获取用户存储数据失败:', error)
          return null
        }
      },
      setItem: (key, value) => {
        try {
          uni.setStorageSync(key, value)
        } catch (error) {
          console.error('保存用户存储数据失败:', error)
        }
      },
      removeItem: (key) => {
        try {
          uni.removeStorageSync(key)
        } catch (error) {
          console.error('删除用户存储数据失败:', error)
        }
      }
    },
    // 指定需要持久化的状态字段
    paths: ['id', 'name', 'avatar', 'roles', 'permissions'],
    // 在状态恢复后进行数据处理
    afterRestore: (context) => {
      console.log('用户状态恢复完成')
      if (context.store.name) {
        console.log('已恢复用户信息:', context.store.name)
      }
    }
  }
})

export default useUserStore
