title: http 模块
date: 2016-10-15 12:38:52
tags: [nodejs]
categories: [node]
---

一个网站的加载流程粗略的流程大概如下：

1. 用户通过浏览器发送一个http的请求到指定的主机
2. 服务器接收到该请求，对该请求进行分析和处理
3. 服务器处理完成以后，返回对应的数据到用户机器
4. 浏览器接收服务器返回的数据，并根据接收到的进行分析和处理

## 最简单的web服务器

我们需要搭建一个 `http` 的服务器，用于处理用户发送的 `http` 请求，在 node 中有 `http` 核心模块可以在很简单的几句话就帮我们启动一个服务器。
```js
// 导入http模块:
var http = require('http');
// 创建http server，并传入回调函数:
var server = http.createServer(function (request, response) {
    // 回调函数接收request和response对象,
    console.log('有客户端请求了.....');
    // 将HTTP响应200写入response, 同时设置Content-Type: text/html:
    response.writeHead(200, {'Content-Type': 'text/html'});
    // 将HTTP响应的HTML内容写入response:
    response.write('<h1>hello World!</h1>');
    response.end();
});
// 让服务器监听8888端口:
server.listen(8888);
console.log('Server is running at http://127.0.0.1:8888/');
```
就这几行代码，我们就搭建了一个简单服务器，当我们将其运行，访问地址能在浏览器中显示我们熟悉的 `hello World!`,迈出了第一步。

下面我们来看看几个重要的地方：

## 核心方法

### 创建与监听

首先我们来看创建`http server`的代码：

- `var server = http.createServer([requestListener])` :创建并返回一个HTTP服务器对象
 - `requestListener` : 监听到客户端连接的回调函数
在这里可以看到我们的回调函数是可选的，我们还可以使用事件监听器来进行，监听到客户端连接之后的操作,如：
`server.on('request', function(req, res) {// do ....})`
我们要在用户访问时做一些什么，都会在这里。

再看监听端口的代码，在这里我们只是简单的写了一下监听的端口，它的可选项都没有去设置

- `server.listen(port, [hostname], [backlog], [callback])` :监听客户端连接请求,只有当调用了 `listen` 方法以后,服务器才开始工作
    - `port` : 监听的端口
    - `hostname` : 主机名(IP/域名),可选
    - `backlog` : 连接等待队列的最大长度,可选
    - `callback` : 调用listen方法并成功开启监听以后,会触发一个 listening事件,callback将作为该事件的执行函数,可选

看完了创建与监听的方法，我们再看看看，我们在监听到客户端连接的回调函数 `server.on('request', function(req, res) {// do ....})` 中看到有两个参数 request 和 response ，
在这两个参数中，我们可以去获得用户的当前请求一些信息,比如头信息,数据等待，还可以向该次请求的客户端输出返回响应，下面我们一起看看它里面的内容

### request 对象

参数`request`对象是 `http.IncomingMessage` 的一个实例,通过它 ，我们可以获取到这次请求的一些信息,比如头信息,数据，`url`参数等等
这里简单的列一下最常见的:

- `httpVersion`: 使用的http协议的版本
- `headers `: 请求头信息中的数据
- `url `: 请求的地址
- `method `: 请求方式

### response 对象

参数 `response`对象是 `http.ServerResponse`(这是一个由HTTP服务器内部创建的对象) 的一个实例，通过它 我们可以向该次请求的客户端输出返回响应。

- `response.writeHead(statusCode, [reasonPhrase], [headers])`：向请求回复响应头，这个方法只能在当前请求中使用一次，并且必须在`response.end()`之前调用。
    - `statusCode`： 一个三位数的HTTP状态码, 例如 404
    - `reasonPhrase`：自行设置http响应状态码对应的原因短语
    - `headers`：响应头的内容
