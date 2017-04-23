title:  jQuery入门笔记之（三）事件详解
date: 2015-12-31 11:42:43
tags: [jQuery]
categories: [jQuery]
---

>在JavaScript 有一个非常重要的功能，就是事件驱动。如果你的网页需要与用户进行交互的话，就不可能不用到事件。它在页面完全加载后，用户通过鼠标或键盘触发页面中绑定事件的元素即可触发。jQuery为开发者更有效率的编写事件行为，封装了大量事件方法供我们使用。

## 基础事件

### 一. 绑定事件
如果你学习过原生的javascript事件，比如常用的事件：click、dblclick、mousedown、mouseup、mousemove、mouseover、mouseout等等。如果恰好你使用的是事件绑定的方式进行触发的话，一定会知道它有多么难处理，各种浏览器的兼容性，this的指向等等，但是在jQuery中，一切都不再是问题了。

jQuery 通过.bind()方法来为元素绑定这些事件。可以传递三个参数：`.bind(eventType [,eventData ],handler(event))`

1. `eventType`：表示一个或多个DOM事件类型，比如`click mouseover`。
2. `eventData`：可选参数，表示一个对象，它包含的数据键值对映射将被传递给事件处理程序。
3. `handler(event)`：表示绑定到指定元素的处理函数。event表示事件对象。

**下面就是绑定的几种方式：**

1.  点击按钮后执行匿名函数
```javascript
$('button').bind('click', function() {
    alert('点击！');//使用点击事件
});
```

2. 执行普通函数式无须圆括号
```javascript
$('button').bind('click', fn);
function fn() {//普通处理函数
    alert('点击！');
}
```

3. 可以同时绑定多个事件
```javascript
$('button').bind('mouseout mouseover', function() {
    $('div').html(function(index, value) {
        return value + '1';//移入和移出分别执行一次
    });
});
```

4. 另一种方式：传递一个对象
```javascript
$('button').bind({
    'mouseout': function() { //事件名的引号可以省略
        alert('移出');
    },
    'mouseover': function() {
        alert('移入');
    }
});
```

**删除绑定函数：**

删除绑定函数`.unbind( eventType [, handler ] )`有三种不同的用法:
```javascript
$('button').unbind(); //删除当前元素的所有事件,包括匿名执行的，在js中匿名执行的事件函数无法删除。

$('button').unbind('click'); //删除当前元素的click事件，使unbind参数删除指定类型事件

$('button').unbind('click', fn1); //只删除click事件的fn1处理函数。
```

### 二. 简写事件
当然jQuery为开发者不简简单单提供了事件绑定的方法就不管其它了，为了使开发者更加方便的绑定事件，jQuery 封装了常用的事件以便节约更多的代码。我们称它为简写事件。

|方法名| 触发条件 |描述|
|-------|-------|------|
|`click(fn)`|鼠标|触发每一个匹配元素的 click(单击)事件|
|`dblclick(fn)`|鼠标|触发每一个匹配元素的 dblclick(双击)事件|
|`mousedown(fn)`|鼠标|触发每一个匹配元素的 mousedown(点击后)事件|
|`mouseup(fn)`|鼠标|触发每一个匹配元素的 mouseup(点击弹起)事件|
|`mouseover(fn)`|鼠标|触发每一个匹配元素的 mouseover(鼠标移入)事件|
|`mouseout(fn)`|鼠标|触发每一个匹配元素的 mouseout(鼠标移出)事件|
|`mousemove(fn)`|鼠标|触发每一个匹配元素的mousemove(鼠标移动)事件|
|`mouseenter(fn)`|鼠标|触发每一个匹配元素的 mouseenter(鼠标穿过)事件|
|`mouseleave(fn)`|鼠标|触发每一个匹配元素的 mouseleave(鼠标穿出)事件|
|`keydown(fn)`|键盘|触发每一个匹配元素的 keydown(键盘按下)事件|
|`keyup(fn)`|键盘|触发每一个匹配元素的 keyup(键盘按下弹起)事件|
|`keypress(fn)`|键盘|触发每一个匹配元素的 keypress(键盘按下)事件|
|`unload(fn)`|文档|当卸载本页面时绑定一个要执行的函数|
|`resize(fn)`|文档|触发每一个匹配元素的 resize(文档改变大小)事件|
|`scroll(fn)`|文档|触发每一个匹配元素的 scroll(滚动条拖动)事件|
|`focus(fn)`|表单|触发每一个匹配元素的 focus(焦点激活)事件|
|`blur(fn)`|表单|触发每一个匹配元素的 blur(焦点丢失)事件|
|`focusin(fn)`|表单|触发每一个匹配元素的 focusin(焦点激活)事件|
|`focusout(fn)`|表单|触发每一个匹配元素的 focusout(焦点丢失)事件|
|`select(fn)`|表单|触发每一个匹配元素的 select(文本选定)事件|
|`change(fn)`|表单|触发每一个匹配元素的 change(值改变)事件|
|`submit(fn)`|表单|触发每一个匹配元素的 submit(表单提交)事件|

