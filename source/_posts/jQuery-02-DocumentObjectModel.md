title: jQuery入门笔记之（二）文档对象模型
date: 2015-12-31 11:39:11
tags: [jQuery]
categories: [jQuery]
---

## 基础 DOM 和 和 CSS 

### 一. 设置元素及内容
我们通过前面所学习的各种选择器、过滤器来得到我们想要操作的元素。这个时候，我们就可以对这些元素进行 DOM 的操作。
那么，最常用的操作就是对元素内容的获取和修改。`html()`和 `text()`方法:

|方法名| 描述|区分|
|---|---|---|
|`html() `|获取元素中 HTML 内容|连同标签一起提取|
|`html(value) `|设置元素中 HTML 内容|清空原数据，设置html内容|
|`text() `|获取元素中文本内容|自动清理html标签|
|`text(value) `|设置元素中文本内容|自动转义html标签以文本形式呈现|
|`val() `|获取表单中的文本内容|value属性的值|
|`val(value) `|设置表单中的文本内容|设置value的值(有特殊用法)|


**注意：**当我们使用` html()`或 `text()`设置元素里的内容时，会清空原来的数据。而我们期望能够追加数据的话，需要先获取原本的数据。

```javascript
$('#box').html($('#box').html() + '<em>guowenfh.github.io</em>'); //追加数据
//当然它还支持使用函数来进行更复杂的追加
```

**`val()`的特殊用法：**
如果想设置多个选项的选定状态，比如下拉列表、单选复选框等等，可以通过数组传递操作。
```javascript
$("input").val(["check1","check2", "radio1"]); //value 值是这些的将被选定
```


### 二. 元素属性操作

除了对元素内容进行设置和获取，通过jQuery也可以对元素本身的属性进行操作，包括获取属性的属性值、设置属性的属性值，并且可以删除掉属性。
`attr()`和`removeAttr()`：

|方法名| 描述|
|---|---|
|`attr(key)`| 获取某个元素 key 属性的属性值|
|`attr(key, value)`| 设置某个元素 key 属性的属性值|
|`attr({key1:value2, key2:value2...})`| 设置某个元素多个 key 属性的属性值|
|`attr(key, function (index, value){})`|  通过 fn 来设置设置某个元素 key属性|


**注意：**
1. jQuery中很多方法都可以使用 `function() {}`来返回出字符串，比如 `html()`、`text()`、`val()`和上一章刚学过的 `is()`、`filter()`方法。
这些方法里的`function() {}`，可以不传参数。可以只传一个参数 `index`，表示当前元素的索引(从0开始)。也可以传递两个参数 `index`、`value`，第二个参数表示属性原本的值。
(当然并不是所有方法都适合，有兴趣可以自己逐个尝试)。
2. 删除指定的属性，这个方法就不可以使用匿名函数，传递`index`和`value`均无效。`$('div').removeAttr('title'); //删除指定的属性`
3. 当然因为`id`和`class`也是元素的属性，自然也可以使用attr进行设置，但是建议不这样使用，因为会导致整个页面结构的混乱，有专门的属性对它们进行设置。


### 三. 元素样式操作
元素样式操作包括了直接设置 CSS 样式、增加 CSS 类别、类别切换、删除类别这几种操作方法。使用频率极高！

|方法名 |描述|
|---|----|
|`css(name) `|获取某个元素行内的 CSS 样式|
|`css([name1, name2, name3]) `|获取某个元素行内多个 CSS 样式|
|`css(name, value) `|设置某个元素行内的 CSS 样式|
|`css(name, function (index, value) ) `|设置某个元素行内的 CSS 样式|
|`css({name1 : value1, name2 : value2}) `|设置某个元素行内多个 CSS 样式，键值对|
|`addClass(class) `|给某个元素添加一个 CSS 类|
|`addClass(class1 class2 class3...) `|给某个元素添加多个 CSS 类|
|`removeClass(class) `|删除某个元素的一个 CSS 类|
|`removeClass(class1 class2 class3...) `|删除某个元素的多个 CSS 类|
|`toggleClass(class) `|来回切换默认样式和指定样式|
|`toggleClass(class1 class2 class3...) `|同上|
|`toggleClass(class, switch) `|来回切换样式的时候设置切换频率|
|`toggleClass(function () {}) `|通过匿名函数设置切换的规则|
|`toggleClass(function () {}, switch) `|在匿名函数设置时也可以设置频率|
|`toggleClass(function (i, c, s) {}, switch) `|在匿名函数设置时传递三个参数|

**理解：**

在获取多个 CSS 样式时，获取到的是一个对象数组，如果用原生JS进行解析需要使用`for in`遍历。

