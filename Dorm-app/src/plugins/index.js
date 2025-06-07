import tab from './tab'
import auth from './auth'
import modal from './modal'

export default {
  install(app) {  // 参数改为 app（Vue 3 的实例）
    // 挂载全局属性
    app.config.globalProperties.$tab = tab
    app.config.globalProperties.$auth = auth
    app.config.globalProperties.$modal = modal
  }
}