大部分事件都如同上面表格中的描述一般比较简单，也比较好理解。

**下面着重讲几个需要注意的地方：**

1. `unload(fn)`、`resize(fn)`、`scroll(fn)`，使用`$(window)`对象触发。

2. `change(fn)`：触发的条件是，输入框的值有改变，且失去焦点。

3. `submit(fn)`：必须在form中，并且使用`$("form")`作为事件触发元素，不然无效。

4. `.mouseover()`和`.mouseout()`表示鼠标移入和移出的时候触发。那么 jQuery 还封装了另外一组：`.mouseenter()`和`.mouseleave()`表示鼠标穿过和穿出的时候触发。那么这两组本质上有什么区别呢？
手册上的说明是：`.mouseenter()`和`.mouseleave()`这组穿过子元素不会触发，而`.mouseover()`和`.mouseout()`则会触发。
经过实验，代码如下：

```html
<div style="width:100px;height:100px;background:blue;">
<p style="width:100px;height:50px;background:red;"></p>
</div>
<strong></strong>
<script>
    $('div').mouseover(function () { //移入 div 会触发，移入 p 再触发
        $('strong').html(function (index, value) {
            return value+'1';
        });
    });
</script>
```
可以看到，鼠标在div内移动时，会不停触发事件函数，输出值。而`mouseenter`则不会有这个问题。

5. `.keydown()`、`.keyup()`返回的是键码，而`.keypress()`返回的是字符编码。

```javascript
$('input').keydown(function(e) {
    alert(e.keyCode); //按下 a 返回 229
});
$('input').keypress(function(e) {
    alert(e.charCode); //按下 a 返回 97
});
```

6. `.focus()`和`.blur()`分别表示光标激活和丢失，事件触发时机是当前元素。而`.focusin()`
和`.focusout()`也表示光标激活和丢失，但是当子元素聚焦或丢失时也触发事件。

```html
 <div style=style="width:100px;height:50px;background:blue;">
    <input type="text">
 </div>
<script>
    $('div').focusin(function(e) {
        alert("激活"); //绑定的是 div 元素，子类input触发
    });
    $('div').focusout(function(e) {
        alert("丢失");
    });
</script>
```

### 三. 复合事件
jQuery 提供了许多最常用的事件效果，组合一些功能实现了一些复合事件，比如切换功
能、智能加载等。

|方法名| 描述|
|----|----|
|`ready(fn)`| 当 DOM 加载完毕触发事件,已经在笔记1中介绍过|
|`hover([fn1,]fn2)`| 当鼠标移入触发第一个 fn1，移出触发 fn2|
|`toggle(fn1,fn2[,fn3..])`| 已废弃，当鼠标点击触发 fn1,再点击触发 fn2...|

```javascript
$('div').hover(function () {//背景移入移出切换效果
    $(this).css('background', 'black'); //mouseenter 效果
}, function () {
    $(this).css('background', 'red'); //mouseleave 效果，可省略
});
```

注意：`.hover()`方法是结合了`.mouseenter()`方法和`.mouseleva()`方法，并非`.mouseover()`
和`.mouseout()`方法。

`.toggle()`有两层含义，一层就如表格中所说（1.9版移除），一层在动画中会用到，在这里不进行讲述，若想实现表格中的效果也特别简单，可以进行如下判断：
```javascript
var flag = 1; //计数器,标记
$('div').click(function () {
    if (flag == 1) { //第一次点击
        $(this).css('background', 'black');
        flag = 2;
    } else if (flag == 2) { //第二次点击
        $(this).css('background', 'blue');
        flag = 3;
    } else if (flag == 3) { //第三次点击
        $(this).css('background', 'red');
        flag = 1;
    }
});
```

---

##  event对象

>JavaScript 在事件处理函数中默认传递了 event 对象，也就是事件对象。但由于浏览器
的兼容性，开发者总是会做兼容方面的处理。jQuery 在封装的时候，解决了这些问题，并且
还创建了一些非常好用的属性和方法。

