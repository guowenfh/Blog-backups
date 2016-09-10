title:  jQuery入门笔记之（六）工具函数
date: 2016-01-03 22:20:57
tags: [jQuery]
categories: [jQuery]
---

> 工具函数直接依附于 jQuery 对象，针对 jQuery 对象本身定义的方法，它是全局性
的函数。主要提供比如字符串、数组、对象等操作方面的遍历。

**字符串操作**
去除字符串左右空格的工具函数：`$.trim()`。这个函数我在task0002的部分已经用正则实现了。
如下：

```javascript
function trim(str) {
    var result = "";
    result = str.replace(/^\s+|\s+$/g, ""); //使用正则进行字符串替换
    return result;
}
//下面是jQuery中的使用方法
var str = "         guowen      ";
alert($.trim(str));//可以看到空格被去除了
```

## 数组及对象操作
jQuery 为处理数组和对象提供了一些工具函数，这些函数可以便利的给数组或对象进行
遍历、筛选、搜索等操作。

**遍历**

这个我也实现了，其实特别简单，只不过jQuery与和我实现的方法略微有一点不同，且更强大一点。
```javascript
var arr = ["二狗", "甲地", "道德", "鲤鱼"];
//原生JS实现，只能用来遍历数组，不能遍历对象。
function each(arr, fn) {
    for (var i = 0, l = arr.length; i < l; i++) {//遍历传参
        fn(arr[i], i);//第一项为值，第二项为索引
    }
}
each(arr,function(value,index) {
    console.log(index+":"+value);//0:二狗1:甲地2:道德3:鲤鱼
});

//jQuery中的方法
$.each(arr, function (index,value) {//注意此处更改了参数的位置。index为数组下标，从0开始
    console.log(index+":"+value);//0:二狗1:甲地2:道德3:鲤鱼
});
//$.each()还可以用来遍历对象
//<div id="box"></div>
$.each($.ajax(), function (name, fn) {
    $("#box").html($("#box").html() + name + "." + "<br />");//一堆,就不贴了
})
```
**`$.grep()`数据筛选**

```javascript
var arr = [12, 33, 4, 5, 1, 77, 55, 32];
/**
 * 数据筛选函数。
 * @param  {String or Number} element  这里表示数组项，字符串数字都有可能（自行在函数内部进行筛选）
 * @param  {Number} index   表示数组下标，如下面的index<4，就只在前四项进行筛选
 * @return {String or Number}         返回筛选出来的项
 */
console.log($.grep(arr,function  (element,index){
    return element<6&&index<4;//会打印出[4, 5]。
}));
```
** $.map()修改数据**

```javascript
//还是上面的数组
var arrMap = $.map(arr,function(element, index) {
    if(element<6 && index<4){
        return element+1;
    }
});
console.log(arrMap);//打印出[5,6]
```

** $.inArray()获取查找到元素的下标**

```javascript
/**
* 获取查找到元素的下标
* @param  {String or Number} element  需要查找的字符串或数字
* @param  {Array} arr   待查找的数组
* @return {Number}   返回查找到的元素的数组下标0开始，(查找到多个时，返回第一个)，未查找到时返回-1
*/
var arrInArray = $.inArray(1, arr);
console.log(arrInArray);//返回4
```

** $.merge()合并两个数组**

```javascript
//将arr2拼接到arr后，返回合并的数组
$.merge(arr, arr2);
```

 **$.unique()删除重复的 DOM 元素**（不能处理数字和字符串）
没太明白，只能删除拼接过来的重复元素，对自身的元素不受影响？[文档地址](http://www.css88.com/jqapi-1.9/jQuery.unique/)
希望有看明白的教育我一下。。

发一个我实现的普通数组去重吧。(处理数字和字符串)
```javascript
function uniqArray(arr) {//数组去重
    var result = []; //创建一个新数组。
    for (var i = 0, l = arr.length; i < l; i++) {
        if (result.indexOf(arr[i]) === -1) { //查找是否已经含有该元素
            result.push(arr[i]); //添加到新数组
        }
    }
    return result; //返回去重后的新数组
}
```

** toArray()合并多个dom元素组成数组。**

```javascript
//<ul><li>1</li><li>2</li><li>3</li><li>4</li></ul>
console.log($('li').toArray());//[[li, li, li, li]]。注意数组项是原生的DOM元素。
console.log($('li').toArray().length);//4
```

## 测试操作（类型判断）
> 在jQuery数据有着各种类型和状态。可以通过判断数据的类型和状态做相应的操作。


测试工具函数

|函数名 |说明|
|--------|------|
|$.isArray(obj)| 判断是否为数组对象，是返回 true|
|$.isFunction(obj)| 判断是否为函数，是返回 true|
|$.isEmptyObject(obj)| 判断是否为空对象，是返回 true|
|$.isPlainObjet(obj)| 判断是否为纯粹对象，是返回 true|
|$.contains(obj)| 判断 DOM 节点是否含另一个 DOM 节点，是返回 true|
|$.type(data)| 判断数据类型|
|$.isNumeric(data)| 判断数据是否为数值|
|$.isWindow(data)| 判断数据是否为 window 对象|

挑几个出来说明一下

判断是否为空对象
```javascript
var obj={a:"1"};
alert($.isEmptyObject(obj));//false。
```

判断是由{}或 new Object()创造出的对象
```javascript
alert($.isPlainObject({a:"1"}));//true
alert($.isPlainObject(new Object("a")));//false
```

**URL解析**
其实在Ajax的博客中已经讲到了：$.param()将对象键值对转换为 URL 字符串键值对

```javascript
var obj = {
    name : 'Lee',
    email : "guowen921@163.com"
};
console.log( $.param(obj));//name=Lee&email=guowen921%40163.com
console.log(decodeURIComponent( $.param(obj)));//name=Lee&email=guowen921@163.com
//请注意上面的邮箱部分，$.param()会对于特殊字符进行编码传输，下面的代码，可以将其解析成字符
```

**改变this指向**
$.proxy方法类似于ECMAScript 5的bind方法，可以绑定函数的上下文（也就是this对象）和参数，返回一个新函数。
主要用处是为回调函数绑定上下文对象。如如外部事件触发调用对象方法时 this 的指向问题。
> 来自javaScript标准参考教程。

```javascript
//<button>点击</button>
var o = {
    name: "Lee",
    test: function(event) {
        console.log(this.name);
    }
};
$("button")
  .on("click", o.test) // 无输出（默认this指向触发该事件的元素也就是button）
  .on("click", $.proxy(o.test, o)); // Lee，现在指向o
```
