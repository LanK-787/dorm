<template>
  <view class="about-container">
    <view class="header-section text-center">
      <image style="width: 150rpx;height: 150rpx;" src="/static/logo200.png" mode="widthFix">
      </image>
      <uni-title type="h2" title="智慧宿舍管理系统移动端"></uni-title>
    </view>

    <view class="content-section">
      <view class="menu-list">
        <view class="list-cell list-cell-arrow">
          <view class="menu-item-box">
            <view>版本信息</view>
            <view class="text-right">v{{version}}</view>
          </view>
        </view>
        <view class="list-cell list-cell-arrow">
          <view class="menu-item-box">
            <view>官方邮箱</view>
            <view class="text-right">ruoyi@xx.com</view>
          </view>
        </view>
        <view class="list-cell list-cell-arrow">
          <view class="menu-item-box">
            <view>服务热线</view>
            <view class="text-right">400-999-9999</view>
          </view>
        </view>
        <view class="list-cell list-cell-arrow">
          <view class="menu-item-box">
            <view>公司网站</view>
            <view class="text-right">
              <uni-link :href="url" :text="url" showUnderLine="false"></uni-link>
            </view>
          </view>
        </view>
      </view>
    </view>

    <view class="copyright">
      <view>Copyright &copy; 2025 ruoyi.vip All Rights Reserved.</view>
    </view>
  </view>
</template>

<script>
  export default {
    data() {
      // 安全获取全局配置，避免 globalData 未初始化时报错
      const getGlobalConfig = () => {
        const app = getApp()
        if (app && app.globalData && app.globalData.config && app.globalData.config.appInfo) {
          return app.globalData.config.appInfo
        }
        // 如果 globalData 未初始化，返回默认配置
        return {
          site_url: "http://ruoyi.vip",
          version: "1.1.0"
        }
      }
      const appInfo = getGlobalConfig()
      return {
        url: appInfo.site_url,
        version: appInfo.version
      }
    }
  }
</script>

<style lang="scss" scoped>
  page {
    background-color: #f8f8f8;
  }

  .copyright {
    margin-top: 50rpx;
    text-align: center;
    line-height: 60rpx;
    color: #999;
  }

  .header-section {
    display: flex;
    padding: 30rpx 0 0;
    flex-direction: column;
    align-items: center;
  }
</style>
