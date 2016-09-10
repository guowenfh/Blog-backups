title:  jQuery入门笔记之（一）选择器引擎
date: 2015-12-31 11:26:15
tags: [jQuery]
categories: [jQuery]
---
> 本来是单独整理了一个CSS选择器的，但是在jQuery中基本都有对应的，所以就不发了。
> 
>jQuery选择器，若未作特别说明，获取的都是元素集合。

## 一. 常规选择器

### （一）简单选择器

模仿的是CSS选择器，只不过在使用jQuery选择器时，我们首先必须使用“$()”函数来包装我们的 CSS 规则。
而CSS 规则作为参数传递到jQuery对象内部后，再返回包含页面中对应元素的 jQuery 对象。随后可以进行节点操作，例如：`$('#box').css('color', 'red'); `。

那么除了 ID 选择器之外，还有两种基本的选择器，分别为：元素标签名和类(class)：

|选择器| CSS 模式| jQuery 模式 |描述|
|------|------|---------|-----|
|元素名|`div{}`|` $('div')`|获取所有div元素的 DOM 对象|
|ID|`#box {}`| `$('#box')`| 获取一个 ID 为 box 元素的 DOM 对象|
|类(class)| `.box{}`|`$('.box')`|获取所有class为box的所有DOM对象|


我们可以采用jQuery核心自带的一个属性length来查看返回的元素个数。(`size()`方法已经弃用)

在实践过程中发现使用多个id时，css居然都会高亮，jQuery没有这个问题。（标准写明一个页面只能有一个id）

jQuery选择器的写法与CSS选择器十分类似，只不过他们的功能不同。CSS 找到元素后添加的是单一的样式，而jQuery则添加的是动作行为。重要的是**jQuery兼容性更好**，例如：

```javascript
#box > p { //CSS 子选择器，IE6 不支持
color:red;
}
$('#box > p').css('color','red'); //jQuery 子选择器，兼容了 IE6
```

jQuery选择器支持CSS1、CSS2的全部规则，支持CSS3部分实用的规则，同时它还有少量独有的规则而jQuery选择器在获取节点对象的时候不但简单，还**内置了容错功能**区别如下：

```javascript
$('#pox').css('color', 'red'); //不存在ID为pox的元素，也不报错
document.getElementById('pox').style.color = 'red'; //报错了
```

如何判断jQuery是否调取不存在的元素：

```javascript
if ($('#pox').length > 0) { //jQuery对象，判断元素包含数量即可
    $('#pox').css('color', 'red');
}
//或者转化成DOM对象方式判断
if ($('#pox')[0]) {}; //通过数组下标也可以获取 DOM 对象
if ($('#pox').get(0)) {} ;
```

### （二）进阶选择器

在简单选择器中，我们了解了最基本的三种选择器：元素标签名、ID 和类(class)。那么在基础选择器外，还有一些进阶和高级的选择器方便我们更精准的选择元素

|选择器| CSS 模式 |jQuery 模式| 描述|
|--|--|--|--|
|群组选择器 |`span,.con,.box{}` | `$('span,em,.box')`| 获取多个选择器的 DOM 对象|
|后代选择器| `ul li a{}`|` $('ul li a')`| 获取追溯到的多个 DOM 对象|
|通配选择器| `*{}` | `$('*')` |获取所有元素标签的 DOM 对象|


目前介绍的六种选择器，在实际应用中，我们可以灵活的搭配，使得选择器更加的精准和快速：
```javascript
$('#box p, ul li *').css('color', 'red');//组合了多种选择器
```
**警告：**在实际使用上，通配选择器一般用的并不多，一般只用在局部的环境内。因为在大通配上，比如：`$('*')`，这种使用方法效率很低，影响性能，建议尽可能的少用。(CSS上也很少用)

还有一种选择器，可以在ID和类(class)中指明元素前缀，比如：