```javascript
var box = $('div').css(['color', 'height', 'width']); //得到多个 CSS 样式的数组对象
for (var i in box) { //逐个遍历出来
    alert(i + ':' + box[i]);
}
```

在jQuery显然不需要那么麻烦，因为它提供了一个遍历工具专门来处理这种对象数组，`$.each()`方法，这个方法可以轻松的遍历对象数组。

```javascript
/**
 * 遍历对象数组
 * @param  {String} index 索引，鍵，属性名
 * @param  {String} value  属性值，值（相当于arr[i]）
 */
//遍历原生JS对象数组时，value为元素DOM。
$.each(box, function(index, value) {
    alert(index+":"+value);//效果和上面的一样
});
```


如果想设置某个元素的 CSS 样式的值，但这个值需要计算我们可以传递一个匿名函数。
```javascript
$('div').css('width', function (index, value) {
return (parseInt(value) - 50) + 'px';//局部操作，不影响全局，避免冲突。
});
```

在使用`.toggleClass()`使用时，可以使用传入匿名函数的方法，实现由默认到几个class之间的切换。例如：
```javascript
//注意这里必须要先删除原有的样式，不然只是被覆盖了，而不是替换。
$('div').click(function() {
    $(this).toggleClass(function() {
        if ($(this).hasClass('red')) {
            $(this).removeClass('red');
            return 'blue';
        } else {
            $(this).removeClass('blue');
            return 'red';
        }
    });
});
```

对于`.toggleClass()`传入匿名函数的方法，还可以可以传递 `index`索引、`class`类两个参数以及频率布尔值，可以得到当前的索引、class类名和频率布尔值。


### 四. CSS方法

#### （一）width()方法

|方法名| 描述|
|----|----|
|`width()`| 获取某个元素的宽度(number)|
|`width(value)`| 设置某个元素的宽度(无单位时，默认px)| 
|`width(function (index, width) {})`| 通过匿名函数设置某个元素的宽度|

虽然可以不加单位，但是建议加上，使代码更加清晰。
index 是索引，value 是原本值。

#### （二）height()方法
|方法名 |描述|
|---|---|
|`height()`| 获取某个元素的高度|
|`height(value)`| 设置某个元素的高度|
|`height(function (index, height) {})`| 通过匿名函数设置某个元素的高度|

上述两个方法不包括内外边距和边框

#### （三）内外边距和边框尺寸方法

|方法名 |描述|
|---|---|
|`innerWidth()`| 获取元素宽度，包含内边距 padding|
|`innerHeight()`| 获取元素高度，包含内边距 padding|
|`outerWidth()`| 获取元素宽度，包含边框 border 和内边距 padding|
|`outerHeight()`| 获取元素高度，包含边框 border 和内边距 padding|
|`outerWidth(ture)`| 同上，且包含外边距(注意里面的true)|
|`outerHeight(true)`| 同上，且包含外边距|


#### （四）元素偏移方法
|方法名 |描述|
|---|---|
|`offset()`| 获取某个元素相对于视口的偏移位置(无论定位与否)|
|`position()`| 获取某个元素相对于父元素的偏移位置|
|`scrollTop()`| 获取垂直滚动条的位置|
|`scrollTop(value)`| 设置垂直滚动条的位置|
|`scrollLeft()`| 获取水平滚动条的值|
|`scrollLeft(value)`| 设置水平滚动条的值|


**注意：**
前两个方法，获取得到的是一个对象，如：`{left:12,top:32}`，所以需要获取其中的一个值的时候，还需要进行选取，例如：`$(div).offset.left`。获取相对与视口的偏移。

在获取滚动条的值时需要注意的是，对象为window且需要用$包装转化成jQ对象
```javascript
$(window).scrollTop(); //获取当前滚动条的位置
$(window).scrollTop(300); //设置当前滚动条的位置
```


## DOM 节点操作

DOM中有一个非常重要的功能，就是节点模型，也就是DOM中的“M”。页面中的元素结构就是通过这种节点模型来互相对应着的，我们只需要通过这些节点关系，可以创建、插入、替换、克隆、删除等等一些列的元素操作。

### 一. 创建节点
为了使页面更加智能化，有时我们想动态的在 html 结构页面添加一个元素标签，那么在插入之前首先要做的动作就是：创建节点。
在jQuery中创建节点异常简单。
```javascript
var box = $('<div id="box">节点</div>'); //创建一个节点
$('body').append(box); //将节点插入到<body>元素内部
```

### 二． 插入节点
在创建节点的过程中，其实我们已经演示怎么通过.append()方法来插入一个节点。但仅仅这个功能远远不能满足我们的需求，除了这个方法，jQuery提供了其他几个方法来插入节点。

