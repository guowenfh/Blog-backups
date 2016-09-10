title: task0002（一）- JavaScript数据类型及语言基础
date: 2015-12-14 14:45:52
tags: [JS,百度前端技术学院,task0002]
categories: [前端技术]
---

## 1. 第一个页面交互
- 这里最需要学习的老师的代码中，每一部分功能都由函数控制，没有创建一个全部变量。且最后有一个函数来控制执行代码。这个更多的是思想上的学习吧！
- 在chrome上相加时，直接两个数拼接到一起了，而不是数值相加。因为输入的值，在获取时，默认是字符串类型的。
- 在IE8下提示`对象不支持“addEventListener”属性或方法`。原因是IE8不支持标准的DOM事件绑定函数，它使用`attachEvent`

### 1.1 了解JavaScript是什么
> JavaScript，一种直译式脚本语言，是一种动态类型、基于原型的语言，内置支持类。它的解释器被称为JavaScript引擎，为浏览器的一部分，广泛用于客户端的脚本语言，最早是在HTML网页上使用，用来给HTML网页增加动态功能。然而现在JavaScript也可被用于网络服务器，如Node.js。

上面是维基百科上的解释。不过让JavaScript流行起来的原因应该是**JavaScript 是目前所有主流浏览器上唯一支持的脚本语言**。下面是[MDN对其核心功能的解释](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Guide/JavaScript_Overview#What_is_JavaScript.3F)
>核心的 JavaScript 中包含有一组核心的对象，包括 Array，Date 和 Math，以及一组核心的语言要素，包括操作符，控制结构和语句。出于多种目的，可以通过为其增补附加的对象，对核心 JavaScript 加以扩展；例如：
- 客户端: JavaScript 提供了用于控制浏览器（Navigator 或者其它浏览器）以及其中的文档对象模型（DOM）的对象，从而扩展了核心 JavaScript。例如，客户端扩展允许应用程序在 HTML 的表单中加入元素，以便响应用户事件，比如鼠标点击，表单输入和页面导航。
- 服务器端: JavaScript 提供了服务于在服务器上运行 JavaScript 的对象，从而扩展了核心 JavaScript。例如，服务器端扩展可以允许应用程序访问关系型数据库，在应用程序的不同调用间提供信息的连续性，甚至于处理服务器之上的文件。

### 1.2 如何在HTML页面加载JavaScript代码

可以有三种方法加载在HTML页面中引入JavaScript代码：

1. 内联式: 在HTML标签的style属性中定义样式，在onclick这样的属性中定义Javascript代码;
2. 嵌入式: 在页面中使用`<script>`标签定义Javascript代码;
3. 引用外部文件: 在`<script>`标签中定义`src`属性引入Javascript文件.

**注意**：在`<head>`或者`<body>`中都可以创建`<script>`标签来创建或者引入JavaScript代码。

- 搜索一下，为什么我们让你把`<script>`放在`</body>`前。
 1. 浏览器在解释HTML页面时，是按照先后顺序的，所在放在前面的`JS`代码就会先被执行。正是因为这种特性，所以放在`<head>`中的`<script>`代码会阻塞页面的渲染。
 2. 其实有些JS代码可以放在`<head></head >`之间,比如IE9以下浏览器兼容HTML5标签的js代码，这是一个底层的兼容脚本，不涉及任何页面逻辑。那么它应该放在`<head></head >`间。
 3. 新版浏览器`<script>`标签可以使用`defer`属性来延迟加载。
 
最简单的不就是把能放在`body`中的代码放进去吗？扩展阅读中有详细介绍。
 
### 1.3 扩展阅读：
 - [JavaScript语言的历史](http://javascript.ruanyifeng.com/introduction/history.html)
 - [JavaScript 的性能优化：加载和执行](http://www.ibm.com/developerworks/cn/web/1308_caiys_jsload/index.html)
 

## 2. JavaScript数据类型及语言基础

- 创建一个JavaScript文件，比如`util.js`；
- 实践判断各种数据类型的方法，并在`util.js`中实现以下方法：

### 2.1 判断各种数据类型的方法
这里比较简单，可以参考我的另一篇博客[JavaScript类型识别](http://guowenfh.github.io/2015/11/30/2015-12-01-javascript-type/).


```javascript
// 判断arr是否为一个数组，返回一个bool值
function isArray(arr) {
    return typeof (arr) === "object" && Object.prototype.toString.call(arr) === "[object Array]";
}

// 判断fn是否为一个函数，返回一个bool值
function isFunction(fn) {
    return typeof (fn) === "function";
}

```
在ECMAScript5中，判断数组类型可以直接使用`Array.isArray()`。



```javascript
Array.isArray([]); //true
Array.isArray(function(){}); //false
```


### 2.2 值类型和引用类型的区别.各种对象的读取、遍历方式 
- 了解值类型和引用类型的区别，了解各种对象的读取、遍历方式，并在`util.js`中实现以下方法：

#### 2.2.1 深度克隆


```javascript
// 使用递归来实现一个深度克隆，可以复制一个目标对象，返回一个完整拷贝
// 被复制的对象类型会被限制为数字、字符串、布尔、日期、数组、Object对象。不会包含函数、正则对象等
function cloneObject(src) {
    // your implement
}

// 测试用例：
var srcObj = {
    a: 1,
    b: {
        b1: ["hello", "hi"],
        b2: "JavaScript"
    }
};
var abObj = srcObj;
var tarObj = cloneObject(srcObj);

srcObj.a = 2;
srcObj.b.b1[0] = "Hello";

console.log(abObj.a);
console.log(abObj.b.b1[0]);

console.log(tarObj.a);      // 1
console.log(tarObj.b.b1[0]);    // "hello"
```

**思路如下**

1. 题目考的主要是有些对象的使用`=`直接赋值，并不是真正的复制，而是将一个新的变量指向了当前对象，共享同一个地址。在修改原对象时，新对象也会跟着改变。
2. 经过测试，数字、字符串、布尔、日期、可以直接赋值，修改不会产生影响。所以就思考了在使用`typeof`值为对象或者是原始类型时的情况。且对象类型为`Date`对象时，也使用直接赋值的方式。
3. 再考虑对象类型为`Array`或者`Object`的情况。对于结果声明其类型。
4. 接着往下走，在遍历对象时，只考虑其自身的属性，而不考虑继承来属性。若其自身值还是对象，那么 就递归调用，进一步解析、赋值，否则直接赋值。

**实现：**


```javascript
function cloneObject(src) {
    var result ;//返回的复制后的结果。
    if (typeof(src)==="object"){
        //对象为日期对象时也直接赋值。
        if(Object.prototype.toString.call(src)==="[object Date]"){
            result = src;
        }else{
            //判断对象的类型是Array还是Object，结果类型更改。
            result = (Object.prototype.toString.call(src)==="[object Array]")? [] : {};
            for (var i in src){
                if (src.hasOwnProperty(i)) { //排除继承属性
                    if (typeof src[i] === "object") {
                        result[i] = cloneObject(src[i]); //递归赋值
                    } else {
                        result[i] = src[i]; //直接赋值
                    }
                }
            }
        }
    }else{
        //对于原始类型直接赋值。
        result = src;
    }
    return result;
}
```


### 2.3数组、字符串、数字等相关方法
- 学习数组、字符串、数字等相关方法，在`util.js`中实现以下函数

#### 2.3.1  数组去重操作


```javascript
// 对数组进行去重操作，只考虑数组中元素为数字或字符串，返回一个去重后的数组
function uniqArray(arr) {
    // your implement
}
// 使用示例
var a = [1, 3, 5, 7, 5, 3];
var b = uniqArray(a);
console.log(b); // [1, 3, 5, 7]
```

**思路如下：**

1. 新建一下新数组
2. 循环原数组
3. 判断新数组内元素,原数组是否含有.含有则跳过
 - 这里使用了数组的`indexOf`方法，找到某个元素在数组中的索引。简化了查找过程，若使用最简单的遍历寻找的话需要嵌套循环，是这样的，先在循环中取原数组的值，再循环在新数组中查找，若有相等的情况就不添加。（这是我的第一想法，显然比现在复杂很多）. 
 - 参看来自MDN的[Array对象](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Array).里面介绍了一下数组的方法.
4. 返回新数组.

**实现：**


```javascript
function uniqArray(arr) {
    // your implement
    var result = []; //创建一个新数组。
    for (var i = 0, l = arr.length; i < l; i++) {
        if (result.indexOf(arr[i]) === -1) { //查找是否已经含有该元素
            result.push(arr[i]); //添加到新数组
        }
    }
    return result; //返回新数组

}
```

#### 2.3.2 实现`trim`函数，去除字符串首尾空白
- 实现一个简单的`trim`函数，用于去除一个字符串，头部和尾部的空白字符


```javascript
//1.字符串查找
// 假定空白字符只有半角空格、Tab
// 练习通过循环，以及字符串的一些基本方法，分别扫描字符串str头部和尾部是否有连续的空白字符，并且删掉他们，最后返回一个完成去除的字符串
function simpleTrim(str) {
    // your implement
}
//2.正则
// 很多同学肯定对于上面的代码看不下去，接下来，我们真正实现一个trim
// 对字符串头尾进行空格字符的去除、包括全角半角空格、Tab等，返回一个字符串
// 尝试使用一行简洁的正则表达式完成该题目
function trim(str) {
    // your implement
}
// 使用示例
var str = '   hi!  ';
str = trim(str);
console.log(str); // 'hi!'
```
**实现如下:**


```javascript
//1.字符串查找
//这里就是利用两个循环，找到头尾第一个不是空格且不是tab符的元素。记录它们的索引，之后截取字符串。
function simpleTrim(str) {
    // your implement
    var result = "";
    for (var i = 0, il = str.length; i < il; i++) { //从头查找
        if (str[i] != " " && str[i] != "\t") {
            break; //查找到第一个不为空格及tab符的元素
        }

    }
    for (var j = str.length - 1; j >= 0; j--) { //从尾查找
        if (str[j] != " " && str[j] != "\t") {
            break;
        }

    }
    result = str.slice(i, j + 1); //截取需要的字符串。
    return result;
}
//2.正则
function trim(str) {
    // your implement
    var result = "";
    result = str.replace(/^\s+|\s+$/g, ""); //使用正则进行字符串替换
    return result;
}
```
#### 2.3.3 遍历数组，对每一个元素执行fn函数


```javascript
// 实现一个遍历数组的方法，针对数组中每一个元素执行fn函数，并将数组索引和元素作为参数传递
function each(arr, fn) {
    // your implement
}

// 其中fn函数可以接受两个参数：item和index

// 使用示例
var arr = ['java', 'c', 'php', 'html'];
function output(item) {
    console.log(item)
}
each(arr, output);  // java, c, php, html

// 使用示例
var arr = ['java', 'c', 'php', 'html'];
function output(item, index) {
    console.log(index + ': ' + item)
}
each(arr, output);  // 0:java, 1:c, 2:php, 3:html
```

**思路如下:**

1. 这里的实现有点类似ECMA5中数组的`forEach()`方法
2. 由示例可知:item为必须参数,index为可选参数.
3. 且item为数组项,index为数组索引.
4. 这样就简单了,循环传参.

**实现：**


```javascript
function each(arr, fn) {
    // your implement
    for (var i = 0, l = arr.length; i < l; i++) {//遍历传参
        fn(arr[i], i);
    }
}
```

#### 2.3.4 获取对象里第一层元素的数量，返回整数


```javascript
// 获取一个对象里面第一层元素的数量，返回一个整数
function getObjectLength(obj) {}

// 使用示例
var obj = {
    a: 1,
    b: 2,
    c: {
        c1: 3,
        c2: 4
    }
};
console.log(getObjectLength(obj)); // 3
```

**实现：**


```javascript
//使用for in遍历时,直接获取到的就是第一层的结果
//排除继承来的属性,使用外部变量保存循环次数
function getObjectLength(obj) {
    var count = 0;
    for (var i in obj) {
        if (obj.hasOwnProperty(i)) {
            count++;
        }
    }
    return count;
}
```

### 正则表达式

```javascript
// 判断是否为邮箱地址
function isEmail(emailStr) {
    // your implement
}

// 判断是否为手机号
function isMobilePhone(phone) {
    // your implement
}
```


**实现思路**
>这里参考我对于正则表达式入门的两篇博客

>- [正则表达式-理论基础篇](http://guowenfh.github.io/2015/12/01/Regexp-basis/)
- [正则表达式-基础实战篇](http://guowenfh.github.io/2015/12/14/Regexp-basisCombat/)

- 手机号码的匹配
 1.  这里匹配的情况是最简单的情况，并没有特别完美，比如限制开头第二位数字的范围：188，158通过，而123,191，不通过等等。
 2. 可利用多选分支，例如：`/^1[3|5][0-9]{9}$|^18\d{9}$/`。不过现在虚拟运营商的加入，号码段变多了，所以直接用最简单的方法，也没事。 
- 邮箱的匹配
 1.  在@前能出现哪些东西？这里使用`(\w+\.)*`来匹配出现`.`的情况，表示出现0次或多次因为`.`后不能紧跟@，所以后面紧跟`\w+`匹配普通的字母数字情况。
 2.  @后出现的邮箱后缀并不固定所以使用`\w+`来匹配。
 3.  最后考虑域名结尾的级联情况所以用`(\.\w+)+`。
 

**实现如下:**


```javascript
// 判断是否为邮箱地址
function isEmail(emailStr) {
    // your implement
    var reg = /^(\w+\.)*\w+@\w+(\.\w+)+$/;
    return reg.test(emailStr);
}

// 判断是否为手机号
function isMobilePhone(phone) {
    // your implement
    var reg = /^1\d{10}$/;
    return reg.test(phone);
}
```
### 2.4 参考资料

- [JavaScript 数据结构](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Data_structures)
- [MDN Array](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Array)
- [MDN String](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/String)
- [MDN Number](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Number)
- [MDN 正则](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/RegExp)
