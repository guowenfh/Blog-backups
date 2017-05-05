title: Ajax入门（一）从0开始到一次成功的GET请求
date: 2015-12-18 14:38:40
tags: [JS,Ajax]
categories: [前端技术]
---
> 续作[Ajax入门（二）Ajax函数封装](https://guowenfh.github.io/2015/12/18/Ajax-elementary-course-2-fn/)
> 传统表单在提交后整个页面都刷新

## 什么是服务器

### 网页浏览过程分析

一个完整的**HTTP请求**过程,通常有下面7个步骤

 1. 建立TCP连接
 2. Web浏览器向Web服务器发送请求命令
 3. Web浏览器发送请求头信息
 4. Web服务器- 应答
 5. Web服务器- 发送应答头信息
 6. Web服务器- 向浏览器发送数据
 7. Web服务器- 关闭TCP连接

 **如何配置自己的服务器程序(AMP)**

> Ajax必须在服务器环境下才能正常使用

- 我使用的WampServer程序.(支持中文)[官网连接](http://www.wampserver.com/en/).可能速度不行,不过科学上网,大家应该都会.
-  网上的使用教程:[如何安装使用](http://www.phpthinking.com/archives/379)
- XAMPP--我试了一下,还是wamp简单,大家有兴趣就自己去测试了
- 推荐使用firefox浏览器进行AJAX的调试。

## Ajax原理

> 什么是Ajax?

- 无刷新数据读取
  - 用户注册/在线聊天室
  - 理解同步和异步(基本都用异步请求).
    > 同步: 客户端发起请求--等待-->服务器端处理---等待-->响应-->页面载入 (请求错误时全部重新载入).
异步: 客户端发起请求--->服务器端处理--->响应--->页面载入(填写时,即时更新,部分返回).

### HTTP请求
- 一个HTTP请求一般由四部分组成
 1. HTTP请求的方法或动作如是`GET`还是`POST`请求
 2. 正在请求的URL,总得知道请求的地址是什么吧?
 3. 请求头,包含一些客户端环境信息,身份验证信息等
 4. 请求体,也就是请求正文,请求正文中可以包含客户端提交的查询字符串信息,表单信息等等.

![HTTP请求](https://ws1.sinaimg.cn/large/82d12951gy1feuqytyw96j20ez06fgn0.jpg)

### HTTP响应


- 一个**HTTP响应**一般由三部分组成:
 1. 一个**数字**和**文字**组成的状态码,用来显示请求是成功还是失败
 2. **响应头**,响应头和请求头一样包含许多有用的信息,例如服务器类型,日期时间,内容类型和长度等.
 3. **响应体**,也就是响应正文.

![HTTP响应](https://ws1.sinaimg.cn/large/82d12951gy1feuqytjxc1j20et076wfn.jpg)

### HTTP请求方式


| GET | POST |
|-----|------|
|用于信息获取/查询(如:浏览帖子)|用于修改服务器上的资源(如:用户注册)|
| 安全性低(使用`url`传递参数所有人可见)  |  安全性一般(至少不可见) |
|  容量低(2000个字符)   |  容量几乎无限 |

### 常见的HTTP状态码


|状态码|描述|原因短语|
|-----|-----|------|
| 200 |请求成功.一般用于GET和POST方法|OK|
| 301 |资源移动.所请求资源移动到新的URL,浏览器自动跳转到新的URL|Moved Permanently|
| 304 |未修改.所请求资源未修改读取缓存数据|Not Modified|
| 400 |请求语法错误,服务器无法理解|Bad Request|
| 404 |未找到资源,可以设置个性"404页面"|Not Found|
| 500 |服务器内部错误|internal Server Error|

## 编写Ajax

**类比打电话理解Ajax编写步骤**


|打电话|ajax请求|
|------|------|
|1.打电话|1.创建Ajax对象|
|2.拨号|2.连接服务器|
|3.建立连接|3.发送请求|
|4.听|4.接受返回|

### 1.创建Ajax对象

- IE6:`ActiveXObject("Microsoft.XMLHTTP")`;//IE6已死,可以不考虑了
- `XMLHttpRequest()`;

例:`var request = new XMLHttpRequest();`

### 2.连接服务器

- `open(method,url,async);`
- open(发送请求方法"GET/POST" ,(请求地址"文件名") ,是否异步传输)

例: `request.open("GET","get.json",true);`

### 3.发送请求

- `send(string)`
 - 在使用`GET`方式请求时无需填写参数
 - 在使用`POST`方式时参数代表着向服务器发送的数据


```javascript
//完整的GET请求
var oAjax = new XMLHttpRequest();//创建Ajax对象
oAjax.open("GET","create.php",true);//连接服务器
oAjax.send();//发送请求

//完整的POST发送请求
var oAjax = new XMLHttpRequest();//创建
oAjax.open("POST","create.php",true);//"POST"
oAjax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");//设置HTTP头信息.必须在open与send之间,否则出现异常.
oAjax.send("name=陈二狗&sex=男");//发送给服务器的内容
```

    ### 4.接收返回-请求状态监控


- XMLHttpRequset取得响应


|属性|值|
|--|--|
|`responseText`|获得字符串形式的响应数据|
|`responseXML`|获得XML形式的响应数据|
|`status`和`statusText`|以数字和文本方式返回HTTP状态码|
|`getAllResponseHeader()`|获取所有的响应报头|
|`getResponseheader()`|查询响应中的某个字段的值|


- **`onreadystatechange`事件**
> 通过监听`onreadystatechange`事件,来判断请求的状态.

- `readyState`属性:响应返回所处状态


|状态码|状态|所处位置|
|------|----|--------|
| 0 |(未初始化)|还没有调用`open()`方法|
| 1 |(载入)|已调用`send()`方法,正在发送请求|
| 2 |(载入完成)|`send()`方法完成,已经收到全部响应 内容|
| 3 |(解析)|正在解析响应内容|
| 4 |(完成)|响应内容解析完成,**可以在客户端调用了**|

例:


```javascript
//基本完整的一个Ajax请求
var request = new XMLHttpRequest();
request.open("GET","get.json",true);
request.onreadystatechange = function () {
    if (request.readyState === 4) {
        if (request.status === 200) {
            //响应成功,做一些事情
        } else {
           //响应失败,做一些事情
        }
    }
};
```

### 使用函数简单的封装一个get请求


```
/**
 * 一个简单的异步get请求
 * @param {String}   url     请求地址,文件名
 * @param {Function} fnSucc  请求成功时执行的函数,形参为为获取的字符串值.
 * @param {Function} fnFaild 请求失败执行的函数,可选参数
 */
function get(url, fnSucc, fnFaild) {
    //1.创建ajax对象
    var oAjax = null
        //此处必须需要使用window.的方式,表示为window对象的一个属性.不存在是值为undefined,进入else/若直接使用XMLHttpRequest在不支持的情况下会报错
    if (window.XMLHttpRequest) {
        oAjax = new XMLHttpRequest();
    } else {
        //IE6以上,现在应该不需要考虑IE6了
        oAjax = new ActiveXObject("Microsoft.XMLHTTP");
    }
    //2.连接服务器
    //open(方法,url,是否异步)
    oAjax.open("GET", url, true);
    //3.发送请求
    oAjax.send();
    //4.接收返回
    //OnRedayStateChange事件
    oAjax.onreadystatechange = function () {
        if (oAjax.readyState === 4) {
            if (oAjax.status === 200) {
                fnSucc(oAjax.responseText);
            } else {
                if (fnFaild) {
                    fnFaild();
                }
            }
        }
    };
}
```

## 使用Ajax

### 基础:请求并显示静态TXT文件
  - 字符集编码:不一致时会出现乱码
  - 缓存,阻止缓存,(使用时间对象添加)

### 动态数据:请求JS(或JSON)文件
> 注：**并不推荐使用`eval`，并不推荐使用`eval`，并不推荐使用`eval`**。因为eval解析数据时会有一系列问题出现。这里是因为只是学习就随意点了。
> 在需要解析请求数据时，推荐使用JSON的方法`JSON.parse()`可以将一个 JSON 字符串解析成为一个 JavaScript 值。参考[MDN-JSON](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/JSON)


  - `eval`的使用
 例:



```javascript
var str = "54-8*6+4";
alert(eval(str)); //10;

var str1 = "[1,2,3]";
var arr = eval(str1);
alert(arr[1]);//2

var str3 = "function show(){alert('abc');}";
eval(str3);
show() //abc
```

**一次成功的get请求**



```javascript
//已经引入get函数
//数据文件放在同级目录下就行了。
get("json.js", function (str) {
    var arr = eval(str);
    alert(arr[0].a);
}, function () {
    alert("服务器请求失败!");
});
//json.js存放的文件如下
/*
    [{
        a: 12,
        b: 5
    }, {
        a: 2,
        b: 56
    }]
*/
//服务器响应成功时,将返回12.

```

- `DOM`创建元素
 - 局部刷新:请求并显示部分网页文件,使用`for`循环.
 - 这里是属于DOM操作的范围，在这里就不过多讲述了。
