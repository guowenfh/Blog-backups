title: React 项目构建
date: 2019-04-11 12:00:00
tags: [react,webpack]
categories: [构建]
---

> 在很久之前在知乎回答过一个问题：[公司要求统一一套前端脚手架，该怎么选择？](https://www.zhihu.com/question/263620922/answer/273687900) 在那个时候推荐了使用了魔改 `vue-cli@2` 来实现 `react` 的基础脚手架，让 `react` 以及 `vue` 能够基本使用同一个模式的脚手架。
> 在之后也将他开源了出来：[vue-cli-react-base 最基础的实现](https://github.com/guowenfh/vue-cli-react-base/tree/base)

 <!-- more -->
## 思考

在之前开源版本 `vue-cli-react-base` 的实现中只完成了和 `create-react-app` 构建出来的一样包含 react 运行最基础的功能。

最近回过头再再看，也一直在思考，一个面向于**企业内部**的项目脚手架到底有什么样的需求？

是如同 `vue-cli@2` 和 `create-react-app` 一样的嘛？只实现最基础的功能，所有的扩展（路由，数据管理，ui 库，目录结构约定），都交给开发者去完成。

感觉并不够。

还是如同 [umijs](https://umijs.org/zh/guide/) 或者 [nextjs](https://nextjs.org/docs/) 一样？开箱即用，有约定式路由，代码自动分割，在预定义的同时也支持 自定义扩展 `webpack` 配置达到用户的需求。

这样好像还不错。拿过来直接就可以开发项目了。

但是 他们的自定义扩展 `webpack` 真的足够方便吗？他们本身带来的学习成本呢？

基于这种思考，我开始尝试的去做这样一个事情。 把 `vue-cli-react-base` 一个基本完整的项目开发骨架给搭建起来。


于是最近开始基于他进行了一些改造。

如下：

## vue-cli-react-base

> [vue-cli-react-base github](https://github.com/guowenfh/vue-cli-react-base/)
> 使用 vue-cli@2 驱动的 react 项目
> 使用 webpack@4 + babel@7 + (css/less module) + prettier 来构建

支持 module.css / module.less 等 css module 语法，推荐使用 `npm i -S classnames` 库来更好的使用 css module

内置了 `husky` 与 `eslint-config-standard` 与 `prettier-eslint` 来运行 `git commit` 时代码的自动格式化。自动格式化 使用了 `standard` 的代码风格

状态管理工具方面使用 `@rematch` , 并且内置了插件 `@rematch/immer` 以及 `@rematch/loading`

具体使用方式参考: [Rematch实践指南](https://rematch.gitbook.io/handbook/cha-jian)

内置了组件库 `antd` 结合 `babel-plugin-import` 做了组件（`lodash`也可以）的按需引入 (直接修改 `src/theme.js` 可以修改主题色)。当然要用别的组件库也是可行的，需要改的东西很少不是嘛？

使用 `react-router-config` 来达到和 `vue-router` 类似的体验。

结合 `react-loadable` 与 `import()` 实现了路由的按需加载

`package.json` 使用了 `~` 版本，来尽量保证安装时依赖升级导致项目报错问题

对于 `mock` 数据的需求，使用`npm run dev-mock`启动服务，实现了两种途径的mock数据：
1. 直接 `webpack-dev-server` 提供的 `proxyTable`
2. 使用本地 `mock` 数据，在 `mocker`文件夹下，修改添加即可， 或者使用 `easymock` 这样类似的在线 mock 服务，基于这样的需求实现了一个 `apiProxy` 的高阶函数，提供了本地mock的支持，当然他也能够比较方便的进行各种需求的改造。

```js
/**
 * 拦截请求函数，只在 开发并且开启了mock的情况下启用
 * @param {Function} fn
 * @returns {fn}
 */
const apiProxy = fn => {
  if (process.env.NODE_ENV === 'development' && process.env.mock === true) {
    return function(url, data = {}, otherOptions = {}) {
      return import('../mocker/index').then(({ default: mocker }) => {
      // 如果未找到 mock 对应的数据的情况依旧走老代码
        if (!mocker[url]) {
          return fn.call(this, url, data, otherOptions)
        }
        const isFn = typeof mocker[url] === 'function'
        // 如果是一个函数那么一定要返回 Promise
        if (isFn) {
          return mocker[url](data)
        }
        // 其他情况，直接使用Promsie返回值
        return mocker[url]
      })
    }
  }
  return function(...args) {
    return fn.apply(this, args)
  }
}
```

上面就是对于企业内部项目脚手架思考的一些产出，不过又在想是不是，整个 webapck 所有的配置全部都被暴露了出来，和 目前 `create-react-app` 以及 `vue-cli@3` 的设计思路感觉还是不太相符啊，隐藏实现细节，暴露更改接口。能在底层升级的情况下，无需改动（大部分时候）上层业务的接口修改

基于这样的思考又结合上面的实现 于是又有了另外一个项目：

## cra-config-create-app

> [cra-config-create-app](https://github.com/guowenfh/cra-config-create-app)
> 一个基于 create-react-app 和 react-app-rewired 开箱即用的一个基础项目骨架。
> 本项目想法源自于 既希望能直接享受到 cra 带来的可升级的机制，
> 又能够和 vue-cli@2 一样支持一些基础的配置项，
> 于是利用 react-app-rewired 和 环境变量 的支持 把部分选项直接写成了配置项。
> 支持直接修改配置项使用。

具体已经实现的功能和 上面的项目是一致的，但是这个能够享受到 create-react-app 升级 带来的一些特性和优化支持。（比如 create-react-app 快发布 3.0了。。）

当需要写入使用的全局环境变量时，需使用 `process.env.REACT_APP_XXX = xxx` 形式才能拿到。 （只支持字符串）

使用 `%REACT_APP_XXX%` 方式获取

已经支持的配置如下： `cra-config/config.js`

```js
 {
  alias: {
    '@': resolveApp('src')
  },
  // 开发环境
  dev: {
    /**
     * 是否启用 https 的构建
     * 修改 host， port 等。
     * 如果 process.env.xxx 有对应的值，那么会覆盖这里的配置
     */
    HTTPS: false,
    HOST: '0.0.0.0',
    PORT: 5000,
    /**
     s* 在 webpack 中 是否启用 eslint 检查
     */
    useEslint: true,
    /**
     * 是否自动打开浏览器
     */
    autoOpenBrowser: true,
    /**
     * 本地服务器代理的配置
     */
    proxyTable: {}
  },
  // 构建正式
  build: {
    /**
     * 在 webpack 中 是否启用 eslint 检查
     */
    useEslint: false,
    /**
     * 构建时打包文件夹
     */
    appBuild: resolveApp('dist'),
    /**
     * 是否启用 sourcemap
     */
    productionSourceMap: false
  }
}
```


整体文章说得比较散，因为对于企业内部，一个完备靠谱的的上线项目来说，仅仅是上面提到的点，感觉还是远远不够的，发布部署流程，分支合并策略。函数命名规范，甚至函数体的最大行数等等。

这让我想起了某一次听到 月影 说的一句话：框架的出现，不是让能力强的人写出来更好的代码，而是让能力没那么好的人，能够写出来没那么差的代码。

加油共勉！
