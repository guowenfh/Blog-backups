title:  jQuery入门笔记之（五）jQuery中的Ajax
date: 2016-01-03 12:22:45
tags: [jQuery,Ajax]
categories: [jQuery]
---

> 关于Ajax的概述就不说了，有兴趣自己去找一下吧，并且建议去我博客看关于原生js实现Ajax函数的实现，希望有所帮助。服务器的配置，那篇文章也给出了地址。
> [Ajax入门（一）从0开始到一次成功的GET请求](//guowenfh.github.io/2015/12/18/Ajax-elementary-course-1/)
> [Ajax入门（二）Ajax函数封装](//guowenfh.github.io/2015/12/18/Ajax-elementary-course-2-fn/)

## jQuery中的Ajax
> jQuery 对 Ajax 做了大量的封装，我们使用起来也较为方便，不需要去考虑浏览器兼容性。对于封装的方式，jQuery采用了三层封装：最底层的封装方法为：$.ajax()，而通过这层封装了第二层有三种方法：.load()、$.get()和$.post()，最高层是$.getScript()和$.getJSON()方法。

### Ajax中的`load()`方法

```javascript
/**
 * Ajax中的load方法（局部方法，可以直接绑定在需要获取的元素上）
 * @param {String}        url  必须，获取文件地址
 * @param {JSON or String}          可选，键值对方式的请求参数或者（使用键值对形式，请求将转化成post）
 * @param {Function}      可选，请求成功的回调函数
 *   @config   {String}   responseText         获得字符串形式的响应数据
 *   @config   {String}   textStatus            文本方式返回HTTP状态码
 *   @config   {Object}   XMLHttpRequest        xhr对象，有多种属性
 */
.load(url, data, complete(responseText, textStatus, XMLHttpRequest));
```

例如下面这段代码
```javascript
$('button').click(function () {
    $('#box').load('test.php', {url : 'guowen'});
});
```
在控制台可以看到请求为POST，（注意：这里第二个参数若是字符串的情况，例如"url=guowen"，请求仍然为GET。）
所以服务器端php文件应该如此设置：
```php
<?php
if ($_POST["url"] == "guowen") {//get请求把POST更改一下就好了
    echo "<a href='//guowenfh.github.io/'>三省吾身丶丶</a>";
} else {
    echo "其他网站";
}
?>
```

关于XHR对象上的属性，和HTTP状态码，参考我原来的博客。

### $.get()和$.post()

> .load()方法是局部方法，因为他需要一个包含元素的 jQuery 对象作为前缀。而$.get()和$.post()是全局方法，无须指定某个元素。对于用途而言，.load()适合做静态文件的异步获取，而对于需要传递参数到服务器页面的，$.get()和$.post()更加合适。

$.get()方法有四个参数，前面三个参数和.load()一样，多了一个第四参数type，即服务器返回的内容格式：包括xml、html、script、json、jsonp和text。第一个参数为必选参数，后面三个为可选参数

GET方式请求会直接在html后以`?Key=value`跟随，所以，有三种形式请求数据，
1. 直接跟在url后
2. 字符串形式的`"url=guowen"`
3. 键值对形式的`{url:"guowen"}`

POST请求方式除去不能直接跟在url后之外，剩余两个，使用方法一样

**注意:** 与`.load()`方法不同的是：`.load()`方法根据第二个参数的不同类型，请求方式会改变，但这里已经是两个独立的方法了，所以请求类型不会进行转换。

第四个参数一般都不进行设置，jQuery会自动转换其类型。强制设置时，有可能会连标签一起返回。

至于POST与GET方式请求的差别，在我原来的博客中也有写到，这里就不赘述了。


### `$.getScript()`和`$.getJSON()`

jQuery提供了一组用于特定异步加载的方法：`$.getScript()`，用于加载特定的JS文件；`$.getJSON()`，用于专门加载JSON文件。

`$.getJSON()`方法与之前的使用方法类似，就是把第四个参数，类型强制设置成了JSON。


有时我们希望能够特定的情况再加载JS文件，而不是一开始把所有JS文件都加载了，这时就可以使用`$.getScript()`方法。

```javascript
//点击按钮后再加载 JS 文件
$('input').click(function () {
    $.getScript('test.js');
});
```

### `$.ajax()`
> $.ajax()是所有 ajax 方法中最底层的方法，所有其他方法都是基于$.ajax()方法的封装。这个方法只有一个参数，传递一个各个功能键值对的对象。

参数很多有兴趣的自己去看[jQuery.ajax()](http://www.css88.com/jqapi-1.9/jQuery.ajax/)，本来准备写几个常用的。强迫症犯了，去网上找资料做成了表格。。如下：

|参数| 类型| 说明|
|------|-------|-------|
|url |String| 发送请求的地址|
|type |String| 请求方式：POST 或 GET，默认 GET|
|timeout |Number| 设置请求超时的时间（毫秒）|
|data |Object 或String|发送到服务器的数据，键值对字符串或对象|
|dataType |String| 返回的数据类型，比如 html、xml、json 等|
|beforeSend |Function| 发送请求前可修改 XMLHttpRequest 对象的函数|
|complete |Function| 请求完成后调用的回调函数|
|success |Function| 请求成功后调用的回调函数|
|error |Function| 请求失败时调用的回调函数|
|global |Boolean| 默认为 true，表示是否触发全局 Ajax|
|cache |Boolean|设置浏览器缓存响应，默认为 true。如果 dataType类型为 script 或 jsonp 则为 false。|
|content| DOM|指定某个元素为与这个请求相关的所有回调函数的上下文。|
|contentType |String|指 定 请 求 内 容 的 类 型 。 默 认 为application/x-www-form-urlencoded。|
|async |Boolean| 是否异步处理。默认为 true，false 为同步处理|
|processData |Boolean| 默认为 true，数据被处理为 URL 编码格式。如果为 false，则阻止将传入的数据处理为 URL 编码的格式。|
|dataFilter |Function| 用来筛选响应数据的回调函数。|
|ifModified |Boolean| 默认为 false，不进行头检测。如果为true，进行头检测，当相应内容与上次请求改变时，请求被认为是成功的。|
|jsonp |String|指定一个查询参数名称来覆盖默认的 jsonp 回调参数名 callback。|
|username |String| 在 HTTP 认证请求中使用的用户名|
|password |String| 在 HTTP 认证请求中使用的密码|
|scriptCharset |String|当远程和本地内容使用不同的字符集时，用来设置 script 和 jsonp 请求所使用的字符集。|
|xhr |Function| 用来提供 XHR 实例自定义实现的回调函数|
|traditional |Boolean|默认为 false，不使用传统风格的参数序列化。如为 true，则使用|


最常用的如下：

```javascript
$('button').click(function () {
    $.ajax({
        type : 'POST', //这里可以换成 GET
        url : 'test.php',
        data : {
            url : 'guowen'
        },
        success : function (response, stutas, xhr) {
            $('#box').html(response);
        }
    });
});
```

注意：对于data属性，如果是GET、模式，可以使用三种之前说所的三种形式。如果是POST模式可以使用之前所说的两种形式。（这里不需要考虑之前的data类型的问题了，因为指定了请求类型，不会转化）


### 表单序列化

使用表单序列化方法`.serialize()`，会智能的获取指定表单内的所有元素。这样，在面对大量表单元素时，会把表单元素内容序列化为字符串，然后再使用Ajax请求。
序列化表单内的元素：`data : $('form').serialize()`，其余部分相同。

除此之外还可以直接获取单选框、复选框和下拉列表框等内容


除了`.serialize()`方法，还有一个可以返回 JSON 数据的方法：`.serializeArray()`。这个方法可以直接把数据整合成键值对的 JSON 对象。
使用方法相同`$('form').serializeArray()`.

有时，我们可能会在同一个程序中多次调用$.ajax()方法。而它们很多参数都相同，这
个时候我们课时使用 jQuery 提供的`$.ajaxSetup()`请求默认值来初始化参数。

```javascript
$('form input[type=button]').click(function () {
    $.ajaxSetup({//初始化多个ajax方法相同部分参数，后面再写ajax的时候，就不用在写了。
        type : 'POST',
        url : 'test.php',
        data : $('form').serialize()//表单序列化
    });
    $.ajax({
        success : function (response, status, xhr) {
                    alert(response);
                }
    });
});
```

在使用 data 属性传递的时候，如果是以对象形式传递键值对，可以使用`$.param()`方法将对象转换为字符串键值对格式。

主要是针对无法直接使用表单序列化方法`.serialize()`的情况，且传递参数为对象，建议使用该方法进行解析后再进行传递。


## Ajax进阶

### 加载请求，及错误处理。

主要是处理网速较慢的情况，出现请求时间较长的问题。而此时若没有一点提示，用户可能会认为你的网页出现了问题。若是能在请求过程中给用户一些提示，比如：正在努力加载中…… 。 可能会对用户更加友好一些。
jQuery提供了两个全局事件，jQuery 提供了两个全局事件，`.ajaxStart()`和`.ajaxStop()`。
这两个全局事件，只要用户触发了 Ajax，请求开始时（**未完成其他请求**）激活`.ajaxStart()`，请求结束时（**所有请求都结束了**）激活`.ajaxStop()`。
值得注意的是，因为是全局事件，所以这两个方法是直接需要直接绑定到document上的。例如：

```javascript
$(document).ajaxStart(function(){
    $(".loading").show();
}).ajaxStop(function(){
    $(".loading").hide();
});
```

当然你也可以自行在ajax内部进行一些设置,如请求超时时间，该ajax函数是否触发全局事件等等。以键值对的方式写明就可以了。

错误处理也特别简单

```javascript
$.ajax({
    //…………
    timeout : 500,//如果请求时间太长，可以设置超时
    global : false,//如果某个 ajax 不想触发全局事件，可以设置取消
    error : function(xhr,errorText,errorType){//一般都直接用xhr对象
                alert("发生错误："+xhr.status);//返回错误状态码
            }
});
```
除此之外`$.get()`、`$.post()`和`.load()`,可以通过连缀处理使用局部`.error()`方法来处理错误，当然还有一个全局的方法：通过全局`.ajaxError()`事件方法来返回错误信息。即可

### 请求全局事件

jQuery 对于 Ajax 操作提供了很多全局事件方法，除去上面已经提到的.ajaxStart()、.ajaxStop()、.ajaxError()等事件方法。他们都属于请求时触发的全局事件，除了这些，还有一些其他全局事件：
1. .ajaxSuccess()，对应一个局部方法：.success()，请求成功完成时执行。
2. .ajaxComplete()，对应一个局部方法：.complete()，请求完成后注册一个回调函数。
3. .ajaxSend()，没有对应的局部方法，只有属性 beforeSend，请求发送之前要绑定的函数。

**注意：**全局事件方法是所有 Ajax 请求都会触发到，并且只能绑定在 document 上。而局部方法，则针对某个 Ajax。
对于一些全局事件方法的参数，大部分为对象，而这些对象有哪些属性或方法能调用，
可以通过遍历方法得到。如：

```javascript
//遍历 settings 对象的属性
$(document).ajaxSuccess(function (event, xhr, settings) {
    for (var i in settings) {
        console.log(i);
    }
});
```

这些全局方法，在$.ajax()方法中都可以直接以参数中的键值对的形式来完成

### JSON和JSONP

其实在同一个域中时，只要url的后缀是json的文件的，默认就是json。当然你还可以使用`$.ajax()`方法设置 dataType属性加载 JSON 文件。

先来试试本地JSON:
php如下：
```php
<?php
    $_arr= array('a'=>1,'b'=>2,'c'=>3);
    $_result = json_encode($_arr);
    echo $_result;
?>
```

js:
```javascript
$.ajax({
    type:"post",
    url:"test.php",
    dataType:"json",//因为文件类型是php。但是返回的数据是json，所以必须设置类型，否则返回字符串
    success:function(response,staus,xhr){
        console.log(response.a);//打印出来1
    }
});
```

实现跨域：这部分需要服务器端配合。
```php
<?php
    $_arr= array('a'=>1,'b'=>2,'c'=>3);
    $_result = json_encode($_arr);
    $_callback = $_GET['callback'];//关键在这。配合客户端JS使用
    echo $_callback."($_result)";//php用点号实现字符串拼接
?>
```

客户端实现：
```javascript
$.ajax({//我本地地址为http://127.0.0.1:8020/ajax.html
    type:"GET",
    url:"http://localhost/test.php?callback=?",//这样就可以实现跨域资源的访问了，最后的？号，jQuery会自动转化成字符串
    dataType:"json",//若这里使用JSONP的话，可以删除上面url的“?callback=?”，jQuery会自动处理。
    success:function(response,staus,xhr){
        alert(response.a);
        console.log(response)
    }
});
```
当然我们还可以进行使用`$.getJSON()`。使用方式同上。

### jqXHR对象

在之前，我们使用了局部方法：.success()、.complete()和.error()。这三个局部方法并不是 XMLHttpRequest 对象调用的，而是$.ajax()之类的全局方法返回的对象调用的。这个对象，就是 jqXHR 对象，它是原生对象 XHR 的一个超集。

```javascript
//获取 jqXHR 对象，查看属性和方法
var jqXHR = $.ajax({
    type : 'POST',
    url : 'test.php',
    data : $('form').serialize()
});
for (var i in jqXHR) {
    document.write(i + '<br />');
}
```

注意：如果使用 jqXHR 对象的话，那么建议用.done()、.always()和.fail()代
替.success()、.complete()和.error()。以为在未来版本中，很可能将这三种方法废弃取消。

```javascript
//成功后回调函数
jqXHR.done(function (response) {
    $('#box').html(response);
});
```
使用 jqXHR 的连缀方式比$.ajax()的属性方式有三大好处：

1. 可连缀操作，可读性大大提高；
2. 可以多次执行同一个回调函数；
3. 为多个操作指定回调函数；



PS：很多都只做了一下测试，并不能熟练应用，先过一遍吧，以后再来熟练掌握。
