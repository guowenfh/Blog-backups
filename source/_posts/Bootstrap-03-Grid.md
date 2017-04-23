title: Bootstrap入门笔记之（三）栅格系统
date: 2016-01-28 00:49:03
tags: [Bootstrap]
categories: [Bootstrap]

---

## 实现原理

栅格系统是Bootstrap中的核心，正是因为栅格系统的存在，Bootstrap才能有着如此强大的响应式布局方案。下面是官方文档中的解说：

> Bootstrap 提供了一套响应式、移动设备优先的流式栅格系统，随着屏幕或视口（viewport）尺寸的增加，系统会自动分为最多12列。包含了用于简单的布局选项的预定义类，也包含了用于生成更多语义布局的功能强大的混合类。

我们来理解一下这一段话，可以发现其中最重要的部分就是**移动设备优先**，那么什么是移动设备优先呢？

Bootstrap的基础CSS代码**默认从小屏幕设备**（比如移动设备、平板电脑）开始，然后使用**媒体查询扩展到大屏幕设备**（比如笔记本电脑、台式电脑）上的组件和网格。

有着如下策略：

1. 内容：决定什么是最重要的。
2. 布局：优先设计更小的宽度。
3. 渐进增强：随着屏幕大小增加而添加元素。


## 工作原理

1. 数据行（`.row`）必须包含在容器`.container`（固定宽度）或`.container-fluid`（100%宽度）中，以便为其赋予合适的排列（aligment）和内填充（padding）。如：
```html
<div class="container"><!-- 水平居中，两边有margin，最小屏幕时，充满父元素 -->
    <div class="row"></div>
</div>
<!-- 或者 -->
<div class="container-fluid"><!-- 默认一直充满整个父元素 -->
    <div class="row"></div>
</div>
```
2. 在数据行（`.row`)中可以添加列（column），但列数之和不能超过平分的总列数（在超过时，多余部分会换行显示），默认12。（使用Less或者Sass可以进行自定义设置）如：
```html
<div class="container">
    <div class="row">
        <div class="col-md-2"></div>
        <div class="col-md-6"></div>
        <div class="col-md-4"></div>
```
3.  页面上的**具体内容**应当放置于列（column）内，并且**只有列**（column）可以作为数据行`.row`容器的**直接子元素**。
4. 预定义的网格类，比如 `.row` 和 `.col-xs-4`，可用于快速创建网格布局。
5. 栅格系统中的列是通过指定**1到12**的值来表示其跨越的范围。例如，三个等宽的列可以使用三个`.col-xs-4`来创建。


**注意事项：**

正如上面在注释部分所展现的一样的`.container`（固定宽度）是固定宽度的布局方式。通过查看源码，在查看`.container`类的时候我们会发现，它的宽度是响应式的：（如下）

```css
.container {
  padding-right: 15px;
  padding-left: 15px;
  margin-right: auto;margin-left: auto;
}
@media (min-width: 768px) {
  .container {
    width: 750px;
  }
}
@media (min-width: 992px) {
  .container {
    width: 970px;
  }
}
/*........*/
```

从上面的css代码可以看到，该类默认为整个父元素的宽度（最小屏幕），但是在大屏幕下有着不同的宽度，并且在不同宽度下左右margin会同时增加或减少（水平居中）。

**`.container-fluid`类就和`.container`的默认情况一样，为100%宽度。**（CSS代码一样）

除此之外

从源码中我们还可以发现，除了有左右margin外，还可以看到该类是有着左右填充（padding）存在的。

如果我们继续查看源码，可以发现数据行`.row`中的每一个列也有着左右填充（padding）的存在，如下：

```css
.col-md-1, .col-lg-12 /*......*/{
  position: relative;
  min-height: 1px;
  padding-right: 15px;
  padding-left: 15px;
}
```

看到这里，大家应该都能想到会有什么样的情况出现！我们在第一个和最后一个列因为**双填充**的存在，**实际上对于内容的隔离**已经到了**30px**。我们需要怎么消除影响呢？

Bootstrap是通过`.rows`上的外边距（margin）取负`margin-left: -15px;margin-right: -15px;`，表示第一列和最后一列的行偏移，用来抵消第一个列的左内距和最后一列的右内距。


## 基本用法

