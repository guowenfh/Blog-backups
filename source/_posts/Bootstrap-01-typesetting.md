title: Bootstrap入门笔记之（一）排版
date: 2016-01-18 13:40:46
tags: [Bootstrap]
categories: [Bootstrap]
---

## 1. 标题

在Bootstrap中使用标题的方式和常规html一样：从`<h1>`到`<h6>`分别从大到小安排标题元素，只不过在Bootstrap中重新设置了其默认样式，从源码中可以看到有如下共性：

字体颜色与字体样式继承自父元素，字体粗细为500，且行高全部设为1.1（也就是font-size的1.1倍）

```
{
    font-family: inherit;
    font-weight: 500;
    line-height: 1.1;
    color: inherit;
}
```


在不同大小的标题中有着如下区别：

1. 在Bootstrap中对于不同级别标题字体大小设置为：**h1=36px，h2=30px，h3=24px，h4=18px，h5=14px和h6=12px。**
2. 重新设置了**margin-top**和**margin-bottom**的值，**h1~h3**重置后的值都是**20px**；**h4~h6**重置后的值都是**10px**。


除此之外在Bootstrap中为了**让非标题元素和标题使用相同的样式**，还特意定义了**.h1~.h6**六个类名。如下所示：

在Bootstrap中，下面的代码，显示效果相同。

```html
<!--Bootstrap中的标题-->
<h1>Bootstrap标题一</h1>
<h2>Bootstrap标题二</h2>
<h3>Bootstrap标题三</h3>
<h4>Bootstrap标题四</h4>
<h5>Bootstrap标题五</h5>
<h6>Bootstrap标题六</h6>

<!--Bootstrap中让非标题元素和标题使用相同的样式-->
<div class="h1">Bootstrap标题一</div>
<div class="h2">Bootstrap标题二</div>
<div class="h3">Bootstrap标题三</div>
<div class="h4">Bootstrap标题四</div>
<div class="h5">Bootstrap标题五</div>
<div class="h6">Bootstrap标题六</div>
```


因为在实际应用中，我们可能经常会遇到除了主标题外，之后紧跟着一个副标题的情况。Bootstrap人性化的为我们设置了这样一个效果。使用方式也特别简单，如下：

```html
<h1>Bootstrap标题一<small>我是副标题</small></h1>
```
当然毋庸置疑的是，从`<h1>`到`<h6>`都可以使用该设置。副标题`<small>`有着自己一些独特的样式：

1. 行高全部都设置为了1，而且字体粗细变成了常规效果（不加粗），同时颜色被设置为灰色（`#999`）。
2. 在h1~h3内的`<small>`标签文本，其大小都设置为当前字号的65%；而在h4~h6内的字号都设置为当前字号的75%；

## 2. 正文文本

Bootstrap中的文本全局样式如下：

1. 字体大小为14px
2. 行高为1.42867143（约等于20px）
3. 字体颜色为`#333`
4. p标签外部有着10个像素的下外边距`margin-bottom:10px;`

当然，你是可以自行设置重置样式的。^_^



## 3. 强调 

### 字体风格相关

```html
<p class="lead">lead</p><!-- 字体变大，行高变大，下外边距变大 -->
<i>i</i><!--无特殊意义， 斜体 -->
<small>small</small><!-- 小号字体-->
<strong>strong</strong><!-- 语气强烈的强调，粗体 -->
<em>em</em><!-- 强调，斜体 -->

```

### 强调相关的类

在Bootstrap中定义了一系列的这样的类，用于不同的情景，出去text外，还有bg（背景颜色）等等。使用方法类似，只是前面的文本进行了一些改变！所以。**记住这6个单词吧**

```html
<p class="text-muted">提示，使用浅灰色（#999）</p>
<p class="text-primary">主要，使用蓝色（#428bca）</p>
<p class="text-success">成功，使用浅绿色(#3c763d)</p>
<p class="text-info">通知信息，使用浅蓝色（#31708f）</p>
<p class="text-warning">警告，使用黄色（#8a6d3b）</p>
<p class="text-danger">危险，使用褐色（#a94442）</p>
```