### 一. 事件对象

处理函数的e就是event事件对象（JS中需做兼容处理），event 对象有很多可用的属性和方法，这里先演示一下：

```javascript
//通过处理函数传递事件对象
$('input').bind('click', function (e) { //接受事件对象参数
    alert(e.type);//打印出click
});
```
下面是一些常用的属性：

|属性名| 描述|
|----|-----|
|`type`|获取这个事件的事件类型的字符串，例如：click|
|`target`|获取绑定事件的 DOM 元素|
|`dat`| 获取事件调用时的额外数据|
|`relatedTarget`|获取移入移出目标点离开或进入（最相邻）的那个 DOM 元素|
|`currentTarget`|获取冒泡前触发的 DOM 元素，等同与 this|
|`pageX/pageY`|获取相对于页面原点（最左上角）的水平/垂直坐标|
|`screenX/screenY`|获取显示器屏幕位置的水平/垂直坐标(非 jQuery 封装)|
|`clientX/clientY`| 获取相对于页面视口的水平/垂直坐标(非 jQuery 封装)|
|`result`|获取上一个相同事件的返回值|
|`timeStamp`|获取事件触发的时间戳|
|`whic`| 获取鼠标的左中右键(1,2,3)，或获取键盘按键|
|`altKey/shiftKey/ctrlKey`|获取是否按下了 alt、shift、ctrl(非jQuery 封装)|

**注意：**

`target`：是获取触发元素的DOM，就是你点了哪个就是哪个。
`currentTarget`：是获取监听元素的DOM，你把事件绑定在谁身上就是谁。

```html
<div style="width:100px;height:100px;background:#999">
    <p style="width:50px;height:50px;background:#333"></p>
</div>
<script>
    $('div').bind('click', function (e) {
    alert(e.target);//点击p时返回p
    });
    $('div').bind('click', function (e) {
        alert(e.currentTarget);//无论何时都返回div，等同this
    });
</script>
```

通过 event.data 获取额外数据，可以是数字、字符串、数组、对象

```javascript
$('input').bind('click', 123, function () { //传递 data 数据
    alert(e.data); //获取数字数据123
});
```
获取鼠标的左中右键
```javascript
$(document).mousedown(function (e) {
    alert(e.which);
});
```
获取键盘的按键
```javascript
$('input').keyup(function (e) {
    alert(e.which);
});
```
//获取触发元素鼠标当前的位置
```javascript
$(document).click(function (e) {
    alert(e.screenY+ ',' + e.pageY + ',' + e.clientY);
});
```

### 二. 冒泡和默认行为
如果看我的百度前端技术学院task0002的笔记的话，应该都知道事件冒泡是怎么样的，事件代理就是根据它来实现的。这里我稍微说一下事件冒泡是什么样的，事件冒泡其实就是在点击一个元素时，会一层一层的向父元素递进当点击一个div时其实是这样的`div -> body -> html -> document`。

下面来看一下冒泡和默认行为的一些方法：

|方法名|描述|
|---|---|
|`preventDefault()`| 阻止某个元素的默认行为|
|`isDefaultPrevented()`| 判断是否调用了 preventDefault()方法|
|`stopPropagation()`| 阻止事件冒泡|
|`isPropagationStopped()`| 判断是否调用了 stopPropagation()方法|
|`stopImmediatePropagation()`| 阻止事件冒泡，并取消该事件的后续事件处理函数|
|`isImmediatePropagationStopped()`| 判断是否调用了 stopImmediatePropagation()方法|

这些方法都是event对象的一些方法，需要注意的是：
先来看到最后两个，名字都长到让人记不住的方法，，如代码中所示：
```javascript
$("div").click(function(e) {
    e.stopImmediatePropagation() ;
    alert("div1");//只弹出div1
});
$("div").click(function(e) {
    alert("div2");//因第一个点击事件取消了该事件的后续处理函数，这里将不被执行
});
```

同时取消默认行为以及事件冒泡：
```html
<a href="//guowenfh.github.io">三省吾身丶丶</a>
<script >
    $("a").click(function(e) {
        // e.preventDefault();//阻止默认行为
        // e.stopPropagation();//阻止事件冒泡
        alert("a");
        return false;
    });
    $(document).click(function(e) {
        alert("document");
    });
</script>
```
注意这段代码中，我们可以看到a被弹出来了，但是链接并没有跳转，而且document也没有被弹出，因为`return false`相当于同时了这两件事情，只不过，在使用表格中的检测方法时，返回的false。
而使用event对象的方法实现阻止时，检测返回true。

