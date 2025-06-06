## Ruoyi-APP-No-HbuilderX

## 项目介绍

本项目是将 [(Ruoyi-APP)](https://gitee.com/y_project/RuoYi-App) 改造成为 可以不使用HbuilderX，可以直接使用vscode或者webstrom就可以运行的项目。



## 运行前提

+ 了解node并且已经安装过node (我这边用的是v14.21.3，其他版本未经测试)



## 下载项目

```
git clone --recursive https://gitee.com/qiqi_chen/ruoyi-app-no-hbuilder-x.git
```

（PS1：由于该项目有子仓库，所以必须如命令中一样使用 **--recursive** 也额外拉取了 [(Ruoyi-APP)](https://gitee.com/y_project/RuoYi-App) 的项目，它会被拉取放到src目录下）

（PS2：如果您忘记了在命令中使用 **--recursive** 了，那么此时src文件夹是空的，可以使用以下命令补救,这条命令会将子模块初始化到src目录下）

```
git submodule update --init --recursive
```

(PS3： 如果你执行过带有--recursive的clone命令了，那上面这条命令就不用执行了)

## 环境准备

首先由于网络的原因，npm的下载速度一般，可以先全局设置国内的淘宝镜像，让以后的npm的网络下载请求都可以得到加速

```sh
npm config set registry https://registry.npmmirror.com
```



#### 安装相关依赖

```sh
npm i
```





## 运行服务

```
npm run serve
```

### 
## 打包

命令格式

```
npm run build:%PLATFORM%
```

比如

```
npm run build:h5
```



可以参考后面这个表格

| 值                      | 平台                                                         |
| ----------------------- | ------------------------------------------------------------ |
| app-plus                | app平台生成打包资源（支持npm run build:app-plus，可用于持续集成。不支持run，运行调试仍需在HBuilderX中操作） |
| h5                      | H5                                                           |
| mp-alipay               | 支付宝小程序                                                 |
| mp-baidu                | 百度小程序                                                   |
| mp-weixin               | 微信小程序                                                   |
| mp-toutiao              | 抖音小程序                                                   |
| mp-lark                 | 飞书小程序                                                   |
| mp-qq                   | qq 小程序                                                    |
| mp-360                  | 360 小程序                                                   |
| mp-kuaishou             | 快手小程序                                                   |
| mp-jd                   | 京东小程序                                                   |
| mp-xhs                  | 小红书小程序                                                 |
| quickapp-webview        | 快应用(webview)                                              |
| quickapp-webview-union  | 快应用联盟                                                   |
| quickapp-webview-huawei | 快应用华为                                                   |





## 引用致谢

[若依 / RuoYi-App](https://gitee.com/y_project/RuoYi-App)

[迁移HbuilderX的uniapp项目到主流的前端IDE开发（支持VS Code等编辑器/IDE）](https://zhuanlan.zhihu.com/p/268206071)

[uniapp官网](https://zh.uniapp.dcloud.io/quickstart-cli.html)

[Error: PostCSS plugin autoprefixer requires PostCSS 8.](https://blog.csdn.net/FormAda/article/details/109029274)





