title: Bootstrap入门笔记之（五）导航条、分页导航
date: 2016-01-30 23:12:50
tags: [Bootstrap]
categories: [Bootstrap]
---

## 导航条

导航条（navbar）和我们在上一个笔记中介绍的导航（nav）相比，就多了一个**“条”**字。其实在Bootstrap框架中他们有着一定的区别。
在导航条(navbar)中有一个背景色、而且导航条可以是纯链接（类似导航），也可以是表单，还有就是表单和导航一起结合等多种形式。它们在移动设备上可以折叠（并且可开可关），且在视口（viewport）宽度增加时逐渐变为水平展开模式。

### 基础导航条

实际上，导航条和导航在外观上的差别并不是那么的大，但是在实际使用中导航条要比导航复杂得多。下面就来实现一个最基础的导航条。

```
<div class="navbar navbar-default" role="navigation"><!--role是为了方便屏幕阅读器理解此处内容-->
    <ul class="nav navbar-nav">
        <li class="active"><a href="#">HTML</a></li>
        <li><a href="#">CSS</a></li>
        <li><a href="#">JavaScript</a></li>
        <li><a href="#">PHP</a></li>
     </ul>
</div>
```
Other more 
可以达到的效果是这样的：

宽屏：
![基础导航条宽](/images/Bootstrap/05-navbar-1.jpg)

窄屏：
![基础导航条窄](/images/Bootstrap/05-navbar-2.jpg)


在制作一个基础导航条时，主要注意以下几点：

1. 首先在制作导航的列表(`<ul class="nav">`)基础上添加类名`.navbar-nav`
2. 在列表外部添加一个容器（div）在这里允许的话**推荐使用**`<nav>`，并且使用类名`.navbar`和`.navbar-default`
3. `.navbar`类的主要功能就是设置左右padding和圆角等效果，通过`.navbar-default`来进行控制导航条的颜色比如还有`.navbar-inverse`。（有兴趣的可以去看看源码）


### 带标题、二级菜单

在Web页面制作中，一般都可以在菜单前面看到有一个标题（文字字号比其它文字稍大一些），其实在Bootstrap框架也为大家做了这方面考虑，其通过`.navbar-header`和`.navbar-brand`来实现，如：
```html
<div class="navbar-header">
    <a href="##" class="navbar-brand">WEB开发</a>
</div>
```

