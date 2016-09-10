title: task0002（三）- BOM + AJAX
date: 2015-12-19 00:08:41
tags: [JS,百度前端技术学院,task0002]
categories: [前端技术]
---


##  BOM

实现以下函数

### 判断是否为IE浏览器

- 这里应该说一下，在从网上了解到的资料来看，在对于某个功能事件的时候不要去做浏览器检测，而应该做特性检测。这样更符合要求，且浏览器的`UserAgent`可人为修改
- 需要实现的话，ie11的版本号中并没有`msie:`。只能通过`rv:`获得。所以需进行一些处理。但是该属性同样可以返回火狐浏览器的版本号`- -。`所以还需要多加一层判断。查找是否存在`Trident\/7.0;`
- 使用正则表达式的`match`方法,详细见我写的正则表达式的博客。


```javascript
// 判断是否为IE浏览器，返回-1或者版本号
function isIE() {
    var uUserAgent = navigator.userAgent; //保存浏览器的userAgent
    var ieAgent = uUserAgent.match(/msie (\d+.\d+)/i);
    if (ieAgent) {
        return ieAgent[1];
    } else {
        if (uUserAgent.match(/Trident\/7.0;/i)) { //处理到ie11.
            ieAgent = uUserAgent.match(/rv:(\d+.\d+)/i);
            return ieAgent[1];
        }
        return -1; //不是ie浏览器。
    }
}
```


### Cookie相关

秒味js的免费课程，把cookie讲的很好。

#### 什么是cokie

- 页面用来保存信息
 - 比如:自动登入/保存用户名

- cookie的特性
 - 同一个网站中所有页面共享一套cookie
 - 数量/大小有限
 - 过期时间
 
- JS中使用cookie
    - `document.cookie`


#### 设置cookie


```javascript
/**
 * 设置cookie
 * @param {String} cookieName  设置cookie名
 * @param {String} cookieValue 对对应的cookie名
 * @param {Number} expiredays  过期的时间(多少天后)
 */
function setCookie(cookieName, cookieValue, expiredays) {
    var oDate = new Date();
    oDate.setDate(oDate.getDate() + expiredays);
    document.cookie = cookieName + "=" + cookieValue + ";expires=" + oDate;
}
```

#### 获取cookie值


```javascript
 /**
 * 获取cookie
 * @param   {String} cookieName 待寻找的cookie名
 * @returns {String} 返回寻找到的cookie值,无时为空
 */
function getCookie(cookieName) {
    var arr = document.cookie.split("; ");
    for (var i = 0; i < arr.length; i++) {
        var arr2 = arr[i].split("=");
        if (arr2[0] == cookieName) {
            return arr2[1];
        }
    }
    return "";
}
```

#### 删除cookies

```javascript
/**
 * 删除cookie
 * @param {String} cookieName 待删除的cookie名
 */
function removeCookie(cookieName) {
    setCookie(cookieName, "1", -1)
}
```

### 扩展阅读：

#### sessionStorage、localStorage 和 cookie 之间的区别

- **共同点**
    都是保存在浏览器端，且同源的。都是键值对存储。
- **区别**


|特性 | Cookie | localStorage | sessionStorage|
|-----|-------|--------------|---------|
|数据的声明周期 | 一般由服务器生成，可设置失效时间。如果在浏览器端生成Cookie，默认是关闭浏览器后失效 | 除非被清除，否则永久保存 | 仅在当前会话下有效，关闭页面或关闭浏览器后被清除|
|存放数据大小 | 4K左右 | 一般为5MB | 同左（话说markdown不支持跨列表格，只能用html写，懒得麻烦了-_-）|
|与服务器端通信 | 每次都会携带在HTTP头中，如果使用cookie保存过多数据会带来性能问题 | 仅在客户端（即浏览器）中保存，不参与和服务器的通信 | 同左|
|易用性 | 需要程序员自己封装，原生的Cookie接口不友好 | 原生接口可以接受，亦可再次封装来对Object和Array有更好的支持 | 同左|


