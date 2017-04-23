title: task0002（二）- DOM + 事件
date: 2015-12-16 12:32:41
tags: [JS,百度前端技术学院,task0002]
categories: [前端技术]
---

##  DOM

### 添加class、移除class、是否同级元素、获取元素位置

先来一些简单的，在你的`util.js`中完成以下任务：


```javascript
// 为element增加一个样式名为newClassName的新样式
function addClass(element, newClassName) {
    // your implement
}

// 移除element中的样式oldClassName
function removeClass(element, oldClassName) {
    // your implement
}

// 判断siblingNode和element是否为同一个父元素下的同一级的元素，返回bool值
function isSiblingNode(element, siblingNode) {
    // your implement
}

// 获取element相对于浏览器窗口的位置，返回一个对象{x, y}
function getPosition(element) {
    // your implement
}
// your implement
```

#### 思路：


1. 其实这里可以先定义一个`hasClass`函数。用来判断该节点是否含有某个className。
 - `addClass`添加样式。调用`hasClass`函数，判断`element`是否含有待添加的新className，若没有则添加，否则什么都不做。
 - `removeClass`删除样式。调用`hasClass`函数，判断`element`是否含有该指定样式，若含有的话删除该className。没有的话什么都不做。

2. 判断siblingNode和element是否为同一个父元素下的同一级的元素。这里直接判断`parentNode`就可以了吧

