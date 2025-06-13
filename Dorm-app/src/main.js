import { createSSRApp } from 'vue'
import uviewPlus from 'uview-plus'
import App from './App.vue'
import store from "@/store";
import plugins from '@/plugins'
import config from '@/config'

export function createApp() {
  const app = createSSRApp(App)
  app.use(store)
  app.use(plugins)
  app.use(uviewPlus)

  // 挂载全局配置
  app.config.globalProperties.$config = config

  return {
    app,
  }
}
