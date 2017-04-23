title: Ajax入门（二）Ajax函数封装
date: 2015-12-18 19:49:35
tags: [JS,Ajax]
categories: [前端技术]
---

> 如果看了的我上一篇博客《[Ajax入门（一）从0开始到一次成功的GET请求](//guowenfh.github.io/2015/12/18/Ajax-elementary-course-1/)》的话，肯定知道我们已经完成了一个简单的get请求函数了。如下：


```javascript
/**
 * 一个简单的get请求
 * @param {String}   url     请求地址,文件名
 * @param {Function} fnSucc  请求成功时执行的函数
 * @param {Function} fnFaild 请求失败执行的函数
 */
function AJAX(url, fnSucc, fnFaild) {
    //1.创建ajax对象
    var oAjax = null;
        /**
         * 此处必须需要使用window.的方式,表示为window对象的一个属性.不存在时值为undefined.
         * 进入else若直接使用XMLHttpRequest在不支持的情况下会报错
         **/
    if (window.XMLHttpRequest) {
        //IE6以上
        oAjax = new XMLHttpRequest();
    } else {
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
                //                alert("成功" + oAjax.responseText);
                fnSucc(oAjax.responseText);
            } else {
                //                alert("服务器响应失败!");
                if (fnFaild) {
                    fnFaild();
                }
            }
        }
    };
}
```
**为什么要继续进行Ajax函数封装？**
原因如下：

1. 目前方法只能使用get请求，而不能使用post请求，而在用户注册时必须使用POST，因为POST，现在不够完整。
2. 目前请求参数只能直接写在url里，不利于动态获取数据，应该使用参数解析的方式，便于使用。
3. get请求方式请求缓存问题。
4. 学习封装方法，


## 改造目标

```javascript
function ajax(url, options) {
    // your implement
}
```
options是一个对象，里面可以包括的参数为：

- type: post或者get，可以有一个默认值
- data: 发送的数据，为一个键值对象或者为一个用&连接的赋值字符串
- onsuccess: 成功时的调用函数
- onfail: 失败时的调用函数

## 改造开始（三步）


### （一）原函数的改造

形参中，删除`fnSucc`、`fnFaild` 添加`options`。使成功与失败执行的函数变成options对象的 `onsuccess`、`onfail`两个方法对应的值。
主要是在**4、接收返回**部分进行更改，如下

```javascript
//4.接收返回
oAjax.onreadystatechange = function () {
    if (oAjax.readyState === 4) {
        if (oAjax.status === 200) {
            //请求成功。形参为获取到的字符串形式的响应数据
            options.onsuccess(oAjax.responseText);
        } else {
            //先判断是否存在请求失败函数
            //存在时，形参为XMLHttpRequest对象，便于进行错误进行处理
            if (options.onfail) {
                options.onfail(oAjax);
            }
        }
    }
};
```

### （二）请求参数的处理

> 首先我们要知道的是在使用请求参数存在时，GET方式的请求参数特别简单。直接在url后面添加?参数名=参数值&参数名二=参数值二


#### 实现思路：


1. 首先判断options.data是否存在，不存在时使用`"?timestamp= + new Date().getTime();`链接在url后，以清除缓存。
  - 这里只是我使用的方法，这里的timestamp可以随意更改
  - `new Date().getTime();`也可以用`Math.random();`主要是保持每次请求的url都不一样。
  - 还有许多别的方法参考[Ajax缓存问题怎么解决？](http://any9.com/1731.html)。有兴趣的自己再多google一下吧。
2. 存在options.data时，应该限制请求data格式便于处理，设定为JSON（当然没必要像JSON那么严格，但是应该保持键值对的格式）。
3. 使用for in 遍历data，使用`=`来连接键与值，使用`&`来连接多个请求参数
4. 只需要对原函数中的**2.连接服务器**进行更改

#### 实现如下：


原：

```javascript
//2.连接服务器
//open(方法,url,是否异步)
oAjax.open("GET", url, true);
```

**现：**

```javascript
//open(方法,url,是否异步)
var param = "";//请求参数。
//判断data存在时缓存它，不存在时，设为0
var data = options.data ? options.data : 0;
if(typeof(data)==="object"){//只有data为对象使才执行
	for (var key in data){//请求参数拼接
		if (data.hasOwnProperty(key)) {
			param += key+"="+data[key]+"&";
		}
	}
	param.replace(/&$/,"");//去除结尾的&。
}else{
	param= "timestamp=" + new Date().getTime();
}
//2.连接服务器
oAjax.open("GET", url+"?"+param, true);
```


### （三）请求类型选择
> 使用post发送数据，模拟form提交。在url看不到请求参数，更加安全。


#### 实现思路：

1. 判断是否type是否存在，存在时转为大写，默认为GET请求。
2. 判断请求的类型，GET 或  POST 。
3. 在使用post请求提交数据时，请求参数不跟在url后面。
4. 使用post请求数据必须添加在`open()`与`send()`直接添加头信息。
  - `xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");`

5. 使用post请求数据，对**2.连接服务器、3.发送请求**部分进行处理

#### 实现如下：

原：

```javascript
//2.连接服务器
oAjax.open("GET", url+"?"+param, true);
```

**现**：

```javascript
//3.发送请求
var type = options.type ? options.type.toUpperCase() : "GET" ;
if(type ==="GET"){
	oAjax.open("GET", url+"?"+param, true);
	oAjax.send();
}else{
	oAjax.open("POST", url, true);
	oAjax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	oAjax.send(param);
}
```


## 最终完成
> 结合之前写的，集合起来。


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
function AJAX(url, options) {
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


> 最终完成就是这样了。当然还远远算不上完美，比如`try catch`的使用 ，但是通过这样的封装，还是学到很多知识。