3. 获取element相对于浏览器窗口的位置，返回一个对象{x, y}。
 - 这个题应该是这几个中比较复杂的一个了。因为不能直接使用`offsetLeft/Top`。**`offsetLeft/Top`所获取的是其相对父元素的相对位置。**当多层定位嵌套时想要获取到当前元素相对网页的位置就会不对。
 -  并且由于在`表格`和`iframe`中，offsetParent对象未必等于父容器，所以也不能直接利用该元素的`parent`来获取位置，因为其对于`表格`和`iframe`中的元素不适用。
 -  通过查询知道有一个`Element.getBoundingClientRect()`方法。它返回一个对象，其中包含了left、right、top、bottom四个属性，分别对应了该元素的左上角和右下角相对于浏览器窗口（viewport）左上角的距离。

 -  但是用该方法获取到的是元素的相对位置，在出现滚动时，距离会发生改变，要获得绝对位置时，还需要加上滚动的距离。因为Firefox或Chrome的不兼容问题需要进行兼容性处理，参考[document.body.scrollTop or document.documentElement.scrollTop](http://www.cnblogs.com/zhenyu-whu/archive/2012/11/13/2768004.html)
 -  最终根据两个值，得到绝对位置。


```javascript
//其实也简单，只需要获取到两个值，取其中的最大值即可。
var scrollLeft = Math.max(document.documentElement.scrollLeft, document.body.scrollLeft);
var scrollTop = Math.max(document.documentElement.scrollTop, document.body.scrollTop);
```


#### 实现：

```javascript
//判断element中是否含有className为sClass。
function hasClass(element, sClass) {
    return element.className.match(new RegExp("(\\s|^)" + sClass + "(\\s|$)"));
}

// 为element增加一个样式名为newClassName的新样式
function addClass(element, newClassName) {
    if (!hasClass(element, newClassName)) {
        element.className += " " + newClassName;
    }
}

// 移除element中的样式oldClassName
function removeClass(element, oldClassName) {
    if (hasClass(element, oldClassName)) {
        var reg = new RegExp("(\\s|^)" + oldClassName + "(\\s|$)");
        element.className = element.className.replace(reg, "");
    }
}

// 判断siblingNode和element是否为同一个父元素下的同一级的元素，返回bool值
function isSiblingNode(element, siblingNode) {
    return element.parentNode === siblingNode.parentNode
}

// 获取element相对于浏览器窗口的位置，返回一个对象{x, y}
function getPosition(element) {
    var position = {};
    position.x = element.getBoundingClientRect().left + Math.max(document.documentElement.scrollLeft, document.body.scrollLeft);//获取相对位置+滚动距离=绝对位置.
    position.y = element.getBoundingClientRect().top + Math.max(document.documentElement.scrollTop, document.body.scrollTop);
    return position;
}
```

参考资料：（还没看完）

- 阮一峰[用Javascript获取页面元素的位置](http://www.ruanyifeng.com/blog/2009/09/find_element_s_position_using_javascript.html)
- 博客园[JavaScript获取DOM元素位置和尺寸大小](http://www.cnblogs.com/dolphinX/archive/2012/11/19/2777756.html)
- 博客园[js中的各种宽高以及位置总结](http://www.cnblogs.com/myzhibie/p/4256164.html?utm_source=tuicool)

### 挑战`mini $`

接下来挑战一个`mini $`，它和之前的`$`是不兼容的，它应该是`document.querySelector`的功能子集，在不直接使用`document.querySelector`的情况下，在你的`util.js`中完成以下任务：

```javascript
// 实现一个简单的Query
function $(selector) {

}

// 可以通过id获取DOM对象，通过#标示，例如
$("#adom"); // 返回id为adom的DOM对象

// 可以通过tagName获取DOM对象，例如
$("a"); // 返回第一个<a>对象

// 可以通过样式名称获取DOM对象，例如
$(".classa"); // 返回第一个样式定义包含classa的对象

// 可以通过attribute匹配获取DOM对象，例如
$("[data-log]"); // 返回第一个包含属性data-log的对象

$("[data-time=2015]"); // 返回第一个包含属性data-time且值为2015的对象

// 可以通过简单的组合提高查询便利性，例如
$("#adom .classa"); // 返回id为adom的DOM所包含的所有子节点中，第一个样式定义包含classa的对象
```
实现思路：
嗯，这个题思考了很久，网上找了很多资料但还是不怎么会，还达不到想要的效果，有点钻牛角尖了。尽量来写一下吧。（我果然是个弱鸡）。感谢秒味课堂的免费课程。

1. 题目要求获取到所有的节点中的第一个，所以不需要用数组来储存获取到的节点。
2. 额。。想了半天，还是使用函数包装来实现后代选择器比较好，所以VQuery函数返回是获取到的完整节点对象数组，`$`函数用来达到题目要求。
3. 所以在VQuery函数中就不需要考虑空格了，直接使用switch分支，来判定不同的情况。`#`、`.`、`[`、 `[=]`。
4. 在`$`函数中，判断字符串中是否含有空格，有空格的话需要分割成数组，数组的前一项是为父选择符，后一项为子选择符。分不同的情况来调用VQuery函数，并返回对象。

```javascript
/**
 * $函数的依赖函数，选择器函数
 * @param   {string} selector CSS方式的选择器
 * @param   {object} root     可选参数，selector的父对象。不存在时，为document
 * @returns {Array}  返回获取到的节点数组，需要注意的是使用ID选择器返的也是数组
 */
function VQuery(selector, root) {
    //用来保存选择的元素
    var elements = []; //保存结果节点数组
    var allChildren = null; //用来保存获取到的临时节点数组
    root = root || document; //若没有给root，赋值document
    switch (selector.charAt(0)) {
    case "#": //id选择器
        elements.push(root.getElementById(selector.substring(1)));
        break;
    case ".": //class选择器
        if (root.getElementsByClassName) { //标准
            elements = root.getElementsByClassName(selector.substring(1));
        } else { //兼容低版本浏览器
            var reg = new RegExp("\\b" + selector.substring(1) + "\\b");
            allChildren = root.getElementsByTagName("*");
            for (var i = 0, len = allChildren.length; i < len; i++) {
                if (reg.test(allChildren[i].className)) {
                    elements.push(allChildren[i]);
                }
            }
        }
        break;
    case "[": //属性选择器

        if (selector.indexOf("=") === -1) {
        //只有属性没有值的情况
            allChildren = root.getElementsByTagName("*");
            for (var i = 0, len = allChildren.length; i < len; i++) {
                if (allChildren[i].getAttribute(selector.slice(1, -1)) !== null) {
                    elements.push(allChildren[i]);
                }
            }
        } else {
        //既有属性又有值的情况
            var index = selector.indexOf("="); //缓存=出现的索引位置。
            allChildren = root.getElementsByTagName("*");
            for (var i = 0, len = allChildren.length; i < len; i++) {
                if (allChildren[i].getAttribute(selector.slice(1, index)) === selector.slice(index + 1, -1)) {
                    elements.push(allChildren[i]);
                }
            }
        }
        break;
    default: //tagName
        elements = root.getElementsByTagName(selector);
    }
    return elements
}
/**
 * 模仿jQuery的迷你$选择符。
 * @param   {string} selector CSS方式的选择器，支持简单的后代选择器（只支持一级）
 * @returns {object} 返回获取到的第一个节点对象，后代选择器时，返回第一个对象中的第一个符合条件的对象
 */
function $(selector) {
//这里trim处理输入时两端出现空格的情况，支持ie9+。但是这个函数实现起来也特别简单，可以参考我task0002（-）前面有trim函数的实现。稍微修改一下，这样就没兼容性问题了。
    if (selector == document) {
        return document;
    }
    selector = selector.trim();
    //存在空格时，使用后代选择器
    if (selector.indexOf(" ") !== -1) {
        var selectorArr = selector.split(/\s+/); //分割成数组，第一项为parent，第二项为chlid。
        //这里没去考虑特别多的情况了，只是简单的把参数传入。
        return VQuery(selectorArr[1], VQuery(selectorArr[0])[0])[0];
    } else { //普通情况,只返回获取到的第一个对象
        return VQuery(selector,document)[0];
    }
}
```

##  事件

### 事件绑定、事件移除

我们来继续用封装自己的小jQuery库来实现我们对于JavaScript事件的学习，还是在你的`util.js`，实现以下函数

```javascript
// 给一个element绑定一个针对event事件的响应，响应函数为listener
function addEvent(element, event, listener) {
    // your implement
}

// 例如：
function clicklistener(event) {
    ...
}
addEvent($("#doma"), "click", a);

// 移除element对象对于event事件发生时执行listener的响应
function removeEvent(element, event, listener) {
    // your implement
}
```

这里慕课网的视频讲的特别清楚，就不赘述了。

- [慕课网 DOM探索之基础详解篇](http://www.imooc.com/learn/488)
- [慕课网 DOM事件探秘](http://www.imooc.com/view/138)。这一部分，主要看这个。


```javascript
/**
 * 事件添加函数
 * @param {object}   element  需要绑定事件的对象
 * @param {string}   event    事件类型
 * @param {function} listener 事件触发执行的函数
 */
function addEvent(element, event, listener) {
    if (element.addEventListener) { //标准
        element.addEventListener(event, listener, false);
    } else if (element.attachEvent) { //低版本ie
        element.attachEvent("on" + event, listener);
    } else { //都不行的情况
        element["on" + event] = listener;
    }
}

/**
 * 事件移除函数
 * @param {object}   element  需要移除事件的对象
 * @param {string}   event    事件类型
 * @param {function} listener 需要被移除事件函数
 */
function removeEvent(element, event, listener) {
    // your implement
    if (element.removeEventListener) { //标准
        element.removeEventListener(event, listener, false);
    } else if (element.detachEvent) { //低版本ie
        element.detachEvent("on" + event, listener);
    } else { //都不行的情况
        element["on" + event] = null;
    }
}
```


### `click`事件、`Enter`事件

利用上面写好的事件绑定函数就很简单了。

- `click`事件，这个简单，直接函数封装一层就行。
- `Enter`事件，这里主要考察的键盘的事件的触发。
  1. `keydown`事件：在键盘按下时触发.
  2. `keyup`事件：在按键释放时触发,也就是你按下键盘起来后的事件
  3. `keypress`事件：在敲击按键时触发,我们可以理解为按下并抬起同一个按键
  4. `keyCode`属性：在键盘事件触发时，按下的键的值。值=13时，为`Enter`键。（需进行兼容处理）



```javascript
// 实现对click事件的绑定
function addClickEvent(element, listener) {
    addEvent(element, "click", listener);
}
// 实现对于按Enter键时的事件绑定
function addEnterEvent(element, listener) {
    // your implement
    addEvent(element, "keydown", function (ev) {
    //兼容性处理。
        var oEvent = ev || window.event;
        if (oEvent.keyCode === 13) {
            listener();
        }
    });
}
```

接下来我们把上面几个函数和$做一下结合，把他们变成$对象的一些方法

- `addEvent(element, event, listener) -> $.on(element, event, listener)`;
- `removeEvent(element, event, listener) -> $.un(element, event, listener)`;
- `addClickEvent(element, listener) -> $.click(element, listener)`;
- `addEnterEvent(element, listener) -> $.enter(element, listener)`;


```javascript
//在js中万物皆对象(原谅我这么浅显的说），所以实现就特别简单了
$.on = function (element, type, listener) {
    return addEvent(element, type, listener);
};
$.un = function (element, type, listener) {
    return removeEvent(element, type, listener);
};
$.click = function (element, listener) {
    return addClickEvent(element, listener);
}
$.enter = function (element, listener) {
    $.enter addEnterEvent(element, listener);
};
```

### 事件代理
接下来考虑这样一个场景，我们需要对一个列表里所有的`<li>`增加点击事件的监听

我们通过自己写的函数，取到id为list这个ul里面的所有li，然后通过遍历给他们绑定事件。这样我们就不需要一个一个去绑定了。但是看看以下代码：


```html
<ul id="list">
    <li id="item1">Simon</li>
    <li id="item2">Kenner</li>
    <li id="item3">Erik</li>
</ul>
<button id="btn">Change</button>
function clickListener(event) {
    console.log(event);
}
```


```javascript
function renderList() {
    $("#list").innerHTML = '<li>new item</li>';
}

function init() {
    each($("#list").getElementsByTagName('li'), function(item) {
        $.click(item, clickListener);
    });

    $.click($("#btn"), renderList);
}
init();
```

我们增加了一个按钮，当点击按钮时，改变list里面的项目，这个时候你再点击一下li，绑定事件不再生效了。那是不是我们每次改变了DOM结构或者内容后，都需要重新绑定事件呢？当然不会这么笨，接下来学习一下事件代理，然后实现下面新的方法：


```javascript
// 先简单一些
function delegateEvent(element, tag, eventName, listener) {
    // your implement
}

$.delegate = delegateEvent;
// 使用示例
// 还是上面那段HTML，实现对list这个ul里面所有li的click事件进行响应
$.delegate($("#list"), "li", "click", clickHandle);
```

#### 实现思路：
写到这里，刚好前几天CSS魔法写的《前端进阶之路：点击事件绑定》有提到“事件代理/委托”，不过是直接使用jQuery来实现的。所以地址有兴趣的自己搜索吧-_-。

-  “事件代理” 的本质是利用了事件冒泡的特性。当一个元素上的事件被触发的时候，比如说鼠标点击了一个按钮，同样的事件将会在那个元素的所有祖先元素中被触发。这一过程被称为事件冒泡；
-  这个事件从原始元素开始一直冒泡到DOM树的最上层。任何一个事件的目标元素都是最开始的那个元素，在我们的这个例子中也就是按钮，并且它在我们的元素对象中以属性的形式出现。使用事件代理，我们可以把事件处理器添加到一个元素上，等待一个事件从它的子级元素里冒泡上来，并且可以得知这个事件是从哪个元素开始的。

-  这里就不细说事件冒泡与事件捕获了（阻止默认行为也会用到，有兴趣去网上找找看），但是要理解事件代理就必须先知道它们。下面这张图可以先看看。（图片来自网络，侵删）

![事件捕获与事件冒泡原型图](//ws1.sinaimg.cn/large/82d12951gy1fewio65xc0j20f00dimzj.jpg)

- 理解了这个之后就没那么难了，只需要进行一点兼容性处理。
- 参考资料
 - [javascript事件代理（委托）](http://www.cnblogs.com/Aralic/p/4446030.html)
 - [JavaScript事件代理](http://www.cnblogs.com/rubylouvre/archive/2009/08/09/1542174.html)

#### 实现如下：


```javascript
/**
 * 事件代理
 * @param   {HTMLElement}   element   需要进行事件代理的父元素。
 * @param   {string}   tag       需要触发事件的标签名
 * @param   {string}   eventName 触发的事件类型
 * @param   {function} listener  事件执行的函数
 */
function delegateEvent(element, tag, eventName, listener) {
    // your implement
    return addEvent(element, eventName, function (ev) {
        var oEvent = ev || event; //兼容处理
        var target = oEvent.target || oEvent.srcElement; //兼容处理
        if (target.tagName.toLocaleLowerCase() === tag) {
            listener.call(target, oEvent); //使用call方法修改执行函数中的this指向，现在this指向触发了事件的HTML节点（可直接使用this.innerHTML返回该节点内容）
        }
    })
}
```


### 封装改变
估计有同学已经开始吐槽了，函数里面一堆$看着晕啊，那么接下来把我们的事件函数做如下：（这里应该是把前面的`$.on`、`$.click`、`$.un`、`$.delegate`都改写一下。比较简单，就拿一个出来作例子吧。）


```javascript
//和上面的函数一样，原来第一个参数是传入获取到的父HTMLElement对象，现在直接传入选择器名称就行
$.delegate = function (selector, tag, event, listener) {
//这里的`$(selector)`，是用的自己封装的选择器函数，愿意的话可以换成标准支持的`document.querySelector()`
    return delegateEvent($(selector), tag, event, listener);
};
// 使用示例：
$.delegate('#list', "li", "click", liClicker);
```