一图胜千言，通过下表可以详细查看 Bootstrap 的栅格系统是如何在多种屏幕设备上工作的。使用方法我想应该不用再多说了，已经有提到过，直接一起来看看区别吧。（图片扒自[Bootstrap中文官网](//v3.bootcss.com/css/#grid-less)）

![栅格参数](//ws1.sinaimg.cn/large/82d12951gy1fewhvpnhn2j20oa0b9q3u.jpg)

通过源码可以发现，如下：
```css
.col-md-1/*......*/{ float: left;}/*所有的列都是默认向左浮动的*/
.col-md-1 {
    width: 8.33333333%;
}
.col-md-2 {
    width: 16.66666667%;
}
/*.....*/
.col-md-12 {
    width: 100%;
}
```

从这些CSS代码也就不难发现，Bootstrap中每一列所占的宽度，以及为何在列数设置超过12时，超过部分会换行显示了。

在下面所有的示例中每一列的背景颜色与边框的效果由如下CSS代码控制：

```css
[class *= col-]{
    background-color: #eee;
    border: 1px solid #ccc;
}
```

### 基础

那么我们就来看看一些示例吧，下面这种方式是最基本的用法：

```html
<div class="container">
    <div class="row">
        <div class="col-md-6">.col-md-6</div>
        <div class="col-md-6">.col-md-6</div>
    </div>
    <div class="row">
        <div class="col-md-4">.col-md-4</div>
        <div class="col-md-4">.col-md-4</div>
        <div class="col-md-4">.col-md-4</div>
    </div>
    <div class="row">
        <div class="col-md-2">.col-md-2</div>
        <div class="col-md-6">.col-md-6</div>
        <div class="col-md-4">.col-md-4</div>
    </div>
</div>
```
实现的效果如下：

![网格基本用法](//ws1.sinaimg.cn/large/82d12951gy1fewhvotkb7j20re02ddfu.jpg)

Bootstrap作为一个响应式框架当然不会只有那么简单的功能，我们继续往下走吧！

### 列偏移

在某些情况下，我们不希望相邻的列紧靠在一起，如果你希望不通过额外的margin或其他的手段来实现的话，Bootstrap内置为我们提供了列偏移（offset），这一系列的类来帮助我们实现想要的效果。

只需要给需要偏移的列元素上添加类名`col-md-offset-*`(**星号代表要偏移的列组合数**)，那么具有这个类名的列就会向右偏移。
这些类实际是通过使用 `*` 选择器为当前元素增加了左侧的边距（margin）。例如：在列元素中添加`.col-md-offset-6` 类将 `.col-md-6`元素向右侧偏移了6个列（column）的宽度。

现在我们的代码是这样的：

```html
<div class="container">
    <div class="row">
        <div class="col-md-2 ">col-md-8 </div>
        <div class="col-md-3 col-md-offset-2">col-md-4 col-md-offset-2</div>
        <div class="col-md-4 col-md-offset-1">col-md-4 col-md-offset-1</div>
    </div>
    <p><br></p>
    <div class="row">
        <div class="col-md-4 ">col-md-4 </div>
        <div class="col-md-3 col-md-offset-4">col-md-3 col-md-offset-4</div>
        <div class="col-md-4 col-md-offset-4">col-md-4 col-md-offset-4</div>
    </div>
</div>
```

可以实现的效果如下：

![网格基本用法](//ws1.sinaimg.cn/large/82d12951gy1fewhvpk4whj20rd035q30.jpg)

从实现的效果我们就能发现一些东西，注意**第二段的显示效果与代码**，从那里我们可以发现：使用`col-md-offset-*`对列进行向右偏移时，要保证列与偏移列的总数不超过12，不然会致列断行显示。
其实原因也很简单：因为该类是对于列设置`margin-left`，并且我们在上面的源码展示中，也可以看有每一列都有着`float:left`的属性，从这些地方我们就不难发现在（偏移+列宽）超过12时，为何会换行显示了


### 列排序

列排序其实就是改变列的方向（顺序），就是改变左右浮动，并且设置浮动的距离。在Bootstrap框架的网格系统中是通过添加类名`col-md-push-*`和`col-md-pull-*` (和上面一样，星号代表移动的列组合数)。

Bootstrap仅通过设置left和right来实现定位效果。通过查看源码，我们可以看到基本设置比较简单，如下：

```css
.col-md-pull-12 {
    right: 100%;
}
/*...*/
.col-md-push-1 {
    left: 8.33333333%;
}
.col-md-push-0 {
    left: auto;
}
```

还是继续看看我们的实际效果吧！代码如下

```html
<div class="container">
    <div class="row">
        <div class="col-md-4 col-md-push-8">.col-md-4  col-md-push-8 </div>
        <div class="col-md-8 col-md-pull-4">.col-md-8  col-md-pull-4 </div>
    </div>
    <div class="row">
        <div class="col-md-4 ">.col-md-4  默认</div>
        <div class="col-md-8 ">.col-md-8  默认</div>
    </div>
</div>
```

![网格基本用法](//ws1.sinaimg.cn/large/82d12951gy1fewhvpivx0j20wy01ojrf.jpg)

我们可以发现列的位置已经发生了改变


### 列嵌套

Bootstrap框架的网格系统还支持列的嵌套。你可以在一个列中添加一个或者多个行（`.row`）容器，然后在这个行容器中插入列（像前面介绍的一样使用列）。但在列容器中的行容器（`.row`），宽度为100%时，就是当前外部列的宽度。（其实就是在列中嵌套多个列，下面会有实际效果展示）

注意：被嵌套的行（`.row`）所包含的列（column）的个数不能超过12（其实，没有要求你必须占满12列 -_- ）。

我们现在有这样一个需求：

1. 创建一个8-4列网格。（备注：以中屏md（970px）为例）。
2. 在第一个8列网格中插入8-4列网格。
3. 在第二个4列网格中插入9-3列网格。

效果如下：

![网格基本用法](//ws1.sinaimg.cn/large/82d12951gy1fewhvpmvnqj20wy01pwep.jpg)

该如何实现呢？

```html
<div class="container">
    <div class="row">
        <div class="col-md-8">
            我的里面嵌套了一个网格
            <div class="row">
                <div class="col-md-8">col-md-8</div>
                <div class="col-md-4">col-md-4</div>
            </div>
        </div>
        <div class="col-md-4">
            我的里面嵌套了一个网格
            <div class="row">
                <div class="col-md-9">col-md-9</div>
                <div class="col-md-3">col-md-3</div>
            </div>
        </div>
    </div>
</div>
```

是不是很简单呢？当然为了完全实现和效果图一样的展示，我们还需要对CSS进行一些添加，主要是对于嵌套的添加 一些高亮的样式：

```css
[class *= col-] [class *= col-] {
    background-color: #f36;
    border:1px dashed #fff;
    color: #fff;
}
```

栅格系统的基础里面方面呢，上面已经说的差不多了，看上去十分简单不是吗？

要想在我们的实际项目中使页面在不同屏幕中达到一个最佳的显示效果，还需要我们对于栅格系统进行的灵活的运用！

下面就一起来进行一些实例的研究吧！


## 实例：

在上面我们已经实现了过最简单的从堆叠到水平排列的布局了，非常简单，我们只使用了单一的一组 `.col-md-*`栅格类，就创建了一个基本的栅格系统。
它在手机和平板设备上一开始是堆叠在一起的（超小屏幕到小屏幕这一范围），在桌面（中等）屏幕设备上变为水平排列

###  移动设备和桌面屏幕

是否不希望在小屏幕设备上所有列都堆叠在一起？那就使用针对超小屏幕和中等屏幕设备所定义的类吧，即 `.col-xs-*` 和 `.col-md-*`。
我把Bootstrap中文官网的代码稍微做了一点修改。主要是将中间的`.col-md-4`和`.col-xs-6`两个类调换了一下位置（CSS层叠，说到这应该就不需要做更多的说明了吧。），代码如下：

```html
<div class="container">
    <div class="row">
        <div class="col-xs-12 col-md-8">.col-xs-12 .col-md-8</div>
        <div class="col-xs-6 col-md-4">.col-xs-6 .col-md-4</div>
    </div>
    <div class="row">
        <div class="col-md-4 col-xs-6">.col-md-4 .col-xs-6</div>
        <div class="col-md-4 col-xs-6">.col-md-4 .col-xs-6</div>
        <div class="col-md-4 col-xs-6">.col-md-4 .col-xs-6</div>
    </div>
    <div class="row">
        <div class="col-xs-6">.col-xs-6</div>
        <div class="col-xs-6">.col-xs-6</div>
    </div>
</div>
```

宽屏显示效果如下：
![移动设备和桌面屏幕-桌面](/images/Boo//ws1.sinaimg.cn/large/82d12951gy1fewhvp57zgj20rd02dglo.jpg)
窄屏显示效果如下：
![移动设备和桌面屏幕-移动](//ws1.sinaimg.cn/large/82d12951gy1fewhvovi4xj20lf03gmx9.jpg)

其实从上面代码和实际的显示效果，我们就可以看出一些问题来：

1. 在宽屏时，使用`col-md-*`的布局方式，在窄屏时使用`col-xs-*`布局
2. 响应式的列重置与列中设置的类的排列顺序无关。
3. 响应式列重置，在一个`.row`仍然存在列超过12时，`col-xs-6`*3=18。**多余列**的元素将作为一个**整体单元**被另起一行排列。


在了解了上面的这些问题之后是不是明了了一些呢？

举一反三，我们再来看一个更加复杂的例子

### 手机、平板、桌面

在上面案例的基础上，通过增加使用针对平板设备的 `.col-sm-*` 类，我们来创建更加动态和强大的布局吧。

```html
<div class="container">
    <div class="row">
        <div class="col-xs-12 col-sm-6 col-md-8">.col-xs-12 .col-sm-6 .col-md-8</div>
        <div class="col-xs-6 col-sm-12 col-md-4">.col-xs-6 .col-sm-12 .col-md-4</div>
    </div>
    <div class="row">
        <div class="col-xs-6 col-sm-4">.col-xs-6 .col-sm-4</div>
        <div class="col-xs-6 col-sm-4">.col-xs-6 .col-sm-4</div>
        <div class="col-xs-6 col-sm-4">.col-xs-6 .col-sm-4</div>
    </div>
</div>
```

这一次会比原来的情况更加复杂，一个会有3种情况出现：

宽屏：
![桌面](//ws1.sinaimg.cn/large/82d12951gy1fewhvovi4xj20lf03gmx9.jpg)
中屏：
![平板](//ws1.sinaimg.cn/large/82d12951gy1fewhvoxn1mj20rf01l3yj.jpg)
窄屏：
![手机](//ws1.sinaimg.cn/large/82d12951gy1fewhvoxnbqj20kl02laa3.jpg)


然后我们从这一部分代码与实际效果，再加上上面做的一点小总结，对比之后又能发现一些问题：

1. Bootstrap中对于栅格系统的展示总是**优先展示****对应屏幕大小**范围的类（`.col-xs-6 `和`.col-sm-4`等等）。
2. 在为不同大小屏幕，添加多个类一定要记住在**基本用法**处的表格中的内容，它决定了在不同大小屏幕下的显示与排列。
3. 若还要继续添加在超大屏幕下的特定显示效果，只需要对列再添加一个`.col-lg-*`的类，就能达到你所想要的

### 响应式列重置

除了在上面讲到的内容，在官方文档中还提到了**响应式列重置**，在我看来其实就是以下几点（或者说在这样的条件下可以使用）：

1. 需要对于不同屏幕大小进行处理，添加多个对于列宽进行处理的类。
2. 在缩小屏幕时，同一数据行（`.row`）针对小屏幕设置的类的宽度（`.col-sm-*`等等）加起来超过12，余下部分进行换行显示。
3. 在不同列的高度，有比较大的差异。可以在**未超过12**与**超过12**的部分，两者之间添加下面这样的代码：`<div class="clearfix visible-xs-block"></div>`。（`.visible-xs-block`这一系列的类，会在后面进行讲解）
 它最主要的作用是：它是响应式的，会占据未超过12的部分的宽高，且只有在发生列换行显示（堆叠）才进行设置。
4. 为了便于大家理解，我加一句：把上面那段代码复制到数据行`.row`容器内的最末端，它所占据的宽高和`.row`是一样的。（内容中有多段这样的代码的时候不成立，原因大家应该都能看出来了）


说到这里呢，栅格系统的部分，基本告一段落了，我们即将开始对于**菜单、按钮及导航**，这一部分的组件进行学习


参考：

- [慕课网：玩转Bootstrap](http://www.imooc.com/learn/141)
- [Bootstrap中文官网：全局 CSS 样式](//v3.bootcss.com/css/)