```javascript
$('div.box'); //限定.box获取到的元素标签名必须是div
$('p#box div.side'); //同上
```

如同CSS一样，类(class)有一个特殊的模式，就是同一个DOM节点可以声明多个类(class)。那么对于这种格式，我们有多class选择器可以使用，但要**注意和class群组选择器的区别**。
```javascript
.box.pox { //双 class 选择器获取页面中class同时有.box.pox的元素
    color:red;
}
$('.box.pox').css('color', 'red'); //用多个class进行精准确定
```

**注意要点：**

> 只追求必要的确定性。当选择器筛选越复杂，jQuery内部的选择器引擎处理字符串的时间就越长。


### （三）高级选择器

在前面学习了六种最常规的选择器，一般来说通过这六种选择器基本上可以解决所有DOM节点对象选择的问题。但在很多特殊的元素上，比如父子关系的元素，兄弟关系的元素，特殊属性的元素等等并不好获取，下面就来说说这些高级选择器：

|选择器 |CSS 模式| jQuery 模式| 描述|
|--|---|--|--|
|后代选择器 |`ul li a {}`|` $('ul li a') `|获取追溯到的多个 DOM 对象|
|子选择器|` div > p {}`|` $('div p')`| 只获取子类节点的多个 DOM 对象|
|next 选择器（相连）| `div + p {}`|` $('div + p')`| 只获取某节点后一个同级DOM对象|
|nextAll 选择器(之后所有) |`div ~ p {}`| `$('div ~ p')`| 获取某节点后面所有同级DOM对象|

其实后代选择器我们在进阶选择器里面已经有过使用，这里为什么要再提起呢?

因为它属于层次选择器，在高级选择器中，jQuery为这样的选择器都提供了一个相对应的方法。