#### 内部插入节点方法

|方法名| 描述|
|-----|-----|
|`append(content)`| 向指定元素内部后面插入节点content|
|`append(function (index, html) {})`| 使用匿名函数向指定元素内部后面插入节点|
|`appendTo(content)`| 将指定元素移入到指定元素content 内部后面|
|`prepend(content)`| 向指定元素content 内部的前面插入节点|
|`prepend(function (index, html) {})`| 使用匿名函数向指定元素内部的前面插入节点|
|`prependTo(content)`| 将指定元素移入到指定元素 content 内部前面|

需要注意的是`appendTo(content)`与`prependTo(content)`在使用方法上与其他两个略微有些不同，`$("<em>new</em>").appendTo("div");`，它代表的是创建的节点传入div内部。

匿名函数方式：

```javascript
$('div').append(function (index, html) {
 //使用匿名函数插入节点index是获取到的div的索引，html 是原节点
    if(index==1){
        return '<strong>节点</strong>';//在获取到的第二个div内部添加节点
    }
});
```

#### 外部插入节点方法

|方法名 |描述|
|---|---|
|`after(content)`| 向指定元素的外部后面插入节点 content|
|`after(function (index, html) {})`| 使用匿名函数向指定元素的外部后面插入节点|
|`before(content)`| 向指定元素的外部前面插入节点 content|
|`before(function (index, html) {})`| 使用匿名函数向指定元素的外部前面插入节点|
|`insertAfter(content)`| 将指定节点移到指定元素 content 外部的后面|
|`insertBefore(content)`| 将指定节点移到指定元素 content 外部的前面|

与上面相同`insertAfter(content)` 与`insertBefore(content)`也与其它两个是相反的。


### 三．包裹节点
jQuery 提供了一系列方法用于包裹节点，那包裹节点是什么意思呢？其实就是使用字符串代码将指定元素的代码包含着的意思。

|方法名| 描述|
|----|----|
|`wrap(html)`| 向指定元素包裹一层 html 代码|
|`wrap(element)`| 向指定元素包裹一层 DOM 对象节点|
|`wrap(function (index) {})`| 使用匿名函数向指定元素包裹一层自定义内容|
|`unwrap()`| 移除一层指定元素包裹的内容（多层需移除多次）|
|`wrapAll(html)`| 用 html 将所有元素包裹到一起|
|`wrapAll(element)`| 用 DOM 对象将所有元素包裹在一起|
|`wrapInner(html)`| 向指定元素的子内容包裹一层 html|
|`wrapInner(element)`| 向指定元素的子内容包裹一层 DOM 对象节点|
|`wrapInner(function (index) {})`| 用匿名函数向指定元素的子内容包裹一层|

wrap的多种用法：
```javascript
$('div').wrap('<strong class="ing"></strong>'); //在 div 外层包裹一层 strong
$('div').wrap('<strong>123</strong>'); //包裹的元素可以带内容
$('div').wrap('<strong><em></em></strong>'); //包裹多个元素
$('div').wrap($('strong').get(0)); //也可以包裹一个原生 DOM
$('div').wrap(document.createElement('strong')); //临时的原生 DOM
$('div').wrap(function (index) { //匿名函数
    return '<strong></strong>';
});
```


**注意：** `.wrap()`和`.wrapAll()`的区别在前者把每个元素当成一个独立体，分别包含一层外层；后者将所有元素作为一个整体作为一个独立体，只包含一层外层。这两种都是在外层包含，而`.wrapInner()`在内层包含。

### 四. 节点操作

|方法名|描述|参数解析|
|-----|-----|----|
|`$('div').clone(true); `|复制一个节点|true时表示同时复制事件行为，空或false都表示只复制元素及内容|
|`$('div').remove("#box");`|删除一个id=box的div元素|无参数时，表示直接删除元素|
|`$('div').detach();`|保留事件行为的删除|同上|
|`$('div').empty();`|清空节点里的内容|无参数|
|`$(selector).replaceWith(content);`|将 $(selector) 替换成 content 元素|HTML字符串，DOM元素，或者jQuery对象|
|`$(content).replaceAll(selector); `|同上|参数selector为被替换的元素，content为替换的内容。|

**注意：**
1. `.remove()`和`.detach()`都是删除节点，而删除后本身方法可以返回当前被删除的节点对象，但区别在于前者在恢复时不保留事件行为，后者则保留。
2. 节点被替换后，所包含的事件行为就全部消失了。
3. 注意`replaceWith()`和`replaceAll()`方法替换的操作的**内容和被替换元素所在的位置不同**