## 高级事件
>jQuery 不但封装了大量常用的事件处理，还提供了不少高级事件方便开发者使用。比
如模拟用户触发事件、事件委托事件、和统一整合的 on 和 off，以及仅执行一次的 one 方
法。这些方法大大降低了开发者难度，提升了开发者的开发体验。

### 一. 模拟操作
在事件触发的时候，有时我们需要一些模拟用户行为的操作。例如：当网页加载完毕后自行点击一个按钮触发一个事件，而不是用户去点击。

#### 1. `.trigger()`
先来一个最机械的`.trigger()`：
`<button>点击</button>`

```javascript
$("button").click(function() {
    alert("这里是第一次点击来自模拟！");
});
$("button").trigger('click');
```
打开网页，可以看到内容并不需要被点击，就直接被弹了出来。
当然不会那么复杂，来进阶一下吧，只需要把`.trigger('click')`连在`click`事件之后就可以了，效果当然一样。
但是，这样好像还是有点麻烦，jQuery怎么可能让我们那么麻烦，把添加的字符串删除，添加`.click()`，现在就是这样的：

```javascript
$('input').click(function () {
    alert('我的第一次点击来自模拟！');//效果和上面一样
}).click();
```
这种简单的方法jQuery几乎所有的常用事件都提供了：

|blur|focusin |mousedown| resize|
|----|------|------|------|
|change| focusout| mousenter |scroll|
|click |keydown |mouseleave |select|
|dblclick| keypress| mousemove |submit|
|error |keyup| mouseout| unload|
|focus| load| mouseover|  |

下面来介绍一下`.trigger()`的一些进阶用法，当然如果要进行这样的参数传递的话，就不能使用上面的简单方法了：
有时在模拟用户行为的时候，我们需要给事件执行传递参数，这个参数类似与在事件绑定中的`event.data`的额外数据，可以是数字、字符串、数组、对象。需要注意的是当传递一个值的时候，直接传递即可。当两个值以上，需要在前后用中括号包含起来。

```javascript
$("button").click(function (e, data1, data2) {
    alert(data1.a + "," + data2[1]);//加载后直接弹出1,456
}).trigger("click", [{"a" : "1", "b" : "2"}, ["123","456"]]);
```
在使用`bind`时，`bind`传入的额外数据通过`event.data`获取，该数据传输模式不变。

模拟用户行为时，除了通过 JavaScript 事件名触发，也可以通过自定义的事件触发，所谓自定义事件其实就是一个被.bind()绑定的任意函数。
```javascript
$('input').bind('myEvent', function () {
alert('自定义事件！');
}).trigger('myEvent');
```

#### 2. `.triggerHandler()`
这是另一个模拟用户行为的方法，用法和`trigger()`方法一样。但是在某些情况下有如下区别：

1. `.triggerHandler()`方法并不会触发事件的默认行为，而`.trigger()`会，例如：
```javascript
$('form').trigger('submit'); //模拟用户执行提交，并跳转到执行页面
$('form').triggerHandler('submit'); //模拟用户执行提交，并阻止的默认行为
```

2. `.triggerHandler()`方法只会影响第一个匹配到的元素，而`.trigger()`会影响所有。
3. `.triggerHandler()`方法会返回当前事件执行的返回值，如果没有返回值，则返回
undefined；而`.trigger()`则返回当前包含事件触发元素的 jQuery 对象(方便链式连缀调用)。
4. `.trigger()`在创建事件的时候，会冒泡。但这种冒泡是自定义事件才能体现出来，是
jQuery 扩展于 DOM 的机制，并非 DOM 特性。而`.triggerHandler()`不会冒泡。

### 二. 命名空间
> 有时，我们想对事件进行移除。但对于同名同元素绑定的事件移除往往比较麻烦，这个
时候，可以使用事件的命名空间解决。（主要是处理绑定匿名函数的情况）

```javascript
$("button").bind('click.abc', function(e) {
    alert("abc");
});
$("button").bind('click.xyz', function(e) {
    alert("xyz");
});
$("button").unbind('click.abc' );//处理过后只弹出xyz。
```
**注意：**也可以直接使用`('.abc')`，这样的话，可以移除**相同命名空间的不同事件**。对于模拟操作`.trigger()`和.`triggerHandler()`，用法也是一样的。`$('input').trigger('click.abc')`

