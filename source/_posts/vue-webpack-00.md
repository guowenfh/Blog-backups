title: webpack入坑之旅（零）简介与升级
date: 2018-08-05 18:34:58
tags: [webpack]
categories: [前端框架]
---

## webpack 基础中的基础。

升级了一下两年前写的这个教程，前端变化太快了，里面很多示例已经跑步起来，终于愿意花时间来更新一下了。非常基础！！

记录 vue-webapck 的学习基础，代码示例 [github地址](https://github.com/guowenfh/vue-webpack)

**2018-08-05最新更新： 本教程已升级至 webpack4 ，旧的代码在 webpack1-backup 分支。将原来教程中部分不正确的地方也已经剔除。不过难免还有错误之处，欢迎指正。**

代码示例位于 webpack 文件夹中。已经把所有练习的`node_modules`移除，若要正常使用，请安装运行`npm install #推荐 cnpm `。

然后再根据文中的指令，进行打包、编译等操作。重要的是在运行过程中体会。学习。

教程目录:

- [webpack入坑之旅（一）不是开始的开始](//guowenfh.github.io/2016/03/24/vue-webpack-01-base/)
- [webpack入坑之旅（二）loader入门](//guowenfh.github.io/2016/03/24/vue-webpack-02-deploy/)
- [webpack入坑之旅（三）webpack.config入门](//guowenfh.github.io/2016/03/24/vue-webpack-03-config/)
- [webpack入坑之旅（四）扬帆起航](//guowenfh.github.io/2016/03/24/vue-webpack-04-custom/)
- [webpack入坑之旅（五）加载vue单文件组件](//guowenfh.github.io/2016/03/25/vue-webpack-05-vue/)
- [webpack入坑之旅（六）配合vue-router实现SPA](//guowenfh.github.io/2016/03/28/vue-webpack-06-router/)

----

这个教程更多的是从基础开始学习，vue 与 webpack 应该要怎么结合。在真实的实际项目中，还是推荐 vue-cli。

关于 vue-cli 生成的配置解析可以参考一下 [vue-cli#2.0 webpack 配置分析](https://github.com/DDFE/DDFE-blog/issues/10)

---

## react

对于 **react** 可以考虑使用我基于 vue-cli 生成的配置修改的 react 版本 [vue-cli-react-base](https://github.com/guowenfh/vue-cli-react-base)。

使用 vue-cli 类似的配置与命令，来驱动 react 项目，在 router 分支也有 使用 react + router + antd 的例子


若是有什么地方，没有写对的，也请大家指出，帮忙改进，谢谢！