1. jQuery为后代选择器提供了一个等价的find(）方法:
```javascript
$('#box p').css('color', 'red'); //后代选择器
$('#box').find('p').css('color','red');//和后代选择器等价
```
2. jQuery为子选择器提供了一个等价的children()方法
```javascript
$('#box > p').css('color','red');//子选择器，孙子失明
$('#box').children('p').css('color','red');//和子选择器等价
```
3. jQuery为next选择器提供了一个等价的next()方法：
```
$('#box+p').css('color','red');//下一个同级节点
$('#box').next('p').css('color','red');//和next选择器等价
```
4. jQuery为nextAll选择器提供了一个等价的方法nextAll()：
```
$('#box ~ p').css('color','red');//后面所有同级节点
$('#box').nextAll('p').css('color', 'red'); //和 nextAll 选择器等价
```

**需要注意的是：**

1. 层次选择器对节点的层次都是有要求的，比如子选择器，有子节点才可以被选择到，孙子节点和重孙子节点都无法选择到。next和nextAll选择器，必须是同一个层次的后一个和后N个，不在同一个层次就无法选取到了。
2. 在 `find()`、`children()`、`next()`和`nextAll()`和这四个方法中，如果不传递参数，就相当于传递了“*”，选择所有符合条件的元素，**建议尽量保持参数的传递**


**jQuery独有补充方法。CSS未含有**

```javascript
$('#box').prev('p').css('color','red');//同级上一个元素
$('#box').prevAll('p').css('color','red');//同级上面所有的元素

$('#box').prevUntil('p').css('color','red');//同级上非指定元素选定，遇到则停止
$('#box').nextUntil('p').css('color','red');//同级下非指定元素选定，遇到则停止

$('#box').siblings('p').css('color','red');//siblings()方法正好集成了prevAll()和nextAll()两个功能的效果，及上下相邻的所有元素进行选定：
```

**扩展：**

```javascript
$('p', '#box');//jQuery会自动把这条语句转成$('#box').find('p')，这会导致一定的性能损失。

$('p', $('#parent'));//jQuery内部会也将这条语句转成$('#box').find('p')
```

这里，**推荐使用jQuery提供的方法。**使用“+”或“~”从字面上没有next和nextAll更加语义化，更加清晰，jQuery的方法更加丰富，提供了相对的prev和prevAll。
并且有时需要能够灵活的拆分和组合选择器。所以，如果jQuery提供了独立的方法来代替某些选择器的功能，推荐优先使用独立的方法。

### （四）属性选择器
> 注意`¦`应该是`|`，因为markdown表格解析的问题，所以用来替代

|CSS 模式| jQuery模式| 描述|
|-------|--------|---------|
| `a[title]`| `$('a[title]')`| 获取具有这个属性的 DOM 对象|
| `a[title=num1]` | `$('a[title=num1]')` | 获取具有这个属性=这个属性值的DOM对象 | 
| `a[title^=num]` | `$('a[title^=num]')` | 获取具有这个属性且开头属性值匹配的DOM对象 | 
| `a[title¦=num]` | `$('a[title¦=num]')` | 获取具有这个属性且等于属性值或开头属性值匹配后面跟一个`-`号的DOM对象 | 
| `a[title$=num]` | `$('a[title$=num]')` | 获取具有这个属性且结尾属性值匹配的DOM对象 | 
| `a[title!=num]` | `$('a[title!=num]')` | 获取不具有这个属性或不等于该属性值的DOM对象 | 
| `a[title~=num]` | `$('a[title~=num]')` | 获取具有这个属性且属性值是以一个空格分割的列表，其中包含属性值的DOM对象
| `a[title*=num]` | `$('a[title*=num]')` | 获取具有这个属性且属性值含有一个指定字串的DOM对象 | 
| `a[bbb][title=num1]` | `$('a[bbb][title=num1]')` | 获取具有这个属性且属性值匹配的DOM对象 | 


## 二. 过滤选择器

### （一）基本过滤器

| 过滤器名 |  jQuery 语法  | 说明 |  返回 | 
|----| ---|----|-----|
|`:first`|` $('li:first') `|选取第一个元素 |单个|
|`:last `|`$('li:last') `|选取最后一个元素 |单个|
|`:not(selector)`|`$('li:not(.red)')`|选取class不是red的li元素|集合|
|`:even`|` $('li:even')`|选择索引(以下几个都是从0开始)是偶数的所有元素 |集合|
|`:odd `|`$('li:odd')`| 选择索引是奇数的所有元素 |集合|
|`:eq(index)`|`$('li:eq(2)')`|选择索引等于index的元素(负数从后开始)|单个|
|`:gt(index)`|`$('li:gt(2)')`|选择索引大于index的元素|集合|
|`:lt(index)`|`$('li.lt(2)')`|选择索引小于index的元素|集合|
|`:header`|`$(':header') `|选择标题元素，h1~h6 |集合|
|`:animated`|` $(':animated') `|选择正在执行动画的元素 |集合|
|`:focus`|` $(':focus') `|选择当前被焦点的元素 |集合|


**注意：**`:focus`过滤器，必须是网页初始状态的已经被激活焦点的元素才能实现元素获取。而不是鼠标点击或者Tab键盘敲击激活的。
```javascript
$('input').get(0).focus(); //先初始化激活一个元素焦点
$(':focus').css('background', 'red'); //被焦点的元素
```

jQuery为最常用的过滤器提供了专用的方法，如下：

```javascript
$('li').eq(2).css('background','#ccc');//元素li的第三个元素，负数从后开始
$('li').first().css('background','#ccc');//元素li的第一个元素
$('li').last().css('background','#ccc');//元素li的最后一个元素
$('li').not('.red').css('background','#ccc');//元素li不含class为red的元素
```

### （二）内容过滤器
内容过滤器的过滤规则主要是包含的子元素或文本内容上。

|过滤器名|jQuery语法 |说明|
|---|---|---|
|`:contains(text)`|`$(':contains("ycku.com")')`|选取含"ycku.com"文本的元素|
|`:empty`|`$(':empty')`|选取不包含子元素或空文本的元素| 
|`:has(selector)`|`$(':has(.red)')`|选取含有class是red的元素(在父元素调用)|
|`:parent`|`$(':parent')`|选取含有子元素或文本的元素|

jQuery 提供了一个 has()方法来提高:has 过滤器的性能：
```javascript
$('ul').has('.red').css('background', '#ccc'); //选择子元素含有 class 是 red 的元素
```


jQuery提供了一个名称和:parent相似的方法，但这个方法并不是选取含有子元素或文本的元素，而是获取当前元素的父元素，返回的是元素集合。

```javascript
$('li').parent().css('background','#ccc');//选择当前元素的父元素
$('li').parents().css('background','#ccc');//选择当前元素的父元素及祖先元素（追溯到html）
$('li').parentsUntil('html').css('background','#ccc');//选择当前元素遇到html父元素停止（会在body上加）
```

### （三）可见性过滤器
可见性过滤器根据元素的可见性和不可见性来选择相应的元素。

|过滤器名| jQuery 语法| 说明 |
|---|---|---|
|`:hidden`|` $(':hidden')` |选取所有不可见元素|
|`:visible`|` $(':visible')`| 选取所有可见元素|

**注意：**:hidden过滤器一般是包含的内容为：CSS样式为`display:none`、input表单类型为`type="hidden"`和`visibility:hidden`的元素。


### （四）子元素过滤器
子元素过滤器的过滤规则是通过父元素和子元素的关系来获取相应的元素。

|过滤器名|jQuery语法|说明|
|---|---|---|---|
|`:first-child`|`$('li:first-child')`|获取每个父元素的第一个子元素|
|`:last-child`|`$('li:last-child')`|获取每个父元素的最后一个子元素|
|`:only-child`|`$('li:only-child')`|获取有且只有一个子元素的元素|
|`:nth-child(odd/even/index)`支持表达式，如2n等同even|`$('li:nth-child(even)')`|获取每个自定义子元素的元素(索引值从 1 开始计算)|


### （五）其他方法
jQuery 在选择器和过滤器上，还提供了一些常用的方法，方便我们开发时灵活使用。

|方法名| jQuery 语法 |描述|
|---|---|---|
|`is(s/o/e/f)`|`$('li').is('.red')`返回布尔值|传递选择器、DOM、jquery对象或是函数来匹配元素集合，如果这些元素中至少有一个元素匹配给定的参数，返回true|
|`hasClass(class)`|`$('li').eq(2).hasClass('red')`|其实就是`is("." + class)`,但只能传递class|
|`slice(start, end)`|`$('li').slice(0,2)`|选择从start到end位置的元素，如果是负数，则从后开始|
|`filter(s/o/e/f)`|`$('li').filter('.red')`|筛选元素集合中匹配表达式或通过传递函数测试的那些元素集合。|
|`end() `|`$('div').find('p').end()`|获取当前元素的前一个状态的元素(同级或父级) |
|`contents()`|`$('div').contents()`|获取某元素下面所有元素节点，包括文本节点，如果是iframe，则可以查找文本内容|

**is:**

```javascript
$('.red').is('li'); //选择器，检测class为是否为 red
$('.red').is($('li')); //jQuery 对象集合，同上
$('.red').is($('li').eq(2)); //jQuery 对象单个，同上
$('.red').is($('li').get(1)); //DOM 对象，同上
```
还可以进行各种自定义判断：
```html
<ul>
  <li>list <strong>item 1</strong></li>
  <li><span>list item 2</span></li>
  <li>list item 3</li>
</ul>
<script>
$("ul").click(function(event) {
  var $target = $(event.target);
  if ( $target.is("li") ) {
    $target.css("background-color", "red");
  }
});
</script>
```
当用户点击的是第一个列表项中的单词`"list"`或第三个列表项中的任何单词时，被点击的列表项会被设置为红色背景。
不过，当用户点击第一个列表项中的`item1`或第二个列表项中的任何单词时，都不会有任何变化，这是为这上面的情况中，事件的目标分别是 `<strong> `是 `<span>`。

**slice:**
```javascript
$('li').slice(0,2).css('color', 'red'); //前三个变成红色
```
**注意：**这个参数有多种传法和JavaScript中的slice方法是一样的比如：slice(2)，从第三个开始到最后选定；slice(2,4)，第三和第四被选定；slice(0,-2)，从倒数第三个位置，向前选定所有；slice(2,-2)，前两个和末尾两个未选定。

**filter：**
```javascript
$('li').filter('.red').css('background','#ccc');//选择li的class为red的元素
$('li').filter('.red,:first,:last').css('background','#ccc');//增加了首尾选择
//特殊要求函数返回
$('li').filter(function(){
    return $(this).attr('class')=='red' && $(this).attr('title')=='列表3';
}).css('background', '#ccc');
```
此处注意`$(this)`的使用，这把this包装成了jQuery对象，以便使用jQuery的方法。

## 三. 表单选择器

### （一）常规选择器
其实使用上面的选择器已经能对表单元素进行选取了，先来验证一下，来看看如何利用上面的方法来进行表单元素的选择。

```javascript
//val()是jQuery用来获取表单元素文本内容的一个方法
$('input').val(); //元素名定位，默认获取第一个
$('input').eq(1).val(); //同上，获取第二个
$('input[type=password]').val();//选择type为password的字段
$('input[name=user]').val(); //选择 name 为 user 的字段
```
很显然，上面的这个方法都能选择到想要的元素，那么对于 id 和class基本一致，也可以结合属性选择器来精确的定位，在这里我们不在重复。
对于表单中的其他元素名比如：textarea、select 和 button 等，原理一样，不在重复。
但是这样是不是太过于复杂了呢？假如我们要同时选择input、textarea、select 和 button？继续看吧。

### （二）表单选择器
虽然可以使用常规选择器来对表单的元素进行定位，但有时还是不能满足开发者灵活多变的需求，而且也太过于繁琐。所以，jQuery为表单提供了专用的选择器。

|方法名| 描述|
|----|----|
|`:input`| 选取所有 `input`、`textarea`、`select` 和 `button`元素|
|`:text `|选择所有单行文本框，即 `type=text`|
|`:password`| 选择所有密码框，即 `type=password`|
|`:radio`| 选择所有单选框，即 `type=radio`|
|`:checkbox`| 选择所有复选框，即 `type=checkbox`|
|`:submit `|选取所有提交按钮，即 `type=submit`|
|`:reset `|选取所有重置按钮，即 `type=reset`|
|`:image `|选取所有图像按钮，即 `type=image`|
|`:button`| 选择所有普通按钮，即 `button 元素`|
|`:file `|选择所有文件按钮，即 `type=file`|
|`:hidden `|选择所有不可见字段，即 `type=hidden`|

**注意：**
1. 由于这些选择器都是返回元素集合，如果想获取某一个指定的元素，最好结合一下属性选择器。比如：
```javascript
$(':text[name=user]).size(); //获取单行文本框 name=user 的元素
```
2. 在使用这些属性时最好界定父元素，比如直接`$(":hidden").length`这样是不正确的，因为它还会选择到`head`标签内的元素，所以length属性不会为0，建议使用这样的形式：`$("form :hidden")`

### （三）表单过滤器
jQuery 提供了四种表单过滤器，分别在是否可以用、是否选定来进行表单字段的筛选过滤。

|方法名| 描述|
|----|-----|
|`:enabled `|选取所有可用元素|
|`:disabled`| 选取所有不可用元素|
|`:checked`|选取所有被选中的元素，单选和复选字段|
|`:selected`| 选取所有被选中的元素，下拉列表|
