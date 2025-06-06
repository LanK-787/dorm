/// <reference types='@dcloudio/types' />
import { ComponentCustomProperties } from 'vue'

declare module '@vue/runtime-core' {
  interface ComponentCustomProperties {
    /**
     * 组件类型
     */
    mpType?: string;
  }
}

declare global {
  type Hooks = App.AppInstance & Page.PageInstance;
}