- `write(chunk, [encoding])` : 发送一个数据块到响应正文中 ,如果这个方法被调用但是 `response.writeHead()` 没有被调用，
    它将切换到默认header模式并更新默认的headers。chunk可以是字符串或者缓存。如果chunk 是一个字符串，
    第二个参数表明如何将这个字符串编码为一个比特流。默认的 encoding是'utf8'。
- `end([data], [encoding])`: 当所有的正文和头信息发送完成以后,调用该方法告诉服务器数据已经全部发送完成了。
    **这个方法在每次完成信息发送以后必须调用,并且是最后调用**,如果指定了参数 data , 就相当于先调用` response.write(data, encoding) `之后再调用 `response.end()`
- `setHeader(name, value) `: 为默认或者已存在的头设置一条单独的头信息：如果这个头已经存在于 将被送出的头中，将会覆盖原来的内容。如果我想设置更多的头， 就使用一个相同名字的字符串数组
    如：`response.setHeader("Set-Cookie", ["type=ninja", "language=javascript"]);`

看了那么多api，是时候实践一把了，我们再来对原来的代码进行一点改造～

```js
// 导入http模块,url 模块
var http = require('http');
var url = require('url')
// 创建http server
var server = http.createServer();
server.on('request', function (req, res) {
    // 将HTTP响应200写入response, 同时设置Content-Type: text/html:
    res.writeHead(200, {
        'Content-Type': 'text/html'
    });
    var urlObj = url.parse(req.url);
    //根据用户访问的url不同展示不同的页面
    switch (urlObj.pathname){
        // 这是首页
        case '/':
            res.write('<h1>这是里首页</h1>');
            break;
        case '/user':
            res.write('<h1>这里是个人中心</h1>');
            break;
        default :
            res.write('<h1>你要找的页面不见了～</h1>');
            break;
    }
    // 将HTTP响应的HTML内容写入response:
    res.end();
});
server.listen(8888);
console.log('Server is running at http://127.0.0.1:8888/');
```

启动一下该js文件，并且通过不同的url不同的后缀,如 `/` 和 `/user` 去访问这个地址，看看浏览器的输出，应该已经变了。

这就是通过简单的的url处理，来实现的路由机制拉～

## url 处理响应不同 html
当然这里我们再继续深入一下！结合 node 的文件系统（fs模块），使不同的url，直接读取不同的 html 文件,示例：

准备工作: 在当前文件目录下建立`html`文件夹, 并且新增文件 `index.html`与 `user.html`，内容自行发挥

```js
var http = require('http');
var url = require('url');
var fs = require('fs');

var server = http.createServer();
// 读取我们当前文件所在的目录下的 html 文件夹
var HtmlDir = __dirname + '/html/';
server.on('request', function(req, res) {
    var urlObj = url.parse(req.url);
    switch (urlObj.pathname) {
        case '/':
            //首页
            sendData(HtmlDir + 'index.html', req, res);
            break;
        case '/user':
            //用户首页
            sendData(HtmlDir + 'user.html', req, res);
            break;
        default:
            //处理其他情况
            sendData(HtmlDir + 'err.html', req, res);
            break;
    }
});

/**
 * 读取html文件，响应数据，发送给浏览器
 * @param {String} file 文件路径
 * @param {Object} req request
 * @param {Object} res response 对象
 */
function sendData(file, req, res) {
    fs.readFile(file, function(err, data) {
        if (err) {
            res.writeHead(404, {
                'content-type': 'text/html;charset=utf-8'
            });
            res.end('<h1>你要找的页面不见了～</h1>');
        } else {
            res.writeHead(200, {
                'content-type': 'text/html;charset=utf-8'
            });
            res.end(data);
        }

    });
}
server.listen(8888);
console.log('Server is running at http://127.0.0.1:8888/');
```

运行文件，切换url，程序会将不同的页面返回。大家自己去试试吧！

这是对于 node 的 http模块 的学习，理解有限，如果有错误之处，请指出，谢谢！

本文地址：[//guowenfh.github.io/2016/10/15/node-http/](https://guowenfh.github.io/2016/10/15/node-http/)
