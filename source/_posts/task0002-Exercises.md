<!-- title: task0002（四）- 练习：数据处理、轮播及交互 -->
date: 2015-12-24 13:46:57
tags: [JS,百度前端技术学院,task0002]
categories: [前端技术]
---
包括5部分：

- 小练习1-处理用户输入
- 小练习2-日期对象的使用
- 小练习3：轮播图
- 小练习4：输入提示框
- 小练习5：界面拖拽交互


[源码地址](https://github.com/guowenfh/IFE/tree/master/task0002)
[task0002 在线Demo](http://guowenfh.github.io/IFE/task0002/index.html)


## 小练习1：处理用户输入
> 这里直接可以利用原来写过的`util.js`。所以应该不是特别难。主要考察对字符串的操作，以及正则表达式的使用

### 任务描述

在`task0002`目录下创建一个`task0002_1.html`文件，以及一个`js`目录和`css`目录，在`js`目录中创建`task0002_1.js`，并将之前写的`util.js`也拷贝到`js`目录下。然后完成以下需求。

#### 第一阶段

在页面中，有一个单行输入框，一个按钮，输入框中用来输入用户的兴趣爱好，允许用户用半角逗号来作为不同爱好的分隔。

当点击按钮时，把用户输入的兴趣爱好，按照上面所说的分隔符分开后保存到一个数组，过滤掉空的、重复的爱好，在按钮下方创建一个段落显示处理后的爱好。

**实现**

根据题目要求，这个地方比较简单，可以直接利用前面写过的一些函数，分成四步，进行。

1. 使用正则表达式来对字符串进行分割操作。
2. `uniqArray`函数进行去重操作。
3. for循环，`trim`函数对数组项进行去除首尾空格，用来处理，该项为空的情况。
4. innerHTML进行输出。

html：

```html
<input type="text" id="user_input">
<button id="btn">提交</button>
<ul id="user_output"></ul>
```

`task0002_1.js`中的js:

```javascript
//自执行的匿名函数
(function handle_1() {
    //其实这里没必要使用id因为数据那么少$函数直接获取标签就行
    var inp = $("#user_input");
    var out = $("#user_output");
    $.click("#btn", function () {
        var value = inp.value.split(/\,|\，/); //1.根据半角逗号分割成数组。
        var unValue = uniqArray(value); //2.数组去重
        for (var i = 0, len = unValue.length; i < len; i++) {
            var trimValue = trim(unValue[i]); //3.对每一项进行去除首尾空格操作
            console.log(trimValue);
            if (trimValue !== "") { //4.只有在去除首尾空格后不为空的数组才输出。
                out.innerHTML += "<li>" + trimValue + "</li>"
            }
        }
    })
})();
```
#### 第二阶段

单行变成多行输入框，一个按钮，输入框中用来输入用户的兴趣爱好，允许用户用换行、空格（全角/半角）、逗号（全角/半角）、顿号、分号来作为不同爱好的分隔。

当点击按钮时的行为同上

**实现**

看题目描述，主要是对于第一步进行修改，第一阶段只要求对半角逗号进行处理，但是在第二阶段中，需要对**“换行、空格（全角/半角）、逗号（全角/半角）、顿号、分号”**进行处理。
主要是考察对于正则表达式的应用。

只需要对`var value = inp.value.split(/\,|\，/); `进行更改如下：

`var value = inp.value.split(/\n|\s+|\,|\，|\、|\;|\；/); `
需要注意的是：在正则表达式进行匹配这些符号时最好是前面加上转义字符。


#### 第三阶段

用户输入的爱好数量不能超过10个，也不能什么都不输入。当发生异常时，在按钮上方显示一段红色的错误提示文字，并且不继续执行后面的行为；当输入正确时，提示文字消失。

同时，当点击按钮时，不再是输出到一个段落，而是每一个爱好输出成为一个checkbox，爱好内容作为checkbox的label。

**实现**

- 嗯，其实这里按照题目要求应该要实时监听输入值变化，但是那样太麻烦了，，所以就直接在点击按钮的时候判断了。
- 直接判断数组长度就行了。。输入为空时，判断字符串=“”。
- 输出`checkbox`这里不过多的设置了，只是演示。

### 最终完成

html:

```html
<textarea name="user_input" id="user_input" cols="45" rows="10"></textarea>
<br>
<button id="btn">处理并输出</button>
<p>输入的爱好数量不能超过10个，或什么都不输入</p>
<form id="user_output"></form>
```
js:

```javascript
(function handle_1() {
    var inp = $("#user_input");
    var out = $("#user_output");
    $.click("#btn", function () {
        var value = inp.value.split(/\n|\s+|\,|\，|\、|\;|\；/); //分割成数组。
        var unValue = uniqArray(value); //数组去重
        var i = 0;
        var len = unValue.length;
        if (len > 10 || unValue == "") {
            $("p").style.disautoPlay = "block";
        } else {
            $("p").style.disautoPlay = "none";
            for (; i < len; i++) {
                var trimValue = trim(unValue[i]); //对每一项进行去除首尾空格操作
                console.log(trimValue);
                if (trimValue !== "") { //只有在去除首尾空格后不为空的数组才输出。
                    out.innerHTML += "<label>" + "<input type='checkbox'>" + trimValue + "</label>"
                }
            }
        }
    })
})();
```


在线演示：**[小练习1：处理兴趣列表](http://guowenfh.github.io/IFE/task0002/task0002_1.html)**

## 小练习2：日期对象的使用


### 任务描述

在和上一任务同一目录下面创建一个`task0002_2.html`文件，在`js`目录中创建`task0002_2.js`，并在其中编码，实现一个倒计时功能。

- 界面首先有一个文本输入框，允许按照特定的格式`YYYY-MM-DD`输入年月日；
- 输入框旁有一个按钮，点击按钮后，计算当前距离输入的日期的00:00:00有多少时间差
- 在页面中显示，距离YYYY年MM月DD日还有XX天XX小时XX分XX秒
- 每一秒钟更新倒计时上显示的数
- 如果时差为0，则倒计时停止

### 实现思路

#### 了解日期对象
这里主要是考察的对于日期对象的使用。

`new Date()`。如果没有输入任何参数，则Date的构造器会依据系统设置的当前时间来创建一个Date对象。表示当前系统时间。

```javascript
//时间对象创建的几种方式。
var today = new Date();
var birthday = new Date("December 17, 1995 03:24:00");
var birthday = new Date("1995-12-17T03:24:00");
var birthday = new Date(1995,11,17);
var birthday = new Date(1995,11,17,3,24,0);
```
  - Date对象中处理时间和日期的常用方法：详细内容在[MDN](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Date)上

![日期对象常用方法](/images/ife/DateObject.jpg)

#### 正式开始：

1. 创建时间处理函数，使用正则表达式，处理输入的值，`value.match(/(^\d{4})-(\d{2})-(\d{2}$)/);`用到了match方法和正则的分组，在我写的正则博客里应该有过详细介绍了。这里也不过的说明了。
2. 使用目标时间的`getTime()`毫秒数减去得到当前的毫秒数，得到相差的毫秒数。处理它：**（注意毫秒的问题）**
 - `(60 * 60 * 24)` ：剩余的天数。
 - `(60 * 60) % 24)` :剩余的小时数。依次类推。
3. `innerHTML输出`，并且判断相差时间，改变输出的值。
4. 定时器的使用。(我这里使用的`setTimeout()`，使用递归调用实现自执行)
  - 计时器`setTimeout(函数,延迟时间);`，在载入后延迟指定时间后,去执行一次表达式,仅执行一次。
 - 取消计时器:`clearTimeout()`停止计时器。
5. 给按钮添加点击事件，在点击时，调用刚刚编写的的时间处理函数。

 
在线演示：**[小练习2：倒计时](http://guowenfh.github.io/IFE/task0002/task0002_2.html)**

## 小练习3：轮播图组件

### 任务描述

在和上一任务同一目录下面创建一个`task0002_3.html`文件，在`js`目录中创建`task0002_3.js`，并在其中编码，实现一个轮播图的功能。

- 图片数量及URL均在HTML中写好
- 可以配置轮播的顺序（正序、逆序）、是否循环、间隔时长
- 图片切换的动画要流畅
- 在轮播图下方自动生成对应图片的小点，点击小点，轮播图自动动画切换到对应的图片

效果示例：[http://echarts.baidu.com/](http://echarts.baidu.com/) 上面的轮播图（不需要做左右两个箭头）

### 实现思路:
> 主要是对于考察对于定时器，以及事件绑定的处理，以及动画效果，为此我专门写了一篇博客《[JS完美运动框架的封装过程](http://guowenfh.github.io/2015/12/21/JS-Animated-Frames/)》。 这里就直接使用里面封装好的函数了。
>
> 本来都要放弃组件的编写了，只想按照常规方法来写个轮播图就好，但是在先把小练习4完成的情况下，就发现了一种新方法，可以帮助我完成这个任务（强烈建议先看小练习四！）使用`nextElementNode`,图片向左切换。（不涉及任何css，我假设css都会了，也没有用到特别难css属性）


**该轮播图有依赖函数。主要使用到以下函数：**

- 选择器函数`$(class)`;
- 运动框架`startMove`。
 - 同时在该函数引入时，还依赖于获取实际样式函数`getStyle`。 
- 获取当前元素在同级元素的索引`getIndex`;
- 事件代理函数：`delegateEvent`。
- 添加class与删除class元素`addClass、romoveClass`。


#### 第一步：实现点击切换

编写幻灯片函数：`Slideshow(element)`。

1. 根据图片的数量创建与图片数量相同的导航小点：`ul>li*length` 。设置其`li`样式，并且默认把第一个`li`设置为活动状态`className`为`active`。
2. 编写点击函数`clickLi`：
 1. 给`li`添加事件代理函数。
 2. 据点击的li的索引值算出来动画的目标值，`-iCurrent * getIndex(this);`
 3. 移除所有`li`上的选中状态`active`：编写函数`removeLiClass()`，在后面我们还要用到它。
 4. 设置当前点击的`li`为选中：状态`active`
 5. 调用运动框架实现动画效果。


```javascript
function Slideshow(element) {
    //1.创建li
    var imgArr = element.getElementsByTagName("img"); //获取图片数量
    var imgArrLen = imgArr.length; //缓存图片数量
    var createUl = document.createElement("ul"); //创建小点的ul
    var iCurrent = parseInt(getStyle(imgArr[0], "width")); //获取一张图片的宽度
    element.style.width = iCurrent * imgArrLen + "px"; //设置图片容器的宽度。
    //创建li
    for (var i = 0, len = imgArrLen; i < len; i++) {
        createUl.innerHTML += "<li></li>";
    }
    element.parentNode.appendChild(createUl); //插入导航
    addClass(createUl, "Slideshow-nav"); //添加导航样式
    addClass(createUl.getElementsByTagName("li")[0], "active"); //默认设置第一个为第当前活动的li
    
    //编写点击函数clickLi： 
    clickLi();
    /**
     * 点击导航
     */
    function clickLi() {
        delegateEvent(createUl, "li", "click", function () {
            var iTaget = -iCurrent * getIndex(this);
            removeLiClass();
            addClass(this, "active"); //移出
            startMove(element, {
                "left": iTaget
            });
        });
    }
    
    /**
    * 用于移除所有的Li的选中状态：active
    */
    function removeLiClass() {
        var oLi = createUl.getElementsByTagName("li");
        for (var i = 0, len = oLi.length; i < len; i++) {
            removeClass(oLi[i], "active");
        }
    }
}

```

#### 第二步：实现自动播放 
> 为了方便后续的封装，暂时只考虑：**正序**，**不循环**的情况！

1. 创建自动播放函数`paly（）`,获取当前为选中状态`active`的li.
2. 设置目标值，根据选中状态的索引+1 *width来设置。（注意是负值，同时考虑索引值+1为`length`的情况。）
3. 因为不循环，需要在设置`(getIndex(heightLi)+1)===imgArrLen-1`清除定时器。(其实就是轮播到最后的时候，至于为什么是这样，可以自己研究一下，更改一下值。)
4. 获取下一个元素节点，存在的话，取消现有选中状态，设置下一个元素节点为选择中，调用运动框架！实现动画，
5. 添加定时器`setInterval()`，调用该函数，实现自动播放。
 - 测试几次，你会发现：点击`li`和自动播放之间存在**冲突**，动画效果都没做完就播放下一张了，**如何解决呢？**
6. 给图片容器添加一个鼠标移入和移除事件（`mouseover、mouseover`）也就是`hover`上去的效果
 - 移入时，清除定时器，暂停播放。
 - 移出时，开启定时器，继续轮播。
 - 然后你会发现问题成功的解决了！（而且我观察了大部分的轮播，都是这个效果，移入暂停，移出继续)

这里我们的最基本的功能都实现了，代码如下：(放在`Slideshow()`函数内部)

```javascript
var iSpeed = 4000;//定时器间隔。

hoverElement(); 
/*
* 移入图片容器暂停，移除继续播放。
*/
function hoverElement() {
    addEvent(element.parentNode, "mouseover", function () {
        clearInterval(timer);
    });
    addEvent(element.parentNode, "mouseout", function () {
        timer = setInterval(autoPlay, iSpeed);
    });
}

var timer = null;
timer = setInterval(autoPlay, iSpeed);
/*
* 自动播放函数。
*/
function autoPlay() {
    var heightLi = $(".Slideshow-nav .active"); //高亮的li
    var iTaget;
    iTaget = (getIndex(heightLi) + 1) === imgArrLen ? 0 : (-iCurrent * (getIndex(heightLi) + 1));

    if (getIndex(heightLi) + 1 === imgArrLen - 1) {
        clearInterval(timer);
    }
    var nextLi = heightLi.nextElementSibling;
    if (nextLi) {
        removeLiClass();
        addClass(nextLi, "active");
    }
    startMove(element, {
        "left": iTaget
    });
}
```

#### 第三步：添加配置项（题目要求完成）

1. 获取题目要求：主要是以下三点。
 1. 是否循环，默认为循环。
 2. 是否反向，默认不反向。只有循环时，才可反向。
 3. 轮播间隔时间，默认4000。
2. 如何实现？（使用JSON如下：）

```javascript
/*
 * @param {JSON}         option       配置项
 *   @config   {String}  noLoop       不循环？，默认为循环，只要存在则不循环，任意值
 *   @config   {String}  reverse      是否反向，任意值。只有“noLoop”不存在时，也就是只有循环时，才执行。
 *   @config   {Number}  intervalTime 轮播间隔时间（单位为毫秒），默认为4000，
*/
```

3. 在`Slideshow()`内部，以下部分进行修改或添加。
 1. 先从简单的开始吧！判断`option.intervalTime`是否存在并且更改`iSpeed`的值（这样，轮播间隔时间配置就成功了），默认为4000毫秒。
4. 改变自动播放（一）：`autoPlay`函数。这里是整个改造中最复杂的部分！分几步进行。
 1. 把刚刚写的`autoPlay`函数内的内容，除去`var heightLi = $(".Slideshow-nav .active"); `、`var iTaget;`这两个内容，其他的都使用`if(option.noLoop){}`包裹起来。
  这样就又完成了一个内容，当配置为不循环时的情况，就写好了。
 2. 既然有`if`**不循环**的情况,那么就肯定有`else`对应**循环**时的情况对吧?（笑）那么在里面应该怎么做呢？
 3. 第一次练习时，可以不添加函数，直接使用`if else`,对应正向与反向的情况！但是，在这里为了后面的进化，且不过多的阐述，就直接使用使用函数了，就叫他`play(reverse)`吧。
 在这里当然传入的参数是`option.reverse`，
5. 改变自动播放（二）：编写`play(reverse)`。
 1. 第一要务就是加入`if eles`啦，用来区分，true时为反向，false为正向（默认）。
 2. 先来说正向的情况！其实特别简单，有两步：
  -  第一步：删除`(getIndex(heightLi)+1)===imgArrLen-1`清除定时器的部分，只有这样才能实现循环，
  - 第二步：在上面被提取到不循环的内容中(也就是第一版的`autoPlay()`)的`if (nextLi)`部分加上`else`的情况就行了！
```javascript
//在下一个元素节点不存在的情况下（也就是到了最后了），设置第一个节点为活动状态，就这样正向的循环就成功了！
 else {
    removeLiClass();
    addClass($(".Slideshow-nav li"), "active");
}
```
 3. 反向的情况(只需要对正向循环进行修改)：
  - 改变目标值`iTaget`。`getIndex(heightLi) === 0 ? -iCurrent * (imgArrLen - 1) : -iCurrent * (getIndex(heightLi) - 1);`
  - 改变下一个元素节点，为前一个元素节点`previousElementSibling`。
  - 改变上面`else`的情况，为设置最后一个节点为活动状态。代码就不贴了，有兴趣的看源码吧!

6. 到现在函数就修改完成了。只需要在循环的情况下，调用该函数，并且传入`option.reverse`。

其实到这里我们题目要求就完成了！

但是！不挑战一下怎么能行？

为什么不把左右点击切换一起实现了呢？

既然这样，我们就继续吧！

#### 第四步：扩展！左右箭头实现！

1. 创建并设置箭头样式(配合css使用)
```javascript
//创建左右导航
var createSpan = document.createElement("div");
addClass(createSpan, "left-right")
createSpan.innerHTML = "<span class='nav-left'>&lt;</span><span class='nav-right'>&gt;</span>"
element.parentNode.appendChild(createSpan);
```
2. 创建点击事件，事件代理。
3. 炸裂的函数调用。
 - 还记得我们刚刚的`play(reverse)`函数吗？刚刚的功能完全不用封装函数，那为什么要做呢？就是这里啦！
 - 想想刚刚的函数实现了什么功能呢？是不是正向循环，和反向循环？，自动播放是因为在外层有定时器的缘故。
 - 所以只需要调用传参就行了！
4. 传什么参数？
 - 想想左右箭头的索引，是不是0和1。这样就懂了吧！
 - 对索引进行取反。传参！代码如下：


```javascript
delegateEvent(createSpan, "span", "click", function () {
    var heightLi = $(".Slideshow-nav .active"); //高亮的待选li
    var leftIndex = !getIndex(this); //点击左时为true，点击又为false
    //移动的目标值，默认正向
    play(leftIndex);
});
```
至此，我们的轮播图组件就完成了！ 需要配合CSS使用。 通过这次封装，收益良多，感兴趣的话可以看看[源码](https://github.com/guowenfh/IFE/tree/master/task0002)

在线演示：**[小练习3：图片轮播组件](http://guowenfh.github.io/IFE/task0002/task0002_3.html)**

## 小练习4：输入提示框

### 任务描述

在和上一任务同一目录下面创建一个`task0002_4.html`文件，在`js`目录中创建`task0002_4.js`，并在其中编码，实现一个类似百度搜索框的输入提示的功能。

要求如下：

- 允许使用鼠标点击选中提示栏中的某个选项
- 允许使用键盘上下键来选中提示栏中的某个选项，回车确认选中
- 选中后，提示内容变更到输入框中

**初级班：**

- 不要求和后端交互，可以自己伪造一份提示数据例如：

```
var suggestData = ['Simon', 'Erik', 'Kener'];
```

**中级班：**

- 自己搭建一个后端Server，使用Ajax来获取提示数据

示例：

![示例](https://github.com/baidu-ife/ife/raw/master/2015_spring/task/task0002/img/task0002_sug.png)


### 实现思路

这里我并没有一开始就直接进行数据获取的部分，而是进行了任务分解，如下：

#### 第一阶段


1. 先在使用写好的`ul>li`标签下，。添加3个事件`mouseover`、`mouseout`、`click`。实现点击li使其值变成输入框内的值。（直接使用事件代理）
2. 对输入框添加键盘事件（对，你没看错，只有在聚焦在输入框时才触发）
 - 获取当前高亮的li。没有则设第一个为高亮`active`。
 - 判断`keyCode`使用键盘下键,使用`nextElementSibling`方法获取下一个节点（向上同理）,取消当前的`active`，设置下一个为`active`。（使用键盘上下选中的效果,处理完成）
 - 判断`keyCode`，获取当前状态为`active`的值，实现回车时，把其设为`input`的值。


3. 需要注意的地方：
 - 在移除高亮状态时，最好是遍历一遍。因为键盘与鼠标划过有可能同时触发，导致有多个高亮。 
 - 错误处理

#### 第二阶段

1. 删除原来的`ul>li`html部分的`li`。添加对于输入框进行实时监听（这部分不在这里展开讲，如何实现大家去google吧，因为一展开就太多要说的了）。
- 给个参考：[实时监听输入框值变化](http://www.cnblogs.com/lhb25/archive/2012/11/30/oninput-and-onpropertychange-event-for-input.html)
2. 使用AJAX获取服务器上的数据，解析，遍历，并进行数据匹配。
3. 匹配成功显示`ul`，否则设为`none`。
4. 使用正则表达式的`match`方法，来获取匹配成功的把部分，使用`span`进行高亮显示。并且插入`ul`
5. 改造第一阶段的函数：
- 因为是使用的事件代理，直接对`ul`添加事件，所以需要修改的部分不是很多。
- `click`和`enter`部分获取的值，因为`span`标签的存在，需要使用正则进行处理，输出删除`span`后的值。
 

在线演示：**[小练习4：输入框即时提示](http://guowenfh.github.io/IFE/task0002/task0002_4.html)**

## 小练习5：界面拖拽交互

- 实现一个可拖拽交互的界面
- 如示例图，左右两侧各有一个容器，里面的选项可以通过拖拽来左右移动
- 被选择拖拽的容器在拖拽过程后，在原容器中消失，跟随鼠标移动
- 注意拖拽释放后，要添加到准确的位置
- 拖拽到什么位置认为是可以添加到新容器的规则自己定
- 注意交互中良好的用户体验和使用引导

![示例](https://github.com/baidu-ife/ife/raw/master/2015_spring/task/task0002/img/task0002_drag.png)

### 实现思路：

#### 第一步：封装拖拽函数
> 开一个DEMO页面，实践如下：

1. 了解应该用到的事件，`onmousedown`、`onmousemove`、`onmouseup`。
2. 思考**对谁添加事件?**
 1. 在鼠标点击`div`时，对`div`添加`onmousedown`,表示鼠标按下。
 2. 在事件内给`document`添加`onmousemove`。（为啥给`document`加呢？因为给`div`加在移动过快时会跳出去）表示鼠标移动。
 3. 并且添加`document`添加`onmouseup`，表示鼠标已经抬起，清除移动事件，以及本身。
3. 思考**如何设置对象的位置？**
 1. 直接获取鼠标的位置并设置给`div`行不行呢？试试吧！显然，会出现问题，点击鼠标就到`div`左上角去了。
 2. 那么怎么改变呢？获取鼠标在`div`中的位置？对。就这样，在鼠标按下时记录鼠标在`div`中的位置.
 3. 在鼠标移动时，用当前的位置，减去刚刚的位置，这就是应该的值！
4. 别忘了鼠标抬起时，需要清除事件，不然鼠标就粘住了。 
 > 这里用到了event,事件对象的相关概念，推荐观看慕课网的视频。[DOM事件探秘](http://www.imooc.com/learn/138)
5. 善用this。
**扩展**


```javascript
/**
 * 鼠标拖拽函数。
 * @param {HTMLElement} element 需要拖拽的对象
 */
function setDrag(element) {
    addEvent(element, "mousedown", onmousedown);
    //鼠标按下
    function onmousedown(ev) {
        var oEvent = ev || event;
        var disX = oEvent.clientX - this.offsetLeft;
        var disY = oEvent.clientY - this.offsetTop;
        var that = this;
        addEvent(document, "mousemove", onmousemove);
        addEvent(document, "mouseup", onmouseup);
        /**
         * 鼠标移动
         */
        function onmousemove(ev) {
            var oEvent = ev || event;
            that.style.left = oEvent.clientX - disX + "px";
            that.style.top = oEvent.clientY - disY + "px"
        }
        /**
         * 鼠标抬起删除事件
         */
        function onmouseup() {
            removeEvent(document, "mousemove", onmousemove);
            removeEvent(document, "mouseup", onmouseup);
        }
    }
}
```

#### 第二步：布局转换函数

1. 两个参数，第一个参数，传入父级对象。第二个参数传入标签名，
2. 循环，使用数组，对象，获取标签当前元素的位置`left`，`top`。（`offsetLeft`）。这里不能使用获取实际样式函数，因为本身就需要获取其相对父元素的位置。
3. 第二个循环
 - 设置`left`，`top`值。
 - 设置绝对定位。
 - 取消原有的`margin`值。
4. 调用函数，把对象从文档流布局，变成绝对定位布局。


```javascript
/**
 * 布局转换函数
 * @param {HTMLElment} element  HTML对象
 * @param {string}     childEle 其内需要转换的标签名
 */
function toPosition(element, childEle) {
    var eleArr = element.getElementsByTagName(childEle);
    var aPos = [];
    //
    for (var i = 0, len = eleArr.length; i < len; i++) {
        aPos[i] = {
            left: eleArr[i].offsetLeft,
            top: eleArr[i].offsetTop
        };
    }
    for (var i = 0, len = eleArr.length; i < len; i++) {
        eleArr[i].style.left = aPos[i].left + "px";
        eleArr[i].style.top = aPos[i].top + "px";
        eleArr[i].style.position = "absolute";
        eleArr[i].style.margin = "0";
    }
}
```

在线演示：**[小练习5：拖拽交互](http://guowenfh.github.io/IFE/task0002/task0002_5.html)**

#### 第三步：实现拖拽
> 前面我们已经实现了`setDrag(element)`函数，常规方法就是直使用循环，然后传入`element`。

但是，为什么不用事件代理呢？

特别简单，只需要对上面写的函数进行一些简单的改装。

```javascript
delegateEvent(parentElement, "li", "mousedown", function (ev) {
//此处是原函数中的内容。
}
```

**现在知道为什么上面的函数会用到this了吧？**

#### 第四步：碰撞检测函数

先来看张图：
![碰撞检测示意图](/images/ife/hitDetection.jpg)


是不是有瞬间豁然开朗的感觉呢？

获取相关值，只需要考虑不碰不上的情况就行了！。如下：

```javascript
/**
 * 碰撞检测函数
 * @param   {object}  obj1 对象1
 * @param   {object}  obj2 对象2
 * @returns {boolean} 碰撞时返回true，否则反正false
 */
function hitDetection(obj1, obj2) {
    //对象1的相关值
    var l1 = obj1.offsetLeft;
    var r1 = obj1.offsetLeft + obj1.offsetWidth;
    var t1 = obj1.offsetTop;
    var b1 = obj1.offsetTop + obj1.offsetHeight;
    //对象2的相关值
    var l2 = obj2.offsetLeft;
    var r2 = obj2.offsetLeft + obj2.offsetWidth;
    var t2 = obj2.offsetTop;
    var b2 = obj2.offsetTop + obj2.offsetHeight;

    if (r1 < l1 || l1 > r2 || b1 < t2 || t1 > b2) {
        return false;//没碰上
    } else {
        return true;
    }
}
```

#### 第五步：处理各种碰撞情况

> 这里讲起来就太复杂了。源代码中注释还是比较详细的，有兴趣可以看下


