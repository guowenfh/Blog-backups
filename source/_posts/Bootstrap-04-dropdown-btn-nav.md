title: Bootstrap入门笔记之（四）菜单、按钮及导航
date: 2016-01-30 01:23:36
tags: [Bootstrap]
categories: [Bootstrap]
---

我们接下来要学习的东西呢，是Bootstrap为我们提供的一些组件，这些组件的使用非常简单，可以方便快捷帮助我们搭建网站，并且能达到一个不错的显示效果。我们最需要注意的就是：**HTML的结构**和bootstrap提供**添加到结构上的类以及属性**。
这些组件的交互功能是依赖于jQuery库实现的，所以还必须引入jQuery.js，且必须在Bootstrap.js之前。正式上线的话直接使用压缩版本就可以了如下：

```html
<script src="../js/jquery-min-1.11.3.js"></script>
<script src="../js/bootstrap.min.js"></script>
```

## 菜单

### 基本用法

在官方文档中，我们看到的下拉菜单组件是这样的：

```html
<div class="dropdown">
    <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
    下拉菜单<span class="caret"></span>
    </button>
    <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
        <li><a href="#">菜单项1</a></li>
        <li><a href="#">菜单项2</a></li>
    </ul>
</div>
```

那么，到底哪一些属性是必须的、用来控制行为的呢？又有哪一部分是起到修饰作用的？

我们来自己简化一下这一段代码：

```html
<div class="dropdown">
    <button class="dropdown-toggle"data-toggle="dropdown">下拉菜单</button>
    <ul class="dropdown-menu" >
        <li>菜单项1</li>
        <li>菜单项2</li>
    </ul>
</div>
```

我们来看看简化前后的对比图：

