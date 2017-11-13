title: 浅谈 electron 中的 session 管理（隔离）
date: 2017-10-21 22:51:51
tags: [HTML,electron]
categories: [前端技术]
---

> 已经有很长一段时间没有产出博客了。
> 一. 是因为花了很多时间去专研业务，能够做到目前的基本业务流程理清，大致了然于胸（导致了一个问题：有人找我解决问题，我可能会先问一句，你的需求是什么？）
> 二. 确实是自己这一段时间确实懈怠了，每天上班回去就不想敲代码了，看看剧，看看小说，刷刷微博。虽然在组内有过一些分享，整理过一些东西，但是却没有将其在博客产出了。
> 这样的情况，让我明显的感觉到自己的成长速度相对于第一年成长的速度，慢了几个等级。这让我有一种危机感，于是克服这种懈怠，跳出舒适区，继续强健自己。重新回归吧。
> 最后。还是引用这个博客的描述："兴趣遍地都是，专注和坚持才是真正稀缺的。"

不多说了，开始吧。

## 基础介绍

> 由于公司的项目内部调整，有幸接触 2 个星期的 electron 开发。（然后我又被拥抱变化了。。）实现了一个多账号的切换，并且同时对于多账号的聊天窗口做一个浏览器 tab 的集成的需求，这里对于接触到的知识点，做一个总结。以免完全忘记(忽略代码规范，我自己都看不下去)

