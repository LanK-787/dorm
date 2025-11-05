<script setup>
import {getCurrentInstance} from "vue"
import { onLaunch } from '@dcloudio/uni-app'
import './permission'
import pagesJson from './pages.json'
import config from "@/config";
import {getToken} from "@/utils/auth"; // permission

const {proxy} = getCurrentInstance()

onLaunch(() => {
  initApp()
})
function initApp(){
  initConfig()
  //#ifdef H5
  checkLogin()
  //#endif
}
function initConfig(){
  // 使用 getApp() 获取全局实例，确保 globalData 正确初始化
  const app = getApp()
  if (!app.globalData) {
    app.globalData = {}
  }
  app.globalData.config = config
  app.globalData.pages = pagesJson
}
function checkLogin() {
  if (!getToken()) {
    proxy.$tab.reLaunch('/pages/login')
  }
}
</script>

<style lang="scss">
@import "uview-plus/index.scss";
@import '@/static/scss/index.scss';
</style>