- **安全性**
    cookie 中最好不要放置任何明文的东西。而且特别需要注意敏感数据的存放。不是什么数据都适合放在 Cookie、localStorage 和 sessionStorage中的。使用它们的时候，需要时刻注意是否有代码存在 XSS 注入的风险。
- 参考：[详说 Cookie, LocalStorage 与 SessionStorage](http://jerryzou.com/posts/cookie-and-web-storage/)


## Ajax

###  任务描述

学习Ajax，并尝试自己封装一个Ajax方法。实现如下方法：

```javascript
// 
function ajax(url, options) {
    // your implement
}

// 使用示例：
ajax(
    'http://localhost:8080/server/ajaxtest', 
    {
        data: {
            name: 'simon',
            password: '123456'
        },
        onsuccess: function (responseText, xhr) {
            console.log(responseText);
        }
    }
);
```

options是一个对象，里面可以包括的参数为：

- type: `post`或者`get`，可以有一个默认值
- data: 发送的数据，为一个键值对象或者为一个用&连接的赋值字符串
- onsuccess: 成功时的调用函数
- onfail: 失败时的调用函数

### 实现如下：
> 专门用两篇博客来记录了一下AJAX的学习过程，以及该函数的完成过程
> [Ajax入门（一）从0开始到一次成功的GET请求](http://guowenfh.github.io/2015/12/18/Ajax-elementary-course-1/)
> [Ajax入门（二）Ajax函数封装](http://guowenfh.github.io/2015/12/18/Ajax-elementary-course-2-fn/)


```javascript
/**
 * AJAX函数封装
 * @param {string} url     请求地址（必须）
 * @param {object} options 发送请求的选项参数
 *   @config {string} [options.type] 请求发送的类型。默认为GET。
 *   @config {Object} [options.data] 需要发送的数据。
 *   @config {Function} [options.onsuccess] 请求成功时触发，function(oAjax.responseText, oAjax)。（必须）
 *   @config {Function} [options.onfail] 请求失败时触发，function(oAjax)。(oAJax为XMLHttpRequest对象)
 *
 *@returns {XMLHttpRequest} 发送请求的XMLHttpRequest对象
 */
function ajax(url, options) {
    //1.创建ajax对象
    var oAjax = null;
        /**
         * 此处必须需要使用window.的方式,表示为window对象的一个属性.不存在时值为undefined,进入else
         * 若直接使用XMLHttpRequest,在不支持的情况下会报错
         **/
    if (window.XMLHttpRequest) {
        //IE6以上
        oAjax = new XMLHttpRequest();
    } else {
        oAjax = new ActiveXObject("Microsoft.XMLHTTP");
    }
    
    //2.连接服务器
    //open(方法,url,是否异步)
    var param = ""; //请求参数。
    //只有data存在，且为对象使才执行
    var data = options.data ? options.data : -1; //缓存data
    if (typeof (data) === "object") {
        for (var key in data) { //请求参数拼接
            if (data.hasOwnProperty(key)) {
                param += key + "=" + data[key] + "&";
            }
        }
        param.replace(/&$/, "");
    } else {
        param = "timestamp=" + new Date().getTime();
    }

    //3.发送请求
    var type = options.type ? options.type.toUpperCase() : "GET";
    if (type === "GET") {
        oAjax.open("GET", url + "?" + param, true);
        oAjax.send();
    } else {
        oAjax.open("POST", url, true);
        oAjax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        oAjax.send(param);
    }

    //4.接收返回
    //OnRedayStateChange事件
    oAjax.onreadystatechange = function () {
        if (oAjax.readyState === 4) {
            if (oAjax.status === 200) {
                //请求成功。形参为获取到的字符串形式的响应数据
                options.onsuccess(oAjax.responseText, oAjax);
            } else {
                //先判断是否存在请求失败函数
                //存在时，形参为XMLHttpRequest对象，便于进行错误进行处理
                if (options.onfail) {
                    options.onfail(oAjax);
                }
            }
        }
    };
    return oAjax;//发送请求的XMLHttpRequest对象
}
```