当然也可以用来做logo，[中文官网描述](http://v3.bootcss.com/components/?#navbar-brand-image)，在此不进行详细描述。

二级菜单自然不用多说，在上一篇博客中已经进行了详细说明，若还是不太了解的话，可以再去翻翻我的上一篇博客，我们一起来看看下面这段代码以及能实现的效果：（注意这里使用的是`navbar-inverse`反色的导航条）

```html
<div class="navbar navbar-inverse" role="navigation">
    <div class="navbar-header">
        <a href="##" class="navbar-brand">WEB开发</a>
     </div>
    <ul class="nav navbar-nav">
        <li class="active"><a href="#">HTML</a></li>
        <li><a href="#">CSS</a></li>
        <li class="dropdown" >
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">JavaScript
            <span class="caret"></span></a>
            <ul class="dropdown-menu">
                <li><a href="#">jQuery</a></li>
                <li><a href="#">Vue</a></li>
                <li><a href="#">NodeJS</a></li>
            </ul>
        </li>
        <li ><a href="#">PHP</a></li>
    </ul>
</div>
```

效果如下：

![标题-下拉](/images/Bootstrap/05-navbar-3.jpg)


我们常常在导航条中都能看到搜索表单，比如知乎，新浪微博等等都具有，Bootstrap框架当然不可能缺掉这样的东西。使用方法也非常简单：

在Bootstrap框架中提供s    了一个`.navbar-form`，在`.navbar`容器中放置一个带有`.navbar-form`类名的表单；再添加`.navbar-left`让表单左浮动，更好实现对齐。
在Bootstrap中，还提供了`.navbar-right`样式，让元素在导航条靠右对齐。

把这段代码复制到代码当中看看效果吧：

```html
<form action="##" class="navbar-form navbar-left" rol="search">
    <div class="form-group">
        <input type="text" class="form-control" placeholder="请输入关键词" />
    </div>
    <button type="submit" class="btn btn-default">搜索</button>
</form>
```

### 按钮、文本和链接

除了上面的一些样式之外，bootstrap框架提供了三种其他样式：

1. 导航条中的按钮`navbar-btn`，使不在`<form>`中的按钮在导航条里垂直居中
2. 导航条中的文本`navbar-text`，一般使用`<p>`元素，达到最优的行距
3. 导航条中的普通链接`navbar-link`，非导航的链接，添加这个类，可以有正确的默认颜色与反色设置

但这三种样式在框架中使用时受到一定的限制，需要和`navbar-brand`、`navbar-nav`配合起来使用。而且**对数量也有一定的限制，一般情况在使用一到两个不会有问题，超过两个就会有问题**。

### 固定导航条

有时，我们希望导航条固定在浏览器顶部或底部，Bootstrap为我们方便的提供了两个类来实现这样的样式：

1. `.navbar-fixed-top`：导航条固定在浏览器窗口顶部
2. `.navbar-fixed-bottom`：导航条固定在浏览器窗口底部

使用方法很简单，只需要在制作导航条最外部容器（navbar）上追加对应的类名即可。
```html
<nav class="navbar navbar-default navbar-static-top">
    ...
</nav>
```

这个固定的导航条会**遮住页面上的其它内容**，除非你给`<body>`元素底部设置了`padding`。提示：导航条的**默认高度**是 50px。如：`body { padding-bottom: 70px; }`，当然你也可以使用你自己的值。


## 响应式导航条

在上面的例子中，导航条就仅仅能大屏幕下有一个不错的效果，在屏幕变小的情况下，还**直接把所有的导航项直接展现出来就不适合了**。为了有一个更好的显示效果，响应式的导航条设计也就随之而来。我们先来看看效果，再一步一步分析它！

![响应式导航条](/images/Bootstrap/05-navbar-4.jpg)

窄屏时，点击右边的按钮图标可展开，效果与上面的展开效果除了`active`状态不再溢出容器外，其他基本相同。实现代码如下：

```html
<div class="navbar navbar-default" role="navigation">
    <div class="navbar-header">
        <!-- .navbar-toggle样式用于toggle收缩的内容，即nav-collapse collapse样式所在元素 -->
        <button class="navbar-toggle" type="button" data-toggle="collapse" data-target=".navbar-responsive-collapse">
            <span class="sr-only">Toggle Navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <!-- 确保无论是宽屏还是窄屏，navbar-brand都显示 -->
        <a href="#" class="navbar-brand">WEB开发</a>
    </div>
    <!-- 屏幕宽度小于768px时，div.navbar-responsive-collapse容器里的内容都会隐藏，显示icon-bar图标，当点击icon-bar图标时，再展开。屏幕大于768px时，默认显示。 -->
    <div class="collapse navbar-collapse navbar-responsive-collapse">
        <ul class="nav navbar-nav">
            <li class="active"><a href="#">HTML</a></li>
            <li><a href="#">CSS</a></li>
            <li><a href="#">JavaScript</a></li>
            <li><a href="#">PHP</a></li>
        </ul>
    </div>
</div>
```

分析：

1. 和普通导航条一样，最外层使用`<div class="navbar navbar-default" role="navigation">`容器包裹，主要是`.navbar`和 `.navbar-default`类。
2. 保证在窄屏时**需要折叠的内容必须**包裹在带一个div内，并且为这个div加入`.collapse`、`.navbar-collapse`两个类名。最后为这个div**添加一个class类名或者id名**。
3. 保证在窄屏时要显示的图标样式（固定写法）：
```html
<button class="navbar-toggle" type="button" data-toggle="collapse">
    <span class="sr-only">Toggle Navigation</span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
</button>
```
4.  并为button添加**data-target=".类名/#id名"**，究竞是类名还是id名呢？由**需要折叠的div**来决定。（这里很关键，你可以把上面的代码在这里进行修改，会发现无法展开）


## 分页导航

分页导航几乎在所有的网站都可以看到，好的分页导航可以给用户带来更好额用户体验，还可以方便爬虫在网页中进行搜索。

### 带页码的分页导航



带页码的分页导航，应该是最常见的一种分页导航，特别是在列表页内容很多的时候，会给用户提供带页码的分页导航方式，在Bootstrap中使用的是`ul>li>a`这样的结构，在ul标签上加入`pagination`类：

```html
<ul class="pagination ">
    <li><a href="#">&laquo;第一页</a></li>
    <li><a href="#">6</a></li>
    <li class="active"><a href="#">7</a></li>
    <li><a href="#">8</a></li>
    <li><a href="#">9</a></li>
    <li><a href="#">10</a></li>
    <li class="disabled"><a href="#">最后一页&raquo;</a></li>
</ul> 
```

实现效果如下：

![分页码导航](/images/Bootstrap/05-navbar-5.jpg)

可以看到同样会有`hover`、`active`、`disabled`等等状态，当然它也可以调整大小：在外层容器中的`.pagination`类后，添加`.pagination-lg`让分页导航变大；`.pagination-sm`让分页导航变小：

### 翻页分页导航

其实这种方式，就是看不到具体的页码，只会提供一个**上一页**和**下一页**的按钮。

使用方式很简单，也就是在ul标签上添加`pager`类：

```html
<ul class="pager">
    <li><a href="#">&laquo;上一页</a></li>
    <li><a href="#">下一页&raquo;</a></li>
</ul>
```

它默认是居中显示的，如果我们需要一个居左一个居右显示的话，添加两个样式：`previous`让“上一步”按钮居左；`next`让“下一步”按钮居右。（同样可以使用`disabled`表示禁用状态）

```html
<ul class="pager">
    <li class="previous disabled"><a href="#">&laquo;上一页</a></li>
    <li class="next"><a href="#">下一页&raquo;</a></li>
</ul>
```

## 其他

### 标签

在一些Web页面中常常会添加一个标签用来告诉用户一些额外的信息，比如说在导航上添加了一个新导航项，可能就会加一个“new”标签，来告诉用户。这是新添加的导航项。
在Bootstrap专门将这样的效果提取成为了单独的标签组件。可以使用`<span>`这样的行内标签添加`.label`类来控制大小，再使用情景类来控制高亮显示的颜色如：`label-default`、`label-danger`等等（在原来笔记中说到过这样的情景类，只不过这里需要加上不同的前缀）

![导航条标签](/images/Bootstrap/05-navbar-6.jpg)

### 徽章（角标）

其实和上面的标签效果很大一部分是类似的，一般用作信息提示，例如剩余多少未读信息等等，也就是我们常常能在右上角看到的未读信息提示。在Bootstrap中，把这种效果称作为徽章效果，使用`badge`类来实现。

给链接、导航等元素嵌套 `<span class="badge">` 元素，可以很醒目的展示新的或未读的信息条目。

```html
<a href="#">Inbox <span class="badge">42</span></a>
<button class="btn btn-primary" type="button">
  Messages <span class="badge">4</span>
</button>
```

![导航条角标](/images/Bootstrap/05-navbar-7.jpg)


通过查看源码，我们可以发现Bootstrap同样使用`:empty`伪元素，来设置当没有内容的时候隐藏：

```css
.badge:empty {
    display: none;
}
```

需要注意的是IE8 不支持 `:empty` 选择符，所以不会默认隐藏；

Bootstrap 中的徽章会适配导航元素的激活状态。

```html
<ul class="nav nav-pills" role="tablist">
    <li role="presentation" class="active"><a href="#">Home <span class="badge">42</span></a></li>
    <li role="presentation"><a href="#">Profile</a></li>
    <li role="presentation"><a href="#">Messages <span class="badge">3</span></a></li>
</ul>
```

![导航条角标-适应激活](/images/Bootstrap/05-navbar-8.jpg)


好了《导航条、分页导航》的学习到此就结束了，下面需要学习Bootstrap中其他的一些比较零散的**内置组件**。

继续坚持，加油！


参考：

- [慕课网：玩转Bootstrap](http://www.imooc.com/learn/141)
- [Bootstrap中文官网：全局 CSS 样式](http://v3.bootcss.com/css/)
