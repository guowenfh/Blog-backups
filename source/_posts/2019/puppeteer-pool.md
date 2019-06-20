title: 使用 generic-pool 优化 puppeteer 并发问题
date: 2019-06-16 22:44:19
tags: [字体,node,nodejs,JS,puppeteer]
categories: [前端技术,node,nodejs,puppeteer]
---

> 这个篇文章产生时间应该是在一年前的。。由于最近组里进了很多新小伙伴，写下这篇文章算是补一个介绍吧。
> 
> 在17年的 D2 百度的小姐姐分享的话题 《打造前端复杂应用》时有提到利用服务端产生图片来导出 脑图和 h5 图片的问题，正好那段时间也正在做这个方向的探索 于是有 《[一次canvas中文字转化成图片后清晰度丢失的探索](https://blog.guowenfh.com/2018/03/05/2018/canvas-text-to-image-clarity/) 》这篇文章的产生。里面提到了 在之前 我使用了 phantomjs 来解决服务端页面渲染的问题。当然后面我们改成了 puppeteer。由于其实都是虚拟浏览器，两者都遇到了浏览器复用的问题。

<!--more-->
## 背景

首先 对于 puppeteer 到底是一个什么样的工具在这里我不过过多的赘述。你就把他当成一个可以在服务端无界面情况下运行的一个完整 chrome 就行了。我们可以利用他模拟用户在浏览器上的几乎所有操作。当然也包括网页渲染 和截图。<br />比如我之前写的  [geek-time-topdf](https://github.com/guowenfh/geek-time-topdf)  之前基于 puppeteer 实现的一个 node.js cli 工具，可以将你购买的极客时间课程打印成 PDF （由于极客时间网页版现在已经挺好用 ，并且改版，现已经没维护了。不过还是可以参考，这里只是说一下可以这么用）

我们现在其实就是利用 puppeteer + node.js 构建了一个 http 服务。那么必然我们不可能每一次请求都去产生一个 puppeteer 实例。（来一个请求就打开一个chrome。这本身就是一个非常消耗性能的行为。（ps：想象一下你在电脑上点开的每一个链接都会打开一个新的浏览器。用完然后你又把它关掉。如此往复）)。当然你本身也做不到。因为当你 启动了一定数量的 puppeteer 实例之后 ，自己就报 EventEmitter 达到上限的错了。<br />当然你可能还是无法避免的想要启动更多实例怎么办呢?

```javascript
const { EventEmitter } = require('events')
EventEmitter.defaultMaxListeners = 30 // 修改 EventEmitter 的上限
```


## 使用 链接池

好了上面废话了那么多，进入正题。 既然我们说了那么多 不可能每一次都启动和关闭一个 puppeteer 实例。 那么今天我们的主角  [generic-pool](https://github.com/coopernurse/node-pool)  就要出场了。

这是一个基于 Promise 的通用链接池库。有了他之后我们就可以 将 puppeteer 实例放在我们的链接池中，如果有请求进来，那么就去池子里面去取一个实例。我们可以设置实例的上限，和常驻池中的实例数量。（一个任务队列，超过上限时自动排队。）然后你拿到这个实例之后就可以去进行和普通创建实例一样的操作了。（性能对比图这里就不给出了，提升还是非常巨大的，可以自行尝试。）

具体的使用可以在 github 查看这里就不多聊了。我们直接基于我们目前的一个启动创建配置来进行一个讲解。（算了，讲解就直接写在代码注释里了。） -_-!

puppeteer-pool.js

```javascript
'use strict'
const puppeteer = require('puppeteer')
const genericPool = require('generic-pool')

/**
 * 初始化一个 Puppeteer 池
 * @param {Object} [options={}] 创建池的配置配置
 * @param {Number} [options.max=10] 最多产生多少个 puppeteer 实例 。如果你设置它，请确保 在引用关闭时调用清理池。 pool.drain().then(()=>pool.clear())
 * @param {Number} [options.min=1] 保证池中最少有多少个实例存活
 * @param {Number} [options.maxUses=2048] 每一个 实例 最大可重用次数，超过后将重启实例。0表示不检验
 * @param {Number} [options.testOnBorrow=2048] 在将 实例 提供给用户之前，池应该验证这些实例。
 * @param {Boolean} [options.autostart=false] 是不是需要在 池 初始化时 初始化 实例
 * @param {Number} [options.idleTimeoutMillis=3600000] 如果一个实例 60分钟 都没访问就关掉他
 * @param {Number} [options.evictionRunIntervalMillis=180000] 每 3分钟 检查一次 实例的访问状态
 * @param {Object} [options.puppeteerArgs={}] puppeteer.launch 启动的参数
 * @param {Function} [options.validator=(instance)=>Promise.resolve(true))] 用户自定义校验 参数是 取到的一个实例
 * @param {Object} [options.otherConfig={}] 剩余的其他参数 // For all opts, see opts at https://github.com/coopernurse/node-pool#createpool
 * @return {Object} pool
 */
const initPuppeteerPool = (options = {}) => {
  const {
    max = 10,
    min = 2,
    maxUses = 2048,
    testOnBorrow = true,
    autostart = false,
    idleTimeoutMillis = 3600000,
    evictionRunIntervalMillis = 180000,
    puppeteerArgs = {},
    validator = () => Promise.resolve(true),
    ...otherConfig
  } = options

  const factory = {
    create: () =>
      puppeteer.launch(puppeteerArgs).then(instance => {
        // 创建一个 puppeteer 实例 ，并且初始化使用次数为 0
        instance.useCount = 0
        return instance
      }),
    destroy: instance => {
      instance.close()
    },
    validate: instance => {
      // 执行一次自定义校验，并且校验校验 实例已使用次数。 当 返回 reject 时 表示实例不可用
      return validator(instance).then(valid => Promise.resolve(valid && (maxUses <= 0 || instance.useCount < maxUses)))
    }
  }
  const config = {
    max,
    min,
    testOnBorrow,
    autostart,
    idleTimeoutMillis,
    evictionRunIntervalMillis,
    ...otherConfig
  }
  const pool = genericPool.createPool(factory, config)
  const genericAcquire = pool.acquire.bind(pool)
  // 重写了原有池的消费实例的方法。添加一个实例使用次数的增加
  pool.acquire = () =>
    genericAcquire().then(instance => {
      instance.useCount += 1
      return instance
    })
  pool.use = fn => {
    let resource
    return pool
      .acquire()
      .then(r => {
        resource = r
        return resource
      })
      .then(fn)
      .then(
        result => {
          // 不管业务方使用实例成功与后都表示一下实例消费完成
          pool.release(resource)
          return result
        },
        err => {
          pool.release(resource)
          throw err
        }
      )
  }
  return pool
}
```

如何使用：

```javascript
const pool = initPuppeteerPool({ // 全局只应该被初始化一次
    puppeteerArgs: {
      ignoreHTTPSErrors: true,
      headless: false, // 是否启用无头模式页面
      timeout: 0,
      pipe: true, // 不使用 websocket 
    }
})
// 在业务中取出实例使用
const page = await pool.use(instance=>{
	const page = await instance.newPage()
	await page.goto('http://xxx.xxx', { timeout: 120000 })
	// do XXX ...
    return page
})
// do XXX ...

// 应该在服务重启或者关闭时执行
//pool.drain().then(() => pool.clear())

```

可以看到我们在 基于[generic-pool](https://github.com/coopernurse/node-pool) 的情况下构建了一个 Puppeteer 的池。每一次请求进来之后 我们调用 `pool.use` 去取得一个实例。然后去进行我们后续的操作就可以了。

整体流程如下：在服务启动时启动池。
请求到达->从池中取得一个 Puppeteer 实例->打开tab页->运行代码->关闭tab页->返回数据（其他的管理都交给池了）

比如简述一下我们目前运行代码的业务流程：
1. 拿到 json 数据把 canvas 页面渲染出来 （前端页面渲染流程，配置与渲染分离，只有在渲染的一刻才知道最终产生的数据是什么。
2. 渲染页面与 Puppeteer 交互。拿到处理后的 json 
3. 拿到截图的配置参数
4. 使用 Puppeteer Page api 截图。
5. 对产生的 图片 buffer 做格式转化（调用 imagemagick（一个跨平台图像处理库） 等处理图片）
6. 数据上传 阿里 oss
7. 异步通知其他端处理已经结束。

然后我们再仔细看配置中的 `maxUses` 可以看到我们自定义扩展了每一个 Puppeteer  最多可以被使用的次数（防止实例变卡什么的）来防止一些意外情况出现。

其实我们之所以需要一个池其中一个问题主要就是处理性能问题。。这一部分其实在在业务代码中也需要处理。下面简单说几个点。

1. Puppeteer 什么样的启动参数对服务性能有提升？
2. 在截图时选什么样的参数能在达到业务要求的情况下尽可能的提升性能？
3. 是产生图片在本地？还是直接拿到 图片 buffer 去和第三方服务对接？
4. 有没有可能把业务处理流程进行步骤拆分？让 Puppeteer 承担的工作少一些？

那我们有了一个 Puppeteer 的池，实现复用 Puppeteer 实例。那么如何更好的去实现一个 http 服务呢？


## 结合 egg.js

egg.js 是蚂蚁金服出品的一个企业级 node.js 框架。可以高效的搭建一个可用的 http 服务，其他介绍自行官网查看。具体我这里就不多介绍了。

这里简单说一下怎么结合 puppeteer-pool 在一起使用 核心其实就是 创建 `app.js`  做初始化处理。

```javascript
const initPuppeteerPool = require('./util/puppeteer-pool')
const { EventEmitter } = require('events')
EventEmitter.defaultMaxListeners = 30
class AppBootHook {
  constructor(app) {
    this.app = app
  }
  async didLoad() {
    // 所有的配置已经加载完毕
    // 可以用来加载应用自定义的文件，启动自定义的服务
    this.app.pool = initPuppeteerPool()
  }
  async beforeClose() {
    if (this.app.pool.drain) {
      await this.app.pool.drain().then(() => this.app.pool.clear())
    }
  }
}
module.exports = AppBootHook
```

server.js

```javascript
const Service = require('egg').Service
class ScreenshotService extends Service {
    renderPage(url) {
        const { app, config } = this
        const imageBuffer = await app.pool.use(async instance => {
            // 1. 创建一个新窗口
            const page = await instance.newPage()
            await page.goto(url, { timeout: 120000 })
            // 2. 截图参数，截图
            const buf = await page.screenshot({ ...imgOutOption, clip: opt })
            return buf
        })
        return imageBuffer
    }
}
```


## 说一下 Puppeteer 使用到的坑

这里说三个 Puppeteer 使用上的坑吧：

1. 可以看到第 5 点：由于我们的场景对于图片清晰度要求很高，所以发现了这个问题。（Puppeteer 导出 png 再调用 imagemagick 转成jpg ,也比直接使用 Puppeteer 导出 jpg 清晰度高（即便清晰度设置成了100 -_- !））
2. Puppeteer 无法截图产生超过 65535 的图。（当然 imagemagick 也无法处理超过这个的图。（这个是一个挺有意思的事情。有兴趣的可以去搜索这个数看看
3. Puppeteer@1.12.2 之后的版本 单张截图超过 6000（不确定值，但是确实会出问题，因为出现问题就没升级了）有一定概率导致 图片部分区域为空白。

## 后续/扩展

> 这是目前未处理的部分。


其实可以看到我们在上面的处理实现了多个 Puppeteer 实例的复用，但是其中也有一个问题，那就是其实我们在这样的情况下使用每一次请求过来只会利用一个 浏览器 窗口，那么我们的 QPS 直接与我们新建的 Puppeteer 实例上限挂钩（配置中的 max 属性），当然还有单个任务的处理时间。（当然在我们内部的业务场景没啥问题（长度过长，图片太多。然后还要处理图片。cpu早100%了）

能不能在实例池的基础上，再创建一个单实例的窗口池呢？ （因为实际上我们真正操作的内容 其实都是 Puppeteer 的 Page ）这部分是还没做的，就交给你们去实现了


参考链接：
- [Puppeteer 性能优化与执行速度提升](https://blog.it2048.cn/article-puppeteer-speed-up/)
- [phantomJs 池](https://github.com/binded/phantom-pool)