## 4. 文本对齐风格

```html
<p class="text-left">我居左</p>
<p class="text-center">我居中</p>
<p class="text-right">我居右</p>
<p class="text-justify">我两端对齐</p>
```

在Bootstrap中，为了简化操作，方便使用，使用了上面这四个类分别对应我们在CSS中常常使用**text-align**来实现文本的对齐风格的设置。

## 5. 列表

在Bootstrap中对于列表的设置与原生的html基本一致，需要注意的有：

1. 在列表之间有10px的下外边距
2. 在嵌套列表中，不含有下边距

Bootstrap当然不会就这么简单做一点点修改，它定义了一些关于列表的类给我们使用。

### 去点列表`.list-unstyled`

```css
.list-unstyled {
    padding-left: 0;
    list-style: none;
}
```

从源码中，我们可以看到这样的信息，它除了将项目编号去除之外，还将默认的左边距也清除掉了。

```
<ol>
    <li class="list-unstyled">
    项目列表
        <ul class="list-unstyled">
        <li>带有项目编号</li>
        <li>带有项目编号</li>
        </ul>
    </li>
</ol>
```
在这样一段代码中，三个列表项会整齐的**排列在一起**，且都没有**项目符号**


### 内联列表`.list-inline`

除了去点列表之外，Bootstrap还可以通过添加类名“.list-inline”来实现内联列表，简单点说就是**把垂直列表换成水平列表，而且去掉项目符号（编号），保持水平显示。**也可以说内联列表就是为制作水平导航而生。

### 水平定义列表`.dl-horizontal` 

现有代码如下：

```html
<dl class="dl-horizontal">
    <dt>标题一：</dt>
    <dd>描述内容，我很喜欢前端，也很喜欢响应式布局，它能在个不同大小的屏幕下提供很好的体验，我现在是初学者，但是我会越来强的</dd>
    <dt>标题二：标题二：标题二：标题二：</dt>
    <dd>描述内容</dd>
</dl>
```

在浏览器全屏显示中可以看到效果如下：

![自定义水平列表大屏](/images/Bootstrap/horizontal1.jpg)

我们来把屏幕大小进行改变，在遇到一个临界值时（小屏），水平定义列表将回复到原始的状态，如下改变：

![自定义水平列表小屏](/images/Bootstrap/horizontal2.jpg)

这是为什么呢？我们去看看源码吧！
原来在这里添加了一个媒体查询，只有**屏幕大于768px**的时候，添加类名`.dl-horizontal`才具有水平定义列表效果。其实现主要方式：

1. **将dt设置了一个左浮动，并且设置了一个宽度为160px**
2. **将dd设置一个margin-left的值为180px，达到水平的效果**
3. **当标题宽度超过160px时，将会显示三个省略号**

现在再看看上面的效果是不是和这里的描述都是一样的呢？答案当然是肯定的 ^ ^

## 6. 代码

在Bootstrap主要提供了三种代码风格：

1. 使用`<code></code>`来显示单行内联代码——针对于**单个单词或单个句子**的代码
2. 使用`<pre></pre>`来显示多行块代码——针对于**多行代码**（也就是成块的代码）
3. 使用`<kbd></kbd>`来显示用户输入代码——表示**用户要通过键盘输入的内容**

直接来看效果吧!

![code风格](/images/Bootstrap/code1.jpg)

代码如下：（需要注意的是，**不管使用哪种代码风格，在代码中碰到小于号（`<`）和大于号（`>`）都需要使用转义字符来替代）

```html
code风格：
<div>Bootstrap的代码风格有三种：<code>&lt;code&gt;</code>、<code>&lt;pre&gt;</code>和<code>&lt;kbd&gt;</code></div>
pre风格：
<div>
<pre>
&lt;ul&gt;
    &lt;li&gt;...&lt;/li&gt;
&lt;/ul&gt;
</pre>
</div>
kbd风格：
<div>请输入<kbd>ctrl+c</kbd>来复制代码，然后使用<kbd>ctrl+v</kbd>来粘贴代码</div>
```