[electron-中文文档](https://wizardforcel.gitbooks.io/electron-doc/content/faq/electron-faq.html)

<!--more-->


在我加入项目之前，壳就已经搭好了，我只是在之上去开发。然而我接触时间太短，然后就撤离了，只能说一些我看到的和用到的部分。（ 其它存在的问题, 比如：安全，目前没有更多的精力去解决）

了解之后，最开始的项目搭建是使用的 [electron-quick-start](https://github.com/electron/electron-quick-start) 来快速的构建出 一个 electron 客户端的项目。


由于项目需要快速迭代和试错。也没有使用大多数客户端项目将所有资源存在本地，然后再去更新本地资源的形式，而是在客户端暴露 sdk 的情况下 直接 load 了一个 远程地址

```js
const electron = require('electron')
const {BrowserWindow} = electron
const path = require('path')
let mainWindow = new BrowserWindow({
    width: 1280,
    height: 768,
    icon: path.resolve(__dirname ,'./build/icon.png'),
    title:'客户端',
    webPreferences: {
      webSecurity: false,
      allowRunningInsecureContent: true,
      preload: path.resolve(path.join(__dirname, './common/sdk.js'))
    }
})
mainWindow.loadURL('https://baidu.com',{extraHeaders: 'pragma: no-cache\n'})
```

SDK 部分，实际上也没有做太多的封装，直接就暴露出来了。
大概是下面这些

- [electron-json-storage](https://github.com/electron-userland/electron-json-storage)
- [node-notifier](https://github.com/mikaelbr/node-notifier)
- [superagent](https://github.com/visionmedia/superagent)

```js
{
const storage = require('electron-json-storage');   // 缓存
const notifier = require('node-notifier')           // 通知功能
const charset = require('superagent-charset');
const request = charset(require('superagent'));     // HTTP
}
```

关于此项目 electron 暴露出来的内容，我能聊的大致就是这些了。至于图标，打包成可安装文件，客户端快捷键的设置，并没有太认真的去看，不过应该在网上多搜索，是能找到答案的。 [electron-github-issues](https://github.com/electron/electron/issues) 实际上能解决绝大多数的问题。

## session 模块

> 关于 [electron session](https://wizardforcel.gitbooks.io/electron-doc/content/api/session.html) 模块，就和文档中的描述一致，session 模块可以用来创建一个新的 Session 对象，然后 有 `session.fromPartition(partition)` 进行自定义的设置。
你也可以通过使用 webContents 的属性 session 来使用一个已有页面的 session (webContents 是 BrowserWindow 的属性.)

在经过实际的测试发现，在主进程之外无法直接使用`electron.session` 来获取到 session 对象：`{ defaultSession: [Getter], fromPartition: [Function] }`

所以在最后，我只能是通过  webContents 中的 session 来处理。

当然就算是这样，也有很多解决方案，但是我目前使用了我认为最简单的一个。直接修改 本地所有的 cookies。

### 在 BrowserWindow 中

在文档中发现 可以直接在用 BrowserWindow 是可以直接通过 webPreferences 参数来对于 session 进行最初的设置的。

- `webPreferences` 参数是个对象，它的属性:
    - `session Session` - 设置界面 session. 而不是直接忽略 session 对象 , 也可用 partition 来代替, 它接受一个 partition 字符串. 当同时使用 session 和 partition , session 优先级更高. 默认使用默认 session .
    - `partition String` - 通过 session 的 partition 字符串来设置界面 session. 如果 partition 以 persist: 开头, 这个界面将会为所有界面使用相同的 partition. 如果没有 persist: 前缀, 界面使用历史 session. 通过分享同一个 partition, 所有界面使用相同的 session. 默认使用默认 session.

### 在 webview 中

```html
<webview src="https://github.com" partition="persist:github"></webview>
<webview src="http://electron.atom.io" partition="electron"></webview>
```

在 webview 中同样支持 partition 的设置。规则同上。

但是除此之外 webview 也同样提供了一个方法 `<webview>.getWebContents()`去获取 到 webview 所属的 webContents。 这样的话，我们也可以直接使用它 session 的属性进行处理

<!-- 但是我接手到的并不是一个全新的项目，也不能推倒重新来过，在做切换时，并不能从这里突破（登陆还是会用到的。）。
 -->

## 店铺切换

### 登陆窗口

首先我们需要去创建出一个登陆窗口去让用户把账号给添加到目前的登陆流程中来。然后通过回调函数，将一个必要信息传到主窗口做登陆完成的处理（或者是使用 ipcMain EventEmitter 形式，最终只是需要拿到值。）

```js
{
    /**
     * 创建一个 登录 的窗口。
     * 用于 session 隔离
     * Promise 中有  {partition,userinfo,cookies}
     * @returns Promise
     */
    function createLoginWin(partition){
        partition = partition || `persist:${Math.random()}`;
        const charset = require('superagent-charset');
        const request = charset(require('superagent'));     // HTTP
        let BrowserWindow = new require('electron').remote.BrowserWindow;
        let presWindow = new BrowserWindow({
            width: 1280,
            height: 768,
            title:'用户登陆',
            webPreferences: {
              webSecurity: false,
              allowRunningInsecureContent: true,
              partition
            }
        });
        let webContents = presWindow.webContents;
        return new Promise(function(resove,reject){
            // webContents.openDevTools();
            presWindow.loadURL('http://taobao.com/#/login');
            webContents.on("did-navigate-in-page", function() {
                // 这里可以看情况进行参数的传递，获取制定的 cookies
                webContents.session.cookies.get({},function(err,cookies){
                    if(err){
                        presWindow.close(); // 关闭登陆窗口
                        return reject(err);
                    }
                    // 这一步并不是必需的。
                    request
                    .get('http://taobao.com/userinfo')
                    .query({ _: Date.now() }) // query string
                    .set("Cookie", cookies.map(item=>`${item.name}=${item.value};`).join(' '))
                    .end(function(err,res){
                        presWindow.close();
                        if(err) {return reject(err);}
                        if(!res || !res.body || !res.body.result !== 1){
                            return reject(res.body)
                        }
                        let obj = { partition,cookies,userinfo:res.body.data}
                        resove(obj);
                    })
                })
            });
        })
    }
}
```

至于信息的存储的话，是使用了 electron-json-storage 将用户的值存储到本地。这里可以随意。

### 切换用户

上面只是创建了新用户登录的窗口。那么对于旧有的（目前登录）用户信息，做一个初始化同步存储下来的操作。（保持结构一致，（除了 `partition` 不存在之外））为了后续的 使用方便，可以封装几个对于当前窗口 cookies 操作的函数

```js
const cookies =  {
    getCurrCookies(params={}){
        let currWin = require('electron').remote.getCurrentWindow();
        let currSession = currWin.webContents.session;
        return new Promise((resove,reject)=>{
            currSession.cookies.get(Object.assign({},params),function(err,cookies){
                if(err){return reject(err);}
                resove(cookies);
            })
        })
    },
    removeCurrCookies(cookies = []){
        let currWin = require('electron').remote.getCurrentWindow();
        let currSession = currWin.webContents.session;
        let err = [];
        let apiCount = 0;
        return new Promise((resove,reject)=>{
            cookies.forEach(item=>{
                currSession.cookies.remove(`http://${item.domain}`,item.name ,function(err){
                    if(err){return err.push(err);}
                    apiCount = apiCount + 1;
                })
                if(err.length === apiCount){
                    resove({message:'cookie 清除成功'});
                }else{
                    reject(err);
                }
            })
        })
    },
    setCurrCookies(cookies = []){
        let currWin = require('electron').remote.getCurrentWindow();
        let currSession = currWin.webContents.session;
        let err = [];
        let apiCount = 0;
        return new Promise((resove,reject)=>{
            cookies.forEach(item=>{
                currSession.cookies.set(Object.assign({},item,{
                    url:`http://${item.domain}`,
                    name:item.name
                }),function(err){
                    if(err){
                        return err.push(err)
                    }
                    apiCount = apiCount + 1;
                })
                if(err.length === apiCount){
                    resove({message:'cookie 设置成功！'});
                }else{
                    reject(err);
                }
            })
        })
    }
}
```

有了这几个函数。结合我们上面，将用户登录信息保存下来的部分，切换店铺就变得异常简单了。

流程如下：

获取当前 --> 清除当前 --> 获取目标 --> 设置当前 --> 重新载入


## 多 webview 聊天窗口

先来上一个截图。

![](https://ws4.sinaimg.cn/large/006tKfTcgy1fkq9cead1tj30l20aw75e.jpg)

在我的使用中，直接将聊天窗口创建出来，一个新的 BrowserWindow ，html 中会创建多个 webview

```js
function openChatTool(data=[]){
    // 需要打开的聊天窗口集合，里面会有我们在上面存下来的信息
    let random = Math.random();
    let BrowserWindow = new require('electron').remote.BrowserWindow;
    let presWindow = new BrowserWindow({
        width: 1280,
        height: 768,
        title:'聊天窗口',
        webPreferences: {
          webSecurity: false,
          allowRunningInsecureContent: true,
        }
    });
    // presWindow.webContents.openDevTools();
    presWindow.loadURL(`http://${location.host}/chat.html?v=${Math.random()}`);
    presWindow.webContents.on('did-finish-load', function() {
        // 使用了 send 方法在线程中进行信息传递，在 chat.html 中 可以使用 ipcRenderer接受 如：electron.ipcRenderer.on('chatList',()=>{})
        presWindow.webContents.send('chatList', data);
    });
}
```
chat.html 中 tab 切换的部分在此直接略过

```js
const electron = require('electron');
electron.ipcRenderer.on('chatList', function(event, data) {
    console.log(data);
    const webview = document.createElement('webview');
    webview.allowpopups = true;
    webview.disablewebsecurity = true;
    webview.className = index == 0 ? 'active' : '';
    // 直接使用 之前存下来的 partition，是最简单的形式
    // 当然也可以不使用这个，在下面的事件中 session.cookies.set 将 cookie 设置进去
    webview.partition = item.partition || `persist:${Math.random()}`;
    webview.src="http://chat.com";
    document.body.appendChild(webview);
    webview.addEventListener('did-finish-load',function(event){
        let webviewContents = webview.getWebContents();
        if(webview.getURL()=='http://chat.com/index'){
            webviewContents.webContents.session.cookies.get({},function(err,cookies){
                // 处理登录失效。重新登录的逻辑。还需要结合别的事件来处理
                // 这里可以直接拿到 webview 内的 session 信息
                // 代码略
                // 可以在外部插入代码
                webview.executeJavaScript(`console.log(11)`,()=>{ console.log('insert dom success')})
            })
        }
    })
})

```

这样需求就搞定了，但是实际上我用到的只是非常少的一部分，并且完成的也不算好。 单单是一个 session 模块中的东西我也还有很多没有去详细的尝试和理解的。不过这个需求整体下来，感觉 electron 还是非常有趣的。只不过接触的时间还太短，没有挖掘出更多有好玩的东西，要是之后有了时间，可以考虑用他写一个自己的应用吧。