![下拉菜单（基本用法）](//ws1.sinaimg.cn/large/82d12951gy1fewh4tam3pj20b406oq35.jpg)

在使用Bootstrap框架中的下拉菜单组件时，其结构运用的正确与否非常的重要，如果结构和类名未使用正确，直接影响组件是否能正常运用。经过我们上面的简化，最终可以看到核心要求有以下几点：

1. 使用一个名为`.dropdown`的容器包裹了整个下拉菜单元素，示例中为：`<div class="dropdown"></div>`
2. 使用了一个`<button>`按钮做为父菜单，并且定义类名`.dropdown-toggle`和自定义`data-toggle`属性，且值必须和最外容器类名一致，此示例为：`data-toggle="dropdown"`
3. 下拉菜单项使用一个ul列表，并且定义一个类名为`.dropdown-menu`，此示例为：`<ul class="dropdown-menu">`

也就是说，我们仅仅需要牢记这3个步骤我们就可以使下拉菜单生效，`<button>`内的`<span>`标签，也仅仅是用来进行图标的展示，让菜单更加清晰。不过虽然如此，我个人建议在**实际的使用过程**中，把Bootstrap框架中的下拉菜单的**其它属性也一并加上**，这样更加友好的为不同的客户**如：屏幕阅读器**提供了一个优质的体验。

那么这些是怎么起作用的呢？

查看CSS源码可以看到`.dropdown-menu`有一个`display:none`，所以下拉列表项默认隐藏的；我们继续打开chrome开发者工具（F12），可以看到每一次在列表项展现出来时，`.dropdown`类后还增加了一个`.open`的类；不用多说想肯定就是这个类在起作用，我们再继续回到CSS源码中去可以看到：
```css
.open > .dropdown-menu {
  display: block;
}
```
看到这里也应该不用过多说明了，添加了这个`.open`类时，`.dropdown-menu`自然的就显示出来了。

### 下拉菜单修饰

#### 下拉分隔线

在Bootstrap框架中的下拉菜单还提供了下拉分隔线，假设下拉菜单有两个组，那么组与组之间可以通过添加一个**空**的`<li>`，并且给这个`<li>`添加类名`.divider`来实现添加下拉分隔线的功能。`<li class="divider"></li>`对应的样式代码：

```css
.dropdown-menu .divider {
  height: 1px;
  margin: 9px 0;
  overflow: hidden;
  background-color: #e5e5e5;
}
```

####  菜单标题

上一小节讲解通过添加`divider`可以将下拉菜单分组，为了让这个分组更明显，还可以给每个组添加一个头部（标题）：`<li  class="dropdown-header">第一部分菜单头部</li>`。

从源码中比较关键的两个点是：标题的字体颜色是：`color: #777;`，还有内填充`padding: 3px 20px;`

#### 对齐方式

Bootstrap框架中下拉菜单**默认是左对齐**也就是添加`.dropdown-menu-left `类所能达到的效果，如果你想让下拉菜单**相对于父容器右对齐**时，可以在`.dropdown-menu`上（也就是你的菜单项的ul）添加一个`.pull-right`或者`.dropdown-menu-right`类名，如下所示：`<ul class="dropdown-menu pull-right" >`
源码如下：

```css
.dropdown-menu.pull-right,
.dropdown-menu-right {/*两个类自选*/
  right: 0;
  left: auto;
}
```

当然你只进行这样的设置的话，可能还会有一些奇怪的情况出现，比如列表项跑到屏幕最右边去了，所以同时一定要为`.dropdown`添加`float:left`样式。

```css
.dropdown{
  float: left;
}
```

![下拉菜单（右对齐）](//ws1.sinaimg.cn/large/82d12951gy1fewh4tmwxwj20al0azdg1.jpg)


#### 菜单项状态

下拉菜单项的默认的状态（不用设置）有悬浮状态（`:hover`）和焦点状态（`:focus`）：（包括下面提到的状态都必须在li中包含a标签才有- -）

下拉菜单项除了上面两种状态，还有**当前状态**（`.active`）和**禁用状态**（`.disabled`）。这两种状态使用方法只需要在对应的菜单项上添加对应的类名如：`<li class="disabled"><a href="#">桃</a></li>`

我们可以实现下面这样的效果：

![下拉菜单（右对齐）](//ws1.sinaimg.cn/large/82d12951gy1fewh4t7z1rj208j052dfw.jpg)



## 按钮

我们在[《Bootstrap入门笔记之（二）表单》](//guowenfh.github.io/2016/01/18/Bootstrap-02-form/)中，已经了解过了Bootstrap中按钮的使用，在这里我们继续进行一些扩展！

### 按钮组及工具栏

>单个按钮在Web页面中的运用有时候并不能满足我们的业务需求，常常会看到将多个按钮组合在一起使用，比如富文本编辑器里的一组小图标按钮等。这个时候我们就会需要用到按钮组

对于结构方面，非常的简单。使用一个名为`.btn-group`的容器，把多个按钮放到这个容器中。如：

```html
<div class="btn-group">
    <button type="button" class="btn btn-default">向左</button>
    <button type="button" class="btn btn-danger">中间</button>
    <button type="button" class="btn btn-default">向右</button>
</div>
```

如何转化成工具栏呢？只需要再用一个`.btn-toolbar`的内容，将我们的`.btn-group`再进行一次包裹，同时，我们还可以使用`.btn-group-lg`大按钮组、`.btn-group-xs`:超小按钮组这一系列的类添加到`.btn-group`容器来进行对一组按钮进行大小控制如下：

```html
<div class= "btn-toolbar">
    <!-- …… -->
    <div class= "btn-group ">
        <button type="button" class="btn btn-default">向左</button>
        <button type="button" class="btn btn-danger">中间</button>
        <button type="button" class="btn btn-default">向右</button>
    </div>
    <div class= "btn-group btn-group-sm">
        <button type="button" class="btn btn-default">向左</button>
        <button type="button" class="btn btn-danger">中间</button>
        <button type="button" class="btn btn-default">向右</button>
    </div>
    <!-- …… -->
</div>
```

上面两段代码效果如下：

![按钮组及工具栏](//ws1.sinaimg.cn/large/82d12951gy1fewh4t9v13j20hw0403yo.jpg)

### 嵌套分组

这里的嵌套分组其实就是在分组按钮中嵌套了一个下拉菜单。使用的时候，只需要把当初制作下拉菜单的`.dropdown`的容器换成`.btn-group`，并且和普通的按钮放在同一级。如下所示：

```html
<div class="btn-group">
    <button class="btn btn-default" type="button">首页</button>
    <div class="btn-group">
        <button class="btn btn-default dropdown-toggle" data-toggle="dropdown" type="button">产品展示<span class="caret"></span></button>
        <ul class="dropdown-menu">
            <li><a href="##">公司简介</a></li>
            <li><a href="##">企业文化</a></li>
            <li><a href="##">组织结构</a></li>
            <li><a href="##">客服服务</a></li>
        </ul>
    </div>
    <button class="btn btn-default" type="button">关于</button>
</div>
```

当然我们还可以从**水平按钮组**变成**垂直分组**，只需要在水平分组的最外层容器的类名`.btn-group`替换成`.btn-group-vertical`，就可以实现垂直分组的效果。

**按钮的向下向上三角形**

我们在下拉菜单和嵌套分组都都看到了一个按钮的向下三角形，我们是通过在`<button>`标签中添加一个`<span>`标签元素，并且命名为`caret`，这个三角形完全是通过CSS代码来实现的：

```css
.caret {
    display: inline-block;
    width: 0;
    height: 0;
    margin-left: 2px;
    vertical-align: middle;
    border-top: 4px solid;
    border-right: 4px solid transparent;
    border-left: 4px solid transparent;
}
```

有的时候我们的下拉菜单会**向上弹起**，这个时候我们的**三角方向需要朝上**显示，实现方法：需要在`.btn-group`类上追加`dropup`类名（这也是做向上弹起下拉菜单要用的类名）。

```
.dropup .caret{
    content: "";
    border-top: 0;/*可以看到这里top与bottom的变化*/
    border-bottom: 4px solid;
}
```

那么现在就来对比一下，上面代码以及类的添加可以达到的不同效果：


![嵌套分组、垂直、向上展开](//ws1.sinaimg.cn/large/82d12951gy1fewh4tck8ej20le06t3yy.jpg)



## 导航

导航对于一位前端开发人来说眼应该都不陌生。可以说，每一个网页里面都会有导航的存在，便于用户查找网站所提供的各项功能服务。那么如何使用Bootstrap框架制作各式各样的导航呢？

### 基础样式

Bootstrap框架中制作导航条主要通过`.nav`样式。默认的`.nav`样式**不提供**默认的导航样式，必须附加另外一个样式才会有效，比如`nav-tabs`、`nav-pills`之类。

```html
<ul class="nav nav-tabs">
    <li><a href="#">HTML5</a></li>
    <li><a href="#">CSS3</a></li>
    <li><a href="#">JavaScript</a></li>
</ul>
```

当然他们同样也有**当前状态**（`.active`）和**禁用状态**（`.disabled`），我们给第一个导航添加当前状态，最后一个导航添加禁用状态，实现效果如下：


![导航-基础样式](//ws1.sinaimg.cn/large/82d12951gy1fewh4tcyc7j208w06oq38.jpg)

### 修饰

#### 垂直堆叠的导航

在实际运用当中，除了水平导航之外，还有垂直导航，就类似前面介绍的垂直排列按钮一样。制作垂直堆叠导航只需要在**`.nav-pills`**的基础上添加一个`.nav-stacked`类名即可，同时，我们和下拉菜单一样，同样可以使用组之间的分割线例，只需要在导航项之间添加`<li class=”nav-divider”></li>`,如：

```html
<ul class="nav nav-pills nav-stacked">
    <li class="active"><a href="#">HTML5</a></li>
    <li><a href="#">CSS3</a></li>
    <li class="nav-divider"></li>
    <li class="disabled"><a href="#">JavaScript</a></li>
</ul>
```

复制到浏览器中看看效果吧！

你应该已经发现了在垂直导航中，每一个导航项都是占**文字居左**，占100%的父容器宽度的，如果你想有响应式的效果，应该和栅格系统一起使用，另外为什么不试试使用`nav-tabs`来实现垂直导航呢？看看效果，你就会明白为什么不使用了。

**自适应导航**

自适应导航和前面制作自适应按钮是一样的，不过更换了一个类名，`.nav-justified`。当然他需要和`.nav-tabs`或者`.nav-pills`配合在一起使用。 它是响应式的，在宽度足够时，给多个导航项，均分空间；在达到一个临界值（768px）时，它会和垂直导航一样：每一项都充满父容器的宽度，不同的是，他的文字是**居中显示**的

#### 导航中加下拉菜单（二级导航）

前面介绍的都是使用制作一级导航，但很多时候，在Web页面常常会用到二级导航的效果。
在Bootstrap框架中制作二级导航就更容易了。只需要将li当作父容器，使用类名`.dropdown`，同时在**`li`中嵌套另一个列表`ul`
**

```html
<ul class="nav nav-pills">
    <li ><a href="#">HTML5</a></li>
    <li><a href="#">CSS3</a></li>
    <li class="dropdown">
        <a href="##" class="dropdown-toggle" data-toggle="dropdown">JavaScript<span class="caret"></span></a>
        <ul class="dropdown-menu">
            <li><a href="##">JQuery</a></li>
            <li><a href="##">Vue</a></li>
            …
       </ul>
</ul>
```

这里的话不进行太多的讲解，与上面的嵌套按钮效果一致。

#### 面包屑式导航

面包屑(Breadcrumb)一般用于导航，主要是起的作用是告诉用户现在所处页面的位置（**当前位置**）。一般在文章、博客、列表处用的比较多，需要用到`.breadcrumb`类。

```
<ol class="breadcrumb">
    <li><a href="#">个人首页</a></li>
    <li><a href="#">标签</a></li>
    <li class="active">Bootstrap</li>
</ol>
```

可以实现的效果：

![导航-面包屑](//ws1.sinaimg.cn/large/82d12951gy1fewh6ziqq9j208102hq2q.jpg)

是不是很简洁明了呢？



好了我们对于《 菜单、按钮及导航》的学习到这里呢先就告一段落了，下一章节应该就是对于**导航条、分页导航**的学习了。继续加油！


参考：

- [慕课网：玩转Bootstrap](http://www.imooc.com/learn/141)
- [Bootstrap中文官网：全局 CSS 样式](http://v3.bootcss.com/css/)