`<pre>`元素一般用于显示大块的代码，并保证原有格式不变。但有时候代码太多，而且不想让其占有太大的页面篇幅，就想控制代码块的大小。Bootstrap也考虑到这一点，你只需要在**pre标签**上添加类名`.pre-scrollable`，就可以控制代码块区域**最大高度为340px**，一旦超出这个高度，就会在**Y轴（纵向）出现滚动条。**

当然，你也可以进行自定义配置，例如：只需要在自定义的css中，对于该类添加一个`word-wrap: normal;`，这样的话，在代码块边框横向宽度小于内部代码横向长度时，就会出现横向滚动条。

## 7. 表格

表格是Bootstrap的一个基础组件之一，Bootstrap为表格提供了**1种基础样式**和**4种附加样式**以及**1个支持响应式的表格**。

对应上面所说的，Bootstrap为表格不同的样式风格提供了不同的类名，主要包括：

| `.table`|基础表格|
|:-----:|:------:|
| `.table-striped`|斑马线表格|
| `.table-bordered`|带边框的表格|
| `.table-hover`|鼠标悬停高亮的表格|
| `.table-condensed`|紧凑型表格|
| `.table-responsive`|响应式表格|

`.table`主要有三个作用：

-  给表格设置了margin-bottom:20px以及设置单元内距
-  在thead底部设置了一个2px的浅灰实线
-  每个单元格顶部设置了一个1px的浅灰实线

具体大家可以在源码中查看，后几种附加的样式在这里也不多说，但是下面说一些**注意事项：**

1. 后几种表格附加样式，必须在基础样式`.table`之后，例如`<table class="table table-bordered table-hover">`
2. 响应式表格：其原理是在表格**外部添加容器**把普通表格**包裹**起来，下面进行详细说明：

```html
<div class="table-responsive"><!-- 关键！容器包裹后实现响应式 -->
   <table class="table table-bordered"><!-- 设置表格样式，带边框的表格 -->
   <thead><!-- 一个表格应该有表头，若直接写tr>td这样的结构，浏览器会自动创建一个tbody包裹 -->
   </thead>
   <tbody><!--与上同理，即使你不创建，浏览器也会自动添加tbody包裹你的代码  -->
   </tbody>
 </table>
 </div>
```

下面是宽屏的效果（和普通的表格无区别）：

![表格行的类](/images/Bootstrap/table-broad.png)

此处是窄屏的效果（可以看到滚动条的出现）：
![表格行的类](/images/Bootstrap/table-Narrow.png)

### 表格行的类，表格情景

在上面已经说到了在Bootstrap中，为不同的情景做了不一样的颜色，用于不同的信息展示。只是在类名上做了一些小小的改变。下面就可以看到：（图片来自[慕课网](http://www.imooc.com)）

![表格行的类](/images/Bootstrap/table.jpg)

只需要在**`<tr>`**标签添加上这些类就可以使用了。
除此之外，通过源码可以看到，在这些颜色设置之外，Bootstrap还单独设置了**hover效果（悬浮状态）**的**颜色加深**效果（它对于不同的情况单独进行了颜色设置）。
实现也特别简单，只需要像`<table class="table-hover">`这样，在`<table>`标签加上一个`table-hover`的类。（在未对`<tr>`进行情景颜色设置时，该类依然有效果，只是效果不一样，上面已经说到了，因为它的单独设置，具体请到源码中查看）

也正因为这样，如果你想自定义颜色的话，**除了修改`tr`元素的颜色样式外，在`.table-hover`表格中也要做相应的调整!**


排版的内容到这里就告一段落了，下面进行表单的学习！加油！

参考：

- [慕课网：玩转Bootstrap](http://www.imooc.com/learn/141)
- [Bootstrap中文官网：全局 CSS 样式](http://v3.bootcss.com/css/)