### 三.事件委托
> 事件委托也就是事件代理。我在[task0002（二）- DOM + 事件](//guowenfh.github.io/2015/12/16/task0002-DOM&&event/)已经谈过了。而且也自己实现了一下事件代理，这里稍微再介绍一下:

1. “事件代理” 的本质是利用了事件冒泡的特性。当一个元素上的事件被触发的时候，比如说鼠标点击了一个按钮，同样的事件将会在那个元素的所有祖先元素中被触发。这一过程被称为事件冒泡；
2. 这个事件从原始元素开始一直冒泡到DOM树的最上层。任何一个事件的目标元素都是最开始的那个元素，在我们的这个例子中也就是按钮，并且它在我们的元素对象中以属性的形式出现。
3. 使用事件代理，我们可以把事件处理器添加到一个元素上，等待一个事件从它的子级元素里冒泡上来，并且可以得知这个事件是从哪个元素开始的。
4. 对于动态生成的节点同样有效。

实现如下：

```html
<div>
    <button>点击</button>
    <button>点击</button>
</div>
<script>
    $("div").delegate('button',"click", function() {
        alert("点击了");//无论点击哪个都可以弹出
        $("<button>生成</button>").appendTo('div');//点击同时生成节点，同样可以点击弹出
    });
    //$("div").undelegate('button', 'click');//取消事件代理
</script>
```
注意：`.delegate()`需要指定父元素，然后第一个参数是当前元素，第二个参数是事件方式，第三个参数是执行函数。和`.bind()`方法一样，可以传递额外参数。`.undelegate()`和`.unbind()`方法一样可以直接删除所有事件，比如：`.undelegate('click')`。也可以删除命名空间的事件，比如：`.undelegate('click.abc')`。

开胃菜完了，下面才是重点！

## 强大的`on` 、`off` 和`one`
>目前绑定事件和解绑的方法有三组共六个。由于这三组的共存可能会造成一定的混乱，为此 jQuery1.7 以后推出了.on()和.off()方法彻底摒弃前面三组。（暂时未移除）

### 一. `on`

1. 替代`.bind()`方式
```javascript
$('button').on('click', function () {
    alert('替代.bind()');
});
```

2. 替代`.bind()`方式，并使用额外数据和事件对象
```javascript
$('.button').on('click', {user : 'Lee'}, function (e) {
    alert('替代.bind()' + e.data.user);//lee
});
```

3. 替代.bind()方式，并绑定多个事件
```javascript
$('.button').on('mouseover mouseout', function () {
    alert('替代.bind()移入移出！');
});
$('.button').on({//以对象模式绑定多个事件
    mouseover : function () {
        alert('替代.bind()移入！');
    },
    mouseout : function () {
        alert('替代.bind()移出！');
    }
});
```

4. 替代.bind()方式，阻止默认行为并取消冒泡
```javascript
$('form').on('submit', function () {
    return false;
});
$('form').on('submit', false);//在function中只有阻止事件存在时，这样写可以简化代码，效果相同

$('form').on('submit', function (e) {//当然使用事件对象也是可以的
    e.preventDefault();//阻止默认行为
    e.stopPropagation();//取消冒泡
});
```

5. 替代`.delegate()`，事件委托
```javascript
$('div').on('click', 'button', function () {
    $(this).clone().appendTo('div');//每次点击都复制一个button
});
```
**特别注意：**`.on()`和`.delegate()`之间的选择器和事件名称的位置！因为便于多种事件处理方式，将**选择器与事件名称调换了位置**

### 二.`off`

1. 替代`.unbind()`方式，移除事件
```javascript
$('.button').off('click');
$('.button').off('click', fn);
$('.button').off('click.abc');
```

2. 代替`.undelegate()`，取消事件委托
`$('#box').off('click', '.button');`


**注意：**和之前方式一样，事件委托和取消事件委托也有各种搭配方式，比如额外数据、命名空间等等。

### 三. `one`

>不管是.bind()还是.on()，绑定事件后都不是自动移除事件的，需要通过.unbind()和.off()来手工移除。jQuery 提供了.one()方法，绑定元素执行完毕后自动移除事件，可以方法仅触发一次的事件。

1. 类似于.bind()只触发一次
```javascript
$('button').one('click', function () {
    alert('one 仅触发一次！');
});
```

2. 类似于.delegate()只触发一次
```javascript
$('div').one('click', 'button', function (){
    $(this).clone().appendTo('div');//只复制一次
});
```


所以前面的一系列讲述，都是为了抛砖引玉，现在在jQuery中对于事件的处理直接用`on` 、`off` 和`one`这三个就好了！
